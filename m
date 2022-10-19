Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B35603B8E
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 10:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiJSIf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 04:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiJSIf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 04:35:26 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABD3C3BC61;
        Wed, 19 Oct 2022 01:35:24 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,195,1661785200"; 
   d="scan'208";a="139550055"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 19 Oct 2022 17:35:24 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id F3C12422C554;
        Wed, 19 Oct 2022 17:35:23 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH v4 1/3] dt-bindings: net: renesas: Document Renesas Ethernet Switch
Date:   Wed, 19 Oct 2022 17:35:16 +0900
Message-Id: <20221019083518.933070-2-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221019083518.933070-1-yoshihiro.shimoda.uh@renesas.com>
References: <20221019083518.933070-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document Renesas Etherent Switch for R-Car S4-8 (r8a779f0).

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 .../net/renesas,r8a779f0-ether-switch.yaml    | 265 ++++++++++++++++++
 1 file changed, 265 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml

diff --git a/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml b/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml
new file mode 100644
index 000000000000..049548528e61
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml
@@ -0,0 +1,265 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/renesas,r8a779f0-ether-switch.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Renesas Ethernet Switch
+
+maintainers:
+  - Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
+
+properties:
+  compatible:
+    const: renesas,r8a779f0-ether-switch
+
+  reg:
+    maxItems: 2
+
+  reg-names:
+    items:
+      - const: base
+      - const: secure_base
+
+  interrupts:
+    maxItems: 47
+
+  interrupt-names:
+    items:
+      - const: mfwd_error
+      - const: race_error
+      - const: coma_error
+      - const: gwca0_error
+      - const: gwca1_error
+      - const: etha0_error
+      - const: etha1_error
+      - const: etha2_error
+      - const: gptp0_status
+      - const: gptp1_status
+      - const: mfwd_status
+      - const: race_status
+      - const: coma_status
+      - const: gwca0_status
+      - const: gwca1_status
+      - const: etha0_status
+      - const: etha1_status
+      - const: etha2_status
+      - const: rmac0_status
+      - const: rmac1_status
+      - const: rmac2_status
+      - const: gwca0_rxtx0
+      - const: gwca0_rxtx1
+      - const: gwca0_rxtx2
+      - const: gwca0_rxtx3
+      - const: gwca0_rxtx4
+      - const: gwca0_rxtx5
+      - const: gwca0_rxtx6
+      - const: gwca0_rxtx7
+      - const: gwca1_rxtx0
+      - const: gwca1_rxtx1
+      - const: gwca1_rxtx2
+      - const: gwca1_rxtx3
+      - const: gwca1_rxtx4
+      - const: gwca1_rxtx5
+      - const: gwca1_rxtx6
+      - const: gwca1_rxtx7
+      - const: gwca0_rxts0
+      - const: gwca0_rxts1
+      - const: gwca1_rxts0
+      - const: gwca1_rxts1
+      - const: rmac0_mdio
+      - const: rmac1_mdio
+      - const: rmac2_mdio
+      - const: rmac0_phy
+      - const: rmac1_phy
+      - const: rmac2_phy
+
+  clocks:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+  iommus:
+    maxItems: 16
+
+  power-domains:
+    maxItems: 1
+
+  ethernet-ports:
+    type: object
+    additionalProperties: false
+
+    properties:
+      '#address-cells':
+        description: Port number of ETHA (TSNA).
+        const: 1
+
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      "^port@[0-9a-f]+$":
+        type: object
+        $ref: /schemas/net/ethernet-controller.yaml#
+        unevaluatedProperties: false
+
+        properties:
+          reg:
+            description:
+              Port number of ETHA (TSNA).
+
+          phy-handle: true
+
+          phy-mode: true
+
+          phys:
+            maxItems: 1
+            description:
+              Phandle of an Ethernet SERDES.
+
+          mdio:
+            $ref: /schemas/net/mdio.yaml#
+            unevaluatedProperties: false
+
+        required:
+          - reg
+          - phy-handle
+          - phy-mode
+          - phys
+          - mdio
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - interrupts
+  - interrupt-names
+  - clocks
+  - resets
+  - power-domains
+  - ethernet-ports
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/r8a779f0-cpg-mssr.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/power/r8a779f0-sysc.h>
+
+    ethernet@e6880000 {
+        compatible = "renesas,r8a779f0-ether-switch";
+        reg = <0xe6880000 0x20000>, <0xe68c0000 0x20000>;
+        reg-names = "base", "secure_base";
+        interrupts = <GIC_SPI 256 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 257 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 258 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 259 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 260 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 261 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 262 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 263 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 266 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 267 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 268 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 269 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 270 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 271 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 273 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 274 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 276 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 277 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 278 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 280 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 281 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 282 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 283 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 284 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 285 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 286 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 287 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 288 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 289 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 290 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 291 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 292 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 293 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 294 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 295 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 296 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 297 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 298 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 299 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 300 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 301 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 302 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 304 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 305 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 306 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "mfwd_error", "race_error",
+                          "coma_error", "gwca0_error",
+                          "gwca1_error", "etha0_error",
+                          "etha1_error", "etha2_error",
+                          "gptp0_status", "gptp1_status",
+                          "mfwd_status", "race_status",
+                          "coma_status", "gwca0_status",
+                          "gwca1_status", "etha0_status",
+                          "etha1_status", "etha2_status",
+                          "rmac0_status", "rmac1_status",
+                          "rmac2_status",
+                          "gwca0_rxtx0", "gwca0_rxtx1",
+                          "gwca0_rxtx2", "gwca0_rxtx3",
+                          "gwca0_rxtx4", "gwca0_rxtx5",
+                          "gwca0_rxtx6", "gwca0_rxtx7",
+                          "gwca1_rxtx0", "gwca1_rxtx1",
+                          "gwca1_rxtx2", "gwca1_rxtx3",
+                          "gwca1_rxtx4", "gwca1_rxtx5",
+                          "gwca1_rxtx6", "gwca1_rxtx7",
+                          "gwca0_rxts0", "gwca0_rxts1",
+                          "gwca1_rxts0", "gwca1_rxts1",
+                          "rmac0_mdio", "rmac1_mdio",
+                          "rmac2_mdio",
+                          "rmac0_phy", "rmac1_phy",
+                          "rmac2_phy";
+        clocks = <&cpg CPG_MOD 1505>;
+        power-domains = <&sysc R8A779F0_PD_ALWAYS_ON>;
+        resets = <&cpg 1505>;
+
+        ethernet-ports {
+            #address-cells = <1>;
+            #size-cells = <0>;
+            port@0 {
+                reg = <0>;
+                phy-handle = <&eth_phy0>;
+                phy-mode = "sgmii";
+                phys = <&eth_serdes 0>;
+                mdio {
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+                };
+            };
+            port@1 {
+                reg = <1>;
+                phy-handle = <&eth_phy1>;
+                phy-mode = "sgmii";
+                phys = <&eth_serdes 1>;
+                mdio {
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+                };
+            };
+            port@2 {
+                reg = <2>;
+                phy-handle = <&eth_phy2>;
+                phy-mode = "sgmii";
+                phys = <&eth_serdes 2>;
+                mdio {
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+                };
+            };
+        };
+    };
-- 
2.25.1

