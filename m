Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AB843E648
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 18:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhJ1Qn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 12:43:57 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:16412 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhJ1Qn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 12:43:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635439289; x=1666975289;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B3yIueqAaUwco5fsiYMKbMxzLpRWuBO3Of6GX/De5Rk=;
  b=k0pP7m0g40HDCYn0fJkyr+nM5IyEbPOqXY5gNGwK60t3mUsHhHqrqda+
   B9enTZ/7b26PRR5C/UhgylXzyuBhKfsWQjxbLsLhNh+LLLiKM1epXCo/z
   ku/akMN2i9m5oLU+TLduX68h0B81l5G5w8Ng4xht1PI0Uo4EdjDd/FJfs
   y9pW1/H9avWOaaut15KPmyRbFXy4wkC2M4D0PDJi0Vlx4bKXSslpNk7Fw
   UoMHihgOHruXfLDypSayFlKOzaw1d4d7LvIJMefKKSMeVj8HquxyFiox0
   dPX795d6qYv1CCL5eSwgjdBvUxW3gaL/dw4mxVFVGWs1kXITQV0v1C/bE
   Q==;
IronPort-SDR: 37ghqgqa2tugdFefwjtpV8OMf20V4eOREhig72u2P3d/jwzyKi8QXnBkpVOIaTG9/ePbZA0qLb
 /UcxxtwV0e7LUzPVFl3EMMBsCN3PwlKcD425/03CUI9fQIKp2rIgb0K3KjOF9soTBTeCqDmSVh
 J6AMIDHfsBh6+QJt3HrnGB76WIBkLWlKc2xtqwheqeUvZ0cTYPNxxGY5sXju62yVqyu4h+Ecvi
 6DF1YA+mc1atj85M4QCI/8O69PblJzpmbCIeeyHUC0IpH7I/s+Tkxh5H5S+ImbaAT4tdPGJgvO
 U0KJo5Gi81D5mviUMWZJCTxV
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="142031734"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2021 09:41:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 28 Oct 2021 09:41:27 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 28 Oct 2021 09:41:21 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v5 net-next 01/10] dt-bindings: net: dsa: dt bindings for microchip lan937x
Date:   Thu, 28 Oct 2021 22:11:02 +0530
Message-ID: <20211028164111.521039-2-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211028164111.521039-1-prasanna.vengateshan@microchip.com>
References: <20211028164111.521039-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation in .yaml format and updates to the MAINTAINERS
Also 'make dt_binding_check' is passed.

Introduced rx-internal-delay-ps & tx-internal-delay-ps for RGMII
internal delay along with min/max values. This is to address the
Vladimir proposal from the previous revision and mdio details
are added as suggested by Rob.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 .../bindings/net/dsa/microchip,lan937x.yaml   | 180 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 2 files changed, 181 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
new file mode 100644
index 000000000000..0bc16894c8c4
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
@@ -0,0 +1,180 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/microchip,lan937x.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: LAN937x Ethernet Switch Series Tree Bindings
+
+maintainers:
+  - UNGLinuxDriver@microchip.com
+
+allOf:
+  - $ref: dsa.yaml#
+
+properties:
+  compatible:
+    enum:
+      - microchip,lan9370
+      - microchip,lan9371
+      - microchip,lan9372
+      - microchip,lan9373
+      - microchip,lan9374
+
+  reg:
+    maxItems: 1
+
+  spi-max-frequency:
+    maximum: 50000000
+
+  reset-gpios:
+    description: Optional gpio specifier for a reset line
+    maxItems: 1
+
+  mdio:
+    $ref: /schemas/net/mdio.yaml#
+    unevaluatedProperties: false
+
+patternProperties:
+  "^(ethernet-)?ports$":
+    patternProperties:
+      "^(ethernet-)?port@[0-7]+$":
+        allOf:
+          - if:
+              properties:
+                phy-mode:
+                  contains:
+                    enum:
+                      - rgmii
+                      - rgmii-rxid
+                      - rgmii-txid
+                      - rgmii-id
+            then:
+              properties:
+                rx-internal-delay-ps:
+                  $ref: "#/$defs/internal-delay-ps"
+                tx-internal-delay-ps:
+                  $ref: "#/$defs/internal-delay-ps"
+
+required:
+  - compatible
+  - reg
+
+$defs:
+  internal-delay-ps:
+    description: Delay is in pico seconds
+    minimum: 2170
+    maximum: 4000
+    default: 0
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+
+    //Ethernet switch connected via spi to the host
+    ethernet {
+      #address-cells = <1>;
+      #size-cells = <0>;
+
+      fixed-link {
+        speed = <1000>;
+        full-duplex;
+      };
+    };
+
+    spi {
+      #address-cells = <1>;
+      #size-cells = <0>;
+
+      lan9374: switch@0 {
+        compatible = "microchip,lan9374";
+        reg = <0>;
+
+        spi-max-frequency = <44000000>;
+
+        ethernet-ports {
+          #address-cells = <1>;
+          #size-cells = <0>;
+          port@0 {
+            reg = <0>;
+            label = "lan1";
+            phy-mode = "internal";
+            phy-handle = <&t1phy0>;
+          };
+          port@1 {
+            reg = <1>;
+            label = "lan2";
+            phy-mode = "internal";
+            phy-handle = <&t1phy1>;
+          };
+          port@2 {
+            reg = <2>;
+            label = "lan4";
+            phy-mode = "internal";
+            phy-handle = <&t1phy2>;
+          };
+          port@3 {
+            reg = <3>;
+            label = "lan6";
+            phy-mode = "internal";
+            phy-handle = <&t1phy3>;
+          };
+          port@4 {
+            reg = <4>;
+            phy-mode = "rgmii";
+            ethernet = <&ethernet>;
+            fixed-link {
+              speed = <1000>;
+              full-duplex;
+            };
+          };
+          port@5 {
+            reg = <5>;
+            label = "lan7";
+            phy-mode = "rgmii";
+            fixed-link {
+              speed = <1000>;
+              full-duplex;
+            };
+          };
+          port@6 {
+            reg = <6>;
+            label = "lan5";
+            phy-mode = "internal";
+            phy-handle = <&t1phy4>;
+          };
+          port@7 {
+            reg = <7>;
+            label = "lan3";
+            phy-mode = "internal";
+            phy-handle = <&t1phy5>;
+          };
+        };
+
+        mdio {
+          #address-cells = <1>;
+          #size-cells = <0>;
+
+          t1phy0: ethernet-phy@0{
+            reg = <0x0>;
+          };
+          t1phy1: ethernet-phy@1{
+            reg = <0x1>;
+          };
+          t1phy2: ethernet-phy@2{
+            reg = <0x2>;
+          };
+          t1phy3: ethernet-phy@3{
+            reg = <0x3>;
+          };
+          t1phy4: ethernet-phy@6{
+            reg = <0x6>;
+          };
+          t1phy5: ethernet-phy@7{
+            reg = <0x7>;
+          };
+        };
+      };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 975086c5345d..c95392430f11 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12300,6 +12300,7 @@ M:	UNGLinuxDriver@microchip.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+F:	Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
 F:	drivers/net/dsa/microchip/*
 F:	include/linux/platform_data/microchip-ksz.h
 F:	net/dsa/tag_ksz.c
-- 
2.27.0

