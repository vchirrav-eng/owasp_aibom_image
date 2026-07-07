# OWASP AIBOM Generator — Docker Image

Docker packaging of the **OWASP GenAI Security Project AIBOM Generator** — an open-source tool for generating **AI Bills of Materials (AIBOMs)** in [CycloneDX](https://cyclonedx.org) format for Hugging Face-hosted models. The tool is listed in the official [CycloneDX Tool Center](https://cyclonedx.org/tool-center/).

- Live tool: https://owasp-genai-aibom.org
- OWASP AIBOM Initiative: https://genai.owasp.org/
- Upstream source: https://huggingface.co/spaces/GenAISecurityProject/OWASP-AIBOM-Generator
- License: [Apache-2.0](LICENSE)

## What it does

- Extracts metadata from models hosted on Hugging Face (model cards, configurations, repository files)
- Generates an AIBOM in CycloneDX 1.6 JSON format (compatible with SPDX AI Profile)
- Calculates AIBOM completeness scoring with improvement recommendations
- Provides a human-readable AIBOM viewer, JSON download, and API endpoints for automation

## Quick start

```bash
docker run -p 7860:7860 vchirrav/owasp-aibom-generator
```

Open http://localhost:7860, enter a Hugging Face model ID (e.g. `meta-llama/Llama-2-7b-chat-hf`) or model URL, and download the generated AIBOM JSON.

## Build the image

```bash
git clone https://github.com/vchirrav-eng/owasp_aibom_image.git
cd owasp_aibom_image
docker build -t vchirrav/owasp-aibom-generator .
```

Note: the image includes PyTorch and Transformers, so expect a multi-GB image and a long first build.

## Run

### Web app (default)

```bash
docker run -d --name aibom -p 7860:7860 vchirrav/owasp-aibom-generator
```

### CLI mode

Any arguments passed to the container are forwarded to the AIBOM CLI instead of starting the web server:

Linux/macOS:

```bash
docker run --rm -v "$(pwd)/out:/data" vchirrav/owasp-aibom-generator meta-llama/Llama-2-7b-chat-hf -o /data/aibom.json
```

Windows (cmd):

```cmd
docker run --rm -v "%cd%\out:/data" vchirrav/owasp-aibom-generator meta-llama/Llama-2-7b-chat-hf -o /data/aibom.json
```

Windows (PowerShell):

```powershell
docker run --rm -v "${PWD}\out:/data" vchirrav/owasp-aibom-generator meta-llama/Llama-2-7b-chat-hf -o /data/aibom.json
```

The AIBOM is written to `out/aibom.json` on the host.

**Command line options:**

| Option | Shorthand | Description |
|--------|-----------|-------------|
| `model_id` | | Hugging Face Model ID (e.g., `owner/model`) |
| `--test` | `-t` | Run test mode for multiple predefined models |
| `--output` | `-o` | Custom output file path |
| `--name` | `-n` | Override component name in metadata |
| `--version` | `-v` | Override component version in metadata |
| `--manufacturer` | `-m` | Override component manufacturer/supplier |
| `--inference` | `-i` | Use AI inference for enhanced metadata (requires API key) |
| `--summarize` | `-s` | Enable intelligent description summarization (downloads a model) |
| `--verbose` | | Enable verbose logging |

### Environment variables

| Variable | Default | Purpose |
|---|---|---|
| `PORT` | `7860` | Web server port inside the container |
| `HF_TOKEN` | unset | Hugging Face token; optional, needed for private/gated models |
| `AIBOM_OUTPUT_DIR` | `/data/aibom_output` or `/tmp/aibom_output` | Where generated AIBOMs are written |
| `HF_HOME` | `/data/.cache/huggingface` or `/tmp/.cache/huggingface` | Hugging Face cache location |
| `RECAPTCHA_SITE_KEY` / `RECAPTCHA_SECRET_KEY` | unset | Optional reCAPTCHA for the web form |

Example with a token and persistent storage:

```bash
docker run -d -p 7860:7860 -e HF_TOKEN=hf_xxx -v aibom-data:/data vchirrav/owasp-aibom-generator
```

If a writable `/data` volume is mounted, model caches and generated output persist there; otherwise the container falls back to `/tmp` (ephemeral).

## Publish to Docker Hub

```bash
docker login
docker tag vchirrav/owasp-aibom-generator vchirrav/owasp-aibom-generator:1.0.2
docker push vchirrav/owasp-aibom-generator:1.0.2
docker push vchirrav/owasp-aibom-generator:latest
```

Version `1.0.2` matches the upstream package version in [pyproject.toml](pyproject.toml).

## Repository layout

```
Dockerfile         # python:3.11-slim base, installs the package, runs entrypoint.sh
entrypoint.sh      # starts uvicorn web server, or the CLI if args are given
pyproject.toml     # package metadata and dependencies
src/               # application code (FastAPI web app + CLI)
```

## Bugs and contributions

Upstream issues: https://github.com/GenAI-Security-Project/aibom-generator/iss