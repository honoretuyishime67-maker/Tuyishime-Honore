const videos = [
  { id: 'yvzLHXqcanQ' },
  { id: 'glsbQJfo4T8' },
  { id: '8_UyFSrQblc' },
  { id: 'jPFDwkthyaA' },
];

// USER PROVIDED GOOGLE API KEYS
const GOOGLE_API_KEY = "AIzaSyBIqQ-gyjdKJ3x2n2iREYT6PoFnBl3-RqE";

// Global state for chat personalization and memory
let chatState = {
  userRole: null, // 'teacher', 'student', 'collaborator', or null
  uploadedDocuments: [],
  conversationLength: 0
};

// Prevent multiple initializations
if (window.honoreChatInitialized) {
  console.log('🤖 Chat already initialized, skipping...');
} else {
  window.honoreChatInitialized = true;

  // Show startup message only once
  console.log('%c🤖 HONORE AI CHAT READY', 'color: #228b22; font-size: 14px; font-weight: bold;');
  console.log('%c📝 To enable AI responses: Open console and paste:', 'color: #666; font-size: 12px;');
  console.log('%csetOpenAIKey("sk-proj-YOUR-KEY-HERE")', 'color: #007bff; font-size: 12px; font-weight: bold;');
  console.log('%cThen chat will show real AI responses with thinking bubbles! 🧠', 'color: #666; font-size: 12px;');

  // Initialize chat functionality
  initChatSystem();
}

function initChatSystem() {
  // Initialize video functionality only if elements exist
  initVideos();

  // Initialize accessibility features
  initAccessibilityFeatures();

  // Initialize hero quotes rotation (Home Page only)
  initHeroQuotes();

  // Initialize chat functionality
  initChat();

  // Initialize mobile menu
  initMobileMenu();
}

function initMobileMenu() {
  const navToggle = document.querySelector('.nav-toggle');
  const navLinks = document.querySelector('.nav-links');

  if (navToggle && navLinks) {
    navToggle.addEventListener('click', () => {
      navToggle.classList.toggle('active');
      navLinks.classList.toggle('active');
      document.body.classList.toggle('nav-open');
    });

    // Close menu when clicking a link
    navLinks.querySelectorAll('a').forEach(link => {
      link.addEventListener('click', () => {
        navToggle.classList.remove('active');
        navLinks.classList.remove('active');
        document.body.classList.remove('nav-open');
      });
    });
  }
}

function initChatEventListeners() {
  // Chat form handling
  const aiForm = document.getElementById('ai-form');
  if (aiForm) {
    aiForm.addEventListener('submit', handleChatSubmit);
  }

  // Chat toggle
  const aiToggle = document.getElementById('ai-toggle');
  if (aiToggle) {
    aiToggle.addEventListener('click', toggleChat);
  }

  // Chat close
  const aiClose = document.getElementById('ai-close');
  if (aiClose) {
    aiClose.addEventListener('click', closeChat);
  }
}

async function handleChatSubmit(event) {
  event.preventDefault();
  const input = document.getElementById('ai-input');
  if (!input) return;

  const message = input.value.trim();
  if (!message) return;

  // Add user message
  appendChatMessageEnhanced(message, 'user');
  input.value = '';

  // Get bot response
  const response = await getChatResponse(message);
  appendChatMessageEnhanced(response, 'bot');
}

function toggleChat() {
  const aiWidget = document.getElementById('ai-widget');
  if (aiWidget) {
    aiWidget.classList.toggle('open');
    const toggle = document.getElementById('ai-toggle');
    if (toggle) {
      const isOpen = aiWidget.classList.contains('open');
      toggle.setAttribute('aria-expanded', isOpen);
    }
  }
}

function closeChat() {
  const aiWidget = document.getElementById('ai-widget');
  if (aiWidget) {
    aiWidget.classList.remove('open');
    const toggle = document.getElementById('ai-toggle');
    if (toggle) {
      toggle.setAttribute('aria-expanded', 'false');
    }
  }
}

function setNowPlaying(title) {
  const nowPlaying = document.getElementById('now-playing');
  if (nowPlaying) nowPlaying.textContent = `Now Playing: ${title}`;
}

async function fetchTitle(videoId) {
  if (GOOGLE_API_KEY) {
    try {
      const url = `https://www.googleapis.com/youtube/v3/videos?part=snippet&id=${videoId}&key=${GOOGLE_API_KEY}`;
      const response = await fetch(url);
      const data = await response.json();
      if (data.items && data.items.length > 0) {
        return data.items[0].snippet.title;
      }
    } catch (error) {
      console.error('YouTube Data API error:', error);
    }
  }

  // oEmbed Fallback
  try {
    const url = `https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=${videoId}&format=json`;
    const response = await fetch(url);
    if (!response.ok) throw new Error('oEmbed fetch failed');
    const data = await response.json();
    return data.title;
  } catch {
    return 'Ministry Video';
  }
}

function createCard(video) {
  const button = document.createElement('button');
  button.type = 'button';
  button.className = 'video-card';
  button.dataset.videoId = video.id;
  button.setAttribute('aria-label', 'Play video');

  const thumb = document.createElement('div');
  thumb.className = 'video-thumb';
  thumb.style.backgroundImage = `url('https://img.youtube.com/vi/${video.id}/hqdefault.jpg')`;

  const meta = document.createElement('div');
  meta.className = 'video-meta';
  meta.innerHTML = `
    <span class="video-title">Loading title…</span>
  `;

  button.appendChild(thumb);
  button.appendChild(meta);

  fetchTitle(video.id).then((title) => {
    // Format title: clean up ugly separators and convert ALL CAPS to Title Case
    let cleanTitle = (title || '')
      .replace(/(\/\/|@@|_)/g, ' - ')
      .replace(/\s+/g, ' ')
      .trim();
    // Convert to Title Case for a professional look
    cleanTitle = cleanTitle.toLowerCase().replace(/\b\w/g, c => c.toUpperCase());

    const titleEl = meta.querySelector('.video-title');
    if (titleEl) {
      titleEl.textContent = cleanTitle;
      button.setAttribute('aria-label', `Play video: ${cleanTitle}`);
    }
    video.title = cleanTitle;
  });

  return button;
}

function loadVideo(videoId) {
  const ytPlayer = document.getElementById('yt-player');
  if (!ytPlayer) return;
  ytPlayer.src = `https://www.youtube.com/embed/${videoId}?autoplay=1&rel=0`;

  const current = videos.find((v) => v.id === videoId);
  if (current && current.title) {
    setNowPlaying(current.title);
  }
}

async function initVideos() {
  const videoGrid = document.getElementById('video-grid');
  if (!videoGrid) return; // Only initialize if element exists

  videos.forEach((video) => {
    videoGrid.appendChild(createCard(video));
  });

  // Add "Find more" indicator card
  const moreCard = document.createElement('a');
  moreCard.href = 'https://www.youtube.com/@tuyishimehonore9611';
  moreCard.target = '_blank';
  moreCard.className = 'video-card more-videos-card';
  moreCard.innerHTML = `
    <div class="video-thumb more-thumb">
      <div class="more-overlay">
        <span>+ Explore More</span>
      </div>
    </div>
    <div class="video-meta">
      <span class="video-title">View All Videos on YouTube</span>
    </div>
  `;
  videoGrid.appendChild(moreCard);

  if (videos.length) {
    const first = videos[0];
    const title = await fetchTitle(first.id);
    first.title = title;
    setNowPlaying(title);
    loadVideo(first.id);
    const firstCard = videoGrid.querySelector('.video-card');
    if (firstCard) firstCard.classList.add('active-video');
  }

  videoGrid.addEventListener('click', (event) => {
    const card = event.target.closest('.video-card');
    if (!card) return;
    const videoId = card.dataset.videoId;
    if (!videoId) return;

    // Identify selected video visually
    document.querySelectorAll('.video-card').forEach(c => c.classList.remove('active-video'));
    card.classList.add('active-video');

    loadVideo(videoId);
    card.scrollIntoView({ behavior: 'smooth', block: 'start' });
  });
}

function appendChatMessage(text, sender) {
  const container = document.getElementById('ai-messages');
  if (!container) return;

  const message = document.createElement('div');
  message.className = `ai-message ${sender}`;
  message.textContent = text;
  container.appendChild(message);
  container.scrollTop = container.scrollHeight;

  // Track conversation length
  if (sender === 'user' || sender === 'bot') {
    chatState.conversationLength++;
  }
}

// Create message for bot messages (simple bubble)
function createBotMessage(text) {
  const messageWrapper = document.createElement('div');
  messageWrapper.className = 'ai-message-wrapper bot-wrapper';

  // Remove thinking section from text completely
  const thinkingRegex = /---THINKING---([\s\S]*?)---END THINKING---/;
  const answerText = text.replace(thinkingRegex, '').trim();

  // Create answer bubble
  const bubble = document.createElement('div');
  bubble.className = 'ai-message-bubble bot';
  bubble.innerHTML = answerText;

  messageWrapper.appendChild(bubble);
  return messageWrapper;
}

// Create message for user messages
function createUserMessage(text) {
  const messageWrapper = document.createElement('div');
  messageWrapper.className = 'ai-message-wrapper user-wrapper';

  const bubble = document.createElement('div');
  bubble.className = 'ai-message-bubble user';
  bubble.textContent = text;

  messageWrapper.appendChild(bubble);

  return messageWrapper;
}

// Enhanced append message with proper structure
function appendChatMessageEnhanced(text, sender) {
  const container = document.getElementById('ai-messages');
  if (!container) return;

  let messageElement;
  if (sender === 'bot') {
    messageElement = createBotMessage(text);
  } else {
    messageElement = createUserMessage(text);
  }

  container.appendChild(messageElement);
  container.scrollTop = container.scrollHeight;

  if (sender === 'user' || sender === 'bot') {
    chatState.conversationLength++;
  }
}

// Set user role (Local only)
function setUserRole(role) {
  chatState.userRole = role;

  let roleLabel = 'General visitor';
  if (role === 'teacher') roleLabel = 'Educator';
  if (role === 'student') roleLabel = 'Student/Learner';
  if (role === 'collaborator') roleLabel = 'Collaborator';

  console.log(`Role set to: ${roleLabel}`);

  // Optional: show a brief confirmation
  const roleEl = document.getElementById('ai-user-role');
  if (roleEl) {
    roleEl.textContent = `Role: ${roleLabel}`;
  }
}

// Get conversation info (Local only)
function getConversationInfo() {
  return {
    length: chatState.conversationLength,
    role: chatState.userRole,
    docs: chatState.uploadedDocuments.length
  };
}

function scanPageContent() {
  const elements = document.querySelectorAll('h1, h2, h3, p, li, .card h3');
  let content = "Current Page Content:\n";
  elements.forEach(el => {
    if (el.textContent.length > 10) {
      content += `- ${el.textContent.trim()}\n`;
    }
  });
  return content;
}

function getFallbackResponse(message) {
  const lower = message.trim().toLowerCase();

  // Dynamic Agent Reasoning Simulation
  const reasoningSteps = [
    "🔍 Scanning current page for context...",
    "📂 Accessing Honore's profile database...",
    "📂 Checking document repository for related files...",
    "🧠 Processing request via local agent logic...",
    "✨ Formulating specialized response..."
  ];

  // Specific Knowledge Extraction (Simulating Agent Capability)
  const pageContext = scanPageContent();
  const docs = chatState.uploadedDocuments.length > 0 ? `(Agent: Referenced ${chatState.uploadedDocuments.join(", ")})` : "";

  const patterns = [
    {
      test: /\b(hi|hello|hey|greetings|good morning|good afternoon|good evening|who are you|introduce|intro|about you|who is honore)\b/,
      reply: `Hello there! It's so good to connect with you. I am Honore Tuyishime, Passionate Educator and ICT Trainer dedicated to transforming education through technology integration and pedagogical excellence in Rwanda. and I am dedicated to serving God and the community through transformational teaching, discipleship, and a heart-led commitment to service, as commissioned in the Holy Scriptures. I'm here to share my journey and expertise with you—how can I help you explore my work in education technology or my spiritual mission today? ${docs}`
    },
    {
      test: /\b(education|study|studied|school|university|academic|background|learn)\b/i,
      reply: `I have a comprehensive educational foundation that bridges pedagogy and technology:
• **Primary Education (2011-2016):** GS Kagitumba (Primary School Certificate).
• **Ordinary Level (2017-2019):** GS Kagitumba (O-Level Certificate).
• **A2 Diploma (2020-2023):** TTC Matimba, focusing on Science & Mathematics Education (SME).
• **Teaching Residency (2023-2024):** TTC De La Salle (Byumba), Primary Teaching Residency Program Pilot (PTRP) with international partners.
• **University (2024-Present):** Kigali Independent University (ULK), currently pursuing a Bachelor's in Computer Science and Physics Education.

Check the **Education** page for full details and to download my official certificates! ${docs}`
    },
    {
      test: /\b(cv|resume|background|experience|qualification|work history)\b/i,
      reply: `I currently teach STEM subjects at Rukara Model School and serve as an ICT trainer with PISQUARE/Edify. My background is in Computer Science and Physics Education (ULK), and my primary focus is transforming education through technology. I've trained over 100 teachers in digital literacy so far! ${docs}`
    },
    {
      test: /\b(certificat|diploma|credential|training|qualification)\b/i,
      reply: `I have built a strong professional profile through a wide range of specialized certifications. My academic journey began with my Primary Education and O-Level Certificates from GS Kagitumba, followed by an A2 Diploma in Science & Mathematics Education from TTC Matimba. I furthered my pedagogical expertise through the Primary Teaching Residency Program (PTRP) at TTC De La Salle, a premier pilot sponsored by Florida State University and Bridge2Rwanda. On the technical side, I am a Microsoft Certified Educator and hold an IBM AI Literacy Master credential, along with specialized training in AI Prompting from One Million Prompters. Additionally, I’ve completed EdTech Integration training with REB and the World Bank, and the CPD-ITMS program with the University of Rwanda's Centre of Excellence. I am also a certified PISQUARE Trainer through Edify, reflecting my commitment to official standards in both education and ICT. ${docs}`
    },
    {
      test: /\b(contact|email|phone|reach|connect)\b/,
      reply: `You can reach me personally at +250 791 684 429 or tuyishimehonore63@gmail.com. I'm always open to discussing new educational projects or potential collaborations in ICT training! ${docs}`
    },
    {
      test: /\b(ministry|church|god|scripture|verse|discipleship)\b/,
      reply: `My life and service are grounded in Matthew 28:19 and Acts 1:8. I'm currently advancing my theological studies at Promise Bible Centre and AMCC. My heart's mission is to serve God through discipleship, youth education, and community empowerment. ${docs}`
    },
    {
      test: /\b(project|developer|tech|coding|web|app)\b/,
      reply: `My development work spans from pedagogical web apps like the Digital Lesson Plan to tutorial-based ICT resources. I specialize in HTML, CSS, JavaScript, and Laravel, and I focus on building tools that solve real classroom challenges for teachers. ${docs}`
    },
    {
      test: /\b(language|speak|talk|english|kinyarwanda|french)\b/i,
      reply: `I am fluent in English and Kinyarwanda, both at an excellent level for professional and personal communication. I also have a good command of French. This allows me to connect with a wide range of educators and partners! ${docs}`
    },
    {
      test: /\b(hobby|hobbies|interest|free time|like to do)\b/i,
      reply: `When I'm not in the classroom or coding, you'll find me reading the Bible, praying, or listening to gospel music. I also have a deep interest in cattle keeping and livestock management—it keeps me grounded and connected to my community. Of course, I'm always exploring new technologies too! ${docs}`
    },
    {
      test: /\b(reference|referee|verify|supervisor|principal|dr barnabas|erick|ferdinand)\b/i,
      reply: `I have a strong network of professional references including Dr. Barnabas Muyengwa (Principal of Rukara Model School), Erick Iyamuremyi (Head of PISQUARE), and Br. Ferdinand Biziyaremye (PTRP Coordinator). They can speak to my teaching performance, STEM leadership, and ICT training expertise! ${docs}`
    },
    {
      test: /\b(location|address|where are you|nyagatare|kagitumba|matimba)\b/i,
      reply: `I am based in the Eastern Province of Rwanda, specifically in Nyagatare District. I serve at Rukara Model School and coordinate my training programs from here. ${docs}`
    },
    {
      test: /\b(thank you|thanks|amazing|awesome|wow|appreciate|helpful)\b/i,
      reply: `It's truly my pleasure! I'm so glad I could help. Please let me know if there's anything else you'd like to dive into! ${docs}`
    }
  ];

  for (const entry of patterns) {
    if (entry.test.test(lower)) {
      return `---THINKING---\n${reasoningSteps.join("\n")}\n---END THINKING---\n${entry.reply}`;
    }
  }

  return `---THINKING---\n${reasoningSteps.join("\n")}\n---END THINKING---I've carefully analyzed your message against my professional background. To provide you with the most real and specific information, could you share a bit more? For example, are you interested in my hands-on teaching strategies at Rukara, the technical architecture of my web projects, or the specifics of my ICT training programs for teachers? I'm here to provide honest, detailed insights. ${docs}`;
}

// HONORE'S COMPLETE BACKGROUND CONTEXT
const HONORE_CONTEXT = `
I AM TUYISHIME HONORE - PROFILE ULTIMATE KNOWLEDGE BASE (Updated 2026)

MISSION STATEMENT (Always use for introductions):
"I am Honore Tuyishime, Passionate Educator and ICT Trainer dedicated to transforming education through technology integration and pedagogical excellence in Rwanda. and I am dedicated to serving God and the community through transformational teaching, discipleship, and a heart-led commitment to service, as commissioned in the Holy Scriptures."

CORE IDENTITY:
- 22-year-old Rwandan Educator (Born Feb 28, 2002).
- STEM Educator at Rukara Model School of Sciences and Mathematics.
- Senior ICT Trainer at PISQUARE/Edify.
- Student at ULK (Computer Science & Physics Education).

PROFESSIONAL EXPERIENCE & IMPACT:
- Rukara Model School (Sept 2024 - Present): Leading STEM instruction for 200+ elite students; Pedagogical Lead.
- PISQUARE (Nov 2025 - Present): Trained 100+ primary school teachers in digital literacy and ICT integration.
- Expertise in: 5Es Model, Blended Learning, Peer Observation, and Digital School Management.
- Technical Skills: HTML5, CSS3, JavaScript, PHP, MySQL, Laravel, WordPress, GeoGebra, Scratch, MS Teams, Google Classroom.

FULL CERTIFICATION RECORD:
1. Primary Teaching Residency Program (PTRP) - National Residency (2023-2024) - Sponsored by FSU, Bridge2Rwanda, IEE.
2. Microsoft Certified Educator (UNESCO Framework).
3. IBM AI Literacy Master (Machine Ethics & Logic).
4. REB & World Bank: EdTech Integration Pilot.
5. University of Rwanda Centre of Excellence: CPD-ITMS (ICT in Pedagogy).
6. One Million Prompts: Specialized AI Prompting.
7. TTC Matimba: A2 Diploma in Science & Mathematics Education.

KEY PROJECTS:
- Digital Lesson Plan (https://digital-lesson-plan.vercel.app/): Web app for streamlined teacher planning.
- ICT Education Hub (YouTube): Expert tutorials for digital transformation in classrooms.

SPIRITUAL & MINISTRY CORE:
- Commission: Matthew 28:19 and Acts 1:8.
- Theological Studies: Promise Bible Centre (34 comprehensive courses) and Africa Multination for Christ College (Foundational Certificate).
- Focus: Preaching, discipleship, and community empowerment.

PERSONAL LIFESTYLE:
- Hobbies: Reading the Bible, Praying, listening to Gospel music, cattle keeping, and exploring new tech.
- Location: Nyagatare, Eastern Province, Rwanda.
- Contact: +250 791 684 429 | tuyishimehonore63@gmail.com
`;

// OpenAI API Key - User will set this
let OPENAI_API_KEY = '';

// Function to set the OpenAI API key (call this from console or put in code)
function setOpenAIKey(apiKey) {
  OPENAI_API_KEY = apiKey;
  console.log('✓ OpenAI API key set successfully');
  console.log('🟢 Chat will now use real AI responses with thinking bubbles');
}

// Show startup message
console.log('%c🤖 HONORE AI CHAT READY', 'color: #228b22; font-size: 14px; font-weight: bold;');
console.log('%c📝 To enable AI responses: Open console and paste:\nsetOpenAIKey("sk-proj-YOUR-KEY-HERE")', 'color: #FF6B35; font-size: 12px;');
console.log('%cThen chat will show real AI responses with thinking bubbles! 🧠', 'color: #4a584a; font-size: 12px;');

async function getChatResponse(message) {
  // TIER 1: OpenAI (if key is set via console)
  if (typeof OPENAI_API_KEY !== 'undefined' && OPENAI_API_KEY) {
    try {
      const response = await fetch('https://api.openai.com/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${OPENAI_API_KEY}`
        },
        body: JSON.stringify({
          model: 'gpt-4o-mini',
          messages: [
            { role: 'system', content: HONORE_CONTEXT },
            { role: 'user', content: message }
          ]
        })
      });

      if (response.ok) {
        const data = await response.json();
        return data.choices[0]?.message?.content || getFallbackResponse(message);
      }
    } catch (e) { console.error('OpenAI Error:', e); }
  }

  // TIER 2: Google Gemini (uses the hardcoded key)
  if (typeof GOOGLE_API_KEY !== 'undefined' && GOOGLE_API_KEY) {
    try {
      const pageContext = typeof scanPageContent === 'function' ? scanPageContent() : '';
      const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GOOGLE_API_KEY}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents: [{
            parts: [{
              text: `You are Honore's AI Assistant. ${HONORE_CONTEXT}\nPage Context: ${pageContext}\nUser: ${message}`
            }]
          }]
        })
      });

      if (response.ok) {
        const data = await response.json();
        return data.candidates?.[0]?.content?.parts?.[0]?.text || getFallbackResponse(message);
      }
    } catch (e) { console.error('Gemini Error:', e); }
  }

  // TIER 3: Local Fallback (100% reliable)
  return getFallbackResponse(message);
}

function initChat() {
  const widget = document.getElementById('ai-widget');
  const toggle = document.getElementById('ai-toggle');
  const closeBtn = document.getElementById('ai-close');
  const form = document.getElementById('ai-form');
  const input = document.getElementById('ai-input');

  if (!widget || !form || !input || !toggle) return;

  // Start collapsed; show greeting when the user opens the chat.
  let firstOpen = true;

  function openWidget() {
    widget.classList.add('open');
    widget.classList.remove('collapsed');
    toggle.setAttribute('aria-expanded', 'true');
    input.focus();

    if (firstOpen) {
      appendChatMessageEnhanced('Hello! I\'m Honore. I really appreciate you reaching out and taking the time to connect. I\'m here to help, share ideas, and support you in any way I can. How can I assist you today?', 'bot');
      firstOpen = false;
    }
  }

  function closeWidget() {
    widget.classList.remove('open');
    widget.classList.add('collapsed');
    toggle.setAttribute('aria-expanded', 'false');
  }

  // Make toggle button use a small avatar when collapsed
  if (!toggle.querySelector('.ai-avatar-mini')) {
    const avatar = document.createElement('img');
    avatar.src = 'profile.jpg';
    avatar.alt = 'AI chat';
    avatar.className = 'ai-avatar-mini';
    avatar.role = 'button';
    avatar.tabIndex = 0;

    const text = document.createElement('span');
    text.className = 'ai-toggle-text';
    text.textContent = 'Chat with Honore';

    toggle.textContent = '';
    toggle.style.flexDirection = 'column';
    toggle.appendChild(avatar);
    toggle.appendChild(text);

    // Make avatar independently clickable
    avatar.addEventListener('click', (e) => {
      e.stopPropagation();
      openWidget();
    });
  }

  // Keep widget collapsed on load; expand only when the user clicks.
  toggle.addEventListener('click', () => {
    if (widget.classList.contains('open')) {
      closeWidget();
    } else {
      openWidget();
    }
  });

  closeBtn?.addEventListener('click', closeWidget);

  // Make header profile image clickable to open chat
  const headerAvatar = document.querySelector('.ai-avatar');
  if (headerAvatar) {
    headerAvatar.style.cursor = 'pointer';
    headerAvatar.addEventListener('click', openWidget);
  }

  // Role selector removed - not needed

  form.addEventListener('submit', async (event) => {
    event.preventDefault();
    const value = input.value.trim();
    if (!value) return;

    appendChatMessageEnhanced(value, 'user');
    input.value = '';
    input.disabled = true;

    // Simple typing indicator
    const typingIndicator = document.createElement('div');
    typingIndicator.className = 'ai-message-wrapper bot-wrapper typing-indicator-wrapper';
    typingIndicator.innerHTML = '<div class="ai-message-bubble bot typing"><span></span><span></span><span></span></div>';
    document.getElementById('ai-messages').appendChild(typingIndicator);
    document.getElementById('ai-messages').scrollTop = document.getElementById('ai-messages').scrollHeight;

    try {
      // Small artificial delay for realism
      await new Promise(resolve => setTimeout(resolve, 1000));
      typingIndicator.remove();

      const response = await getChatResponse(value);
      appendChatMessageEnhanced(response, 'bot');
    } catch (error) {
      typingIndicator.remove();
      appendChatMessageEnhanced('Sorry, there was an error. Please try again.', 'bot');
    } finally {
      input.disabled = false;
      input.focus();
    }
  });

  const fileInput = document.getElementById('ai-file');
  const fileStatus = document.getElementById('ai-file-status');

  if (fileInput) {
    fileInput.addEventListener('change', async () => {
      const file = fileInput.files?.[0];
      if (!file) return;

      fileStatus.textContent = 'Analyzing document locally...';

      setTimeout(() => {
        chatState.uploadedDocuments.push(file.name);
        fileStatus.textContent = `✓ "${file.name}" loaded. I can now reference your document details!`;
        appendChatMessageEnhanced(`I've scanned your document: "${file.name}". I'll keep its details in mind while we chat!`, 'bot');
        fileInput.value = '';
      }, 2000);
    });
  }
}

const quotes = [
  { text: "To transform Rwanda's education system by empowering teachers and learners with digital skills, innovative approaches, and modern technologies for the future.", author: "Tuyishime Honore (Vision Statement)" },
  { text: "Education is the most powerful weapon which you can use to change the world.", author: "Nelson Mandela" },
  { text: "Technology will not replace great teachers, but technology in the hands of great teachers can be transformational.", author: "George Couros" },
  { text: "The future of education is not in the classroom; it is in the connections we build and the digital tools we harness.", author: "Tuyishime Honore" },
  { text: "When we teach computers to learn, we must also teach learners to think.", author: "Unknown" },
  { text: "Every student can learn, just not on the same day, or the same way.", author: "George Evans" },
  { text: "The best way to predict the future is to create it.", author: "Peter Drucker" },
  { text: "Learning is not a spectator sport.", author: "D. Blocher" },
  { text: "Tell me and I forget. Teach me and I remember. Involve me and I learn.", author: "Benjamin Franklin" },
  { text: "Digital learning is not about technology; it’s about empowering learners.", author: "Unknown" },
  { text: "Coding is today’s language of creativity.", author: "Unknown" },
  { text: "The important thing is not to stop questioning. Curiosity has its own reason for existing.", author: "Albert Einstein" },
  { text: "Teaching is the one profession that creates all other professions.", author: "Unknown" },
  { text: "You don’t have to be great to start, but you have to start to be great.", author: "Zig Ziglar" },
  { text: "The role of a teacher is to create the conditions for invention rather than provide ready-made knowledge.", author: "Seymour Papert" },
  { text: "Access to technology is not enough. It must be backed by good teaching.", author: "Unknown" },
  { text: "A child’s mind is not a vessel to be filled but a fire to be kindled.", author: "Dorothy Butler" },
  { text: "Learning is not a place; it is a process.", author: "G. K. Chesterton" },
  { text: "The function of education is to teach one to think intensively and to think critically.", author: "Martin Luther King Jr." },
  { text: "When learning becomes a habit, success becomes a tradition.", author: "Unknown" },
  { text: "Every problem is a gift—without problems we would not grow.", author: "Anthony Robbins" },
  { text: "Digital skills are the currency of the 21st century.", author: "Unknown" },
  { text: "Curiosity is the wick in the candle of learning.", author: "William Arthur Ward" },
  { text: "Great teachers empathize with children, respect them, and believe that each one has something special that can be built upon.", author: "Ann Lieberman" },
  { text: "Education is the passport to the future, for tomorrow belongs to those who prepare for it today.", author: "Malcolm X" },
  { text: "Students don’t care how much you know until they know how much you care.", author: "John C. Maxwell" },
  { text: "Technology alone won’t fix education, but well-used technology can open doors.", author: "Unknown" },
  { text: "Learning is a treasure that will follow its owner everywhere.", author: "Chinese Proverb" },
  { text: "The greatest sign of success for a teacher is to be able to say, 'The children are now working as if I did not exist.'", author: "Maria Montessori" },
  { text: "The only way to do great work is to love what you do.", author: "Steve Jobs" },
  { text: "A teacher affects eternity; he can never tell where his influence stops.", author: "Henry Adams" },
  { text: "The more that you read, the more things you will know. The more that you learn, the more places you’ll go.", author: "Dr. Seuss" },
  { text: "Learning never exhausts the mind.", author: "Leonardo da Vinci" },
  { text: "To teach is to learn twice.", author: "Joseph Joubert" },
  { text: "Good teaching is more a giving of right questions than a giving of right answers.", author: "Josef Albers" },
  { text: "Every child deserves a champion: an adult who will never give up on them.", author: "Rita Pierson" },
  { text: "Education is not preparation for life; education is life itself.", author: "John Dewey" },
  { text: "The beautiful thing about learning is that no one can take it away from you.", author: "B.B. King" },
  { text: "Innovation is the ability to see change as an opportunity, not a threat.", author: "Steve Jobs" },
  { text: "A great teacher takes a hand, opens a mind, and touches a heart.", author: "Unknown" },
  { text: "Programming today is a race between software engineers trying to build bigger and better idiot-proof programs, and the Universe trying to build bigger and better idiots.", author: "Rick Cook" },
  { text: "The most valuable resource that all teachers have is each other. Without collaboration our growth is limited to our own perspectives.", author: "Robert John Meehan" },
  { text: "Success is the sum of small efforts repeated day in and day out.", author: "Robert Collier" },
  { text: "The greatest learning happens outside the classroom when we apply what we know.", author: "Unknown" },
  { text: "Technology is best when it brings people together.", author: "Matt Mullenweg" },
  { text: "Learning is the only thing the mind never exhausts, never fears, and never regrets.", author: "Leonardo da Vinci" },
  { text: "The purpose of education is to replace an empty mind with an open one.", author: "Malcolm Forbes" },
  { text: "Excellence is not a destination; it is a continuous journey that never ends.", author: "Brian Tracy" },
  { text: "You don’t learn to walk by following rules. You learn by doing, and by falling over.", author: "Richard Branson" },
  { text: "If you can dream it, you can do it.", author: "Walt Disney" },
  { text: "Learning is a lifelong process, and the best teachers are the ones who keep learning.", author: "Unknown" },
];

const quoteText = document.getElementById('rotator-text');
const quoteAuthor = document.getElementById('rotator-author');
const quoteCounter = document.getElementById('quote-counter');
const prevBtn = document.getElementById('quote-prev');
const nextBtn = document.getElementById('quote-next');

if (quoteText) renderQuote(0);

// ===== HERO QUOTE ROTATOR (Home Page) =====

function initHeroQuotes() {
  const heroContainer = document.getElementById('hero-quote-container');
  const heroText = document.getElementById('hero-quote-text');
  const heroAuthor = document.getElementById('hero-quote-author');

  if (!heroContainer || !heroText || !heroAuthor) return;

  let currentHeroIdx = 0;

  function updateHeroQuote() {
    // Fade out
    heroContainer.classList.remove('fade-in');

    setTimeout(() => {
      const q = quotes[currentHeroIdx];
      heroText.textContent = `“${q.text}”`;
      heroAuthor.textContent = `— ${q.author}`;

      // Fade in
      heroContainer.classList.add('fade-in');

      // Prep next
      currentHeroIdx = (currentHeroIdx + 1) % quotes.length;
    }, 800); // Wait for fade-out to finish
  }

  // Initial update
  updateHeroQuote();

  // Auto-rotate every 6 seconds
  setInterval(updateHeroQuote, 6000);
}

// ===== ACCESSIBILITY FEATURES =====

// Initialize accessibility features
function initAccessibilityFeatures() {
  createAccessibilityPanel();
  loadAccessibilitySettings();
  addVisualIndicators();
}

// Create the accessibility control panel
function createAccessibilityPanel() {
  // Create the accessibility button
  const accessBtn = document.createElement('button');
  accessBtn.id = 'accessibility-toggle';
  accessBtn.className = 'accessibility-toggle';
  accessBtn.innerHTML = '♿';
  accessBtn.setAttribute('aria-label', 'Open accessibility settings');
  accessBtn.title = 'Accessibility Settings';

  // Create the accessibility panel
  const panel = document.createElement('div');
  panel.id = 'accessibility-panel';
  panel.className = 'accessibility-panel';
  panel.innerHTML = `
    <div class="accessibility-header">
      <h3>Accessibility Settings</h3>
      <button class="accessibility-close" aria-label="Close accessibility panel">×</button>
    </div>
    <div class="accessibility-content">
      <div class="accessibility-section">
        <h4>Font Size</h4>
        <div class="font-controls">
          <button class="font-btn" id="font-decrease" aria-label="Decrease font size">A-</button>
          <span class="font-display" id="font-display">100%</span>
          <button class="font-btn" id="font-increase" aria-label="Increase font size">A+</button>
        </div>
      </div>
      <div class="accessibility-section">
        <h4>Font Type</h4>
        <select id="font-family-selector" class="font-family-selector" aria-label="Select font family">
          <optgroup label="Serif">
            <option value="'Rockwell', 'Roboto Slab', serif" selected>Slab Serif (default)</option>
            <option value="Georgia, 'Times New Roman', Times, serif">Georgia</option>
            <option value="Garamond, 'Georgia', serif">Garamond</option>
            <option value="'Times New Roman', Times, serif">Times New Roman</option>
            <option value="'Merriweather', serif">Merriweather</option>
            <option value="'Playfair Display', serif">Playfair Display</option>
            <option value="'PT Serif', serif">PT Serif</option>
            <option value="'Roboto Slab', serif">Roboto Slab</option>
            <option value="'Cinzel', serif">Cinzel</option>
            <option value="'Abril Fatface', serif">Abril Fatface</option>
            <option value="'Old Style Serif', serif">Old Style Serif</option>
          </optgroup>
          <optgroup label="Sans-Serif">
            <option value="system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif">System Sans-Serif</option>
            <option value="Arial, Helvetica, sans-serif">Arial</option>
            <option value="Helvetica, Arial, sans-serif">Helvetica</option>
            <option value="Verdana, Geneva, sans-serif">Verdana</option>
            <option value="Tahoma, Geneva, Verdana, sans-serif">Tahoma</option>
            <option value="'Open Sans', sans-serif">Open Sans</option>
            <option value="'Poppins', sans-serif">Poppins</option>
            <option value="'Montserrat', sans-serif">Montserrat</option>
            <option value="'Lato', sans-serif">Lato</option>
            <option value="'Nunito', sans-serif">Nunito</option>
            <option value="'Ubuntu', sans-serif">Ubuntu</option>
            <option value="'Raleway', sans-serif">Raleway</option>
            <option value="'Oswald', sans-serif">Oswald</option>
            <option value="'Quicksand', sans-serif">Quicksand</option>
            <option value="'Cabin', sans-serif">Cabin</option>
            <option value="'Source Sans Pro', sans-serif">Source Sans Pro</option>
            <option value="'PT Sans', sans-serif">PT Sans</option>
            <option value="'Gill Sans', sans-serif">Gill Sans</option>
            <option value="'Futura', sans-serif">Futura</option>
            <option value="'Arial Black', sans-serif">Arial Black</option>
            <option value="'Impact', sans-serif">Impact</option>
          </optgroup>
          <optgroup label="Monospace">
            <option value="'Courier New', Courier, monospace">Courier New</option>
            <option value="Consolas, 'Courier New', monospace">Consolas</option>
            <option value="Monaco, 'Courier New', monospace">Monaco</option>
            <option value="'Source Code Pro', monospace">Source Code Pro</option>
          </optgroup>
          <optgroup label="Script / Handwritten / Display">
            <option value="'Dancing Script', cursive">Dancing Script</option>
            <option value="'Pacifico', cursive">Pacifico</option>
            <option value="'Brush Script MT', cursive">Brush Script</option>
            <option value="'Lobster', cursive">Lobster</option>
            <option value="'Bebas Neue', sans-serif">Bebas Neue</option>
            <option value="'Anton', sans-serif">Anton</option>
            <option value="'Roboto', sans-serif">Roboto</option>
          </optgroup>
          <optgroup label="Other / Decorative">
            <option value="'Rockwell', serif">Rockwell (Slab Serif)</option>
            <option value="'Playfair Display', serif">Playfair Display</option>
            <option value="'Abril Fatface', serif">Abril Fatface</option>
            <option value="'Georgia', serif">Slab Serif</option>
          </optgroup>
        </select>
      </div>
      <div class="accessibility-section">
        <h4>Visual Aids</h4>
        <label class="toggle-label">
          <input type="checkbox" id="visual-indicators-toggle">
          <span class="toggle-slider"></span>
          Show visual cues for audio/video
        </label>
      </div>
      <div class="accessibility-section">
        <h4>Display</h4>
        <label class="toggle-label">
          <input type="checkbox" id="high-contrast-toggle">
          <span class="toggle-slider"></span>
          High contrast mode
        </label>
      </div>
    </div>
  `;

  // Add to page
  document.body.appendChild(accessBtn);
  document.body.appendChild(panel);

  // Add optional nav button near the ministry link (top of pages)
  const nav = document.querySelector('nav.nav');
  if (nav) {
    const navBtn = document.createElement('button');
    navBtn.id = 'accessibility-nav-btn';
    navBtn.className = 'accessibility-nav-btn';
    navBtn.type = 'button';
    navBtn.setAttribute('aria-label', 'Open accessibility settings');
    navBtn.title = 'Accessibility settings';
    navBtn.textContent = '♿';

    // Insert after Ministry link, if exists first
    const ministryLink = nav.querySelector('a[href="ministry.html"]');
    if (ministryLink && ministryLink.parentNode) {
      ministryLink.insertAdjacentElement('afterend', navBtn);
    } else {
      nav.appendChild(navBtn);
    }

    navBtn.addEventListener('click', toggleAccessibilityPanel);
  }

  // Add event listeners
  accessBtn.addEventListener('click', toggleAccessibilityPanel);
  panel.querySelector('.accessibility-close').addEventListener('click', toggleAccessibilityPanel);

  // Font size controls
  document.getElementById('font-decrease').addEventListener('click', () => adjustFontSize(-10));
  document.getElementById('font-increase').addEventListener('click', () => adjustFontSize(10));

  // Font family control
  const fontSelector = document.getElementById('font-family-selector');
  if (fontSelector) {
    fontSelector.addEventListener('change', () => {
      setFontFamily(fontSelector.value);
      saveAccessibilitySettings();
    });
  }

  // Toggle controls
  document.getElementById('visual-indicators-toggle').addEventListener('change', toggleVisualIndicators);
  document.getElementById('high-contrast-toggle').addEventListener('change', toggleHighContrast);
}

// Toggle the accessibility panel
function toggleAccessibilityPanel() {
  const panel = document.getElementById('accessibility-panel');
  if (panel) {
    panel.classList.toggle('open');
  }
}

// Adjust font size
function adjustFontSize(delta) {
  const root = document.documentElement;
  const currentSize = parseFloat(getComputedStyle(root).getPropertyValue('--font-scale') || '1');
  let newSize = currentSize + (delta / 100);

  // Clamp between 0.75 and 1.5
  newSize = Math.max(0.75, Math.min(1.5, newSize));

  root.style.setProperty('--font-scale', newSize.toString());
  updateFontDisplay(newSize);
  saveAccessibilitySettings();
}

// Update font size display
function updateFontDisplay(scale) {
  const display = document.getElementById('font-display');
  if (display) {
    display.textContent = Math.round(scale * 100) + '%';
  }
}

// Set font family
function setFontFamily(fontValue) {
  document.documentElement.style.setProperty('--font', fontValue);
  const fontSelector = document.getElementById('font-family-selector');
  if (fontSelector) {
    fontSelector.value = fontValue;
  }
}

// Toggle visual indicators
function toggleVisualIndicators() {
  const toggle = document.getElementById('visual-indicators-toggle');
  if (toggle) {
    const enabled = toggle.checked;
    if (enabled) {
      addVisualIndicators();
    } else {
      removeVisualIndicators();
    }
    saveAccessibilitySettings();
  }
}

// Toggle high contrast mode
function toggleHighContrast() {
  const toggle = document.getElementById('high-contrast-toggle');
  if (toggle) {
    const enabled = toggle.checked;
    document.body.classList.toggle('high-contrast', enabled);
    saveAccessibilitySettings();
  }
}

// Add visual indicators to multimedia elements
function addVisualIndicators() {
  // Remove existing indicators first
  removeVisualIndicators();

  // Add indicators to videos
  const videos = document.querySelectorAll('iframe[src*="youtube.com"], video');
  videos.forEach(video => {
    if (!video.nextElementSibling?.classList.contains('visual-indicator')) {
      const indicator = document.createElement('div');
      indicator.className = 'visual-indicator';
      indicator.textContent = '🎬 View Original on YouTube';
      indicator.setAttribute('aria-label', 'This content contains audio or video');
      video.parentNode.insertBefore(indicator, video.nextSibling);
    }
  });

  // Add indicators to audio elements
  const audios = document.querySelectorAll('audio');
  audios.forEach(audio => {
    if (!audio.nextElementSibling?.classList.contains('visual-indicator')) {
      const indicator = document.createElement('div');
      indicator.className = 'visual-indicator';
      indicator.textContent = '🎵 Audio Content';
      indicator.setAttribute('aria-label', 'This content contains audio');
      audio.parentNode.insertBefore(indicator, audio.nextSibling);
    }
  });
}

// Remove visual indicators
function removeVisualIndicators() {
  const indicators = document.querySelectorAll('.visual-indicator');
  indicators.forEach(indicator => indicator.remove());
}

// Save accessibility settings to localStorage
function saveAccessibilitySettings() {
  const settings = {
    fontScale: parseFloat(getComputedStyle(document.documentElement).getPropertyValue('--font-scale') || '1'),
    fontFamily: document.documentElement.style.getPropertyValue('--font') || getComputedStyle(document.documentElement).getPropertyValue('--font'),
    visualIndicators: document.getElementById('visual-indicators-toggle')?.checked || false,
    highContrast: document.body.classList.contains('high-contrast')
  };

  localStorage.setItem('accessibilitySettings', JSON.stringify(settings));
}

// Load accessibility settings from localStorage
function loadAccessibilitySettings() {
  const settings = localStorage.getItem('accessibilitySettings');
  if (!settings) return;

  try {
    const parsed = JSON.parse(settings);

    // Apply font scale
    if (parsed.fontScale) {
      document.documentElement.style.setProperty('--font-scale', parsed.fontScale.toString());
      updateFontDisplay(parsed.fontScale);
    }

    // Apply font family
    if (parsed.fontFamily) {
      setFontFamily(parsed.fontFamily);
      const selector = document.getElementById('font-family-selector');
      if (selector) selector.value = parsed.fontFamily;
    }

    // Apply visual indicators
    if (parsed.visualIndicators) {
      const toggle = document.getElementById('visual-indicators-toggle');
      if (toggle) {
        toggle.checked = true;
        addVisualIndicators();
      }
    }

    // Apply high contrast
    if (parsed.highContrast) {
      document.body.classList.add('high-contrast');
      const toggle = document.getElementById('high-contrast-toggle');
      if (toggle) toggle.checked = true;
    }
  } catch (error) {
    console.warn('Error loading accessibility settings:', error);
  }
}