Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C13A36D444
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 10:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237110AbhD1IwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 04:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhD1IwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 04:52:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82E9C061574
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 01:51:18 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lbfuf-0003Qd-8A; Wed, 28 Apr 2021 10:51:17 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lbfud-00013v-7s; Wed, 28 Apr 2021 10:51:15 +0200
Date:   Wed, 28 Apr 2021 10:51:15 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        Shawn Guo <shawnguo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v3 0/6] provide generic net selftest support
Message-ID: <20210428085115.mehvsj2vlqmbmib5@pengutronix.de>
References: <20210419130106.6707-1-o.rempel@pengutronix.de>
 <DB8PR04MB67951B9C6AB1620E807205F2E6459@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210423043729.tup7nntmmyv6vurm@pengutronix.de>
 <DB8PR04MB6795479FBF086751D16080E2E6419@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <6416c580-0df9-7d36-c42d-65293c40aa25@gmail.com>
 <DB8PR04MB6795AD745C2B27B6AC68497EE6409@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB8PR04MB6795AD745C2B27B6AC68497EE6409@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:45:15 up 146 days, 22:51, 47 users,  load average: 0.08, 0.06,
 0.07
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 08:06:05AM +0000, Joakim Zhang wrote:
> 
> Hi Florian,
> 
> > -----Original Message-----
> > From: Florian Fainelli <f.fainelli@gmail.com>
> > Sent: 2021年4月28日 0:41
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>; Oleksij Rempel
> > <o.rempel@pengutronix.de>
> > Cc: Shawn Guo <shawnguo@kernel.org>; Sascha Hauer
> > <s.hauer@pengutronix.de>; Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit
> > <hkallweit1@gmail.com>; Fugang Duan <fugang.duan@nxp.com>;
> > kernel@pengutronix.de; netdev@vger.kernel.org;
> > linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> > dl-linux-imx <linux-imx@nxp.com>; Fabio Estevam <festevam@gmail.com>;
> > David Jander <david@protonic.nl>; Russell King <linux@armlinux.org.uk>;
> > Philippe Schenker <philippe.schenker@toradex.com>
> > Subject: Re: [PATCH net-next v3 0/6] provide generic net selftest support
> > 
> > 
> > 
> > On 4/26/2021 9:48 PM, Joakim Zhang wrote:
> > >
> > >> -----Original Message-----
> > >> From: Oleksij Rempel <o.rempel@pengutronix.de>
> > >> Sent: 2021年4月23日 12:37
> > >> To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > >> Cc: Shawn Guo <shawnguo@kernel.org>; Sascha Hauer
> > >> <s.hauer@pengutronix.de>; Andrew Lunn <andrew@lunn.ch>; Florian
> > >> Fainelli <f.fainelli@gmail.com>; Heiner Kallweit
> > >> <hkallweit1@gmail.com>; Fugang Duan <fugang.duan@nxp.com>;
> > >> kernel@pengutronix.de; netdev@vger.kernel.org;
> > >> linux-arm-kernel@lists.infradead.org;
> > >> linux-kernel@vger.kernel.org; dl-linux-imx <linux-imx@nxp.com>; Fabio
> > >> Estevam <festevam@gmail.com>; David Jander <david@protonic.nl>;
> > >> Russell King <linux@armlinux.org.uk>; Philippe Schenker
> > >> <philippe.schenker@toradex.com>
> > >> Subject: Re: [PATCH net-next v3 0/6] provide generic net selftest
> > >> support
> > >>
> > >> Hi Joakim,
> > >>
> > >> On Fri, Apr 23, 2021 at 03:18:32AM +0000, Joakim Zhang wrote:
> > >>>
> > >>> Hi Oleksij,
> > >>>
> > >>> I look both stmmac selftest code and this patch set. For stmmac, if
> > >>> PHY
> > >> doesn't support loopback, it will fallthrough to MAC loopback.
> > >>> You provide this generic net selftest support based on PHY loopback,
> > >>> I have a
> > >> question, is it possible to extend it also support MAC loopback later?
> > >>
> > >> Yes. If you have interest and time to implement it, please do.
> > >> It should be some kind of generic callback as phy_loopback() and if
> > >> PHY and MAC loopbacks are supported we need to tests both variants.
> > > Hi Oleksij,
> > >
> > > Yes, I can try to implement it when I am free, but I still have some questions:
> > > 1. Where we place the generic function? Such as mac_loopback().
> > > 2. MAC is different from PHY, need program different registers to enable
> > loopback on different SoCs, that means we need get MAC private data from
> > "struct net_device".
> > > So we need a callback for MAC drivers, where we extend this callback? Could
> > be "struct net_device_ops"? Such as ndo_set_loopback?
> > 
> > Even for PHY devices, if we implemented external PHY loopback in the future,
> > the programming would be different from one vendor to another. I am starting
> > to wonder if the existing ethtool self-tests are the best API to expose the ability
> > for an user to perform PHY and MAC loopback testing.
> > 
> > From an Ethernet MAC and PHY driver perspective, what I would imagine we
> > could have for a driver API is:
> > 
> > enum ethtool_loopback_mode {
> > 	ETHTOOL_LOOPBACK_OFF,
> > 	ETHTOOL_LOOPBACK_PHY_INTERNAL,
> > 	ETHTOOL_LOOPBACK_PHY_EXTERNAL,
> > 	ETHTOOL_LOOPBACK_MAC_INTERNAL,
> > 	ETHTOOL_LOOPBACK_MAC_EXTERNAL,
> > 	ETHTOOL_LOOPBACK_FIXTURE,
> > 	__ETHTOOL_LOOPBACK_MAX
> > };
> 
> What's the difference between internal and external loopback for both PHY and MAC? I am not familiar with these concepts. Thanks.

For example KSZ9031 PHY. It supports two loopback modes. See page 23:
https://ww1.microchip.com/downloads/en/DeviceDoc/00002096E.pdf

TI DP83TC811R-Q1 PHY supports 4 modes. See page 27:
https://www.ti.com/lit/ds/symlink/dp83tc811r-q1.pdf


> Best Regards,
> Joakim Zhang
> > 	int (*ndo_set_loopback_mode)(struct net_device *dev, enum
> > ethtool_loopback_mode mode);
> > 
> > and within the Ethernet MAC driver you would do something like this:
> > 
> > 	switch (mode) {
> > 	case ETHTOOL_LOOPBACK_PHY_INTERNAL:
> > 	case ETHTOOL_LOOPBACK_PHY_EXTERNAL:
> > 	case ETHTOOL_LOOPBACK_OFF:
> > 		ret = phy_loopback(ndev->phydev, mode);
> > 		break;
> > 	/* Other case statements implemented in driver */
> > 
> > we would need to change the signature of phy_loopback() to accept being
> > passed ethtool_loopback_mode so we can support different modes.
> > 
> > Whether we want to continue using the self-tests API, or if we implement a
> > new ethtool command in order to request a loopback operation is up for
> > discussion.
> > --
> > Florian

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
