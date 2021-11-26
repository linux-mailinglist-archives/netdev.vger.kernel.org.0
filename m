Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1887045E9E6
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 10:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359671AbhKZJJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 04:09:13 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:36438 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359842AbhKZJHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 04:07:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637917438; x=1669453438;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=COb8v8Hw5Zr/LWQ7Z9Py1B0kqlpclqkKtLzJabDhYvs=;
  b=VmfOU3tyzYTGdInRDL6yU3k9is0GDraIZh2jYDVVnMGoJkjyPY8PqnQM
   vg3r9yrHRoLOhJcH3TL9Tr0l7AdeyiWV0gBj135QcSDaCndE+sko3Iuy6
   c+5zEn1sEaIkhIQs/nZWRHOvASJnvgGZpCDrmmgbNSMmn+RDPYnfEogc/
   FNk/HAkONZc/pSUqMCLaLoAGZQJvXTg3odVUly4RM176wMmq6RK/ilc96
   FCih+dlqnTMbUZtxFBUgwRGG1rdDHnAg3mn5xl+VtyjB35p43AMPRyjom
   4NHhkOIH70ndyfiu69qUzeF54toGer//fNCKous/HgAXwAV+eFoAGqOHQ
   g==;
IronPort-SDR: RbQzdWjq2TM0k4trde+oJSFq8Y9tYULBjUDQgM3XPpUax4TAZmOs0AGtFr25YRrH1FlVGiVjZb
 0OsjszBz7uFdq15fdob+riu2SN3ybRrFIXup9Le4d2dCN8M1VLE/okVWAMdIvp3bIFc3sJpqOk
 cPZ4eDC2TlUIsAZZK4+Wi5tmHIga1UI0eH1IOwtZ5ath9QmJnzwsmznVsqjgXAT4AuWZInU10z
 zWlGC3OSREIDqSoFl+KXOMt6SIMT+FV0DJLQnGSYBdlcsK1HkUNoOc0+FsAHt1zWTBXVHEqPEm
 PefGzqjRmX6PhtMjX/yRXtzU
X-IronPort-AV: E=Sophos;i="5.87,265,1631602800"; 
   d="scan'208";a="153319323"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Nov 2021 02:03:58 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 26 Nov 2021 02:03:58 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 26 Nov 2021 02:03:55 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 1/6] dt-bindings: net: lan966x: Add lan966x-switch bindings
Date:   Fri, 26 Nov 2021 10:05:35 +0100
Message-ID: <20211126090540.3550913-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126090540.3550913-1-horatiu.vultur@microchip.com>
References: <20211126090540.3550913-1-horatiu.vultur@microchip.com>
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

