Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1C231700E
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 20:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbhBJTYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 14:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbhBJTXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 14:23:55 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266C2C061574;
        Wed, 10 Feb 2021 11:23:15 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id f2so3149877ioq.2;
        Wed, 10 Feb 2021 11:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NkYoy9buCQsEegEicFBby9ZhYZEuVWAS8lqJiSMkCkA=;
        b=iqrYWI42ZCYhY+qahaijXZCVmakGsolbMo5QZ2+6FRatOOuvux7UQXJiSKE1G4X9C+
         LjjpRonZlMCYL2aBqTIFWMdXrDp0somQv6QOxu3TcwtQqNgumR4gFIJN92xC5U+72WgW
         75mJwQnqP8DdVtsjdTWHxpEzM6282NO8h1PSDJSMpTZKlcBmRaVm8njSydX5mIcKGjYF
         Na9MUvi1E4Hzt0wUFw+PO1gCIreH7yFNHxCN0M34uzefuS6azC5056rTiE+OoqnHlr/j
         iUMqIR3GD+9gFheRUnN+OHCIDYpzln0MDffuoD4FvM0ftc1Qo9NoqaodaWFcyVaNfJuX
         sm8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NkYoy9buCQsEegEicFBby9ZhYZEuVWAS8lqJiSMkCkA=;
        b=rrW9kHO1JUArrj10lZQvquM4g2g77nAYkiYMmObIOfxO5h++nlX5b4qRnfVD1vyKmr
         xqBtGH9Wst+X+cUe4v6mYgZ5ZyBgCZTCuN66e/sWk/SkRE5ECcj4lnaMtGX8fjN6CWXE
         7QMWVZjufSG7zWtZP0ZLlLLFHopMz0z7hvCW6HVD5r0B3jmUtHSQrYioxppQSl2osSzr
         tIPiGJbjM/eSrwXSS88+LZgnzVH2Uc5H5Nlmhk5m1ugrT4CRbN4tNYJXWv2rFe2HLvbx
         hH6Hy2fggjq4PuoPrtSTSs2THViSMPP5zXqs2lA0virRHsVtUlnt8GZrgGyIXmM+mYF5
         lDpA==
X-Gm-Message-State: AOAM530H1ziX1suD7Ifi2c/CYkyzENQFLol6r0zV97GiYw7e86WS48h2
        N29sbYkL6sNrnquV3JbSC0nN+QkeCSZrvW0h/q0=
X-Google-Smtp-Source: ABdhPJwGTy2isZuu4D/BMp5t0NtJtF1hs8aPRrx/VrC0jJvEY+WqZsNbKIdhoPV5g+WT0OBtsfSDtI+g3gSQyskQrg0=
X-Received: by 2002:a05:6638:388e:: with SMTP id b14mr4947485jav.96.1612984994633;
 Wed, 10 Feb 2021 11:23:14 -0800 (PST)
MIME-Version: 1.0
References: <20210205124020.683286-1-jolsa@kernel.org> <20210205124020.683286-5-jolsa@kernel.org>
 <20210210174451.GA1943051@ubuntu-m3-large-x86> <CAEf4BzZvz4-STv3OQxyNDiFKkrFM-+GOM-yXURzoDtXiRiuT_g@mail.gmail.com>
 <20210210180215.GA2374611@ubuntu-m3-large-x86>
In-Reply-To: <20210210180215.GA2374611@ubuntu-m3-large-x86>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Feb 2021 11:23:03 -0800
Message-ID: <CAEf4BzZRafWhwhqrtf=oZgRbmNWB-Q2LJASE8dM8OHiXoeOS8w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] kbuild: Add resolve_btfids clean to root
 clean target
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 10:02 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> On Wed, Feb 10, 2021 at 09:52:42AM -0800, Andrii Nakryiko wrote:
> > On Wed, Feb 10, 2021 at 9:47 AM Nathan Chancellor <nathan@kernel.org> wrote:
> > >
> > > On Fri, Feb 05, 2021 at 01:40:20PM +0100, Jiri Olsa wrote:
> > > > The resolve_btfids tool is used during the kernel build,
> > > > so we should clean it on kernel's make clean.
> > > >
> > > > Invoking the the resolve_btfids clean as part of root
> > > > 'make clean'.
> > > >
> > > > Acked-by: Song Liu <songliubraving@fb.com>
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > > >  Makefile | 7 ++++++-
> > > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/Makefile b/Makefile
> > > > index b0e4767735dc..159d9592b587 100644
> > > > --- a/Makefile
> > > > +++ b/Makefile
> > > > @@ -1086,6 +1086,11 @@ ifdef CONFIG_STACK_VALIDATION
> > > >    endif
> > > >  endif
> > > >
> > > > +PHONY += resolve_btfids_clean
> > > > +
> > > > +resolve_btfids_clean:
> > > > +     $(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(abspath $(objtree))/tools/bpf/resolve_btfids clean
> > > > +
> > > >  ifdef CONFIG_BPF
> > > >  ifdef CONFIG_DEBUG_INFO_BTF
> > > >    ifeq ($(has_libelf),1)
> > > > @@ -1495,7 +1500,7 @@ vmlinuxclean:
> > > >       $(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
> > > >       $(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
> > > >
> > > > -clean: archclean vmlinuxclean
> > > > +clean: archclean vmlinuxclean resolve_btfids_clean
> > > >
> > > >  # mrproper - Delete all generated files, including .config
> > > >  #
> > > > --
> > > > 2.26.2
> > > >
> > >
> > > This breaks running distclean on a clean tree (my script just
> > > unconditionally runs distclean regardless of the tree state):
> > >
> > > $ make -s O=build distclean
> > > ../../scripts/Makefile.include:4: *** O=/home/nathan/cbl/src/linux-next/build/tools/bpf/resolve_btfids does not exist.  Stop.
> > >
> >
> > Can't reproduce it. It works in all kinds of variants (relative and
> > absolute O=, clean and not clean trees, etc). Jiri, please check as
> > well.
> >
>
> Odd, this reproduces for me on a completely clean checkout of bpf-next:

my bad, I was trying it on a branch that didn't have Jiri's patches,
sorry about that.

>
> $ git clone --depth=1 https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/
>
> $ cd bpf-next
>
> $ make -s O=build distclean
> ../../scripts/Makefile.include:4: *** O=/tmp/bpf-next/build/tools/bpf/resolve_btfids does not exist.  Stop.
>
> I do not really see how this could be environment related. It seems like
> this comes from tools/scripts/Makefile.include, where there is no
> guarantee that $(O) is created before being used like in the main
> Makefile?
>
> Cheers,
> Nathan
