Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4EBE369825
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 19:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243237AbhDWRTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 13:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhDWRTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 13:19:00 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D97C061574;
        Fri, 23 Apr 2021 10:18:24 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id p126so2824698yba.1;
        Fri, 23 Apr 2021 10:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ro7xCYFTIMq+4aXdu0vnN1al3dV+lMpIl8csXTesIbU=;
        b=sjl8rnUjbHS5FhocMnzYK/CDexn3v38B54UYwP3iFCPU+PwGcOQaKI59Y3HKb8L3o8
         24R/zBF5yZjwwZhtFTyRQfIgmP/FK7hzDREhgJEBcwOrAxisuw3NLqZVL+kPsfHtNlwW
         NJB3t59NfUhelqL5udZkEu4iqdaCNRPxsYoSYUDsA45GP03reoaa4LQnDQ3LRf4AtgfQ
         e3e3gc4tS+XJMEGxnflX0ykJH8HZDxY7PGFf2CnF+bHo0pIou8OKxupWLdI6vN17f6Yq
         N0g5XupONvXOVW1W0eAnloXkB1QmVdAfExNVDpW6jZUXQ09A9HUAMpW7lBOcEsCysbS0
         lHVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ro7xCYFTIMq+4aXdu0vnN1al3dV+lMpIl8csXTesIbU=;
        b=RsFMxv9XvI7TGxWjLGuNVZZQak/x9sB4zWNUCN6BZW+KoDLU25RrUTkrHkuu70ZE7Y
         I3UuniYpINPmMkfBn+agt5mwMeeHIIw1oK5iotckx08DxN3afLqZSrSmTVKBVVnaFRTv
         8YAJF6CubvdTl14R4VRPXbZCAp8GKeEnoJeDhDZt/fMQxdkyEk0F1CJC5BPrvMzi7kS/
         u7iLKTnJhyo0lw3sThzbMFKDrSfnp00fIhDWNlg24O/mGiJ1j/ikMqOrd5wMoKHc48yU
         bjxXPlYGWPZIpIYntqM5uHr9tWdt4QY8sZ4HAkZMMTkY0ayZi95qAu3yQuO/CIcYOy4Z
         QXYg==
X-Gm-Message-State: AOAM531b7mkdiEQesPjSd0wBzd+EE9chubG1ycz78Hzzv2zGWqpme+ix
        2TG+MvalQoJQd4rirk6T6lLjYAZr5V1n7ySd9Lw=
X-Google-Smtp-Source: ABdhPJy/PI8enZ3VVWM1OOLOMAN/E+WKrgw2anRZOFWnpYPUGT0G3hO4Kbh7I2X0+QHUB6roP+X1D3RE4Q9uSs8Ln9Q=
X-Received: by 2002:a25:c4c5:: with SMTP id u188mr6949290ybf.425.1619198303207;
 Fri, 23 Apr 2021 10:18:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-16-andrii@kernel.org>
 <3947e6ff-0b73-995e-630f-4a1252f8694b@fb.com>
In-Reply-To: <3947e6ff-0b73-995e-630f-4a1252f8694b@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Apr 2021 10:18:12 -0700
Message-ID: <CAEf4BzasVszkBCA0Ra2NsU+0ixoR65khF2E6h7CG_P3FOyamFQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 15/17] selftests/bpf: add function linking selftest
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 5:50 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/16/21 1:24 PM, Andrii Nakryiko wrote:
> > Add selftest validating various aspects of statically linking functions:
> >    - no conflicts and correct resolution for name-conflicting static funcs;
> >    - correct resolution of extern functions;
> >    - correct handling of weak functions, both resolution itself and libbpf's
> >      handling of unused weak function that "lost" (it leaves gaps in code with
> >      no ELF symbols);
> >    - correct handling of hidden visibility to turn global function into
> >      "static" for the purpose of BPF verification.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Ack with a small nit below.
>
> Acked-by: Yonghong Song <yhs@fb.com>
>
> > ---
> >   tools/testing/selftests/bpf/Makefile          |  3 +-
> >   .../selftests/bpf/prog_tests/linked_funcs.c   | 42 +++++++++++
> >   .../selftests/bpf/progs/linked_funcs1.c       | 73 +++++++++++++++++++
> >   .../selftests/bpf/progs/linked_funcs2.c       | 73 +++++++++++++++++++
> >   4 files changed, 190 insertions(+), 1 deletion(-)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_funcs.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs1.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs2.c
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 666b462c1218..427ccfec1a6a 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -308,9 +308,10 @@ endef
> >
> >   SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
> >
> > -LINKED_SKELS := test_static_linked.skel.h
> > +LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h
> >
> >   test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
> > +linked_funcs.skel.h-deps := linked_funcs1.o linked_funcs2.o
> >
> >   LINKED_BPF_SRCS := $(patsubst %.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/linked_funcs.c b/tools/testing/selftests/bpf/prog_tests/linked_funcs.c
> > new file mode 100644
> > index 000000000000..03bf8ef131ce
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/linked_funcs.c
> > @@ -0,0 +1,42 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2021 Facebook */
> > +
> > +#include <test_progs.h>
> > +#include <sys/syscall.h>
> > +#include "linked_funcs.skel.h"
> > +
> > +void test_linked_funcs(void)
> > +{
> > +     int err;
> > +     struct linked_funcs *skel;
> > +
> > +     skel = linked_funcs__open();
> > +     if (!ASSERT_OK_PTR(skel, "skel_open"))
> > +             return;
> > +
> > +     skel->rodata->my_tid = syscall(SYS_gettid);
> > +     skel->rodata->syscall_id = SYS_getpgid;
> > +
> > +     err = linked_funcs__load(skel);
> > +     if (!ASSERT_OK(err, "skel_load"))
> > +             goto cleanup;
> > +
> > +     err = linked_funcs__attach(skel);
> > +     if (!ASSERT_OK(err, "skel_attach"))
> > +             goto cleanup;
> > +
> > +     /* trigger */
> > +     syscall(SYS_getpgid);
> > +
> > +     ASSERT_EQ(skel->bss->output_val1, 2000 + 2000, "output_val1");
> > +     ASSERT_EQ(skel->bss->output_ctx1, SYS_getpgid, "output_ctx1");
> > +     ASSERT_EQ(skel->bss->output_weak1, 42, "output_weak1");
> > +
> > +     ASSERT_EQ(skel->bss->output_val2, 2 * 1000 + 2 * (2 * 1000), "output_val2");
> > +     ASSERT_EQ(skel->bss->output_ctx2, SYS_getpgid, "output_ctx2");
> > +     /* output_weak2 should never be updated */
> > +     ASSERT_EQ(skel->bss->output_weak2, 0, "output_weak2");
> > +
> > +cleanup:
> > +     linked_funcs__destroy(skel);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/linked_funcs1.c b/tools/testing/selftests/bpf/progs/linked_funcs1.c
> > new file mode 100644
> > index 000000000000..cc621d4e4d82
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/linked_funcs1.c
> > @@ -0,0 +1,73 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2021 Facebook */
> > +
> > +#include "vmlinux.h"
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_tracing.h>
> > +
> > +/* weak and shared between two files */
> > +const volatile int my_tid __weak = 0;
> > +const volatile long syscall_id __weak = 0;
>
> Since the new compiler (llvm13) is recommended for this patch set.
> We can simplify the above two definition with
>    int my_tid __weak;
>    long syscall_id __weak;
> The same for the other file.

This is not about old vs new compilers. I wanted to use .rodata
variables, but I'll switch to .bss, no problem.

>
> But I am also okay with the current form
> to *satisfy* llvm10 some people may still use.
>
> > +
> > +int output_val1 = 0;
> > +int output_ctx1 = 0;
> > +int output_weak1 = 0;
> > +
> > +/* same "subprog" name in all files, but it's ok because they all are static */
> > +static __noinline int subprog(int x)
> > +{
> > +     /* but different formula */
> > +     return x * 1;
> > +}
> > +
> > +/* Global functions can't be void */
> > +int set_output_val1(int x)
> > +{
> > +     output_val1 = x + subprog(x);
> > +     return x;
> > +}
> > +
> > +/* This function can't be verified as global, as it assumes raw_tp/sys_enter
> > + * context and accesses syscall id (second argument). So we mark it as
> > + * __hidden, so that libbpf will mark it as static in the final object file,
> > + * right before verifying it in the kernel.
> > + *
> > + * But we don't mark it as __hidden here, rather at extern site. __hidden is
> > + * "contaminating" visibility, so it will get propagated from either extern or
> > + * actual definition (including from the losing __weak definition).
> > + */
> > +void set_output_ctx1(__u64 *ctx)
> > +{
> > +     output_ctx1 = ctx[1]; /* long id, same as in BPF_PROG below */
> > +}
> > +
> > +/* this weak instance should win because it's the first one */
> > +__weak int set_output_weak(int x)
> > +{
> > +     output_weak1 = x;
> > +     return x;
> > +}
> > +
> > +extern int set_output_val2(int x);
> > +
> > +/* here we'll force set_output_ctx2() to be __hidden in the final obj file */
> > +__hidden extern void set_output_ctx2(__u64 *ctx);
> > +
> [...]
