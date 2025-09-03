# Playwright MCP - Essential Files for Feature Implementation RAG

This document identifies the most critical files to summarize for a virtualized RAG system that helps implement features in the Playwright MCP project. Each file is categorized by its role in the architecture with signal-to-noise considerations for effective context utilization.

## Core Framework Files (Highest Priority)

1. `src/tools/tool.ts` - **Core interface definitions**
   - Tool type definitions and interfaces
   - Helper functions for tool creation
   - Type constraints and schema specifications
   - Signal focus: Type interfaces, not implementation details

2. `src/response.ts` - **Response handling**
   - Response formatting mechanisms
   - Error handling patterns
   - Signal focus: Public methods for adding content to responses

3. `src/tab.ts` - **Browser tab abstraction**
   - Playwright Page interaction methods
   - Element reference resolution
   - Modal state management
   - Signal focus: Public API for tab interaction

4. `src/context.ts` - **Browser context management**
   - Tab management methods
   - Tool execution flow
   - Session management
   - Signal focus: Tab creation/selection patterns

5. `config.d.ts` - **Configuration type definitions**
   - Tool capability types
   - Configuration schema
   - Signal focus: Available configuration options

## Tool Implementation Examples (High Priority)

6. `src/tools/snapshot.ts` - **Core snapshot functionality**
   - Accessibility snapshot generation
   - Element reference system
   - Signal focus: Core patterns for tool implementation

7. `src/tools/evaluate.ts` - **JavaScript evaluation**
   - Code execution in page context
   - Safety mechanisms
   - Signal focus: Patterns for executing code in browser

8. `src/tools/navigate.ts` - **Navigation tools**
   - URL handling
   - Navigation states
   - Signal focus: Navigation completion patterns

9. `src/tools/mouse.ts` - **Input tools example**
   - Element interaction
   - Signal focus: Element reference handling

10. `src/tools/dialogs.ts` - **Modal handling**
    - Dialog and alert management
    - Signal focus: Modal state clearing patterns

## Architecture Integration (Medium Priority)

11. `src/browserServerBackend.ts` - **MCP-Playwright bridge**
    - Tool registration
    - Request handling
    - Signal focus: Initialization flow

12. `src/browserContextFactory.ts` - **Browser creation**
    - Context factory system
    - Browser lifecycle
    - Signal focus: Browser configuration options

13. `src/tools.ts` - **Tool registration**
    - Tool aggregation
    - Capability filtering
    - Signal focus: How tools are registered

14. `src/mcp/server.ts` - **Protocol implementation**
    - MCP protocol handling
    - Signal focus: Tool execution flow

15. `src/program.ts` - **Server initialization**
    - Command-line parsing
    - Server startup
    - Signal focus: Configuration options

## Extension Points (Medium Priority)

16. `src/extension/extensionContextFactory.ts` - **Extension integration**
    - Browser extension support
    - Signal focus: Extension capabilities

17. `lib/loopTools/tool.js` - **Loop tool system**
    - AI model integration tools
    - Signal focus: Extension patterns

## Testing Patterns (Lower Priority)

18. `tests/fixtures.ts` - **Test utilities**
    - Tool testing patterns
    - Signal focus: How to test new tools

19. `tests/core.spec.ts` - **Core test examples**
    - Tool validation patterns
    - Signal focus: Test patterns for features

## Documentation (Support)

20. `docs/dev_README.md` - **Developer guide**
    - Setup and workflow
    - Signal focus: Development workflows

## Signal-to-Noise Optimization Guidelines

When summarizing these files for RAG implementation:

1. **Focus on interfaces over implementations**
   - Prioritize method signatures and type definitions
   - Document parameters and return types
   - Minimize internal algorithm details

2. **Emphasize extension patterns**
   - Highlight factory methods and registration patterns
   - Document how to plug into existing abstractions
   - Show common usage patterns

3. **Document flow control patterns**
   - Note async/await usage patterns
   - Highlight error handling conventions
   - Document lifecycle hooks

4. **Capture type constraints**
   - Document Zod schema patterns
   - Note required vs optional parameters
   - Highlight capability requirements

5. **Prioritize browser automation patterns**
   - Focus on page/element interaction
   - Document navigation handling
   - Note modal dialog management

6. **Include core tool examples**
   - Provide representative examples from different tool types
   - Show both simple and complex implementations
   - Demonstrate proper response formatting

## File Summarization Template

For consistent summarization quality:

```
# [Filename]

## Purpose
[1-2 sentences on the file's role in the system]

## Key Components
- [List of main classes/functions/types]

## Core Interfaces
```typescript
// Include relevant type definitions and method signatures
```

## Usage Patterns
[Examples of how this file is used in the system]

## Extension Points
[How to extend or customize functionality in this file]

## Dependencies
[Key files this component interacts with]
```

These summaries should enable an AI assistant to:
- Understand where to implement new features
- Follow established patterns and type constraints
- Generate code that integrates properly with the system
- Recommend appropriate existing tools for related functionality
- Maintain consistency with the project's architecture
