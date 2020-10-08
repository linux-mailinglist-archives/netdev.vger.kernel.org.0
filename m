Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312D72879EA
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730875AbgJHQYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:24:02 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:53680 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgJHQX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 12:23:57 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 098GNrhs016497;
        Thu, 8 Oct 2020 11:23:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1602174233;
        bh=JmQUBZqhgOiPTKRAfFaSbG6VjBtwTm0Yzc53wlyD54U=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=SN0vev9ggO8jFENPPfO+RBzO+hzdZrMD3FrFeUVYzFI2ntsgruxQpOBXgcjDgPjW7
         T3ZZ4s0aPbnaiwFF2xTomHuU1v6gubhBW5RJ8yccN/bBJN2AdsaolNSyoKDxr4huO6
         p+qxPeuC9IV/ZqqEae8q10f1VFq6VWWYEUTMKTVM=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 098GNrcV063389
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 8 Oct 2020 11:23:53 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 8 Oct
 2020 11:23:52 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 8 Oct 2020 11:23:52 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 098GNp5Z070117;
        Thu, 8 Oct 2020 11:23:52 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next 1/2] dt-bindings: dp83td510: Add binding for DP83TD510 Ethernet PHY
Date:   Thu, 8 Oct 2020 11:23:46 -0500
Message-ID: <20201008162347.5290-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201008162347.5290-1-dmurphy@ti.com>
References: <20201008162347.5290-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DP83TD510 is a 10M single twisted pair Ethernet PHY

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 .../devicetree/bindings/net/ti,dp83td510.yaml | 70 +++++++++++++++++++
 1 file changed, 70 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ti,dp83td510.yaml

diff --git a/Documentation/devicetree/bindings/net/ti,dp83td510.yaml b/Documentation/devicetree/bindings/net/ti,dp83td510.yaml
new file mode 100644
index 000000000000..0f0eac77a11a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ti,dp83td510.yaml
@@ -0,0 +1,70 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+# Copyright (C) 2020 Texas Instruments Incorporated
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/ti,dp83td510.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: TI DP83TD510 ethernet PHY
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+
+maintainers:
+  - Dan Murphy <dmurphy@ti.com>
+
+description: |
+  The PHY is an twisted pair 10Mbps Ethernet PHY that support MII, RMII and
+  RGMII interfaces.
+
+  Specifications about the Ethernet PHY can be found at:
+    http://www.ti.com/lit/ds/symlink/dp83td510e.pdf
+
+properties:
+  reg:
+    maxItems: 1
+
+  tx-fifo-depth:
+    description: |
+       Transmitt FIFO depth for RMII mode.  The PHY only exposes 4 nibble
+       depths. The valid nibble depths are 4, 5, 6 and 8.
+    default: 5
+
+  rx-internal-delay-ps:
+    description: |
+       Setting this property to a non-zero number sets the RX internal delay
+       for the PHY.  The internal delay for the PHY is fixed to 30ns relative
+       to receive data.
+
+  tx-internal-delay-ps:
+    description: |
+       Setting this property to a non-zero number sets the TX internal delay
+       for the PHY.  The internal delay for the PHY has a range of -4 to 4ns
+       relative to transmit data.
+
+  ti,master-slave-mode:
+    $ref: /schemas/types.yaml#definitions/uint32
+    default: 0
+    description: |
+      Force the PHY to be configured to a specific mode.
+      Force Auto Negotiation - 0
+      Force Master mode at 1v p2p - 1
+      Force Master mode at 2.4v p2p - 2
+      Force Slave mode at 1v p2p - 3
+      Force Slave mode at 2.4v p2p - 4
+
+required:
+  - reg
+
+examples:
+  - |
+    mdio0 {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      ethphy0: ethernet-phy@0 {
+        reg = <0>;
+        tx-fifo-depth = <5>;
+        rx-internal-delay-ps = <1>;
+        tx-internal-delay-ps = <1>;
+      };
+    };
-- 
2.28.0.585.ge1cfff676549

