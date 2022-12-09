Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31307648782
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiLIRQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLIRQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:16:21 -0500
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890A63C6FB;
        Fri,  9 Dec 2022 09:16:20 -0800 (PST)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-1447c7aa004so469040fac.11;
        Fri, 09 Dec 2022 09:16:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IwxqxBCPakFkimAmEbcTrjphzN962ux7QwhcuLBuAmM=;
        b=zLzUIipIRbqc8zMjSxHgDpdhwGjLVZT4csii7QvUVcdyvLAiViPOq+CbZiTeLFPuvh
         9XpsGCqF5jBk4I1lkCWQlTJEQrTy1vXLCjLOoMiEAYl2lbih7AOzaKdwCG6+1nCadHfm
         TDcinoqP27/AXW7Oi7YZ1fMm8+Lct8EslKpZikVL5c5Wr1Ei8+3CxW2WWcQaTpI83WKK
         PTJyoCvSs6fY4IfMd1dThaVw+MdfvILFa2IJj6vJCaWZmo5Q9Gtfyw5hFmYfjePHg5v+
         lO6QjuJxx7mrMofAlJFuEFjh4WuX2pJ3LAJBk1b9AXA2QXfrAVGRJfoY3KEnucDlLmrX
         mwwg==
X-Gm-Message-State: ANoB5plilSPCeJE/Y6zslcHGAgT7UGoEUYA8QSiIF+s7PjBePi/GhbOb
        TA4F6x5s9wvtbi1ca8BRLQ==
X-Google-Smtp-Source: AA0mqf7b7ej9ufgS3AIASEAr21dJPuxpBJoIyfIyZHzzHoY4dlYLgtH0OCJlVPxdixsPIxnEPgM+pQ==
X-Received: by 2002:a05:6870:b10:b0:144:db8f:9e0b with SMTP id lh16-20020a0568700b1000b00144db8f9e0bmr3520626oab.29.1670606179379;
        Fri, 09 Dec 2022 09:16:19 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id fo6-20020a0568709a0600b00142fa439ee5sm1089954oab.39.2022.12.09.09.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 09:16:18 -0800 (PST)
Received: (nullmailer pid 3351156 invoked by uid 1000);
        Fri, 09 Dec 2022 17:16:18 -0000
From:   Rob Herring <robh@kernel.org>
To:     Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: Convert Socionext NetSec Ethernet to DT schema
Date:   Fri,  9 Dec 2022 11:15:52 -0600
Message-Id: <20221209171553.3350583-1-robh@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Socionext NetSec Ethernet binding to DT schema format.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../net/socionext,synquacer-netsec.yaml       | 73 +++++++++++++++++++
 .../bindings/net/socionext-netsec.txt         | 56 --------------
 MAINTAINERS                                   |  2 +-
 3 files changed, 74 insertions(+), 57 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/socionext,synquacer-netsec.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/socionext-netsec.txt

diff --git a/Documentation/devicetree/bindings/net/socionext,synquacer-netsec.yaml b/Documentation/devicetree/bindings/net/socionext,synquacer-netsec.yaml
new file mode 100644
index 000000000000..a65e6aa215a7
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/socionext,synquacer-netsec.yaml
@@ -0,0 +1,73 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/socionext,synquacer-netsec.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Socionext NetSec Ethernet Controller IP
+
+maintainers:
+  - Jassi Brar <jaswinder.singh@linaro.org>
+  - Ilias Apalodimas <ilias.apalodimas@linaro.org>
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    const: socionext,synquacer-netsec
+
+  reg:
+    items:
+      - description: control register area
+      - description: EEPROM holding the MAC address and microengine firmware
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    const: phy_ref_clk
+
+  dma-coherent: true
+
+  interrupts:
+    maxItems: 1
+
+  mdio:
+    $ref: mdio.yaml#
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+  - interrupts
+  - mdio
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    ethernet@522d0000 {
+        compatible = "socionext,synquacer-netsec";
+        reg = <0x522d0000 0x10000>, <0x10000000 0x10000>;
+        interrupts = <GIC_SPI 176 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&clk_netsec>;
+        clock-names = "phy_ref_clk";
+        phy-mode = "rgmii";
+        max-speed = <1000>;
+        max-frame-size = <9000>;
+        phy-handle = <&phy1>;
+
+        mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+            phy1: ethernet-phy@1 {
+                compatible = "ethernet-phy-ieee802.3-c22";
+                reg = <1>;
+            };
+        };
+    };
+...
diff --git a/Documentation/devicetree/bindings/net/socionext-netsec.txt b/Documentation/devicetree/bindings/net/socionext-netsec.txt
deleted file mode 100644
index a3c1dffaa4bb..000000000000
--- a/Documentation/devicetree/bindings/net/socionext-netsec.txt
+++ /dev/null
@@ -1,56 +0,0 @@
-* Socionext NetSec Ethernet Controller IP
-
-Required properties:
-- compatible: Should be "socionext,synquacer-netsec"
-- reg: Address and length of the control register area, followed by the
-       address and length of the EEPROM holding the MAC address and
-       microengine firmware
-- interrupts: Should contain ethernet controller interrupt
-- clocks: phandle to the PHY reference clock
-- clock-names: Should be "phy_ref_clk"
-- phy-mode: See ethernet.txt file in the same directory
-- phy-handle: See ethernet.txt in the same directory.
-
-- mdio device tree subnode: When the Netsec has a phy connected to its local
-		mdio, there must be device tree subnode with the following
-		required properties:
-
-	- #address-cells: Must be <1>.
-	- #size-cells: Must be <0>.
-
-	For each phy on the mdio bus, there must be a node with the following
-	fields:
-	- compatible: Refer to phy.txt
-	- reg: phy id used to communicate to phy.
-
-Optional properties: (See ethernet.txt file in the same directory)
-- dma-coherent: Boolean property, must only be present if memory
-	accesses performed by the device are cache coherent.
-- max-speed: See ethernet.txt in the same directory.
-- max-frame-size: See ethernet.txt in the same directory.
-
-The MAC address will be determined using the optional properties
-defined in ethernet.txt. The 'phy-mode' property is required, but may
-be set to the empty string if the PHY configuration is programmed by
-the firmware or set by hardware straps, and needs to be preserved.
-
-Example:
-	eth0: ethernet@522d0000 {
-		compatible = "socionext,synquacer-netsec";
-		reg = <0 0x522d0000 0x0 0x10000>, <0 0x10000000 0x0 0x10000>;
-		interrupts = <GIC_SPI 176 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&clk_netsec>;
-		clock-names = "phy_ref_clk";
-		phy-mode = "rgmii";
-		max-speed = <1000>;
-		max-frame-size = <9000>;
-		phy-handle = <&phy1>;
-
-		mdio {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			phy1: ethernet-phy@1 {
-				compatible = "ethernet-phy-ieee802.3-c22";
-				reg = <1>;
-			};
-		};
diff --git a/MAINTAINERS b/MAINTAINERS
index 1f81f0399efa..54178ecb2590 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19029,7 +19029,7 @@ M:	Jassi Brar <jaswinder.singh@linaro.org>
 M:	Ilias Apalodimas <ilias.apalodimas@linaro.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/net/socionext-netsec.txt
+F:	Documentation/devicetree/bindings/net/socionext,synquacer-netsec.yaml
 F:	drivers/net/ethernet/socionext/netsec.c
 
 SOCIONEXT (SNI) Synquacer SPI DRIVER
-- 
2.35.1

