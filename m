Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7FB6F44A4
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 11:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731852AbfKHKgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 05:36:02 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:1725 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731522AbfKHKgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 05:36:01 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8ARFkn030043;
        Fri, 8 Nov 2019 11:35:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=a6bYe1UWeEcww5/uqteaBQHLnBulzOOBvtzUWN1mnMs=;
 b=uYA2H2JVAv3sGK7zx4jWfIFZ/eqrUb/Apizg7GodmmMKXlly62Adster4bc4Zt1d34Fz
 5J1AXPaHEjy5AKSMNBpLu3MhGvvFO11A0Y1VUTE+XM4QVxnA0Ll5T5im5tIuT4EB6rsk
 XXJ6N7NIuZJdhMgDyOk74HO/160py/q17Rg9/vc/DdSloPFJkwq0aHjJAKOPcEQ56/bo
 6pbi3X/o18A80esvCimNwoVUb611L6iL/coV3efK4gTYwa7yDMEsNGt9gRzuDz0UeS+c
 Fcl9DwUQ/wv9mc+DRIxA+lvLwgXaqaROURte/NiK2OmYb4waxGo5HPtZldQZ7BHmbtRR mg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2w41vmu28m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 11:35:37 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 394FC100038;
        Fri,  8 Nov 2019 11:35:33 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas23.st.com [10.75.90.46])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 2714E2B0FED;
        Fri,  8 Nov 2019 11:35:33 +0100 (CET)
Received: from SAFEX1HUBCAS21.st.com (10.75.90.45) by SAFEX1HUBCAS23.st.com
 (10.75.90.46) with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 8 Nov 2019
 11:35:33 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 8 Nov 2019 11:35:32
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <mripard@kernel.org>,
        <martin.blumenstingl@googlemail.com>,
        <alexandru.ardelean@analog.com>, <narmstrong@baylibre.com>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@st.com>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH  2/2] dt-bindings: net: dwmac: Convert stm32 dwmac to DT schema
Date:   Fri, 8 Nov 2019 11:35:26 +0100
Message-ID: <20191108103526.22254-3-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108103526.22254-1-christophe.roullier@st.com>
References: <20191108103526.22254-1-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_02:2019-11-07,2019-11-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert stm32 dwmac to DT schema.

Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
---
 .../devicetree/bindings/net/stm32-dwmac.txt   |  44 -----
 .../devicetree/bindings/net/stm32-dwmac.yaml  | 161 ++++++++++++++++++
 2 files changed, 161 insertions(+), 44 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/stm32-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/stm32-dwmac.yaml

diff --git a/Documentation/devicetree/bindings/net/stm32-dwmac.txt b/Documentation/devicetree/bindings/net/stm32-dwmac.txt
deleted file mode 100644
index a90eef11dc46..000000000000
--- a/Documentation/devicetree/bindings/net/stm32-dwmac.txt
+++ /dev/null
@@ -1,44 +0,0 @@
-STMicroelectronics STM32 / MCU DWMAC glue layer controller
-
-This file documents platform glue layer for stmmac.
-Please see stmmac.txt for the other unchanged properties.
-
-The device node has following properties.
-
-Required properties:
-- compatible:  For MCU family should be "st,stm32-dwmac" to select glue, and
-	       "snps,dwmac-3.50a" to select IP version.
-	       For MPU family should be "st,stm32mp1-dwmac" to select
-	       glue, and "snps,dwmac-4.20a" to select IP version.
-- clocks: Must contain a phandle for each entry in clock-names.
-- clock-names: Should be "stmmaceth" for the host clock.
-	       Should be "mac-clk-tx" for the MAC TX clock.
-	       Should be "mac-clk-rx" for the MAC RX clock.
-	       For MPU family need to add also "ethstp" for power mode clock
-- interrupt-names: Should contain a list of interrupt names corresponding to
-           the interrupts in the interrupts property, if available.
-		   Should be "macirq" for the main MAC IRQ
-		   Should be "eth_wake_irq" for the IT which wake up system
-- st,syscon : Should be phandle/offset pair. The phandle to the syscon node which
-	       encompases the glue register, and the offset of the control register.
-
-Optional properties:
-- clock-names:     For MPU family "eth-ck" for PHY without quartz
-- st,eth-clk-sel (boolean) : set this property in RGMII PHY when you want to select RCC clock instead of ETH_CLK125.
-- st,eth-ref-clk-sel (boolean) :  set this property in RMII mode when you have PHY without crystal 50MHz and want to select RCC clock instead of ETH_REF_CLK.
-
-Example:
-
-	ethernet@40028000 {
-		compatible = "st,stm32-dwmac", "snps,dwmac-3.50a";
-		reg = <0x40028000 0x8000>;
-		reg-names = "stmmaceth";
-		interrupts = <0 61 0>, <0 62 0>;
-		interrupt-names = "macirq", "eth_wake_irq";
-		clock-names = "stmmaceth", "mac-clk-tx", "mac-clk-rx";
-		clocks = <&rcc 0 25>, <&rcc 0 26>, <&rcc 0 27>;
-		st,syscon = <&syscfg 0x4>;
-		snps,pbl = <8>;
-		snps,mixed-burst;
-		dma-ranges;
-	};
diff --git a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
new file mode 100644
index 000000000000..eb0fd831f59d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
@@ -0,0 +1,161 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+# Copyright 2019 BayLibre, SAS
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/stm32-dwmac.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: STMicroelectronics STM32 / MCU DWMAC glue layer controller
+
+maintainers:
+  - Alexandre Torgue <alexandre.torgue@st.com>
+  - Christophe Roullier <christophe.roullier@st.com>
+
+description:
+  This file documents platform glue layer for stmmac.
+
+# We need a select here so we don't match all nodes with 'snps,dwmac'
+select:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - st,stm32-dwmac
+          - st,stm32mp1-dwmac
+  required:
+    - compatible
+
+allOf:
+  - $ref: "snps,dwmac.yaml#"
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - st,stm32-dwmac
+              - st,stm32mp1-dwmac
+    then:
+      properties:
+       clocks:
+         minItems: 3 
+         maxItems: 5
+         items:
+          - description: GMAC main clock
+          - description: MAC TX clock
+          - description: MAC RX clock
+          - description: For MPU family, used for power mode
+          - description: For MPU family, used for PHY without quartz
+
+       clock-names:
+         minItems: 3          
+         maxItems: 5
+         contains:
+          enum:
+            - stmmaceth
+            - mac-clk-tx
+            - mac-clk-rx
+            - ethstp
+            - eth-ck     
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - enum:
+              - st,stm32mp1-dwmac
+          - const: snps,dwmac-4.20a
+      - items:
+          - enum:
+              - st,stm32-dwmac
+          - const: snps,dwmac-4.10a
+      - items:
+          - enum:
+              - st,stm32-dwmac
+          - const: snps,dwmac-3.50a            
+
+  st,syscon:
+    allOf:
+      - $ref: "/schemas/types.yaml#/definitions/phandle-array"
+    description:
+      Should be phandle/offset pair. The phandle to the syscon node which
+      encompases the glue register, and the offset of the control register
+
+  st,eth-clk-sel:
+    description:
+      set this property in RGMII PHY when you want to select RCC clock instead of ETH_CLK125.
+    type: boolean
+    
+  st,eth-ref-clk-sel:
+    description:
+      set this property in RMII mode when you have PHY without crystal 50MHz and want to select RCC clock instead of ETH_REF_CLK.
+    type: boolean   
+
+required:
+  - compatible
+  - clocks
+  - clock-names
+  - st,syscon
+
+examples:
+ - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/stm32mp1-clks.h>
+    #include <dt-bindings/reset/stm32mp1-resets.h>
+    #include <dt-bindings/mfd/stm32h7-rcc.h>  
+    //Example 1
+     ethernet0: ethernet@5800a000 {
+       compatible = "st,stm32mp1-dwmac", "snps,dwmac-4.20a";
+       reg = <0x5800a000 0x2000>;
+       reg-names = "stmmaceth";
+       interrupts = <&intc GIC_SPI 61 IRQ_TYPE_LEVEL_HIGH>;
+       interrupt-names = "macirq";
+       clock-names = "stmmaceth",
+                     "mac-clk-tx",
+                     "mac-clk-rx",
+                     "ethstp",
+                     "eth-ck";				      
+       clocks = <&rcc ETHMAC>,
+                <&rcc ETHTX>,
+                <&rcc ETHRX>,
+                <&rcc ETHSTP>,
+                <&rcc ETHCK_K>;	
+       st,syscon = <&syscfg 0x4>;
+       snps,pbl = <2>;
+       snps,axi-config = <&stmmac_axi_config_0>;
+       snps,tso;
+       status = "disabled";
+       phy-mode = "rgmii";       
+       };
+
+    //Example 1 (MCU example)
+     ethernet1: ethernet@40028000 {
+       compatible = "st,stm32-dwmac", "snps,dwmac-3.50a";
+       reg = <0x40028000 0x8000>;
+       reg-names = "stmmaceth";
+       interrupts = <0 61 0>, <0 62 0>;
+       interrupt-names = "macirq", "eth_wake_irq";
+       clock-names = "stmmaceth", "mac-clk-tx", "mac-clk-rx";
+       clocks = <&rcc 0 25>, <&rcc 0 26>, <&rcc 0 27>;
+       st,syscon = <&syscfg 0x4>;
+       snps,pbl = <8>;
+       snps,mixed-burst;
+       dma-ranges;
+       phy-mode = "mii";       
+       };
+
+    //Example 2 
+     ethernet2: ethernet@40027000 {
+       compatible = "st,stm32-dwmac", "snps,dwmac-4.10a";
+       reg = <0x40028000 0x8000>;
+       reg-names = "stmmaceth";
+       interrupts = <61>;
+       interrupt-names = "macirq";
+       clock-names = "stmmaceth", "mac-clk-tx", "mac-clk-rx";
+       clocks = <&rcc 62>, <&rcc 61>, <&rcc 60>;
+       st,syscon = <&syscfg 0x4>;
+       snps,pbl = <8>;
+       status = "disabled";
+       phy-mode = "mii";        
+       };
+
+       
-- 
2.17.1

