Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272DB5BE2C0
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 12:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiITKMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 06:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiITKMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 06:12:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78EA5F7FC;
        Tue, 20 Sep 2022 03:12:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8B8361193;
        Tue, 20 Sep 2022 10:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDB5C433D6;
        Tue, 20 Sep 2022 10:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663668721;
        bh=sOgb8gCYIQifFb9gx4t/0bcTOJ4i+MYKAqE4XXafw8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFwFislgvzGSFl9HxDHQiA2NhCZljFFZF/+x4zGZ55YuiAOnySSC+3hPKh7FbyxmA
         fHd6YHGk2qBRp+k5f38rACEevF4hNWGd7sNk5vR1M/hor6HUId4Y3/SFZC74A4CaSf
         VRw5v8FNUkwN5mGNNzkd/A0vMTvmJxHDvEyk6WHRDZ7zSSNYdnZ6JuWawZA/zXIjkR
         y6W01SJXqkv2DUDqrduRGF3raVyjBdK6WLUsZEzpnmazKHLhPXVxQSXCamV3e2UHVe
         CoQXUMjDE/+mZwiL8xxL5sxMfx0z4PhunxSMCbt1Rmvp5pOCKCTUuGJK3VeXAcMsla
         R03feCEvGsDeQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
Subject: [PATCH v3 net-next 02/11] dt-bindings: net: mediatek: add WED binding for MT7986 eth driver
Date:   Tue, 20 Sep 2022 12:11:14 +0200
Message-Id: <163c6def2dfea5ab340f8a2a93e766088e2fb642.1663668203.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1663668203.git.lorenzo@kernel.org>
References: <cover.1663668203.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the binding for the Wireless Ethernet Dispatch core on the
MT7986 ethernet driver

Reviewed-by: Rob Herring <robh@kernel.org>
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

