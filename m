Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3413E1CAF
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhHET2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:28:24 -0400
Received: from smtp-32.italiaonline.it ([213.209.10.32]:43224 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230445AbhHET2W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 15:28:22 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([82.60.87.158])
        by smtp-32.iol.local with ESMTPA
        id Bj29mFVCOPvRTBj2DmCFmv; Thu, 05 Aug 2021 21:28:06 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1628191686; bh=ovU+K9dCeH924H7d43lXZI742Ly2v3I9DHb1WZh8TOc=;
        h=From;
        b=LPS8IsRgxYc0qFeub/igX7l9u+HcwMfTxUsncvrl1gMxAZzLU+STcKMNVqKa0KO6y
         vrKg6aZg69qtpll+Sj1tPsVFKT88J9jeO83fD4cVwIlL/VKtfAuB6juehqsrXRcE92
         hvk2WjA6D5JyIgDHcRCjDJSSkXg0g/pxWGgzZrSMX/DfaTaWiDcweqo2yz4cnkeK6x
         YbGy0o+FKo0twzaJiTLcmc/FMT2QDf51Sfpjm0crIIheTPZta9eGTG0RsArCRaA56d
         z1eBQKl8MQnKtgkQWJBNM4+Nfxq0RVIvHCievynX9CchSvOVfhkGjEQG9J4/BHdRGM
         O7D1aEVmn5h0Q==
X-CNFS-Analysis: v=2.4 cv=NqgUz+RJ c=1 sm=1 tr=0 ts=610c3bc6 cx=a_exe
 a=Hc/BMeSBGyun2kpB8NmEvQ==:117 a=Hc/BMeSBGyun2kpB8NmEvQ==:17 a=gEfo2CItAAAA:8
 a=p_hF36_8n4bHhE57Z5sA:9 a=4Mw1SIdcLJOoZDVX:21 a=uq95oRJrG9BvWHuX:21
 a=sptkURWiP4Gy88Gu7hUp:22
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v5] dt-bindings: net: can: c_can: convert to json-schema
Date:   Thu,  5 Aug 2021 21:27:50 +0200
Message-Id: <20210805192750.9051-1-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
X-CMAE-Envelope: MS4xfMJZUreXtdoXwnW6voTjepbJyx7hsY02Q2/poIPhNXunXtjH4cv2vvQcJPankzge42XRVAXFWGsptOhVzlOtwhp65QQWUzy03WAM4SmIQ4NSjpG794bx
 068eaY6/CyKqdtY536dlwnSWz030tGjopKRKK6kW9popmrfvVD8hXJdxh8PaDabrDR7ydrsU4VDRi6kXyO53L2xYfVOSjMxfbxGA1BlWsFSfVmT49cbcgKAW
 zgbvGNcISZGyWRp0oqMCKWYBgpPgJFM9gRzVsi9YEMVXZXylLHrq9UMxTeR84TXRJoyUce7+SOzj71xZPvivPO/rm3wyBRRN3+3GTLNueikfjzzaGXtF0qd6
 fRX0YxFK/S6DH1pXvQni77P6mo/QArmLkntoL6JtxF1YF3GD8bvBPQCR+MVaqsJXXJxqKaHrDk83wVmMvrnTWkOTf3ZbhrhHDgCCbRt4d0UkCjcKWdaSa/Wx
 W/nzxEFArW8ZS+faLqrBow+KDjpIEqRVN0v5YKspOeNln24iPWWJpsl7rN4=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Bosch C_CAN/D_CAN controller device tree binding
documentation to json-schema.

Document missing properties.
Remove "ti,hwmods" as it is no longer used in TI dts.
Make "clocks" required as it is used in all dts.
Update the examples.

Signed-off-by: Dario Binacchi <dariobin@libero.it>

---

Changes in v5:
 - Complete 'interrupts' property description

Changes in v4:
 - Fix 'syscon-raminit' property to pass checks.
 - Drop 'status' property from CAN node of examples.
 - Replace CAN node of examples (compatible = "bosch,d_can")  with a
   recent version taken from socfpga.dtsi dts.
 - Update the 'interrupts' property due to the examples updating.
 - Add 'resets' property due to the examples updating.

Changes in v3:
 - Add type (phandle-array) and size (maxItems: 2) to syscon-raminit
   property.

Changes in v2:
 - Drop Documentation references.

 .../bindings/net/can/bosch,c_can.yaml         | 119 ++++++++++++++++++
 .../devicetree/bindings/net/can/c_can.txt     |  65 ----------
 2 files changed, 119 insertions(+), 65 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/c_can.txt

diff --git a/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
new file mode 100644
index 000000000000..2cd145a642f1
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
@@ -0,0 +1,119 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/can/bosch,c_can.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Bosch C_CAN/D_CAN controller Device Tree Bindings
+
+description: Bosch C_CAN/D_CAN controller for CAN bus
+
+maintainers:
+  - Dario Binacchi <dariobin@libero.it>
+
+allOf:
+  - $ref: can-controller.yaml#
+
+properties:
+  compatible:
+    oneOf:
+      - enum:
+          - bosch,c_can
+          - bosch,d_can
+          - ti,dra7-d_can
+          - ti,am3352-d_can
+      - items:
+          - enum:
+              - ti,am4372-d_can
+          - const: ti,am3352-d_can
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    minItems: 1
+    maxItems: 4
+
+  power-domains:
+    description: |
+      Should contain a phandle to a PM domain provider node and an args
+      specifier containing the DCAN device id value. It's mandatory for
+      Keystone 2 66AK2G SoCs only.
+    maxItems: 1
+
+  clocks:
+    description: |
+      CAN functional clock phandle.
+    maxItems: 1
+
+  clock-names:
+    maxItems: 1
+
+  syscon-raminit:
+    description: |
+      Handle to system control region that contains the RAMINIT register,
+      register offset to the RAMINIT register and the CAN instance number (0
+      offset).
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      items:
+        - description: The phandle to the system control region.
+        - description: The register offset.
+        - description: The CAN instance number.
+
+  resets:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+
+if:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - bosch,d_can
+
+then:
+  properties:
+    interrupts:
+      minItems: 4
+      maxItems: 4
+      items:
+        - description: Error and status IRQ
+        - description: Message object IRQ
+        - description: RAM ECC correctable error IRQ
+        - description: RAM ECC non-correctable error IRQ
+
+else:
+  properties:
+    interrupts:
+      maxItems: 1
+      items:
+        - description: Error and status IRQ
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/reset/altr,rst-mgr.h>
+
+    can@ffc00000 {
+       compatible = "bosch,d_can";
+       reg = <0xffc00000 0x1000>;
+       interrupts = <0 131 4>, <0 132 4>, <0 133 4>, <0 134 4>;
+       clocks = <&can0_clk>;
+       resets = <&rst CAN0_RESET>;
+    };
+  - |
+    can@0 {
+        compatible = "ti,am3352-d_can";
+        reg = <0x0 0x2000>;
+        clocks = <&dcan1_fck>;
+        clock-names = "fck";
+        syscon-raminit = <&scm_conf 0x644 1>;
+        interrupts = <55>;
+    };
diff --git a/Documentation/devicetree/bindings/net/can/c_can.txt b/Documentation/devicetree/bindings/net/can/c_can.txt
deleted file mode 100644
index 366479806acb..000000000000
--- a/Documentation/devicetree/bindings/net/can/c_can.txt
+++ /dev/null
@@ -1,65 +0,0 @@
-Bosch C_CAN/D_CAN controller Device Tree Bindings
--------------------------------------------------
-
-Required properties:
-- compatible		: Should be "bosch,c_can" for C_CAN controllers and
-			  "bosch,d_can" for D_CAN controllers.
-			  Can be "ti,dra7-d_can", "ti,am3352-d_can" or
-			  "ti,am4372-d_can".
-- reg			: physical base address and size of the C_CAN/D_CAN
-			  registers map
-- interrupts		: property with a value describing the interrupt
-			  number
-
-The following are mandatory properties for DRA7x, AM33xx and AM43xx SoCs only:
-- ti,hwmods		: Must be "d_can<n>" or "c_can<n>", n being the
-			  instance number
-
-The following are mandatory properties for Keystone 2 66AK2G SoCs only:
-- power-domains		: Should contain a phandle to a PM domain provider node
-			  and an args specifier containing the DCAN device id
-			  value. This property is as per the binding,
-			  Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
-- clocks		: CAN functional clock phandle. This property is as per the
-			  binding,
-			  Documentation/devicetree/bindings/clock/ti,sci-clk.yaml
-
-Optional properties:
-- syscon-raminit	: Handle to system control region that contains the
-			  RAMINIT register, register offset to the RAMINIT
-			  register and the CAN instance number (0 offset).
-
-Note: "ti,hwmods" field is used to fetch the base address and irq
-resources from TI, omap hwmod data base during device registration.
-Future plan is to migrate hwmod data base contents into device tree
-blob so that, all the required data will be used from device tree dts
-file.
-
-Example:
-
-Step1: SoC common .dtsi file
-
-	dcan1: d_can@481d0000 {
-		compatible = "bosch,d_can";
-		reg = <0x481d0000 0x2000>;
-		interrupts = <55>;
-		interrupt-parent = <&intc>;
-		status = "disabled";
-	};
-
-(or)
-
-	dcan1: d_can@481d0000 {
-		compatible = "bosch,d_can";
-		ti,hwmods = "d_can1";
-		reg = <0x481d0000 0x2000>;
-		interrupts = <55>;
-		interrupt-parent = <&intc>;
-		status = "disabled";
-	};
-
-Step 2: board specific .dts file
-
-	&dcan1 {
-		status = "okay";
-	};
-- 
2.17.1

