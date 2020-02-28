Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0B7173C51
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 16:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgB1P5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 10:57:13 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:58071 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbgB1P5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 10:57:11 -0500
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 00F891C0002;
        Fri, 28 Feb 2020 15:57:09 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        foss@0leil.net
Subject: [PATCH net-next v2 2/3] dt-bindings: net: phy: mscc: document rgmii skew properties
Date:   Fri, 28 Feb 2020 16:57:01 +0100
Message-Id: <20200228155702.2062570-3-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228155702.2062570-1-antoine.tenart@bootlin.com>
References: <20200228155702.2062570-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch documents two new properties to describe RGMII skew delays in
both Rx and Tx: vsc8584,rgmii-skew-rx and vsc8584,rgmii-skew-tx.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 .../devicetree/bindings/net/mscc-phy-vsc8531.txt       |  8 ++++++++
 include/dt-bindings/net/mscc-phy-vsc8531.h             | 10 ++++++++++
 2 files changed, 18 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
index 5ff37c68c941..c682b6e74b14 100644
--- a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
+++ b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
@@ -31,6 +31,14 @@ Optional properties:
 			  VSC8531_LINK_100_ACTIVITY (2),
 			  VSC8531_LINK_ACTIVITY (0) and
 			  VSC8531_DUPLEX_COLLISION (8).
+- vsc8584,rgmii-skew-rx	: RGMII skew delay in Rx.
+			  Allowed values are defined in
+			  "include/dt-bindings/net/mscc-phy-vsc8531.h".
+			  Default value is VSC8584_RGMII_SKEW_0_2.
+- vsc8584,rgmii-skew-tx	: RGMII skew delay in Tx.
+			  Allowed values are defined in
+			  "include/dt-bindings/net/mscc-phy-vsc8531.h".
+			  Default value is VSC8584_RGMII_SKEW_0_2.
 
 
 Table: 1 - Edge rate change
diff --git a/include/dt-bindings/net/mscc-phy-vsc8531.h b/include/dt-bindings/net/mscc-phy-vsc8531.h
index 9eb2ec2b2ea9..02313cb3fc35 100644
--- a/include/dt-bindings/net/mscc-phy-vsc8531.h
+++ b/include/dt-bindings/net/mscc-phy-vsc8531.h
@@ -28,4 +28,14 @@
 #define VSC8531_FORCE_LED_OFF           14
 #define VSC8531_FORCE_LED_ON            15
 
+/* RGMII skew values, in ns */
+#define VSC8584_RGMII_SKEW_0_2		0
+#define VSC8584_RGMII_SKEW_0_8		1
+#define VSC8584_RGMII_SKEW_1_1		2
+#define VSC8584_RGMII_SKEW_1_7		3
+#define VSC8584_RGMII_SKEW_2_0		4
+#define VSC8584_RGMII_SKEW_2_3		5
+#define VSC8584_RGMII_SKEW_2_6		6
+#define VSC8584_RGMII_SKEW_3_4		7
+
 #endif
-- 
2.24.1

