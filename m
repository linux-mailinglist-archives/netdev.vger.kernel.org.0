Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B40B654F79
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 12:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbiLWLKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 06:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiLWLKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 06:10:06 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CCD3B420;
        Fri, 23 Dec 2022 03:10:04 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2BNB9ZmT117432;
        Fri, 23 Dec 2022 05:09:35 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1671793775;
        bh=hs8A+ikrCIJXVeU90AWqoy3wS+jPweDvMoAC5HoKW7w=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=wbkmhF9lg+JmYa2jjf4KLUvFricC1NGJh0Oje7gm6nGzBExA/eU/OVv/CAH72L2GX
         +MnLtrqnZGf51BnISjvKoD6ee5j6Yyh2EhENyM3u8nN/YfDnufvoC3opKjE4+7A2eJ
         9+G1qYNZUnVYACdR/TCsjkvnmO7lUTo7wkaCok0g=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2BNB9Zjw115588
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 23 Dec 2022 05:09:35 -0600
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 23
 Dec 2022 05:09:35 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 23 Dec 2022 05:09:35 -0600
Received: from lelv0854.itg.ti.com (lelv0854.itg.ti.com [10.181.64.140])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2BNB9ZIl058720;
        Fri, 23 Dec 2022 05:09:35 -0600
Received: from localhost (a0501179-pc.dhcp.ti.com [10.24.69.114])
        by lelv0854.itg.ti.com (8.14.7/8.14.7) with ESMTP id 2BNB9XpI001011;
        Fri, 23 Dec 2022 05:09:34 -0600
From:   MD Danish Anwar <danishanwar@ti.com>
To:     "Andrew F. Davis" <afd@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Suman Anna <s-anna@ti.com>, Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Vignesh Raghavendra" <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, <andrew@lunn.ch>
CC:     <nm@ti.com>, <ssantosh@kernel.org>, <srk@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 1/2] dt-bindings: net: Add ICSSG Ethernet Driver bindings
Date:   Fri, 23 Dec 2022 16:39:29 +0530
Message-ID: <20221223110930.1337536-2-danishanwar@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221223110930.1337536-1-danishanwar@ti.com>
References: <20221223110930.1337536-1-danishanwar@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Puranjay Mohan <p-mohan@ti.com>

Add a YAML binding document for the ICSSG Programmable real time unit
based Ethernet driver. This driver uses the PRU and PRUSS consumer APIs
to interface the PRUs and load/run the firmware for supporting ethernet
functionality.

Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
Signed-off-by: Md Danish Anwar <danishanwar@ti.com>
---
 .../bindings/net/ti,icssg-prueth.yaml         | 174 ++++++++++++++++++
 1 file changed, 174 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml

diff --git a/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
new file mode 100644
index 000000000000..7659f5fd3132
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
@@ -0,0 +1,174 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/ti,icssg-prueth.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title:
+  Texas Instruments ICSSG PRUSS Ethernet
+
+maintainers:
+  - Puranjay Mohan <p-mohan@ti.com>
+  - Md Danish Anwar <danishanwar@ti.com>
+
+description:
+  Ethernet based on the Programmable Real-Time
+  Unit and Industrial Communication Subsystem.
+
+allOf:
+  - $ref: /schemas/remoteproc/ti,pru-consumer.yaml#
+
+properties:
+  compatible:
+    enum:
+      - ti,am654-icssg-prueth  # for AM65x SoC family
+
+  sram:
+    description:
+      phandle to MSMC SRAM node
+
+  dmas:
+    maxItems: 10
+
+  dma-names:
+    items:
+      - const: tx0-0
+      - const: tx0-1
+      - const: tx0-2
+      - const: tx0-3
+      - const: tx1-0
+      - const: tx1-1
+      - const: tx1-2
+      - const: tx1-3
+      - const: rx0
+      - const: rx1
+
+  ethernet-ports:
+    type: object
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      ^port@[0-1]$:
+        type: object
+        description: ICSSG PRUETH external ports
+
+        $ref: ethernet-controller.yaml#
+
+        unevaluatedProperties: false
+        additionalProperties: false
+        properties:
+          reg:
+            items:
+              - enum: [0, 1]
+            description: ICSSG PRUETH port number
+
+          ti,syscon-rgmii-delay:
+            $ref: /schemas/types.yaml#/definitions/phandle-array
+            description:
+              phandle to system controller node and register offset
+              to ICSSG control register for RGMII transmit delay
+
+        required:
+          - reg
+
+  ti,mii-g-rt:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: |
+      phandle to MII_G_RT module's syscon regmap.
+
+  ti,mii-rt:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: |
+      phandle to MII_RT module's syscon regmap
+
+  interrupts:
+    minItems: 2
+    maxItems: 2
+    description: |
+      Interrupt specifiers to TX timestamp IRQ.
+
+  interrupt-names:
+    items:
+      - const: tx_ts0
+      - const: tx_ts1
+
+required:
+  - compatible
+  - sram
+  - ti,mii-g-rt
+  - dmas
+  - dma-names
+  - ethernet-ports
+  - interrupts
+  - interrupt-names
+
+unevaluatedProperties: false
+
+examples:
+  - |
+
+    /* Example k3-am654 base board SR2.0, dual-emac */
+    pruss2_eth: pruss2_eth {
+        compatible = "ti,am654-icssg-prueth";
+        pinctrl-names = "default";
+        pinctrl-0 = <&icssg2_rgmii_pins_default>;
+        sram = <&msmc_ram>;
+
+        ti,prus = <&pru2_0>, <&rtu2_0>, <&tx_pru2_0>,
+                  <&pru2_1>, <&rtu2_1>, <&tx_pru2_1>;
+        firmware-name = "ti-pruss/am65x-pru0-prueth-fw.elf",
+                        "ti-pruss/am65x-rtu0-prueth-fw.elf",
+                        "ti-pruss/am65x-txpru0-prueth-fw.elf",
+                        "ti-pruss/am65x-pru1-prueth-fw.elf",
+                        "ti-pruss/am65x-rtu1-prueth-fw.elf",
+                        "ti-pruss/am65x-txpru1-prueth-fw.elf";
+        ti,pruss-gp-mux-sel = <2>,      /* MII mode */
+                              <2>,
+                              <2>,
+                              <2>,      /* MII mode */
+                              <2>,
+                              <2>;
+        ti,mii-g-rt = <&icssg2_mii_g_rt>;
+        dmas = <&main_udmap 0xc300>, /* egress slice 0 */
+               <&main_udmap 0xc301>, /* egress slice 0 */
+               <&main_udmap 0xc302>, /* egress slice 0 */
+               <&main_udmap 0xc303>, /* egress slice 0 */
+               <&main_udmap 0xc304>, /* egress slice 1 */
+               <&main_udmap 0xc305>, /* egress slice 1 */
+               <&main_udmap 0xc306>, /* egress slice 1 */
+               <&main_udmap 0xc307>, /* egress slice 1 */
+               <&main_udmap 0x4300>, /* ingress slice 0 */
+               <&main_udmap 0x4301>; /* ingress slice 1 */
+        dma-names = "tx0-0", "tx0-1", "tx0-2", "tx0-3",
+                    "tx1-0", "tx1-1", "tx1-2", "tx1-3",
+                    "rx0", "rx1";
+        interrupts = <24 0 2>, <25 1 3>;
+        interrupt-names = "tx_ts0", "tx_ts1";
+        ethernet-ports {
+            #address-cells = <1>;
+            #size-cells = <0>;
+            pruss2_emac0: port@0 {
+                reg = <0>;
+                phy-handle = <&pruss2_eth0_phy>;
+                phy-mode = "rgmii-rxid";
+                interrupts-extended = <&icssg2_intc 24>;
+                ti,syscon-rgmii-delay = <&scm_conf 0x4120>;
+                /* Filled in by bootloader */
+                local-mac-address = [00 00 00 00 00 00];
+            };
+
+            pruss2_emac1: port@1 {
+                reg = <1>;
+                phy-handle = <&pruss2_eth1_phy>;
+                phy-mode = "rgmii-rxid";
+                interrupts-extended = <&icssg2_intc 25>;
+                ti,syscon-rgmii-delay = <&scm_conf 0x4124>;
+                /* Filled in by bootloader */
+                local-mac-address = [00 00 00 00 00 00];
+            };
+        };
+    };
-- 
2.25.1

