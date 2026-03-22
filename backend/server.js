const express = require('express');
const cors = require('cors');
const Groq = require('groq-sdk');
const OpenAI = require('openai');
const multer = require('multer');
const pdf = require('pdf-parse');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 3000;

// Load CV data from JSON file
let cvData = null;
try {
  const cvPath = path.join(__dirname, '..', 'cv-data.json');
  const cvContent = fs.readFileSync(cvPath, 'utf8');
  cvData = JSON.parse(cvContent);
  console.log('✓ CV data loaded successfully');
} catch (error) {
  console.warn('⚠ CV data file not found or invalid. Running without embedded CV context.');
}

// Initialize Groq client with API key from environment variable
const groq = new Groq({
  apiKey: process.env.GROQ_API_KEY
});

// Initialize OpenAI client with API key from environment variable
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

// Log which AI services are available
console.log(`✓ Groq API: ${process.env.GROQ_API_KEY ? 'Ready' : 'Not configured'}`);
console.log(`✓ OpenAI API: ${process.env.OPENAI_API_KEY ? 'Ready' : 'Not configured'}`);

// Store the latest uploaded document text to include in AI context
let uploadedDocumentText = '';

// Conversation memory: store up to 20 most recent messages per session
let conversationHistory = [];
const MAX_HISTORY = 20;

// Document tracking: store metadata about uploaded documents
let uploadedDocuments = [];

// Session tracking for personalization
let userProfile = {
  role: null, // 'teacher', 'student', 'collaborator', or null
  lastUpdate: Date.now()
};

const upload = multer({ storage: multer.memoryStorage() });

app.use(cors());
app.use(express.json());

// Function to detect user role from conversation context
function detectUserRole(messages) {
  const recentText = messages.slice(-5).map(m => m.content).join(' ').toLowerCase();
  
  if (/\b(teach|classroom|student|lesson|course|grading|curriculum)\b/.test(recentText)) {
    return 'teacher';
  }
  if (/\b(learn|study|assignment|exam|understand|help me|question)\b/.test(recentText)) {
    return 'student';
  }
  if (/\b(collaborat|partner|project|implement|develop|train)\b/.test(recentText)) {
    return 'collaborator';
  }
  return null;
}

// Domain-specific system prompts with comprehensive CV data
function getSystemPrompt(userRole, documentContext) {
  // Build comprehensive CV context
  let cvContext = '';
  if (cvData) {
    cvContext = `
VERIFIED BACKGROUND FACTS (Reference these in your answers):
- NAME: Tuyishime Honore | DOB: 28 Feb 2002 | Age: 22 | Location: Eastern Province, Rwanda | Phone: +250 791 684 429
- CURRENT ROLE 1: Teacher at Rukara Model School of Sciences and Mathematics (Sept 2024 - Present) teaching STEM subjects
- CURRENT ROLE 2: ICT Trainer with PISQUARE/Edify (Nov 2025 - Present) - Have trained 100+ primary teachers in ICT integration
- CURRENT ROLE 3: Student at ULK (2024-Present) studying Bachelor of Education in Computer Science & Physics Education (CSP)
- TEACHING EXPERIENCE: Currently teaching STEM at Rukara; trained 100+ teachers through PISQUARE; practical experience with classroom integration of technology
- EDUCATION: A2 Diploma in Teaching from TTC Matimba (2020-2023); Primary Teaching Residency from TTC De La Salle (2023-2024); Currently pursuing university degree
- CERTIFICATIONS: Primary Teaching Residency Certificate, EdTech Integration Training (REB & World Bank), CPD-ITMS ICT Training, PISQUARE Trainer Certification, Microsoft Course
- TECH SKILLS: HTML5, CSS3, JavaScript, PHP, MySQL, Laravel, Google Classroom, MS Teams, Kahoot, Scratch, Turtle Art, video production
- LANGUAGES: English (Excellent), Kinyarwanda (Excellent), French (Good)
- PASSION: Education technology, teaching methodology, helping teachers integrate tech into classrooms
- MISSION: To bridge the gap between traditional and technology-enabled teaching by creating practical solutions that enhance learning`;
  }

  const systemPrompt = `YOU ARE TUYISHIME HONORE - Respond as Honore speaking directly to the visitor.

**YOUR RESPONSE FORMAT (SHOW YOUR THINKING):**

When answering questions, ALWAYS show your thinking process like this:

---THINKING---
(Reflect here on what they're asking and what from your experience is relevant)
Example: "They're asking about teaching experiences... I should mention Rukara where I teach STEM, and PISQUARE where I've trained teachers. This connects to my mission of bridging traditional and technology-enabled teaching."
---END THINKING---

(Then give your authentic answer based on that reflection)

---

**YOUR INSTRUCTIONS (FOLLOW THESE STRICTLY):**

1. SHOW YOUR REASONING - Always start with a visible thinking section (in the format above). Reflect on what the person is asking and which real experiences from your background apply.

2. REFERENCE YOUR REAL EXPERIENCE - Use specific facts from your verified background. When asked about teaching, mention Rukara specifically. When asked about training, mention PISQUARE and the 100+ teachers. Use real examples.

3. ANSWER WITH YOUR ACTUAL CREDENTIALS - You're not just someone interested in education; you ARE a trained teacher (TTC certified), you ARE currently teaching STEM at Rukara, you ARE training teachers through PISQUARE. Say this directly when relevant.

4. SPEAK NATURALLY AFTER THINKING - Use "I" and speak like Honore in conversation. Natural flowing paragraphs. Warm, genuine tone. This is your actual answer, not more thinking.

5. BE SPECIFIC WITH EXAMPLES - Don't give generic answers. For example: "At Rukara I work with STEM, and I've found that when students use practical tools like Scratch or GeoGebra, they understand abstract concepts better because they see them in action."

6. REFERENCE DOCUMENTS IF SHARED - If the user uploaded a document, use information from it and mention it.

7. STAY TRUE TO YOUR MISSION - Your mission is to bridge traditional and technology-enabled teaching. Your passion is helping teachers grow. Use real examples from your work.

BACKGROUND TO REFERENCE:
${cvContext}

${documentContext}

Now respond as Honore would - showing your thinking first, then answering with real experience, specific examples, and authentic voice.`;

  return systemPrompt;
}

// Function to extract relevant context from uploaded document based on question
function extractRelevantContext(documentText, userMessage) {
  if (!documentText) return '';
  
  const keywords = userMessage.toLowerCase().split(/\s+/).filter(w => w.length > 3);
  const lines = documentText.split('\n');
  
  const relevantLines = lines.filter(line => {
    const lineLower = line.toLowerCase();
    return keywords.some(keyword => lineLower.includes(keyword));
  });
  
  if (relevantLines.length > 0) {
    return relevantLines.slice(0, 10).join('\n').substring(0, 1500);
  }
  return documentText.substring(0, 1000);
}

// Add message to conversation history
function addToHistory(role, content) {
  conversationHistory.push({
    role,
    content,
    timestamp: Date.now()
  });
  
  // Keep only the most recent messages
  if (conversationHistory.length > MAX_HISTORY) {
    conversationHistory = conversationHistory.slice(-MAX_HISTORY);
  }
}

// Function to get response from AI (tries Groq first, then OpenAI)
async function getDualAIResponse(messages, systemPrompt) {
  let lastError = null;

  // Try Groq first
  if (process.env.GROQ_API_KEY) {
    try {
      console.log('🟢 Attempting Groq API...');
      const chatCompletion = await groq.chat.completions.create({
        messages: [
          {
            role: 'system',
            content: systemPrompt
          },
          ...messages
        ],
        model: 'llama3-8b-8192',
        temperature: 0.5,
        max_tokens: 500
      });
      const response = chatCompletion.choices[0]?.message?.content;
      if (response) {
        console.log('✅ Groq API succeeded');
        return { response, source: 'groq' };
      }
    } catch (error) {
      lastError = error;
      console.warn('⚠️ Groq API failed:', error.message);
    }
  }

  // Fall back to OpenAI
  if (process.env.OPENAI_API_KEY) {
    try {
      console.log('🟠 Attempting OpenAI API...');
      const chatCompletion = await openai.chat.completions.create({
        messages: [
          {
            role: 'system',
            content: systemPrompt
          },
          ...messages
        ],
        model: 'gpt-4o-mini', // Using lighter model for efficiency, change to gpt-4o or gpt-4-turbo for better quality
        temperature: 0.5,
        max_tokens: 500
      });
      const response = chatCompletion.choices[0]?.message?.content;
      if (response) {
        console.log('✅ OpenAI API succeeded');
        return { response, source: 'openai' };
      }
    } catch (error) {
      lastError = error;
      console.warn('⚠️ OpenAI API failed:', error.message);
    }
  }

  // If both fail, throw error
  throw lastError || new Error('No AI service available. Please check API keys.');
}

app.post('/chat', async (req, res) => {
  const { message, userRole } = req.body;
  if (!message) {
    return res.status(400).json({ error: 'Message is required' });
  }

  try {
    // Update user profile if role is provided
    if (userRole) {
      userProfile.role = userRole;
      userProfile.lastUpdate = Date.now();
    }

    // Add user message to history
    addToHistory('user', message);

    // Detect role if not explicitly provided
    const detectedRole = userRole || detectUserRole(conversationHistory);
    if (detectedRole && !userProfile.role) {
      userProfile.role = detectedRole;
    }

    const relevantContext = extractRelevantContext(uploadedDocumentText, message);
    
    const documentContextNote = relevantContext 
      ? `\n\n[DOCUMENT REFERENCE AVAILABLE]\nThe user has shared: ${uploadedDocuments.map(d => d.name).join(', ')}\n\nRelevant sections:\n${relevantContext}`
      : '';

    const systemPrompt = getSystemPrompt(userProfile.role, documentContextNote);

    // Build messages array with conversation history
    const messages = conversationHistory.map(msg => ({
      role: msg.role,
      content: msg.content
    }));

    // Ensure system message is included
    const chatMessages = messages.slice(-10); // Use last 10 messages for context window

    // Use dual AI with fallback
    const { response, source } = await getDualAIResponse(chatMessages, systemPrompt);
    
    // Add assistant response to history
    addToHistory('assistant', response);

    res.json({ 
      response,
      detectedRole: userProfile.role,
      documentsUsed: uploadedDocuments.length > 0,
      aiSource: source // Show which AI was used
    });
  } catch (error) {
    console.error('Error calling AI services:', error);
    res.status(500).json({ error: 'Failed to get response from AI. Please ensure API keys are configured.' });
  }
});

// New endpoint to get conversation summary or reset
app.get('/conversation-info', (req, res) => {
  res.json({
    messageCount: conversationHistory.length,
    userRole: userProfile.role,
    documentsLoaded: uploadedDocuments.length,
    documents: uploadedDocuments.map(d => ({ name: d.name, uploadedAt: d.uploadedAt }))
  });
});

app.post('/reset-conversation', (req, res) => {
  conversationHistory = [];
  res.json({ message: 'Conversation history cleared. Starting fresh!' });
});

app.post('/upload', upload.single('document'), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: 'No file uploaded' });
  }

  try {
    const buffer = req.file.buffer;
    let text = '';
    const fileName = req.file.originalname;
    const fileType = req.file.mimetype;
    const fileSize = req.file.size;

    if (req.file.mimetype === 'application/pdf') {
      const data = await pdf(buffer);
      text = data.text;
    } else {
      text = buffer.toString('utf8');
    }

    // Store more content (up to 15000 chars) for better context extraction
    uploadedDocumentText = text.substring(0, 15000);

    // Track document metadata
    const docMetadata = {
      name: fileName,
      type: fileType,
      size: fileSize,
      uploadedAt: new Date().toISOString(),
      charCount: uploadedDocumentText.length,
      usageCount: 0 // Track how many times this doc is referenced in answers
    };
    
    // Replace if document with same name already exists, otherwise add
    const existingIndex = uploadedDocuments.findIndex(d => d.name === fileName);
    if (existingIndex >= 0) {
      uploadedDocuments[existingIndex] = docMetadata;
    } else {
      uploadedDocuments.push(docMetadata);
    }

    // Log the upload for debugging
    console.log(`Document uploaded: ${fileName} (${fileType}), extracted ${uploadedDocumentText.length} characters`);
    console.log(`Total documents in memory: ${uploadedDocuments.length}`);

    res.json({ 
      success: true, 
      message: `Document "${fileName}" successfully loaded. I'll use it for context when answering your questions.`,
      charCount: uploadedDocumentText.length,
      totalDocuments: uploadedDocuments.length,
      documents: uploadedDocuments
    });
  } catch (error) {
    console.error('Upload error:', error);
    res.status(500).json({ error: 'Failed to process document' });
  }
});

app.post('/set-role', (req, res) => {
  const { role } = req.body;
  const validRoles = ['teacher', 'student', 'collaborator', null];
  
  if (!validRoles.includes(role)) {
    return res.status(400).json({ error: 'Invalid role. Use: teacher, student, collaborator, or null' });
  }
  
  userProfile.role = role;
  userProfile.lastUpdate = Date.now();
  
  let roleDescription = 'General visitor';
  if (role === 'teacher') roleDescription = 'Educator/Teacher';
  if (role === 'student') roleDescription = 'Student/Learner';
  if (role === 'collaborator') roleDescription = 'Collaborator/Partner';
  
  res.json({ 
    message: `Role set to: ${roleDescription}`,
    role: userProfile.role
  });
});

// Serve CV data for reference
app.get('/cv-data', (req, res) => {
  if (cvData) {
    res.json(cvData);
  } else {
    res.status(404).json({ error: 'CV data not available' });
  }
});

// Get CV summary
app.get('/cv-summary', (req, res) => {
  if (cvData) {
    res.json({
      name: cvData.personalInfo.fullName,
      summary: cvData.summary,
      mission: cvData.mission,
      currentRoles: [
        `Teacher at Rukara Model School (Sept 2024-Present)`,
        `ICT Trainer with PISQUARE/Edify (Nov 2025-Present)`
      ],
      education: `Bachelor's in Computer Science & Physics Education (ULK, 2024-Present)`,
      keyStrengths: cvData.keyStrengths,
      contact: {
        email: cvData.personalInfo.email,
        phone: cvData.personalInfo.phone
      }
    });
  } else {
    res.status(404).json({ error: 'CV data not available' });
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});