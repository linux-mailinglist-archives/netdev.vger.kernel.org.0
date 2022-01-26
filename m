Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A3449D428
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 22:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiAZVLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 16:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbiAZVLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 16:11:37 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B90C06173B
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 13:11:37 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id u15so1201001wrt.3
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 13:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3FEiW1X94C/i5Fq6cjS066qKz7PGloLVknC6qoY6ptc=;
        b=sIVUmRPSjRmA0WryHY9N3K0BzQiklgGLUixhH7/sCvIlLCPLNashx6S/yeqiyuCZkg
         Fg5m8vpqfDxrWwC8dXeNW3RWuvXGVPh7ZFMEi7D4UVnVAnJB4JrZsHhTOqGKPQ7OJQgq
         huXJ5AwSUqfVg4ULjzna/E5rtIugcX3OERTJbFbkUMYItCZyA/QoRmaZ3Dh61fVH2Mlp
         w1gOYNHp8T2ypQBembErR33xuCIvuWOzLzwDwuTxQ7jS4yO9y9AKrWlNAdhkAY2mN2hC
         KMHYH6PHxKSiBYZwGERCuiK9mFHm0BxbWA6dxhBAj6S9xJ+prmL8U2sFcFGLQSZ3AP5S
         xc0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3FEiW1X94C/i5Fq6cjS066qKz7PGloLVknC6qoY6ptc=;
        b=pu1oHDAdYkvjiyfE0Rn9eSNFfmAG/FO3RiL8VH00Hqoq2tzl+6J/61FUbwojpPGH8B
         UurNtDIib30NGICavf+kNjPUrCN5mWyVNqIHSy88vvydnoxN/IPjzSp3Cq3PiOHPIvXn
         S39GZXfD+Q6B+A/wRELQgEvkaxV8h+9JMAssyFLKXis9AyZUJPGp8J6X61Q38yqcQ6ld
         Frz+74RHwzgXxw2xWvSglzJzAwJ6uZwpQyd9jJy1ekSaeTGRF8SFJMKIuGUKK58VYqv+
         mJFnujY+vA7DHKfG/RB4QzC8ZxdrFMoT/ffA/8HrFXiX8iQvRPC/qPt2WGXF0CB2jzG4
         pzcw==
X-Gm-Message-State: AOAM531WzqDA6i8HFXzw9un5aVKejcHWbJIOv26mVWkqMC8PLgGrErYA
        b72DeHmSEz39TYiwWYWj/ST2jw==
X-Google-Smtp-Source: ABdhPJw97joQxHgaHu23aJL8beZot82hawRW4Lo7gEBLPS/ZOA9YnLR2SjZfiiKRrxwSMfvP91aD2A==
X-Received: by 2002:a5d:59af:: with SMTP id p15mr368115wrr.488.1643231495636;
        Wed, 26 Jan 2022 13:11:35 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o12sm342178wmq.41.2022.01.26.13.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 13:11:35 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        robh+dt@kernel.org, ulli.kroll@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] dt-bindings: net: convert net/cortina,gemini-ethernet to yaml
Date:   Wed, 26 Jan 2022 21:11:28 +0000
Message-Id: <20220126211128.3663486-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Converts net/cortina,gemini-ethernet.txt to yaml
This permits to detect some missing properties like interrupts

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../bindings/net/cortina,gemini-ethernet.txt  |  92 ------------
 .../bindings/net/cortina,gemini-ethernet.yaml | 138 ++++++++++++++++++
 2 files changed, 138 insertions(+), 92 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/cortina,gemini-ethernet.txt
 create mode 100644 Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml

diff --git a/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.txt b/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.txt
deleted file mode 100644
index 6c559981d110..000000000000
--- a/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.txt
+++ /dev/null
@@ -1,92 +0,0 @@
-Cortina Systems Gemini Ethernet Controller
-==========================================
-
-This ethernet controller is found in the Gemini SoC family:
-StorLink SL3512 and SL3516, also known as Cortina Systems
-CS3512 and CS3516.
-
-Required properties:
-- compatible: must be "cortina,gemini-ethernet"
-- reg: must contain the global registers and the V-bit and A-bit
-  memory areas, in total three register sets.
-- syscon: a phandle to the system controller
-- #address-cells: must be specified, must be <1>
-- #size-cells: must be specified, must be <1>
-- ranges: should be state like this giving a 1:1 address translation
-  for the subnodes
-
-The subnodes represents the two ethernet ports in this device.
-They are not independent of each other since they share resources
-in the parent node, and are thus children.
-
-Required subnodes:
-- port0: contains the resources for ethernet port 0
-- port1: contains the resources for ethernet port 1
-
-Required subnode properties:
-- compatible: must be "cortina,gemini-ethernet-port"
-- reg: must contain two register areas: the DMA/TOE memory and
-  the GMAC memory area of the port
-- interrupts: should contain the interrupt line of the port.
-  this is nominally a level interrupt active high.
-- resets: this must provide an SoC-integrated reset line for
-  the port.
-- clocks: this should contain a handle to the PCLK clock for
-  clocking the silicon in this port
-- clock-names: must be "PCLK"
-
-Optional subnode properties:
-- phy-mode: see ethernet.txt
-- phy-handle: see ethernet.txt
-
-Example:
-
-mdio-bus {
-	(...)
-	phy0: ethernet-phy@1 {
-		reg = <1>;
-		device_type = "ethernet-phy";
-	};
-	phy1: ethernet-phy@3 {
-		reg = <3>;
-		device_type = "ethernet-phy";
-	};
-};
-
-
-ethernet@60000000 {
-	compatible = "cortina,gemini-ethernet";
-	reg = <0x60000000 0x4000>, /* Global registers, queue */
-	      <0x60004000 0x2000>, /* V-bit */
-	      <0x60006000 0x2000>; /* A-bit */
-	syscon = <&syscon>;
-	#address-cells = <1>;
-	#size-cells = <1>;
-	ranges;
-
-	gmac0: ethernet-port@0 {
-		compatible = "cortina,gemini-ethernet-port";
-		reg = <0x60008000 0x2000>, /* Port 0 DMA/TOE */
-		      <0x6000a000 0x2000>; /* Port 0 GMAC */
-		interrupt-parent = <&intcon>;
-		interrupts = <1 IRQ_TYPE_LEVEL_HIGH>;
-		resets = <&syscon GEMINI_RESET_GMAC0>;
-		clocks = <&syscon GEMINI_CLK_GATE_GMAC0>;
-		clock-names = "PCLK";
-		phy-mode = "rgmii";
-		phy-handle = <&phy0>;
-	};
-
-	gmac1: ethernet-port@1 {
-		compatible = "cortina,gemini-ethernet-port";
-		reg = <0x6000c000 0x2000>, /* Port 1 DMA/TOE */
-		      <0x6000e000 0x2000>; /* Port 1 GMAC */
-		interrupt-parent = <&intcon>;
-		interrupts = <2 IRQ_TYPE_LEVEL_HIGH>;
-		resets = <&syscon GEMINI_RESET_GMAC1>;
-		clocks = <&syscon GEMINI_CLK_GATE_GMAC1>;
-		clock-names = "PCLK";
-		phy-mode = "rgmii";
-		phy-handle = <&phy1>;
-	};
-};
diff --git a/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml b/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
new file mode 100644
index 000000000000..294977fd32f7
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
@@ -0,0 +1,138 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/cortina,gemini-ethernet.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Cortina Systems Gemini Ethernet Controller
+
+maintainers:
+  - Linus Walleij <linus.walleij@linaro.org>
+
+description: |
+  This ethernet controller is found in the Gemini SoC family:
+  StorLink SL3512 and SL3516, also known as Cortina Systems
+  CS3512 and CS3516.
+
+properties:
+  compatible:
+    const: cortina,gemini-ethernet
+
+  reg:
+    minItems: 3
+    description: must contain the global registers and the V-bit and A-bit
+      memory areas, in total three register sets.
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 1
+
+  ranges: true
+
+#The subnodes represents the two ethernet ports in this device.
+#They are not independent of each other since they share resources
+#in the parent node, and are thus children.
+patternProperties:
+  "^ethernet-port@[0-9]+$":
+    type: object
+    description: contains the resources for ethernet port
+    allOf:
+      - $ref: ethernet-controller.yaml#
+    properties:
+      compatible:
+        const: cortina,gemini-ethernet-port
+
+      reg:
+        minItems: 2
+        items:
+          - description: DMA/TOE memory
+          - description: GMAC memory area of the port
+
+      interrupts:
+        maxItems: 1
+        description: should contain the interrupt line of the port.
+                     this is nominally a level interrupt active high.
+
+      resets:
+        maxItems: 1
+        description: this must provide an SoC-integrated reset line for the port.
+
+      clocks:
+        maxItems: 1
+        description: this should contain a handle to the PCLK clock for
+                     clocking the silicon in this port
+
+      clock-names:
+        const: PCLK
+
+    required:
+      - reg
+      - compatible
+      - interrupts
+      - resets
+      - clocks
+      - clock-names
+
+required:
+  - compatible
+  - reg
+  - ranges
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/clock/cortina,gemini-clock.h>
+    #include <dt-bindings/reset/cortina,gemini-reset.h>
+    mdio0: mdio {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      phy0: ethernet-phy@1 {
+        reg = <1>;
+        device_type = "ethernet-phy";
+      };
+      phy1: ethernet-phy@3 {
+        reg = <3>;
+        device_type = "ethernet-phy";
+      };
+    };
+
+
+    ethernet@60000000 {
+        compatible = "cortina,gemini-ethernet";
+        reg = <0x60000000 0x4000>, /* Global registers, queue */
+              <0x60004000 0x2000>, /* V-bit */
+              <0x60006000 0x2000>; /* A-bit */
+        #address-cells = <1>;
+        #size-cells = <1>;
+        ranges;
+
+        gmac0: ethernet-port@0 {
+    		compatible = "cortina,gemini-ethernet-port";
+    		reg = <0x60008000 0x2000>, /* Port 0 DMA/TOE */
+    		      <0x6000a000 0x2000>; /* Port 0 GMAC */
+    		interrupt-parent = <&intcon>;
+    		interrupts = <1 IRQ_TYPE_LEVEL_HIGH>;
+    		resets = <&syscon GEMINI_RESET_GMAC0>;
+    		clocks = <&syscon GEMINI_CLK_GATE_GMAC0>;
+    		clock-names = "PCLK";
+    		phy-mode = "rgmii";
+    		phy-handle = <&phy0>;
+    	};
+
+    	gmac1: ethernet-port@1 {
+    		compatible = "cortina,gemini-ethernet-port";
+    		reg = <0x6000c000 0x2000>, /* Port 1 DMA/TOE */
+    		      <0x6000e000 0x2000>; /* Port 1 GMAC */
+    		interrupt-parent = <&intcon>;
+    		interrupts = <2 IRQ_TYPE_LEVEL_HIGH>;
+    		resets = <&syscon GEMINI_RESET_GMAC1>;
+    		clocks = <&syscon GEMINI_CLK_GATE_GMAC1>;
+    		clock-names = "PCLK";
+    		phy-mode = "rgmii";
+    		phy-handle = <&phy1>;
+    	};
+    };
-- 
2.34.1

