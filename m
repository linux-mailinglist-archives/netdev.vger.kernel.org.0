Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32473D4E8F
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 18:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbhGYPXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 11:23:10 -0400
Received: from smtp-34.italiaonline.it ([213.209.10.34]:39452 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229545AbhGYPXG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 11:23:06 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([79.45.45.231])
        by smtp-34.iol.local with ESMTPA
        id 7gb5mU7LcLCum7gbGmo0x9; Sun, 25 Jul 2021 18:03:35 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1627229015; bh=SckQhOc4wdu1vP3T2POPf4LicMBU62ZmXI1yqKNc/e0=;
        h=From;
        b=Cx36R0S0GP99ygXewyLXgMXbMhoFQdV9LhDgkGPn95xdlWffwK60IcN0fOXo+hCj4
         68LivQF+vR+YwZHLuAIKeaM+6jki/JcXviUzqLpfJL+7iQWTLd14aVhUHd/YSuWmm8
         j8Mj+uKdYcpQdCj1b9wAqStp9qLhMXU2uyctPsysDVUvH1jh6qp/bvQDhTdL558s82
         0pHc79gKbWftXxosISMEsTBIit5OAoCX/B3qY56r+ReXmbrSsQZSOi4PY9b6WlOdau
         QQSSwHWAJK8pSyFoCcOT0tibbO02LKUWTSi++bahn2szUg8lqLMCz0+wT+OQYZwlRY
         cUTr+psZLd2XA==
X-CNFS-Analysis: v=2.4 cv=a8D1SWeF c=1 sm=1 tr=0 ts=60fd8b57 cx=a_exe
 a=TX8r+oJM0yLPAmPh5WrBoQ==:117 a=TX8r+oJM0yLPAmPh5WrBoQ==:17 a=gEfo2CItAAAA:8
 a=faqJUPsDrVUeZvGr8DYA:9 a=ZIXt85xL_p7RR4ZI:21 a=DbC9JZPw0L3yLR2B:21
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
Subject: [PATCH 2/2] dt-bindings: net: can: c_can: convert to json-schema
Date:   Sun, 25 Jul 2021 18:03:18 +0200
Message-Id: <20210725160318.9312-2-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210725160318.9312-1-dariobin@libero.it>
References: <20210725160318.9312-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfBGANg4XaGvrsUFx1KFT2ELpdtEy6ikJwfyZLstFQqDuJkeM0R5N1slKlWHLHKI3NG1+3aO0GnHxLggY6w7vo7yXY77WLYgP5B4XJzKstyeOr0UF6aFF
 SRo7jYdkll7RmktSHjd+QwNOFm7a1WRMmYU3owsZyw6X4RWCJAcZAOEWrwlelxffJX2HNw5ieIMRD+7jRlX3aXUkvYi/2G/hLiVOItAXG2lXhUhq5BA3alIa
 Hy1QE/RSgu5c+tqRTXzooV6DEYdW7zQZFuoeDCjOXexPqxGQ0EioijDhQWVAnmSR91Bg811/hikYJ35eCUpKMLvdLNo3KMmmLpso8z04Yx9jev6KEevdIoeP
 1r2dSMU/1B5jBcYsnk+JdWjjAG0oZBOBfKNpTE2neItyJl4ZhiXoLWIfZPkQQeJlecmSPsnbYZ9H7b0p7Pbgmxe9/9xMxj6ce3lDEvEpzDi9TgR8mlWj+d5s
 haTAIPPwOBNUMsDbZBqNT1bY8bDeq+cBuYZ/X7eKqoOB0WNPBsqoYQQQkWA=
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

 .../bindings/net/can/bosch,c_can.yaml         | 85 +++++++++++++++++++
 .../devicetree/bindings/net/can/c_can.txt     | 65 --------------
 2 files changed, 85 insertions(+), 65 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/c_can.txt

diff --git a/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
new file mode 100644
index 000000000000..f3a0a53eb5af
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
+      See, Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt.
+    maxItems: 1
+
+  clocks:
+    description: |
+      CAN functional clock phandle.
+      See, Documentation/devicetree/bindings/clock/ti,sci-clk.txt.
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

