# SERP Flow Diagram Assets (Readable Presentation Version)

This folder contains rebuilt diagram sources optimized for readability on projectors.

## Files
- `serp-flow-mermaid.mmd` — Mermaid source (larger labels, clearer grouping, data stores included)
- `serp-flow-graphviz.dot` — Graphviz logical/circuit style source with orthogonal edges and data-store cylinders

## Why this version is better
- Bigger text labels for presentation distance
- Reduced visual clutter (fewer crossings)
- Boxy/circuit-like structure for logic clarity
- Explicit data stores to show backend architecture

## Render locally
### Mermaid
Use Mermaid Live Editor or CLI:
```bash
mmdc -i serp-flow-mermaid.mmd -o serp-flow-mermaid.svg
```

### Graphviz
```bash
dot -Tsvg serp-flow-graphviz.dot -o serp-flow-graphviz.svg
```

If `dot` is unavailable on your current device, render on a laptop or use an online Graphviz renderer.
