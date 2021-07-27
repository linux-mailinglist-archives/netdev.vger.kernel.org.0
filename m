Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3AB3D6F78
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 08:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhG0Gbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 02:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbhG0Gba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 02:31:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1C2C061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 23:31:31 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m8Gcj-00049b-Mq; Tue, 27 Jul 2021 08:31:29 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1m8Gci-0007Pa-C6; Tue, 27 Jul 2021 08:31:28 +0200
Date:   Tue, 27 Jul 2021 08:31:28 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     alexandru.tachici@analog.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: Re: [PATCH v2 3/7] net: phy: adin1100: Add initial support for
 ADIN1100 industrial PHY
Message-ID: <20210727063128.7ralgt4n6lbk7c2e@pengutronix.de>
References: <20210712130631.38153-1-alexandru.tachici@analog.com>
 <20210712130631.38153-4-alexandru.tachici@analog.com>
 <YO3GNqqUbyxId+Mn@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YO3GNqqUbyxId+Mn@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:30:30 up 236 days, 20:36, 14 users,  load average: 0.13, 0.10,
 0.03
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 06:58:30PM +0200, Andrew Lunn wrote:
> > +static const int phy_10_features_array[] = {
> > +	ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
> 
> Does you device implement ETHTOOL_LINK_MODE_10baseT1L_Half_BIT? I'm
> assuming half duplex is part of the standard?

No, there is no ETHTOOL_LINK_MODE_10baseT1L_Half_BIT according to
802.3cg-2019.

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
