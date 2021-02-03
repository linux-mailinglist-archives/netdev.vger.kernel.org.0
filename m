Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EFA30D632
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 10:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbhBCJYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 04:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbhBCJVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 04:21:06 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58706C0617AB
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 01:19:35 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1l7EJP-0003qt-TT; Wed, 03 Feb 2021 10:18:59 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1l7EJO-0004Q8-1Y; Wed, 03 Feb 2021 10:18:58 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH v1 0/7] remove different PHY fixups 
Date:   Wed,  3 Feb 2021 10:18:50 +0100
Message-Id: <20210203091857.16936-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series tries to remove most of the imx6 and imx7 board
specific PHY configuration via fixup, as this breaks the PHYs when
connected to switch chips or USB Ethernet MACs.

Each patch has the possibility to break boards, but contains a
recommendation to fix the problem in a more portable and future-proof
way.

regards,
Oleksij

Oleksij Rempel (7):
  ARM i.MX6q: remove PHY fixup for KSZ9031
  ARM i.MX6q: remove TX clock delay of ar8031_phy_fixup()
  ARM i.MX6q: remove hand crafted PHY power up in ar8035_phy_fixup()
  ARM i.MX6q: remove clk-out fixup for the Atheros AR8031 and AR8035
    PHYs
  ARM i.MX6q: remove Atheros AR8035 SmartEEE fixup
  ARM: imx6sx: remove Atheros AR8031 PHY fixup
  ARM: imx7d: remove Atheros AR8031 PHY fixup

 arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts |  2 +-
 arch/arm/mach-imx/mach-imx6q.c          | 85 -------------------------
 arch/arm/mach-imx/mach-imx6sx.c         | 26 --------
 arch/arm/mach-imx/mach-imx7d.c          | 22 -------
 4 files changed, 1 insertion(+), 134 deletions(-)

-- 
2.30.0

