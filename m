Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3962F1FE1
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391189AbhAKTw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:52:27 -0500
Received: from conssluserg-01.nifty.com ([210.131.2.80]:45956 "EHLO
        conssluserg-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389589AbhAKTw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:52:26 -0500
X-Greylist: delayed 1890 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jan 2021 14:52:24 EST
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id 10BJpRbo021925;
        Tue, 12 Jan 2021 04:51:27 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com 10BJpRbo021925
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1610394688;
        bh=ItG6RXKqICsvoOxHCqOhjokCnPBLYEL/fl3sMptIQxM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aZnGLDoeg10Xj/lLkkvubtnDMFXBOWqn+G9q0gCgMr7x3jwwQ6yAYFFuyBFrpCtQ0
         QiyvcPiFxHh+d91md3EaCE1ank3G2zqG7k1DeEvcuuP0Dqx0xLjd1U9XErzPQ3SrX2
         Fg73drapC6OgIFkLUcaMqGsQIfi4eLv+mJFNTpeRyDrwqWbkWlilncrncxL4Y/BRRP
         fyVO2J90yy0le6YbNdZfrk0Cvy7n2mQ1vcNygTft2ru3jhM4ofwj7pbs2WoPyifajL
         CrlBEojNwZb179L62f9KIz9d+h9K8RE2GNpKB/7FYiVgv5xUIoT1pQHclzhSaxCEx9
         QFpYUTjzv/ZPQ==
X-Nifty-SrcIP: [209.85.215.169]
Received: by mail-pg1-f169.google.com with SMTP id n25so371004pgb.0;
        Mon, 11 Jan 2021 11:51:27 -0800 (PST)
X-Gm-Message-State: AOAM531EqcIsRFyQl8FHOHQS8gGOEo73oc+CZiKl9xYlG6HwWV9Pag7d
        TcZ6dNI6g3UWIUfM8XxD1z6Ikg7XGQSSBEsHVTo=
X-Google-Smtp-Source: ABdhPJwiWmifGckt7py++NZBF3MlPvLFNx7xeFXySdQrm+pbBznt0vx0PAl1WQLBSrjANOHybx/pbWbQ2rAQPltB7uQ=
X-Received: by 2002:a63:eb0c:: with SMTP id t12mr1117953pgh.7.1610394686894;
 Mon, 11 Jan 2021 11:51:26 -0800 (PST)
MIME-Version: 1.0
References: <20210111180609.713998-1-natechancellor@gmail.com>
 <CAK7LNAQ=38BUi-EG5v2UiuAF-BOsVe5BTd-=jVYHHHPD7ikS5A@mail.gmail.com> <20210111193400.GA1343746@ubuntu-m3-large-x86>
In-Reply-To: <20210111193400.GA1343746@ubuntu-m3-large-x86>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue, 12 Jan 2021 04:50:50 +0900
X-Gmail-Original-Message-ID: <CAK7LNASZuWp=aPOCKo6QkdHwM5KG6MUv8305v3x-2yR7cKEX-w@mail.gmail.com>
Message-ID: <CAK7LNASZuWp=aPOCKo6QkdHwM5KG6MUv8305v3x-2yR7cKEX-w@mail.gmail.com>
Subject: Re: [PATCH] bpf: Hoise pahole version checks into Kconfig
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Michal Marek <michal.lkml@markovi.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 4:34 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Tue, Jan 12, 2021 at 04:19:01AM +0900, Masahiro Yamada wrote:
> > On Tue, Jan 12, 2021 at 3:06 AM Nathan Chancellor
> > <natechancellor@gmail.com> wrote:
> > >
> > > After commit da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for
> > > vmlinux BTF"), having CONFIG_DEBUG_INFO_BTF enabled but lacking a valid
> > > copy of pahole results in a kernel that will fully compile but fail to
> > > link. The user then has to either install pahole or disable
> > > CONFIG_DEBUG_INFO_BTF and rebuild the kernel but only after their build
> > > has failed, which could have been a significant amount of time depending
> > > on the hardware.
> > >
> > > Avoid a poor user experience and require pahole to be installed with an
> > > appropriate version to select and use CONFIG_DEBUG_INFO_BTF, which is
> > > standard for options that require a specific tools version.
> > >
> > > Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> >
> >
> >
> > I am not sure if this is the right direction.
> >
> >
> > I used to believe moving any tool test to the Kconfig
> > was the right thing to do.
> >
> > For example, I tried to move the libelf test to Kconfig,
> > and make STACK_VALIDATION depend on it.
> >
> > https://patchwork.kernel.org/project/linux-kbuild/patch/1531186516-15764-1-git-send-email-yamada.masahiro@socionext.com/
> >
> > It was rejected.
> >
> >
> > In my understanding, it is good to test target toolchains
> > in Kconfig (e.g. cc-option, ld-option, etc).
> >
> > As for host tools, in contrast, it is better to _intentionally_
> > break the build in order to let users know that something needed is missing.
> > Then, they will install necessary tools or libraries.
> > It is just a one-time setup, in most cases,
> > just running 'apt install' or 'dnf install'.
> >
> >
> >
> > Recently, a similar thing happened to GCC_PLUGINS
> > https://patchwork.kernel.org/project/linux-kbuild/patch/20201203125700.161354-1-masahiroy@kernel.org/#23855673
> >
> >
> >
> >
> > Following this pattern, if a new pahole is not installed,
> > it might be better to break the build instead of hiding
> > the CONFIG option.
> >
> > In my case, it is just a matter of 'apt install pahole'.
> > On some distributions, the bundled pahole is not new enough,
> > and people may end up with building pahole from the source code.
>
> This is fair enough. However, I think that parts of this patch could
> still be salvaged into something that fits this by making it so that if
> pahole is not installed (CONFIG_PAHOLE_VERSION=0) or too old, the build
> errors at the beginning, rather at the end. I am not sure where the best
> place to put that check would be though.

Me neither.


Collecting tool checks to the beginning would be user-friendly.
However, scattering the related code to multiple places is not
nice from the developer point of view.

How big is it a problem if the build fails
at the very last stage?

You can install pahole, then resume "make".

Kbuild skips unneeded building, then you will
be able to come back to the last build stage shortly.



-- 
Best Regards
Masahiro Yamada
