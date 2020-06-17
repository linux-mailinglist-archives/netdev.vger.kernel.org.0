Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DC21FCE96
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 15:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgFQNg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 09:36:26 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:46867 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgFQNgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 09:36:22 -0400
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id CE341100007;
        Wed, 17 Jun 2020 13:36:17 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        foss@0leil.net, antoine.tenart@bootlin.com
Subject: [PATCH net-next v2 2/8] net: phy: mscc: fix copyright and author information in MACsec
Date:   Wed, 17 Jun 2020 15:31:21 +0200
Message-Id: <20200617133127.628454-3-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200617133127.628454-1-antoine.tenart@bootlin.com>
References: <20200617133127.628454-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All headers in the MSCC PHY driver have been copied and pasted from the
original mscc.c file. However the information is not necessarily
correct, as in the MACsec support. Fix this.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc/mscc_fc_buffer.h | 2 +-
 drivers/net/phy/mscc/mscc_mac.h       | 2 +-
 drivers/net/phy/mscc/mscc_macsec.c    | 6 +++---
 drivers/net/phy/mscc/mscc_macsec.h    | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_fc_buffer.h b/drivers/net/phy/mscc/mscc_fc_buffer.h
index 3803e826c37d..399e803395a5 100644
--- a/drivers/net/phy/mscc/mscc_fc_buffer.h
+++ b/drivers/net/phy/mscc/mscc_fc_buffer.h
@@ -2,7 +2,7 @@
 /*
  * Driver for Microsemi VSC85xx PHYs
  *
- * Copyright (C) 2019 Microsemi Corporation
+ * Copyright (C) 2020 Microsemi Corporation
  */
 
 #ifndef _MSCC_PHY_FC_BUFFER_H_
diff --git a/drivers/net/phy/mscc/mscc_mac.h b/drivers/net/phy/mscc/mscc_mac.h
index 59b6837c60b3..8dd38dc6edbf 100644
--- a/drivers/net/phy/mscc/mscc_mac.h
+++ b/drivers/net/phy/mscc/mscc_mac.h
@@ -2,7 +2,7 @@
 /*
  * Driver for Microsemi VSC85xx PHYs
  *
- * Copyright (c) 2017 Microsemi Corporation
+ * Copyright (c) 2020 Microsemi Corporation
  */
 
 #ifndef _MSCC_PHY_LINE_MAC_H_
diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index b4d3dc4068e2..c0eeb62cb940 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -1,10 +1,10 @@
 // SPDX-License-Identifier: (GPL-2.0 OR MIT)
 /*
- * Driver for Microsemi VSC85xx PHYs
+ * Driver for Microsemi VSC85xx PHYs - MACsec support
  *
- * Author: Nagaraju Lakkaraju
+ * Author: Antoine Tenart
  * License: Dual MIT/GPL
- * Copyright (c) 2016 Microsemi Corporation
+ * Copyright (c) 2020 Microsemi Corporation
  */
 
 #include <linux/phy.h>
diff --git a/drivers/net/phy/mscc/mscc_macsec.h b/drivers/net/phy/mscc/mscc_macsec.h
index d751f2946b79..9c6d25e36de2 100644
--- a/drivers/net/phy/mscc/mscc_macsec.h
+++ b/drivers/net/phy/mscc/mscc_macsec.h
@@ -2,7 +2,7 @@
 /*
  * Driver for Microsemi VSC85xx PHYs
  *
- * Copyright (c) 2018 Microsemi Corporation
+ * Copyright (c) 2020 Microsemi Corporation
  */
 
 #ifndef _MSCC_PHY_MACSEC_H_
-- 
2.26.2

