Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E23A1A7310
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 07:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405552AbgDNFju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 01:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405521AbgDNFjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 01:39:48 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E8AC0A3BDC;
        Mon, 13 Apr 2020 22:39:48 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id y3so12039542qky.8;
        Mon, 13 Apr 2020 22:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lu4CaH/5kxyPUiJrDZteHqpYnCXI6U7exPvL+MBMnh0=;
        b=NdSodnhOT8oUAf/+bdmgRvZAlsZrMV9Z++oKsYeG4spAsFjdjiLwgNvjuVrKJXz0D3
         oG0K9jw2/8dnIl/qmV0aD1We86PMXG6tTgzgHvIeJWWoCtnmmIA2yDPSwq/R50yiSkE9
         unLloPL/acFDUN9pljeb0Fh3do1Sh1oBSzIN6yJrIBQNMFgJ8P5h40VNsRpU1KxcmD/4
         kmjDjiKcAJB7BH2DnIp5GTefPEK3H5e5uM800HOSCFvx4nKl3wkOGiDNQ+z2FV0q+1Q1
         69r98fo+a8NAuHQnFCHSdZ3MsqSJuedX7f4AQ6wzy1vUJfVToLdDKtPPMWkQXKuTjfkg
         wGoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lu4CaH/5kxyPUiJrDZteHqpYnCXI6U7exPvL+MBMnh0=;
        b=Ah2bcxDRwJClyFUArGzBI+PbwsLeJhPVoZNp+wTd7ykb9VORUHtj9wTB0mcYBtyvVq
         kOaKg5idnmkCotApTzqAMnmEa6VHmVLsD4TQLARfdZpuB0b5QLZdUmu51i0wSsJ5D236
         sBGu3Q30Wd9zM5m4flx1vUdfVYIaZxWkH3lfOzhcYyag7weXRQhzhv/0qEba+bH32EiB
         371qq9M538Z80ucZ6YxTFA2pVYPYh4Bl/oI6b+dfnec2IhE6x3YrgIcuqJWXDRN91CaN
         sX8HeBJ066yYcGGSdJzQvK7Ogwg3GXnBB+fowpXD0+7yEtz0Qr8N3M4cdql4Au22LGru
         zq8Q==
X-Gm-Message-State: AGi0PuYxoaJ5dMp8xOCLR7c2KS31bjt2A7cJU2sElIMAqhFpnW5zF55P
        lrMLzwEN1Ipcly9JtGPoAlbB+3U0OxRqqCwtI0Ce4GYt
X-Google-Smtp-Source: APiQypJ1LdLvSjZuzEW+Z0IQ4VlBtYL7ZDwZIxRS7wtus6f6rvqzEqmymLa+fpqZ1y79i6j1UQDt0OmeY5Nq318M7z8=
X-Received: by 2002:ae9:e854:: with SMTP id a81mr19659205qkg.36.1586842787751;
 Mon, 13 Apr 2020 22:39:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232537.2676518-1-yhs@fb.com>
In-Reply-To: <20200408232537.2676518-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Apr 2020 22:39:36 -0700
Message-ID: <CAEf4BzbLAsPAvk45SOgywJH-8x6--ONsSW2yNhE_6EsH9nMtVA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 14/16] tools/bpf: selftests: add dumper
 programs for ipv6_route and netlink
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
>
> Two bpf programs are added in this patch for netlink and ipv6_route
> target. On my VM, I am able to achieve identical
> results compared to /proc/net/netlink and /proc/net/ipv6_route.
>
>   $ cat /proc/net/netlink
>   sk               Eth Pid        Groups   Rmem     Wmem     Dump  Locks    Drops    Inode
>   000000002c42d58b 0   0          00000000 0        0        0     2        0        7
>   00000000a4e8b5e1 0   1          00000551 0        0        0     2        0        18719
>   00000000e1b1c195 4   0          00000000 0        0        0     2        0        16422
>   000000007e6b29f9 6   0          00000000 0        0        0     2        0        16424
>   ....
>   00000000159a170d 15  1862       00000002 0        0        0     2        0        1886
>   000000009aca4bc9 15  3918224839 00000002 0        0        0     2        0        19076
>   00000000d0ab31d2 15  1          00000002 0        0        0     2        0        18683
>   000000008398fb08 16  0          00000000 0        0        0     2        0        27
>   $ cat /sys/kernel/bpfdump/netlink/my1
>   sk               Eth Pid        Groups   Rmem     Wmem     Dump  Locks    Drops    Inode
>   000000002c42d58b 0   0          00000000 0        0        0     2        0        7
>   00000000a4e8b5e1 0   1          00000551 0        0        0     2        0        18719
>   00000000e1b1c195 4   0          00000000 0        0        0     2        0        16422
>   000000007e6b29f9 6   0          00000000 0        0        0     2        0        16424
>   ....
>   00000000159a170d 15  1862       00000002 0        0        0     2        0        1886
>   000000009aca4bc9 15  3918224839 00000002 0        0        0     2        0        19076
>   00000000d0ab31d2 15  1          00000002 0        0        0     2        0        18683
>   000000008398fb08 16  0          00000000 0        0        0     2        0        27
>
>   $ cat /proc/net/ipv6_route
>   fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
>   fe80000000000000c04b03fffe7827ce 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>   ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000003 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   $ cat /sys/kernel/bpfdump/ipv6_route/my1
>   fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
>   fe80000000000000c04b03fffe7827ce 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>   ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000003 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  .../selftests/bpf/progs/bpfdump_ipv6_route.c  | 63 ++++++++++++++++
>  .../selftests/bpf/progs/bpfdump_netlink.c     | 74 +++++++++++++++++++
>  2 files changed, 137 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_ipv6_route.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_netlink.c
>
> diff --git a/tools/testing/selftests/bpf/progs/bpfdump_ipv6_route.c b/tools/testing/selftests/bpf/progs/bpfdump_ipv6_route.c
> new file mode 100644
> index 000000000000..590e56791052
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpfdump_ipv6_route.c
> @@ -0,0 +1,63 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include <bpf/bpf_endian.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +extern bool CONFIG_IPV6_SUBTREES __kconfig __weak;
> +
> +#define        RTF_GATEWAY             0x0002
> +#define IFNAMSIZ               16
> +#define fib_nh_gw_family        nh_common.nhc_gw_family
> +#define fib_nh_gw6              nh_common.nhc_gw.ipv6
> +#define fib_nh_dev              nh_common.nhc_dev
> +
> +SEC("dump//sys/kernel/bpfdump/ipv6_route")
> +int BPF_PROG(dump_ipv6_route, struct fib6_info *rt, struct seq_file *seq, u64 seq_num)
> +{
> +       struct fib6_nh *fib6_nh = &rt->fib6_nh[0];
> +       unsigned int flags = rt->fib6_flags;
> +       const struct net_device *dev;
> +       struct nexthop *nh;
> +       static const char fmt1[] = "%pi6 %02x ";
> +       static const char fmt2[] = "%pi6 ";
> +       static const char fmt3[] = "00000000000000000000000000000000 ";
> +       static const char fmt4[] = "%08x %08x ";
> +       static const char fmt5[] = "%8s\n";
> +       static const char fmt6[] = "\n";
> +       static const char fmt7[] = "00000000000000000000000000000000 00 ";
> +
> +       /* FIXME: nexthop_is_multipath is not handled here. */
> +       nh = rt->nh;
> +       if (rt->nh)
> +               fib6_nh = &nh->nh_info->fib6_nh;
> +
> +       bpf_seq_printf(seq, fmt1, sizeof(fmt1), &rt->fib6_dst.addr,
> +                      rt->fib6_dst.plen);
> +
> +       if (CONFIG_IPV6_SUBTREES)
> +               bpf_seq_printf(seq, fmt1, sizeof(fmt1), &rt->fib6_src.addr,
> +                              rt->fib6_src.plen);
> +       else
> +               bpf_seq_printf(seq, fmt7, sizeof(fmt7));
> +
> +       if (fib6_nh->fib_nh_gw_family) {
> +               flags |= RTF_GATEWAY;
> +               bpf_seq_printf(seq, fmt2, sizeof(fmt2), &fib6_nh->fib_nh_gw6);
> +       } else {
> +               bpf_seq_printf(seq, fmt3, sizeof(fmt3));
> +       }
> +
> +       dev = fib6_nh->fib_nh_dev;
> +       bpf_seq_printf(seq, fmt4, sizeof(fmt4), rt->fib6_metric, rt->fib6_ref.refs.counter);
> +       bpf_seq_printf(seq, fmt4, sizeof(fmt4), 0, flags);
> +       if (dev)
> +               bpf_seq_printf(seq, fmt5, sizeof(fmt5), dev->name);
> +       else
> +               bpf_seq_printf(seq, fmt6, sizeof(fmt6));
> +
> +       return 0;
> +}
> diff --git a/tools/testing/selftests/bpf/progs/bpfdump_netlink.c b/tools/testing/selftests/bpf/progs/bpfdump_netlink.c
> new file mode 100644
> index 000000000000..37c9be546b99
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpfdump_netlink.c
> @@ -0,0 +1,74 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include <bpf/bpf_endian.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +#define sk_rmem_alloc  sk_backlog.rmem_alloc
> +#define sk_refcnt      __sk_common.skc_refcnt
> +
> +#define offsetof(TYPE, MEMBER)  ((size_t)&((TYPE *)0)->MEMBER)
> +#define container_of(ptr, type, member) ({                              \
> +        void *__mptr = (void *)(ptr);                                   \
> +        ((type *)(__mptr - offsetof(type, member))); })
> +
> +static inline struct inode *SOCK_INODE(struct socket *socket)
> +{
> +       return &container_of(socket, struct socket_alloc, socket)->vfs_inode;
> +}
> +
> +SEC("dump//sys/kernel/bpfdump/netlink")

We discussed already on previous patch, but just to put it visually
into comparison:

SEC("dump/netlink")

looks so much nicer :)

> +int BPF_PROG(dump_netlink, struct netlink_sock *nlk, struct seq_file *seq, u64 seq_num)
> +{
> +       static const char banner[] =
> +               "sk               Eth Pid        Groups   "
> +               "Rmem     Wmem     Dump  Locks    Drops    Inode\n";
> +       static const char fmt1[] = "%pK %-3d ";
> +       static const char fmt2[] = "%-10u %08x ";
> +       static const char fmt3[] = "%-8d %-8d ";
> +       static const char fmt4[] = "%-5d %-8d ";
> +       static const char fmt5[] = "%-8u %-8lu\n";
> +       struct sock *s = &nlk->sk;
> +       unsigned long group, ino;
> +       struct inode *inode;
> +       struct socket *sk;
> +
> +       if (seq_num == 0)
> +               bpf_seq_printf(seq, banner, sizeof(banner));
> +
> +       bpf_seq_printf(seq, fmt1, sizeof(fmt1), s, s->sk_protocol);
> +
> +       if (!nlk->groups)  {
> +               group = 0;
> +       } else {
> +               /* FIXME: temporary use bpf_probe_read here, needs
> +                * verifier support to do direct access.
> +                */
> +               bpf_probe_read(&group, sizeof(group), &nlk->groups[0]);

Is this what's being fixed by patch #10?

> +       }
> +       bpf_seq_printf(seq, fmt2, sizeof(fmt2), nlk->portid, (u32)group);
> +
> +
> +       bpf_seq_printf(seq, fmt3, sizeof(fmt3), s->sk_rmem_alloc.counter,
> +                      s->sk_wmem_alloc.refs.counter - 1);
> +       bpf_seq_printf(seq, fmt4, sizeof(fmt4), nlk->cb_running,
> +                      s->sk_refcnt.refs.counter);
> +
> +       sk = s->sk_socket;
> +       if (!sk) {
> +               ino = 0;
> +       } else {
> +               /* FIXME: container_of inside SOCK_INODE has a forced
> +                * type conversion, and direct access cannot be used
> +                * with current verifier.
> +                */
> +               inode = SOCK_INODE(sk);
> +               bpf_probe_read(&ino, sizeof(ino), &inode->i_ino);
> +       }
> +       bpf_seq_printf(seq, fmt5, sizeof(fmt5), s->sk_drops.counter, ino);
> +
> +       return 0;
> +}
> --
> 2.24.1
>
