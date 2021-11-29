Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093EB461561
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 13:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbhK2Mrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 07:47:47 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:50663 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343841AbhK2Mpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 07:45:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638189749; x=1669725749;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8mLcRQ1S3yIRTg8cYLtlsBBPok2EJxFTrXPriaed98U=;
  b=sbF+r9tR6G4hsFlSKQSCpYEIfZgo60ZYDmjI14BQpi78wd/73lQWiDy7
   lW1WgZ5nagJrpzG3jmkVfXK7bAVCYfd1VUtXLLtv7f1RAcQpcK/Xa4hSJ
   t/lfd908mz/R4BTa3G7YRgpWLMuVhj5oknVcfBaSh6K4pqGalWF6uOlq2
   CxMj8UXxZc8OIDaOves2mF7mRfmgpDaTD9jshTXeWujAPcIY73Rjvf5ic
   9N1TaTterjkMzNByG/vo18B5jJB7NiKE8l/yb7wXMesdNHGfm+3GHH3cZ
   5vLeVCG+cW4oEpDrsOuxm9eBjtjTkqYDwRNTzZQSR2K7JctnXhH6TyKfY
   A==;
IronPort-SDR: 6EluseXMoJ1JwlMBrp+JHh6qvTzHttpQ7tGLX/xE8vcwYrZFg2U8Zr068CDU4ZATuUZp1gg8rV
 y+kYuvQ89Dn425XMLqg7Q+0B+7z4+ZEzQFp48S6g3PtOM32z6k57aB1nUJgwRskGM3HH2n88cU
 4hlW8GfXIZ1iJMIKWe/31sRF9B6ANwWevewpMkeMLb7C7bnEfM2txG0pSMB4HKlr/mZGeA8gRM
 nXGmuoeVuok4oHO9Ec3fqVcUAiDxkOEwAUvEROXPr6F9mwwy3hSaIfCE9YCAObYMFcu3oR287K
 Nqnnfnl1Q0XSI54rMHFM95RM
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="144833706"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2021 05:42:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 29 Nov 2021 05:42:26 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 29 Nov 2021 05:42:24 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v5 1/6] dt-bindings: net: lan966x: Add lan966x-switch bindings
Date:   Mon, 29 Nov 2021 13:43:54 +0100
Message-ID: <20211129124359.4069432-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211129124359.4069432-1-horatiu.vultur@microchip.com>
References: <20211129124359.4069432-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the lan966x switch device driver bindings

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/microchip,lan966x-switch.yaml         | 158 ++++++++++++++++++
 1 file changed, 158 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml

diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
new file mode 100644
index 000000000000..d54dc183a033
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
@@ -0,0 +1,158 @@
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
+        allOf:
+          - $ref: "http://devicetree.org/schemas/net/ethernet-controller.yaml#"
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
+            enum:
+              - gmii
+              - sgmii
+              - qsgmii
+              - 1000base-x
+              - 2500base-x
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

