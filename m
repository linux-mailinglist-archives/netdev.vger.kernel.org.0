Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAB43D5A24
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 15:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbhGZMfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 08:35:11 -0400
Received: from smtp-34.italiaonline.it ([213.209.10.34]:48970 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233403AbhGZMfJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 08:35:09 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([79.45.45.231])
        by smtp-34.iol.local with ESMTPA
        id 80S8mb4Z4LCum80SHmrOfa; Mon, 26 Jul 2021 15:15:37 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1627305337; bh=TwXY0wWEIjCoEyIDcLLonShwStlhhTEg8+KADKL1xoc=;
        h=From;
        b=TnwuGt4s1+i+ma/PQVKUWcJZ9JZfxKIiiHrq10MCB+koP6pRiaZVrhQ4OtBDH01fz
         vR9M5uCbBbDFPOBI6eTnqh8g8xEBWQFpcPGVjezCTi51EykcK+djXkfP4GXdZdUFhM
         fKCJQcUnQs0T//f5NkQCPyt9G1Kju8hH5jWPNYrfNSAQ8InzZH9OH0RBagVaNlVa08
         qB+952H5zNugUCopo+edd7XsLtBjiKlREzkYzCNpgvW9fqEp1TC2ZBceuRCMJTnzHT
         R42pW1erdBRZRctmCbNPZHQ7mnyhn8c1iTA6Nd+iq3CwVfrwv2uAvlm6gCsBznt7dx
         2o1GF3XEn36bw==
X-CNFS-Analysis: v=2.4 cv=a8D1SWeF c=1 sm=1 tr=0 ts=60feb579 cx=a_exe
 a=TX8r+oJM0yLPAmPh5WrBoQ==:117 a=TX8r+oJM0yLPAmPh5WrBoQ==:17 a=gEfo2CItAAAA:8
 a=faqJUPsDrVUeZvGr8DYA:9 a=EZF1DJdq9kaO9wn_:21 a=AsuNPSxbIB0PVpCX:21
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
Subject: [PATCH v2 2/2] dt-bindings: net: can: c_can: convert to json-schema
Date:   Mon, 26 Jul 2021 15:15:26 +0200
Message-Id: <20210726131526.17542-2-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210726131526.17542-1-dariobin@libero.it>
References: <20210726131526.17542-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfCjld3f9P9Dc32M8sJ+iOTqcyhmDUr06dk2NrsDeDtqqBwIcy1gSNXoxMC3322PLdOG4OzQJqJAVcNW3bZC2Ea56tFCpyjiAaDq9DL9+ut8YbFOEuUAk
 8kMpd6cKBJVrRoTNX+PNsuJPm30z5Zg9OKnqci0tqHm+IeiD6eDxIVVimHfIAccDz88xHOtoGBwC+36Ks9+1sLbPJF86AF1VjR71//h1NlJ3fry70tXb+673
 /sw2xtsudsDgzjbyj/dUXQT4QSLLfIXxxwAl8IPU8Y8oHEi9Az0m/PH9MGd4f8ZOr2udg3LoZRCftboa5G0V3yEfdm4cDW9h3+HrxTRwDvnEaviRoWfdn5jI
 uiZUfpU+st5c1JZtfvqhvuYsZZasTRtXwK1jzlCH+30tdwu9JdCaV3nwNFzjNFtmL97G2BRYWFYYWe8u0NclL0uKbGLnQN0KJk2dUWnhDBsm0u0pzVKW8kPD
 f7rc5EPcDDBhQXRndZN0lYWboTAJted7W8DH0Bypj1RPS7SQnW4OazDe3hs=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Bosch C_CAN/D_CAN controller device tree binding
documentation to json-schema.

Document missing properties.
Remove "ti,hwmods" as it is no longer used in TI dts.
Make "clocks" required as it is used in all dts.
Correct nodename in the example.

Signed-off-by: Dario Binacchi <dariobin@libero.it>

---

Changes in v2:
 - Drop Documentation references

 .../bindings/net/can/bosch,c_can.yaml         | 83 +++++++++++++++++++
 .../devicetree/bindings/net/can/c_can.txt     | 65 ---------------
 2 files changed, 83 insertions(+), 65 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/c_can.txt

diff --git a/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
new file mode 100644
index 000000000000..f937c37e9199
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
@@ -0,0 +1,83 @@
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
+    maxItems: 1
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
+
+required:
+ - compatible
+ - reg
+ - interrupts
+ - clocks
+
+additionalProperties: false
+
+examples:
+  - |
+    can@481d0000 {
+        compatible = "bosch,d_can";
+        reg = <0x481d0000 0x2000>;
+        interrupts = <55>;
+        interrupt-parent = <&intc>;
+        status = "disabled";
+    };
+  - |
+    can@0 {
+        compatible = "ti,am3352-d_can";
+        reg = <0x0 0x2000>;
+        clocks = <&dcan1_fck>;
+        clock-names = "fck";
+        syscon-raminit = <&scm_conf 0x644 1>;
+        interrupts = <55>;
+        status = "disabled";
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

