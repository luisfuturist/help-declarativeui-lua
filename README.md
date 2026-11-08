# help-declarativeui-lua

Declarative UI experiment in Lua: components, hooks, reactivity and rendering, inspired by React-style patterns. Built for MTA:SA.

## Layout

- `components/` - UI components (incl. `mta.lua` for MTA integration)
- `event-handlers.lua`, `event-parameters.lua` - event system
- `hooks.lua` - lifecycle hooks
- `reactivity.lua` - reactive state primitives
- `render.lua`, `drawers.lua`, `document.lua` - rendering layer
- `utils/` - drawing, element, input, math helpers
- `test/` - example HUD and test scripts
- `docs/` - module documentation (components, control flow, reactivity, rendering)

## Usage

See `test/example_hud.lua` for a working example and `docs/` for per-module reference.
