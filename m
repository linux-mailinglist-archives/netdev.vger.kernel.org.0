Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E161669146C
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 00:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjBIXbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 18:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjBIXbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 18:31:21 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D73B272E;
        Thu,  9 Feb 2023 15:31:20 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pQGNq-0002EZ-0Q;
        Fri, 10 Feb 2023 00:31:18 +0100
Date:   Thu, 9 Feb 2023 23:29:40 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: [PATCH v3 03/12] dt-bindings: arm: mediatek: sgmiisys: Convert to DT
 schema
Message-ID: <c128e3e4f771483abb713572d4123aed78de35ef.1675984550.git.daniel@makrotopia.org>
References: <cover.1675984550.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1675984550.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mediatek,sgmiiisys bindings to DT schema format.
Add maintainer Matthias Brugger, no maintainers were listed in the
original documentation.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 .../arm/mediatek/mediatek,sgmiisys.txt        | 27 ----------
 .../arm/mediatek/mediatek,sgmiisys.yaml       | 53 +++++++++++++++++++
 2 files changed, 53 insertions(+), 27 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
deleted file mode 100644
index d2c24c277514..000000000000
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
+++ /dev/null
@@ -1,27 +0,0 @@
-MediaTek SGMIISYS controller
-============================
-
-The MediaTek SGMIISYS controller provides various clocks to the system.
-
-Required Properties:
-
-- compatible: Should be:
-	- "mediatek,mt7622-sgmiisys", "syscon"
-	- "mediatek,mt7629-sgmiisys", "syscon"
-	- "mediatek,mt7981-sgmiisys_0", "syscon"
-	- "mediatek,mt7981-sgmiisys_1", "syscon"
-	- "mediatek,mt7986-sgmiisys_0", "syscon"
-	- "mediatek,mt7986-sgmiisys_1", "syscon"
-- #clock-cells: Must be 1
-
-The SGMIISYS controller uses the common clk binding from
-Documentation/devicetree/bindings/clock/clock-bindings.txt
-The available clocks are defined in dt-bindings/clock/mt*-clk.h.
-
-Example:
-
-sgmiisys: sgmiisys@1b128000 {
-	compatible = "mediatek,mt7622-sgmiisys", "syscon";
-	reg = <0 0x1b128000 0 0x1000>;
-	#clock-cells = <1>;
-};
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml
new file mode 100644
index 000000000000..99ceb08ad7c0
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml
@@ -0,0 +1,53 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,sgmiisys.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: MediaTek SGMIISYS Controller
+
+maintainers:
+  - Matthias Brugger <matthias.bgg@gmail.com>
+
+description:
+  The MediaTek SGMIISYS controller provides SGMII related clocks to the system
+  and is used by the Ethernet controller as SGMII PCS.
+
+properties:
+  $nodename:
+    pattern: "^syscon@[0-9a-f]+$"
+
+  compatible:
+    oneOf:
+      - items:
+          - enum:
+              - mediatek,mt7622-sgmiisys
+              - mediatek,mt7629-sgmiisys
+              - mediatek,mt7986-sgmiisys_0
+              - mediatek,mt7986-sgmiisys_1
+          - const: syscon
+
+  reg:
+    maxItems: 1
+
+  '#clock-cells':
+    const: 1
+
+required:
+  - compatible
+  - reg
+  - '#clock-cells'
+
+additionalProperties: false
+
+examples:
+  - |
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+      sgmiisys: syscon@1b128000 {
+        compatible = "mediatek,mt7622-sgmiisys", "syscon";
+        reg = <0 0x1b128000 0 0x1000>;
+        #clock-cells = <1>;
+      };
+    };
-- 
2.39.1

