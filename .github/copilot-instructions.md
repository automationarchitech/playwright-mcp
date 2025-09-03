# Playwright MCP Guide for AI Agents

## Overview

Playwright MCP is a Model Context Protocol (MCP) server that enables LLMs to interact with web browsers through structured accessibility snapshots. The codebase provides a bridge between AI agents and browser automation.

## Architecture

- **Main Components**:
  - `BrowserServerBackend`: Central component connecting MCP protocol to Playwright
  - `BrowserContextFactory`: Creates and manages browser contexts (persistent, isolated, CDP, remote)
  - `Context`: Represents a user's browser session
  - `Tab`: Represents a browser tab with automation capabilities
  - `Tools`: Collection of browser interaction methods exposed via MCP

- **Data Flow**:
  1. MCP client connects to the server
  2. Server initializes browser context based on configuration
  3. Client calls tools with arguments to perform browser actions
  4. Server executes Playwright commands and returns structured snapshots

## Development Workflow

### Building and Running

```bash
# Install dependencies
npm install

# Build the project
npm run build

# Run in watch mode for development
npm run watch

# Start server locally
node cli.js --port 8080

# Run tests
npm test
```

### Key Configuration Options

- `--isolated`: Run in an isolated browser profile (vs. persistent default)
- `--headless`: Run browser in headless mode (headed by default)
- `--browser <browser>`: Select browser (chrome, firefox, webkit)
- `--caps <caps>`: Enable capabilities (vision, pdf, etc.)
- `--port <port>`: Port for HTTP transport (enables remote connections)

## Project Conventions

- Tool definitions follow a pattern of using Zod schemas for validation
- Tools are organized by capability and registered in `src/tools.ts`
- Each tool must specify if it's `readOnly` or `destructive`
- Page snapshots use accessibility trees, not screenshots

## Integration Points

- Connects to any MCP client (VS Code, Claude, Cursor, etc.)
- Uses Playwright for browser automation
- Implements the Model Context Protocol for standardized tool interfaces

## Common Operations

- View tool names, schemas and examples in README.md
- Debug with `npx -y @modelcontextprotocol/inspector node ./cli.js`
- Create persistent user profiles at standard OS-specific locations
