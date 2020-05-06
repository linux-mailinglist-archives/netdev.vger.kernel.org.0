Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A60A1C7917
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 20:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730183AbgEFSOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 14:14:32 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:53670 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728892AbgEFSOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 14:14:31 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046IEPJO111558;
        Wed, 6 May 2020 13:14:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588788865;
        bh=dufM3xHtstw3fL+VZJpkmiMWZxt+Xeyp7CijsYKqoBk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=lUGjgeF0TZ50dWSmPcsOT9gkpQF3Nqnk9IpFoinB+dHB8j5dyW8E9T3paSQ0yiHlm
         UfFZV8zSOuRUEAr2xvnePnA6DSWWSZKAoNXw1+0pDUU90FzSTcWnUMKVQBjAxNCVBA
         eSHhoOO0AX+RV5TxJXv8EbxY/oaHvcK7HnLcxfRU=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046IEO35075024
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 13:14:25 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 13:14:24 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 13:14:24 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046IENbM089699;
        Wed, 6 May 2020 13:14:24 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next 2/3] dt-binding: net: ti: am65x-cpts: make reg and compatible required
Date:   Wed, 6 May 2020 21:14:00 +0300
Message-ID: <20200506181401.28699-3-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506181401.28699-1-grygorii.strashko@ti.com>
References: <20200506181401.28699-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch follows K3 CPTS review comments from Rob Herring
<robh@kernel.org>.
 - "reg" and "compatible" properties are required now
 - minor format changes
 - K3 CPTS example added to K3 MCU CPSW bindings

Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 15 ++++++++++-
 .../bindings/net/ti,k3-am654-cpts.yaml        | 25 +++++++------------
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 0c054a2ce5ba..c87395f360a6 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -144,7 +144,7 @@ patternProperties:
     description:
       CPSW MDIO bus.
 
-  "^cpts$":
+  "^cpts@[0-9a-f]+":
     type: object
     allOf:
       - $ref: "ti,k3-am654-cpts.yaml#"
@@ -171,6 +171,8 @@ examples:
     #include <dt-bindings/pinctrl/k3.h>
     #include <dt-bindings/soc/ti,sci_pm_domain.h>
     #include <dt-bindings/net/ti-dp83867.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
 
     mcu_cpsw: ethernet@46000000 {
         compatible = "ti,am654-cpsw-nuss";
@@ -229,4 +231,15 @@ examples:
                     ti,fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
               };
         };
+
+        cpts@3d000 {
+             compatible = "ti,am65-cpts";
+             reg = <0x0 0x3d000 0x0 0x400>;
+             clocks = <&k3_clks 18 2>;
+             clock-names = "cpts";
+             interrupts-extended = <&gic500 GIC_SPI 858 IRQ_TYPE_LEVEL_HIGH>;
+             interrupt-names = "cpts";
+             ti,cpts-ext-ts-inputs = <4>;
+             ti,cpts-periodic-outputs = <2>;
+        };
     };
diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
index df83c320e61b..50e027911dd4 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
@@ -42,7 +42,7 @@ description: |+
 
 properties:
   $nodename:
-    pattern: "^cpts(@.*|-[0-9a-f])*$"
+    pattern: "^cpts@[0-9a-f]+$"
 
   compatible:
     oneOf:
@@ -52,7 +52,7 @@ properties:
   reg:
     maxItems: 1
     description:
-       The physical base address and size of CPTS IO range
+      The physical base address and size of CPTS IO range
 
   reg-names:
     items:
@@ -65,27 +65,27 @@ properties:
     items:
       - const: cpts
 
-  interrupts-extended:
+  interrupts:
     items:
       - description: CPTS events interrupt
 
   interrupt-names:
     items:
-      - const: "cpts"
+      - const: cpts
 
   ti,cpts-ext-ts-inputs:
     allOf:
       - $ref: /schemas/types.yaml#/definitions/uint32
     maximum: 8
     description:
-        Number of hardware timestamp push inputs (HWx_TS_PUSH)
+      Number of hardware timestamp push inputs (HWx_TS_PUSH)
 
   ti,cpts-periodic-outputs:
     allOf:
       - $ref: /schemas/types.yaml#/definitions/uint32
     maximum: 8
     description:
-         Number of timestamp Generator function outputs (TS_GENFx)
+      Number of timestamp Generator function outputs (TS_GENFx)
 
   refclk-mux:
     type: object
@@ -107,9 +107,11 @@ properties:
       - clocks
 
 required:
+  - compatible
+  - reg
   - clocks
   - clock-names
-  - interrupts-extended
+  - interrupts
   - interrupt-names
 
 additionalProperties: false
@@ -140,13 +142,4 @@ examples:
                assigned-clock-parents = <&k3_clks 118 11>;
          };
     };
-  - |
 
-    cpts {
-             clocks = <&k3_clks 18 2>;
-             clock-names = "cpts";
-             interrupts-extended = <&gic500 GIC_SPI 858 IRQ_TYPE_LEVEL_HIGH>;
-             interrupt-names = "cpts";
-             ti,cpts-ext-ts-inputs = <4>;
-             ti,cpts-periodic-outputs = <2>;
-    };
-- 
2.17.1

