Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3963575E8
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356284AbhDGUZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356091AbhDGUXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:23:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F250D611C1;
        Wed,  7 Apr 2021 20:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617827024;
        bh=hAvCfLCkBUvIsNZca5EkKhAM/mZQHGOhR0RQDN3T/FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUvIIF0X4hXF+ART5z+5SbEz84TJ71rltb6quvF522QS5m5PZeUh9hXzeDiZ2LlQv
         YfF8tvWGExf11eNb2SD8mGPxxpm2SajVEnfHolzvM0NJ31AK1Hqkzxx/v3zNMbzAZq
         i6eLpHx51MCKCdxdnaa8TzwDX2ldJejKMLyGdqL31s11ylNfA50PFMWrq1MtyitcZ/
         R9+G31lFYcMLfbx4g1D0IjjZiUsjXn8I+zw4yTmipwfkptI6OZAB/Ceedktez4asqT
         5jzaGfVOhLxB7tOWsFsu9VWvP9XW9Cg5UlB2RcCTw7JmAS+wGCzVw2bhW5hZqYN+Zb
         3MOwOksAdfEDg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 06/16] net: phy: marvell10g: add MACTYPE definitions for 88E21xx
Date:   Wed,  7 Apr 2021 22:22:44 +0200
Message-Id: <20210407202254.29417-7-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407202254.29417-1-kabel@kernel.org>
References: <20210407202254.29417-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add all MACTYPE definitions for 88E2110, 88E2180, 88E2111 and 88E2181.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/marvell10g.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 7d9a45437b69..556c9b43860e 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -35,6 +35,15 @@
 enum {
 	MV_PMA_FW_VER0		= 0xc011,
 	MV_PMA_FW_VER1		= 0xc012,
+	MV_PMA_21X0_PORT_CTRL	= 0xc04a,
+	MV_PMA_21X0_PORT_CTRL_SWRST				= BIT(15),
+	MV_PMA_21X0_PORT_CTRL_MACTYPE_MASK			= 0x7,
+	MV_PMA_21X0_PORT_CTRL_MACTYPE_USXGMII			= 0x0,
+	MV_PMA_2180_PORT_CTRL_MACTYPE_DXGMII			= 0x1,
+	MV_PMA_2180_PORT_CTRL_MACTYPE_QXGMII			= 0x2,
+	MV_PMA_21X0_PORT_CTRL_MACTYPE_5GBASER			= 0x4,
+	MV_PMA_21X0_PORT_CTRL_MACTYPE_5GBASER_NO_SGMII_AN	= 0x5,
+	MV_PMA_21X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH	= 0x6,
 	MV_PMA_BOOT		= 0xc050,
 	MV_PMA_BOOT_FATAL	= BIT(0),
 
-- 
2.26.2

