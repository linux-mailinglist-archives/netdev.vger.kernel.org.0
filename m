Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA986379EB1
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 06:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhEKEjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 00:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbhEKEj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 00:39:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6769BC061761
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 21:38:21 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lgK9K-0005c0-3A; Tue, 11 May 2021 06:37:38 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lgK9J-0007xq-21; Tue, 11 May 2021 06:37:37 +0200
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
Subject: [PATCH v3 0/7] remove different PHY fixups
Date:   Tue, 11 May 2021 06:37:28 +0200
Message-Id: <20210511043735.30557-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v3:
- split arch and dts changes

changes v2:
- rebase against latest kernel
- fix networking on RIoTBoard

This patch series tries to remove most of the imx6 and imx7 board
specific PHY configuration via fixup, as this breaks the PHYs when
connected to switch chips or USB Ethernet MACs.

Each patch has the possibility to break boards, but contains a
recommendation to fix the problem in a more portable and future-proof
way.

Oleksij Rempel (7):
  ARM i.MX6q: remove PHY fixup for KSZ9031
  ARM i.MX6q: remove part of ar8031_phy_fixup()
  ARM i.MX6q: remove BMCR_PDOWN handler in ar8035_phy_fixup()
  ARM i.MX6q: remove clk-out fixup for the Atheros AR8031 and AR8035
    PHYs
  ARM i.MX6q: remove Atheros AR8035 SmartEEE fixup
  ARM: imx6sx: remove Atheros AR8031 PHY fixup
  ARM: imx7d: remove Atheros AR8031 PHY fixup

 arch/arm/mach-imx/mach-imx6q.c  | 85 ---------------------------------
 arch/arm/mach-imx/mach-imx6sx.c | 26 ----------
 arch/arm/mach-imx/mach-imx7d.c  | 22 ---------
 3 files changed, 133 deletions(-)

-- 
2.29.2

