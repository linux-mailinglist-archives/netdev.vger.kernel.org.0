Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0D42CEEE6
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 14:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbgLDNk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 08:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729606AbgLDNk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 08:40:56 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E42C061A51
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 05:40:16 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1klBJi-0005IX-If; Fri, 04 Dec 2020 14:40:10 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1klBJh-0004az-2O; Fri, 04 Dec 2020 14:40:09 +0100
Date:   Fri, 4 Dec 2020 14:40:09 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201204134009.q6alw6t2pk22saak@pengutronix.de>
References: <20201202140904.24748-1-o.rempel@pengutronix.de>
 <20201202140904.24748-3-o.rempel@pengutronix.de>
 <20201202104207.697cfdbb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201203085011.GA3606@pengutronix.de>
 <20201203083517.3b616782@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201203175320.f3fmyaqoxifydwzv@pengutronix.de>
 <20201203180140.4puwxgailw2iysxz@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201203180140.4puwxgailw2iysxz@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:32:17 up 2 days,  3:38, 24 users,  load average: 0.01, 0.02, 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 08:01:40PM +0200, Vladimir Oltean wrote:
> On Thu, Dec 03, 2020 at 06:53:20PM +0100, Oleksij Rempel wrote:
> > It is possible to poll it more frequently, but  it make no reals sense
> > on this low power devices.
> 
> Frankly I thought you understood the implications of periodic polling
> and you're ok with them,

I added polling to read out small counters to avoid overflow.

> just wanting to have _something_.

Having something is good, but making it good is better :D

> But fine,
> welcome to my world, happy to have you onboard...
> 
> > What kind of options do we have?
> 
> https://www.spinics.net/lists/netdev/msg703774.html
> https://www.spinics.net/lists/netdev/msg704370.html
> 
> Unfortunately I've been absolutely snowed under with work lately. I hope
> to be able to come back to that during the weekend or something like that.

Ok, so the strategy is to fix the original issue. Sound good.

For now I'll resend this patches without accessing mdio regs from the
stats64 callback. It will give initial play ground, so we can see what
else should be done for DSA specific use case.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
