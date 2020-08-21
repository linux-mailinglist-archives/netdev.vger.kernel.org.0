Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B268E24CF29
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgHUHWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:22:38 -0400
Received: from mx1.tq-group.com ([62.157.118.193]:44577 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbgHUHW2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 03:22:28 -0400
IronPort-SDR: w79nluinkL3SKoYHInWHxhFBFe07XrWBzzRRr0yktT9zSEIGdcKytSP1gWqqTliOTbgKXVnQwq
 7xoMUgAmCPjThddW6S/vuD/Tb9yennWBlwStVClih9qn+goNgcnT+oeL3Vm4oGCVzM8UYPePmn
 k7LOluuUKTmruUamHRQr1EJcnyP94KaTkqoGJ9KORrgcNYqRJGbAOncJixPfaefPRR5pcqK/sa
 I6Rvc8+w8n0h6F3bjTOUmIqndXqiPYdpP9f49ZRWM98H/4gPnzVSsht9hHn4P5Z0Xxzf7iWvsr
 KqI=
X-IronPort-AV: E=Sophos;i="5.76,335,1592863200"; 
   d="scan'208";a="13549382"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 21 Aug 2020 09:22:26 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 21 Aug 2020 09:22:26 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Fri, 21 Aug 2020 09:22:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1597994546; x=1629530546;
  h=from:to:cc:subject:date:message-id;
  bh=EefKwu7gf4WtneGw/sVo55ly+Znp9htNXOYzXWaEm68=;
  b=jy9ThjoV4wDk9UiDVcJVGjprT+d2U9L+WrXMQah1AwCzxlxcpGXounJ/
   EQyvQ19Sg08UxUd3MZvWvJks2AJQHHWXl1kJ13yOKDl/DZnhLmt5PG8oA
   fDtu35DUubNxZ/HHn3LtSbMCg8JrEdteuAmM1oCZJVXLIaEDK1wXnnteW
   377vyoON0/N0aGI/Y5Yzt8ZLQ0Bpg64pQsKdM3HL3QdhZ/849C7Wy/c9J
   +qi9Q6xHHF1iC+joi5f8nliGI9Zn+u5qqrIieWFdm2OjtFkwgDXiRkf6W
   Jdf5rCUTEfCOwX0Zg/5Gn6CsJyuYFGT+AqMyv3feuu258gnXXcibvS46r
   g==;
IronPort-SDR: wl6o/SaXXXPhs/Ibl2ArIyhyI7yKooib5XSU7LoxvPQsN4N2QbJNy8gz6Jt5XPAgNnhljOLtM4
 dlf63hseFjJEopXKLRXX994O74GctOpWtz6ZQ9K6ltNGBeO8AaIeYX0UR4oLFc3wGNPNCbKfqT
 ZvyukA7Ec/SS3JxLp4ubcXOTEM1P60dlIZfI37uI7ahsLX7ej0ki59b9u21mcVxUjYVHqu/jXN
 wjZUi67yqNJ6V/d249jLoTd+cU+bElBh3A6g4SYL4zjPl/LCdVRTmeGYpW/uY1RpqBb2it9+3B
 dio=
X-IronPort-AV: E=Sophos;i="5.76,335,1592863200"; 
   d="scan'208";a="13549381"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 21 Aug 2020 09:22:25 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.117.49.26])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id BFDDF280065;
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
Subject: [PATCH net-next 1/2] dt-bindings: dp83867: add ti,led-function and ti,led-ctrl properties
Date:   Fri, 21 Aug 2020 09:21:45 +0200
Message-Id: <20200821072146.8117-1-matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the TQ-Systems MBa7x (imx7-mba7.dtsi), a user of these properties
already sneaked in before they were properly specified. Add them to the
binding docs.

On top of the existing use (requiring to specify the raw register value
in the DTS), we propose a few convenience macros and defines.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 .../devicetree/bindings/net/ti,dp83867.yaml   | 18 ++++++
 include/dt-bindings/net/ti-dp83867.h          | 60 +++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.yaml b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
index c6716ac6cbcc..f91d40edab39 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83867.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
@@ -106,6 +106,18 @@ properties:
       Transmitt FIFO depth- see dt-bindings/net/ti-dp83867.h for applicable
       values.
 
+  ti,led-function:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+      Value of LED configuration register 1, controlling the triggers for the
+      PHY LED outputs. See dt-bindings/net/ti-dp83867.h.
+
+  ti,led-ctrl:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+      Value of LED configuration register 2, controlling polarity and related
+      settings for the PHY LED outputs. See dt-bindings/net/ti-dp83867.h.
+
 required:
   - reg
 
@@ -123,5 +135,11 @@ examples:
         ti,clk-output-sel = <DP83867_CLK_O_SEL_CHN_A_RCLK>;
         ti,rx-internal-delay = <DP83867_RGMIIDCTL_2_25_NS>;
         ti,tx-internal-delay = <DP83867_RGMIIDCTL_2_75_NS>;
+        ti,led-function = <(DP83867_LED0(FUNC_LINK_ACT) |
+                            DP83867_LED1(FUNC_LINK_1000))>;
+        ti,led-ctrl = <(DP83867_LED0(CTRL_ACTIVE_HIGH) |
+                        DP83867_LED1(CTRL_ACTIVE_HIGH) |
+                        DP83867_LED2(CTRL_FORCE_LOW) |
+                        DP83867_LED3(CTRL_FORCE_LOW))>;
       };
     };
diff --git a/include/dt-bindings/net/ti-dp83867.h b/include/dt-bindings/net/ti-dp83867.h
index 6fc4b445d3a1..f3e3866d26ee 100644
--- a/include/dt-bindings/net/ti-dp83867.h
+++ b/include/dt-bindings/net/ti-dp83867.h
@@ -50,4 +50,64 @@
 #define DP83867_CLK_O_SEL_REF_CLK		0xC
 /* Special flag to indicate clock should be off */
 #define DP83867_CLK_O_SEL_OFF			0xFFFFFFFF
+
+/*
+ * Register values and helper macros for ti,led-function and ti,led-ctrl
+ *
+ * Example:
+ *
+ * ti,led-function = <(DP83867_LED0(FUNC_LINK_ACT) |
+ *                     DP83867_LED1(FUNC_LINK_1000))>;
+ * ti,led-ctrl = <(DP83867_LED0(CTRL_ACTIVE_HIGH) |
+ *                 DP83867_LED1(CTRL_ACTIVE_HIGH) |
+ *                 DP83867_LED2(CTRL_FORCE_LOW) |
+ *                 DP83867_LED3(CTRL_FORCE_LOW))>;
+ *
+ * It is recommended to force all unused LED pins to high or low level via
+ * led-ctrl (led-function is ignored in this case). LEDs that are missing from
+ * the configured value will be set to value 0x0 (FUNC_LINK and
+ * CTRL_ACTIVE_LOW).
+ */
+
+/* Link established */
+#define DP83867_LED_FUNC_LINK		0x0
+/* Receive or transmit activity */
+#define DP83867_LED_FUNC_ACT		0x1
+/* Transmit activity */
+#define DP83867_LED_FUNC_ACT_TX		0x2
+/* Receive activity */
+#define DP83867_LED_FUNC_ACT_RX		0x3
+/* Collision detected */
+#define DP83867_LED_FUNC_COLLISION	0x4
+/* 1000BT link established */
+#define DP83867_LED_FUNC_LINK_1000	0x5
+/* 100BTX link established */
+#define DP83867_LED_FUNC_LINK_100	0x6
+/* 10BT link established */
+#define DP83867_LED_FUNC_LINK_10	0x7
+/* 10/100BT link established */
+#define DP83867_LED_FUNC_LINK_10_100	0x8
+/* 100/1000BT link established */
+#define DP83867_LED_FUNC_LINK_100_1000	0x9
+/* Full duplex */
+#define DP83867_LED_FUNC_FULL_DUPLEX	0xa
+/* Link established, blink for transmit or receive activity */
+#define DP83867_LED_FUNC_LINK_ACT	0xb
+/* Receive Error or Transmit Error */
+#define DP83867_LED_FUNC_ERR		0xd
+/* Receive Error */
+#define DP83867_LED_FUNC_ERR_RX		0xe
+
+#define DP83867_LED_CTRL_ACTIVE_HIGH	0x4
+#define DP83867_LED_CTRL_ACTIVE_LOW	0x0
+#define DP83867_LED_CTRL_FORCE_HIGH	0x3
+#define DP83867_LED_CTRL_FORCE_LOW	0x1
+
+#define DP83867_LED_SHIFT(v, s)		((DP83867_LED_##v) << (s))
+
+#define DP83867_LED0(v)			DP83867_LED_SHIFT(v, 0)
+#define DP83867_LED1(v)			DP83867_LED_SHIFT(v, 4)
+#define DP83867_LED2(v)			DP83867_LED_SHIFT(v, 8)
+#define DP83867_LED3(v)			DP83867_LED_SHIFT(v, 12)
+
 #endif
-- 
2.17.1

