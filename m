Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0AE12F60C
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 10:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgACJ1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 04:27:31 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38336 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbgACJ1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 04:27:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TFFNUpBqrHSpyurnMmcanTS7uqHtMMP0ooKKfVEFBeA=; b=xY0zM+CeBrM/vokDa80g5TsP7
        yMjSfuLAZNBHGfXQAzrjsYJ7w7huIQs1MR7Sp6VCRFpgEoFjmC42WtfI2jiFoR+fNbT2+o4r6OucS
        USrfgGGAkKAXCVf5z+KrasALMVjdLAyuj4TLWWDQ6GDTbr2tSUhQ+opAE/GdtWclzCiNsBGSgK9qD
        IbxETDnQrTZ/gXelOAW1D92iDqK/VA14h1U21WvcBBR62Yuu9GVlznsWuOvF6vYfw/a2sjtt3cfXD
        MAZEPTQwzcLobUe3JwBAFGRdwewng1VE1RWSosx2GOa/uR4DOMv257cO0pmpE3wNKKTBPDKhgLrDu
        N+7y8Bs/Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33388)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1inJEp-0001FV-9X; Fri, 03 Jan 2020 09:27:23 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1inJEk-00030q-7h; Fri, 03 Jan 2020 09:27:18 +0000
Date:   Fri, 3 Jan 2020 09:27:18 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>
Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Message-ID: <20200103092718.GB25745@shell.armlinux.org.uk>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191223120730.GO25745@shell.armlinux.org.uk>
 <DB8PR04MB69858081021729EC70216BE3EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB69858081021729EC70216BE3EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 07:01:50AM +0000, Madalin Bucur (OSS) wrote:
> > -----Original Message-----
> > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Sent: Monday, December 23, 2019 2:08 PM
> > To: Madalin Bucur <madalin.bucur@nxp.com>
> > Cc: davem@davemloft.net; netdev@vger.kernel.org; andrew@lunn.ch;
> > f.fainelli@gmail.com; hkallweit1@gmail.com; shawnguo@kernel.org;
> > devicetree@vger.kernel.org
> > Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
> > 
> > On Thu, Dec 19, 2019 at 06:32:51PM +0000, Madalin Bucur wrote:
> > > 10GBase-R could be used as a common nominator but just as well 10G and
> > > remove the rest while we're at it. There are/may be differences in
> > > features, differences in the way the HW is configured (the most
> > > important aspect) and one should be able to determine what interface
> > > type is in use to properly configure the HW. SFI does not have the CDR
> > > function in the PMD, relying on the PMA signal conditioning vs the XFI
> > > that requires this in the PMD.
> > 
> > I've now found a copy of INF-8077i on the net, which seems to be the
> > document that defines XFI. The definition in there seems to be very
> > similar to SFI in that it is an electrical specification, not a
> > protocol specification, and, just like SFI, it defines the electrical
> > characteristics at the cage, not at the serdes. Therefore, the effects
> > of the board layout come into play to achieve compliance with XFI.
> 
> I think we're missing the point here: we need to start from the device
> tree and that is supposed to describe the board, the hardware, not to
> configure the software. Please re-read the paragraph above in this key:
> the device tree needs to describe the HW features, those electrical
> properties you are discussing above. The fact that we use a certain
> protocol over it, by choice in software, does not change the HW and it
> should not change the device tree describing it.

phy_interface_t does *NOT* describe the electrical properties of the
link; it describes the protocol. The protocol for 10GBASE-R, SFI and
XFI are *all* the same. Therefore, phy_interface_t does *not*
distinguish between these.

Yes, DT may need to describe the electrical properties. That needs to
be done independently of the phy_interface_t and therefore phy-mode
definition.

Just like it is done for SATA interfaces that need the eye mask
(electrical properties of the serdes) adjusted for the board.

> > Just like SFI, XFI can be used with multiple different underlying
> > protocols. I quote:
> > 
> >   "The XFI interface is designed to support SONET OC-192,
> >   IEEE.Std-802.3ae, 10GFC and G.709(OTU-2) applications."
> > 
> > Therefore, to describe 10GBASE-R as "XFI" is most definitely incorrect.
> > 10GBASE-R is just _one_ protocol that can be run over XFI, but it is
> > not the only one.
> 
> Exactly why the chip to chip interface described by the device tree needs
> to be xfi not 10GBASE-R,

Sorry no.

Merely specifying "xfi" does not tell you what you need to do to achieve
XFI compliance at the point defined in INF8077i.  Plus, XFI can also be
protocols _other_ than 10GBASE-R.

Claiming that "XFI" properly defines the interface is utter rubbish. It
does not. XFI defines the electrical characteristics *only* and not
the underlying protocol. It is not limited to 10GBASE-R, but includes
other protocols as well.

XFI is not a phy interface type.  Sorry.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
