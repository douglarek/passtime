passtime - overlay for Gentoo Linux
==================================

Write some ebuilds to pass the time with Gentoo Linux.

```
(root)$ eselect repository enable dlang
(root)$ eselect repository add passtime git https://github.com/douglarek/passtime.git
```

## Packages<a name="packages"></a>

| Package                      | Description                                                               | URL                                                                                                                           |
| :--------------------------- | :-------------------------------------------------------------------------| :-----------------------------------------------------------------------------------------------------------------------------|
| app-editors/cursor           | Cursor App - AI-first coding environment                                  | [https://www.cursor.com](https://www.cursor.com)                                                                              |
| net-misc/onedrive[^1]        | Free Client for OneDrive on Linux[^2]                                     | [https://github.com/abraunegg/onedrive](https://github.com/abraunegg/onedrive)                                                |
| net-proxy/dae[^3]            | eBPF-based Linux high-performance transparent proxy solution              | [https://github.com/daeuniverse/dae](https://github.com/daeuniverse/dae)                                                      |
| net-vpn/cloudflared-bin      | Cloudflare Tunnel client (formerly Argo Tunnel)                           | [https://github.com/cloudflare/cloudflared](https://github.com/cloudflare/cloudflared)                                        |
| net-im/wechat[^5]            | Weixin for Linux                                                          | [https://linux.weixin.qq.com](https://linux.weixin.qq.com)                                                                    |
| app-text/goldendict-ng[^6]   | The Next Generation GoldenDict                                            | [https://github.com/xiaoyifang/goldendict-ng](https://github.com/xiaoyifang/goldendict-ng)                                    |
| dev-util/osc[^7]             | The Command Line Interface to work with an Open Build Service             | [https://github.com/openSUSE/osc](https://github.com/openSUSE/osc)                                                            |
| dev-util/android-tools-bin   | Android platform tools (adb, fastboot)                                    | [https://developer.android.com/tools/releases/platform-tools](https://developer.android.com/tools/releases/platform-tools)    |
| sci-ml/ollama[^8]            | Get up and running with Llama 3, Mistral, Gemma, and other language models| [https://github.com/ollama/ollama](https://github.com/ollama/ollama)                                                          |
| dev-go/staticcheck           | Go static analysis, detecting bugs, performance issues, and much more     | [https://github.com/dominikh/go-tools](https://github.com/dominikh/go-tools)                                                  |
| dev-go/gotests               | Automatically generate Go test boilerplate from your source code          | [https://github.com/cweill/gotests](https://github.com/cweill/gotests)                                                        |

[^1]: forked from https://github.com/gentoo/dlang with regular updates.
[^2]: you need to enable dlang overlay by running `eselect repository enable dlang`.
[^3]: modified from https://github.com/microcai/gentoo-zh with minimal dependencies.
[^4]: borrowed from https://github.com/gentoo/guru.
[^5]: native qt non-bubblewrap.
[^6]: borrowed from https://gitlab.com/Perfect_Gentleman/PG_Overlay.
[^7]: borrowed from https://github.com/Gig-OS/gig.
[^8]: borrowed from https://github.com/gentoo/guru. You need to enable guru overlay to use it.

