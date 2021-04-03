Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F4035341F
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 15:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbhDCN0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 09:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhDCN0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 09:26:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBEAC0613E6
        for <netdev@vger.kernel.org>; Sat,  3 Apr 2021 06:26:45 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lSgIR-0000ze-EP; Sat, 03 Apr 2021 15:26:39 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lSgIO-00064V-9v; Sat, 03 Apr 2021 15:26:36 +0200
Date:   Sat, 3 Apr 2021 15:26:36 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, linux-mips@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/9] net: dsa: tag_ar9331: detect IGMP and
 MLD packets
Message-ID: <20210403132636.h7ghwk2eaekskx2b@pengutronix.de>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-3-o.rempel@pengutronix.de>
 <20210403130318.lqkd6id7gehg3bin@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210403130318.lqkd6id7gehg3bin@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:23:49 up 122 days,  3:30, 32 users,  load average: 0.17, 0.07,
 0.03
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 04:03:18PM +0300, Vladimir Oltean wrote:
> Hi Oleksij,
> 
> On Sat, Apr 03, 2021 at 01:48:41PM +0200, Oleksij Rempel wrote:
> > The ar9331 switch is not forwarding IGMP and MLD packets if IGMP
> > snooping is enabled. This patch is trying to mimic the HW heuristic to take
> > same decisions as this switch would do to be able to tell the linux
> > bridge if some packet was prabably forwarded or not.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> 
> I am not familiar with IGMP/MLD, therefore I don't really understand
> what problem you are trying to solve.
> 
> Your switch has packet traps for IGMP and MLD, ok. So it doesn't forward
> them. Must the IGMP/MLD packets be forwarded by an IGMP/MLD snooping
> bridge? Which ones and under what circumstances?

I'll better refer to the rfc:
https://tools.ietf.org/html/rfc4541

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
