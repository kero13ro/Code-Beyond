# Exploring Claude Code + MCP Servers Integration

Recently experimented with integrating MCP (Model Context Protocol) servers into Claude Code. These are my exploration notes on what works, what doesn't, and what might be possible.

![[Pasted image 20250930140312.png]]

## What Can MCP Actually Do?

The core idea of MCP is enabling AI to directly connect with external tools and data sources. In theory, it sounds powerful. In practice, there are some interesting limitations and even more interesting possibilities.

Here's what I've tested so far:

### Chrome DevTools MCP

This one is genuinely useful. Claude can directly analyze web performance, inspect console errors, and capture network requests. No more taking screenshots and pasting them into the conversation.

**What this enables:**
- Real-time debugging without context switching
- Performance analysis with immediate code suggestions
- Automated accessibility audits
- Network request inspection for API debugging

The workflow becomes significantly smoother when you can just say "check why this page is slow" and Claude can actually see the performance metrics.

### Figma MCP - Interesting but Limited

This is where I spent most of my testing time. The results are mixed but revealing.

**What works well:**
- Extracting design tokens (colors, typography, spacing)
- Basic layout information and component settings
- Simple structural hierarchies

**Where it breaks down:**
- Complex gradient borders → **completely broken**
- After investigating, Figma's own export parameters are flawed
- MCP faithfully passes the incorrect data to Claude
- Results in CSS styles that don't match the design

This reveals something important: MCP is only as good as the data source. For simple design-to-code conversions, it works. Complex effects still require manual refinement.

**But the potential is there:** Imagine a custom MCP server that wraps Figma's API with post-processing to fix these known issues, or one that enforces design system constraints before passing data to Claude.

### GitHub MCP - Powerful but Permission-Heavy

Direct repository access, issue creation, and PR management from Claude. The integration is smooth.

**Security consideration:**
The required GitHub token needs full repo access, which means:
- Read all private repositories
- Push code
- Modify settings

For personal projects, this is manageable. For company projects, this is a significant security concern. This points to an interesting research direction: could we build a proxy MCP server that implements fine-grained permission control?

### Atlassian MCP (Jira/Confluence)

Ticket creation and queries work smoothly. Similar token permission concerns as GitHub.

**Interesting use case I'm exploring:** Automated documentation updates. When code changes, could we automatically update related Confluence pages? The integration is there; the workflow patterns need refinement.

## Configuration

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["chrome-devtools-mcp@latest"]
    },
    "figma": {
      "type": "sse",
      "url": "http://127.0.0.1:3845/sse"
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxxx"
      }
    }
  }
}
```

Note: For Figma, enable "Dev Mode MCP Server" in the desktop app preferences.

## What I've Learned

MCP's direction is right. The current implementation has rough edges, but those edges reveal opportunities.

**Strengths:**
- Seamless integration reduces context switching
- Chrome DevTools integration is genuinely productive
- The protocol itself is extensible and well-designed
- Opens up entirely new workflows (design → code → deploy → monitor in one conversation)

**Current limitations:**
- Third-party data quality varies (Figma gradient issue is just one example)
- Permission models are coarse-grained
- No built-in data filtering or compression at the protocol level
- Token consumption can be significant with large data sources

## Promising Directions to Explore

### 1. Custom MCP Servers

The protocol is open. This means we can build specialized servers for:

- **Internal design systems:** Pre-processed, validated design data
- **API documentation:** Context-aware API reference with usage examples
- **Test databases:** Realistic test data generation based on schema
- **Build systems:** Real-time build output and error analysis
- **Analytics platforms:** Connect development decisions to user behavior data

The key insight: control the data pipeline, control the quality.

### 2. Intelligent Data Filtering

MCP servers could implement smart filtering strategies:

- Summarize large datasets before sending to Claude
- Cache frequently requested data
- Progressive loading (send overview first, details on demand)
- Schema-aware compression

This is particularly relevant for large codebases or extensive design systems.

### 3. Workflow Orchestration

Combining multiple MCP servers enables complex workflows:

**Example:** Design review automation
1. Figma MCP → Extract design changes
2. GitHub MCP → Compare with existing components
3. Custom component library MCP → Suggest reusable alternatives
4. Atlassian MCP → Generate design review ticket with comparisons

**Example:** Performance regression detection
1. GitHub MCP → Detect code changes
2. Chrome DevTools MCP → Run performance audit
3. Custom metrics MCP → Compare against baseline
4. Slack MCP (hypothetical) → Notify team if regression detected

### 4. Fine-Grained Security Models

Current token-based authentication is binary. More nuanced approaches:

- GitHub Apps instead of personal access tokens (limited scope)
- Proxy MCP servers that implement role-based access
- Audit logging for all MCP operations
- Temporary, operation-specific tokens

This would make MCP viable for enterprise environments.

### 5. Data Quality Layers

For problematic integrations like Figma:

- Build a post-processing MCP proxy
- Known issues (like gradient borders) get corrected before reaching Claude
- Enforce design system constraints
- Validate data against schemas

Essentially, create a "smart adapter" layer between the raw API and MCP.

### 6. Domain-Specific Assistants

MCP enables specialized AI workflows:

- **DevOps assistant:** Connects to logs, metrics, deployment systems
- **Documentation assistant:** Syncs between code, docs, and support tickets
- **Accessibility assistant:** Combines Chrome DevTools, design files, and WCAG guidelines
- **Performance assistant:** Links code analysis, runtime metrics, and user impact

Each domain benefits from a curated set of MCP servers.

## Observations

The most interesting aspect of MCP isn't the individual integrations—it's the **composability**. Each MCP server adds context, and Claude can synthesize across all of them.

This shifts the question from "can AI write code?" to "what context does AI need to make good decisions?"

The protocol is young. The rough edges (data quality, token usage, security) are solvable. The underlying idea—giving AI structured access to the tools developers use—feels like the right abstraction.

I'm particularly curious about:
- Custom MCP servers for internal tools
- Workflow orchestration patterns
- How teams adopt and govern MCP usage
- What new development patterns emerge when context is unlimited

![[Pasted image 20250930142154.png]]

---

*These notes are evolving as I experiment further. If you're exploring MCP, I'd be interested in comparing notes.*