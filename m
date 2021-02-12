Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8A83198D3
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhBLDce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:32:34 -0500
Received: from conssluserg-02.nifty.com ([210.131.2.81]:43160 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhBLDc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 22:32:28 -0500
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id 11C3VMuq032592;
        Fri, 12 Feb 2021 12:31:22 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com 11C3VMuq032592
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1613100683;
        bh=UgXhTmEgG78gZGSkfIhvjRiMvprjydlQULXYBgmgRwY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=huMkwvVBD8rZZGjJgDfZa5Qm+6rA8WYCWlrIa6/dOk3qdbXyHswyd7cmB/gkDddum
         Ab18lmAwNlHkhZzXurK+ODrtl5znS6XOmfbFuT64KaJHLAtk24mPyeTX+T3A5wCfZN
         iDSI8e8nnkdEEWa/9X4o7paYgaPE1N0kAK3Z0WX3rjXkoiSaTNXsN6/xTxx6NW1ldi
         ttxfoMqfo/86LToMCpzwekpawvbmyUb0IPMOa4e67qC1HX4v1sDXPAP3ef8GN9+HSk
         VF1yfwNK/ny8vlpg3fHZ9ReJGzvLm51aqdPN3qFVrt0GlGYmYaI4X4Tl7j5yWNRCNo
         opA2GYbyet7vg==
X-Nifty-SrcIP: [209.85.215.173]
Received: by mail-pg1-f173.google.com with SMTP id t26so5372451pgv.3;
        Thu, 11 Feb 2021 19:31:22 -0800 (PST)
X-Gm-Message-State: AOAM532777x5f8fooT6ruxDCCY29MtfBQf0TcPYFwsPgR/yJ23+QZzsb
        sPSagyoU+2Fkw7kuR3H1iF9nu7AXkp7qi0Kf9v0=
X-Google-Smtp-Source: ABdhPJzzPWMVs2TMBJxt0OrXv6GM+B92F7SYM/zwhAicTpz6p2nlB61o0LHKIxVeIwCY/unsmK2MhT1uYOZTlte/LsQ=
X-Received: by 2002:a63:575e:: with SMTP id h30mr1256230pgm.7.1613100681957;
 Thu, 11 Feb 2021 19:31:21 -0800 (PST)
MIME-Version: 1.0
References: <20210205124020.683286-1-jolsa@kernel.org> <20210205124020.683286-5-jolsa@kernel.org>
 <20210210174451.GA1943051@ubuntu-m3-large-x86> <CAEf4BzZvz4-STv3OQxyNDiFKkrFM-+GOM-yXURzoDtXiRiuT_g@mail.gmail.com>
 <20210210180215.GA2374611@ubuntu-m3-large-x86> <YCQmCwBSQuj+bi4q@krava>
 <CAEf4BzbwwtqerxRrNZ75WLd2aHLdnr7wUrKahfT7_6bjBgJ0xQ@mail.gmail.com> <YCUgUlCDGTS85MCO@krava>
In-Reply-To: <YCUgUlCDGTS85MCO@krava>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Fri, 12 Feb 2021 12:30:45 +0900
X-Gmail-Original-Message-ID: <CAK7LNAT8oTvLJ9FRsrRB5GUS2K+y2QY36Wshb9x1YE5d=ZyA5g@mail.gmail.com>
Message-ID: <CAK7LNAT8oTvLJ9FRsrRB5GUS2K+y2QY36Wshb9x1YE5d=ZyA5g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] kbuild: Add resolve_btfids clean to root
 clean target
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 9:17 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Feb 10, 2021 at 11:26:28AM -0800, Andrii Nakryiko wrote:
>
> SNIP
>
> > > > > Can't reproduce it. It works in all kinds of variants (relative and
> > > > > absolute O=, clean and not clean trees, etc). Jiri, please check as
> > > > > well.
> > > > >
> > > >
> > > > Odd, this reproduces for me on a completely clean checkout of bpf-next:
> > > >
> > > > $ git clone --depth=1 https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/
> > > >
> > > > $ cd bpf-next
> > > >
> > > > $ make -s O=build distclean
> > > > ../../scripts/Makefile.include:4: *** O=/tmp/bpf-next/build/tools/bpf/resolve_btfids does not exist.  Stop.
> > > >
> > > > I do not really see how this could be environment related. It seems like
> > > > this comes from tools/scripts/Makefile.include, where there is no
> > > > guarantee that $(O) is created before being used like in the main
> > > > Makefile?
> > >
> > > right, we need to handle the case where tools/bpf/resolve_btfids
> > > does not exist, patch below fixes it for me
> > >
> > > jirka
> > >
> >
> > Looks good to me, please send it as a proper patch to bpf-next.
> >
> > But I'm curious, why is objtool not doing something like that? Is it
> > not doing clean at all? Or does it do it in some different way?
>
> yes, it's not connected to global make clean
>
> >
> > >
> > > ---
> > > diff --git a/Makefile b/Makefile
> > > index 159d9592b587..ce9685961abe 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -1088,8 +1088,14 @@ endif
> > >
> > >  PHONY += resolve_btfids_clean
> > >
> > > +resolve_btfids_O = $(abspath $(objtree))/tools/bpf/resolve_btfids
> > > +
> > > +# tools/bpf/resolve_btfids directory might not exist
> > > +# in output directory, skip its clean in that case
> > >  resolve_btfids_clean:
> > > -       $(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(abspath $(objtree))/tools/bpf/resolve_btfids clean
> > > +ifneq (,$(wildcard $(resolve_btfids_O)))
> >
> > nit: kind of backwards, usually it's in a `ifneq($var,)` form
>
> ok
>
> thanks,
> jirka
>


I expected this kind of mess
when I saw 33a57ce0a54d498275f432db04850001175dfdfa


The tools/ directory is a completely different world
governed by a different build system
(no, not a build system, but a collection of adhoc makefile code)


All the other programs used during the kernel build
are located under scripts/, and can be built with
a simple syntax, and cleaned up correctly.
It is simple, clean and robust.

objtool is the first alien that opt out Kbuild,
and this is the second one.


It is scary to mix up two different things,
which run in different working directories.

See, this is wired up in the top Makefile
in an ugly way, and you are struggling
in suppressing issues, where you can never
do it in the right way.



-- 
Best Regards
Masahiro Yamada
