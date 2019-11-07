Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8613F35E6
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389621AbfKGRlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:41:16 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:35600 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730868AbfKGRlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 12:41:15 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xA7Hf3ZZ013174;
        Thu, 7 Nov 2019 11:41:03 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1573148463;
        bh=gkvS19CgRrGsYzGHjew64Q0kY91+V839loIwRfgDRFw=;
        h=From:To:CC:Subject:Date;
        b=yt3FBYRzHEMu3zGa4FxWgxUNosLyAtqv3HxABc9UJiISLGkptxcStgr+rlw8YB4TA
         EAFqoMeKVSFAx/B8Osy7YG0iM0uuby8cN1GrbGs4fpedqUHhdASfUadXzoGcfCJjAW
         x9nkF+mxTiyYqUS6vNtfHmH9eyYMJlAAZKQzWJpA=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xA7Hf368079645
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 7 Nov 2019 11:41:03 -0600
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 7 Nov
 2019 11:40:47 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 7 Nov 2019 11:40:47 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA7Hf2xN014786;
        Thu, 7 Nov 2019 11:41:02 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>, Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v2 1/2] dt-bindings: net: dp83869: Add TI dp83869 phy
Date:   Thu, 7 Nov 2019 11:40:01 -0600
Message-ID: <20191107174002.11227-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.22.0.214.g8dca754b1e
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dt bindings for the TI dp83869 Gigabit ethernet phy
device.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
CC: Rob Herring <robh+dt@kernel.org>
---

v2 - No changes 

 .../devicetree/bindings/net/ti,dp83869.yaml   | 84 +++++++++++++++++++
 1 file changed, 84 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ti,dp83869.yaml

diff --git a/Documentation/devicetree/bindings/net/ti,dp83869.yaml b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
new file mode 100644
index 000000000000..6fe3e451da8a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
@@ -0,0 +1,84 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 Texas Instruments Incorporated
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/ti,dp83869.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: TI DP83869 ethernet PHY
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+
+maintainers:
+  - Dan Murphy <dmurphy@ti.com>
+
+description: |
+  The DP83869HM device is a robust, fully-featured Gigabit (PHY) transceiver
+  with integrated PMD sublayers that supports 10BASE-Te, 100BASE-TX and
+  1000BASE-T Ethernet protocols. The DP83869 also supports 1000BASE-X and
+  100BASE-FX Fiber protocols.
+  This device interfaces to the MAC layer through Reduced GMII (RGMII) and
+  SGMII The DP83869HM supports Media Conversion in Managed mode. In this mode,
+  the DP83869HM can run 1000BASE-X-to-1000BASE-T and 100BASE-FX-to-100BASE-TX
+  conversions.  The DP83869HM can also support Bridge Conversion from RGMII to
+  SGMII and SGMII to RGMII.
+
+  Specifications about the charger can be found at:
+    http://www.ti.com/lit/ds/symlink/dp83869hm.pdf
+
+properties:
+  reg:
+    maxItems: 1
+
+  ti,min-output-impedance:
+    type: boolean
+    description: |
+       MAC Interface Impedance control to set the programmable output impedance
+       to a minimum value (35 ohms).
+
+  ti,max-output-impedance:
+    type: boolean
+    description: |
+       MAC Interface Impedance control to set the programmable output impedance
+       to a maximum value (70 ohms).
+
+  tx-fifo-depth:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+       Transmitt FIFO depth see dt-bindings/net/ti-dp83869.h for values
+
+  rx-fifo-depth:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+       Receive FIFO depth see dt-bindings/net/ti-dp83869.h for values
+
+  ti,clk-output-sel:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+       Muxing option for CLK_OUT pin see dt-bindings/net/ti-dp83869.h for values.
+
+  ti,op-mode:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+       Operational mode for the PHY.  If this is not set then the operational
+       mode is set by the straps. see dt-bindings/net/ti-dp83869.h for values
+
+required:
+  - reg
+
+examples:
+  - |
+    #include <dt-bindings/net/ti-dp83869.h>
+    mdio0 {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      ethphy0: ethernet-phy@0 {
+        reg = <0>;
+        tx-fifo-depth = <DP83869_PHYCR_FIFO_DEPTH_4_B_NIB>;
+        rx-fifo-depth = <DP83869_PHYCR_FIFO_DEPTH_4_B_NIB>;
+        ti,op-mode = <DP83869_RGMII_COPPER_ETHERNET>;
+        ti,max-output-impedance = "true";
+        ti,clk-output-sel = <DP83869_CLK_O_SEL_CHN_A_RCLK>;
+      };
+    };
-- 
2.22.0.214.g8dca754b1e

