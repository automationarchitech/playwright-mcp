# Playwright MCP - Files to Summarize for RAG System

## Priority Levels
- **🔴 Critical**: Core architecture, essential for any feature work
- **🟡 Important**: Common patterns, frequently referenced
- **🟢 Reference**: Specific implementations, summarize as needed

---

## 🔴 Critical Files (Summarize First)

### Core Architecture
1. **`/src/tools/tool.ts`**
   - Tool type definitions, interfaces, helper functions
   - How tools are structured and registered
   - Modal state handling patterns

2. **`/src/response.ts`**
   - Response object methods and patterns
   - How tools communicate results
   - Image/snapshot handling

3. **`/src/tab.ts`**
   - Tab lifecycle and methods
   - Modal state management
   - Page interaction patterns

4. **`/src/context.ts`**
   - Browser context management
   - Tab creation and switching
   - Output file handling

5. **`/src/browserServerBackend.ts`**
   - Main backend orchestration
   - Tool routing and execution
   - Session management

6. **`/src/tools.ts`**
   - Tool registration system
   - Capability filtering
   - How to add new tools

### Configuration & Types
7. **`config.d.ts`**
   - Type definitions for configuration
   - Available capabilities
   - Configuration options

8. **`/src/config.ts`**
   - Configuration resolution logic
   - Default values and merging
   - CLI argument processing

---

## 🟡 Important Files (Common Patterns)

### Tool Examples (Pick 2-3 as References)
9. **`/src/tools/common.ts`**
   - Basic browser operations (click, fill, check)
   - Simple tool patterns
   - Context vs Tab tool examples

10. **`/src/tools/screenshot.ts`**
    - Complex input validation with Zod
    - File output patterns
    - Image handling

11. **`/src/tools/navigate.ts`**
    - Navigation patterns
    - URL handling
    - Wait states

### MCP Integration
12. **`/src/mcp/server.ts`**
    - MCP protocol implementation
    - Tool registration with MCP
    - Request/response flow

13. **`/src/program.ts`**
    - CLI entry point
    - Command-line options
    - Initialization flow

### Browser Management
14. **`/src/browserContextFactory.ts`**
    - Browser launch configuration
    - Persistent vs isolated contexts
    - Browser-specific settings

---

## 🟢 Reference Files (Summarize as Needed)

### Specialized Tools
15. **`/src/tools/dialogs.ts`** - Dialog handling patterns
16. **`/src/tools/files.ts`** - File upload/download
17. **`/src/tools/evaluate.ts`** - JavaScript execution
18. **`/src/tools/network.ts`** - Network interception
19. **`/src/tools/console.ts`** - Console message capture
20. **`/src/tools/keyboard.ts`** - Keyboard input patterns
21. **`/src/tools/mouse.ts`** - Mouse interaction patterns
22. **`/src/tools/wait.ts`** - Wait conditions
23. **`/src/tools/tabs.ts`** - Tab management
24. **`/src/tools/snapshot.ts`** - DOM snapshot generation
25. **`/src/tools/pdf.ts`** - PDF generation (capability-gated)

### Utilities
26. **`/src/tools/utils.ts`** - Tool utility functions
27. **`/src/utils/codegen.ts`** - Code generation helpers
28. **`/src/utils/log.ts`** - Logging patterns
29. **`/src/utils/fileUtils.ts`** - File system operations
30. **`/src/utils/manualPromise.ts`** - Promise control patterns

### Transport & Communication
31. **`/src/mcp/transport.ts`** - HTTP/SSE transport setup
32. **`/src/mcp/proxyBackend.ts`** - Proxy mode implementation
33. **`/src/mcp/inProcessTransport.ts`** - In-process communication

### Session & Logging
34. **`/src/sessionLog.ts`** - Session activity tracking
35. **`/src/actions.d.ts`** - Action type definitions

### Extension Mode (If Needed)
36. **`/src/extension/extensionContextFactory.ts`** - Extension mode setup
37. **`/src/extension/cdpRelay.ts`** - CDP protocol relay

### Loop Tools (AI Integration - If Needed)
38. **`/src/loop/loop.ts`** - Base loop implementation
39. **`/src/loopTools/main.ts`** - Loop tools entry
40. **`/src/loopTools/perform.ts`** - Perform action tool

---

## Summary Guidelines

### For Critical Files (🔴)
- **Length**: 200-300 tokens
- **Include**: 
  - Purpose and responsibility
  - Key methods/functions with signatures
  - Important types/interfaces
  - Common usage patterns
  - Dependencies and what it exports

### For Important Files (🟡)
- **Length**: 100-200 tokens
- **Include**:
  - Main purpose
  - Key patterns demonstrated
  - How it fits in the architecture
  - Notable methods/features

### For Reference Files (🟢)
- **Length**: 50-100 tokens
- **Include**:
  - What it does
  - When to use it
  - Special considerations
  - Key exports

---

## RAG Context Strategy

### When implementing a new tool:
1. Always include summaries of:
   - `/src/tools/tool.ts`
   - `/src/response.ts`
   - `/src/tools.ts`
   - 1-2 similar tool examples

2. Include based on tool type:
   - Tab tool → `/src/tab.ts`
   - Context tool → `/src/context.ts`
   - File operations → `/src/utils/fileUtils.ts`
   - Modal handling → relevant dialog sections

### When modifying configuration:
1. Include:
   - `config.d.ts`
   - `/src/config.ts`
   - `/src/program.ts`

### When debugging:
1. Include:
   - `/src/utils/log.ts`
   - `/src/sessionLog.ts`
   - Relevant tool implementation

---

## Optimal Summary Structure

```markdown
## [Filename]
**Purpose**: One-line description
**Key Exports**: Main functions/classes
**Dependencies**: What it imports/requires
**Patterns**: Notable implementation patterns
**Usage**: When/how to use this file
```

---

## Notes for RAG Implementation

1. **Prioritize signal over noise**: Focus on interfaces, not implementation details
2. **Include type signatures**: Essential for TypeScript development
3. **Document patterns**: Show "how" not just "what"
4. **Cross-reference**: Mention related files in summaries
5. **Update regularly**: Keep summaries current with codebase changes

Total files to summarize initially: ~15 critical + important files
Estimated total tokens for core summaries: ~3000-4000 tokens