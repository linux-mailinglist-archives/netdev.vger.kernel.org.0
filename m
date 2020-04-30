Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C291BEE21
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 04:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgD3CMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 22:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3CMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 22:12:41 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69628C035494;
        Wed, 29 Apr 2020 19:12:40 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id k12so3803374qtm.4;
        Wed, 29 Apr 2020 19:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sDMd0/hqud/PMdgZAwD4h3pUtKi9lGJdDj8hIUCvV6o=;
        b=aHLOkWU63+GkcpMx0zLnhGljIMIohXYX2POcodUO6hvTaQ+pD9kmh+9Sx59VpSIbK/
         XmOC7bUu2wcNMhNC446Tyvx7jVisebk4zVSIL6xXn8B+TijqS0au0UWjmM8QBNcKj/wH
         Shj7nwYleovBHPUt66mmDmK4mpKLmz+bcFzwHyQeoTLBa4RgNpNbsX1nkC9KhUOT+4sn
         ooVGcF88SzTdtm/NkpMF/pnTZsycYFJ/Uy6zzY3uVGj3VhiaNXeoYIBsCQ4SOYpu+2lf
         qEiW3A5TdbmSPCQqcNAZ5Ufk5+ZCp5OdLNPHMuHqmlPTJVNigAvZhAfmtaZxCEvZOlmX
         fF1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sDMd0/hqud/PMdgZAwD4h3pUtKi9lGJdDj8hIUCvV6o=;
        b=H/4e2xfmu5bSnOFHoPfWLzGxuyk5j2dAGL1EqJYBQu2OKSWwTgdS179vtV/D3u4P1+
         rLnRELD4mAnPjZ86rtG8MAZgMvThg3I+Q07r3UZ+0y1h9rNmP4ncaLZWkApklDHkQWbe
         X1wPZ04T9b/qlS2GFgDU1aFPoW8vx1uiuHfNczqOCiV/Pqd4k5yYBFUC+dT25OlfEFFD
         GAdZ9qPZ+xUGD715LI2HNsaQvoZ7zSzaEIaPGiWtGKZy0zrO6eGC90o684Izfs83WbGt
         meiTKpgd5F9EhYSwM4a7zPQdnI2QGuxAaihStYmB1gRyDcewyzxps+YWB1pE4SE89Qom
         H/dA==
X-Gm-Message-State: AGi0PuZAm+A7yUQtLGOrR+vwrSR7PIC5p9z8lHrwRXRJKX/RX75t1K9y
        6SZ2hPENwQZoVwrfaaR4WFdWIOAozodd7E9p71I=
X-Google-Smtp-Source: APiQypIp5/I5WDjbckqyIu7EMbS7+rob3pzMu7ANmsM69l0Yg2+MwSDRUrHb/FX9IUpKqvVF5wL6BnCumUraNRTnGlM=
X-Received: by 2002:ac8:3f6d:: with SMTP id w42mr1338943qtk.171.1588212759492;
 Wed, 29 Apr 2020 19:12:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201235.2994549-1-yhs@fb.com> <20200427201255.2996209-1-yhs@fb.com>
In-Reply-To: <20200427201255.2996209-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Apr 2020 19:12:28 -0700
Message-ID: <CAEf4BzYv5eA-sgoUZdM7DP=TUHZB++qpcPNJ1egCr0d7peEXNg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 17/19] tools/bpf: selftests: add iterator
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

On Mon, Apr 27, 2020 at 1:18 PM Yonghong Song <yhs@fb.com> wrote:
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
>   $ cat /sys/fs/bpf/my_netlink
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
>   $ cat /sys/fs/bpf/my_ipv6_route
>   fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
>   fe80000000000000c04b03fffe7827ce 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>   ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000003 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  .../selftests/bpf/progs/bpf_iter_ipv6_route.c | 69 +++++++++++++++++
>  .../selftests/bpf/progs/bpf_iter_netlink.c    | 77 +++++++++++++++++++
>  2 files changed, 146 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
>
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c b/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
> new file mode 100644
> index 000000000000..bed34521f997
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
> @@ -0,0 +1,69 @@
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
> +SEC("iter/ipv6_route")
> +int dump_ipv6_route(struct bpf_iter__ipv6_route *ctx)
> +{
> +       static const char fmt1[] = "%pi6 %02x ";
> +       static const char fmt2[] = "%pi6 ";
> +       static const char fmt3[] = "00000000000000000000000000000000 ";
> +       static const char fmt4[] = "%08x %08x %08x %08x %8s\n";
> +       static const char fmt5[] = "%08x %08x %08x %08x\n";
> +       static const char fmt7[] = "00000000000000000000000000000000 00 ";
> +       struct seq_file *seq = ctx->meta->seq;
> +       struct fib6_info *rt = ctx->rt;
> +       const struct net_device *dev;
> +       struct fib6_nh *fib6_nh;
> +       unsigned int flags;
> +       struct nexthop *nh;
> +
> +       if (rt == (void *)0)
> +               return 0;
> +
> +       fib6_nh = &rt->fib6_nh[0];
> +       flags = rt->fib6_flags;
> +
> +       /* FIXME: nexthop_is_multipath is not handled here. */
> +       nh = rt->nh;
> +       if (rt->nh)
> +               fib6_nh = &nh->nh_info->fib6_nh;
> +
> +       BPF_SEQ_PRINTF(seq, fmt1, &rt->fib6_dst.addr, rt->fib6_dst.plen);
> +
> +       if (CONFIG_IPV6_SUBTREES)
> +               BPF_SEQ_PRINTF(seq, fmt1, &rt->fib6_src.addr,
> +                              rt->fib6_src.plen);
> +       else
> +               BPF_SEQ_PRINTF0(seq, fmt7);

Looking at these examples, I think BPF_SEQ_PRINTF should just assume
that fmt argument is string literal and do:

static const char ___tmp_fmt[] = fmt;

inside that macro. So one can just do:

BPF_SEQ_PRINTF(seq, "Hello, world!\n");

or

BPF_SEQ_PRINTF(seq, "My awesome template %d ==> %s\n", id, some_string);

WDYT?

> +
> +       if (fib6_nh->fib_nh_gw_family) {
> +               flags |= RTF_GATEWAY;
> +               BPF_SEQ_PRINTF(seq, fmt2, &fib6_nh->fib_nh_gw6);
> +       } else {
> +               BPF_SEQ_PRINTF0(seq, fmt3);
> +       }
> +
> +       dev = fib6_nh->fib_nh_dev;
> +       if (dev)
> +               BPF_SEQ_PRINTF(seq, fmt4, rt->fib6_metric,
> +                              rt->fib6_ref.refs.counter, 0, flags, dev->name);
> +       else
> +               BPF_SEQ_PRINTF(seq, fmt4, rt->fib6_metric,
> +                              rt->fib6_ref.refs.counter, 0, flags);
> +
> +       return 0;
> +}

[...]
