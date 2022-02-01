Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E9C4A5E8E
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 15:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239449AbiBAOtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 09:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239445AbiBAOts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 09:49:48 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA5AC06173D
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 06:49:48 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id u15so32561770wrt.3
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 06:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dXIFXBL1STx981dzFcr2zeZBlB5xjBaW3oXYG7W4lV4=;
        b=Usdj4k+OPKhLvVQuCQFiJO3TvaUqsW+6Eo1neLhONt4XnvyAGX6L5JKYdxm8xSBso0
         WO2Pb1p12eDQeaBysRQkRAuKisRgjr/HE8WV5NKfe/JFvzn+vGGRa7/3Xqv94bQnhECm
         zbWucnNvnWf5yXFv5BtXyoW86PluW0T9MGJDVWaJokdwU6YbOI/mFuUQNWRqkNQkhZVB
         /5W38H0rddEIN+KH4OHV+psgMrTOSI4BldAm+McIY69nWutChNQWajytiDSCYrDgB9Ig
         xx3WNuWcpwhTPE2gGJlOibrOVSCa1EfDNL6L3iqBaj76kFOv4Nqqx4DTxdcOaw2Zx7CB
         eDNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dXIFXBL1STx981dzFcr2zeZBlB5xjBaW3oXYG7W4lV4=;
        b=eCDtriq3WEmwDiv6fK3NTVKbposh2/szLFqGkziaLA6t7pBDVm5rOjWk1QltHdxkc1
         FHWIbw3tYPF+Llorwob1Zsb8BwDp2aGYa5xMQ1B+3ToxLS5tz2VB89H0XWXaFYqC4VoG
         dlqW47/EIeLRSeF+i3+V2IjiGuLusDQO4f90hlaX09V7XNz+RgkAHl48OFcNOfOUTDR/
         WtHpx/hBD5ypek1QGDZQ1LZ1N1DAz8pbHjVL2DjRv3K41eW2LYEPKFeghRVc+xbdwD07
         ssLzoHPGEPhOi/xK0HhFwuv5927AWao/LxOr5C+UXxGs0ecbPiabrU/EXRCo8NJIXJZh
         oDQw==
X-Gm-Message-State: AOAM532qNFjuTJGsFb7BSTDFFpjbn7SraJ131lulUiRvr8qLHuSukPNf
        Cr9prkApuE8sUNG/6urzuHcHqQ==
X-Google-Smtp-Source: ABdhPJzJA4+8MBti1hlQlF+emS68y5CThBzCx4VKX9dTZW/yLZYTNhzt/hAHEiUELzTH45lQ4rzSAA==
X-Received: by 2002:a5d:410a:: with SMTP id l10mr21479286wrp.390.1643726987102;
        Tue, 01 Feb 2022 06:49:47 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id l5sm2527023wmq.7.2022.02.01.06.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 06:49:46 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        robh+dt@kernel.org, ulli.kroll@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2] dt-bindings: net: convert net/cortina,gemini-ethernet to yaml
Date:   Tue,  1 Feb 2022 14:49:40 +0000
Message-Id: <20220201144940.2488782-1-clabbe@baylibre.com>
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
Change since v1:
- fixed report done by Rob's bot
 .../bindings/net/cortina,gemini-ethernet.txt  |  92 ------------
 .../bindings/net/cortina,gemini-ethernet.yaml | 137 ++++++++++++++++++
 2 files changed, 137 insertions(+), 92 deletions(-)
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
index 000000000000..cc01b9b5752a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
@@ -0,0 +1,137 @@
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
+                compatible = "cortina,gemini-ethernet-port";
+                reg = <0x60008000 0x2000>, /* Port 0 DMA/TOE */
+                      <0x6000a000 0x2000>; /* Port 0 GMAC */
+                interrupt-parent = <&intcon>;
+                interrupts = <1 IRQ_TYPE_LEVEL_HIGH>;
+                resets = <&syscon GEMINI_RESET_GMAC0>;
+                clocks = <&syscon GEMINI_CLK_GATE_GMAC0>;
+                clock-names = "PCLK";
+                phy-mode = "rgmii";
+                phy-handle = <&phy0>;
+        };
+
+        gmac1: ethernet-port@1 {
+                compatible = "cortina,gemini-ethernet-port";
+                reg = <0x6000c000 0x2000>, /* Port 1 DMA/TOE */
+                      <0x6000e000 0x2000>; /* Port 1 GMAC */
+                interrupt-parent = <&intcon>;
+                interrupts = <2 IRQ_TYPE_LEVEL_HIGH>;
+                resets = <&syscon GEMINI_RESET_GMAC1>;
+                clocks = <&syscon GEMINI_CLK_GATE_GMAC1>;
+                clock-names = "PCLK";
+                phy-mode = "rgmii";
+                phy-handle = <&phy1>;
+        };
+    };
-- 
2.34.1

