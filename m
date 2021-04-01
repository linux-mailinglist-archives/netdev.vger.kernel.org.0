Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9354F351051
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 09:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhDAHsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 03:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbhDAHr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 03:47:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4E2C0613E6
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 00:47:58 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lRs3V-0001u2-GP; Thu, 01 Apr 2021 09:47:53 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lRs3T-000588-IB; Thu, 01 Apr 2021 09:47:51 +0200
Date:   Thu, 1 Apr 2021 09:47:51 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v1 3/3] net: fec: add basic selftest support
Message-ID: <20210401074751.so4m7k3pnhcjeofx@pengutronix.de>
References: <20210330135407.17010-1-o.rempel@pengutronix.de>
 <20210330135407.17010-4-o.rempel@pengutronix.de>
 <YGRqpxefTxZjqp6w@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YGRqpxefTxZjqp6w@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:44:36 up 119 days, 21:50, 47 users,  load average: 0.01, 0.04,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 02:27:19PM +0200, Andrew Lunn wrote:
> On Tue, Mar 30, 2021 at 03:54:07PM +0200, Oleksij Rempel wrote:
> > Port some parts of the stmmac selftest to the FEC. This patch was tested
> > on iMX6DL.
> > With this tests it is possible to detect some basic issues like:
> > - MAC loopback fail: most probably wrong clock configuration.
> > - PHY loopback fail: incorrect RGMII timings, damaged traces, etc
> 
> Hi
> 
> Oleksij
> 
> I've not done a side-by-side diff with stmmac, but i guess a lot of
> this code is identical?

ack

> Rather than make a copy/paste, could you move
> it somewhere under net and turn it into a library any driver can use?

yes, I assume, it is possible to make this code complete generic for all
devices, but we will need to provide some more call backs. For example
enable MAC loop back, enable DSA loopbacks and so on.

Do you have ideas for the new location of generic selftest code and
where  can be added loopback options for different levels?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
