# Local Build + Run

Using Continue.dev as client in this example. 

## 1. Server Testing

Ensure we can get a vanilla server running + Chrome loading properly

`npx playwright install chrome`

Use MCP Inspector to verify vanilla Playwright is working: 

`npx -y @modelcontextprotocol/inspector npx @playwright/mcp@latest`

Then try to navigate to any website manually via `browser_navigate` tool.

Mac: May need to configure App Permissions (i.e. allow VS Code to access)

## 2. Local Build

If we make changes to this repo (i.e. add new tools like `worker_console_messages` or `popup_console_messages`), then need to build from source!

`npm install`

`npm run build`

Now run in server mode: 

`node cli.js --port 8080`

If you want to dynamically reload, then run these simultaneously in seperate terminals

`npm run watch` 
`node cli.js --port 8080` 


## 3. Insepct Local Build

`npx -y @modelcontextprotocol/inspector node /path/to/playwright-mcp/cli.js`