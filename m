Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D8C3D3EDC
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbhGWQwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbhGWQw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 12:52:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A196AC061757
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 10:33:00 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m6z2g-0006L1-EF; Fri, 23 Jul 2021 19:32:58 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1m6z2f-0000ZZ-7L; Fri, 23 Jul 2021 19:32:57 +0200
Date:   Fri, 23 Jul 2021 19:32:57 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     alexandru.tachici@analog.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH v2 0/7] net: phy: adin1100: Add initial support for
 ADIN1100 industrial PHY
Message-ID: <20210723173257.66g3epaszn7qwrvd@pengutronix.de>
References: <20210712130631.38153-1-alexandru.tachici@analog.com>
 <20210712133358.GD22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210712133358.GD22278@shell.armlinux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:23:37 up 233 days,  7:30, 27 users,  load average: 0.11, 0.09,
 0.08
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 02:33:58PM +0100, Russell King (Oracle) wrote:
> On Mon, Jul 12, 2021 at 04:06:24PM +0300, alexandru.tachici@analog.com wrote:
> > From: Alexandru Tachici <alexandru.tachici@analog.com>
> > 
> > The ADIN1100 is a low power single port 10BASE-T1L transceiver designed for
> > industrial Ethernet applications and is compliant with the IEEE 802.3cg
> > Ethernet standard for long reach 10 Mb/s Single Pair Ethernet.
> > 
> > Ethtool output:
> >         Settings for eth1:
> >         Supported ports: [ TP	 MII ]
> >         Supported link modes:   10baseT1L/Full
> >                                 2400mv
> >                                 1000mv
> 
> The SI unit of voltage is V not v, so milli-volts is mV not mv. Surely,
> at the very least, we should be using the SI designation in user
> visible strings?
> 
> It may also be worth providing a brief description of 10BASE-T1L in the
> cover letter so (e.g.) one doesn't have to look up the fact that the
> voltage level is negotiated via bit 13 of the base page. I've found
> that by searching google and finding dp83td510e.pdf

I'm curios how the voltage should be actually chosen?

In the adin1100 datasheet i read:
"The 1.0 V pk-pk operating mode, external termination resistors and independent
Rx/Tx pins make the ADIN1100 suited to intrinsic safety applications"

"For long reach/trunk applications the higher transmit amplitude of 2.4 V pk-pk"

So, it seems to depends on:
- do we have safety requirements?
- how long is the cable?

Can we use 2.4V any time if it is available or it is bad idea for short
cables?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
