# Github CI templates

Continuous Integration templates for Security and Quality. These snippets are steps to automatically check security and quality in your projects.

## Git

- Lint your commit messages with [commitlint](./lint/commit-lint.yml)
- Lint your workflow files with [actionlint](./lint/action-lint.yml) and [zizmor](./lint/zizmor.yml)
- Pin your Github actions by commit with [action-pin](./lint/action-pin.yml)
- Check commit signature in PR with [check-signed-commits-action](./security/commit-sign.yml)

## Docker

- Lint your dockerfile with [hadolint](./lint/hadolint.yml)

> [!TIP]
> you could add exception on a particular line of your dockerfile with `# hadolint ignore=DL3041`

- Test your dockerfile security with [trivy](./security/trivy.yml)

## IaC

- Scan your IaC files with [trivy-iac](./security/trivy-iac.yml)

> [!TIP]
> Trivy has no built-in rules for some providers. The action adds shared rules for Scaleway and Nebius from [checks](./.github/actions/trivy-iac/checks). Add your own Rego rules with the `extra-checks` input, and skip a finding with `# trivy:ignore:<ID> <reason>` on the line before the block. By default, the action scans all IaC types (Dockerfile, Helm, Kubernetes, Terraform, ...). Start with `exit-code: '0'` to see the findings, or limit the scan with `misconfig-scanners: 'terraform'`.

## Helm

- Lint your charts with [helm lint](./lint/helm-lint.yml)

## Broken links

- Test broken links in markdown with [linkchecker](./checker/linkchecker.yml)
