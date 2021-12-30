Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89204820C3
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 23:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240813AbhL3W7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 17:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhL3W7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 17:59:33 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFE3C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 14:59:33 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id s4so24739330ljd.5
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 14:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qJ0EHazswwBJELorD1yecJcj5p8xLmi/2jyxcA1GP9U=;
        b=Dhfr7StuPNwa2sjpeEydXwjSq6gbZQN2zV+iS9Vy0xrU89yX3RFUYAhiU30bsezAds
         ddJ0UNkXia12DqWbJqlxPcXOvXVbei6HZPr37ljQDFPigoRQ8RGnU/EhiO6nPgfOvkCJ
         gDlMNdm6R9B6AkO+1piOtSI/C1P0lNe/ZT/bs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qJ0EHazswwBJELorD1yecJcj5p8xLmi/2jyxcA1GP9U=;
        b=MGxTr1gpe47Or3Q15yCXL5botzoS5hMhBioSzN+qlIRi/kAfz46gQvn0drXl6ptFjI
         lXaLv4d+E2t/XwnhUprakXvIqxZx6NOcmQ2yEsf4cmAFNZlYAPHF9Okrs06TLli/YuZX
         nvJ5eFXAAu80UxPDO9iTjLY5bImU3ZiGk9ydzsXrEbZrJEMKXL/tR0gT8UGVF3aim2ai
         R+0d7NA3KBR1GYvSGlrsJyOvD0Iabp0kA/ECOQcZzs/3iCK6MOA2qBiQkUbWlXLkbVRi
         qGya9CdIgWxbj7QxGbjOBWxb7db8bt98FQkvF+PbpIpY7NFvmwtnuyZykuu4DXPYReru
         BdAg==
X-Gm-Message-State: AOAM532kN6cg/qgYXkh3t61zCxNFBO3Baqnvjm87gEyeIM9bp6lVB6zJ
        ap0o7wuCWyl0+ELbt6iu2qDQY7FN+b++XcekSbiLVGFobQmx+w==
X-Google-Smtp-Source: ABdhPJx7/+GRhGcJ94wPZbgZYOvyIB1i+NBOLWA6xskO05vvXU5tt/8QDRemur9L3iNUr7KFJ4UCxm26v2NP07LI8R4=
X-Received: by 2002:a2e:9cd8:: with SMTP id g24mr4567195ljj.509.1640905171445;
 Thu, 30 Dec 2021 14:59:31 -0800 (PST)
MIME-Version: 1.0
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-9-dmichail@fungible.com> <20211230094327.69429188@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAOkoqZ=18H6CAE8scCV7DWzu9sQDLJHUiVgZi3tmutUNPPE2=A@mail.gmail.com> <Yc4yYWWHb4o+W3Zu@lunn.ch>
In-Reply-To: <Yc4yYWWHb4o+W3Zu@lunn.ch>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 30 Dec 2021 14:59:17 -0800
Message-ID: <CAOkoqZ=PJ8iT=umsizmoRVy8ErRt+wD-5R+tp78an8GCcY+Qjg@mail.gmail.com>
Subject: Re: [PATCH net-next 8/8] net/fungible: Kconfig, Makefiles, and MAINTAINERS
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 2:27 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Dec 30, 2021 at 12:54:07PM -0800, Dimitris Michailidis wrote:
> > On Thu, Dec 30, 2021 at 9:43 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Thu, 30 Dec 2021 08:39:09 -0800 Dimitris Michailidis wrote:
> > > > Hook up the new driver to configuration and build.
> > > >
> > > > Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
> > >
> > > New drivers must build cleanly with W=1 C=1. This one doesn't build at all:
> > >
> > > drivers/net/ethernet/fungible/funeth/funeth.h:10:10: fatal error: fun_dev.h: No such file or directory
> > >    10 | #include "fun_dev.h"
> > >       |          ^~~~~~~~~~~
> >
> > Hmm, I don't get this error. What I run is
> >
> > make W=1 C=1 drivers/net/ethernet/fungible/
>
> C=1 implies you need sparse installed. Do you?

I have sparse. Here's an example of what W=1 C=1 V=1 says is running:

  sparse -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise
-Wno-return-void -Wno-unknown-attribute  -D__x86_64__ --arch=x86
-mlittle-endian -m64
-Wp,-MMD,drivers/net/ethernet/fungible/funcore/.fun_dev.o.d  -nostdinc
-I./arch/x86/include -I./arch/x86/include/generated  -I./include
-I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi
-I./include/uapi -I./include/generated/uapi -include
./include/linux/compiler-version.h -include ./include/linux/kconfig.h
-include ./include/linux/compiler_types.h -D__KERNEL__
-fmacro-prefix-map=./= -DKBUILD_EXTRA_WARN1 -Wall -Wundef
-Werror=strict-prototypes -Wno-trigraphs -fno-strict-aliasing
-fno-common -fshort-wchar -fno-PIE
-Werror=implicit-function-declaration -Werror=implicit-int
-Werror=return-type -Wno-format-security -std=gnu89 -mno-sse -mno-mmx
-mno-sse2 -mno-3dnow -mno-avx -fcf-protection=none -m64
-falign-jumps=1 -falign-loops=1 -mno-80387 -mno-fp-ret-in-387
-mpreferred-stack-boundary=3 -mskip-rax-setup -mtune=generic
-mno-red-zone -mcmodel=kernel -DCONFIG_X86_X32_ABI -Wno-sign-compare
-fno-asynchronous-unwind-tables -mindirect-branch=thunk-extern
-mindirect-branch-register -fno-jump-tables
-fno-delete-null-pointer-checks -Wno-frame-address
-Wno-format-truncation -Wno-format-overflow
-Wno-address-of-packed-member -O2 --param=allow-store-data-races=0
-Wframe-larger-than=1024 -fstack-protector-strong
-Wimplicit-fallthrough=5 -Wno-main -Wno-unused-but-set-variable
-Wno-unused-const-variable -fno-omit-frame-pointer
-fno-optimize-sibling-calls -fno-stack-clash-protection -pg
-mrecord-mcount -mfentry -DCC_USING_FENTRY
-Wdeclaration-after-statement -Wvla -Wno-pointer-sign
-Wno-stringop-truncation -Wno-array-bounds -Wno-stringop-overflow
-Wno-restrict -Wno-maybe-uninitialized -Wno-alloc-size-larger-than
-fno-strict-overflow -fno-stack-check -fconserve-stack
-Werror=date-time -Werror=incompatible-pointer-types
-Werror=designated-init -Wno-packed-not-aligned -Wextra -Wunused
-Wno-unused-parameter -Wmissing-declarations
-Wmissing-format-attribute -Wmissing-prototypes -Wold-style-definition
-Wmissing-include-dirs -Wunused-but-set-variable
-Wunused-const-variable -Wpacked-not-aligned -Wstringop-truncation
-Wno-missing-field-initializers -Wno-sign-compare -Wno-type-limits -g
-gdwarf-4  -DMODULE  -DKBUILD_BASENAME='"fun_dev"'
-DKBUILD_MODNAME='"funcore"' -D__KBUILD_MODNAME=kmod_funcore
drivers/net/ethernet/fungible/funcore/fun_dev.c

$ sparse --version
v0.6.4

>
>     Andrew
