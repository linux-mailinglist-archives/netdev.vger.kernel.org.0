Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6C53DBD8E
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhG3RRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:17:02 -0400
Received: from smtp-36.italiaonline.it ([213.209.10.36]:58178 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229953AbhG3RRB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 13:17:01 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([79.45.223.112])
        by smtp-36.iol.local with ESMTPA
        id 9W7tmvxuai9pC9W7xmkmuu; Fri, 30 Jul 2021 19:16:55 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1627665415; bh=byHMCPhGZ+GTEHiz8XqPFAP8SrcBPUm0jTW9VfwGYOY=;
        h=From;
        b=Ben7FH+9T6DVWKZOGqC/MWsm5wIS4XKn54DitfWke9aeyEojXFhEOlqu6M20AM1KD
         JbaQpdOfxOOtpfYwpdVj6iAuGXyjI/sOsP5TLWWvxRX21XXXNeqTPesIQIs5Mf5g6C
         dBfoUipL16tuJVLA4s4f41C22AG9Hgzx0ccmDmmEITY58HZ7aDS1AygE8P6QXJgh+u
         R19WwlxWx6OqGbv3Dom87u8fiBRjPKvs+QioXHKh2GGhyR2X+84WwVa0bVLpJ1bo8/
         T86nSLUksveG3sBao4pJxCMBCcdCHRzqR+jlE6QDD9cn97q8MDVqHqnNt5tEwqGkq3
         Uz/G1pyd1V5Bg==
X-CNFS-Analysis: v=2.4 cv=RqYAkAqK c=1 sm=1 tr=0 ts=61043407 cx=a_exe
 a=bNRYHniHET+FA3QFAnazSw==:117 a=bNRYHniHET+FA3QFAnazSw==:17 a=gEfo2CItAAAA:8
 a=faqJUPsDrVUeZvGr8DYA:9 a=Sf5sUmNcCa837iNl:21 a=jsU-foglF0TQYXlV:21
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
Subject: [PATCH v3] dt-bindings: net: can: c_can: convert to json-schema
Date:   Fri, 30 Jul 2021 19:16:46 +0200
Message-Id: <20210730171646.2406-1-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
X-CMAE-Envelope: MS4xfNEl38DIm46sYo5x2RN/cpQMMGVk1GQcqlOmoXyZIRQM6+rUaKxqIilWxWW/3wXJxChimr3dTLjccutauXzSnJAjrrRuLYRd3JVRHgy1Fk4JF5iIS1EJ
 h/lqDBxiHdDd2u5G5X643k8ag0Z/i9+CGmL+uoSfsPXKk5Nc8JoOiFVRfPDH1OYTmK+g9C1S+vBlgeWSnHznmYukabZUXwr0JuSrxaP+zbK5L5LBCdf9qXp1
 Ysp6yUTRuXjXlT3Yk9Mgp5Ypl+olmWHnxUJhPyfmf5AZEuGln+LIL0t0zuxBaxrM+M6WlIhh1nwzUQqdZ23BfxMe3bLtMifsPRgMqy9piR8kOAzX6od1+MO1
 VrODlPpaYpYxUX1GOhb51aMVtAVXsNPjKh7h/nfwjB87YsAu0w9m8w+hmebudyyoYhY2HXr8lO3xVv76wY0vV6xGy9JdNgd00czyZrrKRK4S2J/EtUienJik
 4dlaMUzLTYXvMo3OYYobGFG21BAfVDGr6UtkiGdg1DdneSu31vv+8VD+yxo=
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

Changes in v3:
 - Add type (phandle-array) and size (maxItems: 2) to syscon-raminit
   property.

Changes in v2:
 - Drop Documentation references.

 .../bindings/net/can/bosch,c_can.yaml         | 85 +++++++++++++++++++
 .../devicetree/bindings/net/can/c_can.txt     | 65 --------------
 2 files changed, 85 insertions(+), 65 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/c_can.txt

diff --git a/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
new file mode 100644
index 000000000000..416db97fbf9d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
@@ -0,0 +1,85 @@
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
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    maxItems: 2
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

