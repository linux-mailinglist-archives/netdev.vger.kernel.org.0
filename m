Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390BD129479
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 11:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfLWK5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 05:57:35 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39154 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbfLWK5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 05:57:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ks04SPyXvvafL1iMP0l/scP6rd1eKNlpJyjGA3oj0nY=; b=ZPJkYwShSJrtxWxUB8NYuKO5/
        bnisJ9ljjJvpfOGGYxr25zRaxa3LcT6VFlN1iKjvMdKUraUiA6kOIAl4pflbt0xKY6HVLk0J0rdly
        LZmL2U8X5FqnidN5gy+CXHRNFdVQYpZnUotq1sGDXYYTSeiahUL0HhEQegz8K6pALboKvRCyepcE+
        2XR1UfI930DodM5ewqoQLaHdDYB9w6naNXzHUUqgLVkBXFxXTrVQbKq+yTBXQOxW4sv3jc/OHUZ+X
        q+H4nWRrMBZKV8jkm/7esA2TYHGMETZtNw7+fosSwQyLARxpMhKvowGl+Z5oYMGqp7KIkSliMGgkG
        SrybPgDgw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:52728)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ijLOs-0001Ju-AI; Mon, 23 Dec 2019 10:57:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ijLOp-0000kc-4z; Mon, 23 Dec 2019 10:57:19 +0000
Date:   Mon, 23 Dec 2019 10:57:19 +0000
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
Message-ID: <20191223105719.GM25745@shell.armlinux.org.uk>
References: <VI1PR04MB5567010C06EB9A4734431106EC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191219214930.GG25745@shell.armlinux.org.uk>
 <VI1PR04MB556768668EEEDFD61B7AA518EC2D0@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191220091642.GJ25745@shell.armlinux.org.uk>
 <20191220092900.GB24174@lunn.ch>
 <VI1PR04MB55679B12D4E7C9EC05FE0D9AEC2D0@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191220100617.GE24174@lunn.ch>
 <VI1PR04MB556727A95090FFB4F9836DA2EC2E0@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191223082657.GL25745@shell.armlinux.org.uk>
 <VI1PR04MB5567B6C8D56E03C96FF54D07EC2E0@VI1PR04MB5567.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB5567B6C8D56E03C96FF54D07EC2E0@VI1PR04MB5567.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 09:57:51AM +0000, Madalin Bucur (OSS) wrote:
> > -----Original Message-----
> > From: devicetree-owner@vger.kernel.org <devicetree-owner@vger.kernel.org>
> > On Behalf Of Russell King - ARM Linux admin
> > Sent: Monday, December 23, 2019 10:27 AM
> > To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> > Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
> > 
> > On Mon, Dec 23, 2019 at 07:50:08AM +0000, Madalin Bucur (OSS) wrote:
> > > > -----Original Message-----
> > > > From: Andrew Lunn <andrew@lunn.ch>
> > > > Sent: Friday, December 20, 2019 12:06 PM
> > > > To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> > > > Cc: Russell King - ARM Linux admin <linux@armlinux.org.uk>;
> > > > antoine.tenart@free-electrons.com; jaz@semihalf.com;
> > baruch@tkos.co.il;
> > > > davem@davemloft.net; netdev@vger.kernel.org; f.fainelli@gmail.com;
> > > > hkallweit1@gmail.com; shawnguo@kernel.org; devicetree@vger.kernel.org
> > > > Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
> > > >
> > > > On Fri, Dec 20, 2019 at 09:39:08AM +0000, Madalin Bucur (OSS) wrote:
> > > > > > -----Original Message-----
> > > > > > From: Andrew Lunn <andrew@lunn.ch>
> > > > > > Sent: Friday, December 20, 2019 11:29 AM
> > > > > > To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > > > > Cc: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>;
> > > > antoine.tenart@free-
> > > > > > electrons.com; jaz@semihalf.com; baruch@tkos.co.il;
> > > > davem@davemloft.net;
> > > > > > netdev@vger.kernel.org; f.fainelli@gmail.com;
> > hkallweit1@gmail.com;
> > > > > > shawnguo@kernel.org; devicetree@vger.kernel.org
> > > > > > Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI,
> > SFI
> > > > > >
> > > > > > > How does this help us when we can't simply change the existing
> > > > usage?
> > > > > > > We can update the DT but we can't free up the usage of "10gbase-
> > kr".
> > > > > >
> > > > > > Agreed. Code needs to keep on interpreting "10gbase-kr" as any 10G
> > > > > > link. If we ever have a true 10gbase-kr, 802.3ap, one meter of
> > copper
> > > > > > and two connectors, we are going to have to add a new mode to
> > > > > > represent true 10gbase-kr.
> > > > > >
> > > > > > 	Andrew
> > > > >
> > > > > Hi, actually we do have that. What would be the name of the new mode
> > > > > representing true 10GBase-KR that we will need to add when we
> > upstream
> > > > > support for that?
> > > >
> > > > Ah!
> > > >
> > > > This is going to be messy.
> > > >
> > > > Do you really need to differentiate? What seems to make 802.3ap
> > > > different is the FEC, autoneg and link training. Does you hardware
> > > > support this? Do you need to know you are supposed to be using 802.3ap
> > > > in order to configure these features?
> > >
> > > Yes, it does.
> > >
> > > > What are we going to report to user space? 10gbase-kr, or
> > > > 10gbase-kr-true? How do we handle the mess this makes with firmware
> > > > based cards which correctly report
> > > > ETHTOOL_LINK_MODE_10000baseKR_Full_BIT to user space?
> > > >
> > > > What do we currently report to user space? Is it possible for us to
> > > > split DT from user space? DT says 10gbase-kr-true but to user space we
> > > > say ETHTOOL_LINK_MODE_10000baseKR_Full_BIT?
> > > >
> > > > I think in order to work through these issues, somebody probably needs
> > > > the hardware, and the desire to see it working. So it might actually
> > > > be you who makes a proposal how we sort this out, with help from
> > > > Russell and I.
> > > >
> > > > 	Andrew
> > >
> > > We're overcomplicating the fix. As far as I can see only some Marvell
> > boards
> > > declared 10GBase-KR as PHY interface type. These either support 10GBase-
> > KR or
> > > they don't. When we learn this, we'll need to set things straight in the
> > device
> > > trees and code. Until then it will remain as is, there is no trouble
> > with that.
> > 
> > No we aren't.
> > 
> > You think we can just change the existing DT, switching them to use
> > XFI/SFI and free up the "10gbase-kr" definition.  Yes, we can change
> > the existing DT.  What we *can't* do is free up the existing definition
> > for "10gbase-kr" because old device trees must continue to work with
> > new kernels.  That is one of the rules we abide by with the kernel.
> 
> We do not need to "free up" the definition, if that particular device
> does use 10GBase-KR then it does not need changing. Please note 10GBase-KR
> is quite well established in the Ethernet nomenclature (802.3ap, 2007),
> it's clear what it does so there is no need to "free it up" somewhere.

I'm fully aware of what is in IEE 802.3.

> The phy-connection-type was introduced back in the day when this
> connection was more aligned to the MAC-PHY MII. That resulted in
> XGMII being used for all 10G interfaces when they were added.
> But the clean MII separation does not align with today's HW, where
> the asic/SoC to external PHY chip interface has evolved towards
> high speed serial interfaces with obvious benefits. We're now seeing
> the PCS, PMA blocks that are part of the PHY layer moved together with
> the MAC.
> 
> I've recently seen how a certain PHY driver started using USXGMII and
> rejected XGMII (please note the MII is still XGMII but it's buried
> somewhere in the peer SoC) as a phy-conection-type. Some HW platforms
> may use that PHY in USXGMII mode, others use it in one of the other
> supported modes - XFI. Why is USXGMII a valid phy-connection-type
> but XFI is not? Is it correct that I describe that HW as using
> 10GBase-KR instead of XFI, something that has a clearly different
> meaning for anyone familiar with IEEE 802.3ap just because there was
> a typo in a patch, be it a device tree one? I'm puzzled.

I think I've already explained why several times.  In the kernel, we
do not break new kernels running with existing DT files.

Therefore, today's usage of "10gbase-kr" must continue to work in
the current setups.

> > Now, looking at the Armada 8040 data, it only mentions XFI.  It's
> > described as "10GBASE-R (10GbE on single SERDES, including XFI)"
> > and goes on to say that it is compliant with "IEEE 802.3 standard".
> > However, there is no mention of a CDR, except for XAUI/XSGS mode,
> > not for 10GBASE-R/XFI mode.
> 
> Is "10GBASE-R" in wide use? Although you can extract that from the
> Ethernet nomenclature to mean 10G with 64B/66B encoding, I did not
> see it used much by vendors. I do see more of the XFI, SFI terminology
> in use.

Only Intel, Xilinx, Synopsys on the first page of google for
"10GBASE-R".  For "XFI" and "SFI" there's nothing relating to ethernet
on the first page.  So, rather hard to know unless you're in the
hardware industry in that sector.

> > So, it really isn't clear whether Marvell uses "XFI" to refer to a
> > port with a CDR or not.
> > 
> > Marvell's original MVPP2.2 and comphy drivers did used to distinguish
> > between XFI and SFI, but there was absolutely no difference in the
> > way the hardware was programmed.
> > 
> > Then there's the matter that (I believe with some firmware) it can
> > also support 10GBASE-KR (with clause 73 AN) after all.
> 
> Then there's not a real need to change that device tree, it's correct.

Sorry.  Why do you believe it's correct?  As far as I know, the
firmware to support 10GBASE-KR on the Armada 8040 was never
actually released.

Given that some of these are connected directly to a SFP cage.
Given that some of these are connected directly to a PHY that
doesn't do Clause 73 AN over the link.

> The HW can be used in 10GBASE-KR with appropriate SW so the HW description
> is fine.

No it is not.

Just because the hardware _can_ be used with 10GBASE-KR (with AN)
does not mean that the existing usage is correct from the information
you have given.

> > So, we can't just replace the existing usage in DT with "SFI" just
> > because it's connected to a SFP cage, or "XFI" if it's connected
> > to a PHY which also mentiones "XFI" in its datasheet. We can't tell
> > whether the hardware _actually_ supports 1EEE 10GBASE-R, XFI or SFI.
> 
> We don't need to replace it. But if a certain HW is certain to use XFI
> (or SFI), we just need to describe it as such in the device tree.
> 
> > Given that XFI and SFI are not actually documented (afaics) this is
> > really not that surprising - and I would not be surprised if these
> > three terms were used interchangably by some device manufacturers
> > as a result.
> 
> XFI (and SFI?) are the result of MSA, multi-source agreements so they
> must be documented somewhere (see http://www.xfpmsa.org/). Whether that
> document is available for free or behind a paywall/membership it's
> another discussion.

SFI in the SFF8431 defines the electrical characteristics required
in terms of the eye mask and other electrical parameters at various
defined points, such as at the SFP cage connector. That is no
different from other standards such as SATA, HDMI etc. Achieving
those parameters are board layout dependent, and are a matter for
the hardware design team for the board to work out how to setup the
hardware to achieve compliance with that specification.

SFI doesn't rigidly define the protocol in use, because it isn't
limited to just 10GBASE-R - it can be clause 49 10GBASE-R for LAN
ethernet, clause 50 10GBASE-W for WAN ethernet, 10GFC, or 10GBASE-R
with FEC.

10GBASE-R on the other hand does not define any electrical
characteristics. It is the underlying protocol specification only.

Hence, from what I can see, SFI for clause 49 ethernet is just
10GBASE-R with electrical compliance at the cage determined by the
board manufacturer. What that means is that to meet SFI compliance,
it is a whole-system integration problem. The SFP cage connector and
the PCB layout all have an impact on how the serdes needs to be tuned
to achieve compliance in meeting the specification. Every board likely
needs different tuning to achieve compliance.

The XFP MSA is not available to people like me, unlike the SFP
specifications. Effectively, that means it doesn't exist, and I
can't gain the knowledge of what its requirements are. So, choices
_had_ to be made without its knowledge, which is why we've ended
up where we are. Had the XFP MSA been more freely available, then
maybe better choices could be made - but alas, that is the cost of
keeping specifications behind paywalls/membership-only.  Those
sectors of the industry lose out when it comes to one of the
biggest most successful Open Source projects on the planet.

Therefore, for XFI, I don't care what we do - I have no basis on
which to make any decision on that.

phy_interface_t describes the protocol *only*, it doesn't describe
the electrical characteristics of the interface.  So, if we exclude
the electrical characteristics of SFI, we're back to 10GBASE-R,
10GBASE-W, 10GFC or 10GBASE-R with FEC.  That's what phy_interface_t
is, not SFI.

So, I propose that we add 10GBASE-R to the list and *not* SFI.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
