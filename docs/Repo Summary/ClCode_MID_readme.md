# Playwright MCP Server - Detailed Tool Creation Guide

## 📋 Table of Contents
1. [Tool Architecture](#tool-architecture)
2. [Type System & Constraints](#type-system--constraints)
3. [File Interactions & Data Flow](#file-interactions--data-flow)
4. [Response Object Pattern](#response-object-pattern)
5. [Tool Implementation Steps](#tool-implementation-steps)
6. [Advanced Patterns](#advanced-patterns)
7. [Error Handling](#error-handling)

## Tool Architecture

### Tool Types
There are two main tool types, each serving different scopes:

#### 1. **Context Tools** (`defineTool`)
- Operate at browser/context level
- Access to entire browser context
- Used for: closing browser, managing contexts, global operations

#### 2. **Tab Tools** (`defineTabTool`)
- Operate on specific tabs/pages
- Most common tool type
- Used for: clicking, navigating, screenshots, page interactions

### Tool Structure
```typescript
interface Tool<Input> {
  capability: ToolCapability;  // 'core' | 'vision' | 'pdf' | etc.
  schema: ToolSchema<Input>;   // Tool metadata and validation
  handle: HandlerFunction;      // Execution logic
  clearsModalState?: ModalType; // Optional: clears dialogs/file choosers
}
```

## Type System & Constraints

### Input Validation with Zod

Tools use Zod schemas for runtime validation and type inference:

```typescript
import { z } from 'zod';

// Basic schema
const simpleSchema = z.object({
  url: z.string().url(),
  timeout: z.number().optional().default(5000)
});

// Advanced schema with refinements
const complexSchema = z.object({
  element: z.string().optional(),
  ref: z.string().optional(),
  fullPage: z.boolean().optional()
}).refine(data => {
  // Custom validation: both or neither
  return !!data.element === !!data.ref;
}, {
  message: 'Both element and ref must be provided or neither.',
  path: ['ref', 'element']
});
```

### Type Constraints

#### ToolCapability
```typescript
type ToolCapability = 'core' | 'vision' | 'pdf' | 'tabs' | 'network';
```
- `core`: Always available
- Others: Require opt-in via `--caps` flag

#### ToolSchema Properties
```typescript
{
  name: string;        // Unique identifier (browser_*)
  title: string;       // Human-readable title
  description: string; // Detailed description for AI
  inputSchema: z.Schema; // Zod validation schema
  type: 'readOnly' | 'destructive'; // Tool classification
}
```

## File Interactions & Data Flow

### Complete Request Flow

```
1. MCP Client Request
   ↓
2. /src/mcp/server.ts (receives tool call)
   - Validates against registered tools
   - Calls backend.callTool()
   ↓
3. /src/browserServerBackend.ts
   - Creates Response object
   - Routes to appropriate tool handler
   - Manages session logging
   ↓
4. /src/context.ts or /src/tab.ts
   - Provides browser/tab access
   - Manages state and lifecycle
   ↓
5. /src/tools/*.ts (your tool)
   - Executes browser automation
   - Writes to Response object
   ↓
6. /src/response.ts
   - Collects results, code, images
   - Handles snapshots if requested
   - Serializes for MCP response
```

### Key Object Relationships

#### Context Object
```typescript
class Context {
  tabs(): Tab[]              // All open tabs
  currentTab(): Tab | null   // Active tab
  newTab(): Promise<Tab>     // Create new tab
  outputFile(name): string   // Get output path
  closeBrowserContext()      // Close browser
}
```

#### Tab Object
```typescript
class Tab {
  page: playwright.Page      // Playwright page object
  context: Context          // Parent context
  modalStates(): ModalState[] // Active dialogs/choosers
  captureSnapshot(): TabSnapshot // DOM snapshot
  navigate(url): Promise<void>
  waitForCompletion(fn): Promise<void> // Race against modals
}
```

## Response Object Pattern

### Never Return Values Directly

Tools communicate through the Response object, never via return values:

```typescript
// ❌ WRONG
handle: async (tab, params) => {
  const title = await tab.page.title();
  return title; // Never do this!
}

// ✅ CORRECT
handle: async (tab, params, response) => {
  const title = await tab.page.title();
  response.addResult(`Page title: ${title}`);
  response.addCode(`await page.title()`);
}
```

### Response Methods

```typescript
class Response {
  // Text output
  addResult(text: string)     // Add success message
  addError(text: string)       // Add error message
  
  // Code generation
  addCode(code: string)        // Add Playwright code
  
  // Media
  addImage(image: {            // Add image to response
    contentType: string,
    data: Buffer
  })
  
  // State flags
  setIncludeSnapshot()         // Include DOM snapshot
  setIncludeTabs()            // Include tab list
}
```

## Tool Implementation Steps

### Step-by-Step Guide

#### 1. Create Tool File
```typescript
// /src/tools/myFeature.ts
import { z } from 'zod';
import { defineTabTool } from './tool.js';
```

#### 2. Define Input Schema
```typescript
const mySchema = z.object({
  selector: z.string().describe('CSS selector to find elements'),
  action: z.enum(['count', 'list']).describe('What to do'),
  timeout: z.number().optional().default(3000)
});
```

#### 3. Implement Tool
```typescript
const myTool = defineTabTool({
  capability: 'core',
  
  schema: {
    name: 'browser_my_action',
    title: 'My Custom Action',
    description: 'Detailed description for AI context',
    inputSchema: mySchema,
    type: 'readOnly',  // or 'destructive' for modifications
  },
  
  handle: async (tab, params, response) => {
    // 1. Generate code for reproducibility
    response.addCode(`// Finding elements with selector: ${params.selector}`);
    
    // 2. Perform the action
    await tab.waitForCompletion(async () => {
      const elements = await tab.page.$$(params.selector);
      
      if (params.action === 'count') {
        response.addResult(`Found ${elements.length} elements`);
        response.addCode(`await page.$$('${params.selector}').length`);
      } else {
        const texts = await Promise.all(
          elements.map(el => el.textContent())
        );
        response.addResult(`Elements:\n${texts.join('\n')}`);
      }
    });
    
    // 3. Include snapshot if useful
    response.setIncludeSnapshot();
  }
});
```

#### 4. Export Tool
```typescript
export default [myTool];
```

#### 5. Register in tools.ts
```typescript
// /src/tools.ts
import myFeature from './tools/myFeature.js';

export const allTools: Tool<any>[] = [
  ...existing,
  ...myFeature,  // Add here
];
```

## Advanced Patterns

### Modal State Handling

Tools can clear modal states (dialogs, file choosers):

```typescript
defineTabTool({
  clearsModalState: 'dialog',  // Automatically handles dialogs
  schema: { /* ... */ },
  handle: async (tab, params, response) => {
    // Dialog will be auto-dismissed if present
  }
});
```

### Race Against Modal States

Prevent blocking by modal dialogs:

```typescript
await tab.waitForCompletion(async () => {
  // This races against modal states
  // If dialog appears, operation stops
  await tab.page.click('button');
});
```

### Element References

Tools can work with element references from snapshots:

```typescript
const schema = z.object({
  element: z.string(),  // Human description
  ref: z.string(),      // Snapshot reference
});

handle: async (tab, params, response) => {
  const locator = await tab.refLocator({
    element: params.element,
    ref: params.ref
  });
  await locator.click();
}
```

### File Output

Save files to the output directory:

```typescript
handle: async (tab, params, response) => {
  const filePath = await tab.context.outputFile('data.json');
  await fs.writeFile(filePath, JSON.stringify(data));
  response.addResult(`Saved to ${filePath}`);
}
```

## Error Handling

### Proper Error Patterns

```typescript
handle: async (tab, params, response) => {
  try {
    await tab.page.click(params.selector);
    response.addResult('Clicked successfully');
  } catch (error) {
    // Use addError for tool errors
    response.addError(`Failed to click: ${error.message}`);
    // Error flag is automatically set
  }
}
```

### Timeout Handling

```typescript
handle: async (tab, params, response) => {
  try {
    await tab.page.waitForSelector(params.selector, {
      timeout: params.timeout || 5000
    });
  } catch (e) {
    if (e.name === 'TimeoutError') {
      response.addError(`Element not found within ${params.timeout}ms`);
    } else {
      throw e;  // Re-throw unexpected errors
    }
  }
}
```

### Validation Errors

Zod automatically validates inputs before handler is called:
- Invalid inputs never reach your handler
- Error messages are automatically generated
- Type inference ensures type safety

## Best Practices

1. **Always use `waitForCompletion`** for operations that might trigger modals
2. **Generate code** with `addCode()` for reproducibility
3. **Include snapshots** when state changes occur
4. **Validate early** using Zod refinements
5. **Handle timeouts** gracefully with clear messages
6. **Use descriptive names** following `browser_*` convention
7. **Document parameters** with `.describe()` in schemas
8. **Test edge cases** including modal states and errors

## Common Pitfalls

❌ **Don't**:
- Return values from handlers
- Forget to register in tools.ts
- Use raw Playwright without error handling
- Ignore modal states
- Skip code generation

✅ **Do**:
- Use Response object exclusively
- Handle all error cases
- Generate reproducible code
- Test with dialogs/file choosers
- Document thoroughly

## Testing Your Tool

Create a test file: `/tests/myFeature.spec.ts`

```typescript
import { test, expect } from './harness.js';

test('browser_my_action counts elements', async ({ mcpServer }) => {
  const response = await mcpServer.callTool('browser_my_action', {
    selector: '.item',
    action: 'count'
  });
  
  expect(response.content[0].text).toContain('Found 5 elements');
});
```