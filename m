Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12B92A0C89
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 18:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgJ3RaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 13:30:24 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34438 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgJ3RaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 13:30:01 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09UHTrwN049416;
        Fri, 30 Oct 2020 12:29:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604078993;
        bh=Y+hQzHpTXWAoHqNtg/IPOC1Zo98CWSGBIf8N03rnqR0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=rF4J8rMNhoEja/nvY8sMGp/rLOZeheki0z+wRtNn3d/LEoICRqcvIvRoNnv49iLqb
         r3c4hChuu3bWPHjVgNXlPw5tHFFFLhox13YMRJoTcEtfBzeA9xYgdaksvkQ61D4IVi
         3KTmd2mZlJ1+ir+n3NZYLMcv8evli8PvHOKVZlZk=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09UHTrxt083452
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 12:29:53 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 30
 Oct 2020 12:29:52 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 30 Oct 2020 12:29:52 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09UHTqSH046321;
        Fri, 30 Oct 2020 12:29:52 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <robh@kernel.org>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v3 3/4] dt-bindings: dp83td510: Add binding for DP83TD510 Ethernet PHY
Date:   Fri, 30 Oct 2020 12:29:49 -0500
Message-ID: <20201030172950.12767-4-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201030172950.12767-1-dmurphy@ti.com>
References: <20201030172950.12767-1-dmurphy@ti.com>
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
 .../devicetree/bindings/net/ti,dp83td510.yaml | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ti,dp83td510.yaml

diff --git a/Documentation/devicetree/bindings/net/ti,dp83td510.yaml b/Documentation/devicetree/bindings/net/ti,dp83td510.yaml
new file mode 100644
index 000000000000..aef949c1cfdd
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ti,dp83td510.yaml
@@ -0,0 +1,62 @@
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
+  - $ref: "ethernet-phy.yaml#"
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
+    enum: [ 4, 5, 6, 8 ]
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
+        tx-rx-output-high;
+        tx-fifo-depth = <5>;
+        rx-internal-delay-ps = <1>;
+        tx-internal-delay-ps = <1>;
+      };
+    };
-- 
2.28.0.585.ge1cfff676549

