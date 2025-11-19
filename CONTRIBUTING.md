# Contributing to Multi-Agent Research System

Thank you for considering contributing! This document provides guidelines for contributing to this project.

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md).

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check existing issues. When creating a bug report, include:

- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Environment details (Claude Code version, OS, MCP servers)
- Relevant logs from `project_logs/`

Use the bug report template when creating issues.

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- Clear description of the enhancement
- Use cases and motivation
- Example implementation (if applicable)

### Pull Requests

1. **Fork the repository** and create a branch from `main`
2. **Make your changes** following project conventions
3. **Add tests** if applicable
4. **Update documentation** (README, CHANGELOG)
5. **Ensure tests pass** (if test suite exists)
6. **Follow commit message conventions**: `type: description`
   - `feat`: New feature
   - `fix`: Bug fix
   - `docs`: Documentation changes
   - `refactor`: Code refactoring
   - `test`: Adding tests
   - `chore`: Maintenance tasks
7. **Submit pull request** with clear description

## Development Setup

See [README.md](README.md) for installation and setup instructions.

## Project Structure

```
.claude/
├── agents/        # Research agent definitions
├── skills/        # Orchestration skills
└── hooks/         # Lifecycle hooks

docs/              # Documentation
project_logs/      # Runtime logs (gitignored)
```

## Style Guidelines

### Agent Development

- Follow existing agent patterns (see `.claude/agents/`)
- Include comprehensive prompt documentation
- Specify `allowed-tools` explicitly
- Add agent to registry: `.claude/skills/research/research-agents-registry.json`

### Skill Development

- Use YAML frontmatter in SKILL.md
- Progressive disclosure (Quick Start → Deep Dive)
- Include concrete examples
- Document when to use (and when NOT to use)

### Documentation

- Update README.md for user-facing changes
- Update CHANGELOG.md for all releases
- Include examples for new features
- Keep documentation concise and scannable

## Questions?

Feel free to open an issue for questions or reach out to maintainers.

## License

By contributing, you agree that your contributions will be licensed under the Apache 2.0 License.
