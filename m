Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A21D368C3B
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 06:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhDWEiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 00:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhDWEiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 00:38:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FA8C061574
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 21:37:38 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lZnZL-0002Kh-Tg; Fri, 23 Apr 2021 06:37:31 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lZnZJ-0005tt-8w; Fri, 23 Apr 2021 06:37:29 +0200
Date:   Fri, 23 Apr 2021 06:37:29 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v3 0/6] provide generic net selftest support
Message-ID: <20210423043729.tup7nntmmyv6vurm@pengutronix.de>
References: <20210419130106.6707-1-o.rempel@pengutronix.de>
 <DB8PR04MB67951B9C6AB1620E807205F2E6459@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB8PR04MB67951B9C6AB1620E807205F2E6459@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:06:48 up 141 days, 18:13, 35 users,  load average: 0.09, 0.05,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joakim,

On Fri, Apr 23, 2021 at 03:18:32AM +0000, Joakim Zhang wrote:
> 
> Hi Oleksij,
> 
> I look both stmmac selftest code and this patch set. For stmmac, if PHY doesn't support loopback, it will fallthrough to MAC loopback.
> You provide this generic net selftest support based on PHY loopback, I have a question, is it possible to extend it also support MAC loopback later?

Yes. If you have interest and time to implement it, please do.
It should be some kind of generic callback as phy_loopback() and if PHY
and MAC loopbacks are supported we need to tests both variants.

Best regards,
Oleksij

> > -----Original Message-----
> > From: Oleksij Rempel <o.rempel@pengutronix.de>
> > Sent: 2021年4月19日 21:01
> > To: Shawn Guo <shawnguo@kernel.org>; Sascha Hauer
> > <s.hauer@pengutronix.de>; Andrew Lunn <andrew@lunn.ch>; Florian Fainelli
> > <f.fainelli@gmail.com>; Heiner Kallweit <hkallweit1@gmail.com>; Fugang
> > Duan <fugang.duan@nxp.com>
> > Cc: Oleksij Rempel <o.rempel@pengutronix.de>; kernel@pengutronix.de;
> > netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> > linux-kernel@vger.kernel.org; dl-linux-imx <linux-imx@nxp.com>; Fabio
> > Estevam <festevam@gmail.com>; David Jander <david@protonic.nl>; Russell
> > King <linux@armlinux.org.uk>; Philippe Schenker
> > <philippe.schenker@toradex.com>
> > Subject: [PATCH net-next v3 0/6] provide generic net selftest support
> > 
> > changes v3:
> > - make more granular tests
> > - enable loopback for all PHYs by default
> > - fix allmodconfig build errors
> > - poll for link status update after switching to the loopback mode
> > 
> > changes v2:
> > - make generic selftests available for all networking devices.
> > - make use of net_selftest* on FEC, ag71xx and all DSA switches.
> > - add loopback support on more PHYs.
> > 
> > This patch set provides diagnostic capabilities for some iMX, ag71xx or any DSA
> > based devices. For proper functionality, PHY loopback support is needed.
> > So far there is only initial infrastructure with basic tests.
> > 
> > Oleksij Rempel (6):
> >   net: phy: execute genphy_loopback() per default on all PHYs
> >   net: phy: genphy_loopback: add link speed configuration
> >   net: add generic selftest support
> >   net: fec: make use of generic NET_SELFTESTS library
> >   net: ag71xx: make use of generic NET_SELFTESTS library
> >   net: dsa: enable selftest support for all switches by default
> > 
> >  drivers/net/ethernet/atheros/Kconfig      |   1 +
> >  drivers/net/ethernet/atheros/ag71xx.c     |  20 +-
> >  drivers/net/ethernet/freescale/Kconfig    |   1 +
> >  drivers/net/ethernet/freescale/fec_main.c |   7 +
> >  drivers/net/phy/phy.c                     |   3 +-
> >  drivers/net/phy/phy_device.c              |  35 +-
> >  include/linux/phy.h                       |   1 +
> >  include/net/dsa.h                         |   2 +
> >  include/net/selftests.h                   |  12 +
> >  net/Kconfig                               |   4 +
> >  net/core/Makefile                         |   1 +
> >  net/core/selftests.c                      | 400
> > ++++++++++++++++++++++
> >  net/dsa/Kconfig                           |   1 +
> >  net/dsa/slave.c                           |  21 ++
> >  14 files changed, 500 insertions(+), 9 deletions(-)  create mode 100644
> > include/net/selftests.h  create mode 100644 net/core/selftests.c
> > 
> > --
> > 2.29.2
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
