# Brave Origin — Debloat Feature List

**Brave Origin** is a minimalist, paid (or free on Linux) version of the Brave browser that strips away all non-core features. It is available as either a **standalone app** or an **in-app upgrade** to the existing Brave browser.

> **Source:** [Brave Support — What is Brave Origin?](https://support.brave.app/hc/en-us/articles/38561489788173-What-is-Brave-Origin)

---

## What Brave Origin Removes / Disables

The following features are **automatically removed** in the standalone app, or **toggled OFF by default** in the upgraded version:

| # | Feature | Description |
|---|---------|-------------|
| 1 | **Leo** | Brave's built-in AI chat assistant |
| 2 | **Brave News** | Native news feed aggregator shown on the new tab page |
| 3 | **Playlist** | Save videos and audio for offline playback (currently iOS only) |
| 4 | **Brave Rewards** | BAT crypto reward system (also disables browser-based Brave Ads) |
| 5 | **Speedreader** | Distraction-free, simplified article reading mode |
| 6 | **Telemetry & Stats** | Daily usage ping, crash logs, and privacy-preserving product analytics (P3A) |
| 7 | **Brave Talk** | Built-in private video conferencing tool |
| 8 | **Tor** | Private browsing over the Tor network |
| 9 | **Brave VPN** | Premium VPN service |
| 10 | **Brave Wallet** | Built-in cryptocurrency wallet (also disables Web3 domains) |
| 11 | **Wayback Machine** | Integration with the Internet Archive for broken / missing pages |
| 12 | **Web Discovery Project** | Privacy-preserving contribution to Brave Search's index |

---

## What You Keep

Brave Origin retains the **core** experience that makes Brave fast and private:

- **Brave Shields** — industry-leading ad/tracker blocking & privacy protections
- **Brave Search** — independent search index
- **Speed & Performance** — fast page loads, low memory usage
- **Regular Security Updates** — Chromium patches, security & privacy improvements

---

## Pricing & Availability

| Platform | Upgrade Path | Standalone App | One-Time Purchase | Free (Linux) |
|----------|:------------:|:--------------:|:-----------------:|:------------:|
| Android (1.91.x+) | ✅ | ❌ | ✅ | ❌ |
| iOS (1.91.x+) | ✅ | ❌ | ✅ | ❌ |
| macOS (1.91.x+) | ✅ | ✅ | ✅ | ❌ |
| Windows (1.91.x+) | ✅ | ✅ | ✅ | ❌ |
| Linux (1.91.x+) | ✅ | ✅ | ✅ | ✅ |

- **One-time purchase** grants access to **both** the standalone app and the in-app upgrade.
- A single purchase ID can be activated on **up to 10 devices**.
- **Linux users get Brave Origin completely free** (both standalone and upgrade).
- The standalone version has its own **Nightly, Beta, and Release** channels, separate from regular Brave.

---

## Standalone vs. Upgrade Difference

| Aspect | Standalone App | In-App Upgrade |
|--------|----------------|----------------|
| **How features are handled** | Compiled **out of the build** entirely | Disabled via **internal group policies** |
| **New future features** | Will **never appear** in the app | Appear in the Origin settings panel, **off by default** |
| **Can you re-enable features?** | ❌ No | ✅ Yes, via the Origin settings panel |
| **Channels** | Separate Nightly / Beta / Release | Follows regular Brave channels |

---

## Notes

- Origin uses a **blind token protocol** (based on Privacy Pass) to verify purchases without linking your identity to your browsing.
- In **managed workplace environments**, admin Group Policies can override your local Origin settings (upgrade path only).
- If you upgrade to Origin and want to revert, you can disable the `brave://flags/#brave-origin` flag and relaunch the browser.

---

*Last updated: April 18, 2026*
