# Port Binding Fix for Playwright MCP Extension Mode

## Problem Description

When using the Playwright MCP server with the `--extension` flag to connect to a running Chromium browser via the Bridge extension, there was a connection timeout issue caused by port binding and IPv4/IPv6 address mismatches.

### Root Causes

1. **Ignored CLI Arguments**: The `--host` and `--port` CLI arguments were completely ignored in extension mode, causing the CDP relay server to bind to a random available port instead of the specified port.

2. **Dynamic Port Allocation**: The `ExtensionContextFactory` created HTTP servers with empty configuration (`{}`), leading to unpredictable port assignments that didn't match user expectations.

3. **IPv4/IPv6 Address Mismatch**: The HTTP server could bind to IPv6 `::1` while CLI arguments specified IPv4 `127.0.0.1`, creating a connection mismatch between the browser extension and CDP client.

4. **Extension Bridge Disconnect**: The browser extension would successfully connect to the dynamically allocated port, but subsequent CDP commands would timeout due to the address/port mismatch.

## Solution Implementation

### Changes Made

#### 1. Enhanced ExtensionContextFactory Constructor
**File**: `lib/extension/extensionContextFactory.js`  
**Lines**: 21-31

```javascript
// Added _serverConfig property and constructor parameter
_serverConfig;
constructor(browserChannel, userDataDir, serverConfig = {}) {
    this._browserChannel = browserChannel;
    this._userDataDir = userDataDir;
    this._serverConfig = serverConfig;
}
```

#### 2. Updated Relay Server Configuration
**File**: `lib/extension/extensionContextFactory.js`  
**Lines**: 47-52

```javascript
// Modified to use CLI-provided host/port configuration
async _startRelay(abortSignal) {
    const serverConfig = {
        host: this._serverConfig.host || 'localhost',
        port: this._serverConfig.port
    };
    const httpServer = await startHttpServer(serverConfig);
```

#### 3. Updated Factory Creation
**File**: `lib/program.js`  
**Lines**: 99-101

```javascript
// Pass server configuration to extension context factory
function createExtensionContextFactory(config) {
    return new ExtensionContextFactory(config.browser.launchOptions.channel || 'chrome', config.browser.userDataDir, config.server);
}
```

#### 4. Enhanced IPv6 Address Normalization
**File**: `lib/utils/httpServer.js`  
**Lines**: 38-40

```javascript
// Added IPv6 localhost normalization for better compatibility
if (resolvedHost === '[::1]')
    resolvedHost = 'localhost';
```

## Benefits

- **Predictable Port Binding**: CDP relay now binds to user-specified host/port combinations
- **CLI Argument Respect**: `--host` and `--port` arguments are properly honored in extension mode
- **Cross-Platform Compatibility**: IPv6 localhost addresses are normalized for broader compatibility
- **Robust Connection Handling**: Eliminates timeout issues between extension bridge and CDP client

## Testing

The fix can be tested with the following MCP configuration:

```json
{
  "servers": {
    "playwrightLocal": {
      "type": "stdio",
      "command": "node", 
      "args": [
        "C:\\Users\\13476\\Documents\\GitHub\\playwright-mcp\\cli.js",
        "--browser=chromium",
        "--extension", 
        "--no-sandbox",
        "--host=127.0.0.1",
        "--port=9222"
      ]
    }
  }
}
```

---

## Commit Message

```
fix: respect host/port CLI args in extension mode, resolve CDP connection timeouts

- Pass server config to ExtensionContextFactory to honor --host/--port args
- Fix IPv6 localhost normalization for cross-platform compatibility  
- Eliminate random port binding that caused extension bridge disconnects
- Ensure consistent addressing between CDP relay and client connections
```