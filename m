Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FF723A18D
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 11:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgHCJHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 05:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgHCJHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 05:07:25 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88715C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 02:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zsvfj6qLQrBY7hWKv0KCz2IN8ZNd15PqKtlWcVCugu4=; b=eRx3/20M4qgQe1uLH2dW8sreR
        PVqPhiJFx2NI33gZ81heFu4iunNQRbUP2jm8N7MhL8BrOd9S5fOoy65/3KppmVkRktwbGCbntc78p
        /gLTDM4pF4W87x5BqTJ3fBYvhz6lBD8LZqRAVnMdeqh0OMj6yOM+KqQ0ILrL4YCdIrkbRjSjLoymb
        kG1hzrYVlYfMso/oVYKBVDzQgzwx1ZPv1/Hf5gdxHxmrjpCag28K+lOexPs2w73YE34DXTzYmAJnK
        qPXoAfE5UtDvCaOwcUYwqGibxPrg180FKg4JIw2UUZVbozBqpLwLip23VA2NKXVIw1Hkq5HqW64JU
        LDlsGMknA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47734)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k2WRB-0001Fe-8G; Mon, 03 Aug 2020 10:07:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k2WRA-0002xW-8X; Mon, 03 Aug 2020 10:07:16 +0100
Date:   Mon, 3 Aug 2020 10:07:16 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vikas Singh <vikas.singh@puresoftware.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        kuldip dwivedi <kuldip.dwivedi@puresoftware.com>,
        Vikas Singh <vikas.singh@nxp.com>
Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed PHY
Message-ID: <20200803090716.GL1551@shell.armlinux.org.uk>
References: <1595938400-13279-1-git-send-email-vikas.singh@puresoftware.com>
 <1595938400-13279-3-git-send-email-vikas.singh@puresoftware.com>
 <20200728130001.GB1712415@lunn.ch>
 <CADvVLtXVVfU3-U8DYPtDnvGoEK2TOXhpuE=1vz6nnXaFBA8pNA@mail.gmail.com>
 <20200731153119.GJ1712415@lunn.ch>
 <CADvVLtUrZDGqwEPO_ApCWK1dELkUEjrH47s1CbYEYOH9XgZMRg@mail.gmail.com>
 <20200801094132.GH1551@shell.armlinux.org.uk>
 <20200801151107.GK1712415@lunn.ch>
 <AM6PR04MB3976BB0CAB0B4270FF932F62EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR04MB3976BB0CAB0B4270FF932F62EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 08:33:19AM +0000, Madalin Bucur (OSS) wrote:
> > -----Original Message-----
> > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> > Behalf Of Andrew Lunn
> > Sent: 01 August 2020 18:11
> > To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Cc: Vikas Singh <vikas.singh@puresoftware.com>; f.fainelli@gmail.com;
> > hkallweit1@gmail.com; netdev@vger.kernel.org; Calvin Johnson (OSS)
> > <calvin.johnson@oss.nxp.com>; kuldip dwivedi
> > <kuldip.dwivedi@puresoftware.com>; Madalin Bucur (OSS)
> > <madalin.bucur@oss.nxp.com>; Vikas Singh <vikas.singh@nxp.com>
> > Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed PHY
> > 
> > On Sat, Aug 01, 2020 at 10:41:32AM +0100, Russell King - ARM Linux admin
> > wrote:
> > > On Sat, Aug 01, 2020 at 09:52:52AM +0530, Vikas Singh wrote:
> > > > Hi Andrew,
> > > >
> > > > Please refer to the "fman" node under
> > > > linux/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> > > > I have two 10G ethernet interfaces out of which one is of fixed-link.
> > >
> > > Please do not top post.
> > >
> > > How does XGMII (which is a 10G only interface) work at 1G speed?  Is
> > > what is in DT itself a hack because fixed-phy doesn't support 10G
> > > modes?
> > 
> > My gut feeling is there is some hack going on here, which is why i'm
> > being persistent at trying to understand what is actually going on
> > here.
> 
> Hi Andrew,
> 
> That platform used 1G fixed link there since there was no support for
> 10G fixed link at the time. PHYlib could have tolerated 10G speed there
> With a one-liner.

That statement is false.  It is not a "one liner".  fixed-phy exposes
the settings to userspace as a Clause 22 PHY register set, and the
Clause 22 register set does not support 10G.  So, a "one liner" would
just be yet another hack.  Adding Clause 45 PHY emulation support
would be a huge task.

> I understand that PHYLink is working to describe this
> Better, but it was not there at that time. Adding the dependency on
> PHYLink was not desirable as most of the users for the DPAA 1 platforms
> were targeting kernels before the PHYLink introduction (and last I've
> looked, it's still under development, with unstable APIs so we'll
> take a look at this later, when it settles).

I think you need to read Documentation/process/stable-api-nonsense.rst
particularly the section "Stable Kernel Source Interfaces".

phylink is going to be under development for quite some time to come
as requirements evolve.  For example, when support for QSFP interfaces
is eventually worked out, I suspect there will need to be some further
changes to the driver interface.  This is completely normal.

Now, as to the stability of the phylink API to drivers, it has in fact
been very stable - it has only changed over the course of this year to
support split PCS, a necessary step for DPAA2 and a few others.  It has
been around in mainline for two years, and has been around much longer
than that, and during that time it has been in mainline, the MAC facing
interface has not changed until recently.

So, I find your claim to be quite unreasonable.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
