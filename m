Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55D0316D63
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 18:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbhBJRx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbhBJRxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 12:53:35 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145FAC061574;
        Wed, 10 Feb 2021 09:52:54 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id m188so2320306yba.13;
        Wed, 10 Feb 2021 09:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KAh1L7FgxD30dRqMdDkGI8mUAcxr9uaIeaDqKEB9OEI=;
        b=pfHpfy3HIs/BUrAPHhAlSzMC1NyBV61/XtxaGJMcPukV3PRzQzoixWBCAA/+1oGabC
         neGSxD6tyBj8qVksQQUlDeVzYawtHkXudz30697NMNRaEY1CW4u0Xp1cnvdmUxbo0MKk
         awFPz/J0EhRb1ZcNrXGkneDeHdnKumYv0hY8FQNxe2Y834hRnnksCHohrOuIT/wQTchu
         D4YuB/wrYXb7G2qh2bCG53Sg0/s8lNDUnH2lM5R1X8ggnrRnyLZYCWmmc4FvaxY6AQDC
         5ffDcVa1K7fhi7Dlbep1ysWa+sVUs4BjIUOVKl/o3D27EeF3HtFW3coaYHl9W6oDvBd3
         1IiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KAh1L7FgxD30dRqMdDkGI8mUAcxr9uaIeaDqKEB9OEI=;
        b=G0UXXoPKaIja12OLEVNxOvrRXl4lSETsFXq8Ki70b4CEwIP2OgASPgmH1dVSGCwsIJ
         eIr5VmlhErsJl1sL+cKOLHVWzluQj005CXIrgon062mQ7kvxxMwRGoGJcaLofryaCiza
         jQYNj+nvuJVG7qTClE4/tKYh+mJm7CLNufoLz49cI2wgJjQjLq60yXJZQ0LfpdPCAAcg
         RyfGoqT4v9Ze5igRjh8k5LxzHJAXYbqf452HpYF1LoVbe3Jrhj+WfMN/OE2umviWkovC
         B6sZIybxgucuX52t2Z5FbjhocEGBDygTfovl5yARNJDSRPax7pmFQ4XAJSG33ayqCzc7
         tx6g==
X-Gm-Message-State: AOAM532hRBGyWNYKY09TZB23KOCzJoSEwOSd1F+tcBotYWoZfW3Besl8
        aBw8DEl/6bJRHS/y609gCDoG762PsCZxxqFjMpc=
X-Google-Smtp-Source: ABdhPJw7KnbFtBVit1DBx927O41aueogn2C2nLxS81n8XUiwiYcL0YFUbmzaiSysQ+Rg1JSFpJdGogObV2jKiWV4mzo=
X-Received: by 2002:a25:4b86:: with SMTP id y128mr5594033yba.403.1612979573286;
 Wed, 10 Feb 2021 09:52:53 -0800 (PST)
MIME-Version: 1.0
References: <20210205124020.683286-1-jolsa@kernel.org> <20210205124020.683286-5-jolsa@kernel.org>
 <20210210174451.GA1943051@ubuntu-m3-large-x86>
In-Reply-To: <20210210174451.GA1943051@ubuntu-m3-large-x86>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Feb 2021 09:52:42 -0800
Message-ID: <CAEf4BzZvz4-STv3OQxyNDiFKkrFM-+GOM-yXURzoDtXiRiuT_g@mail.gmail.com>
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

On Wed, Feb 10, 2021 at 9:47 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> On Fri, Feb 05, 2021 at 01:40:20PM +0100, Jiri Olsa wrote:
> > The resolve_btfids tool is used during the kernel build,
> > so we should clean it on kernel's make clean.
> >
> > Invoking the the resolve_btfids clean as part of root
> > 'make clean'.
> >
> > Acked-by: Song Liu <songliubraving@fb.com>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  Makefile | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/Makefile b/Makefile
> > index b0e4767735dc..159d9592b587 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1086,6 +1086,11 @@ ifdef CONFIG_STACK_VALIDATION
> >    endif
> >  endif
> >
> > +PHONY += resolve_btfids_clean
> > +
> > +resolve_btfids_clean:
> > +     $(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(abspath $(objtree))/tools/bpf/resolve_btfids clean
> > +
> >  ifdef CONFIG_BPF
> >  ifdef CONFIG_DEBUG_INFO_BTF
> >    ifeq ($(has_libelf),1)
> > @@ -1495,7 +1500,7 @@ vmlinuxclean:
> >       $(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
> >       $(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
> >
> > -clean: archclean vmlinuxclean
> > +clean: archclean vmlinuxclean resolve_btfids_clean
> >
> >  # mrproper - Delete all generated files, including .config
> >  #
> > --
> > 2.26.2
> >
>
> This breaks running distclean on a clean tree (my script just
> unconditionally runs distclean regardless of the tree state):
>
> $ make -s O=build distclean
> ../../scripts/Makefile.include:4: *** O=/home/nathan/cbl/src/linux-next/build/tools/bpf/resolve_btfids does not exist.  Stop.
>

Can't reproduce it. It works in all kinds of variants (relative and
absolute O=, clean and not clean trees, etc). Jiri, please check as
well.

> Cheers,
> Nathan
