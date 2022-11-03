Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010A26179F2
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 10:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiKCJ3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 05:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbiKCJ3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 05:29:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EA2EE13;
        Thu,  3 Nov 2022 02:28:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35BA0B826A0;
        Thu,  3 Nov 2022 09:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522ADC433D6;
        Thu,  3 Nov 2022 09:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667467726;
        bh=YX7U3anovdIFjTZlE83co/YJA3BUSpixBizJml4wk/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=efUrnmL6qEU0ko1OiftWOQbE73jR5FFJraYYyIT3eIZd5zD4WM/h4/mD2capY+mDr
         WiYS3jn5sjRHayQh2gTZZZIjsHBTkSpczRtr+PevlFkpBw1f7Id10NwHrdBs7xTR8F
         vek7Y4q1zZHQNdQVPnqbbeiIXRn6QxRRO9cYfyN0VcxF2MGEiSCpeif3+DTEsnbsOQ
         Rj9eTOwtdQQNsYJD1IpNmcMMlmVdSudQVZjQIqaCzCs2OUcfMdph6U5f0tNawelxLV
         TfY1KPkBgvu999qemGcAre5FP8YP/OkgGxkD8OphB3MDJZjekmKGuCxvlmAIlmvaQn
         KLW4wxCf8I40g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        daniel@makrotopia.org, krzysztof.kozlowski+dt@linaro.org
Subject: [PATCH v3 net-next 2/8] dt-bindings: net: mediatek: add WED RX binding for MT7986 eth driver
Date:   Thu,  3 Nov 2022 10:28:01 +0100
Message-Id: <2d92c3e282c6a788e54370604f966fc7a5b479bf.1667466887.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1667466887.git.lorenzo@kernel.org>
References: <cover.1667466887.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the binding for the RX Wireless Ethernet Dispatch core on the
MT7986 ethernet driver used to offload traffic received by WLAN NIC and
forwarded to LAN/WAN one.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../arm/mediatek/mediatek,mt7622-wed.yaml     | 62 ++++++++++++++++++-
 .../arm/mediatek/mediatek,mt7986-wo-boot.yaml | 47 ++++++++++++++
 .../arm/mediatek/mediatek,mt7986-wo-ccif.yaml | 50 +++++++++++++++
 .../arm/mediatek/mediatek,mt7986-wo-dlm.yaml  | 50 +++++++++++++++
 4 files changed, 206 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
index 84fb0a146b6e..9e34c5d15cec 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
 %YAML 1.2
 ---
-$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7622-wed.yaml#"
-$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+$id: http://devicetree.org/schemas/arm/mediatek/mediatek,mt7622-wed.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: MediaTek Wireless Ethernet Dispatch Controller for MT7622
 
@@ -29,6 +29,50 @@ properties:
   interrupts:
     maxItems: 1
 
+  memory-region:
+    items:
+      - description:
+          Phandle for the node used to run firmware EMI region
+      - description:
+          Phandle for the node used to run firmware ILM region
+      - description:
+          Phandle for the node used to run firmware CPU DATA region
+
+  memory-region-names:
+    items:
+      - const: wo-emi
+      - const: wo-ilm
+      - const: wo-data
+
+  mediatek,wo-ccif:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      Phandle to the mediatek wed-wo controller.
+
+  mediatek,wo-boot:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      Phandle to the mediatek wed-wo boot interface.
+
+  mediatek,wo-dlm:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      Phandle to the mediatek wed-wo rx hw ring.
+
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: mediatek,mt7622-wed
+    then:
+      properties:
+        memory-region-names: false
+        memory-region: false
+        mediatek,wo-boot: false
+        mediatek,wo-ccif: false
+        mediatek,wo-dlm: false
+
 required:
   - compatible
   - reg
@@ -44,8 +88,20 @@ examples:
       #address-cells = <2>;
       #size-cells = <2>;
       wed0: wed@1020a000 {
-        compatible = "mediatek,mt7622-wed","syscon";
+        compatible = "mediatek,mt7622-wed", "syscon";
         reg = <0 0x1020a000 0 0x1000>;
         interrupts = <GIC_SPI 214 IRQ_TYPE_LEVEL_LOW>;
       };
+
+      wed1: wed@15010000 {
+        compatible = "mediatek,mt7986-wed", "syscon";
+        reg = <0 0x15010000 0 0x1000>;
+        interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
+
+        memory-region = <&wo_emi>, <&wo_data>, <&wo_ilm>;
+        memory-region-names = "wo-emi", "wo-ilm", "wo-data";
+        mediatek,wo-ccif = <&wo_ccif0>;
+        mediatek,wo-boot = <&wo_boot>;
+        mediatek,wo-dlm = <&wo_dlm0>;
+      };
     };
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml
new file mode 100644
index 000000000000..6c3c514c48ef
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml
@@ -0,0 +1,47 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-boot.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title:
+  MediaTek Wireless Ethernet Dispatch WO boot controller interface for MT7986
+
+maintainers:
+  - Lorenzo Bianconi <lorenzo@kernel.org>
+  - Felix Fietkau <nbd@nbd.name>
+
+description:
+  The mediatek wo-boot provides a configuration interface for WED WO
+  boot controller on MT7986 soc.
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - mediatek,mt7986-wo-boot
+      - const: syscon
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+
+      wo_boot: syscon@15194000 {
+        compatible = "mediatek,mt7986-wo-boot", "syscon";
+        reg = <0 0x15194000 0 0x1000>;
+      };
+    };
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml
new file mode 100644
index 000000000000..6357a206587a
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml
@@ -0,0 +1,50 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-ccif.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek Wireless Ethernet Dispatch WO controller interface for MT7986
+
+maintainers:
+  - Lorenzo Bianconi <lorenzo@kernel.org>
+  - Felix Fietkau <nbd@nbd.name>
+
+description:
+  The mediatek wo-ccif provides a configuration interface for WED WO
+  controller on MT7986 soc.
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - mediatek,mt7986-wo-ccif
+      - const: syscon
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+
+      wo_ccif0: syscon@151a5000 {
+        compatible = "mediatek,mt7986-wo-ccif", "syscon";
+        reg = <0 0x151a5000 0 0x1000>;
+        interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
+      };
+    };
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml
new file mode 100644
index 000000000000..a499956d9e07
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml
@@ -0,0 +1,50 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-dlm.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek Wireless Ethernet Dispatch WO hw rx ring interface for MT7986
+
+maintainers:
+  - Lorenzo Bianconi <lorenzo@kernel.org>
+  - Felix Fietkau <nbd@nbd.name>
+
+description:
+  The mediatek wo-dlm provides a configuration interface for WED WO
+  rx ring on MT7986 soc.
+
+properties:
+  compatible:
+    const: mediatek,mt7986-wo-dlm
+
+  reg:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - resets
+  - reset-names
+
+additionalProperties: false
+
+examples:
+  - |
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+
+      wo_dlm0: wo-dlm@151e8000 {
+        compatible = "mediatek,mt7986-wo-dlm";
+        reg = <0 0x151e8000 0 0x2000>;
+        resets = <&ethsysrst 0>;
+        reset-names = "wocpu_rst";
+      };
+    };
-- 
2.38.1

