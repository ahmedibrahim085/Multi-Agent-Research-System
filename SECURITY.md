# Security Policy

## Supported Versions

We release patches for security vulnerabilities in the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

**DO NOT** report security vulnerabilities through public GitHub issues.

Instead, please report them privately:

1. Email: ahmedibrahim085@gmail.com
2. Response time: 48 hours
3. Disclosure timeline: We aim to patch and disclose within 90 days

Please include:

- Type of vulnerability
- Full paths of affected files
- Location of affected source code
- Step-by-step reproduction instructions
- Proof-of-concept code (if applicable)
- Impact assessment

## Security Best Practices

When using this system:

1. **MCP Server Security**:
   - Only use trusted MCP servers
   - Review MCP server permissions
   - Rotate API keys regularly (Exa, Brave Search)

2. **Research Data Privacy**:
   - Research outputs in `docs/research-sessions/` may contain sensitive information
   - Review before sharing or committing
   - Use `.gitignore` patterns for sensitive queries

3. **Hook Security**:
   - Review custom hooks before installation
   - Hooks have access to all tool outputs
   - Avoid storing credentials in hook scripts

4. **Memory MCP**:
   - Memory data stored locally in `~/.local/share/mcp/memory/`
   - Contains all research entities and relations
   - Back up regularly if contains critical information

## Acknowledgments

We thank the security research community for responsible disclosure.
