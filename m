Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1D2C581AB
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 13:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfF0Lgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 07:36:47 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43068 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfF0Lgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 07:36:46 -0400
Received: by mail-qt1-f196.google.com with SMTP id w17so1983962qto.10
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 04:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lrbbw427y1OLicF2y8GQv6n0mSuHYHsZTkGTvsVsPRs=;
        b=ncV8NizeVgSneI0njGBIgnjZ60NOgcjoKWqmSZgOb82tmrYcA/mkJ82Vkq53CDDpDm
         etdv7xL7pqNnLAH9oSlm3bwun4e059lKHFXIgsT4F8OmN6tvsmNyhtcA/knNb3f3r/cf
         oKMbZHLUmeMllV0RZbMBEBU4Sns3tTvPNspwZiWcKAmfxH7N1XgBcaPLbIxmBB+umPEL
         qic/EnNTe8CCziDR5gAKCVzumoSE7l4CJSWElqx7nhvzs18ScvEQnpKOjN/MEEbJBFnK
         K71Qkn+A0UP2Vo6IP6ZL4dR2i8klXTjs4iNpTvRugLlnoJSzdjvtFfLMTa5hY+4xuWW/
         nN9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lrbbw427y1OLicF2y8GQv6n0mSuHYHsZTkGTvsVsPRs=;
        b=QHUPwgTzlZEWdtLhRxERvPzfprEo1WQiqnwzfm2Zi0EfFVRjL30nBa1DwLrPTVnDZX
         TISBJit5juByxvaCMFdOtHtdQd11Z0jl3f/v1lV1roQFy23sZrgHHdRcMoH+TVTSgTh2
         6MI3cwsGWrUpE5bqw7QI9HajI6rpNz55vbCP1jjE95MJuXo7HiWD3yVyCGKRt7S3suLe
         kPjSa/fOR/T2ePgSUm7R4Ff8eDKxXb0iweBZYFm0GW4z+LO/kk5igF88VXjQxLYVnq3d
         skk/B4lv5vfFCjs/vte3hbhDLrrn6Sff9mQp1KRcimlPVsPUWkFJXN60JJxtVrCR0/t/
         aarQ==
X-Gm-Message-State: APjAAAXdQ7TtOwFzR/b5K5q0cW73PTjoExMwy/18US62wr4lGQRfP7th
        PYmifGgXzP11lT6toSX6fOKOVaFHUYMnrhG6qv60OA==
X-Google-Smtp-Source: APXvYqxC+OzTvHF4zmnfGQg8wJLudDtNDpGXWQrZsaoLkAoO6mLER+L3idoJdGKuBDbhK3E1ffLTgOF0HgMO8H6+lxA=
X-Received: by 2002:ac8:1ba9:: with SMTP id z38mr2684417qtj.176.1561635404388;
 Thu, 27 Jun 2019 04:36:44 -0700 (PDT)
MIME-Version: 1.0
References: <faaf8b1c-9552-a0ae-3088-2f4255dff857@codeaurora.org>
 <0bcdd38c-5cdb-0510-573a-9a6098ab2105@codeaurora.org> <CAJWu+oo5zmdY9ywhbQTWi+YXRDF=XSJrAUEE0uJ9dV_9vZUSBA@mail.gmail.com>
In-Reply-To: <CAJWu+oo5zmdY9ywhbQTWi+YXRDF=XSJrAUEE0uJ9dV_9vZUSBA@mail.gmail.com>
From:   Joel Fernandes <joelaf@google.com>
Date:   Thu, 27 Jun 2019 07:36:32 -0400
Message-ID: <CAJWu+opEj0=FAHvityWTVxE3BBLHMYiHqu+Bc1+T03DzEsnGbQ@mail.gmail.com>
Subject: Re: samples/bpf compilation failures - 5.2.0
To:     Srinivas Ramana <sramana@codeaurora.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > On 5/28/2019 2:27 PM, Srinivas Ramana wrote:
> > > Hello,
> > >
> > > I am trying to build samples/bpf in kernel(5.2.0-rc1) but unsuccessful
> > > with below errors. Can you help to point what i am missing or if there
> > > is some known issue?

By the way have you just tried building it on an ARM debian chroot? It
is not worth IMO spending time on cross compiler issues if you can
just native compile it within a chroot (as I do). Cross compilation
does not get a lot of testing, so even if we fix it its likely to come
up again as I've experienced. If you want a debian chroot that is
Android friendly, you can find one here:
https://github.com/joelagnel/adeb (comes with llvm, gcc etc).  I have
done lots of native compilation on a Pixel phone.

J.



> > >
> > > ==============================8<===================================
> > > $ make samples/bpf/
> > > LLC=/local/mnt/workspace/tools/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/llc
> > > CLANG=/local/mnt/workspace/tools/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang
> > > V=1
> > > make -C /local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel -f
> > > /local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/Makefile
> > > samples/bpf/
> > > ................
> > > ................
> > > ................
> > > make KBUILD_MODULES=1 -f ./scripts/Makefile.build obj=samples/bpf
> > > (cat /dev/null; ) > samples/bpf/modules.order
> > > make -C
> > > /local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../../tools/lib/bpf/
> > > RM='rm -rf' LDFLAGS=
> > > srctree=/local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../../
> > > O=
> > >
> > > Auto-detecting system features:
> > > ...                        libelf: [ on  ]
> > > ...                           bpf: [ on  ]
> > >
> > > make -C
> > > /local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../..//tools/build
> > > CFLAGS= LDFLAGS= fixdep
> > > make -f
> > > /local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../..//tools/build/Makefile.build
> > > dir=. obj=fixdep
> > >     ld -r -o fixdep-in.o  fixdep.o
> > > ld: fixdep.o: Relocations in generic ELF (EM: 183)
> > > ld: fixdep.o: Relocations in generic ELF (EM: 183)
> > > fixdep.o: error adding symbols: File in wrong format
> > > make[5]: *** [fixdep-in.o] Error 1
> > > make[4]: *** [fixdep-in.o] Error 2
> > > make[3]: *** [fixdep] Error 2
> > > make[2]: ***
> > > [/local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../../tools/lib/bpf/libbpf.a]
> > > Error 2
> > > make[1]: *** [samples/bpf/] Error 2
> > > make: *** [sub-make] Error 2
> > > ==============================>8=======================================
> > >
> > >
> > > I am using the below commands to build:
> > > ========================================================
> > > export ARCH=arm64
> > > export CROSS_COMPILE=<path>linaro-toolchain/5.1/bin/aarch64-linux-gnu-
> > > export CLANG_TRIPLE=arm64-linux-gnu-
> > >
> > > make
> > > CC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang
> > > defconfig
> > >
> > > make
> > > CC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang
> > > -j8
> > >
> > > make
> > > CC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang
> > > headers_install INSTALL_HDR_PATH=./usr
> > >
> > > make samples/bpf/
> > > LLC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/llc
> > > CLANG=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang
> > > V=1
> > > CC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang
> > >
> > > ========================================================
> > >
> > > Thanks,
> > > -- Srinivas R
> > >
> >
> >
> > --
> > Qualcomm India Private Limited, on behalf of Qualcomm Innovation
> > Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
> > Collaborative Project
