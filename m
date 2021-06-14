Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166833A5BD8
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 05:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhFNDgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 23:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbhFNDgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 23:36:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769F3C061574
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 20:34:16 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lsdMY-0005Ao-C2; Mon, 14 Jun 2021 05:34:10 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lsdMW-0006Ku-15; Mon, 14 Jun 2021 05:34:08 +0200
Date:   Mon, 14 Jun 2021 05:34:08 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v4 8/9] net: dsa: dsa_slave_phy_connect():
 extend phy's flags with port specific phy flags
Message-ID: <20210614033407.jsy5tkhmdpi3wbqc@pengutronix.de>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-9-o.rempel@pengutronix.de>
 <20210611192417.gvfxi2kbfjx4jv3d@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210611192417.gvfxi2kbfjx4jv3d@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 05:32:58 up 193 days, 17:39, 48 users,  load average: 0.00, 0.04,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 10:24:17PM +0300, Vladimir Oltean wrote:
> On Fri, Jun 11, 2021 at 09:15:26AM +0200, Oleksij Rempel wrote:
> > This patch extends the flags of the phy that's being connected with the
> > port specific flags of the switch port.
> > 
> > This is needed to handle a port specific erratum of the KSZ8873 switch,
> > which is added in a later patch.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> 
> What happens differently between having this patch and not having it?

Without this patch, the PHY driver will not get the phyflag provided by the
DSA driver.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
