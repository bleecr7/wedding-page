# wedding-page

Repo for wedding info — a [Jekyll](https://jekyllrb.com) site published via [GitHub Pages](https://pages.github.com).

## Local development

Open the repo in a Dev Container (VS Code) — Ruby, Jekyll, and the site gems
are baked into the image (installed at build time). Then run:

```sh
bundle exec jekyll serve --livereload
```

The site is served at <http://localhost:4000>.

> Requires the podman machine to be running — boot it with `.vscode/setup-podman.sh` (auto-runs via the `folderOpen` task).

## Deploy

Push to `main`; GitHub Pages builds and serves the site from the repo root. The custom domain is set via the `CNAME` file.

## For agents

See [`.notes/ARCHITECTURE.md`](.notes/ARCHITECTURE.md) for the repo architecture, DNS/deployment context, and the current to-do list (including deferred, network-heavy verification steps).
