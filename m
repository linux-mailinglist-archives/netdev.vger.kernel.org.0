Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEB34DEA40
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 20:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243964AbiCSTDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 15:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241126AbiCSTDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 15:03:30 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15C070063;
        Sat, 19 Mar 2022 12:02:08 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id w7so12799040ioj.5;
        Sat, 19 Mar 2022 12:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EgxPyz02VhvEbwBcREHgGKzI50ANf/xCGZd/HKHUs/U=;
        b=fbIlwx9Wz3PhT8kuan+pRkTjPTn+2Wv2YnM5gRb5+qPWVIgGsqi1KUd3X1vhBo8Hxn
         lqpRxHQWzRESIdo/ioHjABw1bg5tR7f7BuN/Jyt2lHniP1VpgOyb74aEjFhbLx1uOr/S
         /kQwPRxppq5MJXNDCn2fAq5UZeime5ybFwFqAcvH+kbQ8W+0Yq9zXH1IOR8cWwOEn9h1
         0oYNphnJuOfeFPBoMNPWZSS1QHmuRK06VluGw9LU2f/8CYT9u+OtnSe4BGLQAfqQPsbS
         1qfG6ml2p9xzFp/GRW+22mnmf9uw8206ypULXzgUTCQXgw8kJvDNOChU92xWISsve8mG
         Afcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EgxPyz02VhvEbwBcREHgGKzI50ANf/xCGZd/HKHUs/U=;
        b=uYGMIsd5i0mj5eTIQvinYDdMciOFkKkFbR1FYat0FC5Wo+JxWiPprZ80JD1jCVY4NO
         ADTQVvHxqeU16awLMonS4vCHU7LEEIcoI1bnMEObMUeQO/ABWcU76c41b2y//3Egsu5B
         dZcH6V21lJVtKKyUy/mkrEq1pmXjx91YNVNaW3wIMprQL2eTWxYp0iO/TlHhrzHf6JmJ
         0Q2evsC/yXBHXhKfqUsIU0G3HpFPmOGuCPKUq6uLqqLKlUO3HdoWOuW2+OsM5UySeRAF
         pfKHj0OosivJWbrnZDPrDxbYYxRDyAYzBhMb0iDYMcWaTAh+KE4kKJIySlAn9zwMDSbF
         Pbow==
X-Gm-Message-State: AOAM533+j0eRy0cNWsV1yT1dHFRTRQVrOW/B6e3xbM3+kw34yXdgTYb8
        fGKJuvGM0afjfAxXdf68VJbUyTQt4mb3lKeEy4c=
X-Google-Smtp-Source: ABdhPJzTG0dvatvE1XWwUoi3i2vnFdIswlXghgZ/Q8yt7zR1jWI6pQob//zSNC5LOrnds5FBiCbwF0aXI64vpmrpPtQ=
X-Received: by 2002:a05:6638:772:b0:319:e4eb:adb with SMTP id
 y18-20020a056638077200b00319e4eb0adbmr7452433jad.237.1647716527801; Sat, 19
 Mar 2022 12:02:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220316122419.933957-1-jolsa@kernel.org> <CAEf4BzbpjN6ca7D9KOTiFPOoBYkciYvTz0UJNp5c-_3ptm=Mrg@mail.gmail.com>
 <YjXMSg+BSSOv0xd1@krava> <YjXpTZUI10RVCGPD@krava> <CAEf4BzYbL0=ExUQOy3xZ-C2O6nQN3BVudBWESFNkgs0fr=uRmg@mail.gmail.com>
In-Reply-To: <CAEf4BzYbL0=ExUQOy3xZ-C2O6nQN3BVudBWESFNkgs0fr=uRmg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 19 Mar 2022 12:01:56 -0700
Message-ID: <CAEf4BzZDDqK24rSKwXNp7XL3ErGD4bZa1M6c_c4EvDSt3jrZcg@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 00/13] bpf: Add kprobe multi link
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 19, 2022 at 11:26 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Mar 19, 2022 at 7:31 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > On Sat, Mar 19, 2022 at 01:27:56PM +0100, Jiri Olsa wrote:
> > > On Fri, Mar 18, 2022 at 10:50:46PM -0700, Andrii Nakryiko wrote:
> > > > On Wed, Mar 16, 2022 at 5:24 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > > >
> > > > > hi,
> > > > > this patchset adds new link type BPF_TRACE_KPROBE_MULTI that attaches
> > > > > kprobe program through fprobe API [1] instroduced by Masami.
> > > > >
> > > > > The fprobe API allows to attach probe on multiple functions at once very
> > > > > fast, because it works on top of ftrace. On the other hand this limits
> > > > > the probe point to the function entry or return.
> > > > >
> > > > >
> > > > > With bpftrace support I see following attach speed:
> > > > >
> > > > >   # perf stat --null -r 5 ./src/bpftrace -e 'kprobe:x* { } i:ms:1 { exit(); } '
> > > > >   Attaching 2 probes...
> > > > >   Attaching 3342 functions
> > > > >   ...
> > > > >
> > > > >   1.4960 +- 0.0285 seconds time elapsed  ( +-  1.91% )
> > > > >
> > > > > v3 changes:
> > > > >   - based on latest fprobe post from Masami [2]
> > > > >   - add acks
> > > > >   - add extra comment to kprobe_multi_link_handler wrt entry ip setup [Masami]
> > > > >   - keep swap_words_64 static and swap values directly in
> > > > >     bpf_kprobe_multi_cookie_swap [Andrii]
> > > > >   - rearrange locking/migrate setup in kprobe_multi_link_prog_run [Andrii]
> > > > >   - move uapi fields [Andrii]
> > > > >   - add bpf_program__attach_kprobe_multi_opts function [Andrii]
> > > > >   - many small test changes [Andrii]
> > > > >   - added tests for bpf_program__attach_kprobe_multi_opts
> > > > >   - make kallsyms_lookup_name check for empty string [Andrii]
> > > > >
> > > > > v2 changes:
> > > > >   - based on latest fprobe changes [1]
> > > > >   - renaming the uapi interface to kprobe multi
> > > > >   - adding support for sort_r to pass user pointer for swap functions
> > > > >     and using that in cookie support to keep just single functions array
> > > > >   - moving new link to kernel/trace/bpf_trace.c file
> > > > >   - using single fprobe callback function for entry and exit
> > > > >   - using kvzalloc, libbpf_ensure_mem functions
> > > > >   - adding new k[ret]probe.multi sections instead of using current kprobe
> > > > >   - used glob_match from test_progs.c, added '?' matching
> > > > >   - move bpf_get_func_ip verifier inline change to seprate change
> > > > >   - couple of other minor fixes
> > > > >
> > > > >
> > > > > Also available at:
> > > > >   https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> > > > >   bpf/kprobe_multi
> > > > >
> > > > > thanks,
> > > > > jirka
> > > > >
> > > > >
> > > > > [1] https://lore.kernel.org/bpf/164458044634.586276.3261555265565111183.stgit@devnote2/
> > > > > [2] https://lore.kernel.org/bpf/164735281449.1084943.12438881786173547153.stgit@devnote2/
> > > > > ---
> > > > > Jiri Olsa (13):
> > > > >       lib/sort: Add priv pointer to swap function
> > > > >       kallsyms: Skip the name search for empty string
> > > > >       bpf: Add multi kprobe link
> > > > >       bpf: Add bpf_get_func_ip kprobe helper for multi kprobe link
> > > > >       bpf: Add support to inline bpf_get_func_ip helper on x86
> > > > >       bpf: Add cookie support to programs attached with kprobe multi link
> > > > >       libbpf: Add libbpf_kallsyms_parse function
> > > > >       libbpf: Add bpf_link_create support for multi kprobes
> > > > >       libbpf: Add bpf_program__attach_kprobe_multi_opts function
> > > > >       selftests/bpf: Add kprobe_multi attach test
> > > > >       selftests/bpf: Add kprobe_multi bpf_cookie test
> > > > >       selftests/bpf: Add attach test for bpf_program__attach_kprobe_multi_opts
> > > > >       selftests/bpf: Add cookie test for bpf_program__attach_kprobe_multi_opts
> > > > >
> > > >
> > > > Ok, so I've integrated multi-attach kprobes into retsnoop. It was
> > > > pretty straightforward. Here are some numbers for the speed of
> > > > attaching and, even more importantly, detaching for a set of almost
> > > > 400 functions. It's a bit less functions for fentry-based mode due to
> > > > more limited BTF information for static functions. Note that retsnoop
> > > > attaches two BPF programs for each kernel function, so it's actually
> > > > two multi-attach kprobes, each attaching to 397 functions. For
> > > > single-attach kprobe, we perform 397 * 2 = 794 attachments.
> > > >
> > > > I've been invoking retsnoop with the following specified set of
> > > > functions: -e '*sys_bpf*' -a ':kernel/bpf/syscall.c' -a
> > > > ':kernel/bpf/verifier.c' -a ':kernel/bpf/btf.c' -a
> > > > ':kernel/bpf/core.c'. So basically bpf syscall entry functions and all
> > > > the discoverable functions from syscall.c, verifier.c, core.c and
> > > > btf.c from kernel/bpf subdirectory.
> > > >
> > > > Results:
> > > >
> > > > fentry attach/detach (263 kfuncs): 2133 ms / 31671  ms (33 seconds)
> > > > kprobe attach/detach (397 kfuncs): 3121 ms / 13195 ms (16 seconds)
> > > > multi-kprobe attach/detach (397 kfuncs): 9 ms / 248 ms (0.25 seconds)
> > > >
> > > > So as you can see, the speed up is tremendous! API is also very
> > > > convenient, I didn't have to modify retsnoop internals much to
> > > > accommodate multi-attach API. Great job!
> > >
> > > nice! thanks for doing that so quickly
> > >
> > > >
> > > > Now for the bad news. :(
> > > >
> > > > Stack traces from multi-attach kretprobe are broken, which makes all
> > > > this way less useful.
> > > >
> > > > Below, see stack traces captured with multi- and single- kretprobes
> > > > for two different use cases. Single kprobe stack traces make much more
> > > > sense. Ignore that last function doesn't have actual address
> > > > associated with it (i.e. for __sys_bpf and bpf_tracing_prog_attach,
> > > > respectively). That's just how retsnoop is doing things, I think. We
> > > > actually were capturing stack traces from inside __sys_bpf (first
> > > > case) and bpf_tracing_prog_attach (second case).
> > > >
> > > > MULTI KPROBE:
> > > > ffffffff81185a80 __sys_bpf+0x0
> > > > (kernel/bpf/syscall.c:4622:1)
> > > >
> > > > SINGLE KPROBE:
> > > > ffffffff81e0007c entry_SYSCALL_64_after_hwframe+0x44
> > > > (arch/x86/entry/entry_64.S:113:0)
> > > > ffffffff81cd2b15 do_syscall_64+0x35
> > > > (arch/x86/entry/common.c:80:7)
> > > >                  . do_syscall_x64
> > > > (arch/x86/entry/common.c:50:12)
> > > > ffffffff811881aa __x64_sys_bpf+0x1a
> > > > (kernel/bpf/syscall.c:4765:1)
> > > >                  __sys_bpf
> > > >
> > > >
> > > > MULTI KPROBE:
> > > > ffffffff811851b0 bpf_tracing_prog_attach+0x0
> > > > (kernel/bpf/syscall.c:2708:1)
> > > >
> > > > SINGLE KPROBE:
> > > > ffffffff81e0007c entry_SYSCALL_64_after_hwframe+0x44
> > > > (arch/x86/entry/entry_64.S:113:0)
> > > > ffffffff81cd2b15 do_syscall_64+0x35
> > > > (arch/x86/entry/common.c:80:7)
> > > >                  . do_syscall_x64
> > > > (arch/x86/entry/common.c:50:12)
> > > > ffffffff811881aa __x64_sys_bpf+0x1a
> > > > (kernel/bpf/syscall.c:4765:1)
> > > > ffffffff81185e79 __sys_bpf+0x3f9
> > > > (kernel/bpf/syscall.c:4705:9)
> > > > ffffffff8118583a bpf_raw_tracepoint_open+0x19a
> > > > (kernel/bpf/syscall.c:3069:6)
> > > >                  bpf_tracing_prog_attach
> > > >
> > > > You can see that in multi-attach kprobe we only get one entry, which
> > > > is the very last function in the stack trace. We have no parent
> > > > function captured whatsoever. Jiri, Masami, any ideas what's wrong and
> > > > how to fix this? Let's try to figure this out and fix it before the
> > > > feature makes it into the kernel release. Thanks in advance!
> > >
> > > oops, I should have tried kstack with the bpftrace's kretprobe, I see the same:
> > >
> > >       # ./src/bpftrace -e 'kretprobe:x* { @[kstack] = count(); }'
> > >       Attaching 1 probe...
> > >       Attaching 3340probes
> > >       ^C
> > >
> > >       @[
> > >           xfs_trans_apply_dquot_deltas+0
> > >       ]: 22
> > >       @[
> > >           xlog_cil_commit+0
> > >       ]: 22
> > >       @[
> > >           xlog_grant_push_threshold+0
> > >       ]: 22
> > >       @[
> > >           xfs_trans_add_item+0
> > >       ]: 22
> > >       @[
> > >           xfs_log_reserve+0
> > >       ]: 22
> > >       @[
> > >           xlog_space_left+0
> > >       ]: 22
> > >       @[
> > >           xfs_buf_offset+0
> > >       ]: 22
> > >       @[
> > >           xfs_trans_free_dqinfo+0
> > >       ]: 22
> > >       @[
> > >           xlog_ticket_alloc+0
> > >           xfs_log_reserve+5
> > >       ]: 22
> > >       @[
> > >           xfs_cil_prepare_item+0
> > >
> > >
> > > I think it's because we set original ip for return probe to have
> > > bpf_get_func_ip working properly, but it breaks backtrace of course
> > >
> > > I'm not sure we could bring along the original regs for return probe,
> > > but I have an idea how to workaround the bpf_get_func_ip issue and
> > > keep the registers intact for other helpers
> >
> > change below is using bpf_run_ctx to store link and entry ip on stack,
> > where helpers can find it.. it fixed the retprobe backtrace for me
> >
> > I had to revert the get_func_ip inline.. it's squashed in the change
> > below for quick testing.. I'll send revert in separate patch with the
> > formal change
> >
> > could you please test?
> >
>
> Yep, tried locally and now stack traces work as expected. Thanks!

BTW, there is a separate and unrelated problem, forgot to mention it yesterday.

It is possible to attach to some functions through using .syms
(resolve by name), but it is rejected when specifying .addrs (which
retsnoop derives directly from kallsyms). One such example is
"__bpf_tramp_exit". What's interesting, this function is marked
notrace, but is still attachable by name (including using
single-attach kprobe), while I'd assume it shouldn't.

It is all kind of broken, tbh, this notrace function is present in
/sys/kernel/debug/tracing/available_filter_functions, it's not in
/sys/kernel/debug/kprobes/blacklist, so the whole notrace and
blacklisting doesn't seem to work well.

So anyways, worth looking into this as well and figuring out why this
is inconsistent between .syms and .addrs approaches. Please take a
look when you get a chance. And I'll try to figure out if there is any
way to determine notrace functions from outside the kernel.


> Please resubmit as a proper patch and add my ack:
>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
>
> > thanks,
> > jirka
> >
> >
> > ---
>
> [...]
>
> > -static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx, u64 ip)
> > +static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx)
> >  {
> > +       struct bpf_kprobe_multi_run_ctx *run_ctx;
> >         struct bpf_kprobe_multi_link *link;
> > +       u64 *cookie, entry_ip;
> >         unsigned long *addr;
> > -       u64 *cookie;
> >
> >         if (WARN_ON_ONCE(!ctx))
> >                 return 0;
> > -       link = container_of(ctx, struct bpf_kprobe_multi_link, run_ctx);
> > +       run_ctx = container_of(current->bpf_ctx, struct bpf_kprobe_multi_run_ctx, run_ctx);
> > +       link = run_ctx->link;
> > +       entry_ip = run_ctx->entry_ip;
>
> nit: this can be assigned after we checked that we have link->cookies
>
> >         if (!link->cookies)
> >                 return 0;
> > -       addr = bsearch(&ip, link->addrs, link->cnt, sizeof(ip),
> > +       addr = bsearch(&entry_ip, link->addrs, link->cnt, sizeof(entry_ip),
> >                        __bpf_kprobe_multi_cookie_cmp);
> >         if (!addr)
> >                 return 0;
>
> [...]
