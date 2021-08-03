Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84193DE6C4
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 08:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbhHCGgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 02:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbhHCGgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 02:36:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287D2C06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 23:36:35 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mAo2M-0008BD-Rf; Tue, 03 Aug 2021 08:36:26 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1mAo2L-0006db-Od; Tue, 03 Aug 2021 08:36:25 +0200
Date:   Tue, 3 Aug 2021 08:36:25 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/6] net: dsa: qca: ar9331: make proper
 initial port defaults
Message-ID: <20210803063625.k6it72ny2ikrxjak@pengutronix.de>
References: <20210802131037.32326-1-o.rempel@pengutronix.de>
 <20210802131037.32326-3-o.rempel@pengutronix.de>
 <20210802140345.zreovwix6nuyjwjy@skbuf>
 <YQhLSg3Vr1pvVHsW@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YQhLSg3Vr1pvVHsW@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:35:27 up 243 days, 20:41, 14 users,  load average: 0.24, 0.10,
 0.05
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 09:45:14PM +0200, Andrew Lunn wrote:
> > > +/* AGE_TIME_COEF is not documented. This is "works for me" value */
> > > +#define AR9331_SW_AT_AGE_TIME_COEF		6900
> > 
> > Not documented, not used either, it seems.
> > "Works for you" based on what?
> 
> It is used in a later patch. Ideally it would of been introduced in
> that patch to make this more obvious.

ack, i'll move it from this patch

> > >  #define AR9331_SW_REG_MDIO_CTRL			0x98
> > >  #define AR9331_SW_MDIO_CTRL_BUSY		BIT(31)
> > >  #define AR9331_SW_MDIO_CTRL_MASTER_EN		BIT(30)
> > > @@ -101,6 +111,46 @@
> > >  	 AR9331_SW_PORT_STATUS_RX_FLOW_EN | AR9331_SW_PORT_STATUS_TX_FLOW_EN | \
> > >  	 AR9331_SW_PORT_STATUS_SPEED_M)
> > 
> > Is this patch material for "net"? If standalone ports is all that ar9331
> > supports, then it would better not do packet forwarding in lack of a
> > bridge device.
> 
> It does seem like this patch should be considered for stable, if by
> default all ports can talk with all ports when not part of a bridge.

ack, i'll split this patch set

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
