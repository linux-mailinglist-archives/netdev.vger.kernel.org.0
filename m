Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807BF2B6FE2
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731811AbgKQUQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:16:25 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:47448 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731758AbgKQUQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:16:24 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AHKGHAm098393;
        Tue, 17 Nov 2020 14:16:17 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605644177;
        bh=hAP7xTIYE/3si6W5mQOK90txjunkGtM3wxWyq7hnqgQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=wBH1xp12wc2/aORPdrooKq0nLB+B7qI1wWWiRGdTpPzBnmyn+MT5ezJ8bum+cz0hW
         6IVkS/1ztp74E/Q6Qy2tjzHRn8qtVf+5/bmI5zcVhlath2F7gYXHlY/2OE9d5pKCkd
         ibJHWCNubvse3kc0tFtgT2LqEESe+UoUhw0Jlep8=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AHKGH6l016215
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 14:16:17 -0600
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 17
 Nov 2020 14:16:17 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 17 Nov 2020 14:16:17 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AHKGHXp096184;
        Tue, 17 Nov 2020 14:16:17 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <robh@kernel.org>, <ciorneiioana@gmail.com>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v4 3/4] dt-bindings: dp83td510: Add binding for DP83TD510 Ethernet PHY
Date:   Tue, 17 Nov 2020 14:15:54 -0600
Message-ID: <20201117201555.26723-4-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117201555.26723-1-dmurphy@ti.com>
References: <20201117201555.26723-1-dmurphy@ti.com>
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
 .../devicetree/bindings/net/ti,dp83td510.yaml | 64 +++++++++++++++++++
 1 file changed, 64 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ti,dp83td510.yaml

diff --git a/Documentation/devicetree/bindings/net/ti,dp83td510.yaml b/Documentation/devicetree/bindings/net/ti,dp83td510.yaml
new file mode 100644
index 000000000000..d3c97bb4d820
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ti,dp83td510.yaml
@@ -0,0 +1,64 @@
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
+unevaluatedProperties: false
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
2.29.2

