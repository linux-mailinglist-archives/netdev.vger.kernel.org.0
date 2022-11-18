Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784D662EA83
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240705AbiKRAo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239716AbiKRAoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:44:16 -0500
Received: from finn.localdomain (finn.gateworks.com [108.161.129.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BD362078;
        Thu, 17 Nov 2022 16:44:14 -0800 (PST)
Received: from 068-189-091-139.biz.spectrum.com ([68.189.91.139] helo=tharvey.pdc.gateworks.com)
        by finn.localdomain with esmtp (Exim 4.93)
        (envelope-from <tharvey@gateworks.com>)
        id 1ovp2t-000nxs-MB; Fri, 18 Nov 2022 00:15:51 +0000
From:   Tim Harvey <tharvey@gateworks.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Tim Harvey <tharvey@gateworks.com>
Subject: [PATCH 1/3] dt-bindings: net: phy: dp83867: add LED mode property
Date:   Thu, 17 Nov 2022 16:15:46 -0800
Message-Id: <20221118001548.635752-2-tharvey@gateworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221118001548.635752-1-tharvey@gateworks.com>
References: <20221118001548.635752-1-tharvey@gateworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add description for new property ti,led-modes in binding file.

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 .../devicetree/bindings/net/ti,dp83867.yaml      |  6 ++++++
 include/dt-bindings/net/ti-dp83867.h             | 16 ++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.yaml b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
index b8c0e4b5b494..8b84c34d389f 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83867.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
@@ -118,6 +118,12 @@ properties:
       Transmitt FIFO depth- see dt-bindings/net/ti-dp83867.h for applicable
       values.
 
+  ti,led-modes:
+    description: |
+      List of LED modes - see dt-bindings/net/ti-dp83867.h for applicable
+      values.
+    $ref: schemas/types.yaml#/definitions/uint32-array
+
 required:
   - reg
 
diff --git a/include/dt-bindings/net/ti-dp83867.h b/include/dt-bindings/net/ti-dp83867.h
index 6fc4b445d3a1..ea3e17b27427 100644
--- a/include/dt-bindings/net/ti-dp83867.h
+++ b/include/dt-bindings/net/ti-dp83867.h
@@ -50,4 +50,20 @@
 #define DP83867_CLK_O_SEL_REF_CLK		0xC
 /* Special flag to indicate clock should be off */
 #define DP83867_CLK_O_SEL_OFF			0xFFFFFFFF
+
+/* LED_CFG - LED configuration selection */
+#define DP83867_LED_SEL_LINK			0
+#define DP83867_LED_SEL_ACT			1
+#define DP83867_LED_SEL_ACT_TX			2
+#define DP83867_LED_SEL_ACT_RX			3
+#define DP83867_LED_SEL_COL			4
+#define DP83867_LED_SEL_LINK_1000BT		5
+#define DP83867_LED_SEL_LINK_100BT		6
+#define DP83867_LED_SEL_LINK_10BT		7
+#define DP83867_LED_SEL_LINK_10_100BT		8
+#define DP83867_LED_SEL_LINK_100_1000BT		9
+#define DP83867_LED_SEL_FULL_DUPLEX		10
+#define DP83867_LED_SEL_LINK_ACT		11
+#define DP83867_LED_SEL_ERR_TX_RX		13
+#define DP83867_LED_SEL_ERR_RX			14
 #endif
-- 
2.25.1

