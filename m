Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC1C1C67D1
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgEFGB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725771AbgEFGB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:01:27 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB55C061A0F;
        Tue,  5 May 2020 23:01:27 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b6so797078qkh.11;
        Tue, 05 May 2020 23:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+JO6i0n3BKhKys7BXtPUEzF0yojiQcWesZP2vQRQIxA=;
        b=P9GVNwZ5pGrLU9e6S75s00C7k7Q/gqLg4drFxyx4hub8E7plw+Q04G+323WoLjeWrX
         EruWMXyOCv4lA0WgWWhw3nWvdIAgn1GYXOTfx18ArOVbTrD5g0HgEDZk/Tu/j8yA1l1g
         ncmImIsx6haBSkGblFHrA+VDjRAQkcLm9wKavrdbwx/3ol5lKPhAImMzY6x0TsEM+HrY
         /3Ugoc3jKL1XF2h74Znk7cbiHBNyBIIsPvPQkD3576c5a3vmgEKi9vn1IhcX9ovybHIN
         I4ZehDvM4yhojG9kJoXkA6AI7wVNTCAbyY7MlVW1isGqM6QSEKafn1wpDJeaG5MKrmzL
         I4mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+JO6i0n3BKhKys7BXtPUEzF0yojiQcWesZP2vQRQIxA=;
        b=nARXu2ZOqq6BuJQKgIa+se9oqpoUuGqRdy9dwvHdJRs3EkOAH1oQUXWl/9iLlTbPik
         WW7gONGLip2OCYCSqLiE7LTLV4yDeIKHqnoEgywoJ9n2+Ggi5H4CEkQaQ4LbTDl49rmI
         SUazwCGF9Pjdn+cgN6qBjuLRXLsZEySZ/L7Gfq/BuO+KoA9K5sV/heq2QH94iLgWAiTk
         lMK2PKsaPgxvedovHxifnkxjdCFiW13UKUnaukdjOBQOk9/2HktoARmOqL1ZiDkhp9xe
         1TvDmROUMdvCEWGt9xqefmh4CIfLUIj7snwcHIimZDz0K5Vi7qQP9gB+DKmfE7TC5fNs
         v4Gw==
X-Gm-Message-State: AGi0Pubzx5zEq8MFgfqHFJ/U3vFCwmQtDJba7BNbODrWRdV4KTTNDa+M
        TMKkuSZCwcYIif/HsTJci8yyySphm/hh4l4UUH0=
X-Google-Smtp-Source: APiQypIuvoVsMMx/ygq+c38uJY64J4U+3kVGaxFQE3h17xtrH87AIJCSvprAmZ2v8JW0oYDTXz+nW2YpcAb8TUskVh0=
X-Received: by 2002:a37:68f:: with SMTP id 137mr7289382qkg.36.1588744886373;
 Tue, 05 May 2020 23:01:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062608.2049044-1-yhs@fb.com>
In-Reply-To: <20200504062608.2049044-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 23:01:15 -0700
Message-ID: <CAEf4Bzae=1h4Rky+ojeoaxUR6OHM5Q6OzXFqPrhoOM4D3EYuCA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 18/20] tools/bpf: selftests: add iterator
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

On Sun, May 3, 2020 at 11:30 PM Yonghong Song <yhs@fb.com> wrote:
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

Looks good, but something weird with printf below...

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/progs/bpf_iter_ipv6_route.c | 63 ++++++++++++++++
>  .../selftests/bpf/progs/bpf_iter_netlink.c    | 74 +++++++++++++++++++
>  2 files changed, 137 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
>
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c b/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
> new file mode 100644
> index 000000000000..0dee4629298f
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
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

nit: these look weirdly unaligned :)

> +#define fib_nh_gw_family        nh_common.nhc_gw_family
> +#define fib_nh_gw6              nh_common.nhc_gw.ipv6
> +#define fib_nh_dev              nh_common.nhc_dev
> +

[...]


> +       dev = fib6_nh->fib_nh_dev;
> +       if (dev)
> +               BPF_SEQ_PRINTF(seq, "%08x %08x %08x %08x %8s\n", rt->fib6_metric,
> +                              rt->fib6_ref.refs.counter, 0, flags, dev->name);
> +       else
> +               BPF_SEQ_PRINTF(seq, "%08x %08x %08x %08x %8s\n", rt->fib6_metric,
> +                              rt->fib6_ref.refs.counter, 0, flags);

hmm... how does it work? you specify 4 params, but format string
expects 5. Shouldn't this fail?

> +
> +       return 0;
> +}
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c b/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
> new file mode 100644
> index 000000000000..0a85a621a36d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
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
> +#define container_of(ptr, type, member)                                \
> +       ({                                                      \
> +               void *__mptr = (void *)(ptr);                   \
> +               ((type *)(__mptr - offsetof(type, member)));    \
> +       })

we should probably put offsetof(), offsetofend() and container_of()
macro into bpf_helpers.h, seems like universal things for kernel
datastructs :)

[...]
