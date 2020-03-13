Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBBFC184D63
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 18:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgCMRQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 13:16:36 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33106 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgCMRQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 13:16:36 -0400
Received: by mail-qt1-f194.google.com with SMTP id d22so8164766qtn.0;
        Fri, 13 Mar 2020 10:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lh0hV2LBWCLYpY6cGphwGr9PuJFxCLWX7eWlYeoBrDE=;
        b=DZD4Y25XT7ssinm0JN60ccOU3Ogynfx4haz2fLMw98tMNn8LsSr1gscJgGKDiECTKh
         RS4AjNttEZrxt5H4uKBpXWrW82XQ044OUeqmmJGX8676f7boSTilUakMEB3xDdXFFjp8
         KJA1ZxK0DmyJGQVdQPRzPL5X/kIwJO1psNauN+gDqGqK/NtB4InuuM6skHz0pbh+N5J7
         86FUcxjh+drLyja355fIs65TShL9lTHp61SkY/QPSVG+ICO0QI/7LxKkBVPUaNVKD1k4
         mgfioeOWHlDsFs1mg7G5ElzjRA7KP4SQlFkTs6d7Q/TafrOqeds3AmjeqctHrbL1lZ84
         F8PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lh0hV2LBWCLYpY6cGphwGr9PuJFxCLWX7eWlYeoBrDE=;
        b=tRVR6+45FShAHp44j//o6btsx8ujgcgqUU9a17LQFJwGhcZY+t+qO5OqInIgVYngtU
         9bhE/lkeoCaEXkIgYx6t/slnNC0ezAqK86zuauAHxjwiRY76I9n1c+lLLvnl122ZstkN
         5hk685JilH/UkFw3WVPkwIej4FLdugmCYNDoqMyMLq1vPTsH+JLuATtz4/2MzXI5HH0l
         zY5Sf4GJD+GmsY+6arZM79lIBL7cDQeJLpTQTehDTcAMvF0kGKzaDjXNJPgRzazRZmB9
         4K5RyL4uIX9WJBcxbvCkdFOhFvaCxyxY8bWoo3wD8DmPDHylGP0JavQhYw1YvzBT5J+/
         YqIA==
X-Gm-Message-State: ANhLgQ1pbcaXousgr4BKCZ2ay9I+0Do05K7+rjnUiPh04cmpEv3s3l3i
        QkMrNbja9CgPQqw04qEI5Ky1drZF4NowPw6qVCFfzc/V
X-Google-Smtp-Source: ADFU+vvu2bsR+GkgNhdMuRAqjIMcKyaF6MFWKbAJYHLL3u475yojH2HQvWwv2dMaE6FAGO5keX22QK1ZNFHOfp8KJr8=
X-Received: by 2002:ac8:4e14:: with SMTP id c20mr13345117qtw.141.1584119795371;
 Fri, 13 Mar 2020 10:16:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200313075442.4071486-1-andriin@fb.com> <20200313075442.4071486-5-andriin@fb.com>
 <20200313170212.lf4lnljwtvhypkew@kafai-mbp>
In-Reply-To: <20200313170212.lf4lnljwtvhypkew@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Mar 2020 10:16:24 -0700
Message-ID: <CAEf4BzbZ0rQ=Lwvvy1Kk8jQqRdHzPNodcXTHD=i1px7DKa-YsA@mail.gmail.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next 4/4] selftests/bpf: add
 vmlinux.h selftest exercising tracing of syscalls
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 10:02 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Mar 13, 2020 at 12:54:41AM -0700, Andrii Nakryiko wrote:
> > Add vmlinux.h generation to selftest/bpf's Makefile. Use it from newly added
> > test_vmlinux to trace nanosleep syscall using 5 different types of programs:
> >   - tracepoint;
> >   - raw tracepoint;
> >   - raw tracepoint w/ direct memory reads (tp_btf);
> >   - kprobe;
> >   - fentry.
> >
> > These programs are realistic variants of real-life tracing programs,
> > excercising vmlinux.h's usage with tracing applications.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> [ ... ]
>
> > diff --git a/tools/testing/selftests/bpf/prog_tests/vmlinux.c b/tools/testing/selftests/bpf/prog_tests/vmlinux.c
> > new file mode 100644
> > index 000000000000..04939eda1325
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/vmlinux.c
> > @@ -0,0 +1,43 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2020 Facebook */
> > +
> > +#include <test_progs.h>
> > +#include <time.h>
> > +#include "test_vmlinux.skel.h"
> > +
> > +#define MY_TV_NSEC 1337
> > +
> > +static void nsleep()
> > +{
> > +     struct timespec ts = { .tv_nsec = MY_TV_NSEC };
> > +
> > +     (void)nanosleep(&ts, NULL);
> > +}
> > +
> > +void test_vmlinux(void)
> > +{
> > +     int duration = 0, err;
> > +     struct test_vmlinux* skel;
> > +     struct test_vmlinux__bss *bss;
> > +
> > +     skel = test_vmlinux__open_and_load();
> > +     if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> > +             return;
> > +     bss = skel->bss;
> > +
> > +     err = test_vmlinux__attach(skel);
> > +     if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
> > +             goto cleanup;
> > +
> > +     /* trigger everything */
> > +     nsleep();
> > +
> > +     CHECK(!bss->tp_called, "tp", "not called\n");
> > +     CHECK(!bss->raw_tp_called, "raw_tp", "not called\n");
> > +     CHECK(!bss->tp_btf_called, "tp_btf", "not called\n");
> > +     CHECK(!bss->kprobe_called, "kprobe", "not called\n");
> > +     CHECK(!bss->fentry_called, "fentry", "not called\n");
> > +
> > +cleanup:
> > +     test_vmlinux__destroy(skel);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/test_vmlinux.c b/tools/testing/selftests/bpf/progs/test_vmlinux.c
> > new file mode 100644
> > index 000000000000..5cc2bf8011b0
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_vmlinux.c
> > @@ -0,0 +1,98 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2020 Facebook */
> > +
> > +#include "vmlinux.h"
> > +#include <asm/unistd.h>
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_tracing.h>
> > +#include <bpf/bpf_core_read.h>
> > +
> > +#define MY_TV_NSEC 1337
> > +
> > +bool tp_called = false;
> > +bool raw_tp_called = false;
> > +bool tp_btf_called = false;
> > +bool kprobe_called = false;
> > +bool fentry_called = false;
> > +
> > +SEC("tp/syscalls/sys_enter_nanosleep")
> > +int handle__tp(struct trace_event_raw_sys_enter *args)
> > +{
> > +     struct __kernel_timespec *ts;
> > +
> > +     if (args->id != __NR_nanosleep)
> > +             return 0;
> > +
> > +     ts = (void *)args->args[0];
> > +     if (BPF_CORE_READ(ts, tv_nsec) != MY_TV_NSEC)
> > +             return 0;
> > +
> > +     tp_called = true;
> > +     return 0;
> > +}
> > +
> > +static bool __always_inline handle_probed(struct pt_regs *regs, long id)
> It is not used, may be removing it?
>

Oh, did I really leave it around?... Sigh, will post v2 without it.


> > +{
> > +     struct __kernel_timespec *ts;
> > +
> > +     if (id != __NR_nanosleep)
> > +             return false;
> > +
> > +     ts = (void *)PT_REGS_PARM1_CORE(regs);
> > +     if (BPF_CORE_READ(ts, tv_nsec) != MY_TV_NSEC)
> > +             return false;
> > +
> > +     return true;
> > +}
