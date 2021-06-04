Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D2D39C100
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 22:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhFDUEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 16:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhFDUEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 16:04:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA7CC061766;
        Fri,  4 Jun 2021 13:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5V0K76SC7xFgi4wfm94mthQafI0pCvyrVvpHGrwYWAg=; b=outXc+MeLTFU29y5bTflmViDE
        W0rCMayfjz+1GlO6/IXLpCxjAEIfKk4M7wXr0odesEbAK+5jzbjwZiiVvROklg7Y2bZNhRV5d/Cb2
        P9SaSHAchKQDPY2CHGsFcbqkndPTMuJFRxEZXNJx5ZFS3BON+l0Z+/43/UXB4HxdC7h3SNM2iXPz7
        /yA3Z/LrfHghQwmwUFcEl/iEsALLPlc/8n7yY6Q5a6tC7oC7c5gSHad+Db79iMQz3l13ynBI7eFRH
        +WmDHYAEU4AQjWIfataVu6SvVqRWKyiJOT+muvxKIPTjWzSR4i7TI5mj2ObDaMxCRC6tgQq4tjFuc
        MQDFDgqZQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44716)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lpFzF-0004s2-Aa; Fri, 04 Jun 2021 21:00:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lpFzE-0003Kq-12; Fri, 04 Jun 2021 21:00:08 +0100
Date:   Fri, 4 Jun 2021 21:00:07 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Igal Liberman <Igal.Liberman@freescale.com>,
        Shruti Kanetkar <Shruti@freescale.com>,
        Emil Medve <Emilian.Medve@freescale.com>,
        Scott Wood <oss@buserror.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>
Subject: Re: Unsupported phy-connection-type sgmii-2500 in
 arch/powerpc/boot/dts/fsl/t1023rdb.dts
Message-ID: <20210604200007.GX30436@shell.armlinux.org.uk>
References: <20210603143453.if7hgifupx5k433b@pali>
 <YLjxX/XPDoRRIvYf@lunn.ch>
 <20210603194853.ngz4jdso3kfncnj4@pali>
 <AM6PR04MB3976B62084EC462BA02F0C4CEC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604192732.GW30436@shell.armlinux.org.uk>
 <AM6PR04MB39768A569CE3CC4EC61A8769EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM6PR04MB39768A569CE3CC4EC61A8769EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 07:39:10PM +0000, Madalin Bucur wrote:
> > -----Original Message-----
> > From: Russell King <linux@armlinux.org.uk>
> > Sent: 04 June 2021 22:28
> > To: Madalin Bucur <madalin.bucur@nxp.com>
> > Cc: Pali Rohár <pali@kernel.org>; Andrew Lunn <andrew@lunn.ch>; Igal
> > Liberman <Igal.Liberman@freescale.com>; Shruti Kanetkar
> > <Shruti@freescale.com>; Emil Medve <Emilian.Medve@freescale.com>; Scott
> > Wood <oss@buserror.net>; Rob Herring <robh+dt@kernel.org>; Michael
> > Ellerman <mpe@ellerman.id.au>; Benjamin Herrenschmidt
> > <benh@kernel.crashing.org>; netdev@vger.kernel.org;
> > devicetree@vger.kernel.org; linux-kernel@vger.kernel.org; Camelia
> > Alexandra Groza (OSS) <camelia.groza@oss.nxp.com>
> > Subject: Re: Unsupported phy-connection-type sgmii-2500 in
> > arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > 
> > On Fri, Jun 04, 2021 at 07:35:33AM +0000, Madalin Bucur wrote:
> > > Hi, the Freescale emails no longer work, years after Freescale joined
> > NXP.
> > > Also, the first four recipients no longer work for NXP.
> > >
> > > In regards to the sgmii-2500 you see in the device tree, it describes
> > SGMII
> > > overclocked to 2.5Gbps, with autonegotiation disabled.
> > >
> > > A quote from a long time ago, from someone from the HW team on this:
> > >
> > > 	The industry consensus is that 2.5G SGMII is overclocked 1G SGMII
> > > 	using XAUI electricals. For the PCS and MAC layers, it looks exactly
> > > 	like 1G SGMII, just with a faster clock.
> > >
> > > The statement that it does not exist is not accurate, it exists in HW,
> > and
> > > it is described as such in the device tree. Whether or not it is
> > properly
> > > treated in SW it's another discussion.
> > 
> > Here's the issue though:
> > 
> > 802.3 defined 1000base-X which is a fixed 1G speed interface using a
> > 16-bit control word. Implementations of this exist where the control
> > word can be disabled.
> > 
> > Cisco came along, took 1000base-X and augmented it to allow speeds of
> > 10M and 100M by symbol repetition, and changing the format of the
> > 16-bit control word. Otherwise, it is functionally compatible - indeed
> > SGMII with the control word disabled will connect with 1000base-X with
> > the control word disabled. I've done it several times.
> > 
> > There exists 2500base-X, which is 1000base-X clocked faster, and it
> > seems the concensus is that it has the AN disabled - in other words,
> > no control word.
> > 
> > Now you're saying that SGMII at 2.5G speed exists, which is 1G SGMII
> > fixed at 1G speed, without a control word, upclocked by 2.5x.
> > 
> > My question to you is how is how is this SGMII 2.5G different from
> > 2500base-X?
> > 
> > > In 2015, when this was submitted,
> > > there were no other 2.5G compatibles in use, if I'm not mistaken.
> > > 2500Base-X started to be added to device trees four years later, it
> > should
> > > be compatible/interworking but it is less specific on the actual
> > implementation
> > > details (denotes 2.5G speed, 8b/10b coding, which is true for this
> > overclocked
> > > SGMII). If they are compatible, SW should probably treat them in the
> > same manner.
> > 
> > My argument has been (since I've had experience of SGMII talking to
> > 1000base-X, and have also accidentally clocked such a scenario at
> > 2.5G speeds) that there is in fact no functional difference between
> > SGMII and base-X when they are running at identical speeds with the
> > control word disabled.
> > 
> > Given that we well know that industry likes to use the term "SGMII"
> > very loosely to mean <whatever>base-X as well as SGMII, it becomes
> > a very bad term to use when we wish to differentiate between a
> > base-X and a real Cisco SGMII link with their different control word
> > formats.
> > 
> > And this has always been my point - industry has created confusion
> > over these terms, but as software programmers, we need to know the
> > difference. So, SGMII should _only_ be used to identify the Cisco
> > SGMII modified version of 802.3 base-X _with_ the modified control
> > word or with the capability of symbol repetition. In other words,
> > the very features that make it SGMII as opposed to 802.3 base-X.
> > Everything else should not use the term SGMII.
> > 
> > > There were some discussions a while ago about the mix or even confusion
> > between
> > > the actual HW description (that's what the dts is supposed to do) and
> > the settings
> > > one wants to represent in SW (i.e. speed) denoted loosely by
> > denominations like
> > > 10G Base-R.
> > 
> > The "confusion" comes from an abuse of terms. Abused terms really
> > can't adequately be used to describe hardware properties.
> > 
> > As I say above, we _know_ that some manufacturers state that their
> > single lane serdes is "SGMII" when it is in fact 1000base-X. That
> > doesn't mean we stuff "sgmii" into device tree because that's what
> > the vendor decided to call it.
> > 
> > "sgmii" in the device tree means Cisco's well defined SGMII and
> > does not mean 1000base-X.
> 
> The "sgmii-2500" compatible in that device tree describes an SGMII HW
> block, overclocked at 2.5G. Without that overclocking, it's a plain
> Cisco (like) SGMII HW block. That's the reason you need to disable it's
> AN setting when overclocked. With the proper Reset Configuration Word,
> you could remove the overclocking and transform that into a plain "sgmii".
> Thus, the dts compatible describes the HW, as it is.

I have given you a detailed explanation of my view on this, which is
based on reading the 802.3 and Cisco SGMII specifications and various
device datasheets from multiple different manufacturers.

I find your argument which seems to be based on what your hardware
in front of you "does" and the actual explanation of it to be an
extremely weak response.

Please provide a robust argument for your position. Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
