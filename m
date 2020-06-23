Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA72205A5F
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 20:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733151AbgFWSQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 14:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728916AbgFWSQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 14:16:55 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3FCC061573;
        Tue, 23 Jun 2020 11:16:55 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id q198so11881385qka.2;
        Tue, 23 Jun 2020 11:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mldfnWKkii9NqHOu/tXDKOQ3f+s/hvhqqjnpq5hhPWY=;
        b=dodDBLcldmPsxJt8X89WGwJOvoTtN0MpO3DcU1SWAop3JWBYfEMfQXH8Q8v5FQI21y
         M3tssQMT05tLDv9R6ymn0+i+m6N+QuzwN5Y1qdZ7B2/KDYUC+Itt2Vm4F2QXgwgvZjNz
         mlaaaiiHmj7FsvhyXxCgyHHA40Zcq0kzHC3visY014WNtJ6l5BO/j/i6CQIkwfBEBwjv
         HC3BFqGOvFA1pg1s2Z1gj3WyPbjUC+BkSwUvzeBfkz3ioODYf/cWvuwnlGnDf59yfTzz
         iBTXm5nq4tQtXWf8f1LYCbt+oq81CmnvCVBA07qKm2CLXoYpx1zzOi7AFSP02d2m7WgV
         eQlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mldfnWKkii9NqHOu/tXDKOQ3f+s/hvhqqjnpq5hhPWY=;
        b=jPIW7q/drsEbtxivgUQeAsG2s1wjZJDya7nYpMfYpMeAQn0v0I9fiB6ZOok/lpTBKO
         Lwh8ht6Uh3EoqmNEdo4k0g66WfPS/sTGNkR9SUNEc4bEXH5wpICW2oqg+HsoY664HTg5
         lg1yD6Z2wTzJLjZG1uB9uVSNqSXpTaMOeP1F67owQnOXXBBb6i0b6NzeB1TeyrkkmFuY
         MYz2VlHMX5mWXD/ocM/oDkMUWiD/bNMlm5OTbPDZVJB+PatxypXkffy9WPZhqQ599FBK
         AgvZziNBedwdgOSJbLG5NvqD2oNRPSRhSDmGkjqLoy4b3rQFi7YOBu1djgK+FTWNZXIn
         UQ4A==
X-Gm-Message-State: AOAM533ppAyMwwmImd2aHVlpFbjeyGqUJSMYKkbaCJFBaD4r1HN3AEol
        rgS+tU3IMNiilNSr0Ek0AMi/We9B8FXaSKvUc0c=
X-Google-Smtp-Source: ABdhPJxMvYx/vjH10MXjHGXbvqn7hdYEvl3XK2YxTRCzZrJu73OVTYkeMJKAEbWqQ32ml9obQ63nvUw8ppJjHInKoJ4=
X-Received: by 2002:a05:620a:12d2:: with SMTP id e18mr22426657qkl.437.1592936214457;
 Tue, 23 Jun 2020 11:16:54 -0700 (PDT)
MIME-Version: 1.0
References: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com> <1592914031-31049-9-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1592914031-31049-9-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 11:16:43 -0700
Message-ID: <CAEf4BzZ8cbMBVNhxXRXapyZCm_b70y-85Xb5SpB0MWBixJ9h_w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 8/8] bpf/selftests: add tests for %pT format specifier
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Joe Perches <joe@perches.com>, Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        andriy.shevchenko@linux.intel.com, corbet@lwn.net,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 5:12 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> tests verify we get 0 return value from bpf_trace_print()
> using %pT format specifier with various modifiers/pointer
> values.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/prog_tests/trace_printk_btf.c    | 45 +++++++++++++++++++++
>  .../selftests/bpf/progs/netif_receive_skb.c        | 47 ++++++++++++++++++++++
>  2 files changed, 92 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_printk_btf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/netif_receive_skb.c
>

[...]

> diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> new file mode 100644
> index 0000000..03ca1d8
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> @@ -0,0 +1,47 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020, Oracle and/or its affiliates. */
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +int ret;
> +int num_subtests;
> +int ran_subtests;

oh, interesting, so Clang doesn't put these into the COM section
anymore? We used to need to explicitly zero-initialize these global
vars because of that.

> +
> +#define CHECK_PRINTK(_fmt, _p, res)                                    \
> +       do {                                                            \
> +               char fmt[] = _fmt;                                      \

pro tip: you can use `static const char fmt[] = _fmt` and it will just work.

> +               ++num_subtests;                                         \
> +               if (ret >= 0) {                                         \
> +                       ++ran_subtests;                                 \
> +                       ret = bpf_trace_printk(fmt, sizeof(fmt), (_p)); \
> +               }                                                       \
> +       } while (0)
> +
> +/* TRACE_EVENT(netif_receive_skb,
> + *     TP_PROTO(struct sk_buff *skb),
> + */
> +SEC("tp_btf/netif_receive_skb")
> +int BPF_PROG(trace_netif_receive_skb, struct sk_buff *skb)
> +{
> +       char skb_type[] = "struct sk_buff";

same, `static const char` will generate more optimal code (good to
have good examples in selftests for people to follow). But don't
bother re-spinning just for this.


> +       struct btf_ptr nullp = { .ptr = 0, .type = skb_type };
> +       struct btf_ptr p = { .ptr = skb, .type = skb_type };
> +
> +       CHECK_PRINTK("%pT\n", &p, &res);
> +       CHECK_PRINTK("%pTc\n", &p, &res);
> +       CHECK_PRINTK("%pTN\n", &p, &res);
> +       CHECK_PRINTK("%pTx\n", &p, &res);
> +       CHECK_PRINTK("%pT0\n", &p, &res);
> +       CHECK_PRINTK("%pTcNx0\n", &p, &res);
> +       CHECK_PRINTK("%pT\n", &nullp, &res);
> +       CHECK_PRINTK("%pTc\n", &nullp, &res);
> +       CHECK_PRINTK("%pTN\n", &nullp, &res);
> +       CHECK_PRINTK("%pTx\n", &nullp, &res);
> +       CHECK_PRINTK("%pT0\n", &nullp, &res);
> +       CHECK_PRINTK("%pTcNx0\n", &nullp, &res);
> +
> +       return 0;
> +}
> --
> 1.8.3.1
>
