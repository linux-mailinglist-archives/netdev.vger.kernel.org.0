Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45FF1CC4CB
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 23:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgEIVtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 17:49:17 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:49251 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgEIVtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 17:49:15 -0400
Received: from mail-qt1-f180.google.com ([209.85.160.180]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1Macf4-1j08bD1jis-00cBwH; Sat, 09 May 2020 23:49:13 +0200
Received: by mail-qt1-f180.google.com with SMTP id q13so4745917qtp.7;
        Sat, 09 May 2020 14:49:13 -0700 (PDT)
X-Gm-Message-State: AGi0PuZKh68dXUO5pGwXcBP2j079saIP8wb7HdodKJMAPDgKGfOKZafU
        K68tdVwvhVsNVbybM1EnUohJUsZTqx2K7e2EbM0=
X-Google-Smtp-Source: APiQypLpfX4ahqZVPOUpDwBjl1/Gele77d9P59gkG2JtFwvCb51akS0JDBPZXr0gFygmEktloo+7LqloTf/v/1srlSs=
X-Received: by 2002:ac8:490a:: with SMTP id e10mr7462932qtq.7.1589060952182;
 Sat, 09 May 2020 14:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200509120505.109218-1-arnd@arndb.de> <20200509132427.3d2979d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200509132427.3d2979d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 9 May 2020 23:48:55 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0figw8FHGp2KqW6XdfbWLu_ZXp3hyuPVoPwpum6XeJ_Q@mail.gmail.com>
Message-ID: <CAK8P3a0figw8FHGp2KqW6XdfbWLu_ZXp3hyuPVoPwpum6XeJ_Q@mail.gmail.com>
Subject: Re: [PATCH] net: freescale: select CONFIG_FIXED_PHY where needed
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Timur Tabi <timur@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:lWqosjHwW39E5UlbmDdQ2FRdaXX7VsnMw8pzzqLD8023eMm7XD9
 8WjQ1xC/Z+eRndDjPga6Stey1rp/I8NE3Rn1Eoju1R+5waqUdwMJYZGmMht4O8s0gUMKIAg
 zFrGLkFaMP0wMmtHA3vjYnxsyGkTFTmXyt2WdUouRH1L1KFvEKmwPv68b7NOTBu0/HlszDK
 XQH5jTdIYwiM07JW4RzGQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:r7C04jp4pcI=:OYW7MXS2Ftn52dWmyfW4cd
 3R24wBJ9Gq5k1Tlcu/NfPq7PEmca13BHrEsQlrhsgJVldaw9lzxtzdaQr6AeVcWieLs1ZrE1A
 0etMNdbvvN1/vVKXBYvRdkY0llRWP0XqPG7whWWe7+756GkPpOZoA4628DIazmNNDMqUshiRx
 o1IBrKUkHUScfL4i5jpIls3BvMDAl/skVwVAh49GUgHq7lXAXclysFvGaEP2CmdyEvg1frLYG
 aPJQj/RxVhVkM6XRDbJiRpOuIdFyoSXbTFtSRoFfaQUsStSvZ5v2ZmXfCfS/4ioQS8vKnpNyP
 coQGyMtTgj/ZsKEQ4MbAwS73pUrNQBQBv3vwSsW1GdJKrH88J7cjajac0MYDM3Z4Mn7jqcxKu
 RlXhCp+l4bPUJc9gbCI4SFPl4e9uaJ31blhB3AQ0bzlwYd3kiz1HDqjbRhG8JH7tlKn+XB/tu
 GQU0Y8Svt8r39wAqvU/uTOM7lVGwZ+yE/mRyghkh8ZhUkUSS8nCGQPTzOfhkJ57GL4GCIQoHV
 BmL1RtbkmuBeUvfUWgmGzoEyVvFsl+UCQkkgtQZ+GgY2K6/3XUCz75L7R2aEfaDkLIctzTgcb
 +YS8a2MnCCCKptDeZif2W/4zALBmGyNJo/iWlbWxkoF5itGCNMX4UJdZNKxVG6A5gj4p90y6+
 D6NQwYD7A2xJwlj8JsTAXMaBUSmstiNHi1158tdY/6Di7uy76B+PDt4Eqwc5yq0I8wVv3S43M
 MbUJYWcyqapAQjKGi/64oLd/j+8qeRWZgCs9sM9svohGadZzPd5j+O45bEZR1MIZBfDxYRxg0
 zBdw6Vr/taNL+OQI57UqiXazwWQ6ZxLp0+hwKtsvX1vv9m9Hyo=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 9, 2020 at 10:24 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat,  9 May 2020 14:04:52 +0200 Arnd Bergmann wrote:
> > I ran into a randconfig build failure with CONFIG_FIXED_PHY=m
> > and CONFIG_GIANFAR=y:
> >
> > x86_64-linux-ld: drivers/net/ethernet/freescale/gianfar.o:(.rodata+0x418): undefined reference to `fixed_phy_change_carrier'
> >
> > It seems the same thing can happen with dpaa and ucc_geth, so change
> > all three to do an explicit 'select FIXED_PHY'.
> >
> > The fixed-phy driver actually has an alternative stub function that
> > theoretically allows building network drivers when fixed-phy is
> > disabled, but I don't see how that would help here, as the drivers
> > presumably would not work then.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> > +     select FIXED_PHY
>
> I think FIXED_PHY needs to be optional, depends on what the board has
> connected to the MAC it may not be needed, right PHY folks? We probably
> need the
>
>     depends on FIXED_PHY || !FIXED_PHY

Unfortunately that does not work because it causes a circular dependency:

drivers/net/phy/Kconfig:415:error: recursive dependency detected!
drivers/net/phy/Kconfig:415: symbol FIXED_PHY depends on PHYLIB
drivers/net/phy/Kconfig:250: symbol PHYLIB is selected by FSL_PQ_MDIO
drivers/net/ethernet/freescale/Kconfig:60: symbol FSL_PQ_MDIO is
selected by UCC_GETH
drivers/net/ethernet/freescale/Kconfig:75: symbol UCC_GETH depends on FIXED_PHY

I now checked what other drivers use the fixed-phy interface, and found
that all others do select FIXED_PHY except for these three, and they
are also the only ones using fixed_phy_change_carrier().

The fixed-phy driver is fairly small, so it probably won't harm too much
to use the select, but maybe I missed another option.

        Arnd
