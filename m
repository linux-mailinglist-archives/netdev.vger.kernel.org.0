Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A22C4AB0C1
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 04:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392044AbfIFCxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 22:53:46 -0400
Received: from conssluserg-01.nifty.com ([210.131.2.80]:19502 "EHLO
        conssluserg-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390200AbfIFCxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 22:53:46 -0400
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id x862rNhb032429;
        Fri, 6 Sep 2019 11:53:24 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com x862rNhb032429
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1567738405;
        bh=kAR/wUqcS7gRREBOyEy6+SqUwzX1vVwqh4NOYgKBk3o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fQUGbAtYnD8n9HX3vf4Acj0jkQKT7ErsEmAOElvGGUERqlMDMpf8FYbSsBORK2QzA
         o/ezlgcjrNu7/U6njcJfAJ+bGRQIrUg2a2Y1jI03DQndkvEXzkK92z9xhErW1JcntT
         5uf6xKjp+CWF0RJ/81egtD96BBxu5yOngPOUu0VK1l3zxzVSDiKjmDHemPSF5oqnKW
         gAsD7vIkgx5c/xqbgsIuUsqTA9CO210EdIl92yaaxVOZGKelZdtYnROy3bSupfMa5M
         hcbQh42DuARYJ+r1rGESp8GUJmpHfuwyh6I8Kp5FbzvTZv693X19b/YDBS+dW2tp3i
         I72aPQlpwYuJg==
X-Nifty-SrcIP: [209.85.221.169]
Received: by mail-vk1-f169.google.com with SMTP id v78so972397vke.4;
        Thu, 05 Sep 2019 19:53:24 -0700 (PDT)
X-Gm-Message-State: APjAAAV7mGswYgoXJ2GBMLGp59n3Tm0G2bHhSuM+CCZb2ppI8wkU0V5Z
        d9pWyP9GihPdnGjWwqwo5PdMEGafZwueM7D3Wqw=
X-Google-Smtp-Source: APXvYqxKHG+SoIWTg+3MVhU4LfbuFQuaIy+CykEgSdi/cANBbzxlMXrAaA0HDNNda7sdr7Ki3nzikn9ylYx4U3nnShA=
X-Received: by 2002:a1f:9e83:: with SMTP id h125mr3244894vke.84.1567738403251;
 Thu, 05 Sep 2019 19:53:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190904160021.72d104f1@canb.auug.org.au> <CAK7LNAQEU6uu-Z=VeR2KNa8ezCLA7VHtpvM2tvAKsWtUTi6Eug@mail.gmail.com>
 <CAEf4BzZLBV3o=t9+a4o4T7KZ_M04vddD0RMVs3s4JvDsvQ8onA@mail.gmail.com>
In-Reply-To: <CAEf4BzZLBV3o=t9+a4o4T7KZ_M04vddD0RMVs3s4JvDsvQ8onA@mail.gmail.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Fri, 6 Sep 2019 11:52:47 +0900
X-Gmail-Original-Message-ID: <CAK7LNATkk3VfzgynBEyOinKo3yBEDgNHLgO3bftLAPbDVVWx=A@mail.gmail.com>
Message-ID: <CAK7LNATkk3VfzgynBEyOinKo3yBEDgNHLgO3bftLAPbDVVWx=A@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Fri, Sep 6, 2019 at 4:26 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Sep 3, 2019 at 11:20 PM Masahiro Yamada
> <yamada.masahiro@socionext.com> wrote:
> >
> > On Wed, Sep 4, 2019 at 3:00 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > Hi all,
> > >
> > > After merging the net-next tree, today's linux-next build (arm
> > > multi_v7_defconfig) failed like this:
> > >
> > > scripts/link-vmlinux.sh: 74: Bad substitution
> > >
> > > Caused by commit
> > >
> > >   341dfcf8d78e ("btf: expose BTF info through sysfs")
> > >
> > > interacting with commit
> > >
> > >   1267f9d3047d ("kbuild: add $(BASH) to run scripts with bash-extension")
> > >
> > > from the kbuild tree.
> >
> >
> > I knew that they were using bash-extension
> > in the #!/bin/sh script.  :-D
> >
> > In fact, I wrote my patch in order to break their code
> > and  make btf people realize that they were doing wrong.
>
> Was there a specific reason to wait until this would break during
> Stephen's merge, instead of giving me a heads up (or just replying on
> original patch) and letting me fix it and save everyone's time and
> efforts?
>
> Either way, I've fixed the issue in
> https://patchwork.ozlabs.org/patch/1158620/ and will pay way more
> attention to BASH-specific features going forward (I found it pretty
> hard to verify stuff like this, unfortunately). But again, code review
> process is the best place to catch this and I really hope in the
> future we can keep this process productive. Thanks!

I could have pointed it out if I had noticed
it in the review process.

I actually noticed your patch by Stephen's
former email.  (i.e. when it appeared in linux-next)

(I try my best to check kbuild ML, and also search for
my name in LKML in case I am explicitly addressed,
but a large number of emails fall off my filter)

It was somewhat too late when I noticed it.
Of course, I still could email you afterward, or even send a patch to btf ML,
but I did not fix a particular instance of breakage
because there are already the same type of breakages in code base.

Then, I applied the all-or-nothing checker because I thought it was
the only way to address the root cause of the problems.

I admit I could have done the process better.
Sorry if I made people uncomfortable and waste time.

Thanks.




> >
> >
> >
> > > The change in the net-next tree turned link-vmlinux.sh into a bash script
> > > (I think).
> > >
> > > I have applied the following patch for today:
> >
> >
> > But, this is a temporary fix only for linux-next.
> >
> > scripts/link-vmlinux.sh does not need to use the
> > bash-extension ${@:2} in the first place.
> >
> > I hope btf people will write the correct code.
>
> I replaced ${@:2} with shift and ${@}, I hope that's a correct fix,
> but if you think it's not, please reply on the patch and let me know.
>
>
> >
> > Thanks.
> >
> >
> >
> >
> > > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > > Date: Wed, 4 Sep 2019 15:43:41 +1000
> > > Subject: [PATCH] link-vmlinux.sh is now a bash script
> > >
> > > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > > ---
> > >  Makefile                | 4 ++--
> > >  scripts/link-vmlinux.sh | 2 +-
> > >  2 files changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/Makefile b/Makefile
> > > index ac97fb282d99..523d12c5cebe 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -1087,7 +1087,7 @@ ARCH_POSTLINK := $(wildcard $(srctree)/arch/$(SRCARCH)/Makefile.postlink)
> > >
> > >  # Final link of vmlinux with optional arch pass after final link
> > >  cmd_link-vmlinux =                                                 \
> > > -       $(CONFIG_SHELL) $< $(LD) $(KBUILD_LDFLAGS) $(LDFLAGS_vmlinux) ;    \
> > > +       $(BASH) $< $(LD) $(KBUILD_LDFLAGS) $(LDFLAGS_vmlinux) ;    \
> > >         $(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) $@, true)
> > >
> > >  vmlinux: scripts/link-vmlinux.sh autoksyms_recursive $(vmlinux-deps) FORCE
> > > @@ -1403,7 +1403,7 @@ clean: rm-files := $(CLEAN_FILES)
> > >  PHONY += archclean vmlinuxclean
> > >
> > >  vmlinuxclean:
> > > -       $(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
> > > +       $(Q)$(BASH) $(srctree)/scripts/link-vmlinux.sh clean
> > >         $(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
> > >
> > >  clean: archclean vmlinuxclean
> > > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > > index f7edb75f9806..ea1f8673869d 100755
> > > --- a/scripts/link-vmlinux.sh
> > > +++ b/scripts/link-vmlinux.sh
> > > @@ -1,4 +1,4 @@
> > > -#!/bin/sh
> > > +#!/bin/bash
> > >  # SPDX-License-Identifier: GPL-2.0
> > >  #
> > >  # link vmlinux
> > > --
> > > 2.23.0.rc1
> > >
> > > --
> > > Cheers,
> > > Stephen Rothwell
> >
> >
> >
> > --
> > Best Regards
> > Masahiro Yamada



--
Best Regards
Masahiro Yamada
