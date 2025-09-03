# Playwright MCP - Tool Development Guide

## Introduction

This document provides a detailed guide for developers who want to create new tools for the Playwright MCP project. It covers the architecture, type constraints, file interactions, and best practices for extending the platform with new browser automation capabilities.

## Tool Architecture Overview

In Playwright MCP, a "tool" is a discrete function that enables an LLM to perform a specific browser action. Tools are defined using TypeScript and follow a structured pattern to ensure consistency and maintainability.

### Core Components in the Tool Pipeline

```
┌───────────────┐     ┌──────────────┐     ┌────────────┐     ┌─────────────┐
│ Tool Definition│────>│Context/Tab API│────>│Playwright  │────>│Browser Action│
└───────────────┘     └──────────────┘     └────────────┘     └─────────────┘
         │                    │                   │                   │
         │                    │                   │                   │
         ▼                    ▼                   ▼                   ▼
┌───────────────┐     ┌──────────────┐     ┌────────────┐     ┌─────────────┐
│Schema Validation│───>│State Management│───>│Action Execution│──>│Response Format│
└───────────────┘     └──────────────┘     └────────────┘     └─────────────┘
```

## Key Files and Their Relationships

### 1. `src/tools/tool.ts`

This is the foundation for all tools. It defines:

- Type definitions for tools
- Schema validation structure
- Helper functions for creating tools

```typescript
// Core type definitions
export type Tool<Input extends z.Schema = z.Schema> = {
  capability: ToolCapability;         // Feature capability required (core, vision, etc.)
  schema: ToolSchema<Input>;          // Schema definition for tool (name, params, etc.)
  handle: (context: Context, params: z.output<Input>, response: Response) => Promise<void>;
};

// Helper functions for creating tools
export function defineTool<Input extends z.Schema>(tool: Tool<Input>): Tool<Input> {
  return tool;
}

export function defineTabTool<Input extends z.Schema>(tool: TabTool<Input>): Tool<Input> {
  // Implements tab-specific logic, error handling, and modal state management
  // Converts a TabTool to a regular Tool
}
```

### 2. `src/tools.ts`

Aggregates all available tools and provides filtering capabilities:

```typescript
// Imports all tool modules
import common from './tools/common.js';
import console from './tools/console.js';
import dialogs from './tools/dialogs.js';
// ... more imports

// Exports a combined list of all tools
export const allTools: Tool<any>[] = [
  ...common,
  ...console,
  ...dialogs,
  // ... more tool groups
];

// Filters tools based on configuration
export function filteredTools(config: FullConfig): Tool[] {
  // Filter logic based on capabilities
}
```

### 3. Individual Tool Files (e.g., `src/tools/mouse.ts`)

Each tool file contains implementations for related functionality:

```typescript
// Example tool definition (simplified)
const mouseClick = defineTabTool({
  capability: 'vision',                   // Capability required for this tool
  schema: {                               // Tool schema definition
    name: 'browser_mouse_click_xy',       // Unique tool name
    title: 'Click',                       // Human-readable title
    description: '...',                   // Description for LLMs
    inputSchema: z.object({...}),         // Parameter validation using Zod
    type: 'destructive',                  // Tool behavior classification
  },
  handle: async (tab, params, response) => {
    // Implementation logic using Playwright APIs
    await tab.waitForCompletion(async () => {
      await tab.page.mouse.move(params.x, params.y);
      await tab.page.mouse.down();
      await tab.page.mouse.up();
    });
    
    // Response formatting
    response.setIncludeSnapshot();
    response.addCode(`// Click code example`);
  },
});
```

## Key Types and Interfaces

### Schema Definition (Zod)

The project uses [Zod](https://github.com/colinhacks/zod) for runtime type validation:

```typescript
// Example schema for a mouse click tool
inputSchema: z.object({
  element: z.string().describe('Human-readable element description'),
  x: z.number().describe('X coordinate'),
  y: z.number().describe('Y coordinate'),
})
```

### Tool Types

1. **Regular Tool** - Operates at the context level:
   ```typescript
   type Tool<Input extends z.Schema> = {
     capability: ToolCapability;
     schema: ToolSchema<Input>;
     handle: (context: Context, params: z.output<Input>, response: Response) => Promise<void>;
   };
   ```

2. **Tab Tool** - Operates on a specific browser tab:
   ```typescript
   type TabTool<Input extends z.Schema> = {
     capability: ToolCapability;
     schema: ToolSchema<Input>;
     clearsModalState?: ModalState['type'];
     handle: (tab: Tab, params: z.output<Input>, response: Response) => Promise<void>;
   };
   ```

### Context and Tab APIs

Tools interact with these core classes:

1. **Context** (`src/context.ts`):
   - Manages browser sessions
   - Handles tab creation and selection
   - Provides access to browser context

2. **Tab** (`src/tab.ts`):
   - Wraps Playwright Page objects
   - Manages page state and events
   - Provides snapshot generation
   - Handles modal dialogs

3. **Response** (`src/response.ts`):
   - Collects results from tool executions
   - Formats output for the LLM
   - Manages snapshot inclusion
   - Handles error reporting

## Creating a New Tool: Step-by-Step Guide

### 1. Determine the Tool Type

Decide whether your tool should be:
- A **Context Tool** (operates at browser level) using `defineTool`
- A **Tab Tool** (operates on specific tabs) using `defineTabTool`

### 2. Choose the Appropriate File

Place your tool in an existing file if it fits with existing functionality, or create a new file in `src/tools/` for distinct capabilities.

### 3. Define Your Tool Schema

```typescript
// Example schema definition
const schema = {
  name: 'browser_my_new_tool',           // Tool name (unique identifier)
  title: 'My New Tool',                  // User-friendly name
  description: 'Description for LLMs',   // Detailed explanation
  inputSchema: z.object({                // Parameters with Zod validation
    param1: z.string().describe('Parameter description'),
    param2: z.number().optional().describe('Optional parameter'),
  }),
  type: 'readOnly',                      // 'readOnly' or 'destructive'
};
```

### 4. Implement the Handler Function

```typescript
// Example handler implementation
const handle = async (tab, params, response) => {
  try {
    // 1. Perform the browser action using Playwright
    await tab.waitForCompletion(async () => {
      // Your Playwright code here
      await tab.page.someAction(params.param1);
    });

    // 2. Format the response
    response.setIncludeSnapshot();  // Include page snapshot if needed
    
    // 3. Add example code for future reference
    response.addCode(`// Example code for ${params.param1}`);
    response.addCode(`await page.someAction('${params.param1}');`);
    
    // 4. Add human-readable result (optional)
    response.addResult(`Successfully performed action with ${params.param1}`);
  } catch (error) {
    // Handle errors appropriately
    response.addError(`Failed to perform action: ${error.message}`);
  }
};
```

### 5. Export Your Tool

```typescript
// Create and export the tool
export default [
  defineTabTool({
    capability: 'core',   // 'core', 'vision', 'pdf', etc.
    schema,
    handle,
  })
];
```

### 6. Register Your Tool

Add your tool to `src/tools.ts`:

```typescript
import myNewTool from './tools/myNewTool.js';

export const allTools: Tool<any>[] = [
  // Existing tools...
  ...myNewTool,
];
```

## Type Constraints and Best Practices

### Required Tool Properties

1. **`capability`**: Must be one of the defined `ToolCapability` types in `config.ts`:
   - `'core'` - Basic browser functionality
   - `'vision'` - Visual/coordinate-based interactions
   - `'pdf'` - PDF manipulation
   - Custom capabilities can be added in the config

2. **`schema.type`**:
   - `'readOnly'` - Tools that don't modify page state
   - `'destructive'` - Tools that modify page state

3. **`schema.name`**:
   - Must be unique across all tools
   - Should follow the naming convention: `browser_category_action`

### Modal State Handling

Tools that interact with modal dialogs (file pickers, alerts) should:

1. Use the `clearsModalState` property to indicate which modal type they handle
2. Check for modal state before performing actions
3. Clear modal state after handling

```typescript
const fileUploadTool = defineTabTool({
  // ...
  clearsModalState: 'fileChooser',
  handle: async (tab, params, response) => {
    const modalState = tab.modalStates()[0];
    if (modalState.type !== 'fileChooser')
      return response.addError('No file chooser present');
    
    // Handle file upload
    await modalState.fileChooser.setFiles(params.filePath);
  }
});
```

### Response Formatting

Always use the Response object appropriately:

1. `response.setIncludeSnapshot()` - Include page snapshot after tool execution
2. `response.addCode()` - Add example code for the performed action
3. `response.addResult()` - Add human-readable result explanation
4. `response.addError()` - Report errors in a standardized way

### Handling Asynchronous Operations

Use the Tab's `waitForCompletion` method to properly handle asynchronous operations and network activity:

```typescript
await tab.waitForCompletion(async () => {
  await tab.page.click('button');
  // This will wait for the action and subsequent network activity to complete
});
```

## Testing Your Tool

1. Add tests in the `tests/` directory
2. Run tests with: `npm run test`
3. Test with specific browsers: `npm run ctest` (Chrome), `npm run ftest` (Firefox)

## Advanced Tool Patterns

### Combining Multiple Playwright Actions

```typescript
// Example of a tool that combines multiple actions
const loginTool = defineTabTool({
  // ...
  handle: async (tab, params, response) => {
    await tab.waitForCompletion(async () => {
      await tab.page.fill('input[name="username"]', params.username);
      await tab.page.fill('input[name="password"]', params.password);
      await tab.page.click('button[type="submit"]');
    });
    
    response.setIncludeSnapshot();
  }
});
```

### Conditional Tool Behavior

```typescript
// Example of a tool with conditional behavior
const submitFormTool = defineTabTool({
  // ...
  handle: async (tab, params, response) => {
    // Check for form existence
    const formExists = await tab.page.isVisible('form');
    if (!formExists) {
      return response.addError('No form found on the page');
    }
    
    // Perform action based on form type
    const formType = await tab.page.getAttribute('form', 'data-type');
    if (formType === 'search') {
      // Handle search form
    } else {
      // Handle other form types
    }
    
    response.setIncludeSnapshot();
  }
});
```

## Debugging Tools

When developing new tools:

1. Use the debug module for logging:
   ```typescript
   import debug from 'debug';
   const toolDebug = debug('pw:mcp:my-tool');
   
   // Later in your code
   toolDebug('Processing params:', params);
   ```

2. Run with debug enabled:
   ```
   DEBUG=pw:mcp:* npx @playwright/mcp
   ```

3. Check the session log if enabled:
   ```typescript
   this.sessionLog?.appendEvent('tool', { ... });
   ```

## Configuration and Capabilities

Tool capabilities are controlled by the Playwright MCP configuration:

```typescript
// Example configuration
const config: FullConfig = {
  // Browser configuration
  browser: {
    browserName: 'chromium',
    launchOptions: { /* ... */ },
    contextOptions: { /* ... */ },
  },
  // Tool capabilities
  capabilities: ['core', 'vision', 'pdf'],
  // Network settings
  network: { /* ... */ },
};
```

Only tools with capabilities included in the configuration will be available to clients.

## Common Patterns and Examples

### Element Interaction Pattern

```typescript
// Common pattern for element interaction tools
const elementTool = defineTabTool({
  // ...
  handle: async (tab, params, response) => {
    response.setIncludeSnapshot();
    
    // Find element by selector or accessibility properties
    const element = await tab.page.locator(selector).first();
    
    // Perform action
    await tab.waitForCompletion(async () => {
      await element.someAction();
    });
    
    // Format response
    response.addCode(`await page.locator('${selector}').someAction();`);
  }
});
```

### Screenshot Pattern

```typescript
// Common pattern for screenshot tools
const screenshotTool = defineTabTool({
  // ...
  handle: async (tab, params, response) => {
    // Take screenshot
    const buffer = await tab.page.screenshot({
      path: params.filename,
      fullPage: params.fullPage,
    });
    
    // Add to response
    response.addImage({
      contentType: 'image/png',
      data: buffer,
    });
    
    response.addCode(`await page.screenshot({ path: '${params.filename}' });`);
  }
});
```

## Conclusion

Creating tools for Playwright MCP involves understanding the architecture, type constraints, and interaction patterns. By following this guide, you should be able to develop and integrate new browser automation capabilities that work effectively with LLMs through the Model Context Protocol.

Remember that well-designed tools should:
1. Have clear, specific functionality
2. Handle errors gracefully
3. Provide helpful feedback to the LLM
4. Include example code for future reference
5. Follow consistent naming and parameter conventions

For further details, refer to the existing tool implementations in the codebase and the Playwright API documentation.
