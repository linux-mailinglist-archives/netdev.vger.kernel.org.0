Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E542347148
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 06:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbhCXFyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 01:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbhCXFyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 01:54:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642FBC0613DA
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 22:54:33 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lOwTJ-0002YK-FQ; Wed, 24 Mar 2021 06:54:25 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lOwTI-0002y6-2l; Wed, 24 Mar 2021 06:54:24 +0100
Date:   Wed, 24 Mar 2021 06:54:24 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH v2 0/7] remove different PHY fixups
Message-ID: <20210324055424.u4mbdewg4stndzgh@pengutronix.de>
References: <20210309112615.625-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210309112615.625-1-o.rempel@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:53:31 up 111 days, 19:59, 40 users,  load average: 0.09, 0.05,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shawn,

ping, do this patches need some ACK from some one?

Regards,
Oleksij

On Tue, Mar 09, 2021 at 12:26:08PM +0100, Oleksij Rempel wrote:
> changes v2:
> - rebase against latest kernel
> - fix networking on RIoTBoard
> 
> This patch series tries to remove most of the imx6 and imx7 board
> specific PHY configuration via fixup, as this breaks the PHYs when
> connected to switch chips or USB Ethernet MACs.
> 
> Each patch has the possibility to break boards, but contains a
> recommendation to fix the problem in a more portable and future-proof
> way.
> 
> regards,
> Oleksij
> 
> Oleksij Rempel (7):
>   ARM: imx6q: remove PHY fixup for KSZ9031
>   ARM: imx6q: remove TX clock delay of ar8031_phy_fixup()
>   ARM: imx6q: remove hand crafted PHY power up in ar8035_phy_fixup()
>   ARM: imx6q: remove clk-out fixup for the Atheros AR8031 and AR8035
>     PHYs
>   ARM: imx6q: remove Atheros AR8035 SmartEEE fixup
>   ARM: imx6sx: remove Atheros AR8031 PHY fixup
>   ARM: imx7d: remove Atheros AR8031 PHY fixup
> 
>  arch/arm/boot/dts/imx6dl-riotboard.dts  |  2 +
>  arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts |  2 +-
>  arch/arm/mach-imx/mach-imx6q.c          | 85 -------------------------
>  arch/arm/mach-imx/mach-imx6sx.c         | 26 --------
>  arch/arm/mach-imx/mach-imx7d.c          | 22 -------
>  5 files changed, 3 insertions(+), 134 deletions(-)
> 
> -- 
> 2.29.2
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
