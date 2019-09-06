Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43809AB485
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 11:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392812AbfIFJCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 05:02:23 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40386 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390941AbfIFJCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 05:02:22 -0400
Received: by mail-qt1-f194.google.com with SMTP id g4so6227137qtq.7;
        Fri, 06 Sep 2019 02:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+sNVzTFzpqO4o510Ktut/cKCZlxFAKYGMdx2BImNxYw=;
        b=UceHII/0MXhKgMEKJJdc7L7SF7qqH878zuVr03y9ig4cQ5ojpuOCryqVTeXzYqltss
         ADYSVVmMLXlY2F82ZvVYxq+nCJFZj0mdZJYQNgbTXe/sI5GY5p+FMdVs6P4DGjFApxYT
         LIIz0Yb+5uz3X/Bs4Of88PLEym4Ds05hKyb7SLyJi3rXSIDhbw3A/0pEYir0FFWvEq1a
         WqngVbUSCp4X4pHvjg2UEf12LLf/bpy4Rc916/ZCa29NPVnkeVkWx0p/0VFr0qFTfJR8
         IBQMbNfDhh3GrucEJArdJJCvvnI/DTN2drwNn5JtuTK2jHamezE+MA3yMwIfS/10XIvj
         IhuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+sNVzTFzpqO4o510Ktut/cKCZlxFAKYGMdx2BImNxYw=;
        b=Cx3HCCeaxbdBY4IKcCChrPvkKIoNBW2Tc8SWKx/nJoW0Qc0eSBqYnECk8WCvu5pGfv
         cSGFv+PnDI8mvIJZKfxMFSDSPPxDwTtuAjQbpxIjYMJzeaejadEYEzhTldP8ogY/rdic
         HPodLm7Xlq77x50tOcNimT15v+SPPb+2nfSzZsoL3JP4f2gYGxjODXP6Uum+1ff1DfCo
         28F+qhVUnTho8e7qkiU//qeazS1+qYR6CYMiNXERPt9LMRdlPNmGS5vAO4qfM1oDKocF
         WNAIPANeUjGr/kRD9qgS2N2O+Xe2iwkS+u8HwzKyN4mTiu0JovCwJXzOQM8z7wAQWG23
         3P0A==
X-Gm-Message-State: APjAAAW7MqUMe+Y15CdHcO0MUeVI6oJD0DHcgkrk5rFN/cLtHXsom3wd
        Rq61EeXUE0+zlXf06KrPwZ8VJuB+efgT0WHu3tc=
X-Google-Smtp-Source: APXvYqxOjTZgnoWEZ0lCPnV3dD3o1lw/6m5NLB1zK9MzCVvZEeuAhGP76Vlg5RNRCOz4wwzZi6lsZsGzvPupnI3AG7g=
X-Received: by 2002:ac8:4658:: with SMTP id f24mr7497386qto.93.1567760541243;
 Fri, 06 Sep 2019 02:02:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190904160021.72d104f1@canb.auug.org.au> <CAK7LNAQEU6uu-Z=VeR2KNa8ezCLA7VHtpvM2tvAKsWtUTi6Eug@mail.gmail.com>
 <CAEf4BzZLBV3o=t9+a4o4T7KZ_M04vddD0RMVs3s4JvDsvQ8onA@mail.gmail.com> <CAK7LNATkk3VfzgynBEyOinKo3yBEDgNHLgO3bftLAPbDVVWx=A@mail.gmail.com>
In-Reply-To: <CAK7LNATkk3VfzgynBEyOinKo3yBEDgNHLgO3bftLAPbDVVWx=A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Sep 2019 02:02:09 -0700
Message-ID: <CAEf4BzaYouHw_CWJj1yKr56AzEefRRakCuWA1-kt5dXk5CWWGw@mail.gmail.com>
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

On Thu, Sep 5, 2019 at 7:53 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> On Fri, Sep 6, 2019 at 4:26 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Sep 3, 2019 at 11:20 PM Masahiro Yamada
> > <yamada.masahiro@socionext.com> wrote:
> > >
> > > On Wed, Sep 4, 2019 at 3:00 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > >
> > > > Hi all,
> > > >
> > > > After merging the net-next tree, today's linux-next build (arm
> > > > multi_v7_defconfig) failed like this:
> > > >
> > > > scripts/link-vmlinux.sh: 74: Bad substitution
> > > >
> > > > Caused by commit
> > > >
> > > >   341dfcf8d78e ("btf: expose BTF info through sysfs")
> > > >
> > > > interacting with commit
> > > >
> > > >   1267f9d3047d ("kbuild: add $(BASH) to run scripts with bash-extension")
> > > >
> > > > from the kbuild tree.
> > >
> > >
> > > I knew that they were using bash-extension
> > > in the #!/bin/sh script.  :-D
> > >
> > > In fact, I wrote my patch in order to break their code
> > > and  make btf people realize that they were doing wrong.
> >
> > Was there a specific reason to wait until this would break during
> > Stephen's merge, instead of giving me a heads up (or just replying on
> > original patch) and letting me fix it and save everyone's time and
> > efforts?
> >
> > Either way, I've fixed the issue in
> > https://patchwork.ozlabs.org/patch/1158620/ and will pay way more
> > attention to BASH-specific features going forward (I found it pretty
> > hard to verify stuff like this, unfortunately). But again, code review
> > process is the best place to catch this and I really hope in the
> > future we can keep this process productive. Thanks!
>
> I could have pointed it out if I had noticed
> it in the review process.
>
> I actually noticed your patch by Stephen's
> former email.  (i.e. when it appeared in linux-next)
>
> (I try my best to check kbuild ML, and also search for
> my name in LKML in case I am explicitly addressed,
> but a large number of emails fall off my filter)
>
> It was somewhat too late when I noticed it.
> Of course, I still could email you afterward, or even send a patch to btf ML,
> but I did not fix a particular instance of breakage
> because there are already the same type of breakages in code base.
>
> Then, I applied the all-or-nothing checker because I thought it was
> the only way to address the root cause of the problems.
>
> I admit I could have done the process better.
> Sorry if I made people uncomfortable and waste time.

No worries. Thanks for candid answer. I just wanted to make sure there
are no hard feelings and I can engage your expertise effectively in
the future for kbuild stuff to ensure issues like this don't slip
through, if we ever have to do anything like this for BPF-related
things again. I'll keep CC'ing you and will add kbuild ML as well.
Thanks!

>
> Thanks.
>
>
>
>
> > >
> > >
> > >
> > > > The change in the net-next tree turned link-vmlinux.sh into a bash script
> > > > (I think).
> > > >
> > > > I have applied the following patch for today:
> > >
> > >
> > > But, this is a temporary fix only for linux-next.
> > >
> > > scripts/link-vmlinux.sh does not need to use the
> > > bash-extension ${@:2} in the first place.
> > >
> > > I hope btf people will write the correct code.
> >
> > I replaced ${@:2} with shift and ${@}, I hope that's a correct fix,
> > but if you think it's not, please reply on the patch and let me know.
> >
> >
> > >
> > > Thanks.
> > >
> > >
> > >
> > >
> > > > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > > > Date: Wed, 4 Sep 2019 15:43:41 +1000
> > > > Subject: [PATCH] link-vmlinux.sh is now a bash script
> > > >
> > > > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > > > ---
> > > >  Makefile                | 4 ++--
> > > >  scripts/link-vmlinux.sh | 2 +-
> > > >  2 files changed, 3 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/Makefile b/Makefile
> > > > index ac97fb282d99..523d12c5cebe 100644
> > > > --- a/Makefile
> > > > +++ b/Makefile
> > > > @@ -1087,7 +1087,7 @@ ARCH_POSTLINK := $(wildcard $(srctree)/arch/$(SRCARCH)/Makefile.postlink)
> > > >
> > > >  # Final link of vmlinux with optional arch pass after final link
> > > >  cmd_link-vmlinux =                                                 \
> > > > -       $(CONFIG_SHELL) $< $(LD) $(KBUILD_LDFLAGS) $(LDFLAGS_vmlinux) ;    \
> > > > +       $(BASH) $< $(LD) $(KBUILD_LDFLAGS) $(LDFLAGS_vmlinux) ;    \
> > > >         $(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) $@, true)
> > > >
> > > >  vmlinux: scripts/link-vmlinux.sh autoksyms_recursive $(vmlinux-deps) FORCE
> > > > @@ -1403,7 +1403,7 @@ clean: rm-files := $(CLEAN_FILES)
> > > >  PHONY += archclean vmlinuxclean
> > > >
> > > >  vmlinuxclean:
> > > > -       $(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
> > > > +       $(Q)$(BASH) $(srctree)/scripts/link-vmlinux.sh clean
> > > >         $(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
> > > >
> > > >  clean: archclean vmlinuxclean
> > > > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > > > index f7edb75f9806..ea1f8673869d 100755
> > > > --- a/scripts/link-vmlinux.sh
> > > > +++ b/scripts/link-vmlinux.sh
> > > > @@ -1,4 +1,4 @@
> > > > -#!/bin/sh
> > > > +#!/bin/bash
> > > >  # SPDX-License-Identifier: GPL-2.0
> > > >  #
> > > >  # link vmlinux
> > > > --
> > > > 2.23.0.rc1
> > > >
> > > > --
> > > > Cheers,
> > > > Stephen Rothwell
> > >
> > >
> > >
> > > --
> > > Best Regards
> > > Masahiro Yamada
>
>
>
> --
> Best Regards
> Masahiro Yamada
