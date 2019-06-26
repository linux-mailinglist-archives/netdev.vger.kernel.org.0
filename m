Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E375456BC1
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfFZOVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:21:22 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45506 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbfFZOVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:21:21 -0400
Received: by mail-qt1-f193.google.com with SMTP id j19so2497251qtr.12
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 07:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MCl3tpFEmKK0HQZH2Eap62wiPJfD46EgaEr3zzT9c2M=;
        b=rTPp8xHQvRR1WlL9LKeu8k+ls6QVoa07QO2Hy/pt0RmMRc4WwVQjaawGH+JcBLKlqZ
         l/APsMzNRtVvqE+wLo/F6DCsjCppYgdbJiO/Kzq23QnROLmrLEfxzxZ/NZ82yfuZoSdM
         DllC/cYYCeiIoNJYaG5aKaETgZz1/BsWuplJLvol405gHDd92oc9SW0AlUlef4KJ2077
         B7Bs6ta+IeGV22N6hW+xJF8ZSgNSp1tEKf4Vyv1h/od7u9soFh9lFBMWBVsCu8O9h7f/
         +9U/4ovvW1qDiJyEQK5CQxXV19RP7wXcMxDU6ML0qI3yndOsSTDgiNjJknu1NWBbzVVN
         9xrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MCl3tpFEmKK0HQZH2Eap62wiPJfD46EgaEr3zzT9c2M=;
        b=gvz82zwIBfOkG5w8oVk9yIEU1eDV8Ay8d8UtKlgISxLCaj82EzYY2GY3HG39FJzL5O
         w3rqm2x9qwf7LlVzkwL9nWaREI4zEIoA3b1E/zuMPr4rX8kfVq+iqrhV2toguV14ENUc
         TXmpxbom3Eux7EXYA9EycYFn6JX8QX9TM7KXKxMvQqU8qULiU0oGvu8VDZD+KCfNhWPG
         ViFkFNFscrOP81PslEBEOI2cUsQ2mL2T4jgDri59lpANO54tSl/Gep4FSv6lhS3CKLXU
         ZiJBOdDc5e7IBN408HV34WjKNLfXrPMzkFCW1e/l2Q/DWqweNLT405NCEpJRuJE4GQ24
         rSbw==
X-Gm-Message-State: APjAAAV8FzBH/tPneaCzVp59aQpTHi0WcJh/y7Mny4DftSucvYJxGdAt
        zJHTu0tLHC1ZQnQmfReYUlZgZwbPjdg+mwz4VFdNRg==
X-Google-Smtp-Source: APXvYqxOzzdaaHHfWmnWMdQEY3tUVS20gcBS77Nd8999M96SfELt8pCIZrtjVq+401zaYigoAwExiscIDvefEceYJMQ=
X-Received: by 2002:aed:21f0:: with SMTP id m45mr3923648qtc.391.1561558880523;
 Wed, 26 Jun 2019 07:21:20 -0700 (PDT)
MIME-Version: 1.0
References: <faaf8b1c-9552-a0ae-3088-2f4255dff857@codeaurora.org> <0bcdd38c-5cdb-0510-573a-9a6098ab2105@codeaurora.org>
In-Reply-To: <0bcdd38c-5cdb-0510-573a-9a6098ab2105@codeaurora.org>
From:   Joel Fernandes <joelaf@google.com>
Date:   Wed, 26 Jun 2019 10:21:09 -0400
Message-ID: <CAJWu+oo5zmdY9ywhbQTWi+YXRDF=XSJrAUEE0uJ9dV_9vZUSBA@mail.gmail.com>
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

On Wed, Jun 26, 2019 at 1:41 AM Srinivas Ramana <sramana@codeaurora.org> wrote:
>
> + Joel if he has seen this issue.
>

I have not seen this issue and it has been some time since I built BPF
samples, sorry. I am mostly building BPF programs through bcc/bpftrace
and Android's build system.

We ought to make samples easier to build though, I remember when I
built it last year there were header related issues which should be
fixed. It could be that new BPF features broke it again.

 J.



> On 5/28/2019 2:27 PM, Srinivas Ramana wrote:
> > Hello,
> >
> > I am trying to build samples/bpf in kernel(5.2.0-rc1) but unsuccessful
> > with below errors. Can you help to point what i am missing or if there
> > is some known issue?
> >
> > ==============================8<===================================
> > $ make samples/bpf/
> > LLC=/local/mnt/workspace/tools/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/llc
> > CLANG=/local/mnt/workspace/tools/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang
> > V=1
> > make -C /local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel -f
> > /local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/Makefile
> > samples/bpf/
> > ................
> > ................
> > ................
> > make KBUILD_MODULES=1 -f ./scripts/Makefile.build obj=samples/bpf
> > (cat /dev/null; ) > samples/bpf/modules.order
> > make -C
> > /local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../../tools/lib/bpf/
> > RM='rm -rf' LDFLAGS=
> > srctree=/local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../../
> > O=
> >
> > Auto-detecting system features:
> > ...                        libelf: [ on  ]
> > ...                           bpf: [ on  ]
> >
> > make -C
> > /local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../..//tools/build
> > CFLAGS= LDFLAGS= fixdep
> > make -f
> > /local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../..//tools/build/Makefile.build
> > dir=. obj=fixdep
> >     ld -r -o fixdep-in.o  fixdep.o
> > ld: fixdep.o: Relocations in generic ELF (EM: 183)
> > ld: fixdep.o: Relocations in generic ELF (EM: 183)
> > fixdep.o: error adding symbols: File in wrong format
> > make[5]: *** [fixdep-in.o] Error 1
> > make[4]: *** [fixdep-in.o] Error 2
> > make[3]: *** [fixdep] Error 2
> > make[2]: ***
> > [/local/mnt/workspace/sramana/kdev_torvalds/kdev/kernel/samples/bpf/../../tools/lib/bpf/libbpf.a]
> > Error 2
> > make[1]: *** [samples/bpf/] Error 2
> > make: *** [sub-make] Error 2
> > ==============================>8=======================================
> >
> >
> > I am using the below commands to build:
> > ========================================================
> > export ARCH=arm64
> > export CROSS_COMPILE=<path>linaro-toolchain/5.1/bin/aarch64-linux-gnu-
> > export CLANG_TRIPLE=arm64-linux-gnu-
> >
> > make
> > CC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang
> > defconfig
> >
> > make
> > CC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang
> > -j8
> >
> > make
> > CC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang
> > headers_install INSTALL_HDR_PATH=./usr
> >
> > make samples/bpf/
> > LLC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/llc
> > CLANG=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang
> > V=1
> > CC=<path>/clang_ubuntu/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang
> >
> > ========================================================
> >
> > Thanks,
> > -- Srinivas R
> >
>
>
> --
> Qualcomm India Private Limited, on behalf of Qualcomm Innovation
> Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
> Collaborative Project
