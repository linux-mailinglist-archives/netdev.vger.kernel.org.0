Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7083A126F85
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbfLSVQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:16:40 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:40235 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfLSVQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:16:40 -0500
Received: by mail-qv1-f66.google.com with SMTP id dp13so2815230qvb.7;
        Thu, 19 Dec 2019 13:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6/hiWwf6dXlKT/Q//Vr0HTAFD4paNaUnM6qnrJ16qIc=;
        b=JCwFJ/j9iBJozLV3VepWJ/aKAjHwnAScone6x0APc6PxiM++DpmBqaqHfnoe/5FsVj
         cRLHoNjYv45A0eXRmX2NnaE39r19buW3ytlKfpLoZUwkv/NHJqxY1zl8ppLgvzetkxC/
         poXaHBPbW+H4v5eMDBg52ccYxFzF5OZbJWrUmWqlH8nYHNlOajYLPnI4ecb8kN37EiDg
         A5B5UzO8/7YaeFM2O0zi0Lx6X/Zcp8/w6N9qTexcST19PLW+rj3GSL4YMU7bfzbyrdv5
         ZlxQTcJLGo9V2jxGjpFF6bWWVvCpXeHTnCAdzh4ntrj8Z/aNJGpisNjBx+NbrpoMqbDG
         MObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6/hiWwf6dXlKT/Q//Vr0HTAFD4paNaUnM6qnrJ16qIc=;
        b=a6V4TCNHHYXCozflw3diLKkZ6OjiF/N6yfzlnPoC/HS08pHAS5N6yfw+3eXpjmDcBt
         rQevYo2Z2Z6q1T5PxzQczuRygFCQccqqjrEHLpBoHI03yF12SUn4jXTBtqUwFa5WT0g5
         IKIedj4SrWoPjcj9rMB1x/yS4wZroYiepXQzwTYkQl2Qexh7jBoS9ig8qK7xawC91RR7
         YDXR9Sn7wGZY6NAUHBVi3UyopMG8zz1srhk2tQNlnuBHaTABYBeYCZdgpi3UK4r6FEiq
         y9JV5/CMgNabhEG6tFF8XgvjouTvtHX3G4RtublxDt7g6CQCsgrHKk64fHsm8s8jkMZi
         zqgA==
X-Gm-Message-State: APjAAAVeE/h5Cwlo8HuiFNkmcRMCi88c7XoiARO/ykccIiJDaI1EXAKq
        pS8GxZsaa2jg9lPX+3iBD0PO+SxtECafrBjkNIA=
X-Google-Smtp-Source: APXvYqxX2O9DL3ANPlp5yK373uabnONlqwrS0M6y6JVInbPJDmHKKpqz4TBy/FcS5ovZQdiBJ/N7UD/wcIkRLycQlMI=
X-Received: by 2002:ad4:4e34:: with SMTP id dm20mr9685558qvb.163.1576790198613;
 Thu, 19 Dec 2019 13:16:38 -0800 (PST)
MIME-Version: 1.0
References: <20191219070659.424273-1-andriin@fb.com> <20191219070659.424273-3-andriin@fb.com>
 <97ddb036-c717-82a3-4a3b-58180d34a8ae@fb.com>
In-Reply-To: <97ddb036-c717-82a3-4a3b-58180d34a8ae@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 19 Dec 2019 13:16:27 -0800
Message-ID: <CAEf4BzYFwJiKdTfXvSjcygOSySUqavFY3zaHZ4-0wcSkvHXRdw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] libbpf/tools: add runqslower tool to libbpf
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 10:13 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 12/18/19 11:06 PM, Andrii Nakryiko wrote:
> > Convert one of BCC tools (runqslower [0]) to BPF CO-RE + libbpf. It matches
> > its BCC-based counterpart 1-to-1, supporting all the same parameters and
> > functionality.
> >
> > runqslower tool utilizes BPF skeleton, auto-generated from BPF object file,
> > as well as memory-mapped interface to global (read-only, in this case) data.
> > Its makefile also ensures auto-generation of "relocatable" vmlinux.h, which is
> > necessary for BTF-typed raw tracepoints with direct memory access.
> >
> >    [0] https://github.com/iovisor/bcc/blob/11bf5d02c895df9646c117c713082eb192825293/tools/runqslower.py
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   tools/lib/bpf/tools/runqslower/.gitignore     |   2 +
> >   tools/lib/bpf/tools/runqslower/Makefile       |  60 ++++++
> >   .../lib/bpf/tools/runqslower/runqslower.bpf.c | 101 ++++++++++
> >   tools/lib/bpf/tools/runqslower/runqslower.c   | 187 ++++++++++++++++++
> >   tools/lib/bpf/tools/runqslower/runqslower.h   |  13 ++
> >   5 files changed, 363 insertions(+)
> >   create mode 100644 tools/lib/bpf/tools/runqslower/.gitignore
> >   create mode 100644 tools/lib/bpf/tools/runqslower/Makefile
> >   create mode 100644 tools/lib/bpf/tools/runqslower/runqslower.bpf.c
> >   create mode 100644 tools/lib/bpf/tools/runqslower/runqslower.c
> >   create mode 100644 tools/lib/bpf/tools/runqslower/runqslower.h
> >
> > diff --git a/tools/lib/bpf/tools/runqslower/.gitignore b/tools/lib/bpf/tools/runqslower/.gitignore
> > new file mode 100644
> > index 000000000000..404942cc9371
> > --- /dev/null
> > +++ b/tools/lib/bpf/tools/runqslower/.gitignore
> > @@ -0,0 +1,2 @@
> > +/.output
> > +/runqslower
> > diff --git a/tools/lib/bpf/tools/runqslower/Makefile b/tools/lib/bpf/tools/runqslower/Makefile
> > new file mode 100644
> > index 000000000000..b87b1f9fe9da
> > --- /dev/null
> > +++ b/tools/lib/bpf/tools/runqslower/Makefile
> > @@ -0,0 +1,60 @@
> > +# SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> > +CLANG := clang
> > +LLC := llc
> > +LLVM_STRIP := llvm-strip
> > +BPFTOOL := bpftool
>
> Maybe it is better to use in-tree bpftool? This will ensure we use the
> one shipped together with the source which should have needed functionality.

I can do that as well, though I tried to keep it close enough to how
libbpf+CO-RE applications are going to be built in the wild, so tried
to minimize amount of in-kernel source tree assumptions. Ideally both
bpftool is installed and libbpf is available as a dynamic library in
the system. But surely I can add bpftool auto-build and use that one.

>
> > +LIBBPF_SRC := ../..
> > +CFLAGS := -g -Wall
> > +
> > +# Try to detect best kernel BTF source
> > +KERNEL_REL := $(shell uname -r)
> > +ifneq ("$(wildcard /sys/kenerl/btf/vmlinux)","")
> > +VMLINUX_BTF := /sys/kernel/btf/vmlinux
> > +else ifneq ("$(wildcard /boot/vmlinux-$(KERNEL_REL))","")
> > +VMLINUX_BTF := /boot/vmlinux-$(KERNEL_REL)
> > +else
> > +$(error "Can't detect kernel BTF, use VMLINUX_BTF to specify it explicitly")
> > +endif
> > +
> > +out := .output
> > +abs_out := $(abspath $(out))
> > +libbpf_src := $(abspath $(LIBBPF_SRC))
> > +
> > +.DELETE_ON_ERROR:
> > +
> > +.PHONY: all
> > +all: runqslower
> > +
> > +.PHONY: clean
> > +clean:
> > +     rm -rf $(out) runqslower
> > +
> > +runqslower: $(out)/runqslower.o $(out)/libbpf.a
> > +     $(CC) $(CFLAGS) -lelf -lz $^ -o $@
> > +
> > +$(out)/vmlinux.h: $(VMLINUX_BTF) | $(out)
> > +     $(BPFTOOL) btf dump file $(VMLINUX_BTF) format core > $@
> > +
> > +$(out)/libbpf.a: | $(out)
> > +     cd $(out) &&                                                          \
> > +     $(MAKE) -C $(libbpf_src) OUTPUT=$(abs_out)/ $(abs_out)/libbpf.a
> > +
> > +$(out)/runqslower.o: runqslower.h $(out)/runqslower.skel.h                 \
> > +                  $(out)/runqslower.bpf.o
> > +
> > +$(out)/runqslower.bpf.o: $(out)/vmlinux.h runqslower.h
> > +
> > +$(out)/%.skel.h: $(out)/%.bpf.o
> > +     $(BPFTOOL) gen skeleton $< > $@
> > +
> > +$(out)/%.bpf.o: %.bpf.c | $(out)
> > +     $(CLANG) -g -O2 -target bpf -I$(out) -I$(LIBBPF_SRC)                  \
> > +              -c $(filter %.c,$^) -o $@ &&                                 \
> > +     $(LLVM_STRIP) -g $@
> > +
> > +$(out)/%.o: %.c | $(out)
> > +     $(CC) $(CFLAGS) -I$(LIBBPF_SRC) -I$(out) -c $(filter %.c,$^) -o $@
> > +
> > +$(out):
> > +     mkdir -p $(out)
> > +
> [...]
