# AI Chat Setup Guide

Your profile website has an AI chat assistant (powered by Groq's Llama 3 AI model). Here's how to get it running:

## Prerequisites

- **Node.js** installed (download from https://nodejs.org/)
- **Groq API Key** (free from https://console.groq.com/keys)

## Quick Start (3 steps)

### Step 1: Install Backend Dependencies
Open a terminal/PowerShell and run:
```bash
cd "c:\Users\TUYISHIMEHONORE\Downloads\Profile web\backend"
npm install
```

### Step 2: Set Your Groq API Key
Windows (PowerShell):
```bash
$env:GROQ_API_KEY = "your-api-key-here"
```

Windows (Command Prompt):
```bash
set GROQ_API_KEY=your-api-key-here
```

Replace `your-api-key-here` with your actual API key from https://console.groq.com/keys

### Step 3: Start the Backend Server
```bash
npm start
```

You should see: `Server running at http://localhost:3000` ✓

## What Should Work After Setup

✓ **Chat Widget** - Click "Chat with Honore" button on the website  
✓ **AI Responses** - Ask questions, get thoughtful AI-powered answers  
✓ **File Upload** - Upload your CV/diploma for context-aware responses  
✓ **Role Selection** - Choose your role (Teacher, Student, Collaborator)  
✓ **Document Context** - AI references your uploaded documents

## Features

- **Smart Role Detection** - The AI tailors responses based on who you are
- **Conversation Memory** - Tracks up to 20 recent messages per session
- **Document Intelligence** - Upload CV/diploma, AI learns from it
- **Empathetic Responses** - Structured answers with reasoning, examples, and next steps

## Troubleshooting

### Issue: "Network error" in chat
**Solution:** Backend server is not running. Run `npm start` in the backend folder.

### Issue: "API error" or blank responses
**Solution:** Your Groq API key is missing or invalid. 
1. Get a free key from https://console.groq.com/keys
2. Set it: `$env:GROQ_API_KEY = "sk-..."`
3. Restart the server

### Issue: CV data not loading
**Solution:** Already fixed! The path now correctly points to `../cv-data.json`

## Architecture Overview

```
Frontend (index.html, script.js)
    ↓
Sends chat messages via fetch()
    ↓
Backend Server (backend/server.js) - Port 3000
    ↓
Groq API (llama3-8b-8192 model)
    ↓
Returns AI response with context
```

## API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/chat` | POST | Send message, get AI response |
| `/upload` | POST | Upload CV/document for context |
| `/set-role` | POST | Set user role (teacher/student/collaborator) |
| `/cv-data` | GET | Fetch full CV data |
| `/conversation-info` | GET | Get session info |

## Development Tips

- **Hot Reload**: Restart server with `npm start` after code changes
- **Debug Mode**: Add `console.log()` statements in server.js
- **CORS**: Already enabled for localhost:3000
- **Max Tokens**: Set to 500 for quick responses (increase for longer answers)

---

**Status:** Chat widget is now configured and ready to use!  
**Last Updated:** March 18, 2026
