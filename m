Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABCAE45437E
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 10:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhKQJVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 04:21:08 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:1237 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234946AbhKQJU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 04:20:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637140679; x=1668676679;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=COb8v8Hw5Zr/LWQ7Z9Py1B0kqlpclqkKtLzJabDhYvs=;
  b=zH7st/wWew+G2NTUjOhSRtr/YOjgDOKFAZK13J0Yx08qZFeYIkLeJhHB
   4KyMVUea5Y/c77p5WlNa96Sqfs5MiYl/KpXQINod2RAIPKCfClrpEz/y+
   7RS23KIXuIjzFoW9k9yohgbvCMCER9RPM6eemdo97EfJGOIvBxGMq7PWL
   7SQbBbHqcjxcwKcbPR6eLHF2KCEgIW0zxA2x8erkZDHQYzYpHGN5uBDps
   IK4QAiEbCVK54tu+7uoL980gf+E3sjeZ4i2h+JQh6eNy8/IpAG4YCEX4U
   Tnn4rb+KcinvFyKxgFWIl2Qp8tW4NqqkhN/DUEwhYBZP0AwqSQMWRijtP
   g==;
IronPort-SDR: BaYPy3wIxVRnQ9Hcx89wMAdyK5w72sWLm0NdabhdffV8EpjZPrm019n0YHADFwDCoj1ZyFl5sh
 IJgZ/W7ysmpurA/cMryVT8hUfzKk5sRGIe0+lQj/33BlMs+hc+2tf7RR+vLanB45U7xNBD3XPJ
 cBUQtseiEfkEkRrCpsr1bzzchen8zT/WVEg7JSKE6x5s4AayuYl27xHJ4fVQOMf6mUn7FLhJWZ
 YUPoJPdJt2B0krHOv7PTYueDekf8yn2KYhHKyyQHIk8aGqI9tvy0yvA4Xp3L4ic2O/xRVmTP7+
 1PqYiu/JddPLWCkc1moGOdSP
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="76705738"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Nov 2021 02:17:54 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 17 Nov 2021 02:17:53 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 17 Nov 2021 02:17:52 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <p.zabel@pengutronix.de>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/5] dt-bindings: net: lan966x: Add lan966x-switch bindings
Date:   Wed, 17 Nov 2021 10:18:54 +0100
Message-ID: <20211117091858.1971414-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211117091858.1971414-1-horatiu.vultur@microchip.com>
References: <20211117091858.1971414-1-horatiu.vultur@microchip.com>
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

