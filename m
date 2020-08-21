Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4F424CF27
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgHUHWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:22:39 -0400
Received: from mx1.tq-group.com ([62.157.118.193]:44582 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728270AbgHUHWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 03:22:31 -0400
IronPort-SDR: PvpX4vLHoB6c9cGWXR+HM20NT9r22FGsrYRI3utjSvWfg16ftQ5T6XYs86nxtN3Xy/Gr9H84f8
 R0f9vzRkx9AF45foI7mKFqbB0GwehklXFftO6AP07M/MZcavuTmEMDZ//LmJxXZ8fHPg5RVtb+
 Xu8bF+vyj5wPwW4aeQgZfTu9oP6/mrN15eYA7lAQ672VqX8Wndgao364ec3jGs+SjcLWjc2Az9
 QJYHA5gXCT+1U8gGbBJVb4GfOujTfNYFKaRNEnC2/V48U3DgKblVqwdOxJEiSH1ERTxfhVi5kP
 6CM=
X-IronPort-AV: E=Sophos;i="5.76,335,1592863200"; 
   d="scan'208";a="13549384"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 21 Aug 2020 09:22:26 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 21 Aug 2020 09:22:29 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Fri, 21 Aug 2020 09:22:29 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1597994546; x=1629530546;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=C2YxwjDhmsC3RZPpcsF1SDGKY5Ul1PexKxYtX5L1/3k=;
  b=jgau/tGjIKIdGMdRG+L7p1JwJvunKAAj1PU8Xcc22sDGkoeVRXCOahTC
   d3slq2Q7WRF/xbsa7osaR8q5mCmUS9OEr08fXK/4NFD726eA+VkJ+ryA5
   FYb7cL4OZlH9L4wtmccL/PlNNdw76V83IJj0cLpJwF+tufY9bPtrq9ekr
   cK+exIP1tw5kf221mYJqvemcIpNntV/koJ1DSQrOVVI9zBvwo8kG7WHt3
   ex2oNYcJ8YvxgwGrA3bra0TpEvfKJCKgpJehd/QYxEiyZNyZk5eugVk/K
   BPyfBE7wqJuM9qpL9/pFgZHycJwP7U9joIL63gkoP4YC0Nf7wYM+s2SRO
   g==;
IronPort-SDR: SUKNibXxzv1XPL+UiPJeYZeyVofAQBX+xqiik/VINdxgi6Yea2TV1bKh2HGlBICHCmL2D5Q1IM
 8gyzab0K5QkKVxTbWY4AkWjjqCtwADype1Jj31jhJBQuBz9Ev3lRvjPcbgQGwacBts+WycIQD9
 MVrnnedoL74ZtAqsBbdIz2wSWyLUyyxIUfhXXc76UBNGBTdmTIGllMD9DRAOOYqpuKkXzrYc8j
 1pa/15uTRixuAPxqtMCbAdmAl/xNC9+tVgB6JixjH+oA+Jk3zqj5nycXVHWem7+BqqQXNyrhdl
 EzE=
X-IronPort-AV: E=Sophos;i="5.76,335,1592863200"; 
   d="scan'208";a="13549383"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 21 Aug 2020 09:22:26 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.117.49.26])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id EFC79280070;
        Fri, 21 Aug 2020 09:22:25 +0200 (CEST)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Dan Murphy <dmurphy@ti.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH net-next 2/2] net: phy: dp83867: apply ti,led-function and ti,led-ctrl to registers
Date:   Fri, 21 Aug 2020 09:21:46 +0200
Message-Id: <20200821072146.8117-2-matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200821072146.8117-1-matthias.schiffer@ew.tq-group.com>
References: <20200821072146.8117-1-matthias.schiffer@ew.tq-group.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These DT bindings are already in use by the imx7-mba7 DTS, but they were
not supported by the PHY driver so far.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 drivers/net/phy/dp83867.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index f3c04981b8da..972824e25c1c 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -26,6 +26,8 @@
 #define MII_DP83867_MICR	0x12
 #define MII_DP83867_ISR		0x13
 #define DP83867_CFG2		0x14
+#define DP83867_LEDCR1		0x18
+#define DP83867_LEDCR2		0x19
 #define DP83867_CFG3		0x1e
 #define DP83867_CTRL		0x1f
 
@@ -163,6 +165,8 @@ struct dp83867_private {
 	u32 rx_fifo_depth;
 	int io_impedance;
 	int port_mirroring;
+	u32 led_function;
+	u32 led_ctrl;
 	bool rxctrl_strap_quirk;
 	bool set_clk_output;
 	u32 clk_output_sel;
@@ -583,6 +587,27 @@ static int dp83867_of_init(struct phy_device *phydev)
 		return -EINVAL;
 	}
 
+	ret = of_property_read_u32(of_node, "ti,led-function",
+				   &dp83867->led_function);
+	if (ret) {
+		dp83867->led_function = U32_MAX;
+	} else if (dp83867->led_function > U16_MAX) {
+		phydev_err(phydev,
+			   "ti,led-function value %x out of range\n",
+			   dp83867->led_function);
+		return -EINVAL;
+	}
+
+	ret = of_property_read_u32(of_node, "ti,led-ctrl", &dp83867->led_ctrl);
+	if (ret) {
+		dp83867->led_ctrl = U32_MAX;
+	} else if (dp83867->led_ctrl > U16_MAX) {
+		phydev_err(phydev,
+			   "ti,led-ctrl value %x out of range\n",
+			   dp83867->led_ctrl);
+		return -EINVAL;
+	}
+
 	return 0;
 }
 #else
@@ -788,6 +813,11 @@ static int dp83867_config_init(struct phy_device *phydev)
 			       mask, val);
 	}
 
+	if (dp83867->led_function != U32_MAX)
+		phy_write(phydev, DP83867_LEDCR1, dp83867->led_function);
+	if (dp83867->led_ctrl != U32_MAX)
+		phy_write(phydev, DP83867_LEDCR2, dp83867->led_ctrl);
+
 	return 0;
 }
 
-- 
2.17.1

