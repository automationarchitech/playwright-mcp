# Playwright MCP Server - Quick Guide for LLM Development

## What This Is
A server that lets AI assistants control web browsers using Playwright. It translates AI commands into browser actions like clicking, typing, and taking screenshots.

## Core Concept
**Tools** = Individual browser actions (click, navigate, screenshot, etc.)
Each tool is a self-contained unit with:
- Input validation (what parameters it accepts)
- Action handler (what it does)
- Response format (what it returns)

## Key Directories for Adding Features

### 📍 Where to Add New Tools
`/src/tools/` - Create your tool here
`/src/tools.ts` - Register it here

### 📍 Main Flow
1. **Entry**: `cli.js` → `program.ts` (starts everything)
2. **Server**: `/src/mcp/server.ts` (receives AI requests)
3. **Backend**: `/src/browserServerBackend.ts` (routes to tools)
4. **Tools**: `/src/tools/*.ts` (perform browser actions)

## How to Guide an LLM to Add a Feature

### Example: "Add a tool to count images on a page"

Tell the LLM:
1. **Create** `/src/tools/images.ts`
2. **Copy structure** from a similar tool like `/src/tools/common.ts`
3. **Define the tool**:
   - Name: `browser_count_images`
   - Input: None needed
   - Action: Count `<img>` elements
   - Output: Number of images
4. **Register** in `/src/tools.ts` - import and add to exports
5. **Test** in `/tests/` directory

### Tool Template Structure
```typescript
// In /src/tools/yourFeature.ts
import { defineTabTool } from './tool.js';
import { z } from 'zod';

export default [
  defineTabTool({
    capability: 'core',  // or 'vision', 'pdf' for opt-in features
    schema: {
      name: 'browser_your_action',
      description: 'What it does',
      inputSchema: z.object({
        // Define inputs here
      }),
    },
    handle: async (tab, params, response) => {
      // Do the browser action
      // Send results via response.sendText()
    }
  })
];
```

## Quick Tips for LLM Instructions

✅ **DO:**
- Tell LLM to look at existing tools for patterns
- Specify which tool file to copy from
- Use `/src/tools/common.ts` as reference for basic operations
- Use `/src/tools/screenshot.ts` for image-related features

❌ **DON'T:**
- Don't modify core files unless necessary
- Don't return values directly (use Response object)
- Don't forget to register new tools in `/src/tools.ts`

## Common Modifications

| Task | Files to Modify |
|------|----------------|
| Add browser action | Create in `/src/tools/`, register in `/src/tools.ts` |
| Add CLI option | `/src/program.ts` |
| Change browser settings | `/src/browserContextFactory.ts` |
| Add config option | `/src/config.ts` and `config.d.ts` |

## Testing
- Tests go in `/tests/yourFeature.spec.ts`
- Run: `npm test`
- Build: `npm run build`

## Remember
- Tools are independent - you can add new ones without breaking others
- Follow existing patterns - the codebase is very consistent
- TypeScript will catch most errors at build time