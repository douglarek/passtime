passtime - overlay for Gentoo Linux
==================================

Write some ebuilds to pass the time with Gentoo Linux.

```
(root)$ eselect repository add passtime git https://github.com/douglarek/passtime.git
```

## Packages<a name="packages"></a>

| Package                      | Description                                                   | URL                                                                                   |
| :--------------------------- | :------------------------------------------------------------ | :-------------------------------------------------------------------------------------|
| app-editors/cursor           | Cursor App - AI-first coding environment                      | [https://www.cursor.com](https://www.cursor.com)                                      |
| net-misc/onedrive[^1]        | Free Client for OneDrive on Linux[^2]                         | [https://github.com/abraunegg/onedrive](https://github.com/abraunegg/onedrive)        |
| net-proxy/dae[^3]            | eBPF-based Linux high-performance transparent proxy solution  | [https://github.com/daeuniverse/dae](https://github.com/daeuniverse/dae)              |
| net-vpn/cloudflared-bin      | Cloudflare Tunnel client (formerly Argo Tunnel)               | [https://github.com/cloudflare/cloudflared](https://github.com/cloudflare/cloudflared)|
| media-sound/spotube-bin[^4]  | An open source, cross-platform Spotify client                 | [https://spotube.krtirtho.dev](https://spotube.krtirtho.dev)                          |
| net-im/wechat[^5]            | Weixin for Linux                                              | [https://linux.weixin.qq.com](https://linux.weixin.qq.com)                            |

[^1]: forked from https://github.com/gentoo/dlang with regular updates.
[^2]: you need to enable dlang overlay by running `eselect repository enable dlang`.
[^3]: modified from https://github.com/microcai/gentoo-zh with minimal dependencies.
[^4]: borrowed from https://github.com/gentoo/guru.
[^5]: native qt non-bubblewrap.

