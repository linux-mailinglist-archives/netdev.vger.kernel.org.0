Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F2538893B
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 10:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244646AbhESITn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 04:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240732AbhESITe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 04:19:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5242F6109F;
        Wed, 19 May 2021 08:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621412295;
        bh=dsuOfWqUpLG6TYxzvoXLt4qolVX3EH9WyyCF/m4rDZ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EQbXTObvr4x6HAPKQDoLEy0KFrcDnhjLY8AEw8oTzi3gN4Vs+VRCV6AFyeQelvllV
         g7FQDiVNV1aMFbB08/om6u+SFsGATw4xd/E1IWj1nNP+7QGnmMQgTHDP73a6MZlPKN
         4CTNyy7iJg7hyfZyaQndlExHDjKrESngZQANz877ewTF7cdWmkF1JW65LPxXHlyIXm
         WBoHjxPDxIcwRxjKNYCRY/8IugEb3NXKLKm3xOlDRzfYqpZq3mpp3M7cCrukUEuptw
         ytvniQq3569YdALX5OqkbaPBiGm/NzWJ+flxWSvvhZAlp33KfgP/EaRsznquTe/hfD
         dJQo2kLayKxmQ==
Date:   Wed, 19 May 2021 11:18:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Subject: Re: [PATCH] net: phy: add driver for Motorcomm yt8511 phy
Message-ID: <YKTJwscaV1WaK98z@unreal>
References: <20210511214605.2937099-1-pgwipeout@gmail.com>
 <YKOB7y/9IptUvo4k@unreal>
 <CAMdYzYrV0T9H1soxSVpQv=jLCR9k9tuJddo1Kw-c3O5GJvg92A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMdYzYrV0T9H1soxSVpQv=jLCR9k9tuJddo1Kw-c3O5GJvg92A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 18, 2021 at 08:20:03PM -0400, Peter Geis wrote:
> On Tue, May 18, 2021 at 4:59 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Tue, May 11, 2021 at 05:46:06PM -0400, Peter Geis wrote:
> > > Add a driver for the Motorcomm yt8511 phy that will be used in the
> > > production Pine64 rk3566-quartz64 development board.
> > > It supports gigabit transfer speeds, rgmii, and 125mhz clk output.
> > >
> > > Signed-off-by: Peter Geis <pgwipeout@gmail.com>
> > > ---
> > >  MAINTAINERS                 |  6 +++
> > >  drivers/net/phy/Kconfig     |  6 +++
> > >  drivers/net/phy/Makefile    |  1 +
> > >  drivers/net/phy/motorcomm.c | 85 +++++++++++++++++++++++++++++++++++++
> > >  4 files changed, 98 insertions(+)
> > >  create mode 100644 drivers/net/phy/motorcomm.c
> >
> > <...>
> >
> > > +static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
> > > +     { PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
> > > +     { /* sentinal */ }
> > > +}
> >
> > Why is this "__maybe_unused"? This *.c file doesn't have any compilation option
> > to compile part of it.
> >
> > The "__maybe_unused" is not needed in this case.
> 
> I was simply following convention, for example the realtek.c,
> micrel.c, and smsc.c drivers all have this as well.

Maybe they have a reason, but this specific driver doesn't have such.

Thanks

> 
> >
> > Thanks
