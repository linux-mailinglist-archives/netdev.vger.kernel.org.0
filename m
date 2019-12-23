Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D31C9129327
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 09:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbfLWI1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 03:27:21 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37486 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfLWI1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 03:27:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rrga2Vig6Fp5zMT/ELJyNk5MJZmPGBRKBTXeByM7a+4=; b=vUj/wDxu0RrYtE8dCubT8zqyj
        niVOwtX468MF7FNTqR4L1BqNPYjbBEYU76makEiTrwe/aruWfNKk7dAkazijWlHt4lUuMgxuz7za4
        MF3sfK2NawCFIsHpP3OUifyQOvMSqhO+7A41+Xf7iT5CorHr21BPKoYP+qfCQZQ7imczVIWd5YfqQ
        UUinkq6BSEc/41p84pN4aJF5BvVygtd0o5BqfFJedK39QDKQS5KZyNvt5eihg3DsPVjVtdjbzWa1U
        ldjduJjqByROnr6sIwQ6/XQob/XzU4SATjd+l8ILyu0lXtkAe26m1dNoYjK0m0ipcdxZ8tMA4qnNH
        qJOlkehEg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56826)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ijJ3R-0000cN-Km; Mon, 23 Dec 2019 08:27:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ijJ3J-0000fC-UA; Mon, 23 Dec 2019 08:26:57 +0000
Date:   Mon, 23 Dec 2019 08:26:57 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "antoine.tenart@free-electrons.com" 
        <antoine.tenart@free-electrons.com>,
        "jaz@semihalf.com" <jaz@semihalf.com>,
        "baruch@tkos.co.il" <baruch@tkos.co.il>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Message-ID: <20191223082657.GL25745@shell.armlinux.org.uk>
References: <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191219190308.GE25745@shell.armlinux.org.uk>
 <VI1PR04MB5567010C06EB9A4734431106EC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191219214930.GG25745@shell.armlinux.org.uk>
 <VI1PR04MB556768668EEEDFD61B7AA518EC2D0@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191220091642.GJ25745@shell.armlinux.org.uk>
 <20191220092900.GB24174@lunn.ch>
 <VI1PR04MB55679B12D4E7C9EC05FE0D9AEC2D0@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191220100617.GE24174@lunn.ch>
 <VI1PR04MB556727A95090FFB4F9836DA2EC2E0@VI1PR04MB5567.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB556727A95090FFB4F9836DA2EC2E0@VI1PR04MB5567.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 07:50:08AM +0000, Madalin Bucur (OSS) wrote:
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Friday, December 20, 2019 12:06 PM
> > To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> > Cc: Russell King - ARM Linux admin <linux@armlinux.org.uk>;
> > antoine.tenart@free-electrons.com; jaz@semihalf.com; baruch@tkos.co.il;
> > davem@davemloft.net; netdev@vger.kernel.org; f.fainelli@gmail.com;
> > hkallweit1@gmail.com; shawnguo@kernel.org; devicetree@vger.kernel.org
> > Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
> > 
> > On Fri, Dec 20, 2019 at 09:39:08AM +0000, Madalin Bucur (OSS) wrote:
> > > > -----Original Message-----
> > > > From: Andrew Lunn <andrew@lunn.ch>
> > > > Sent: Friday, December 20, 2019 11:29 AM
> > > > To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > > Cc: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>;
> > antoine.tenart@free-
> > > > electrons.com; jaz@semihalf.com; baruch@tkos.co.il;
> > davem@davemloft.net;
> > > > netdev@vger.kernel.org; f.fainelli@gmail.com; hkallweit1@gmail.com;
> > > > shawnguo@kernel.org; devicetree@vger.kernel.org
> > > > Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
> > > >
> > > > > How does this help us when we can't simply change the existing
> > usage?
> > > > > We can update the DT but we can't free up the usage of "10gbase-kr".
> > > >
> > > > Agreed. Code needs to keep on interpreting "10gbase-kr" as any 10G
> > > > link. If we ever have a true 10gbase-kr, 802.3ap, one meter of copper
> > > > and two connectors, we are going to have to add a new mode to
> > > > represent true 10gbase-kr.
> > > >
> > > > 	Andrew
> > >
> > > Hi, actually we do have that. What would be the name of the new mode
> > > representing true 10GBase-KR that we will need to add when we upstream
> > > support for that?
> > 
> > Ah!
> > 
> > This is going to be messy.
> > 
> > Do you really need to differentiate? What seems to make 802.3ap
> > different is the FEC, autoneg and link training. Does you hardware
> > support this? Do you need to know you are supposed to be using 802.3ap
> > in order to configure these features?
> 
> Yes, it does.
> 
> > What are we going to report to user space? 10gbase-kr, or
> > 10gbase-kr-true? How do we handle the mess this makes with firmware
> > based cards which correctly report
> > ETHTOOL_LINK_MODE_10000baseKR_Full_BIT to user space?
> > 
> > What do we currently report to user space? Is it possible for us to
> > split DT from user space? DT says 10gbase-kr-true but to user space we
> > say ETHTOOL_LINK_MODE_10000baseKR_Full_BIT?
> > 
> > I think in order to work through these issues, somebody probably needs
> > the hardware, and the desire to see it working. So it might actually
> > be you who makes a proposal how we sort this out, with help from
> > Russell and I.
> > 
> > 	Andrew
> 
> We're overcomplicating the fix. As far as I can see only some Marvell boards
> declared 10GBase-KR as PHY interface type. These either support 10GBase-KR or
> they don't. When we learn this, we'll need to set things straight in the device
> trees and code. Until then it will remain as is, there is no trouble with that.

No we aren't.

You think we can just change the existing DT, switching them to use
XFI/SFI and free up the "10gbase-kr" definition.  Yes, we can change
the existing DT.  What we *can't* do is free up the existing definition
for "10gbase-kr" because old device trees must continue to work with
new kernels.  That is one of the rules we abide by with the kernel.

Now, looking at the Armada 8040 data, it only mentions XFI.  It's
described as "10GBASE-R (10GbE on single SERDES, including XFI)"
and goes on to say that it is compliant with "IEEE 802.3 standard".
However, there is no mention of a CDR, except for XAUI/XSGS mode,
not for 10GBASE-R/XFI mode.

So, it really isn't clear whether Marvell uses "XFI" to refer to a
port with a CDR or not.

Marvell's original MVPP2.2 and comphy drivers did used to distinguish
between XFI and SFI, but there was absolutely no difference in the
way the hardware was programmed.

Then there's the matter that (I believe with some firmware) it can
also support 10GBASE-KR (with clause 73 AN) after all.

So, we can't just replace the existing usage in DT with "SFI" just
because it's connected to a SFP cage, or "XFI" if it's connected
to a PHY which also mentiones "XFI" in its datasheet. We can't tell
whether the hardware _actually_ supports 1EEE 10GBASE-R, XFI or SFI.

Given that XFI and SFI are not actually documented (afaics) this is
really not that surprising - and I would not be surprised if these
three terms were used interchangably by some device manufacturers
as a result.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
