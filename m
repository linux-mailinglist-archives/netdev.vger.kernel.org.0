Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1231E7527
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 07:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgE2FAa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 May 2020 01:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2FA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 01:00:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAABC08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 22:00:29 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jeX7q-0002pD-F2; Fri, 29 May 2020 07:00:10 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jeX7e-0003qi-MS; Fri, 29 May 2020 06:59:58 +0200
Date:   Fri, 29 May 2020 06:59:58 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@protonic.nl" <david@protonic.nl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
Message-ID: <20200529045958.qpfh6l6ju3j4q7dh@pengutronix.de>
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
 <CAMuHMdU1ZmSm_tjtWxoFNako2fzmranGVz5qqD2YRNEFRjX0Sw@mail.gmail.com>
 <20200428154718.GA24923@lunn.ch>
 <6791722391359fce92b39e3a21eef89495ccf156.camel@toradex.com>
 <CAMuHMdXm7n6cE5-ZjwxU_yKSrCaZCwqc_tBA+M_Lq53hbH2-jg@mail.gmail.com>
 <20200429092616.7ug4kdgdltxowkcs@pengutronix.de>
 <CAMuHMdWf1f95ZcOLd=k1rd4WE98T1qh_3YsJteyDGtYm1m_Nfg@mail.gmail.com>
 <20200527205221.GA818296@lunn.ch>
 <CAMuHMdU+MR-2tr3-pH55G0GqPG9HwH3XUd=8HZxprFDMGQeWUw@mail.gmail.com>
 <20200528160839.GE840827@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200528160839.GE840827@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:55:29 up 195 days, 20:14, 183 users,  load average: 0.22, 0.07,
 0.02
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 06:08:39PM +0200, Andrew Lunn wrote:
> On Thu, May 28, 2020 at 03:10:06PM +0200, Geert Uytterhoeven wrote:
> > Hi Andrew,
> > 
> > On Wed, May 27, 2020 at 10:52 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > > > You may wonder what's the difference between 3 and 4? It's not just the
> > > > PHY driver that looks at phy-mode!
> > > > drivers/net/ethernet/renesas/ravb_main.c:ravb_set_delay_mode() also
> > > > does, and configures an additional TX clock delay of 1.8 ns if TXID is
> > > > enabled.
> > >
> > > That sounds like a MAC bug. Either the MAC insert the delay, or the
> > > PHY does. If the MAC decides it is going to insert the delay, it
> > > should be masking what it passes to phylib so that the PHY does not
> > > add a second delay.
> > 
> > And so I gave this a try, and modified the ravb driver to pass "rgmii"
> > to the PHY if it has inserted a delay.
> > That fixes the speed issue on R-Car M3-W!
> > And gets rid of the "*-skew-ps values should be used only with..."
> > message.
> > 
> > I also tried if I can get rid of "rxc-skew-ps = <1500>". After dropping
> > the property, DHCP failed.  Compensating by changing the PHY mode in DT
> > from "rgmii-txid" to "rgmii-id" makes it work again.
> 
> In general, i suggest that the PHY implements the delay, not the MAC.
> Most PHYs support it, where as most MACs don't. It keeps maintenance
> and understanding easier, if everything is the same. But there are
> cases where the PHY does not have the needed support, and the MAC does
> the delays.
> 
> > However, given Philippe's comment that the rgmi-*id apply to the PHY
> > only, I think we need new DT properties for enabling MAC internal delays.
> 
> Do you actually need MAC internal delays?
> 
> > That description is not quite correct: the driver expects skews for
> > plain RGMII only. For RGMII-*ID, it prints a warning, but still applies
> > the supplied skew values.
> 
> O.K. so not so bad.
> 
> > 
> > To fix the issue, I came up with the following problem statement and
> > plan:
> > 
> > A. Old behavior:
> > 
> >   1. ravb acts upon "rgmii-*id" (on SoCs that support it[1]),
> >   2. ksz9031 ignored "rgmii-*id", using hardware defaults for skew
> >      values.
> 
> So two bugs which cancelled each other out :-)
> 
> > B. New behavior (broken):
> > 
> >   1. ravb acts upon "rgmii-*id",
> >   2. ksz9031 acts upon "rgmii-*id".
> > 
> > C. Quick fix for v5.8 (workaround, backwards-compatible with old DTB):
> > 
> >   1. ravb acts upon "rgmii-*id", but passes "rgmii" to phy,
> >   2. ksz9031 acts upon "rgmi", using new "rgmii" skew values.
> > 
> > D. Long-term fix:
> 
> I don't know if it is possible, but i would prefer that ravb does
> nothing and the PHY does the delay. The question is, can you get to
> this state without more things breaking?

Some MACs, for example the Atheros AG71XX support delay configuration as
well. But it support also the clock direction. It means (please correct me if
i'm wrong), the MAC can be configured to act as PHY. The same is about
switches, the MAC attached to CPU is act as a PHY and should care about proper
delay configuration.

Regards,
Oleksij

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
