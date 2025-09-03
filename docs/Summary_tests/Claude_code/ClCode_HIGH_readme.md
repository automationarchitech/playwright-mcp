# Playwright MCP Server - High-Level Architecture Guide

## 🎯 Purpose
This document provides a comprehensive map of the Playwright MCP Server codebase to help developers understand the architecture, locate specific functionality, and efficiently guide LLMs when implementing features.

## 🏗️ Architecture Overview

### Core Flow
```
CLI Entry → Program Setup → MCP Server → Backend → Context → Browser → Tools
```

The server acts as a bridge between MCP clients (like AI assistants) and Playwright browser automation, exposing browser control as structured tools through the Model Context Protocol.

## 📁 Directory Structure & Purpose

### `/src` - Main Source Code

#### **Entry Points**
- `cli.js` → `lib/program.js` - Command-line interface entry
- `src/index.ts` - Library API entry point for programmatic use
- `src/program.ts` - CLI command parser and initialization orchestrator

#### **Core Components**

##### **MCP Layer** (`/src/mcp/`)
Handles Model Context Protocol communication
- `server.ts` - MCP server implementation, tool registration
- `transport.ts` - HTTP/SSE transport setup
- `proxyBackend.ts` - Proxy mode for multiple browser connections
- `inProcessTransport.ts` - In-process transport for embedded use

##### **Browser Management**
- `browserContextFactory.ts` - Creates and manages browser contexts (persistent/isolated)
- `browserServerBackend.ts` - Main backend connecting MCP server to browser operations
- `context.ts` - Browser context wrapper, manages tabs and state
- `tab.ts` - Individual tab/page management

##### **Configuration**
- `config.ts` - Configuration resolution and validation
- `config.d.ts` - TypeScript type definitions for configuration

#### **Tool System** (`/src/tools/`)
Each file implements specific browser automation capabilities:

##### Core Tools
- `tool.ts` - Base tool definitions and interfaces
- `common.ts` - Basic browser operations (click, fill, check, etc.)
- `navigate.ts` - Navigation (goto, reload, back, forward)
- `evaluate.ts` - JavaScript execution in browser context
- `wait.ts` - Wait conditions and timeouts

##### Interaction Tools
- `keyboard.ts` - Keyboard input simulation
- `mouse.ts` - Mouse operations (hover, drag)
- `dialogs.ts` - Handle browser dialogs (alert, confirm, prompt)
- `files.ts` - File upload/download handling

##### Content Tools
- `screenshot.ts` - Capture screenshots
- `snapshot.ts` - DOM snapshots with accessibility tree
- `pdf.ts` - PDF generation (opt-in capability)
- `console.ts` - Browser console message capture

##### Browser Features
- `tabs.ts` - Tab management (open, close, switch)
- `network.ts` - Network request monitoring
- `install.ts` - Browser installation utilities

##### Support
- `utils.ts` - Tool utility functions

#### **Utilities** (`/src/utils/`)
- `log.ts` - Logging infrastructure
- `httpServer.ts` - HTTP server utilities
- `manualPromise.ts` - Promise control utilities
- `guid.ts` - GUID generation
- `codegen.ts` - Code generation for actions
- `fileUtils.ts` - File system operations
- `package.ts` - Package.json access

#### **Special Modes**

##### Extension Mode (`/src/extension/`)
Connect to existing browser with extension
- `extensionContextFactory.ts` - Creates contexts for extension mode
- `cdpRelay.ts` - Chrome DevTools Protocol relay

##### Loop Tools (`/src/loopTools/`)
AI agent loop capabilities
- `main.ts` - Loop tools entry point
- `context.ts` - Loop-specific context
- `perform.ts` - Perform actions tool
- `snapshot.ts` - Snapshot for AI vision

##### AI Loop Integration (`/src/loop/`)
- `loop.ts` - Base loop implementation
- `loopClaude.ts` - Claude AI integration
- `loopOpenAI.ts` - OpenAI integration
- `main.ts` - Loop mode entry point

#### **Response & Logging**
- `response.ts` - Tool response formatting
- `sessionLog.ts` - Session activity logging
- `actions.d.ts` - Action type definitions

### `/lib` - Compiled JavaScript
Mirror of `/src` structure with compiled `.js` files

### `/tests` - Test Suite
Comprehensive test coverage for all tools and features

### `/examples` - Usage Examples
Sample implementations and use cases

### `/utils` - Build Utilities
- `check-deps.js` - Dependency validation
- `update-readme.js` - Auto-update README with tool info

## 🔄 Key File Dependencies

### Initialization Chain
```
cli.js
  → program.ts (parses CLI args)
    → config.ts (resolves configuration)
      → browserContextFactory.ts (creates browser context)
        → browserServerBackend.ts (creates backend)
          → mcp/server.ts (starts MCP server)
            → mcp/transport.ts (sets up transport)
```

### Tool Execution Flow
```
mcp/server.ts (receives tool call)
  → browserServerBackend.ts (routes to tool)
    → context.ts (provides browser context)
      → tab.ts (manages browser tab)
        → tools/*.ts (executes specific tool)
          → response.ts (formats response)
```

### Configuration Resolution
```
program.ts (CLI args)
  → config.ts (merges with file config)
    → Creates FullConfig object used throughout
```

## 🛠️ Adding New Features

### To Add a New Tool:
1. Create file in `/src/tools/yourTool.ts`
2. Import `defineTool` or `defineTabTool` from `tool.ts`
3. Define schema using Zod
4. Implement handler function
5. Export tool array
6. Add to `/src/tools.ts` imports and `allTools` array

### To Add a New Capability:
1. Add to `ToolCapability` type in `config.d.ts`
2. Create tools with that capability
3. Update `filteredTools()` in `tools.ts` if needed
4. Document in README

### To Modify Browser Context:
1. Edit `browserContextFactory.ts` for context creation
2. Edit `context.ts` for runtime behavior
3. Update `config.ts` for new options

### To Add Transport Method:
1. Create new transport in `/src/mcp/`
2. Implement Transport interface
3. Add to `transport.ts` start function
4. Add CLI option in `program.ts`

## 🔍 Quick Navigation Guide

| What You Want | Where to Look |
|--------------|---------------|
| Add new browser automation tool | `/src/tools/` + `/src/tools.ts` |
| Modify browser launch options | `/src/browserContextFactory.ts` |
| Add CLI parameter | `/src/program.ts` |
| Change MCP protocol handling | `/src/mcp/server.ts` |
| Add configuration option | `/src/config.ts` + `config.d.ts` |
| Modify tab behavior | `/src/tab.ts` |
| Add logging | `/src/utils/log.ts` |
| Handle file operations | `/src/utils/fileUtils.ts` |
| Add AI integration | `/src/loop/` |
| Modify response format | `/src/response.ts` |
| Add session tracking | `/src/sessionLog.ts` |
| Browser installation | `/src/tools/install.ts` |
| Network interception | `/src/tools/network.ts` |

## 📊 Module Relationships

### Core Dependencies
- **Context** depends on: Tab, Config, BrowserContextFactory
- **Tab** depends on: Response, Tools, SessionLog
- **Tools** depend on: Context or Tab, Response
- **Backend** depends on: Context, Tools, Config
- **Server** depends on: Backend, Transport

### Import Patterns
- Tools import from `tool.ts` for base definitions
- Most files import from `config.js` for types
- Browser operations import from `context.js` or `tab.js`
- MCP operations import from `mcp/server.js`

## 🎮 Capabilities System

The server has a capability system that controls which tools are available:

### Core Capabilities (Always Enabled)
- Basic automation (click, fill, navigate)
- Tab management
- Screenshot/snapshot
- Console/network monitoring

### Opt-in Capabilities
- `vision` - Coordinate-based operations
- `pdf` - PDF generation

Enable via CLI: `--caps=vision,pdf`

## 💡 Development Tips

1. **TypeScript First**: All source in TypeScript, imports use `.js` extension (ES module requirement)
2. **Tool Isolation**: Each tool is self-contained with its own schema and handler
3. **Response Pattern**: Tools don't return values, they write to Response object
4. **Context Lifecycle**: Contexts can be persistent (saved) or isolated (temporary)
5. **Modal States**: Some tools handle modal states (dialogs, file choosers)
6. **Error Handling**: Use Response.sendError() for tool errors
7. **Logging**: Use debug package with `pw:mcp:*` namespace

## 🔧 Common Modification Scenarios

### Scenario: Add screenshot annotation feature
1. Modify `/src/tools/screenshot.ts` - add annotation parameters to schema
2. Update handler to draw annotations before capture
3. Add annotation utilities in `/src/tools/utils.ts`
4. Update tests in `/tests/screenshot.spec.ts`

### Scenario: Add new browser (e.g., Brave)
1. Modify `/src/browserContextFactory.ts` - add Brave launch logic
2. Update `/src/config.ts` - add 'brave' to browser options
3. Update CLI help in `/src/program.ts`
4. Add tests for Brave-specific behavior

### Scenario: Add authentication tool
1. Create `/src/tools/auth.ts` with login/logout tools
2. Define schemas for credentials
3. Implement cookie/localStorage management
4. Add to `/src/tools.ts` exports
5. Consider security implications in handler

## 📝 Notes for LLM Guidance

When guiding an LLM to modify this codebase:
1. **Start with the schema** - Define Zod schema for inputs first
2. **Follow existing patterns** - Copy structure from similar tools
3. **Test incrementally** - Each tool can be tested independently
4. **Use Response object** - Never return values directly from tools
5. **Handle edge cases** - Check for tab existence, timeout handling
6. **Document capabilities** - Update capability requirements if needed
7. **Maintain type safety** - TypeScript will catch many issues early

This architecture is designed for extensibility - new tools and capabilities can be added without modifying core infrastructure.