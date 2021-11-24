Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3EF45B6A7
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241393AbhKXIn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:43:58 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:38037 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240683AbhKXIn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:43:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637743248; x=1669279248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=COb8v8Hw5Zr/LWQ7Z9Py1B0kqlpclqkKtLzJabDhYvs=;
  b=I2JdoiN5okiN+s/lm0epBbL7yLYyYwk2T+D41T9+dJPQMFSGx58t8Q5p
   vr7z+HtbfBJoEKsY5i3DPLjDA6ntJEPOXNX0Tv5wmYkABgVgplWPOLmuA
   CqbHGVNIzeNOF8aNAU2p1mt8WkW7HpFRCzLFknSSQBThd3Zf2qK5BjTr7
   x/0ye9inSSyZ2Z0k+q0yq33pd7XZWJcwoUugcYYC4W3Or23QxVKfVJkwa
   lv4YuaGIoImsacTnXfj1UZhvIihdwNRzPFCPmGw1ihw9hGEci6OJdfwXH
   lNVyBKSQg5DZucTwfXmq5KW4m59buoYdHqXohk4UzJlfrTnSzHSOc5TA2
   A==;
IronPort-SDR: vm9CxtbumBsR0DiRkjIBSdSau/e7DtT16eLDXQgLZF6MgtfIWcSkedjp03yIwsLFfAQBBHbvw9
 LPKgoonVMydmSXht6C4svNS7z64758C49Q3N1k23W7ceFE//Fk0RXzVt9hlH8sBRfVJSeZSfxn
 RfIYiqWYuGdmLw8ZAo4x7Dtk6OFoW7Dg+a2WPDMEOPwX6nwgOTqHzFB4HZtU8jbVf5Q8xKn+Kf
 ZHki0ARhlCs7sDtongJ8c9cfZllvlIyM++41xxgY8LeNXHBWT9loAlp/oFeJB5GdSEJxo9l3UW
 iE2Zr2bXqTdHPNNe5LA3iunp
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="137575614"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Nov 2021 01:40:47 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 24 Nov 2021 01:40:46 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 24 Nov 2021 01:40:44 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 1/6] dt-bindings: net: lan966x: Add lan966x-switch bindings
Date:   Wed, 24 Nov 2021 09:39:10 +0100
Message-ID: <20211124083915.2223065-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124083915.2223065-1-horatiu.vultur@microchip.com>
References: <20211124083915.2223065-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the lan966x switch device driver bindings

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/microchip,lan966x-switch.yaml         | 149 ++++++++++++++++++
 1 file changed, 149 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml

diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
new file mode 100644
index 000000000000..9367491dd2d5
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
@@ -0,0 +1,149 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/microchip,lan966x-switch.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Microchip Lan966x Ethernet switch controller
+
+maintainers:
+  - Horatiu Vultur <horatiu.vultur@microchip.com>
+
+description: |
+  The lan966x switch is a multi-port Gigabit AVB/TSN Ethernet Switch with
+  two integrated 10/100/1000Base-T PHYs. In addition to the integrated PHYs,
+  it supports up to 2RGMII/RMII, up to 3BASE-X/SERDES/2.5GBASE-X and up to
+  2 Quad-SGMII/Quad-USGMII interfaces.
+
+properties:
+  $nodename:
+    pattern: "^switch@[0-9a-f]+$"
+
+  compatible:
+    const: microchip,lan966x-switch
+
+  reg:
+    items:
+      - description: cpu target
+      - description: general control block target
+
+  reg-names:
+    items:
+      - const: cpu
+      - const: gcb
+
+  interrupts:
+    minItems: 1
+    items:
+      - description: register based extraction
+      - description: frame dma based extraction
+
+  interrupt-names:
+    minItems: 1
+    items:
+      - const: xtr
+      - const: fdma
+
+  resets:
+    items:
+      - description: Reset controller used for switch core reset (soft reset)
+      - description: Reset controller used for releasing the phy from reset
+
+  reset-names:
+    items:
+      - const: switch
+      - const: phy
+
+  ethernet-ports:
+    type: object
+    patternProperties:
+      "^port@[0-9a-f]+$":
+        type: object
+
+        properties:
+          '#address-cells':
+            const: 1
+          '#size-cells':
+            const: 0
+
+          reg:
+            description:
+              Switch port number
+
+          phys:
+            description:
+              Phandle of a Ethernet SerDes PHY
+
+          phy-mode:
+            description:
+              This specifies the interface used by the Ethernet SerDes towards
+              the PHY or SFP.
+
+          phy-handle:
+            description:
+              Phandle of a Ethernet PHY.
+
+          sfp:
+            description:
+              Phandle of an SFP.
+
+          managed: true
+
+        required:
+          - reg
+          - phys
+          - phy-mode
+
+        oneOf:
+          - required:
+              - phy-handle
+          - required:
+              - sfp
+              - managed
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - interrupts
+  - interrupt-names
+  - resets
+  - reset-names
+  - ethernet-ports
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    switch: switch@e0000000 {
+      compatible = "microchip,lan966x-switch";
+      reg =  <0xe0000000 0x0100000>,
+             <0xe2000000 0x0800000>;
+      reg-names = "cpu", "gcb";
+      interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+      interrupt-names = "xtr";
+      resets = <&switch_reset 0>, <&phy_reset 0>;
+      reset-names = "switch", "phy";
+      ethernet-ports {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        port0: port@0 {
+          reg = <0>;
+          phy-handle = <&phy0>;
+          phys = <&serdes 0 0>;
+          phy-mode = "gmii";
+        };
+
+        port1: port@1 {
+          reg = <1>;
+          sfp = <&sfp_eth1>;
+          managed = "in-band-status";
+          phys = <&serdes 2 4>;
+          phy-mode = "sgmii";
+        };
+      };
+    };
+
+...
-- 
2.33.0

