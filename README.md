# ci-templates

Continuous Integration templates for Security and Quality. These snippets are steps to automatically check security and quality in your projects.

## Git

- Lint your commit messages with [commitlint](./lint/commit-lint.yml)
- Lint your workflow files with [actionlint](./lint/action-lint.yml)
- Pin you Github action by commit with [action-pin](./lint/action-pin.yml)

## Docker

- Lint your dockerfile with [hadolint](./lint/hadolint.yml)
- Test your dockerfile security with [trivy](./security/trivy.yml)

## Helm

- Lint your charts with [helm lint](./lint/helm-lint.yml)

## Broken links

- Test broken links in markdown with [linkchecker](./checker/linkchecker.yml)
