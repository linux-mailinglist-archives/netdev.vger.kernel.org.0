Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83713E3F2D
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 07:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbhHIFEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 01:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbhHIFEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 01:04:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A8CC061760
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 22:04:12 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mCxSG-000493-8P; Mon, 09 Aug 2021 07:04:04 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1mCxSE-0007sy-6z; Mon, 09 Aug 2021 07:04:02 +0200
Date:   Mon, 9 Aug 2021 07:04:02 +0200
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
Subject: Re: [PATCH net-next v3 5/6] net: dsa: qca: ar9331: add bridge support
Message-ID: <20210809050402.o6l2uu75sslol3la@pengutronix.de>
References: <20210802131037.32326-1-o.rempel@pengutronix.de>
 <20210802131037.32326-6-o.rempel@pengutronix.de>
 <20210807230829.m3eymcwucjtyrgew@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210807230829.m3eymcwucjtyrgew@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:03:27 up 249 days, 19:09, 12 users,  load average: 0.06, 0.04,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 08, 2021 at 02:08:29AM +0300, Vladimir Oltean wrote:
> Hi Oleksij,
> 
> On Mon, Aug 02, 2021 at 03:10:36PM +0200, Oleksij Rempel wrote:
> > This switch is providing forwarding matrix, with it we can configure
> > individual bridges. Potentially we can configure more than one not VLAN
> > based bridge on this HW.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > ---
> 
> I don't see anywhere in this patch or in this series that the
> tag_ar9331.c file is being patched to set skb->offload_fwd_mark to true
> for packets sent (flooded) to the CPU that have already been forwarded
> by the hardware switch. If the software bridge sees a broadcast packet
> coming from your driver and it has offload_fwd_mark = false, it will
> forward it a second time and the other nodes in your network will see
> duplicates.

Ok, thank you, I'll take a look on it.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
