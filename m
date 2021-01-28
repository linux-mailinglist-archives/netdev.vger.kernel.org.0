Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9DF306AC6
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhA1BzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbhA1Byd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:54:33 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20730C061573;
        Wed, 27 Jan 2021 17:53:53 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id y17so3801045ili.12;
        Wed, 27 Jan 2021 17:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=mPzE75sxLYfUlCv97bbvkWvx0ps9bQE/9kEnSkv6IXw=;
        b=e8bFsEyMgxtBL1zwRK8h6w7xJ2/pCdY9BVxmTTTqSIiRnTcc23zWzt9w2Wuc7HkYjZ
         DEv73+GfKPXGLuH9EX2lwYHdkMkBT1d4hiurVVMi8GjLwhzbq4zQg7aHLO27UnXgAlNW
         N36dg9f0JBH97sYPrQSYjPFv1hmMpc3l4585BM+lXupjEbwCMhGAoSrRsgeXz3GpKR1a
         QJuCsVWxTXVlTOoTb8WhE0tnCD0eH5qcUA0KLASu4ealWOcr39QP5Az5CSmdTTZgx8po
         gdaqzTPzL+X9KP2M8esz7nmF0JGVWf8G6g4ATE/EtrYSLa2AiMpkoMPsx9x+YR4LCw7C
         M4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=mPzE75sxLYfUlCv97bbvkWvx0ps9bQE/9kEnSkv6IXw=;
        b=M/+0Hxwl8I9uD3JloXt6Gl1QXQQMOV9ODKnFBFcD3MNgph6Ik5Q6cpJbZe+k25gcgC
         lPDBpW+uKew057EFjNCMXjAP262Guq+Mc5dbqt3DgHk1pZbTNs4UBORy12xByGMyHuxx
         BUlA9/v8tChIYvSAaGzqp6ACjUwJYsJ/ObKnnixLSm/kNJ/fdXjoXorkz34QwOE+AeJf
         uPzSZvisaTTFlDWu+9zHsb0sxBoki46iofw7xYtIgkP2bYme4bDaxn2acRhu0bfMUtO8
         +nbNKhUQ1jPZwAXlVfbjXoUEjI5V1vo8MKLA3b0uEi1gCdXSkfgTihHX9gx14iITSdV0
         cSSg==
X-Gm-Message-State: AOAM531L2+6n2shdjetUZPAzPVRbQ4kC3okZwKwV7ArAEuoM13GbGXpX
        tBS9JEUD5f2sS66WEggyi1Q/b+GuRYl8elAUm78=
X-Google-Smtp-Source: ABdhPJyxN2dNqZbl2oVkSPWPBXJe49Ob1SM2opqAHCKAKljE1Gq5/szHdgEJHsMrbq+AD7YQGyfq4dLJzwlJZ8vy500=
X-Received: by 2002:a92:c80b:: with SMTP id v11mr10919105iln.215.1611798832520;
 Wed, 27 Jan 2021 17:53:52 -0800 (PST)
MIME-Version: 1.0
References: <20210122003235.77246-1-sedat.dilek@gmail.com> <CAEf4Bzb+fXZy1+337zRFA9v8x+Mt7E3YOZRhG8xnXeRN4_oCRA@mail.gmail.com>
 <CA+icZUWVGHqM00qd7-+Hrb9=rkL6AvEQ7Aj8zBK=VPpEi+LTmg@mail.gmail.com> <CAEf4BzZ0S-SzVy=Ym0x27Ab2QS8vwA66OzX4KjC88nSg7wD9SQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZ0S-SzVy=Ym0x27Ab2QS8vwA66OzX4KjC88nSg7wD9SQ@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 28 Jan 2021 02:53:41 +0100
Message-ID: <CA+icZUVYdFEZ_P_JVNO4cCrPw=JD-XMf1560cHuqOM8GbniP+Q@mail.gmail.com>
Subject: Re: [PATCH RFC v2] tools: Factor Clang, LLC and LLVM utils definitions
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Andrey Ignatov <rdna@fb.com>,
        Stephane Eranian <eranian@google.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Thomas Hebb <tommyhebb@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Briana Oursler <briana.oursler@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Davide Caratti <dcaratti@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 2:41 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Jan 27, 2021 at 5:30 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >
> > On Thu, Jan 28, 2021 at 2:27 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Thu, Jan 21, 2021 at 4:32 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > > >
> > > > When dealing with BPF/BTF/pahole and DWARF v5 I wanted to build bpftool.
> > > >
> > > > While looking into the source code I found duplicate assignments
> > > > in misc tools for the LLVM eco system, e.g. clang and llvm-objcopy.
> > > >
> > > > Move the Clang, LLC and/or LLVM utils definitions to
> > > > tools/scripts/Makefile.include file and add missing
> > > > includes where needed.
> > > > Honestly, I was inspired by commit c8a950d0d3b9
> > > > ("tools: Factor HOSTCC, HOSTLD, HOSTAR definitions").
> > > >
> > > > I tested with bpftool and perf on Debian/testing AMD64 and
> > > > LLVM/Clang v11.1.0-rc1.
> > > >
> > > > Build instructions:
> > > >
> > > > [ make and make-options ]
> > > > MAKE="make V=1"
> > > > MAKE_OPTS="HOSTCC=clang HOSTCXX=clang++ HOSTLD=ld.lld CC=clang LD=ld.lld LLVM=1 LLVM_IAS=1"
> > > > MAKE_OPTS="$MAKE_OPTS PAHOLE=/opt/pahole/bin/pahole"
> > > >
> > > > [ clean-up ]
> > > > $MAKE $MAKE_OPTS -C tools/ clean
> > > >
> > > > [ bpftool ]
> > > > $MAKE $MAKE_OPTS -C tools/bpf/bpftool/
> > > >
> > > > [ perf ]
> > > > PYTHON=python3 $MAKE $MAKE_OPTS -C tools/perf/
> > > >
> > > > I was careful with respecting the user's wish to override custom compiler,
> > > > linker, GNU/binutils and/or LLVM utils settings.
> > > >
> > > > Some personal notes:
> > > > 1. I have NOT tested with cross-toolchain for other archs (cross compiler/linker etc.).
> > > > 2. This patch is on top of Linux v5.11-rc4.
> > > >
> > > > I hope to get some feedback from especially Linux-bpf folks.
> > > >
> > > > Acked-by: Jiri Olsa <jolsa@redhat.com> # tools/build and tools/perf
> > > > Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> > > > ---
> > >
> > > Hi Sedat,
> > >
> > > If no one objects, we'll take this through bpf-next tree. Can you
> > > please re-send this as a non-RFC patch against the bpf-next tree? Feel
> > > free to add my ack. Thanks.
> > >
> >
> > I am OK with that and will add your ACK.
> > Is [1] bpf-next Git?
>
> Yes, please use [PATCH bpf-next] subject prefix and cc
> bpf@vger.kernel.org as well.
>

Please see link:

https://lore.kernel.org/r/20210128015117.20515-1-sedat.dilek@gmail.com

- Sedat -

> >
> > - Sedat -
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/
> >
> > > > Changelog RFC v1->v2:
> > > > - Add Jiri's ACK
> > > > - Adapt to fit Linux v5.11-rc4
> > > >
> > >
> > > [...]
