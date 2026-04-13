# ✦ glint

*A type-safe task manager REST API built in Gleam, powered by OTP actors.*

---

## ✦ what is this?

**Glint** is a lightweight task manager API written in [Gleam](https://gleam.run) — a modern, statically typed functional language that runs on the Erlang VM (BEAM). The same runtime that powers WhatsApp, Discord, and systems handling millions of concurrent users.

This is not just a todo app. It is an exploration of how production-grade systems are actually built — with type safety, message passing, and zero runtime surprises.

---

## ✦ features

- add tasks, delete tasks, view all your tasks
- fully type-safe backend — no null errors, no silent failures
- in-memory state powered by an OTP Actor, a lightweight supervised Erlang process
- clean minimal UI with a soft pink aesthetic
- REST API built from scratch with no heavy frameworks

---

## ✦ tech stack

| layer | technology |
|---|---|
| language | [Gleam](https://gleam.run) |
| http server | [Mist](https://github.com/rawhat/mist) |
| web framework | [Wisp](https://github.com/gleam-wisp/wisp) |
| state management | OTP Actor |
| frontend | vanilla HTML + CSS + JS |

---

## ✦ how it works

The data lives inside a **Gleam OTP Actor** — a supervised Erlang process that holds the task list in memory. Every request sends a message to the actor and waits for a reply. One message at a time, naturally thread-safe, no locks, no database.

Routes are matched with **pattern matching** — the compiler makes sure every single case is handled before the code even runs.

---

## ✦ getting started

Prerequisites: [Gleam](https://gleam.run/getting-started/) and Erlang/OTP installed.

```bash
git clone https://github.com/pxxelina/glint.git
cd glint
gleam run
```

Then open [http://localhost:8000](http://localhost:8000) in your browser.

---

## ✦ license

MIT License — Copyright (c) 2026 pxxelina

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

---

*made with love* ♡
