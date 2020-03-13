Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D741C184417
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 10:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgCMJuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 05:50:09 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:38101 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgCMJuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 05:50:09 -0400
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 45B041BF20D;
        Fri, 13 Mar 2020 09:50:05 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 3/3] net: phy: mscc: fix header defines and descriptions
Date:   Fri, 13 Mar 2020 10:48:02 +0100
Message-Id: <20200313094802.82863-4-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200313094802.82863-1-antoine.tenart@bootlin.com>
References: <20200313094802.82863-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cosmetic commit fixing the MSCC PHY header defines and descriptions,
which were referring the to MSCC Ocelot MAC driver (see
drivers/net/ethernet/mscc/).

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/mscc/mscc_fc_buffer.h | 8 ++++----
 drivers/net/phy/mscc/mscc_mac.h       | 8 ++++----
 drivers/net/phy/mscc/mscc_macsec.h    | 8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_fc_buffer.h b/drivers/net/phy/mscc/mscc_fc_buffer.h
index 7e9c0e877895..3803e826c37d 100644
--- a/drivers/net/phy/mscc/mscc_fc_buffer.h
+++ b/drivers/net/phy/mscc/mscc_fc_buffer.h
@@ -1,12 +1,12 @@
 /* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
 /*
- * Microsemi Ocelot Switch driver
+ * Driver for Microsemi VSC85xx PHYs
  *
  * Copyright (C) 2019 Microsemi Corporation
  */
 
-#ifndef _MSCC_OCELOT_FC_BUFFER_H_
-#define _MSCC_OCELOT_FC_BUFFER_H_
+#ifndef _MSCC_PHY_FC_BUFFER_H_
+#define _MSCC_PHY_FC_BUFFER_H_
 
 #define MSCC_FCBUF_ENA_CFG					0x00
 #define MSCC_FCBUF_MODE_CFG					0x01
@@ -61,4 +61,4 @@
 #define MSCC_FCBUF_FC_READ_THRESH_CFG_RX_THRESH(x)		((x) << 16)
 #define MSCC_FCBUF_FC_READ_THRESH_CFG_RX_THRESH_M		GENMASK(31, 16)
 
-#endif
+#endif /* _MSCC_PHY_FC_BUFFER_H_ */
diff --git a/drivers/net/phy/mscc/mscc_mac.h b/drivers/net/phy/mscc/mscc_mac.h
index 9420ee5175a6..fcb5ba5e5d03 100644
--- a/drivers/net/phy/mscc/mscc_mac.h
+++ b/drivers/net/phy/mscc/mscc_mac.h
@@ -1,12 +1,12 @@
 /* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
 /*
- * Microsemi Ocelot Switch driver
+ * Driver for Microsemi VSC85xx PHYs
  *
  * Copyright (c) 2017 Microsemi Corporation
  */
 
-#ifndef _MSCC_OCELOT_LINE_MAC_H_
-#define _MSCC_OCELOT_LINE_MAC_H_
+#ifndef _MSCC_PHY_LINE_MAC_H_
+#define _MSCC_PHY_LINE_MAC_H_
 
 #define MSCC_MAC_CFG_ENA_CFG					0x00
 #define MSCC_MAC_CFG_MODE_CFG					0x01
@@ -156,4 +156,4 @@
 #define MSCC_PROC_0_IP_1588_TOP_CFG_STAT_MODE_CTL_PROTOCOL_MODE(x)	(x)
 #define MSCC_PROC_0_IP_1588_TOP_CFG_STAT_MODE_CTL_PROTOCOL_MODE_M	GENMASK(2, 0)
 
-#endif /* _MSCC_OCELOT_LINE_MAC_H_ */
+#endif /* _MSCC_PHY_LINE_MAC_H_ */
diff --git a/drivers/net/phy/mscc/mscc_macsec.h b/drivers/net/phy/mscc/mscc_macsec.h
index c606c9a65d2d..d0783944d106 100644
--- a/drivers/net/phy/mscc/mscc_macsec.h
+++ b/drivers/net/phy/mscc/mscc_macsec.h
@@ -1,12 +1,12 @@
 /* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
 /*
- * Microsemi Ocelot Switch driver
+ * Driver for Microsemi VSC85xx PHYs
  *
  * Copyright (c) 2018 Microsemi Corporation
  */
 
-#ifndef _MSCC_OCELOT_MACSEC_H_
-#define _MSCC_OCELOT_MACSEC_H_
+#ifndef _MSCC_PHY_MACSEC_H_
+#define _MSCC_PHY_MACSEC_H_
 
 #include <net/macsec.h>
 
@@ -321,4 +321,4 @@ struct macsec_flow {
 #define MSCC_MS_INTR_CTRL_STATUS_INTR_ENABLE_M		GENMASK(31, 16)
 #define MACSEC_INTR_CTRL_STATUS_ROLLOVER		BIT(5)
 
-#endif
+#endif /* _MSCC_PHY_MACSEC_H_ */
-- 
2.24.1

