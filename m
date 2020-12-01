Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8455F2CAF14
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 22:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388655AbgLAVpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 16:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728578AbgLAVpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:45:38 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4BFC0613CF;
        Tue,  1 Dec 2020 13:44:58 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id r127so3247069yba.10;
        Tue, 01 Dec 2020 13:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=66WFLRYM+gxPz1HVwH+SHFDRnQbQ4PXo2x+GWB3+dUA=;
        b=RL2Be7DY4F/996q/8EjrOtzqG4C51dFd9AK1TYlgZKboYzlI8O5gCuB16cK59aAXvS
         5NCMT3wf9uvduy3KpWYAxFXxxIgEAZA7tTU4eg3bPcqfpYAAu9QCeAWpCfoRAdEXaAXV
         aX0slZlyparmDfsYMopZGRA2lD+mf0ruTdkaKw+60QC0EgrxuCoRDFMgQEGtnu41ZKuR
         qFjrNQPr8FAGYOygUpgbkmNlFz7Toyf3Gas1l6CVuimOXIOo58RXGYu1CpJt83ImJEd5
         cw6mTUibtjt9Qhy83TdxkXIELZqPyRi36dYh2tNm7HbkFI5O17698hYh8+gQ5Yi953NG
         Hz/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=66WFLRYM+gxPz1HVwH+SHFDRnQbQ4PXo2x+GWB3+dUA=;
        b=NRtlqGtACXxJ1sHeLlSvvebP3J1qer8zRrECO6OtYg9DyR7te3lqEmpS3QhrIEKep9
         E3VMbuzyYlClCQc5NwW5ILPmQ7hQ9lWG8l8iQ8wXieHlrpw6gJ1OmsPoSBw5sJ5Gzcms
         D7sepJVRwocS1a/Y9iPN6FQYoAYSUmIqowmEMtH8IoWRspTcMlL+2z0A1J3sy7zag0UI
         rtoDmZqNg9zITjr8yLssSiCWzgnXIXUuglChx3mrncCr5/S5vwc2o+838iHbGVDIuqR1
         FeQvv0UsuvZES14fADshgp0WXWoB3jt9VNOFzMCtl/MezVh7gaXNljfeLCQ8cuc2JxIh
         F8+A==
X-Gm-Message-State: AOAM532GsO6M5PX5P7PH/ADY7X48/D8ZUzkJLhtAiCd2sU+JRDiNArTp
        C9bxgmiF/92e4is735TeqmI8ivTBc0Sffd/Hz6U=
X-Google-Smtp-Source: ABdhPJyt9V8E2I5v8l5Xpc2g1LqZTdVRrjJh2M6EfL6fOiPgKfZxBPXdmB08OT/8D3WL91TQjzcmBbkt0NmNuh8bns4=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr5775567ybe.403.1606859098000;
 Tue, 01 Dec 2020 13:44:58 -0800 (PST)
MIME-Version: 1.0
References: <20201201143700.719828-1-leon@kernel.org> <CAEf4BzaSL+rmVYNipsfczsF2v684KOhZgFPtUG9opvk7d6zruA@mail.gmail.com>
 <20201201193243.GG3286@unreal>
In-Reply-To: <20201201193243.GG3286@unreal>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Dec 2020 13:44:46 -0800
Message-ID: <CAEf4Bzb-bepWW56jAAhnCh8yUHrzn-CEKTcbf1zLhAvtZktTqg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] kbuild: Restore ability to build out-of-tree modules
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Edward Srouji <edwards@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 1, 2020 at 11:32 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Tue, Dec 01, 2020 at 10:01:23AM -0800, Andrii Nakryiko wrote:
> > On Tue, Dec 1, 2020 at 6:37 AM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > The out-of-tree modules are built without vmlinux target and request
> > > to recompile that target unconditionally causes to the following
> > > compilation error.
> > >
> > > [root@server kernel]# make
> > > <..>
> > > make -f ./scripts/Makefile.modpost
> > > make -f ./scripts/Makefile.modfinal
> > > make[3]: *** No rule to make target 'vmlinux', needed by '/my_temp/out-of-tree-module/kernel/test.ko'.  Stop.
> > > make[2]: *** [scripts/Makefile.modpost:117: __modpost] Error 2
> > > make[1]: *** [Makefile:1703: modules] Error 2
> > > make[1]: Leaving directory '/usr/src/kernels/5.10.0-rc5_for_upstream_base_2020_11_29_11_34'
> > > make: *** [Makefile:80: modules] Error 2
> > >
> > > As a solution separate between build paths that has vmlinux target and paths without.
> > >
> > > Fixes: 5f9ae91f7c0d ("kbuild: Build kernel module BTFs if BTF is enabled and pahole supports it")
> > > Reported-by: Edward Srouji <edwards@nvidia.com>
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> >
> > e732b538f455 ("kbuild: Skip module BTF generation for out-of-tree
> > external modules") ([0]) was supposed to take care of this. Did you
> > try it?
>
> My tree doesn't have this patch yet, so my questions can be stupid:
> 1. Will it print "Skipping BTF generation for ... due to unavailability
> of vmlinux" line if my .config doesn't have "CONFIG_DEBUG_INFO_BTF_MODULES"?
> I hope it is not.

No, it shouldn't. cmd_btf_ko is only executed if
CONFIG_DEBUG_INFO_BTF_MODULES is set.

> 2. Reliance on existence of vmlinux can be problematic, no one promises
> us that "make clean" is called before and there are no other leftovers
> from previous builds.

In such a case, the worst thing that can happen would be that the
kernel module will get BTF that doesn't match actual vmlinux BTF, and
when attempted to load into the kernel BTF will be ignored (with a
warning). It's not ideal, but I don't know how else we can handle this
short of just not supporting BTF for out-of-tree modules, which a
bunch of folks would be disappointed about, I think. I'm open to
suggestions on how to do it better, though.


>
> And in general, the idea that such invasive change in build infrastructure
> came without any Ack from relevant maintainers doesn't look right to me.
>
> Thanks
>
> >
> >   [0] https://patchwork.kernel.org/project/netdevbpf/patch/20201121070829.2612884-1-andrii@kernel.org/
> >
> >
> > > Not proficient enough in Makefile, but it fixes the issue.
> > > ---
> > >  scripts/Makefile.modfinal | 5 +++++
> > >  scripts/Makefile.modpost  | 4 ++++
> > >  2 files changed, 9 insertions(+)
> > >
> > > diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
> > > index 02b892421f7a..8a7d0604e7d0 100644
> > > --- a/scripts/Makefile.modfinal
> > > +++ b/scripts/Makefile.modfinal
> > > @@ -48,9 +48,14 @@ if_changed_except = $(if $(call newer_prereqs_except,$(2))$(cmd-check),      \
> > >         $(cmd);                                                              \
> > >         printf '%s\n' 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd, @:)
> > >
> > > +ifdef MODPOST_VMLINUX
> > >  # Re-generate module BTFs if either module's .ko or vmlinux changed
> > >  $(modules): %.ko: %.o %.mod.o scripts/module.lds vmlinux FORCE
> > >         +$(call if_changed_except,ld_ko_o,vmlinux)
> > > +else
> > > +$(modules): %.ko: %.o %.mod.o scripts/module.lds FORCE
> > > +       +$(call if_changed_except,ld_ko_o)
> > > +endif
> > >  ifdef CONFIG_DEBUG_INFO_BTF_MODULES
> > >         +$(if $(newer-prereqs),$(call cmd,btf_ko))
> > >  endif
> > > diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> > > index f54b6ac37ac2..f5aa5b422ad7 100644
> > > --- a/scripts/Makefile.modpost
> > > +++ b/scripts/Makefile.modpost
> > > @@ -114,8 +114,12 @@ targets += $(output-symdump)
> > >
> > >  __modpost: $(output-symdump)
> > >  ifneq ($(KBUILD_MODPOST_NOFINAL),1)
> > > +ifdef MODPOST_VMLINUX
> > > +       $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modfinal MODPOST_VMLINUX=1
> > > +else
> > >         $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modfinal
> > >  endif
> > > +endif
> > >
> > >  PHONY += FORCE
> > >  FORCE:
> > > --
> > > 2.28.0
> > >
