Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852205B78F7
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 20:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiIMSAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 14:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiIMR7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 13:59:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2096FA1D31;
        Tue, 13 Sep 2022 10:01:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 542A761414;
        Tue, 13 Sep 2022 17:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67693C433C1;
        Tue, 13 Sep 2022 17:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663088507;
        bh=wm12Hio92i/8JMj155OBAKnvdcQb74N+qR/MF5Gc1mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ouJBhf++du5YpbshAqH6/7+RJCt1Go7zOR6YVNJ2eLH2dhyRr04+gq4cu4/CJU55J
         T31SFtA4rwz1+1583Nh0i81V/i17vGL87juasjb+YS4sQ/iIgJ0dfdGQC56FBgW9pT
         9x8ivgf7jEUDYK/uO+QKQRGwWU9yHD6ZmoLr4oMPmRQ0FxW87ilVJUEntvAWPwApkA
         Xsn4GJwGyQ/M5/BU1VprcfJsUZCKdNYOMijLnToE+G8M1P4Hl9wKtYcZsJ6JxxNHHj
         2sRiz/PhJ4tWX9tTrcO3S42bib4wQ0xEMhWQjDoDVEhk3yCm8SV2Y0uU+lMoFPyOZc
         VCByCkjhAcY+Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
Subject: [PATCH v2 net-next 02/11] dt-bindings: net: mediatek: add WED binding for MT7986 eth driver
Date:   Tue, 13 Sep 2022 19:00:52 +0200
Message-Id: <2d05849aa9fdb5d14897adc51fcd93ace27f610d.1663087836.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1663087836.git.lorenzo@kernel.org>
References: <cover.1663087836.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the binding for the Wireless Ethernet Dispatch core on the
MT7986 ethernet driver

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../arm/mediatek/mediatek,mt7622-wed.yaml     |  1 +
 .../mediatek/mediatek,mt7986-wed-pcie.yaml    | 43 +++++++++++++++++++
 .../devicetree/bindings/net/mediatek,net.yaml | 27 ++++++++----
 3 files changed, 62 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wed-pcie.yaml

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
index 787d6673f952..84fb0a146b6e 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
@@ -20,6 +20,7 @@ properties:
     items:
       - enum:
           - mediatek,mt7622-wed
+          - mediatek,mt7986-wed
       - const: syscon
 
   reg:
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wed-pcie.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wed-pcie.yaml
new file mode 100644
index 000000000000..96221f51c1c3
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wed-pcie.yaml
@@ -0,0 +1,43 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wed-pcie.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: MediaTek PCIE WED Controller for MT7986
+
+maintainers:
+  - Lorenzo Bianconi <lorenzo@kernel.org>
+  - Felix Fietkau <nbd@nbd.name>
+
+description:
+  The mediatek WED PCIE provides a configuration interface for PCIE
+  controller on MT7986 soc.
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - mediatek,mt7986-wed-pcie
+      - const: syscon
+
+  reg:
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
+      wed_pcie: wed-pcie@10003000 {
+        compatible = "mediatek,mt7986-wed-pcie",
+                     "syscon";
+        reg = <0 0x10003000 0 0x10>;
+      };
+    };
diff --git a/Documentation/devicetree/bindings/net/mediatek,net.yaml b/Documentation/devicetree/bindings/net/mediatek,net.yaml
index f5564ecddb62..7ef696204c5a 100644
--- a/Documentation/devicetree/bindings/net/mediatek,net.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek,net.yaml
@@ -69,6 +69,15 @@ properties:
       A list of phandle to the syscon node that handles the SGMII setup which is required for
       those SoCs equipped with SGMII.
 
+  mediatek,wed:
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    minItems: 2
+    maxItems: 2
+    items:
+      maxItems: 1
+    description:
+      List of phandles to wireless ethernet dispatch nodes.
+
   dma-coherent: true
 
   mdio-bus:
@@ -112,6 +121,8 @@ allOf:
             Phandle to the syscon node that handles the ports slew rate and
             driver current.
 
+        mediatek,wed: false
+
   - if:
       properties:
         compatible:
@@ -144,15 +155,6 @@ allOf:
           minItems: 1
           maxItems: 1
 
-        mediatek,wed:
-          $ref: /schemas/types.yaml#/definitions/phandle-array
-          minItems: 2
-          maxItems: 2
-          items:
-            maxItems: 1
-          description:
-            List of phandles to wireless ethernet dispatch nodes.
-
         mediatek,pcie-mirror:
           $ref: /schemas/types.yaml#/definitions/phandle
           description:
@@ -202,6 +204,8 @@ allOf:
           minItems: 2
           maxItems: 2
 
+        mediatek,wed: false
+
   - if:
       properties:
         compatible:
@@ -238,6 +242,11 @@ allOf:
           minItems: 2
           maxItems: 2
 
+        mediatek,wed-pcie:
+          $ref: /schemas/types.yaml#/definitions/phandle
+          description:
+            Phandle to the mediatek wed-pcie controller.
+
 patternProperties:
   "^mac@[0-1]$":
     type: object
-- 
2.37.3

