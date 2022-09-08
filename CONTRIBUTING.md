# Contributing to this repository

Welcome to the contributing guide.
Feel free to contribute to this repository. You can do that in various ways.

## Contributions

### Issues

When something is not clear, please [look in the issues](https://github.com/philips-internal/blackduck-report-action/issues) or [create a new one](https://github.com/philips-internal/blackduck-report-action/issues/new).

### Pull Requests

When you want to add an improvement or fix a bug, please fork the repo and create a pull-request.

> Note: The documentation on the arguments of the GitHub Action are automatically generated from the `actions.yml` file. You don't need to change that in the PR.

### Discussions

You can also start a discussion to get more information about the workings of the tool.

## Development

This repository mainly consist of a bash-script.
You can run this locally as described in the `README.md`.

You do need an actual Black Duck instance with a project analyzed in it.

### Example workflow

This is an example workflow to push a project to Black Duck and get the results.

```
name: Get full licenses

on:
  workflow_dispatch:
  push:
    branches:
      - main

jobs:
  scan:
    runs-on: ubuntu:latest
    container: node:lts
    steps:
      - uses: actions/checkout@v3

      - name: Build my project f.e. with yarn
        run: |
          yarn install
          yarn build

      - name: Set up Java 17 for Detect
        uses: actions/setup-java@v2
        with:
          java-version: '17'
          distribution: 'adopt'

      - name: Run Synopsys Detect
        uses: synopsys-sig/detect-action@v0.3.2
        with:
          blackduck-url: ${{ secrets.BLACKDUCK_URL }}
          blackduck-api-token: ${{ secrets.BLACKDUCK_TOKEN }}
          scan-mode: INTELLIGENT
          detect-version: 7.14.0
          github-token: ${{ secrets.GITHUB_TOKEN }}
        env:
          DETECT_PROJECT_NAME: project-name
          DETECT_PROJECT_VERSION_NAME: version-name
          DETECT_DETECTOR_SEARCH_CONTINUE: true
          DETECT_WAIT_FOR_RESULTS: true
          DETECT_PROJECT_CODELOCATION_UNMAP: true
          DETECT_TOOLS_EXCLUDED: SIGNATURE_SCAN
          DETECT_YARN_PROD_ONLY: true

      - name: Create report in Black Duck
        uses: philips-software/blackduck-report-action@v0.1
        id: blackduck-report
        with:
          blackduck-url: ${{ secrets.BLACKDUCK_URL }}
          blackduck-token: ${{ secrets.BLACKDUCK_TOKEN }}
          project: project-name
          version: version-name

      - name: show content
        run: echo ${{steps.blackduck-report.outputs.sbom-contents}}

      - name: Upload artifact
        uses: actions/upload-artifact@3cea5372237819ed00197afe530f5a7ea3e805c8
        with:
          name: sbom-report
          path: ${{steps.blackduck-report.outputs.sbom-file}}
          retention-days: 7
```

