# Github CI templates

Continuous Integration templates for Security and Quality. These snippets are steps to automatically check security and quality in your projects.

## Git

- Lint your commit messages with [commitlint](./lint/commit-lint.yml)
- Lint your workflow files with [actionlint](./lint/action-lint.yml)
- Pin your Github actions by commit with [action-pin](./lint/action-pin.yml)
- Check commit signature in PR with [check-signed-commits-action](./security/commit-sign.yml)

## Docker

- Lint your dockerfile with [hadolint](./lint/hadolint.yml)

> [!TIP]
> you could add exception on a particular line of your dockerfile with `# hadolint ignore=DL3041`

- Test your dockerfile security with [trivy](./security/trivy.yml)

## Helm

- Lint your charts with [helm lint](./lint/helm-lint.yml)

## Broken links

- Test broken links in markdown with [linkchecker](./checker/linkchecker.yml)
