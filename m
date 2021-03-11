Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66EE5337AC2
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 18:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhCKRZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 12:25:51 -0500
Received: from conssluserg-06.nifty.com ([210.131.2.91]:20558 "EHLO
        conssluserg-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhCKRZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 12:25:44 -0500
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id 12BHPUIR024578;
        Fri, 12 Mar 2021 02:25:31 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com 12BHPUIR024578
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1615483531;
        bh=PXJt6D8qnKY8szVqGBkNLxIg6+eK0InYeixeUSx4Lhs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Qb4NHPOdreQxZNopchu3iYo/9GCNDjinFt5dgXgg7/NB9pUl5M32rRvqbInAxN9Ec
         8RVARmmJ8RCOCDfV+DCPa8VFdntwzEDh2mJ3SicXe1F3Xiu3DUOTbhqLUb1B/H0SK+
         fGNb7CiPQtjZ6n+NCbBDBpadYu+LBbGz/MB5pG67+F8JaWY9LC7Z9U4QX2w+QrMemP
         XqPtWbxM96G/FK5zFVCqGSe4eeey81GfS/sSKIAeuNwOuBX8qIPCM+zyiq+vfORO0A
         VNKcYJGkmxwnb7nKeQFsKmBV+bNlsAOahEwri2PtUf6YBmkq3jfdIsOP1JSEJ61uxn
         diVOHH2nZw5/Q==
X-Nifty-SrcIP: [209.85.216.51]
Received: by mail-pj1-f51.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so9413076pjc.2;
        Thu, 11 Mar 2021 09:25:31 -0800 (PST)
X-Gm-Message-State: AOAM532FnJM5d+t3pXEVYwsEglymDgs2Y+moFP1qSHMePAgNC8zPJNLn
        XwKJfuoXyluJ6tx4girlgO9pUi7B7fnptwvrYvU=
X-Google-Smtp-Source: ABdhPJxPcnVso4Em3gdaU2xvNMRrfF43T4ctrqiyqNN0sGobXOGU9+yOVbhG2axf6IP41vq7Mu+axhdDnGBjOdY7abI=
X-Received: by 2002:a17:90a:3b0e:: with SMTP id d14mr10135971pjc.198.1615483530413;
 Thu, 11 Mar 2021 09:25:30 -0800 (PST)
MIME-Version: 1.0
References: <a1a749e7-48be-d0ab-8fb5-914daf512ae9@web.de> <YEpEuoRGh0KoWoGa@lunn.ch>
In-Reply-To: <YEpEuoRGh0KoWoGa@lunn.ch>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Fri, 12 Mar 2021 02:24:52 +0900
X-Gmail-Original-Message-ID: <CAK7LNASPRUdvy8go5Cn6C+8j2O5AGJje1h-uKiTCFyVOmZwcUw@mail.gmail.com>
Message-ID: <CAK7LNASPRUdvy8go5Cn6C+8j2O5AGJje1h-uKiTCFyVOmZwcUw@mail.gmail.com>
Subject: Re: of_mdio: Checking build dependencies
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Markus Elfring <Markus.Elfring@web.de>,
        stable <stable@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 1:26 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Mar 10, 2021 at 09:31:07PM +0100, Markus Elfring wrote:
> > Hello,
> >
> > I would like to build the Linux version =E2=80=9C5.11.5=E2=80=9D for my=
 needs.
> > But I stumbled on the following information.
> >
> > =E2=80=A6
> >   AR      drivers/built-in.a
> >   LD [M]  drivers/visorbus/visorbus.o
> >   GEN     .version
> >   CHK     include/generated/compile.h
> > error: the following would cause module name conflict:
> >   drivers/net/mdio/of_mdio.ko
> >   drivers/of/of_mdio.ko
>
> Hi Markus
>
> Something wrong here. There should not be any of_mdio.ko in
> drivers/of. That was the whole point of the patch you referenced, it
> moved this file to drivers/net/mdio/. Please check where your
> drivers/of/of_mdio.ko comes from. Has there been a bad merge conflict
> resolution? Or is it left over from an older build?
>
>    Andrew


modules.order may include both
drivers/of/of_mdio.ko  and
drivers/net/mdio/of_mdio.c

But, I do not know how this could happen.

I checked out 14b26b127c098bba^,
and built modules with CONFIG_OF_MDIO=3Dm.
Then, I checked out 14b26b127c098bba
and rebuilt.

I did not see such an error.

I also checked the Kbuild code,
and it looks good too.

Please let me know if you find steps
to reproduce it.

--
Best Regards
Masahiro Yamada
