Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3036877F2B
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 13:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbfG1LRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 07:17:11 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35863 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfG1LRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 07:17:11 -0400
Received: by mail-wm1-f68.google.com with SMTP id g67so46960536wme.1;
        Sun, 28 Jul 2019 04:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=7A61jDnVRYJC5BJ5xISsqutxop7nCjzOOFrTn2F86z4=;
        b=CFQ/f97tvy5dYM8qnkMdVoUQAz4a2ug0uf8k7zV/QiXhFTi3ZYsqZK/Ab+Obl7OW3+
         2kCAqvPEaTlZpY427zGr14ZZvtbERWiFwUkQrmwNbeA3dXhxjaZp++SQFYh9p3WxpuOb
         qe14mbD8jCtOmXOkvipLVZnJGJ0l/bmGCdWgneILvVaq1IguQyVX7MONVkuGN42d7CKG
         Y3gs0Xl0ZnHjefFabPOu/j6vTJwlxEfG6cE8irk1tUtAVLknX9mNvQbijSFZM4uK3HYD
         axBONYR5MLBjW6Zx/YtiojxKY0TjkTcWaaA+r1yvHHss5QUhka2+PyyEQmAkb/zegB+C
         LYeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=7A61jDnVRYJC5BJ5xISsqutxop7nCjzOOFrTn2F86z4=;
        b=lndsiqgm2NUfp0L8G4Pscu87d+JHBciEGnCD5SXgU+klUpPoyIzOaT58+secnUqHJW
         gWJ6QNAJ+ZJ5c1KjtAfHDTQ9hotg3Zl57M/rWmfFrG8JP3kxNIJ/h9ZrrnnzP9Bjq/ud
         6OW/VR0oo28Cw5COa41Wd8FyHnSqMknxCsFY0VGv8r2PYEVHaldsY8e5LLINnxBsIDj0
         UnwjsA0mJnG9Ch+63csEKVo3k+Ob+RY5ZD93Y9ppae1T4dgy2aNpGuvKyOKQ+bbr2fj6
         AgfLGGFbDqdCdyl/QFu6gqLKp7Qt++T/mF671DOljFCN/QbV8UbtgetmwNKc3EajpFSC
         +fEw==
X-Gm-Message-State: APjAAAU3aDbQAOheHlCyBxRGmsGxN10Q/RG2NvwE2d7/yKmbOccAud5m
        hKPTZuW3zLAz95STM6mwEVMtwjIxVOzV2hImKMo=
X-Google-Smtp-Source: APXvYqzzy7eqHmIBZhYkurTUnTOOvst057CDN3imlQhYfSoB/rwVSGRMzSmfAByw/rlW56FaAAm31UCK4rKQuQes+1Q=
X-Received: by 2002:a1c:3cc4:: with SMTP id j187mr90243101wma.36.1564312628810;
 Sun, 28 Jul 2019 04:17:08 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUWF=B_phP8eGD3v2d9jSSK6Y-N65y-T6xewZnY91vc2_Q@mail.gmail.com>
 <c2524c96-d71c-d7db-22ec-12da905dc180@fb.com> <CA+icZUXYp=Jx+8aGrZmkCbSFp-cSPcoRzRdRJsPj4yYNs_mJQw@mail.gmail.com>
 <CA+icZUXsPRWmH3i-9=TK-=2HviubRqpAeDJGriWHgK1fkFhgUg@mail.gmail.com>
 <295d2acd-0844-9a40-3f94-5bcbb13871d2@fb.com> <CA+icZUUe0QE9QGMom1iQwuG8nM7Oi4Mq0GKqrLvebyxfUmj6RQ@mail.gmail.com>
 <CAADnVQLhymu8YqtfM1NHD5LMgO6a=FZYaeaYS1oCyfGoBDE_BQ@mail.gmail.com>
 <CA+icZUXGPCgdJzxTO+8W0EzNLZEQ88J_wusp7fPfEkNE2RoXJA@mail.gmail.com>
 <CA+icZUWVf6AK3bxfWBZ7iM1QTyk_G-4+1_LyK0jkoBDkDzvx4Q@mail.gmail.com> <57169960-35c2-d9d3-94e4-3b5a43d5aca7@fb.com>
In-Reply-To: <57169960-35c2-d9d3-94e4-3b5a43d5aca7@fb.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sun, 28 Jul 2019 13:16:57 +0200
Message-ID: <CA+icZUWNWmF4T6GRrkdanh1syYntRkGjk8SN0yDirnapmpOBwg@mail.gmail.com>
Subject: Re: next-20190723: bpf/seccomp - systemd/journald issue?
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 27, 2019 at 7:11 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/27/19 1:16 AM, Sedat Dilek wrote:
> > On Sat, Jul 27, 2019 at 9:36 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >>
> >> On Sat, Jul 27, 2019 at 4:24 AM Alexei Starovoitov
> >> <alexei.starovoitov@gmail.com> wrote:
> >>>
> >>> On Fri, Jul 26, 2019 at 2:19 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >>>>
> >>>> On Fri, Jul 26, 2019 at 11:10 PM Yonghong Song <yhs@fb.com> wrote:
> >>>>>
> >>>>>
> >>>>>
> >>>>> On 7/26/19 2:02 PM, Sedat Dilek wrote:
> >>>>>> On Fri, Jul 26, 2019 at 10:38 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >>>>>>>
> >>>>>>> Hi Yonghong Song,
> >>>>>>>
> >>>>>>> On Fri, Jul 26, 2019 at 5:45 PM Yonghong Song <yhs@fb.com> wrote:
> >>>>>>>>
> >>>>>>>>
> >>>>>>>>
> >>>>>>>> On 7/26/19 1:26 AM, Sedat Dilek wrote:
> >>>>>>>>> Hi,
> >>>>>>>>>
> >>>>>>>>> I have opened a new issue in the ClangBuiltLinux issue tracker.
> >>>>>>>>
> >>>>>>>> Glad to know clang 9 has asm goto support and now It can compile
> >>>>>>>> kernel again.
> >>>>>>>>
> >>>>>>>
> >>>>>>> Yupp.
> >>>>>>>
> >>>>>>>>>
> >>>>>>>>> I am seeing a problem in the area bpf/seccomp causing
> >>>>>>>>> systemd/journald/udevd services to fail.
> >>>>>>>>>
> >>>>>>>>> [Fri Jul 26 08:08:43 2019] systemd[453]: systemd-udevd.service: Failed
> >>>>>>>>> to connect stdout to the journal socket, ignoring: Connection refused
> >>>>>>>>>
> >>>>>>>>> This happens when I use the (LLVM) LLD ld.lld-9 linker but not with
> >>>>>>>>> BFD linker ld.bfd on Debian/buster AMD64.
> >>>>>>>>> In both cases I use clang-9 (prerelease).
> >>>>>>>>
> >>>>>>>> Looks like it is a lld bug.
> >>>>>>>>
> >>>>>>>> I see the stack trace has __bpf_prog_run32() which is used by
> >>>>>>>> kernel bpf interpreter. Could you try to enable bpf jit
> >>>>>>>>      sysctl net.core.bpf_jit_enable = 1
> >>>>>>>> If this passed, it will prove it is interpreter related.
> >>>>>>>>
> >>>>>>>
> >>>>>>> After...
> >>>>>>>
> >>>>>>> sysctl -w net.core.bpf_jit_enable=1
> >>>>>>>
> >>>>>>> I can start all failed systemd services.
> >>>>>>>
> >>>>>>> systemd-journald.service
> >>>>>>> systemd-udevd.service
> >>>>>>> haveged.service
> >>>>>>>
> >>>>>>> This is in maintenance mode.
> >>>>>>>
> >>>>>>> What is next: Do set a permanent sysctl setting for net.core.bpf_jit_enable?
> >>>>>>>
> >>>>>>
> >>>>>> This is what I did:
> >>>>>
> >>>>> I probably won't have cycles to debug this potential lld issue.
> >>>>> Maybe you already did, I suggest you put enough reproducible
> >>>>> details in the bug you filed against lld so they can take a look.
> >>>>>
> >>>>
> >>>> I understand and will put the journalctl-log into the CBL issue
> >>>> tracker and update informations.
> >>>>
> >>>> Thanks for your help understanding the BPF correlations.
> >>>>
> >>>> Is setting 'net.core.bpf_jit_enable = 2' helpful here?
> >>>
> >>> jit_enable=1 is enough.
> >>> Or use CONFIG_BPF_JIT_ALWAYS_ON to workaround.
> >>>
> >>> It sounds like clang miscompiles interpreter.
> >
> > Just to clarify:
> > This does not happen with clang-9 + ld.bfd (GNU/ld linker).
> >
> >>> modprobe test_bpf
> >>> should be able to point out which part of interpreter is broken.
> >>
> >> Maybe we need something like...
> >>
> >> "bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()"
> >>
> >> ...for clang?
> >>
> >
> > Not sure if something like GCC's...
> >
> > -fgcse
> >
> > Perform a global common subexpression elimination pass. This pass also
> > performs global constant and copy propagation.
> >
> > Note: When compiling a program using computed gotos, a GCC extension,
> > you may get better run-time performance if you disable the global
> > common subexpression elimination pass by adding -fno-gcse to the
> > command line.
> >
> > Enabled at levels -O2, -O3, -Os.
> >
> > ...is available for clang.
> >
> > I tried with hopping to turn off "global common subexpression elimination":
> >
> > diff --git a/arch/x86/net/Makefile b/arch/x86/net/Makefile
> > index 383c87300b0d..92f934a1e9ff 100644
> > --- a/arch/x86/net/Makefile
> > +++ b/arch/x86/net/Makefile
> > @@ -3,6 +3,8 @@
> >   # Arch-specific network modules
> >   #
> >
> > +KBUILD_CFLAGS += -O0
>
> This won't work. First, you added to the wrong file. The interpreter
> is at kernel/bpf/core.c.
>

Thanks for the clarification.
I mixed up the x86 BPF JIT compiler with the BPF interpreter.

I see no diff in the disassembled kernel/bpf/core.o in my clang9-bfd
and clang9-lld build-dirs.

l$ objdump -M intel -d linux.clang9-bfd/kernel/bpf/core.o >
bpf_core_o_clang9-bfd.txt
$ objdump -M intel -d linux.clang9-lld/kernel/bpf/core.o >
bpf_core_o_clang9-lld.txt

--- bpf_core_o_clang9-bfd.txt   2019-07-28 13:11:59.363552042 +0200
+++ bpf_core_o_clang9-lld.txt   2019-07-28 13:12:09.975535278 +0200
@@ -1,5 +1,5 @@

-linux.clang9-bfd/kernel/bpf/core.o:     file format elf64-x86-64
+linux.clang9-lld/kernel/bpf/core.o:     file format elf64-x86-64


 Disassembly of section .text:

> Second, kernel may have compilation issues with -O0.
>

Confirmed.

- Sedat -

> > +
> >   ifeq ($(CONFIG_X86_32),y)
> >           obj-$(CONFIG_BPF_JIT) += bpf_jit_comp32.o
> >   else
> >
> > Still see...
> > BROKEN: test_bpf: #294 BPF_MAXINSNS: Jump, gap, jump, ... jited:0
> >
> > - Sedat -
> >
