Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44A7194C75
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 20:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfHSSTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 14:19:01 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50394 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727744AbfHSSTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 14:19:01 -0400
Received: by mail-wm1-f68.google.com with SMTP id v15so407693wml.0;
        Mon, 19 Aug 2019 11:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=aYP4CxwTGVmvnAPlZJ47p188K02c/ZLyHLr+oQjpd00=;
        b=j1fmQiO0ofr4jDHJgTJiQZIm9RVJL6725/50rVTFk3W2wJF9CfKPjl0puoUJ5AkKY5
         5VY0zUKcSmweefa20/ewVorCdzUOPqB+Zos/Yt4cSdo090viBRGGkkDWNLqrP8f4ZBXc
         m64gGvhIa2pTnKRmT8rj+Gxo44Gg5FxrAmYxGQdW+UKF1H999c2ilrfo07FF1OrqQc7i
         nLYlUm7d85qcospNcHglPKR4flHlWn3Apia+492jcf52FQeWhmpi/LUil/ztDrh8qgwM
         86OdwajzBKzdlr53xxoolqM8vv+VD4RNVqz5nCcKaMghioXyOTjUjCx639FWqeHzNl6o
         L67A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=aYP4CxwTGVmvnAPlZJ47p188K02c/ZLyHLr+oQjpd00=;
        b=HJU9SFI36K85jFXeihqA3X2D+uFbjxfXuQUALVp5sa1UuyjSeWIlyFGI62JjY3M9mz
         Q/jdEmLJDuNCowHtD5bgQht49zrXmGiZSRF6pZmQGWTjQoXOYvbg2AtyL1DHfYyXB2rc
         Faqna2oate9mJrbZjNwJkDkHxajnsbRbkAxCue6CzEgDlmEB354h4hUf4/BstgKUD9GZ
         zrd+FH6+m1tFNkLdU2l3zbuZCtngfBkobLvDNi82ek+1Igajltquw97RCXhSAOlz7dNN
         Bw23hrbfwAQ7QHjiYO89EvfIy6gRvk7VvjnhMfEAq5d8Ur8B9cad4gJJCiCxnHGy9XyP
         JjJA==
X-Gm-Message-State: APjAAAXU6+SIzFSc+kgKpukCeEeEkFcieW0vszPht8ISpb3iFyLeAuJm
        yaDyqxtroCv75tooBhoXIC8W8xqT5NcvpWyKtuk=
X-Google-Smtp-Source: APXvYqyTZvAmEre07+kkSqzqjVVbiAhIiO0iW2pt79ITbyA4Xn3DML/VSHxQxW8OkWxP0XaAUWeoHs+iCaITGgvcBsQ=
X-Received: by 2002:a7b:cf21:: with SMTP id m1mr23089980wmg.150.1566238737678;
 Mon, 19 Aug 2019 11:18:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com> <20190812215052.71840-17-ndesaulniers@google.com>
In-Reply-To: <20190812215052.71840-17-ndesaulniers@google.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 19 Aug 2019 20:18:44 +0200
Message-ID: <CA+icZUVXP9D+EtXrNSTUPBdYKhkQBX-+CUP6ocg4cLRpFcfP9Q@mail.gmail.com>
Subject: Re: [PATCH 00/16] treewide: prefer __section from compiler_attributes.h
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     akpm@linux-foundation.org, jpoimboe@redhat.com, yhs@fb.com,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 11:53 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> GCC unescapes escaped string section names while Clang does not. Because
> __section uses the `#` stringification operator for the section name, it
> doesn't need to be escaped.
>
> This fixes an Oops observed in distro's that use systemd and not
> net.core.bpf_jit_enable=1, when their kernels are compiled with Clang.
>
> Instead, we should:
> 1. Prefer __section(.section_name_no_quotes).
> 2. Only use __attribute__((__section(".section"))) when creating the
> section name via C preprocessor (see the definition of __define_initcall
> in arch/um/include/shared/init.h).
>
> This antipattern was found with:
> $ grep -e __section\(\" -e __section__\(\" -r
>
> See the discussions in:
> https://bugs.llvm.org/show_bug.cgi?id=42950
> https://marc.info/?l=linux-netdev&m=156412960619946&w=2
>
> Nick Desaulniers (16):
>   s390/boot: fix section name escaping
>   arc: prefer __section from compiler_attributes.h
>   parisc: prefer __section from compiler_attributes.h
>   um: prefer __section from compiler_attributes.h
>   sh: prefer __section from compiler_attributes.h
>   ia64: prefer __section from compiler_attributes.h
>   arm: prefer __section from compiler_attributes.h
>   mips: prefer __section from compiler_attributes.h
>   sparc: prefer __section from compiler_attributes.h
>   powerpc: prefer __section and __printf from compiler_attributes.h
>   x86: prefer __section from compiler_attributes.h
>   arm64: prefer __section from compiler_attributes.h
>   include/asm-generic: prefer __section from compiler_attributes.h
>   include/linux: prefer __section from compiler_attributes.h
>   include/linux/compiler.h: remove unused KENTRY macro
>   compiler_attributes.h: add note about __section
>

Hi Nick,

thanks for this patchset and the nice section names cleanup and simplification.

I have tested 5 relevant patches for my x86-64 Debian/buster system.

Patchset "for-5.3/x86-section-name-escaping" (5 patches):

compiler_attributes.h: add note about __section
include/linux/compiler.h: remove unused KENTRY macro
include/linux: prefer __section from compiler_attributes.h
include/asm-generic: prefer __section from compiler_attributes.h
x86: prefer __section from compiler_attributes.h

Toolchain: LLVM/Clang compiler and LLD linker version 9.0.0-rc2 (from
Debian/experimental)

I can boot on bare metal.

$ cat /proc/version
Linux version 5.3.0-rc5-1-amd64-cbl-asmgoto
(sedat.dilek@gmail.com@iniza) (clang version 9.0.0-+rc2-1~exp1
(tags/RELEASE_900/rc2)) #1~buster+dileks1 SMP 2019-08-19

I have sent by Tested-by to the single patches.

Have a nice day,
- Sedat -

>  arch/arc/include/asm/linkage.h        |  8 +++----
>  arch/arc/include/asm/mach_desc.h      |  3 +--
>  arch/arm/include/asm/cache.h          |  2 +-
>  arch/arm/include/asm/mach/arch.h      |  4 ++--
>  arch/arm/include/asm/setup.h          |  2 +-
>  arch/arm64/include/asm/cache.h        |  2 +-
>  arch/arm64/kernel/smp_spin_table.c    |  2 +-
>  arch/ia64/include/asm/cache.h         |  2 +-
>  arch/mips/include/asm/cache.h         |  2 +-
>  arch/parisc/include/asm/cache.h       |  2 +-
>  arch/parisc/include/asm/ldcw.h        |  2 +-
>  arch/powerpc/boot/main.c              |  3 +--
>  arch/powerpc/boot/ps3.c               |  6 ++----
>  arch/powerpc/include/asm/cache.h      |  2 +-
>  arch/powerpc/kernel/btext.c           |  2 +-
>  arch/s390/boot/startup.c              |  2 +-
>  arch/sh/include/asm/cache.h           |  2 +-
>  arch/sparc/include/asm/cache.h        |  2 +-
>  arch/sparc/kernel/btext.c             |  2 +-
>  arch/um/kernel/um_arch.c              |  6 +++---
>  arch/x86/include/asm/cache.h          |  2 +-
>  arch/x86/include/asm/intel-mid.h      |  2 +-
>  arch/x86/include/asm/iommu_table.h    |  5 ++---
>  arch/x86/include/asm/irqflags.h       |  2 +-
>  arch/x86/include/asm/mem_encrypt.h    |  2 +-
>  arch/x86/kernel/cpu/cpu.h             |  3 +--
>  include/asm-generic/error-injection.h |  2 +-
>  include/asm-generic/kprobes.h         |  5 ++---
>  include/linux/cache.h                 |  6 +++---
>  include/linux/compiler.h              | 31 ++++-----------------------
>  include/linux/compiler_attributes.h   | 10 +++++++++
>  include/linux/cpu.h                   |  2 +-
>  include/linux/export.h                |  2 +-
>  include/linux/init_task.h             |  4 ++--
>  include/linux/interrupt.h             |  5 ++---
>  include/linux/sched/debug.h           |  2 +-
>  include/linux/srcutree.h              |  2 +-
>  37 files changed, 62 insertions(+), 83 deletions(-)
>
> --
> 2.23.0.rc1.153.gdeed80330f-goog
>
