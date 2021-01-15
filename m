Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BF22F8580
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 20:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388537AbhAOTat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 14:30:49 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:36822 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727839AbhAOTas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 14:30:48 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 10FJT9dd008455;
        Fri, 15 Jan 2021 13:29:09 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1610738949;
        bh=DTcsPI5R3ZBLY6K8EfeF7t+7yYHjb/L62A3vXpYnKmI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=FSwBWz8ZCVPHD1tsW4upSADLojUsro8KE+0WZBw4f7I0qDxaIy6VCD3n+Qbm4E4/C
         g+tOwdftjuV2d7mgOaA8FHVBXjvQ1LH5w+U1PWN01/goOaNBrO5RKu8wMLe+pOkC8T
         gXITxPTqpsEb+AFmtMbpwWo7tOo7Fv8XohxYWseE=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 10FJT9rI026123
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 Jan 2021 13:29:09 -0600
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 15
 Jan 2021 13:29:09 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 15 Jan 2021 13:29:09 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 10FJT7DK007540;
        Fri, 15 Jan 2021 13:29:08 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [net-next 2/6] dt-binding: net: ti: k3-am654-cpsw-nuss: update bindings for am64x cpsw3g
Date:   Fri, 15 Jan 2021 21:28:49 +0200
Message-ID: <20210115192853.5469-3-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210115192853.5469-1-grygorii.strashko@ti.com>
References: <20210115192853.5469-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update DT binding for recently introduced TI K3 AM642x SoC [1] which
contains 3 port (2 external ports) CPSW3g module. The CPSW3g integrated
in MAIN domain and can be configured in multi port or switch modes.

The overall functionality and DT bindings are similar to other K3 CPSWxg
versions, so DT binding changes are minimal:
 - reword description
 - add new compatible 'ti,am642-cpsw-nuss'
 - allow 2 external ports child nodes
 - add missed 'assigned-clock' props

[1] https://www.ti.com/lit/pdf/spruim2
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 50 +++++++++++--------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index c47b58f3e3f6..3fae9a5f0c6a 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/ti,k3-am654-cpsw-nuss.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: The TI AM654x/J721E SoC Gigabit Ethernet MAC (Media Access Controller) Device Tree Bindings
+title: The TI AM654x/J721E/AM642x SoC Gigabit Ethernet MAC (Media Access Controller) Device Tree Bindings
 
 maintainers:
   - Grygorii Strashko <grygorii.strashko@ti.com>
@@ -13,19 +13,16 @@ maintainers:
 description:
   The TI AM654x/J721E SoC Gigabit Ethernet MAC (CPSW2G NUSS) has two ports
   (one external) and provides Ethernet packet communication for the device.
-  CPSW2G NUSS features - the Reduced Gigabit Media Independent Interface (RGMII),
-  Reduced Media Independent Interface (RMII), the Management Data
-  Input/Output (MDIO) interface for physical layer device (PHY) management,
-  new version of Common Platform Time Sync (CPTS), updated Address Lookup
-  Engine (ALE).
-  One external Ethernet port (port 1) with selectable RGMII/RMII interfaces and
-  an internal Communications Port Programming Interface (CPPI5) (Host port 0).
+  The TI AM642x SoC Gigabit Ethernet MAC (CPSW3G NUSS) has three ports
+  (two external) and provides Ethernet packet communication and switching.
+
+  The internal Communications Port Programming Interface (CPPI5) (Host port 0).
   Host Port 0 CPPI Packet Streaming Interface interface supports 8 TX channels
-  and one RX channels and operating by TI AM654x/J721E NAVSS Unified DMA
-  Peripheral Root Complex (UDMA-P) controller.
-  The CPSW2G NUSS is integrated into device MCU domain named MCU_CPSW0.
+  and one RX channels and operating by NAVSS Unified DMA  Peripheral Root
+  Complex (UDMA-P) controller.
 
-  Additional features
+  CPSWxG features
+  updated Address Lookup Engine (ALE).
   priority level Quality Of Service (QOS) support (802.1p)
   Support for Audio/Video Bridging (P802.1Qav/D6.0)
   Support for IEEE 1588 Clock Synchronization (2008 Annex D, Annex E and Annex F)
@@ -38,10 +35,18 @@ description:
   VLAN support, 802.1Q compliant, Auto add port VLAN for untagged frames on
   ingress, Auto VLAN removal on egress and auto pad to minimum frame size.
   RX/TX csum offload
+  Management Data Input/Output (MDIO) interface for PHYs management
+  RMII/RGMII Interfaces support
+  new version of Common Platform Time Sync (CPTS)
+
+  The CPSWxG NUSS is integrated into
+    device MCU domain named MCU_CPSW0 on AM654x/J721E SoC.
+    device MAIN domain named CPSW0 on AM642x SoC.
 
   Specifications can be found at
-    http://www.ti.com/lit/ug/spruid7e/spruid7e.pdf
-    http://www.ti.com/lit/ug/spruil1a/spruil1a.pdf
+    https://www.ti.com/lit/pdf/spruid7
+    https://www.ti.com/lit/zip/spruil1
+    https://www.ti.com/lit/pdf/spruim2
 
 properties:
   "#address-cells": true
@@ -51,11 +56,12 @@ properties:
     oneOf:
       - const: ti,am654-cpsw-nuss
       - const: ti,j721e-cpsw-nuss
+      - const: ti,am642-cpsw-nuss
 
   reg:
     maxItems: 1
     description:
-      The physical base address and size of full the CPSW2G NUSS IO range
+      The physical base address and size of full the CPSWxG NUSS IO range
 
   reg-names:
     items:
@@ -66,12 +72,16 @@ properties:
   dma-coherent: true
 
   clocks:
-    description: CPSW2G NUSS functional clock
+    description: CPSWxG NUSS functional clock
 
   clock-names:
     items:
       - const: fck
 
+  assigned-clock-parents: true
+
+  assigned-clocks: true
+
   power-domains:
     maxItems: 1
 
@@ -99,16 +109,16 @@ properties:
         const: 0
 
     patternProperties:
-      port@1:
+      port@[1-2]:
         type: object
-        description: CPSW2G NUSS external ports
+        description: CPSWxG NUSS external ports
 
         $ref: ethernet-controller.yaml#
 
         properties:
           reg:
-            items:
-              - const: 1
+            minimum: 1
+            maximum: 2
             description: CPSW port number
 
           phys:
-- 
2.17.1

