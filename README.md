# gh-label-tool

A small Python CLI for managing GitHub issue labels across repos via a `labels.yaml` file.

## Requirements

- Python 3
- `python3-requests` and `python3-yaml`

On Ubuntu/Debian:

```sh
sudo apt-get install python3-requests python3-yaml
```

## Installation

Clone the repo, then run the install script:

```sh
./install.sh
```

This checks and installs dependencies, then copies the `labels` script to `~/.local/bin/`.

To install to a different location:

```sh
./install.sh --dest /usr/local/bin
```

## Authentication

The tool requires a GitHub fine-grained PAT with **Issues: Read and write** permission, scoped to the repos you want to manage.

Export it before running any command:

```sh
export GITHUB_TOKEN=<your-token>
```

## Usage

All commands operate on a `labels.yaml` file in the current working directory.

### Seed

Pull the current label set from a repo into `labels.yaml`:

```sh
labels seed DC23/some-repo
```

This overwrites any existing `labels.yaml`.

### Apply — merge mode

Add and update labels to match `labels.yaml`. Existing labels not in the file are left untouched.

```sh
labels apply DC23/some-repo --mode merge
labels apply DC23/some-repo --mode merge --dry-run
```

### Apply — replace mode

Delete all existing labels on the repo, then recreate them from `labels.yaml`. You will be prompted to confirm before any changes are made.

```sh
labels apply DC23/some-repo --mode replace
labels apply DC23/some-repo --mode replace --dry-run
```

## labels.yaml

The label set is defined in `labels.yaml` in the working directory. An optional `renames` section lets you rename existing labels without losing their association with issues (uses a PATCH rather than delete-and-recreate):

```yaml
renames:
  - from: old label name
    to: new label name

labels:
  - name: bug
    color: d73a4a
    description: Something isn't working
```

Renames are applied before any creates, updates, or deletes, and work in both merge and replace modes.
