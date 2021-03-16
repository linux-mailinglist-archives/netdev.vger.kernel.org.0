Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFAC33CD06
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 06:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbhCPFQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 01:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235356AbhCPFQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 01:16:48 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0B2C06174A;
        Mon, 15 Mar 2021 22:16:48 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id b10so35599649ybn.3;
        Mon, 15 Mar 2021 22:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DV8OHvf62qw0DAevPz2yXHaknM06DJDr08JKozYCvnQ=;
        b=Lg8KVLw/qdrnxTIlbIWdILNtOeGlGnaYcHlhHtCqTmIr8bai7IgYuvsnxULuilTDkN
         3o8kor0NVZ4RM4qHD1OYExWgK+xI45nDQpzNwNdYcIDxqtKCoQ/tAwaxGz1mGALIedm9
         lkpdRzqt0xj+x8dhvO3k8/URY+zx7dLfJ7H3beRksohyIJjGlrPj14A/pCkiMkVFAFND
         uQTeqkCHbV1DMjKB7hERrNR0mGNOAzMDIhr000Za0YaO97+Hp5TdUcpLPYi0b0WzcPLq
         5zxNkMe/o0oL6QExg66QbnxcXupYIgGaIHyap7Uuh3S8FkS6HqcmWIgjfbHXH6RunKMF
         redQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DV8OHvf62qw0DAevPz2yXHaknM06DJDr08JKozYCvnQ=;
        b=QkMWDon9LrJXkEqGSuJug7Ut9ZJy2wDAtWYIAwwpVdEpaD4GISbj6DtwqEPc+tpqaN
         c/oc+gGOrJSC6pXLRsbqAxryHsah1LkWClAMdo6rMNVMW0mPKonMS12WO/hQB/SFvTyz
         rnr/gVgtqwpelXUT2NyDao4Z51zbKtCywkRvBp8y9fpZlSrCc9gCHak7dS7vLpN8p5ZM
         TpdTfLuqwZv5fKW3FHeiEv+BBa6SS+SmtoDNd/94JkBzbWJ+NmGlDE/ekQLQDNS6F3sy
         EYKsuFVrI99JVWLes0kuPDt/8DeMcOIRc1IpflBBIWVNOSIGtLynqfthw7wfCo8siCPK
         FyvQ==
X-Gm-Message-State: AOAM533aptbzIml5DSFRltabScoIUSwaIdHoVkzDnXiTgbv1TtC0YQ/a
        +qfYRsR5iddXGFEnHNoh5CscLAiUjc2VsJFxMTC9Py84s54=
X-Google-Smtp-Source: ABdhPJyR+h5jeYtHPPW6q5YyKwQ2ToUFm4PV1ebVd7XjD5ptfi8qUxXIdqpFdEoKP7fW/pNyVzAAoQAk2+Jf4uCT6hM=
X-Received: by 2002:a25:cc13:: with SMTP id l19mr4665988ybf.260.1615871807989;
 Mon, 15 Mar 2021 22:16:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210313193537.1548766-1-andrii@kernel.org> <20210313193537.1548766-9-andrii@kernel.org>
 <af200ca7-5946-9df6-71ec-98042aecfa27@isovalent.com>
In-Reply-To: <af200ca7-5946-9df6-71ec-98042aecfa27@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Mar 2021 22:16:37 -0700
Message-ID: <CAEf4Bzag+Vx4uBEeeoVfU0gOmq=J70DCsr8Yr3Y=K257Ry1-kA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 08/11] bpftool: add `gen object` command to
 perform BPF static linking
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 2:24 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-03-13 11:35 UTC-0800 ~ Andrii Nakryiko <andrii@kernel.org>
> > Add `bpftool gen object <output-file> <input_file>...` command to statically
> > link multiple BPF ELF object files into a single output BPF ELF object file.
> >
> > Similarly to existing '*.o' convention, bpftool is establishing a '*.bpfo'
> > convention for statically-linked BPF object files. Both .o and .bpfo suffixes
> > will be stripped out during BPF skeleton generation to infer BPF object name.
> >
> > This patch also updates bash completions and man page. Man page gets a short
> > section on `gen object` command, but also updates the skeleton example to show
> > off workflow for BPF application with two .bpf.c files, compiled individually
> > with Clang, then resulting object files are linked together with `gen object`,
> > and then final object file is used to generate usable BPF skeleton. This
> > should help new users understand realistic workflow w.r.t. compiling
> > mutli-file BPF application.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >  .../bpf/bpftool/Documentation/bpftool-gen.rst | 65 +++++++++++++++----
> >  tools/bpf/bpftool/bash-completion/bpftool     |  2 +-
> >  tools/bpf/bpftool/gen.c                       | 49 +++++++++++++-
> >  3 files changed, 99 insertions(+), 17 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
> > index 84cf0639696f..4cdce187c393 100644
> > --- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
> > +++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
> > @@ -14,16 +14,37 @@ SYNOPSIS
> >
> >       *OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] }
> >
> > -     *COMMAND* := { **skeleton** | **help** }
> > +     *COMMAND* := { **object** | **skeleton** | **help** }
> >
> >  GEN COMMANDS
> >  =============
> >
> > +|    **bpftool** **gen object** *OUTPUT_FILE* *INPUT_FILE* [*INPUT_FILE*...]
> >  |    **bpftool** **gen skeleton** *FILE*
> >  |    **bpftool** **gen help**
> >
> >  DESCRIPTION
> >  ===========
> > +     **bpftool gen object** *OUTPUT_FILE* *INPUT_FILE* [*INPUT_FILE*...]
> > +               Statically link (combine) together one or more *INPUT_FILE*'s
> > +               into a single resulting *OUTPUT_FILE*. All the files involed
>
> Typo: "involed"
>
> > +               are BPF ELF object files.
> > +
> > +               The rules of BPF static linking are mostly the same as for
> > +               user-space object files, but in addition to combining data
> > +               and instruction sections, .BTF and .BTF.ext (if present in
> > +               any of the input files) data are combined together. .BTF
> > +               data is deduplicated, so all the common types across
> > +               *INPUT_FILE*'s will only be represented once in the resulting
> > +               BTF information.
> > +
> > +               BPF static linking allows to partition BPF source code into
> > +               individually compiled files that are then linked into
> > +               a single resulting BPF object file, which can be used to
> > +               generated BPF skeleton (with **gen skeleton** command) or
> > +               passed directly into **libbpf** (using **bpf_object__open()**
> > +               family of APIs).
> > +
> >       **bpftool gen skeleton** *FILE*
> >                 Generate BPF skeleton C header file for a given *FILE*.
> >
>
> > diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> > index fdffbc64c65c..7ca23c58f2c0 100644
> > --- a/tools/bpf/bpftool/bash-completion/bpftool
> > +++ b/tools/bpf/bpftool/bash-completion/bpftool
> > @@ -981,7 +981,7 @@ _bpftool()
> >              ;;
> >          gen)
> >              case $command in
> > -                skeleton)
> > +                object|skeleton)
> >                      _filedir
> >                      ;;
> >                  *)
>
> Suggesting the "object" keyword for completing "bpftool gen [tab]"
> is missing. It is just a few lines below:
>
> ------
> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index fdffbc64c65c..223438e86932 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -981,12 +981,12 @@ _bpftool()
>              ;;
>          gen)
>              case $command in
> -                skeleton)
> +                object|skeleton)
>                      _filedir
>                      ;;
>                  *)
>                      [[ $prev == $object ]] && \
> -                        COMPREPLY=( $( compgen -W 'skeleton help' -- "$cur" ) )
> +                        COMPREPLY=( $( compgen -W 'object skeleton help' -- "$cur" ) )
>                      ;;
>              esac
>              ;;
> ------
>
> Looks good otherwise. Thanks for the documentation, it's great to
> have the example in the man page.
>
> Pending the two nits above are fixed:
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Thanks! I'll wait a bit for some more feedback on other patches and
will fix it in the next version (unless my other patches are perfect,
of course ;).

>
> Quentin
