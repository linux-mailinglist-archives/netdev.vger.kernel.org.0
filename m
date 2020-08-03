Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310CA23A817
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgHCOKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbgHCOKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 10:10:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5957AC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 07:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qzkaDTr9vSisME+dA8Xg8IpM8WiAoAVHiR28AiL/tNc=; b=eePogb38qcPeyuvKMgFbSC2uJ
        pMB4mJzSqBz/DpYemgcbd2t0kxs1wZodeHezhW1cV/AdywzLQoSjytTGu3PgVOBLIb6suAzNt6I0U
        mVaGFmKDAHQDau+z8Du7HpUhQWH6axvVtXknTOj3149syYbTDK/eX8+c9xIpRZTdrRslcNEqddY3J
        /t8GlIXu49hoF/Fm16UC1yr27XE5bLLRjpdNl6EE5dvWXrpN3AZf/qJw2aUb7W2LZuq868+xiGfMC
        W4UXZBp8yrG37pIo4cdFbvEHPEc5kMgYhK8vSRbYUWG48adaiAVgYrW5U5hkV2WJudtvRNc7uJgt4
        k9cj1QGRw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47820)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k2bAQ-0001aS-Pf; Mon, 03 Aug 2020 15:10:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k2bAP-00039F-VC; Mon, 03 Aug 2020 15:10:17 +0100
Date:   Mon, 3 Aug 2020 15:10:17 +0100
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
Message-ID: <20200803141017.GM1551@shell.armlinux.org.uk>
References: <1595938400-13279-3-git-send-email-vikas.singh@puresoftware.com>
 <20200728130001.GB1712415@lunn.ch>
 <CADvVLtXVVfU3-U8DYPtDnvGoEK2TOXhpuE=1vz6nnXaFBA8pNA@mail.gmail.com>
 <20200731153119.GJ1712415@lunn.ch>
 <CADvVLtUrZDGqwEPO_ApCWK1dELkUEjrH47s1CbYEYOH9XgZMRg@mail.gmail.com>
 <20200801094132.GH1551@shell.armlinux.org.uk>
 <20200801151107.GK1712415@lunn.ch>
 <AM6PR04MB3976BB0CAB0B4270FF932F62EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20200803090716.GL1551@shell.armlinux.org.uk>
 <AM6PR04MB3976284AEC94129D26300485EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR04MB3976284AEC94129D26300485EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 11:45:55AM +0000, Madalin Bucur (OSS) wrote:
> > -----Original Message-----
> > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Sent: 03 August 2020 12:07
> > To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> > Cc: Andrew Lunn <andrew@lunn.ch>; Vikas Singh
> > <vikas.singh@puresoftware.com>; f.fainelli@gmail.com; hkallweit1@gmail.com;
> > netdev@vger.kernel.org; Calvin Johnson (OSS) <calvin.johnson@oss.nxp.com>;
> > kuldip dwivedi <kuldip.dwivedi@puresoftware.com>; Vikas Singh
> > <vikas.singh@nxp.com>
> > Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed PHY
> > 
> > On Mon, Aug 03, 2020 at 08:33:19AM +0000, Madalin Bucur (OSS) wrote:
> > > > -----Original Message-----
> > > > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> > > > Behalf Of Andrew Lunn
> > > > Sent: 01 August 2020 18:11
> > > > To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > > Cc: Vikas Singh <vikas.singh@puresoftware.com>; f.fainelli@gmail.com;
> > > > hkallweit1@gmail.com; netdev@vger.kernel.org; Calvin Johnson (OSS)
> > > > <calvin.johnson@oss.nxp.com>; kuldip dwivedi
> > > > <kuldip.dwivedi@puresoftware.com>; Madalin Bucur (OSS)
> > > > <madalin.bucur@oss.nxp.com>; Vikas Singh <vikas.singh@nxp.com>
> > > > Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed
> > PHY
> > > >
> > > > On Sat, Aug 01, 2020 at 10:41:32AM +0100, Russell King - ARM Linux
> > admin
> > > > wrote:
> > > > > On Sat, Aug 01, 2020 at 09:52:52AM +0530, Vikas Singh wrote:
> > > > > > Hi Andrew,
> > > > > >
> > > > > > Please refer to the "fman" node under
> > > > > > linux/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> > > > > > I have two 10G ethernet interfaces out of which one is of fixed-
> > link.
> > > > >
> > > > > Please do not top post.
> > > > >
> > > > > How does XGMII (which is a 10G only interface) work at 1G speed?  Is
> > > > > what is in DT itself a hack because fixed-phy doesn't support 10G
> > > > > modes?
> > > >
> > > > My gut feeling is there is some hack going on here, which is why i'm
> > > > being persistent at trying to understand what is actually going on
> > > > here.
> > >
> > > Hi Andrew,
> > >
> > > That platform used 1G fixed link there since there was no support for
> > > 10G fixed link at the time. PHYlib could have tolerated 10G speed there
> > > With a one-liner.
> > 
> > That statement is false.  It is not a "one liner".  fixed-phy exposes
> > the settings to userspace as a Clause 22 PHY register set, and the
> > Clause 22 register set does not support 10G.  So, a "one liner" would
> > just be yet another hack.  Adding Clause 45 PHY emulation support
> > would be a huge task.
> > 
> > > I understand that PHYLink is working to describe this
> > > Better, but it was not there at that time. Adding the dependency on
> > > PHYLink was not desirable as most of the users for the DPAA 1 platforms
> > > were targeting kernels before the PHYLink introduction (and last I've
> > > looked, it's still under development, with unstable APIs so we'll
> > > take a look at this later, when it settles).
> > 
> > I think you need to read Documentation/process/stable-api-nonsense.rst
> > particularly the section "Stable Kernel Source Interfaces".
> > 
> > phylink is going to be under development for quite some time to come
> > as requirements evolve.  For example, when support for QSFP interfaces
> > is eventually worked out, I suspect there will need to be some further
> > changes to the driver interface.  This is completely normal.
> > 
> > Now, as to the stability of the phylink API to drivers, it has in fact
> > been very stable - it has only changed over the course of this year to
> > support split PCS, a necessary step for DPAA2 and a few others.  It has
> > been around in mainline for two years, and has been around much longer
> > than that, and during that time it has been in mainline, the MAC facing
> > interface has not changed until recently.
> > 
> > So, I find your claim to be quite unreasonable.
> 
> I see you agree that there were and there will be many changes for a while,
> It's not a complaint, I know hot it works, it's just a decision based on
> required effort vs features offered vs user requirements. Lately it's been
> time consuming to try to fix things in this area.

No, it hasn't been time consuming.  The only API changes as far as
drivers are concerned have been:

1. the change to the mac_link_up() prototype to move the setup of the
   final link parameters out of mac_config() - and almost all of the
   updates to users were done by me.

2. the addition of split PCS support, introducing new interfaces, has
   had minimal impact on those drivers that updated in step (1).

There have been no other changes as far as users are concerned.

Some of the difficulty with (1) has been that users of phylink appeared
initially with no proper review, and consequently they got quite a lot
wrong.  The most common error has been using state->speed, state->duplex
in mac_config() methods irrespective of the AN mode, which has _always_
since before phylink was merged into mainline, been totally unreliable.

That leads me on to the other visible "changes" for users are concerned,
which may be interpreted as interface changes, but are not; they have
all been clarifications to the documentation, to strengthen things such
as "do not use state->speed and state->duplex in mac_config() for
various specific AN modes".  Nothing has actually changed with any of
those clarifications.

For example, if in in-band mode, and mac_config() uses state->speed
and state->duplex, then it doesn't matter which version of phylink
you're using, if someone issues ethtool -s ethN ..., then state->speed
and state->duplex will be their respective UNKNOWN values, and if you're
using these in that situation, you will mis-program the MAC.

Again, that is not something that has changed.  Ever.  But the
documentation has because people just don't seem to get it, and I seemed
to be constantly repeating myself in review after review on the same
points.

So, your assertion that the phylink API is not stable is false.  It
has been remarkably stable over the two years that it has been around.
It is only natural that as the technology that a piece of code supports
evolves, so the code evolves with it.  That is exactly what has happened
this year with the two changes I mention above.

Now, if you've found it time consuming to "fix things" (unspecified what
"things" are) then I assert that what has needed to be fixed are things
that NXP have got wrong.  Such as the rtnl cockups.  Such as abusing
state->speed and state->duplex.  None of that is because the interface
is unstable - they are down to buggy implementation on NXPs part.

Essentially, what I'm saying is that your attempt to paint phylink as
being painful on the basis of interface changes is totally and utterly
wrong and is just an excuse to justify abusing the fixed-link code and
specifying things that are clearly incorrect via DT.

I will accept that the interface that had existed up until the
mac_link_up() change was confusing - it clearly was due to the number
of people getting mac_config() implementations wrong.  That is actually
another of the reasons why the mac_link_up() change was made.  These
problems are _only_ found by people making use of it.  If people don't
use stuff, then problems aren't found, and nothing changes.

So, I think you can expect a NAK for the patch at the top of this
thread on the basis that it is perpetuating an abuse not only the
legacy fixed-link code, but also DT.  However, I will leave Andrew to
make that call.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
