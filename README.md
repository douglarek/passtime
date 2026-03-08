passtime - overlay for Gentoo Linux
==================================

Write some ebuilds to pass the time with Gentoo Linux.

```
(root)$ eselect repository enable dlang
(root)$ eselect repository add passtime git https://github.com/douglarek/passtime.git
```

## Packages<a name="packages"></a>

| Package                      | Description                                                                           | URL                                                                                                                           |
| :--------------------------- | :-------------------------------------------------------------------------------------| :-----------------------------------------------------------------------------------------------------------------------------|
| app-editors/neovim-bin       | Vim-fork focused on extensibility and agility                                         | [https://neovim.io](https://neovim.io)                                                                                        |
| net-analyzer/pwru-bin        | eBPF-based Linux kernel networking debugger                                           | [https://github.com/cilium/pwru](https://github.com/cilium/pwru)                                                              |
| net-misc/onedrive[^1]        | Free Client for OneDrive on Linux[^2]                                                 | [https://github.com/abraunegg/onedrive](https://github.com/abraunegg/onedrive)                                                |
| net-vpn/cloudflared-bin      | Cloudflare Tunnel client (formerly Argo Tunnel)                                       | [https://github.com/cloudflare/cloudflared](https://github.com/cloudflare/cloudflared)                                        |
| dev-util/osc[^7]             | The Command Line Interface to work with an Open Build Service                         | [https://github.com/openSUSE/osc](https://github.com/openSUSE/osc)                                                            |
| dev-util/android-tools-bin   | Android platform tools (adb, fastboot)                                                | [https://developer.android.com/tools/releases/platform-tools](https://developer.android.com/tools/releases/platform-tools)    |
| dev-util/pi-coding-agent-bin | A terminal-based coding agent with multi-model support                                | [https://github.com/badlogic/pi-mono](https://github.com/badlogic/pi-mono)                                                    |
| dev-go/staticcheck           | Go static analysis, detecting bugs, performance issues, and much more                 | [https://github.com/dominikh/go-tools](https://github.com/dominikh/go-tools)                                                  |
| dev-go/gotests               | Automatically generate Go test boilerplate from your source code                      | [https://github.com/cweill/gotests](https://github.com/cweill/gotests)                                                        |


[^1]: forked from https://github.com/gentoo/dlang with regular updates.
[^2]: you need to enable dlang overlay by running `eselect repository enable dlang`.
[^4]: borrowed from https://github.com/gentoo/guru.
[^7]: borrowed from https://github.com/Gig-OS/gig.
[^8]: borrowed from https://github.com/gentoo/guru. You need to enable guru overlay to use it.

