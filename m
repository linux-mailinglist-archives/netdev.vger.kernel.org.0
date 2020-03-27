Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74FB8195741
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 13:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbgC0Mk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 08:40:27 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33562 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgC0Mk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 08:40:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VHTZ48c5gjThBk1eiRrFIzohciBF7kA3crWky1H4U3M=; b=kJRXQ18XeeyTv/qyEIBjDj46d
        Aje7W0Lhjs42MoJN3VEs3MoNadoIdiZZAcf+4KV1UGFKTWrq5RrL7FAkpJMPrgNhQ63MLIi+A2UzH
        9+qgleFguHbZsXtCrx25vRe6AQUsRsq66pE+tVjPVyY8Dxxnk1PrfRTbKwE6b76hBfyMxsftG6+dT
        VIrk79xbt4DEJEq7IN81x/spNjEUhKRtA1ktKPZU6QteberrcNkI6jKs66g94zsmGA6kxgWoGIyXN
        DLJc1FlOuKF0Sey3m01bNyTel4p7PLToU1Z5awodVTJmX9SdCmlJsO5uJk6VIB4CrFvJ3qSInO21b
        g1TUUAYjQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:37898)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jHoHT-00013s-IW; Fri, 27 Mar 2020 12:40:16 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jHoHP-0004E8-JH; Fri, 27 Mar 2020 12:40:07 +0000
Date:   Fri, 27 Mar 2020 12:40:07 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florinel Iordache <florinel.iordache@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/9] net: phy: add kr phy connection type
Message-ID: <20200327124007.GJ25745@shell.armlinux.org.uk>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-4-git-send-email-florinel.iordache@nxp.com>
 <20200327001515.GL3819@lunn.ch>
 <20200327120151.GG25745@shell.armlinux.org.uk>
 <AM0PR04MB6980E904C03F164E6A1D2267ECCC0@AM0PR04MB6980.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB6980E904C03F164E6A1D2267ECCC0@AM0PR04MB6980.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 12:12:37PM +0000, Madalin Bucur (OSS) wrote:
> > -----Original Message-----
> > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> > Behalf Of Russell King - ARM Linux admin
> > Sent: Friday, March 27, 2020 2:02 PM
> > To: Andrew Lunn <andrew@lunn.ch>
> > Cc: Florinel Iordache <florinel.iordache@nxp.com>; davem@davemloft.net;
> > netdev@vger.kernel.org; f.fainelli@gmail.com; hkallweit1@gmail.com;
> > devicetree@vger.kernel.org; linux-doc@vger.kernel.org; robh+dt@kernel.org;
> > mark.rutland@arm.com; kuba@kernel.org; corbet@lwn.net;
> > shawnguo@kernel.org; Leo Li <leoyang.li@nxp.com>; Madalin Bucur (OSS)
> > <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH net-next 3/9] net: phy: add kr phy connection type
> > 
> > On Fri, Mar 27, 2020 at 01:15:15AM +0100, Andrew Lunn wrote:
> > > On Thu, Mar 26, 2020 at 03:51:16PM +0200, Florinel Iordache wrote:
> > > > Add support for backplane kr phy connection types currently available
> > > > (10gbase-kr, 40gbase-kr4) and the required phylink updates (cover all
> > > > the cases for KR modes which are clause 45 compatible to correctly
> > assign
> > > > phy_interface and phylink#supported)
> > > >
> > > > Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
> > > > ---
> > > >  drivers/net/phy/phylink.c | 15 ++++++++++++---
> > > >  include/linux/phy.h       |  6 +++++-
> > > >  2 files changed, 17 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > > > index fed0c59..db1bb87 100644
> > > > --- a/drivers/net/phy/phylink.c
> > > > +++ b/drivers/net/phy/phylink.c
> > > > @@ -4,6 +4,7 @@
> > > >   * technologies such as SFP cages where the PHY is hot-pluggable.
> > > >   *
> > > >   * Copyright (C) 2015 Russell King
> > > > + * Copyright 2020 NXP
> > > >   */
> > > >  #include <linux/ethtool.h>
> > > >  #include <linux/export.h>
> > > > @@ -303,7 +304,6 @@ static int phylink_parse_mode(struct phylink *pl,
> > struct fwnode_handle *fwnode)
> > > >  			break;
> > > >
> > > >  		case PHY_INTERFACE_MODE_USXGMII:
> > > > -		case PHY_INTERFACE_MODE_10GKR:
> > >
> > > We might have a backwards compatibility issue here. If i remember
> > > correctly, there are some boards out in the wild using
> > > PHY_INTERFACE_MODE_10GKR not PHY_INTERFACE_MODE_10GBASER.
> > >
> > > See e0f909bc3a242296da9ccff78277f26d4883a79d
> > >
> > > Russell, what do you say about this?
> > 
> > Yes, and that's a point that I made when I introduced 10GBASER to
> > correct that mistake.  It is way too soon to change this; it will
> > definitely cause regressions:
> > 
> > $ grep 10gbase-kr arch/*/boot/dts -r
> > arch/arm64/boot/dts/marvell/cn9131-db.dts:      phy-mode = "10gbase-kr";
> > arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts:      phy-mode =
> > "10gbase-kr";
> > arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts:      phy-mode =
> > "10gbase-kr";
> > arch/arm64/boot/dts/marvell/armada-7040-db.dts:    phy-mode = "10gbase-
> > kr";
> > arch/arm64/boot/dts/marvell/armada-8040-mcbin-singleshot.dts:   phy-mode =
> > "10gbase-kr";
> > arch/arm64/boot/dts/marvell/armada-8040-mcbin-singleshot.dts:   phy-mode =
> > "10gbase-kr";
> > arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts:     phy-mode =
> > "10gbase-kr";
> > arch/arm64/boot/dts/marvell/armada-8040-db.dts: phy-mode = "10gbase-kr";
> > arch/arm64/boot/dts/marvell/armada-8040-db.dts: phy-mode = "10gbase-kr";
> > arch/arm64/boot/dts/marvell/cn9132-db.dts:      phy-mode = "10gbase-kr";
> > arch/arm64/boot/dts/marvell/cn9130-db.dts:      phy-mode = "10gbase-kr";
> > 
> > So any change to the existing PHY_INTERFACE_MODE_10GKR will likely
> > break all these platforms.
> 
> Hi Russell,
> 
> I hoped a fix for those would be in by now, it's not useful to leave them like
> that.

I haven't had the time to address the ones I know about, sorry.
However, there are some platforms in that list which I've no
knowledge of, which I therefore can't change.

> We have a similar situation, where all boards using XFI interfaces contain
> phy-connection-type="xgmii" for a long time now but that did not stop anyone from
> adding a warning in the Aquantia driver:
> 
> +       WARN(phydev->interface == PHY_INTERFACE_MODE_XGMII,
> +            "Your devicetree is out of date, please update it. The AQR107 family doesn't support XGMII, maybe you mean USXGMII.\n");
> +
> 
> Maybe we need a warning added here too, until the proper phy-mode is used for
> these boards, to allow for a transition period.

Adding a warning can only be done once the current users have been
updated, otherwise it's technically introducing a regression.  Plus
some users may actually be correct.  I never did get to the bottom
of that, because that required discussion and no one seems willing
to discuss it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
