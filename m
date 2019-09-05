Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 914AAAABEC
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 21:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387438AbfIET00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 15:26:26 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37064 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbfIET00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 15:26:26 -0400
Received: by mail-qt1-f195.google.com with SMTP id g13so3779233qtj.4;
        Thu, 05 Sep 2019 12:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0r/znGHIj2Grw9klAyjeQvZth4AaeZj93+usoxZBVCI=;
        b=nnrajutKL1aJFG4M+XqaQqsGbl1ULe2ZDuBP5kA06rya+jN3ZjXcDANxXsQythz+Bo
         XSUticCROrNWMMomCwX54h9/gF0LZYg2y9WoQ7w/tb6/iI6wfMF8oaWter2DRQarneOA
         g7pWoVLTNrkbqs9et/yeKphmWQFcnDfQ1iNmy8MepfARUhHRPtkwSQWHxUk9DCkdo1Ma
         YjqlZhdvCb4b082lDq3IhxxnLNbWIaVvRVWa5v+dWU+D1YLNw04sTa5nIdQ/5nV8A6bq
         CIEhV4dOBHcj++mizon8s4jYHPG7VXaoR/2FJYNsT2fCy+TrL6Mb0S0x4Z6Kdq5ZkEaJ
         lopw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0r/znGHIj2Grw9klAyjeQvZth4AaeZj93+usoxZBVCI=;
        b=rTXsvlwIy/neP52g44etntola0h+dcYSuMvMzzJBOW7hZS11evp9/25CIdH9FCVnZY
         n0lG7DgNmbKnJzN1V2Q5tG5Yj6aYL4BQhkE2XRZ4zhPoNgVX7K+oTQhTCHupdUpmHiZE
         VEqk4AN5Z5zlRWqKUkXPU4KHhiBMFNlVJ590n07BQo3vGJ4EkNX70dPOAS0WyyjVVjpx
         LDz6DPpnxyPj6ez01oJpR1b+ZthlYv9mbJc+nt9i6ygbHBacGeIwSeKn/YMLvq5Mq8V3
         FKrIjYP0IZeQDb0Dpn0aFEva4B8ADAG8tc4gUVJuge4CWXakRBzePA5MRzyDBesgenIB
         zw9Q==
X-Gm-Message-State: APjAAAUbfc9RH0zNDvPnVqgK/UWbH7aXTjWhKoN03NJJB4mQ9FKOgM3s
        INz6p1x+vhGyqlB3Bfm4m44oFnhIPOYPyvJMG2k=
X-Google-Smtp-Source: APXvYqwMbXNzfBi/GIvilhcFGjlZQw/f5m+TrIcysRJsasuXyqXs1FeFeOSQeHZzhK+9dJHguhczBeE0knW9cEvflu0=
X-Received: by 2002:ac8:478a:: with SMTP id k10mr5266013qtq.117.1567711584703;
 Thu, 05 Sep 2019 12:26:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190904160021.72d104f1@canb.auug.org.au> <CAK7LNAQEU6uu-Z=VeR2KNa8ezCLA7VHtpvM2tvAKsWtUTi6Eug@mail.gmail.com>
In-Reply-To: <CAK7LNAQEU6uu-Z=VeR2KNa8ezCLA7VHtpvM2tvAKsWtUTi6Eug@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 5 Sep 2019 12:26:13 -0700
Message-ID: <CAEf4BzZLBV3o=t9+a4o4T7KZ_M04vddD0RMVs3s4JvDsvQ8onA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 3, 2019 at 11:20 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> On Wed, Sep 4, 2019 at 3:00 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Hi all,
> >
> > After merging the net-next tree, today's linux-next build (arm
> > multi_v7_defconfig) failed like this:
> >
> > scripts/link-vmlinux.sh: 74: Bad substitution
> >
> > Caused by commit
> >
> >   341dfcf8d78e ("btf: expose BTF info through sysfs")
> >
> > interacting with commit
> >
> >   1267f9d3047d ("kbuild: add $(BASH) to run scripts with bash-extension")
> >
> > from the kbuild tree.
>
>
> I knew that they were using bash-extension
> in the #!/bin/sh script.  :-D
>
> In fact, I wrote my patch in order to break their code
> and  make btf people realize that they were doing wrong.

Was there a specific reason to wait until this would break during
Stephen's merge, instead of giving me a heads up (or just replying on
original patch) and letting me fix it and save everyone's time and
efforts?

Either way, I've fixed the issue in
https://patchwork.ozlabs.org/patch/1158620/ and will pay way more
attention to BASH-specific features going forward (I found it pretty
hard to verify stuff like this, unfortunately). But again, code review
process is the best place to catch this and I really hope in the
future we can keep this process productive. Thanks!

>
>
>
> > The change in the net-next tree turned link-vmlinux.sh into a bash script
> > (I think).
> >
> > I have applied the following patch for today:
>
>
> But, this is a temporary fix only for linux-next.
>
> scripts/link-vmlinux.sh does not need to use the
> bash-extension ${@:2} in the first place.
>
> I hope btf people will write the correct code.

I replaced ${@:2} with shift and ${@}, I hope that's a correct fix,
but if you think it's not, please reply on the patch and let me know.


>
> Thanks.
>
>
>
>
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Wed, 4 Sep 2019 15:43:41 +1000
> > Subject: [PATCH] link-vmlinux.sh is now a bash script
> >
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  Makefile                | 4 ++--
> >  scripts/link-vmlinux.sh | 2 +-
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/Makefile b/Makefile
> > index ac97fb282d99..523d12c5cebe 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1087,7 +1087,7 @@ ARCH_POSTLINK := $(wildcard $(srctree)/arch/$(SRCARCH)/Makefile.postlink)
> >
> >  # Final link of vmlinux with optional arch pass after final link
> >  cmd_link-vmlinux =                                                 \
> > -       $(CONFIG_SHELL) $< $(LD) $(KBUILD_LDFLAGS) $(LDFLAGS_vmlinux) ;    \
> > +       $(BASH) $< $(LD) $(KBUILD_LDFLAGS) $(LDFLAGS_vmlinux) ;    \
> >         $(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) $@, true)
> >
> >  vmlinux: scripts/link-vmlinux.sh autoksyms_recursive $(vmlinux-deps) FORCE
> > @@ -1403,7 +1403,7 @@ clean: rm-files := $(CLEAN_FILES)
> >  PHONY += archclean vmlinuxclean
> >
> >  vmlinuxclean:
> > -       $(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
> > +       $(Q)$(BASH) $(srctree)/scripts/link-vmlinux.sh clean
> >         $(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
> >
> >  clean: archclean vmlinuxclean
> > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > index f7edb75f9806..ea1f8673869d 100755
> > --- a/scripts/link-vmlinux.sh
> > +++ b/scripts/link-vmlinux.sh
> > @@ -1,4 +1,4 @@
> > -#!/bin/sh
> > +#!/bin/bash
> >  # SPDX-License-Identifier: GPL-2.0
> >  #
> >  # link vmlinux
> > --
> > 2.23.0.rc1
> >
> > --
> > Cheers,
> > Stephen Rothwell
>
>
>
> --
> Best Regards
> Masahiro Yamada
