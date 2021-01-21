Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576332FE4AA
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 09:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbhAUIKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 03:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbhAUIJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 03:09:23 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8F3C061575;
        Thu, 21 Jan 2021 00:08:42 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id y4so1249026ybn.3;
        Thu, 21 Jan 2021 00:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oobkTWZTECnkORfzKz+9DkXYOma+YaOrTTEwIwnDNH8=;
        b=i68+xYFE4asEvnU0olUlCe9tm+PQeJevoOK4wTwadHBtORItM9WdTOu3uY3Bq7VHqv
         dA7npENVOBzKBYblDVhbIZshaWW517HKXnRNYSo+0qDYCuuzci3PCUNAnNDaUyNXLhGy
         900VrPprFcyGvqkf30hguRWP7jzA6p97etS34BxEKlDZihKgvjuTIxMycXpnQAVp7Z0J
         8H0kQdakt7vAwP/MVSocmyPzpQe25pTKe6F2vBpJkcasQu9NqoFX9AyTJZFFSesThba1
         G84Uf0HoL3ZQE1s13G1OVpBEqrQXNOHpGZnPzu3wy8JukWjWIp3Q3ClcEPZ1BT7EzV5c
         8tBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oobkTWZTECnkORfzKz+9DkXYOma+YaOrTTEwIwnDNH8=;
        b=PI2tF0luH2xyiElgtPJikueG/slWIqicgT4EOEIggi6QLcEuzP9S3Rwjep3cKq686h
         lhTAROPxwAfmCz611IptZ3tORL/fOcRv+Jzxi+Q3+5rqlT+JPd7PtbeCVDY9nFaQ5keY
         UoTWRRCaasA7Xi2REHN5aKhjGlCbIgKyOu9fUyD6AAv+zDQz8RkOb1aT8FKnFr12Kayz
         djQ5X7eT8Vc4dbTTibAMTppE5689Ub3AfCwX3wNu5EtaXkw+eAvK/S2qjMKB/nchnMY3
         sRaAzDTGOIkV9j7beaA6A6iFoADoVP3DXtPlUjw9LQKTAn1uO92m3Df8uLODghC/oyde
         u8PA==
X-Gm-Message-State: AOAM533VWjZBYMAtXFq4Vh90Uqp5ZwEmVj31ILy2xc3IEsone+Cm5j2Y
        3aGm4gisbPcItAg0oKx6NMK/MuTVORTQs0o0HZs=
X-Google-Smtp-Source: ABdhPJxG8Bi2XnJu4M8KQmv8sjAuegcaeBsgG0qbt4gbRNdj6iO5SpOSyz7xInQJefus+Y7leeCfTIfV0h5Sv6CDamg=
X-Received: by 2002:a25:854a:: with SMTP id f10mr17694912ybn.510.1611216522128;
 Thu, 21 Jan 2021 00:08:42 -0800 (PST)
MIME-Version: 1.0
References: <1611206855-22555-1-git-send-email-yangtiezhu@loongson.cn> <20210121053627.GA1680146@ubuntu-m3-large-x86>
In-Reply-To: <20210121053627.GA1680146@ubuntu-m3-large-x86>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 Jan 2021 00:08:31 -0800
Message-ID: <CAEf4BzbZxuy8LRmngRzLZ3VTnrDw=Rf70Ghkbu1a5+fNpQud5Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] samples/bpf: Update build procedure for
 manually compiling LLVM and Clang
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        open list <linux-kernel@vger.kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Fangrui Song <maskray@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 9:36 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Thu, Jan 21, 2021 at 01:27:35PM +0800, Tiezhu Yang wrote:
> > The current LLVM and Clang build procedure in samples/bpf/README.rst is
> > out of date. See below that the links are not accessible any more.
> >
> > $ git clone http://llvm.org/git/llvm.git
> > Cloning into 'llvm'...
> > fatal: unable to access 'http://llvm.org/git/llvm.git/': Maximum (20) redirects followed
> > $ git clone --depth 1 http://llvm.org/git/clang.git
> > Cloning into 'clang'...
> > fatal: unable to access 'http://llvm.org/git/clang.git/': Maximum (20) redirects followed
> >
> > The LLVM community has adopted new ways to build the compiler. There are
> > different ways to build LLVM and Clang, the Clang Getting Started page [1]
> > has one way. As Yonghong said, it is better to copy the build procedure
> > in Documentation/bpf/bpf_devel_QA.rst to keep consistent.
> >
> > I verified the procedure and it is proved to be feasible, so we should
> > update README.rst to reflect the reality. At the same time, update the
> > related comment in Makefile.
> >
> > Additionally, as Fangrui said, the dir llvm-project/llvm/build/install is
> > not used, BUILD_SHARED_LIBS=OFF is the default option [2], so also change
> > Documentation/bpf/bpf_devel_QA.rst together.
> >
> > [1] https://clang.llvm.org/get_started.html
> > [2] https://www.llvm.org/docs/CMake.html
> >
> > Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> > Acked-by: Yonghong Song <yhs@fb.com>
>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
>
> Small comment below.
>
> > ---
> >
> > v2: Update the commit message suggested by Yonghong,
> >     thank you very much.
> >
> > v3: Remove the default option BUILD_SHARED_LIBS=OFF
> >     and just mkdir llvm-project/llvm/build suggested
> >     by Fangrui.
> >
> >  Documentation/bpf/bpf_devel_QA.rst |  3 +--
> >  samples/bpf/Makefile               |  2 +-
> >  samples/bpf/README.rst             | 16 +++++++++-------
> >  3 files changed, 11 insertions(+), 10 deletions(-)
> >
> > diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
> > index 5b613d2..18788bb 100644
> > --- a/Documentation/bpf/bpf_devel_QA.rst
> > +++ b/Documentation/bpf/bpf_devel_QA.rst
> > @@ -506,11 +506,10 @@ that set up, proceed with building the latest LLVM and clang version
> >  from the git repositories::
> >
> >       $ git clone https://github.com/llvm/llvm-project.git
> > -     $ mkdir -p llvm-project/llvm/build/install
> > +     $ mkdir -p llvm-project/llvm/build
> >       $ cd llvm-project/llvm/build
> >       $ cmake .. -G "Ninja" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
> >                  -DLLVM_ENABLE_PROJECTS="clang"    \
> > -                -DBUILD_SHARED_LIBS=OFF           \
> >                  -DCMAKE_BUILD_TYPE=Release        \
> >                  -DLLVM_BUILD_RUNTIME=OFF
> >       $ ninja
> > diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> > index 26fc96c..d061446 100644
> > --- a/samples/bpf/Makefile
> > +++ b/samples/bpf/Makefile
> > @@ -208,7 +208,7 @@ TPROGLDLIBS_xdpsock               += -pthread -lcap
> >  TPROGLDLIBS_xsk_fwd          += -pthread
> >
> >  # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
> > -#  make M=samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
> > +# make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc CLANG=~/git/llvm-project/llvm/build/bin/clang
> >  LLC ?= llc
> >  CLANG ?= clang
> >  OPT ?= opt
> > diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
> > index dd34b2d..23006cb 100644
> > --- a/samples/bpf/README.rst
> > +++ b/samples/bpf/README.rst
> > @@ -65,17 +65,19 @@ To generate a smaller llc binary one can use::
> >  Quick sniplet for manually compiling LLVM and clang
> >  (build dependencies are cmake and gcc-c++)::
>
> Technically, ninja is now a build dependency as well, it might be worth
> mentioning that here (usually the package is ninja or ninja-build).

it's possible to generate Makefile by passing `-g "Unix Makefiles"`,
which would avoid dependency on ninja, no?

>
> Regardless of whether that is addressed or not (because it is small),
> feel free to carry forward my tag in any future revisions unless they
> drastically change.
>
> > - $ git clone http://llvm.org/git/llvm.git
> > - $ cd llvm/tools
> > - $ git clone --depth 1 http://llvm.org/git/clang.git
> > - $ cd ..; mkdir build; cd build
> > - $ cmake .. -DLLVM_TARGETS_TO_BUILD="BPF;X86"
> > - $ make -j $(getconf _NPROCESSORS_ONLN)
> > + $ git clone https://github.com/llvm/llvm-project.git
> > + $ mkdir -p llvm-project/llvm/build
> > + $ cd llvm-project/llvm/build
> > + $ cmake .. -G "Ninja" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
> > +            -DLLVM_ENABLE_PROJECTS="clang"    \
> > +            -DCMAKE_BUILD_TYPE=Release        \
> > +            -DLLVM_BUILD_RUNTIME=OFF
> > + $ ninja
> >
> >  It is also possible to point make to the newly compiled 'llc' or
> >  'clang' command via redefining LLC or CLANG on the make command line::
> >
> > - make M=samples/bpf LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
> > + make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc CLANG=~/git/llvm-project/llvm/build/bin/clang
> >
> >  Cross compiling samples
> >  -----------------------
> > --
> > 2.1.0
> >
