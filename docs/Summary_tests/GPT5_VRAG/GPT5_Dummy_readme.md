# Playwright MCP: Beginner-Friendly Guide for LLM Tool/Feature Creation

## What is Playwright MCP?
Playwright MCP is a server that lets AI models (like ChatGPT or Claude) control a web browser using code. It acts as a bridge between the AI and the browser, making it possible for the AI to:
- Open web pages
- Click buttons, fill forms, and interact with sites
- Take structured "snapshots" of web pages (not just screenshots)
- Run browser automation tasks

## Why Use It?
If you want an AI to:
- Test websites automatically
- Extract information from web pages
- Perform actions on the web (like a human would)
- Build new browser tools or features for automation

...this repo gives you the foundation.

## How Does It Work?
1. **Start the Server**: Run the MCP server locally (see below).
2. **Connect an LLM Client**: Use an AI agent or IDE extension that speaks the MCP protocol.
3. **Send Instructions**: The AI sends commands ("tools") to the server, like "click this button" or "get a snapshot".
4. **Get Results**: The server runs the command in the browser and sends back structured data.

## Key Concepts
- **Tools**: Predefined actions the AI can use (e.g., click, type, navigate, snapshot). You can add new ones!
- **Browser Context**: Each session is isolated, so tests and actions don't interfere with each other.
- **Snapshots**: Instead of images, the server returns accessibility trees (structured data about the page).

## Quick Start
1. **Install dependencies**
   ```cmd
   npm install
   ```
2. **Build the project**
   ```cmd
   npm run build
   ```
3. **Start the server**
   ```cmd
   node cli.js --port 8080
   ```
4. **Connect your LLM client** (e.g., VS Code extension, Claude, etc.)

## Making New Tools/Features
- Tools are defined in `src/tools.ts` (TypeScript) or `lib/tools.js` (JavaScript).
- Each tool has:
  - A name
  - A schema (what arguments it takes)
  - A function (what it does in the browser)
- To add a tool:
  1. Copy an existing tool as a template.
  2. Change the name, schema, and function as needed.
  3. Register it in the tools list.
  4. Rebuild and restart the server.

## Where to Learn More
- See `README.md` for advanced usage and options.
- Explore `src/tools.ts` for tool examples.
- Try running the server and connecting an LLM to experiment!

---
**Tip:** Start simple—try making a tool that just navigates to a page or clicks a button. Build up from there!
