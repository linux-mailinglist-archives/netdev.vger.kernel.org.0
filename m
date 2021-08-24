Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F683F5774
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 06:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhHXFAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 01:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbhHXFAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 01:00:04 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD96C061575;
        Mon, 23 Aug 2021 21:59:20 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id f15so10229865ybg.3;
        Mon, 23 Aug 2021 21:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=17KYTMCnTi2z2l5ALdgtQNaS1BaS2qFMHtmvlTtkPYg=;
        b=TBa6yO1R49zx2vQEc8KiF/cj1vR7hwwx+hhVwgiXJeDvsIYAQtPgszQmtZURB9Md5u
         7KUrBxWdru4+C29RIIYlYLQ9T5aQhC70TYAYxEczXHFtodm99iuncS3ID5g7zKY8rOOG
         sLXbAjttxH0X/1Tv1jsH/u5JaZbxjg4vkxCG89erpvPQ4/g91QXnB/izrfkBh2bL94Rr
         kB8wM2Ui70iunTI0kC38+IfiTOdzD70qSrd6H6EEK+1G55whLs0h9xVqXUXCOqqyJVOr
         RZMMaqo2fXQHHV1oyeNwMQM64wtLcciNJKTYlyNkksE4IenblxXmKaGXfuEN4nAishlF
         VMBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=17KYTMCnTi2z2l5ALdgtQNaS1BaS2qFMHtmvlTtkPYg=;
        b=O5CAUomsAY/hCGNmqANZOukn9ulkWwHWcDhv+oDZO06dKth02YK+dsxF6XSPYvcez2
         AK87wwbgcAc2knsLVrxfVPmLB6lPqN1fAyuhdNzFvmsaXsaNjssDSLmTjpvH389UpHTz
         d3x8NgGEVSbnugSBsWHkCVidhQWj3VKdj1bvFosBylVZrYJggc8bMIado4MMaRkCHOez
         jDt6+KiLfDV6BXoHOPeOajIJC7NZH/THgxdzrJ7wnfIvUOxOWQ/bL4UQEFElZUhQGUaz
         7avWe20hdn61mRsuz/R83EBu3rj85CTHAU9vWlt77yGrgiQzQOtcpzx1swK1HYvd/8QT
         8sVg==
X-Gm-Message-State: AOAM5323QP7GSrb8+vx38qWZfGqgQKumhXkmfMv2/YMg0wLt9MFD/nhn
        6mC+B0+GnkwRxugN8TtXqBj9SNX8983Wm3t3oOQ=
X-Google-Smtp-Source: ABdhPJzdcHojAcoPBe4rwfc1cc2oB0rZzhFw00nrhVl5HjKyYUyMIB6dj1/hrRuGrZItzhj6ojojSHuvvNYTGNoh38A=
X-Received: by 2002:a25:fc10:: with SMTP id v16mr28237345ybd.510.1629781160100;
 Mon, 23 Aug 2021 21:59:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210821025837.1614098-1-davemarchevsky@fb.com> <20210821025837.1614098-6-davemarchevsky@fb.com>
In-Reply-To: <20210821025837.1614098-6-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Aug 2021 21:59:09 -0700
Message-ID: <CAEf4BzYeRNKWfSaqyzhNbm7qdLoWGzFLp9A05pVmQKU_f0zY5Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: add trace_vprintk test prog
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Florent Revest <revest@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 7:59 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> This commit adds a test prog for vprintk which confirms that:
>   * bpf_trace_vprintk is writing to dmesg
>   * bpf_vprintk convenience macro works as expected
>   * >3 args are printed
>
> Approach and code are borrowed from trace_printk test.
>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---
>  tools/testing/selftests/bpf/Makefile          |  3 +-
>  .../selftests/bpf/prog_tests/trace_vprintk.c  | 75 +++++++++++++++++++
>  .../selftests/bpf/progs/trace_vprintk.c       | 25 +++++++
>  3 files changed, 102 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_vprintk.c
>  create mode 100644 tools/testing/selftests/bpf/progs/trace_vprintk.c
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 2a58b7b5aea4..af5e7a1e9a7c 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -313,7 +313,8 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h               \
>                 linked_vars.skel.h linked_maps.skel.h
>
>  LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
> -       test_ksyms_module.c test_ringbuf.c atomics.c trace_printk.c
> +       test_ksyms_module.c test_ringbuf.c atomics.c trace_printk.c \
> +       trace_vprintk.c
>  SKEL_BLACKLIST += $$(LSKELS)
>
>  test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
> diff --git a/tools/testing/selftests/bpf/prog_tests/trace_vprintk.c b/tools/testing/selftests/bpf/prog_tests/trace_vprintk.c
> new file mode 100644
> index 000000000000..fd70427d2918
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/trace_vprintk.c
> @@ -0,0 +1,75 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +
> +#include <test_progs.h>
> +
> +#include "trace_vprintk.lskel.h"
> +
> +#define TRACEBUF       "/sys/kernel/debug/tracing/trace_pipe"
> +#define SEARCHMSG      "1,2,3,4,5,6,7,8,9,10"
> +
> +void test_trace_vprintk(void)
> +{
> +       int err, iter = 0, duration = 0, found = 0;
> +       struct trace_vprintk__bss *bss;
> +       struct trace_vprintk *skel;
> +       char *buf = NULL;
> +       FILE *fp = NULL;
> +       size_t buflen;
> +
> +       skel = trace_vprintk__open();
> +       if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> +               return;

Let's use ASSERT_xxx() in new tests, no new CHECK() uses.


> +
> +       err = trace_vprintk__load(skel);
> +       if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))

you should be able to combine open and load into trace_vprintk__open_and_load()

> +               goto cleanup;
> +
> +       bss = skel->bss;
> +
> +       err = trace_vprintk__attach(skel);
> +       if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
> +               goto cleanup;
> +

[...]
