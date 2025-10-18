## The Problem

Ten years ago, when preparing for national exams, I spent countless hours collecting PDF practice tests, handwriting notes, and compiling study materials manually. The process was tedious and time-consuming.
https://wwwq.moex.gov.tw/exam/wHandExamQandA_File.ashx?t=Q&code=114080&c=236&s=1102&q=1

What if there was a plugin that could automatically upload PDF files to AI pages and generate practice answers instantly?

## The Solution

I built [chrome-pdf-ai](https://github.com/kero13ro/chrome-pdf-ai), a Chrome extension that generates mock answers for exam questions by sending PDF content to Claude AI or ChatGPT.

### Core Workflow

1. Click the extension button
2. Downloads PDF to clipboard
3. Jumps to Claude/ChatGPT page
4. Auto-pastes PDF content with custom prompts

I added a settings page for prompt customization and AI provider switching. Through testing, I discovered ChatGPT performs better on research-oriented questions.

## Technical Challenges

### Icon Design
Generating quality icons proved surprisingly difficult. Most professional tools require payment, and free options look amateur. After testing various AI generators (which often misunderstood requirements), I found [icon.kitchen](https://icon.kitchen/) - simple, clean, and perfect for Chrome extensions.

### Publishing Gotchas
The Chrome Web Store revealed several pitfalls:
- **Extension titles can't be modified post-submission** - mine became "Test Bro - Web Test Assistant"
- Marketing screenshots must be exactly 1280×800px
- Manual ZIP compression required for each upload

I automated the packaging process with a Makefile to exclude screenshots and local configs, significantly speeding up iterations.

## Development Timeline

Using Claude Code, I hit the token limit after approximately 3 hours:
- ~2 hours: core functionality
- ~1 hour: publication preparation and submission

**Key lesson**: Use ChatGPT for non-code tasks (documentation, marketing copy) to conserve Claude Code tokens.

## Launch & What's Next

Surprisingly, the Chrome Web Store review was approved on the third day! 🎉
https://chromewebstore.google.com/detail/ngknkcnhfkfjhbajoeoekiefmhnjjlpl
![[Pasted image 20251010164040.png]]

### Roadmap
- Automated screenshot generation tools (proper size/format)
- Expand to YouTube transcript functionality
- Hot-reload development setup (currently requires manual refresh on `chrome://extensions/`)

---
## Expanding to YouTube

After successfully launching the PDF functionality, I realized the same workflow could be applied to video content. Many educational resources exist on YouTube, but extracting key information requires watching entire videos or manually taking notes.

I expanded the extension to support YouTube transcript extraction:

### YouTube Workflow

1. Navigate to any YouTube video
2. Click the extension button
3. Extension extracts the video transcript
4. Sends transcript to Claude/ChatGPT with customizable prompts
5. AI generates summaries, Q&A, or study notes instantly

### Technical Implementation

- Added `content-youtube.js` to extract transcripts from YouTube's player data
- Extended the background service worker to handle both PDF and video content
- Updated the popup UI to detect content type automatically
- Reused the same AI provider settings and prompt customization system

The extension now serves dual purposes: exam preparation from PDFs and learning from video content. The name evolved to **"[YouTube & PDF to AI Assistant](https://chromewebstore.google.com/detail/youtube-pdf-to-ai-assista/aoladgbnahppfdlneiocoapeikgflgmm)"** to reflect both capabilities.

![[Pasted image 20251018180327.png]]
