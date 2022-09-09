Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4265B38EF
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 15:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiIIN0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 09:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiIIN0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 09:26:31 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B12FD138E56;
        Fri,  9 Sep 2022 06:26:29 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.93,303,1654527600"; 
   d="scan'208";a="134336784"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 09 Sep 2022 22:26:27 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 9F63743BD5A6;
        Fri,  9 Sep 2022 22:26:27 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, geert+renesas@glider.be
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 2/5] dt-bindings: net: renesas: Document Renesas Ethernet Switch
Date:   Fri,  9 Sep 2022 22:26:11 +0900
Message-Id: <20220909132614.1967276-3-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
References: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document Renesas Etherent Switch for R-Car S4-8 (r8a779f0).

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 .../bindings/net/renesas,etherswitch.yaml     | 252 ++++++++++++++++++
 1 file changed, 252 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/renesas,etherswitch.yaml

diff --git a/Documentation/devicetree/bindings/net/renesas,etherswitch.yaml b/Documentation/devicetree/bindings/net/renesas,etherswitch.yaml
new file mode 100644
index 000000000000..1affbf208829
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/renesas,etherswitch.yaml
@@ -0,0 +1,252 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/renesas,etherswitch.yaml#
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
+    maxItems: 3
+
+  reg-names:
+    items:
+      - const: base
+      - const: secure_base
+      - const: serdes
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
+    maxItems: 2
+
+  clock-names:
+    items:
+      - const: fck
+      - const: tsn
+
+  resets:
+    maxItems: 2
+
+  iommus:
+    maxItems: 16
+
+  power-domains:
+    maxItems: 1
+
+  '#address-cells':
+    description: Number of address cells for the MDIO bus.
+    const: 1
+
+  '#size-cells':
+    description: Number of size cells on the MDIO bus.
+    const: 0
+
+  ports:
+    type: object
+
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    additionalProperties: false
+
+    patternProperties:
+      "^port@[0-9a-f]+$":
+        type: object
+
+        $ref: "/schemas/net/ethernet-controller.yaml#"
+        unevaluatedProperties: false
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
+          phy-handle:
+            description:
+              Phandle of an Ethernet PHY.
+
+          phy-mode:
+            description:
+              This specifies the interface used by the Ethernet PHY.
+            enum:
+              - mii
+              - sgmii
+              - usxgmii
+
+        required:
+          - reg
+          - phy-handle
+          - phy-mode
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - interrupts
+  - interrupt-names
+  - clocks
+  - clock-names
+  - resets
+  - power-domains
+  - '#address-cells'
+  - '#size-cells'
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/r8a779f0-cpg-mssr.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/power/r8a779f0-sysc.h>
+
+    rswitch: ethernet@e6880000 {
+            compatible = "renesas,r8a779f0-ether-switch";
+            reg = <0xe6880000 0x20000>, <0xe68c0000 0x20000>,
+                  <0xe6444000 0xc00>;
+            reg-names = "base", "secure_base", "serdes";
+            interrupts = <GIC_SPI 256 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 257 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 258 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 259 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 260 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 261 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 262 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 263 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 266 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 267 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 268 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 269 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 270 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 271 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 273 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 274 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 276 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 277 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 278 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 280 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 281 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 282 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 283 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 284 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 285 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 286 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 287 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 288 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 289 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 290 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 291 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 292 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 293 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 294 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 295 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 296 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 297 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 298 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 299 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 300 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 301 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 302 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 304 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 305 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 306 IRQ_TYPE_LEVEL_HIGH>;
+            interrupt-names = "mfwd_error", "race_error",
+                              "coma_error", "gwca0_error",
+                              "gwca1_error", "etha0_error",
+                              "etha1_error", "etha2_error",
+                              "gptp0_status", "gptp1_status",
+                              "mfwd_status", "race_status",
+                              "coma_status", "gwca0_status",
+                              "gwca1_status", "etha0_status",
+                              "etha1_status", "etha2_status",
+                              "rmac0_status", "rmac1_status",
+                              "rmac2_status",
+                              "gwca0_rxtx0", "gwca0_rxtx1",
+                              "gwca0_rxtx2", "gwca0_rxtx3",
+                              "gwca0_rxtx4", "gwca0_rxtx5",
+                              "gwca0_rxtx6", "gwca0_rxtx7",
+                              "gwca1_rxtx0", "gwca1_rxtx1",
+                              "gwca1_rxtx2", "gwca1_rxtx3",
+                              "gwca1_rxtx4", "gwca1_rxtx5",
+                              "gwca1_rxtx6", "gwca1_rxtx7",
+                              "gwca0_rxts0", "gwca0_rxts1",
+                              "gwca1_rxts0", "gwca1_rxts1",
+                              "rmac0_mdio", "rmac1_mdio",
+                              "rmac2_mdio",
+                              "rmac0_phy", "rmac1_phy",
+                              "rmac2_phy";
+            #address-cells = <1>;
+            #size-cells = <0>;
+            clocks = <&cpg CPG_MOD 1506>, <&cpg CPG_MOD 1505>;
+            clock-names = "fck", "tsn";
+            power-domains = <&sysc R8A779F0_PD_ALWAYS_ON>;
+            resets = <&cpg 1506>, <&cpg 1505>;
+    };
-- 
2.25.1

