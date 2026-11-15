# opendisplay-remote

A fork of [OpenDisplay](https://github.com/peetzweg/opendisplay) (GPL-3.0)
aimed at remote access with full input: a Mac or Windows PC as the host, an
iPad (later a Windows PC) as the client.

## Layout

| Path | What | Origin |
|---|---|---|
| `Mac/`, `iOS/`, `Shared/`, `MacReceiver/` | Mac host, iPad/iPhone client, Mac client (Swift) | upstream |
| `linux/` | Rust protocol core, Linux host and client | upstream |
| `windows/` | Windows host (C++), imported with `git subtree` | [opendisplay-win](https://github.com/martinhoess/opendisplay-win) |
| `PROTOCOL.md` | The wire protocol all of them speak | upstream, extended here |

Pull upstream changes with `git fetch upstream && git merge upstream/main`,
and the Windows host with `git subtree pull --prefix=windows win master`.

## What this fork adds

- **`gesture` and `key` messages** (PROTOCOL.md 6.1), negotiated through
  `welcome.input` so stock OpenDisplay peers keep working in both directions.
  - Rust core (`linux/crates/opendisplay-proto`): implemented and tested.
  - Mac host and iPad client: implemented, **not yet compiled or run** (this
    was written without a Mac). Pinch and rotation on the Mac use undocumented
    CGEvent fields and need checking on a real machine.
  - Windows host: not yet. It already injects real Windows touch and pen.

## Next

1. Build the Mac and iOS targets, fix what the compiler finds, tune gestures.
2. Windows host: advertise and inject `gesture` (pointer zoom) and `key`.
3. Remote access: pairing and encryption (the protocol has none), a mode that
   shows the host's main display instead of a virtual one, and a transport
   that works outside the LAN.
4. Key repeat on the host, and audio.
5. A Windows client, built on the Rust receiver in `linux/crates/od-receiver`.
