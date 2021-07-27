Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A983D6FB3
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 08:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbhG0Gvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 02:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235542AbhG0Gvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 02:51:53 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126F6C061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 23:51:54 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m8GwS-0006AV-A7; Tue, 27 Jul 2021 08:51:52 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1m8GwR-0007uw-BZ; Tue, 27 Jul 2021 08:51:51 +0200
Date:   Tue, 27 Jul 2021 08:51:51 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Dan Murphy <dmurphy@ti.com>, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: phy: dp83td510: Add basic support
 for the DP83TD510 Ethernet PHY
Message-ID: <20210727065151.l6qm36onaljol4sq@pengutronix.de>
References: <20210723104218.25361-1-o.rempel@pengutronix.de>
 <YPrCiIz7baU26kLU@lunn.ch>
 <20210723170848.lh3l62l7spcyphly@pengutronix.de>
 <YPsGddTXtk/Hinmp@lunn.ch>
 <20210726121851.u3flif2opshwgz5e@pengutronix.de>
 <YP63NBaurhQ2Itse@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YP63NBaurhQ2Itse@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:24:39 up 236 days,  4:31, 14 users,  load average: 0.03, 0.05,
 0.04
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 03:23:00PM +0200, Andrew Lunn wrote:
> > With current driver ethtool with show this information:
> > Settings for eth1:
> > 	Supported ports: [ TP	 MII ]
> > 	Supported link modes:   Not reported
> 
> Interesting. The default function for getting the PHYs abilities is
> doing better than i expected. I was guessing you would see 10BaseT
> here.
> 
> Given that, what you have is O.K. for the moment. 
> 
> > > I suspect you are talking about the PoE aspects. That is outside the
> > > scope for phylib. PoE in general is not really supported in the Linux
> > > kernel, and probably needs a subsystem of its own.
> > 
> > No, no. I'm talking about data signals configuration (2.4Vpp/1Vpp), which
> > depends on application and cable length. 1Vpp should not be used with
> > cable over 200 meter
> 
> Should not be used, or is not expected to work very well?

ack, it will not work very well :)

> > and 2.4Vpp should not be used on safety critical applications. 
> 
> Please work with the other T1L driver writer to propose a suitable way
> to configure this. We want all T1L drivers to use the same
> configuration method, DT properties etc.

ack.

After getting 802.3cg-2019 i give NACK to my patch. At least part
of all needed functionality can be implemented as common code.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
