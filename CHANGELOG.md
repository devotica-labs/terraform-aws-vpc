# Changelog

Managed by [release-please](https://github.com/googleapis/release-please).
Do not edit manually — use Conventional Commits in PR titles.

## [0.7.1](https://github.com/devotica-labs/terraform-aws-vpc/compare/v0.7.0...v0.7.1) (2026-06-25)


### Bug Fixes

* scope interface endpoint SG egress to VPC CIDR instead of 0.0.0.0/0 ([0a9963a](https://github.com/devotica-labs/terraform-aws-vpc/commit/0a9963a4e131f8435e4bb5aa9c09b1e0500c3562))
* scope interface endpoint SG egress to VPC CIDR instead of 0.0.0.0/0 ([e04cad8](https://github.com/devotica-labs/terraform-aws-vpc/commit/e04cad84b0d8fa38d055e450afe7f0d18f96fbe6))

## [0.7.0](https://github.com/devotica-labs/terraform-aws-vpc/compare/v0.6.2...v0.7.0) (2026-06-24)


### Features

* add isolated database subnet tier and interface VPC endpoints ([#44](https://github.com/devotica-labs/terraform-aws-vpc/issues/44)) ([93c176f](https://github.com/devotica-labs/terraform-aws-vpc/commit/93c176f7428544643fc8c94329f6af44808e0fdb))

## [0.6.2](https://github.com/devotica-labs/terraform-aws-vpc/compare/v0.6.1...v0.6.2) (2026-06-17)


### Bug Fixes

* **release:** replace dead CycloneDX action with anchore/sbom-action ([#37](https://github.com/devotica-labs/terraform-aws-vpc/issues/37)) ([c282199](https://github.com/devotica-labs/terraform-aws-vpc/commit/c282199ac38feb1c4af099c3810035527e7614f8))

## [0.6.1](https://github.com/devotica-labs/terraform-aws-vpc/compare/v0.6.0...v0.6.1) (2026-06-15)


### Bug Fixes

* **examples:** terraform fmt + match published version constraint ([b697604](https://github.com/devotica-labs/terraform-aws-vpc/commit/b697604d46dae7502f92b495581a97012fd9574f))

## [0.6.0](https://github.com/devotica-labs/terraform-aws-vpc/compare/v0.5.0...v0.6.0) (2026-05-12)


### Features

* **endpoints:** add S3 and DynamoDB gateway VPC endpoints (free, opt-in) ([f4db283](https://github.com/devotica-labs/terraform-aws-vpc/commit/f4db28399a5c52cf0a7b6f2c379e17d37d66ff17))
* **flow-logs:** custom log format string for fintech audit capture ([96af742](https://github.com/devotica-labs/terraform-aws-vpc/commit/96af742289e0632b47b4069f83931e5c15186b18))
* **flow-logs:** support S3 destination as alternative to CloudWatch Logs ([d9a9d43](https://github.com/devotica-labs/terraform-aws-vpc/commit/d9a9d432cb6fc47a510c645c1e10ec682c66a65a))
* **routes:** add additional_public_routes and additional_private_routes inputs ([651d815](https://github.com/devotica-labs/terraform-aws-vpc/commit/651d8150eab92930e9bc52ace8b7c331da4fbdc3))
* **subnets:** per-tier subnet tags for EKS/ELB discovery ([5b1eaff](https://github.com/devotica-labs/terraform-aws-vpc/commit/5b1eafff01b5ca60a1f601948cd15741015c19d5))


### Bug Fixes

* **endpoints:** use data.aws_region.current.region (AWS provider v6) ([d5317cc](https://github.com/devotica-labs/terraform-aws-vpc/commit/d5317cce5d84268dde8b45b33bb8f29e2e8350dd))

## [0.5.0](https://github.com/devotica-labs/terraform-aws-vpc/compare/v0.4.3...v0.5.0) (2026-05-12)


### Features

* **docs:** auto-generate AWS architecture diagram from terraform plan ([78dc53c](https://github.com/devotica-labs/terraform-aws-vpc/commit/78dc53c92c6fb9d92e9d979d16c77cd1ccd8b746))
* **docs:** auto-generate AWS architecture diagram from terraform plan ([f854009](https://github.com/devotica-labs/terraform-aws-vpc/commit/f8540098c96f6e5a4e05ad29011ecbc291ddca7b))

## [0.4.3](https://github.com/devotica-labs/terraform-aws-vpc/compare/v0.4.2...v0.4.3) (2026-05-12)


### Bug Fixes

* **examples:** add Foundation Plan §15.2 six-tag set to module callers ([745102c](https://github.com/devotica-labs/terraform-aws-vpc/commit/745102c3d377142dc35ba276f425c1b67aac3f59))
* **examples:** add Foundation Plan §15.2 six-tag set to module callers ([9fdebf2](https://github.com/devotica-labs/terraform-aws-vpc/commit/9fdebf2a488e32a6daa48af418bb6b8f67251378))

## [0.4.2](https://github.com/devotica-labs/terraform-aws-vpc/compare/v0.4.1...v0.4.2) (2026-05-12)


### Bug Fixes

* **examples:** add provider 'aws' block with skip_* flags + placeholder creds ([a359ff4](https://github.com/devotica-labs/terraform-aws-vpc/commit/a359ff4b0c1cd4d252f4d0baeefb2b345565d24c))

## [0.4.1](https://github.com/devotica-labs/terraform-aws-vpc/compare/v0.4.0...v0.4.1) (2026-05-12)


### Bug Fixes

* **examples:** bump AWS provider constraint to ~&gt; 6.44 to match module ([7b20d23](https://github.com/devotica-labs/terraform-aws-vpc/commit/7b20d23131f5b3f951e05f204ddda9dd3fe9d37c))
* **examples:** bump AWS provider constraint to ~&gt; 6.44 to match module ([6831c82](https://github.com/devotica-labs/terraform-aws-vpc/commit/6831c8213bc68501797d0a518587f343d47bb882))

## [0.4.0](https://github.com/devotica-labs/terraform-aws-vpc/compare/v0.3.0...v0.4.0) (2026-05-12)


### Features

* **audit:** adopt central reusable CI + central policy pack, add Sou… ([e73ec3f](https://github.com/devotica-labs/terraform-aws-vpc/commit/e73ec3f77a1407218253b42868632f38b05f7a4b))
* **audit:** adopt central reusable CI + central policy pack, add SourceFuse attribution ([f2ee258](https://github.com/devotica-labs/terraform-aws-vpc/commit/f2ee25828391b78edc3f179935a4a23d32adb862))
* **governance:** add Code of Conduct (Contributor Covenant 2.1) ([e6fad13](https://github.com/devotica-labs/terraform-aws-vpc/commit/e6fad133f966e52f9ac54e1c6ce413f16e0bdf95))
* **governance:** add terraform package-ecosystem to dependabot ([0926185](https://github.com/devotica-labs/terraform-aws-vpc/commit/0926185575c8d8873cc863cea7911042266970a0))
* **governance:** route reviews to security team for all files ([04f6277](https://github.com/devotica-labs/terraform-aws-vpc/commit/04f6277094a8d1d2c3409f3a2f7b25bb12446295))
* initial vpc module v1.0.0 ([3ee3888](https://github.com/devotica-labs/terraform-aws-vpc/commit/3ee38885594c80a112e17632b61bb18a8392b21f))


### Bug Fixes

* add OIDC to conftest, add OPA policies, make infracost optional ([a50361a](https://github.com/devotica-labs/terraform-aws-vpc/commit/a50361aa5ed3948325891761db44bcfdd3640983))
* **ci:** opt in to terraform-docs auto-update from central CI ([d81e4be](https://github.com/devotica-labs/terraform-aws-vpc/commit/d81e4be1961632fc031912cf4babd27db85b7777))
* **ci:** pin integration tests to terraform 1.9.5 to match central CI ([92df4eb](https://github.com/devotica-labs/terraform-aws-vpc/commit/92df4ebe2cac44763dd95bfe8cb489450581749d))
* **ci:** remove undefined terraform-docs-auto-update input ([12314cd](https://github.com/devotica-labs/terraform-aws-vpc/commit/12314cda581fcc0fb59884292f831e08c10873d2))
* **examples:** add versions.tf to satisfy tflint terraform_required_version ([0af7cb2](https://github.com/devotica-labs/terraform-aws-vpc/commit/0af7cb2075e51f5db33ee10e2634dc8083e19703))
* resolve all 8 CI failures ([5d56197](https://github.com/devotica-labs/terraform-aws-vpc/commit/5d56197af577eeb7008f887c59f0ab7cd01df30d))
* terraform fmt formatting ([f4858fb](https://github.com/devotica-labs/terraform-aws-vpc/commit/f4858fb41d7f599e673e179992f9879c483b6c1c))
* trivy for tfsec, terraform-docs write perms, contract test plan-safe ([0219cfb](https://github.com/devotica-labs/terraform-aws-vpc/commit/0219cfbb1ac8ea03ec50ac74664d940f1f14cef3))

## [0.4.0](https://github.com/devotica-labs/terraform-aws-vpc/compare/v0.3.0...v0.4.0) (2026-05-08)


### Features

* **audit:** adopt central reusable CI + central policy pack, add Sou… ([e73ec3f](https://github.com/devotica-labs/terraform-aws-vpc/commit/e73ec3f77a1407218253b42868632f38b05f7a4b))
* **audit:** adopt central reusable CI + central policy pack, add SourceFuse attribution ([f2ee258](https://github.com/devotica-labs/terraform-aws-vpc/commit/f2ee25828391b78edc3f179935a4a23d32adb862))
* **governance:** add Code of Conduct (Contributor Covenant 2.1) ([e6fad13](https://github.com/devotica-labs/terraform-aws-vpc/commit/e6fad133f966e52f9ac54e1c6ce413f16e0bdf95))
* **governance:** add terraform package-ecosystem to dependabot ([0926185](https://github.com/devotica-labs/terraform-aws-vpc/commit/0926185575c8d8873cc863cea7911042266970a0))
* **governance:** route reviews to security team for all files ([04f6277](https://github.com/devotica-labs/terraform-aws-vpc/commit/04f6277094a8d1d2c3409f3a2f7b25bb12446295))
* initial vpc module v1.0.0 ([3ee3888](https://github.com/devotica-labs/terraform-aws-vpc/commit/3ee38885594c80a112e17632b61bb18a8392b21f))


### Bug Fixes

* add OIDC to conftest, add OPA policies, make infracost optional ([a50361a](https://github.com/devotica-labs/terraform-aws-vpc/commit/a50361aa5ed3948325891761db44bcfdd3640983))
* **ci:** opt in to terraform-docs auto-update from central CI ([d81e4be](https://github.com/devotica-labs/terraform-aws-vpc/commit/d81e4be1961632fc031912cf4babd27db85b7777))
* **ci:** pin integration tests to terraform 1.9.5 to match central CI ([92df4eb](https://github.com/devotica-labs/terraform-aws-vpc/commit/92df4ebe2cac44763dd95bfe8cb489450581749d))
* **ci:** remove undefined terraform-docs-auto-update input ([12314cd](https://github.com/devotica-labs/terraform-aws-vpc/commit/12314cda581fcc0fb59884292f831e08c10873d2))
* **examples:** add versions.tf to satisfy tflint terraform_required_version ([0af7cb2](https://github.com/devotica-labs/terraform-aws-vpc/commit/0af7cb2075e51f5db33ee10e2634dc8083e19703))
* resolve all 8 CI failures ([5d56197](https://github.com/devotica-labs/terraform-aws-vpc/commit/5d56197af577eeb7008f887c59f0ab7cd01df30d))
* terraform fmt formatting ([f4858fb](https://github.com/devotica-labs/terraform-aws-vpc/commit/f4858fb41d7f599e673e179992f9879c483b6c1c))
* trivy for tfsec, terraform-docs write perms, contract test plan-safe ([0219cfb](https://github.com/devotica-labs/terraform-aws-vpc/commit/0219cfbb1ac8ea03ec50ac74664d940f1f14cef3))

## [0.3.0](https://github.com/devotica-labs/terraform-aws-vpc/compare/v0.2.0...v0.3.0) (2026-05-08)


### Features

* **audit:** adopt central reusable CI + central policy pack, add Sou… ([e73ec3f](https://github.com/devotica-labs/terraform-aws-vpc/commit/e73ec3f77a1407218253b42868632f38b05f7a4b))
* **audit:** adopt central reusable CI + central policy pack, add SourceFuse attribution ([f2ee258](https://github.com/devotica-labs/terraform-aws-vpc/commit/f2ee25828391b78edc3f179935a4a23d32adb862))
* **governance:** add Code of Conduct (Contributor Covenant 2.1) ([e6fad13](https://github.com/devotica-labs/terraform-aws-vpc/commit/e6fad133f966e52f9ac54e1c6ce413f16e0bdf95))
* **governance:** add terraform package-ecosystem to dependabot ([0926185](https://github.com/devotica-labs/terraform-aws-vpc/commit/0926185575c8d8873cc863cea7911042266970a0))
* **governance:** route reviews to security team for all files ([04f6277](https://github.com/devotica-labs/terraform-aws-vpc/commit/04f6277094a8d1d2c3409f3a2f7b25bb12446295))
* initial vpc module v1.0.0 ([3ee3888](https://github.com/devotica-labs/terraform-aws-vpc/commit/3ee38885594c80a112e17632b61bb18a8392b21f))


### Bug Fixes

* add OIDC to conftest, add OPA policies, make infracost optional ([a50361a](https://github.com/devotica-labs/terraform-aws-vpc/commit/a50361aa5ed3948325891761db44bcfdd3640983))
* **ci:** opt in to terraform-docs auto-update from central CI ([d81e4be](https://github.com/devotica-labs/terraform-aws-vpc/commit/d81e4be1961632fc031912cf4babd27db85b7777))
* **ci:** pin integration tests to terraform 1.9.5 to match central CI ([92df4eb](https://github.com/devotica-labs/terraform-aws-vpc/commit/92df4ebe2cac44763dd95bfe8cb489450581749d))
* **ci:** remove undefined terraform-docs-auto-update input ([12314cd](https://github.com/devotica-labs/terraform-aws-vpc/commit/12314cda581fcc0fb59884292f831e08c10873d2))
* **examples:** add versions.tf to satisfy tflint terraform_required_version ([0af7cb2](https://github.com/devotica-labs/terraform-aws-vpc/commit/0af7cb2075e51f5db33ee10e2634dc8083e19703))
* resolve all 8 CI failures ([5d56197](https://github.com/devotica-labs/terraform-aws-vpc/commit/5d56197af577eeb7008f887c59f0ab7cd01df30d))
* terraform fmt formatting ([f4858fb](https://github.com/devotica-labs/terraform-aws-vpc/commit/f4858fb41d7f599e673e179992f9879c483b6c1c))
* trivy for tfsec, terraform-docs write perms, contract test plan-safe ([0219cfb](https://github.com/devotica-labs/terraform-aws-vpc/commit/0219cfbb1ac8ea03ec50ac74664d940f1f14cef3))

## [0.2.0](https://github.com/devotica-labs/terraform-aws-vpc/compare/v0.1.0...v0.2.0) (2026-05-08)


### Features

* **audit:** adopt central reusable CI + central policy pack, add Sou… ([e73ec3f](https://github.com/devotica-labs/terraform-aws-vpc/commit/e73ec3f77a1407218253b42868632f38b05f7a4b))
* **audit:** adopt central reusable CI + central policy pack, add SourceFuse attribution ([f2ee258](https://github.com/devotica-labs/terraform-aws-vpc/commit/f2ee25828391b78edc3f179935a4a23d32adb862))

## [Unreleased]
