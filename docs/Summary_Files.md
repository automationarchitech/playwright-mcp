# Playwright MCP - Key Files for RAG Summarization

This document lists the most important files to summarize for a virtualized RAG system that assists with implementing features in the Playwright MCP project. These summaries will provide high-value context for AI assistants.

## Core Architecture Files

1. `src/browserServerBackend.ts` - Central component connecting MCP protocol to Playwright
2. `src/browserContextFactory.ts` - Browser context creation and management
3. `src/context.ts` - User browser session representation and management
4. `src/tab.ts` - Tab representation and Playwright Page object wrapper
5. `src/tools.ts` - Tool aggregation and registration
6. `src/response.ts` - Response formatting for MCP clients

## Protocol and Transport

7. `src/mcp/server.ts` - Model Context Protocol server implementation
8. `src/mcp/transport.ts` - Communication between client and server
9. `src/program.ts` - Command-line options and server initialization

## Tool Implementation

10. `src/tools/tool.ts` - Base tool definition and utility functions
11. `src/tools/snapshot.ts` - Accessibility snapshot tools (core functionality)
12. `src/tools/navigate.ts` - URL navigation tools
13. `src/tools/mouse.ts` - Mouse interaction tools
14. `src/tools/keyboard.ts` - Keyboard input tools
15. `src/tools/evaluate.ts` - JavaScript evaluation tools
16. `src/tools/console.ts` - Console message access tools
17. `src/tools/network.ts` - Network monitoring tools
18. `src/tools/tabs.ts` - Tab management tools

## Configuration and Types

19. `src/config.ts` - Configuration types and defaults
20. `src/actions.d.ts` - Type definitions for actions

## Testing Framework

21. `tests/fixtures.ts` - Test fixtures and utilities
22. `tests/core.spec.ts` - Core functionality tests

## Extension Points

23. `src/extension/cdpRelay.js` - Chrome DevTools Protocol relay
24. `src/extension/extensionContextFactory.js` - Extension context factory

## Additional Documentation Files

25. `docs/COPILOT_HIGH_readme.md` - Concise overview for AI assistants
26. `docs/dev_README.md` - Developer guide and examples
27. `docs/roadmap.md` - Project roadmap and future plans

## Signal-to-Noise Considerations

When summarizing these files:

1. **Focus on interfaces** over implementation details
2. **Highlight core functions** and their parameters
3. **Extract design patterns** rather than specific code blocks
4. **Identify extension points** where new features can be added
5. **Note interconnections** between components
6. **Include key configuration options** that affect behavior
7. **Omit test-specific code** and focus on public APIs
8. **Preserve error handling patterns** that should be followed

These summaries should enable an AI assistant to:
- Understand the overall architecture
- Locate where to implement new features
- Follow established patterns and conventions
- Avoid common pitfalls
- Reference appropriate existing tools
