Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 119EA126FFA
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfLSVth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:49:37 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40270 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfLSVth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:49:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AYRcRglwcP5lo6E4Zn08sq4uQ/tRp+N1/Lj/8ULBHuo=; b=sInF7qsmdiLReNyXRT7V8wbck
        MJKkGXTEe/cg36RETU4RMYa4IIiXV/MFte/uJgpwt+/vA+X9ToXVY7re2GLS8sUpa0mh7tl4bhTe0
        Zga6ZEfAByCt8xHuiIMDWUKlHfURgmr4zwn24e4jSxwKL8jWn1ko+H9ZRaDbBmUgwek7+VyjDmtE6
        WWhaN6XUfpZf6/GK74JMePirCJUOjx2pbZbRbV9V1wzIMQuXsWZ5WUeU01OhZaxJCxwYGztSTyALr
        nSfG1nWGJo0qjwpiwpmVUCw/YJXeoGyT5wzeSny3x1IEGNfN9zhB56fj1VTtW1yqJSowzJdueVRPm
        N2F+K+YuA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:43588)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ii3fo-0004xw-LX; Thu, 19 Dec 2019 21:49:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ii3fm-0005ha-Eo; Thu, 19 Dec 2019 21:49:30 +0000
Date:   Thu, 19 Dec 2019 21:49:30 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Message-ID: <20191219214930.GG25745@shell.armlinux.org.uk>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191219190308.GE25745@shell.armlinux.org.uk>
 <VI1PR04MB5567010C06EB9A4734431106EC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB5567010C06EB9A4734431106EC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 09:34:57PM +0000, Madalin Bucur (OSS) wrote:
> > -----Original Message-----
> > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Sent: Thursday, December 19, 2019 9:03 PM
> > To: Madalin Bucur <madalin.bucur@nxp.com>
> > Cc: davem@davemloft.net; netdev@vger.kernel.org; andrew@lunn.ch;
> > f.fainelli@gmail.com; hkallweit1@gmail.com; shawnguo@kernel.org;
> > devicetree@vger.kernel.org
> > Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
> > 
> > On Thu, Dec 19, 2019 at 06:32:51PM +0000, Madalin Bucur wrote:
> > > > -----Original Message-----
> > > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > > Sent: Thursday, December 19, 2019 7:29 PM
> > > > To: Madalin Bucur <madalin.bucur@nxp.com>
> > > > Cc: davem@davemloft.net; netdev@vger.kernel.org; andrew@lunn.ch;
> > > > f.fainelli@gmail.com; hkallweit1@gmail.com; shawnguo@kernel.org;
> > > > devicetree@vger.kernel.org
> > > > Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
> > > >
> > > > On Thu, Dec 19, 2019 at 05:21:16PM +0200, Madalin Bucur wrote:
> > > > > From: Madalin Bucur <madalin.bucur@nxp.com>
> > > > >
> > > > > Add explicit entries for XFI, SFI to make sure the device
> > > > > tree entries for phy-connection-type "xfi" or "sfi" are
> > > > > properly parsed and differentiated against the existing
> > > > > backplane 10GBASE-KR mode.
> > > >
> > > > 10GBASE-KR is actually used for XFI and SFI (due to a slight mistake
> > on
> > > > my part, it should've been just 10GBASE-R).
> > > >
> > > > Please explain exactly what the difference is between XFI, SFI and
> > > > 10GBASE-R. I have not been able to find definitive definitions for
> > > > XFI and SFI anywhere, and they appear to be precisely identical to
> > > > 10GBASE-R. It seems that it's just a terminology thing, with
> > > > different groups wanting to "own" what is essentially exactly the
> > > > same interface type.
> > >
> > > Hi Russell,
> > >
> > > 10GBase-R could be used as a common nominator but just as well 10G and
> > > remove the rest while we're at it. There are/may be differences in
> > > features, differences in the way the HW is configured (the most
> > > important aspect) and one should be able to determine what interface
> > > type is in use to properly configure the HW. SFI does not have the CDR
> > > function in the PMD, relying on the PMA signal conditioning vs the XFI
> > > that requires this in the PMD. We kept the xgmii compatible for so long
> > > without much issues until someone started cleaning up the PHY supported
> > > modes. Since we're doing that, let's be rigorous. The 10GBase-KR is
> > > important too, we have some backplane code in preparation and having it
> > > there could pave the way for a simpler integration.
> > 
> > The problem we currently have is:
> > 
> > $ grep '10gbase-kr' arch/*/boot/dts -r
> > 
> > virtually none of those are actually backplane. For the mcbin matches,
> > these are either to a 88x3310 PHY for the doubleshot, which dynamically
> > operates between XFI, 5GBASE-R, 2500BASE-X, or SGMII according to the
> > datasheet.
> 
> Yes, I've seen it's used already in several places:
> 
> $ grep PHY_INTERFACE_MODE_10GKR drivers/net -nr
> drivers/net/phy/marvell10g.c:219:       if (iface != PHY_INTERFACE_MODE_10GKR) {
> drivers/net/phy/marvell10g.c:307:           phydev->interface != PHY_INTERFACE_MODE_10GKR)
> drivers/net/phy/marvell10g.c:389:            phydev->interface == PHY_INTERFACE_MODE_10GKR) && phydev->link) {
> drivers/net/phy/marvell10g.c:398:                       phydev->interface = PHY_INTERFACE_MODE_10GKR;
> drivers/net/phy/phylink.c:296:          case PHY_INTERFACE_MODE_10GKR:
> drivers/net/phy/aquantia_main.c:361:            phydev->interface = PHY_INTERFACE_MODE_10GKR;
> drivers/net/phy/aquantia_main.c:499:        phydev->interface != PHY_INTERFACE_MODE_10GKR)
> drivers/net/phy/sfp-bus.c:340:          return PHY_INTERFACE_MODE_10GKR;
> drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:1117:   return interface == PHY_INTERFACE_MODE_10GKR ||
> drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:1203:   case PHY_INTERFACE_MODE_10GKR:
> drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:1652:   case PHY_INTERFACE_MODE_10GKR:
> drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:4761:   case PHY_INTERFACE_MODE_10GKR:
> drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:4783:   case PHY_INTERFACE_MODE_10GKR:
> 
> We should fix this, if it's incorrect.
> 
> > If we add something else, then the problem becomes what to do about
> > that lot - one of the problems is, it seems we're going to be breaking
> > DT compatibility by redefining 10gbase-kr to be correct.
> 
> We need the committer/maintainer to update that to a correct value.

The general principle is, we don't break existing DT - in that, we
expect DT files from current kernels to work with future kernels. So,
we're kind of stuck with "10gbase-kr" being used for this at least in
the medium term.

By all means introduce "xfi" and "sfi" if you think that there is a
need to discriminate between the two, but I've seen no hardware which
that treats them any differently from 10gbase-r.

If we want to support real 10gbase-kr, then I think we need to consider
how to do that without affecting compatibility with what we already
have.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
