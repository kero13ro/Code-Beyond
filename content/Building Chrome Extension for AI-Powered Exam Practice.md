# Building a Chrome Extension for AI-Powered Exam Practice: Lessons Learned

## The Goal

I recently built [chrome-pdf-ai](https://github.com/kero13ro/chrome-pdf-ai), a Chrome extension that generates mock answers for exam questions by sending PDF content to Claude AI or ChatGPT.

## Core Features

The extension workflow is simple:
1. Click the extension button
2. Downloads PDF to clipboard
3. Jumps to Claude/ChatGPT page
4. Auto-pastes PDF content with custom prompts

During development, I added a settings page for prompt editing and AI provider switching. Interestingly, I found ChatGPT performs better on research-oriented questions.

## The Biggest Challenge: Icons

Generating icons was surprisingly difficult. Most quality tools require payment, and free options look amateur. After trying various AI generators (which often misunderstood requirements), I discovered [icon.kitchen](https://icon.kitchen/) - simple, clean, and perfect for my needs.

## Publishing Pitfalls

Publishing to the Chrome Web Store revealed several gotchas:
- **Extension titles can't be modified post-submission** - mine became "Test Bro - Web Test Assistant"
- Marketing screenshots must be exactly 1280×800
- Manual ZIP compression for each upload

I automated packaging with a Makefile to exclude screenshots and local configs, which sped up the iteration process significantly.

## Development Stats

Using Claude Code, I hit the token limit after approximately 3 hours:
- ~2 hours: core functionality
- ~1 hour: preparing for publication and submission

**Key lesson**: Use ChatGPT for non-code tasks (like writing documentation or marketing copy) to conserve Claude Code tokens.

## Next Steps

While waiting for Chrome Web Store approval, I'm planning:
- Automated screenshot generation tools (proper size/format)
- Hot-reload development setup (currently requires manual refresh on `chrome://extensions/`)
- User acquisition strategy through social media and influencer outreach

[Preview the extension](https://chromewebstore.google.com/detail/golnfoeaoefjgpfccimpdjjndjodlhnn/preview?hl=zh-TW&authuser=0) | [Privacy Policy](https://github.com/kero13ro/chrome-pdf-ai/blob/main/PRIVACY_POLICY.md)

---

**Takeaway**: Building and publishing a Chrome extension is faster than expected with AI assistance, but careful planning around naming, assets, and automation can save significant time in the review and iteration process.
