---
name: sveltekit-frontend
description: >
  SvelteKit + Svelte 5 runes frontend development skill (SPA static). Use when writing,
  reviewing, or debugging .svelte components, SvelteKit routes (+page.svelte, +layout.js),
  runes ($state, $derived, $effect, $props, $bindable), load functions, auth guards,
  Tailwind v4, DaisyUI, or PocketBase JS SDK client integration. Vanilla JS only, no TypeScript, no .server.js.
license: MIT
metadata:
  author: brian-marquez
  version: "1.0.0"
  svelte: "5.0.0"
  sveltekit: "2.0.0"
---

# SvelteKit Frontend Specialist (Svelte 5 + SvelteKit)

## Role

Senior frontend engineering guidelines for **SvelteKit (Static SPA)** with **Svelte 5 runes**, **Tailwind CSS v4**, **DaisyUI**, and **PocketBase JS SDK**.

Absolute priorities:
1. **Vanilla JavaScript** — no TypeScript, no `lang="ts"`, no type annotations, `.js` and `.svelte` extensions.
2. Svelte 5 runes API correctness (no Svelte 4 stores or reactive declarations `$:`).
3. Static SPA architecture with `adapter-static` + `fallback: 'index.html'`. No SSR, no Node server.
4. All dynamic data comes from PocketBase SDK on the client. Zero `.server.js` files in the SPA.
5. Tailwind v4 + DaisyUI for all styling. No inline CSS, no ad-hoc classes outside Tailwind.
6. Semantic and accessible HTML: landmarks, ARIA roles, labels, descriptive IDs on every component.
7. Reusable components: never duplicate UI, always extract to `src/lib/components/`.
8. **Mobbin MCP guided design**: if Mobbin MCP is available, search references before designing screens. If not, apply minimal DaisyUI principles.

---

## When to use this skill

- Writing or reviewing `*.svelte`, `+page.svelte`, `+layout.svelte`, `+error.svelte`
- Route files: `+page.js`, `+layout.js` (never `.server.js` in static SPA)
- Runes: `$state`, `$derived`, `$effect`, `$props`, `$bindable`, `$inspect`, `$host`
- PocketBase JS SDK integration (`pb.collection`, `pb.authStore`, realtime)
- Styling with Tailwind v4 + DaisyUI (components, themes, variants)
- Accessible HTML, ARIA roles, form and navigation accessibility
- Reusable components: design, props, snippets
- Minimalist UI design: layout, spacing, typography, palette
- Client-side routing or hydration errors
- Transitions and animations with `svelte/transition`, `svelte/motion`

---

## Priorities of truth

1. Official SvelteKit docs (`kit.svelte.dev/docs`)
2. Official Svelte 5 docs (`svelte.dev/docs`)
3. SvelteKit / Svelte CHANGELOG
4. User codebase

---

## Architecture — Static SPA with PocketBase

### Fixed decisions

This stack **always** uses static SPA. No SSR, no Node server in production.

| Question | Answer |
| :-- | :-- |
| SSR? | No. `adapter-static` with `fallback: 'index.html'` |
| `.server.js`? | No. Never in this stack |
| API endpoints? | No. APIs are PocketBase |
| TypeScript? | No. Vanilla JavaScript always |
| Where does auth live? | `pb.authStore` on the client |
| Where does data live? | PocketBase SDK from `+page.js` or component |

### Mandatory base config

```js
// svelte.config.js
import adapter from '@sveltejs/adapter-static'
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte'

export default {
  preprocess: vitePreprocess(),
  kit: {
    adapter: adapter({
      fallback: 'index.html',  // SPA client-side routing
    }),
  },
}
```

```js
// src/routes/+layout.js
export const prerender = false  // dynamic data from PocketBase
export const ssr = false        // SPA: no SSR
```

```js
// vite.config.js
import { sveltekit } from '@sveltejs/kit/vite'
import tailwindcss from '@tailwindcss/vite'

export default {
  plugins: [tailwindcss(), sveltekit()],
}
```

---

## Tailwind CSS v4 + DaisyUI — Rules

### Setup

```bash
npm install tailwindcss@latest @tailwindcss/vite daisyui@latest
```

```css
/* src/app.css */
@import 'tailwindcss';
@plugin 'daisyui' {
  themes: light --default, dark --prefersdark;
}
```

### Style rules

1. **Tailwind + DaisyUI only** — no `style="..."`, no custom CSS modules.
2. **DaisyUI components first** — `btn`, `card`, `input`, `modal`, `badge`, `alert`, `navbar`.
3. **Tailwind for layout and spacing** — `flex`, `grid`, `gap-*`, `p-*`, `m-*`, `max-w-*`.
4. **DaisyUI themes** — define themes in `app.css`, never hardcode colors with `text-[#hex]`.

---

## Accessibility — Rules

### Semantic landmarks

```svelte
<header>...</header>
<nav aria-label="Main navigation">...</nav>
<main id="main-content">...</main>
<aside aria-label="Sidebar">...</aside>
<footer>...</footer>
```

### Accessible forms

```svelte
<form aria-labelledby="form-title">
  <h2 id="form-title">Log In</h2>

  <div class="form-control">
    <label class="label" for="email">
      <span class="label-text">Email</span>
    </label>
    <input
      id="email"
      type="email"
      name="email"
      class="input input-bordered"
      autocomplete="email"
      aria-required="true"
      aria-describedby="email-error"
    />
    {#if errors?.email}
      <span id="email-error" class="label-text-alt text-error" role="alert">
        {errors.email}
      </span>
    {/if}
  </div>
</form>
```

---

## Reusable Components — Rules

### Folder structure

```
src/lib/components/
  ui/               # primitives: Button, Input, Card, Badge, Modal
  layout/           # Header, Sidebar, Footer, PageWrapper
  features/         # domain components: PostCard, UserAvatar, CommentList
  forms/            # FormField, SearchBar, FilterPanel
```

---

## Svelte 5 Runes — Core Reference

### $state

```svelte
<script>
  let count = $state(0)
  let user = $state(null)
  let items = $state([])
  items.push('new') // deep reactivity
</script>
```

### $derived

```svelte
<script>
  let price = $state(100)
  let qty = $state(2)
  const total = $derived(price * qty)

  const filtered = $derived.by(() =>
    items.filter(i => i.active).sort((a, b) => a.name.localeCompare(b.name))
  )
</script>
```

### $effect

```svelte
<script>
  let query = $state('')

  $effect(() => {
    if (!query) return
    fetchResults(query)
  })

  $effect(() => {
    const sub = pb.collection('messages').subscribe('*', handler)
    return () => sub.then(u => u())
  })
</script>
```

### $props

```svelte
<script>
  const { name, age = 18, onClose } = $props()
</script>
```

### $bindable

```svelte
<script>
  let { value = $bindable('') } = $props()
</script>
```

---

## PocketBase JS SDK Integration

### Client instance (singleton)

```js
// src/lib/pb/client.js
import PocketBase from 'pocketbase'

const pb = new PocketBase(import.meta.env.VITE_PB_URL)
pb.autoCancellation(false) // Disable auto-cancellation globally for SPA

export default pb
```

### Auth guard helper

```js
// src/lib/auth/guard.js
import pb from '$lib/pb/client.js'
import { goto } from '$app/navigation'

export async function setupAuthGuard(collection = 'users', redirectTo = '/login') {
  if (!pb.authStore.isValid) {
    goto(redirectTo)
    return { ready: false, unsubscribe: () => {} }
  }

  try {
    await pb.collection(collection).authRefresh()
  } catch {
    pb.authStore.clear()
    goto(redirectTo)
    return { ready: false, unsubscribe: () => {} }
  }

  const unsubscribe = pb.authStore.onChange((token, record) => {
    if (!token || !record) {
      goto(redirectTo)
    }
  })

  return { ready: true, unsubscribe }
}
```

### Usage in protected page

```svelte
<!-- src/routes/(app)/dashboard/+page.svelte -->
<script>
  import { onMount, onDestroy } from 'svelte'
  import { setupAuthGuard } from '$lib/auth/guard.js'

  let ready = $state(false)
  let unsubscribeAuth = () => {}

  onMount(async () => {
    const result = await setupAuthGuard('users')
    ready = result.ready
    unsubscribeAuth = result.unsubscribe
  })

  onDestroy(() => {
    unsubscribeAuth()
  })
</script>

{#if ready}
  <!-- Protected content -->
{:else}
  <div class="flex items-center justify-center min-h-screen">
    <span class="loading loading-spinner loading-lg text-primary" aria-label="Verifying session"></span>
  </div>
{/if}
```

---

## Absolute prohibitions

- No TypeScript, `lang="ts"`, or `.ts` files
- No `export let` in Svelte 5 (use `$props()`)
- No `$:` reactive statements (use `$derived` or `$effect`)
- No `.server.js` files (static SPA)
- No multiple PocketBase instances on client
- No raw user input string concatenation in PocketBase filters (use `pb.filter()`)
- No inline CSS (`style="..."`)
