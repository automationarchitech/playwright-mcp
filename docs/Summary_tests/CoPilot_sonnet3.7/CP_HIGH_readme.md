# Playwright MCP - High-Level Architecture Overview

## Introduction

Playwright MCP is a Model Context Protocol (MCP) server that enables Large Language Models (LLMs) to interact with web browsers through structured accessibility snapshots. The project uses [Playwright](https://playwright.dev/) under the hood to automate browser interactions, but instead of relying on screenshots, it provides structured accessibility trees that are more suitable for LLMs to process.

## Core Architecture

The system follows a client-server architecture where:

1. LLMs (clients) connect to the Playwright MCP server via the Model Context Protocol
2. The server manages browser contexts, tabs, and provides tools for browser interaction
3. Commands from the LLM are translated into Playwright actions
4. Structured accessibility snapshots are returned to the LLM instead of images

### Key Components and File Relationships

```
┌─────────────────┐      ┌──────────────────┐     ┌────────────────┐
│ MCP Client (LLM)│<─────│BrowserServerBackend│────>│ Browser Context│
└─────────────────┘      └──────────────────┘     └────────────────┘
         │                        │                       │
         │                        │                       │
         │                        ▼                       ▼
         │                  ┌────────────┐          ┌─────────┐
         └─────────────────>│ MCP Tools  │<─────────│   Tab   │
                            └────────────┘          └─────────┘
```

## Main Files and Their Roles

### Entry Points

- **`cli.js`**: The main entry point for the command-line interface
- **`program.ts`**: Defines the command-line options and initializes the server
- **`index.ts`**: Main library entry point for programmatic usage

### Core Components

- **`browserServerBackend.ts`**: Central component that connects the MCP protocol to Playwright. Handles client connections and routes tool calls.
- **`browserContextFactory.ts`**: Creates and manages browser contexts (persistent, isolated, CDP, remote)
- **`context.ts`**: Represents a user's browser session. Manages tabs and provides a facade for tool operations.
- **`tab.ts`**: Represents a browser tab with automation capabilities. Wraps Playwright Page objects.
- **`tools.ts`**: Aggregates all available browser interaction tools from the tools directory
- **`response.ts`**: Handles formatting responses back to the MCP client

### Tool Implementations

The `src/tools/` directory contains implementations for various browser interactions:

- **`navigate.ts`**: URL navigation tools
- **`mouse.ts`**: Mouse interaction tools (click, hover, drag)
- **`keyboard.ts`**: Keyboard input tools
- **`screenshot.ts`**: Screenshot capture tools
- **`snapshot.ts`**: Accessibility snapshot tools (core functionality)
- **`tabs.ts`**: Tab management tools
- **`evaluate.ts`**: JavaScript evaluation tools
- **`console.ts`**: Console message access tools
- **`network.ts`**: Network monitoring tools

### MCP Protocol Implementation

- **`mcp/server.ts`**: Implements the Model Context Protocol server
- **`mcp/transport.ts`**: Handles communication between client and server
- **`mcp/inProcessTransport.ts`**: In-process transport for testing
- **`mcp/proxyBackend.ts`**: Proxy for routing requests to multiple backends

## File References and Dependencies

- **`program.ts`** → Imports `browserContextFactory.ts`, `browserServerBackend.ts`, and `mcp/transport.ts`
- **`browserServerBackend.ts`** → Imports `context.ts` and `tools.ts`
- **`context.ts`** → Imports `tab.ts` and uses `playwright` library
- **`tab.ts`** → Uses `playwright` Page objects
- **`tools.ts`** → Aggregates tools from `src/tools/*`
- Each tool file (e.g., `navigate.ts`) → Defines tools using the utility functions from `tool.ts`

## Workflow and Data Flow

1. **Server Initialization**:
   - `cli.js` → `program.ts` → `browserServerBackend.ts`
   - Command-line options are parsed and a config is created
   - A browser context factory is created based on the config

2. **Client Connection**:
   - MCP client connects to the server via the transport layer
   - Server creates a browser context using the factory
   - A context object is initialized for the client session

3. **Tool Execution**:
   - Client calls a tool with arguments
   - Server routes the call to the appropriate tool implementation
   - Tool performs actions using Playwright APIs
   - A structured snapshot of the page is returned to the client

4. **Browser Interaction Flow**:
   - Context manages multiple tabs
   - Each tab wraps a Playwright Page object
   - Tools use the current tab to perform actions
   - Changes in the page are captured in the accessibility tree

## Configuration Options

The server can be configured with various options:

- Browser selection (Chrome, Firefox, WebKit)
- Persistent vs. isolated contexts
- Headless vs. headed mode
- Network traffic filtering
- Additional capabilities (vision, PDF)

These options can be specified via command-line arguments or a configuration file.

## Extension Points

The codebase is designed to be extensible:

- New tools can be added to the `src/tools/` directory
- Custom browser context factories can be implemented
- The MCP protocol can be extended with new capabilities

## Development Tips

When working with this codebase:

1. Start with `src/tools.ts` to understand available browser interactions
2. Look at `src/browserServerBackend.ts` for the central coordination logic
3. Check individual tool implementations in `src/tools/` to understand specific actions
4. For adding new features, create a new tool or extend an existing one in the tools directory
