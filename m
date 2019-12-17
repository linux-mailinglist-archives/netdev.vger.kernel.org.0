Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBCC122D0F
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbfLQNjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:39:10 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56726 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfLQNjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:39:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=h9KtRx87c908YYM+VrgI+IEy4kBALbbkEDmu+ITY3rk=; b=ApDqTkyw5mv1PRT8JzCZeF82sC
        lJ15AUg25W9XPlA2nrOV83G2Ojm7bJtkZ7/tQJx9xllHYdXlYN/AJMzfGiqApyv848VNnLRFCoZCW
        Wj8TppfyuD5xLUfsutj+1+szmale3c6sWbgFeJbHoMu/l0dnTjavB+KuvlBm110dGQU3jRHfMgl7w
        +rrt8gj/pP8d/3/NEu5014owxxvA0LZ3kDUS9OR70PMKfEPiAkiupQAnayErpibYR1vcPIu40wirY
        6Pf7LN/TwXJdqa2BGr3zdREbkgbFuVWyE453D4SG/hHn81/FudmFTmTFM4K/Tf/m5MIi2k4xritZI
        pO6PW54A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:51622 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD41-0006EW-Gb; Tue, 17 Dec 2019 13:39:01 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD40-0001yI-Ss; Tue, 17 Dec 2019 13:39:00 +0000
In-Reply-To: <20191217133827.GQ25745@shell.armlinux.org.uk>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 01/11] net: phy: remove redundant .aneg_done
 initialisers
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ihD40-0001yI-Ss@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Dec 2019 13:39:00 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove initialisers that set .aneg_done to genphy_aneg_done - this is
the default for clause 22 PHYs, so the initialiser is redundant.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/mscc.c       | 6 ------
 drivers/net/phy/phy_device.c | 1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 7ada1fd9ca71..374d71c3560b 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -2352,7 +2352,6 @@ static struct phy_driver vsc85xx_driver[] = {
 	.soft_reset	= &genphy_soft_reset,
 	.config_init	= &vsc85xx_config_init,
 	.config_aneg    = &vsc85xx_config_aneg,
-	.aneg_done	= &genphy_aneg_done,
 	.read_status	= &vsc85xx_read_status,
 	.ack_interrupt	= &vsc85xx_ack_interrupt,
 	.config_intr	= &vsc85xx_config_intr,
@@ -2377,7 +2376,6 @@ static struct phy_driver vsc85xx_driver[] = {
 	.soft_reset	= &genphy_soft_reset,
 	.config_init    = &vsc85xx_config_init,
 	.config_aneg    = &vsc85xx_config_aneg,
-	.aneg_done	= &genphy_aneg_done,
 	.read_status	= &vsc85xx_read_status,
 	.ack_interrupt  = &vsc85xx_ack_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
@@ -2402,7 +2400,6 @@ static struct phy_driver vsc85xx_driver[] = {
 	.soft_reset	= &genphy_soft_reset,
 	.config_init	= &vsc85xx_config_init,
 	.config_aneg	= &vsc85xx_config_aneg,
-	.aneg_done	= &genphy_aneg_done,
 	.read_status	= &vsc85xx_read_status,
 	.ack_interrupt	= &vsc85xx_ack_interrupt,
 	.config_intr	= &vsc85xx_config_intr,
@@ -2427,7 +2424,6 @@ static struct phy_driver vsc85xx_driver[] = {
 	.soft_reset	= &genphy_soft_reset,
 	.config_init    = &vsc85xx_config_init,
 	.config_aneg    = &vsc85xx_config_aneg,
-	.aneg_done	= &genphy_aneg_done,
 	.read_status	= &vsc85xx_read_status,
 	.ack_interrupt  = &vsc85xx_ack_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
@@ -2452,7 +2448,6 @@ static struct phy_driver vsc85xx_driver[] = {
 	.soft_reset	= &genphy_soft_reset,
 	.config_init    = &vsc8584_config_init,
 	.config_aneg    = &vsc85xx_config_aneg,
-	.aneg_done	= &genphy_aneg_done,
 	.read_status	= &vsc85xx_read_status,
 	.ack_interrupt  = &vsc85xx_ack_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
@@ -2478,7 +2473,6 @@ static struct phy_driver vsc85xx_driver[] = {
 	.soft_reset	= &genphy_soft_reset,
 	.config_init    = &vsc8584_config_init,
 	.config_aneg    = &vsc85xx_config_aneg,
-	.aneg_done	= &genphy_aneg_done,
 	.read_status	= &vsc85xx_read_status,
 	.ack_interrupt  = &vsc85xx_ack_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 7350ea7a8cb6..e9520e065691 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2452,7 +2452,6 @@ static struct phy_driver genphy_driver = {
 	.name		= "Generic PHY",
 	.soft_reset	= genphy_no_soft_reset,
 	.get_features	= genphy_read_abilities,
-	.aneg_done	= genphy_aneg_done,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 	.set_loopback   = genphy_loopback,
-- 
2.20.1

