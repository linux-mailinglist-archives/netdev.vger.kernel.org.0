Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F922FE5B3
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 10:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbhAUI44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 03:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbhAUI4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 03:56:25 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E54C061757;
        Thu, 21 Jan 2021 00:55:32 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id h11so2477717ioh.11;
        Thu, 21 Jan 2021 00:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=1W5ctKqJEh15657vCDtsaXBORxGKTTf2ebPpWs4xoy8=;
        b=ED1aFQMSum6yeY8qkzzGJ3WnKanouDr1DC/viKrXY+D9RAs9X+P189vkC900O7XuTe
         Ob5NDiukGoGXnBM8y/FSE/CVMLcAPmYmUu6Apq2k6GloLz6yj7mhXi5Uqco/3+wxDbpd
         rIy6gKxAK2BL7hoKwhlgQaUDICbL4ryEZVIFXgNg0xAFBHqDbXZ8MmMBhbcj3OP7AcPl
         CfpjBBZ6HBek5j4tylrOEfQ67KxRdDEqOAQ7Duezbjm1uNc5pDRey2rBrKyR/TcdrU2q
         7dQ2sRd53CqHw6MtFgT4immwOJDEHUl0ZWu26/i8pVwbkitqPpWDba64tmN55soU5Co0
         k6gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=1W5ctKqJEh15657vCDtsaXBORxGKTTf2ebPpWs4xoy8=;
        b=REeEZ+oT3ipUQe436XOY6KyTTBcJzQAvNblCvEDEpaYD5IJY//YcVpVNbXyJ975xNx
         2LVZ7zA5iYHX/lyIdI053MY4NqYAZpS1CmgU+KUFIDDNqSUpq5tMCSBtftGxt0LLcoGR
         g20OcOUi9U64oPf2BKjMx3FY09CeoajM5n72oKlCzPorFJbDXzjdkx8kBeK+bGyXx+2/
         kp5Ghy4grbLio+e/AyxmdocaAt6g3+bCIO1BvQo+Agoj7nKsP8K3WFLAQ5AVJ974hTC/
         Zh8N0UruVwI7aw/fkshjmKwWK2ElpY8aYD+IsY4xKX0JJvV9UUm79LASE2vWmLPHjHSw
         tHmA==
X-Gm-Message-State: AOAM533wIPH3GjpcXkESn7uoYLHbaTOywfyMBxIaGIqN3wvlqefQhIx2
        l9TZ/fE2Xlbe6woReeB3XozoF1W199GoVKNomWQ=
X-Google-Smtp-Source: ABdhPJzohOPe9CXB7Wl5N+uCE8ZsLSdvZeIUL3eB0kFqz0DNcE8LR0B3Cnmp49TpCOXWPJx2b23RvCsoNS1FX70YTlU=
X-Received: by 2002:a6b:6a0e:: with SMTP id x14mr9605695iog.57.1611219331865;
 Thu, 21 Jan 2021 00:55:31 -0800 (PST)
MIME-Version: 1.0
References: <1611206855-22555-1-git-send-email-yangtiezhu@loongson.cn>
 <20210121053627.GA1680146@ubuntu-m3-large-x86> <CAEf4BzbZxuy8LRmngRzLZ3VTnrDw=Rf70Ghkbu1a5+fNpQud5Q@mail.gmail.com>
In-Reply-To: <CAEf4BzbZxuy8LRmngRzLZ3VTnrDw=Rf70Ghkbu1a5+fNpQud5Q@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 21 Jan 2021 09:55:20 +0100
Message-ID: <CA+icZUWNu1JaS+m+Ne1ZB+tCARRUaiVh2KbqarnGEtM46PD1NA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] samples/bpf: Update build procedure for
 manually compiling LLVM and Clang
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
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

On Thu, Jan 21, 2021 at 9:08 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Jan 20, 2021 at 9:36 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > On Thu, Jan 21, 2021 at 01:27:35PM +0800, Tiezhu Yang wrote:
> > > The current LLVM and Clang build procedure in samples/bpf/README.rst is
> > > out of date. See below that the links are not accessible any more.
> > >
> > > $ git clone http://llvm.org/git/llvm.git
> > > Cloning into 'llvm'...
> > > fatal: unable to access 'http://llvm.org/git/llvm.git/': Maximum (20) redirects followed
> > > $ git clone --depth 1 http://llvm.org/git/clang.git
> > > Cloning into 'clang'...
> > > fatal: unable to access 'http://llvm.org/git/clang.git/': Maximum (20) redirects followed
> > >
> > > The LLVM community has adopted new ways to build the compiler. There are
> > > different ways to build LLVM and Clang, the Clang Getting Started page [1]
> > > has one way. As Yonghong said, it is better to copy the build procedure
> > > in Documentation/bpf/bpf_devel_QA.rst to keep consistent.
> > >
> > > I verified the procedure and it is proved to be feasible, so we should
> > > update README.rst to reflect the reality. At the same time, update the
> > > related comment in Makefile.
> > >
> > > Additionally, as Fangrui said, the dir llvm-project/llvm/build/install is
> > > not used, BUILD_SHARED_LIBS=OFF is the default option [2], so also change
> > > Documentation/bpf/bpf_devel_QA.rst together.
> > >
> > > [1] https://clang.llvm.org/get_started.html
> > > [2] https://www.llvm.org/docs/CMake.html
> > >
> > > Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> > > Acked-by: Yonghong Song <yhs@fb.com>
> >
> > Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> >
> > Small comment below.
> >
> > > ---
> > >
> > > v2: Update the commit message suggested by Yonghong,
> > >     thank you very much.
> > >
> > > v3: Remove the default option BUILD_SHARED_LIBS=OFF
> > >     and just mkdir llvm-project/llvm/build suggested
> > >     by Fangrui.
> > >
> > >  Documentation/bpf/bpf_devel_QA.rst |  3 +--
> > >  samples/bpf/Makefile               |  2 +-
> > >  samples/bpf/README.rst             | 16 +++++++++-------
> > >  3 files changed, 11 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
> > > index 5b613d2..18788bb 100644
> > > --- a/Documentation/bpf/bpf_devel_QA.rst
> > > +++ b/Documentation/bpf/bpf_devel_QA.rst
> > > @@ -506,11 +506,10 @@ that set up, proceed with building the latest LLVM and clang version
> > >  from the git repositories::
> > >
> > >       $ git clone https://github.com/llvm/llvm-project.git
> > > -     $ mkdir -p llvm-project/llvm/build/install
> > > +     $ mkdir -p llvm-project/llvm/build
> > >       $ cd llvm-project/llvm/build
> > >       $ cmake .. -G "Ninja" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
> > >                  -DLLVM_ENABLE_PROJECTS="clang"    \
> > > -                -DBUILD_SHARED_LIBS=OFF           \
> > >                  -DCMAKE_BUILD_TYPE=Release        \
> > >                  -DLLVM_BUILD_RUNTIME=OFF
> > >       $ ninja
> > > diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> > > index 26fc96c..d061446 100644
> > > --- a/samples/bpf/Makefile
> > > +++ b/samples/bpf/Makefile
> > > @@ -208,7 +208,7 @@ TPROGLDLIBS_xdpsock               += -pthread -lcap
> > >  TPROGLDLIBS_xsk_fwd          += -pthread
> > >
> > >  # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
> > > -#  make M=samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
> > > +# make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc CLANG=~/git/llvm-project/llvm/build/bin/clang
> > >  LLC ?= llc
> > >  CLANG ?= clang
> > >  OPT ?= opt
> > > diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
> > > index dd34b2d..23006cb 100644
> > > --- a/samples/bpf/README.rst
> > > +++ b/samples/bpf/README.rst
> > > @@ -65,17 +65,19 @@ To generate a smaller llc binary one can use::
> > >  Quick sniplet for manually compiling LLVM and clang
> > >  (build dependencies are cmake and gcc-c++)::
> >
> > Technically, ninja is now a build dependency as well, it might be worth
> > mentioning that here (usually the package is ninja or ninja-build).
>
> it's possible to generate Makefile by passing `-g "Unix Makefiles"`,
> which would avoid dependency on ninja, no?
>

AFAICS, cmake is now the default and "Unix Makefiles" deprecated with
newer versions of LLVM/Clang.

- Sedat -

> >
> > Regardless of whether that is addressed or not (because it is small),
> > feel free to carry forward my tag in any future revisions unless they
> > drastically change.
> >
> > > - $ git clone http://llvm.org/git/llvm.git
> > > - $ cd llvm/tools
> > > - $ git clone --depth 1 http://llvm.org/git/clang.git
> > > - $ cd ..; mkdir build; cd build
> > > - $ cmake .. -DLLVM_TARGETS_TO_BUILD="BPF;X86"
> > > - $ make -j $(getconf _NPROCESSORS_ONLN)
> > > + $ git clone https://github.com/llvm/llvm-project.git
> > > + $ mkdir -p llvm-project/llvm/build
> > > + $ cd llvm-project/llvm/build
> > > + $ cmake .. -G "Ninja" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
> > > +            -DLLVM_ENABLE_PROJECTS="clang"    \
> > > +            -DCMAKE_BUILD_TYPE=Release        \
> > > +            -DLLVM_BUILD_RUNTIME=OFF
> > > + $ ninja
> > >
> > >  It is also possible to point make to the newly compiled 'llc' or
> > >  'clang' command via redefining LLC or CLANG on the make command line::
> > >
> > > - make M=samples/bpf LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
> > > + make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc CLANG=~/git/llvm-project/llvm/build/bin/clang
> > >
> > >  Cross compiling samples
> > >  -----------------------
> > > --
> > > 2.1.0
> > >
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/CAEf4BzbZxuy8LRmngRzLZ3VTnrDw%3DRf70Ghkbu1a5%2BfNpQud5Q%40mail.gmail.com.
