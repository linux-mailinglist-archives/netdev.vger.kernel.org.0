Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D6428A3CB
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731223AbgJJW4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731207AbgJJTxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:53:43 -0400
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5812CC08EA76;
        Sat, 10 Oct 2020 10:21:14 -0700 (PDT)
Received: from p548da7b6.dip0.t-ipconnect.de ([84.141.167.182] helo=kmk0.Speedport_W_724V_09011603_06_006); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1kRI10-0004hK-Ol; Sat, 10 Oct 2020 18:46:38 +0200
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, kurt@linutronix.de,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH net-next 1/2] dt-bindings: net: dsa: b53: Add YAML bindings
Date:   Sat, 10 Oct 2020 18:46:26 +0200
Message-Id: <20201010164627.9309-2-kurt@kmk-computers.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201010164627.9309-1-kurt@kmk-computers.de>
References: <20201010164627.9309-1-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1602350474;79f59316;
X-HE-SMSGID: 1kRI10-0004hK-Ol
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the b53 DSA device tree bindings to YAML in order to allow
for automatic checking and such.

Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
---
 .../devicetree/bindings/net/dsa/b53.yaml      | 249 ++++++++++++++++++
 1 file changed, 249 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/b53.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/b53.yaml b/Documentation/devicetree/bindings/net/dsa/b53.yaml
new file mode 100644
index 000000000000..4fcbac1de95b
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/b53.yaml
@@ -0,0 +1,249 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/b53.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom BCM53xx Ethernet switches
+
+allOf:
+  - $ref: dsa.yaml#
+
+maintainers:
+  - Florian Fainelli <f.fainelli@gmail.com>
+
+description:
+  Broadcom BCM53xx Ethernet switches
+
+properties:
+  compatible:
+    oneOf:
+      - const: brcm,bcm5325
+      - const: brcm,bcm53115
+      - const: brcm,bcm53125
+      - const: brcm,bcm53128
+      - const: brcm,bcm5365
+      - const: brcm,bcm5395
+      - const: brcm,bcm5389
+      - const: brcm,bcm5397
+      - const: brcm,bcm5398
+      - items:
+          - const: brcm,bcm11360-srab
+          - const: brcm,cygnus-srab
+      - items:
+          - enum:
+              - brcm,bcm53010-srab
+              - brcm,bcm53011-srab
+              - brcm,bcm53012-srab
+              - brcm,bcm53018-srab
+              - brcm,bcm53019-srab
+          - const: brcm,bcm5301x-srab
+      - items:
+          - enum:
+              - brcm,bcm11404-srab
+              - brcm,bcm11407-srab
+              - brcm,bcm11409-srab
+              - brcm,bcm58310-srab
+              - brcm,bcm58311-srab
+              - brcm,bcm58313-srab
+          - const: brcm,omega-srab
+      - items:
+          - enum:
+              - brcm,bcm58522-srab
+              - brcm,bcm58523-srab
+              - brcm,bcm58525-srab
+              - brcm,bcm58622-srab
+              - brcm,bcm58623-srab
+              - brcm,bcm58625-srab
+              - brcm,bcm88312-srab
+          - const: brcm,nsp-srab
+      - items:
+          - enum:
+              - brcm,bcm3384-switch
+              - brcm,bcm6328-switch
+              - brcm,bcm6368-switch
+          - const: brcm,bcm63xx-switch
+
+required:
+  - compatible
+  - reg
+
+# BCM585xx/586xx/88312 SoCs
+if:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - brcm,bcm58522-srab
+          - brcm,bcm58523-srab
+          - brcm,bcm58525-srab
+          - brcm,bcm58622-srab
+          - brcm,bcm58623-srab
+          - brcm,bcm58625-srab
+          - brcm,bcm88312-srab
+then:
+  properties:
+    reg:
+      minItems: 3
+      maxItems: 3
+    reg-names:
+      items:
+        - const: srab
+        - const: mux_config
+        - const: sgmii_config
+    interrupts:
+      minItems: 13
+      maxItems: 13
+    interrupt-names:
+      items:
+        - const: link_state_p0
+        - const: link_state_p1
+        - const: link_state_p2
+        - const: link_state_p3
+        - const: link_state_p4
+        - const: link_state_p5
+        - const: link_state_p7
+        - const: link_state_p8
+        - const: phy
+        - const: ts
+        - const: imp_sleep_timer_p5
+        - const: imp_sleep_timer_p7
+        - const: imp_sleep_timer_p8
+  required:
+    - interrupts
+else:
+  properties:
+    reg:
+      maxItems: 1
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        switch@1e {
+            compatible = "brcm,bcm53125";
+            reg = <30>;
+
+            ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                    reg = <0>;
+                    label = "lan1";
+                };
+
+                port@1 {
+                    reg = <1>;
+                    label = "lan2";
+                };
+
+                port@5 {
+                    reg = <5>;
+                    label = "cable-modem";
+                    phy-mode = "rgmii-txid";
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                    };
+                };
+
+                port@8 {
+                    reg = <8>;
+                    label = "cpu";
+                    phy-mode = "rgmii-txid";
+                    ethernet = <&eth0>;
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                    };
+                };
+            };
+        };
+    };
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    axi {
+        #address-cells = <1>;
+        #size-cells = <1>;
+
+        switch@36000 {
+            compatible = "brcm,bcm58623-srab", "brcm,nsp-srab";
+            reg = <0x36000 0x1000>,
+                  <0x3f308 0x8>,
+                  <0x3f410 0xc>;
+            reg-names = "srab", "mux_config", "sgmii_config";
+            interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 98 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 99 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 100 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 104 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
+            interrupt-names = "link_state_p0",
+                              "link_state_p1",
+                              "link_state_p2",
+                              "link_state_p3",
+                              "link_state_p4",
+                              "link_state_p5",
+                              "link_state_p7",
+                              "link_state_p8",
+                              "phy",
+                              "ts",
+                              "imp_sleep_timer_p5",
+                              "imp_sleep_timer_p7",
+                              "imp_sleep_timer_p8";
+
+            ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                    label = "port0";
+                    reg = <0>;
+                };
+
+                port@1 {
+                    label = "port1";
+                    reg = <1>;
+                };
+
+                port@2 {
+                    label = "port2";
+                    reg = <2>;
+                };
+
+                port@3 {
+                    label = "port3";
+                    reg = <3>;
+                };
+
+                port@4 {
+                    label = "port4";
+                    reg = <4>;
+                };
+
+                port@8 {
+                    ethernet = <&amac2>;
+                    label = "cpu";
+                    reg = <8>;
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                    };
+                };
+            };
+        };
+    };
-- 
2.26.2

