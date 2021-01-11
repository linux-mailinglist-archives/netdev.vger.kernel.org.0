Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8ED2F1026
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 11:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbhAKKdC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 11 Jan 2021 05:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728959AbhAKKdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 05:33:01 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA53C061794
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 02:32:21 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kyuUh-0002Iu-V7; Mon, 11 Jan 2021 11:32:15 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1kyuUg-0007sF-4C; Mon, 11 Jan 2021 11:32:14 +0100
Date:   Mon, 11 Jan 2021 11:32:14 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v7 net-next 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20210111103214.zsradoj5t6drgp73@pengutronix.de>
References: <20210107125613.19046-1-o.rempel@pengutronix.de>
 <20210107125613.19046-3-o.rempel@pengutronix.de>
 <X/ccfY+9a8R6wcJX@lunn.ch>
 <20210108053228.2efctejqxbqijm6l@pengutronix.de>
 <20210109002143.r4aokvewrgwv3qqv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20210109002143.r4aokvewrgwv3qqv@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:27:20 up 40 days, 33 min, 29 users,  load average: 0.09, 0.10,
 0.12
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 09, 2021 at 02:21:43AM +0200, Vladimir Oltean wrote:
> On Fri, Jan 08, 2021 at 06:32:28AM +0100, Oleksij Rempel wrote:
> > May be the "net: dsa: add optional stats64 support" can already be
> > taken?
> 
> I'm not sure that I see the point. David and Jakub won't cherry-pick
> partial series, and if you resend just patch 1/2, they won't accept new
> code that doesn't have any callers.
> 
> You don't have to wait for my series if you don't want to. If you're
> going to conflict with it anyway (it changes the prototype of
> ndo_get_stats64), you might as well not wait. I don't know when, or if,
> it's going to be over with it. It is going to take at least one more
> respin since it now conflicts with net.git commit 9f9d41f03bb0 ("docs:
> net: fix documentation on .ndo_get_stats") merged a few hours ago into
> net-next. So just say which way it is that you prefer.

Ok, thx. If no one is against it, i'll prefer to push this patches now.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
