Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539F51D387D
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 19:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgENRkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 13:40:42 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:36028 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgENRkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 13:40:42 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04EHeZHE039911;
        Thu, 14 May 2020 12:40:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589478035;
        bh=y4zOa5MLsEzlYAmWxSm1ws8HfmXJ3acfchfMHbkNxsQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=bLYN2SFR/wqKSiLSWC2evH2SM68aiqoqUM2qrTeIUmvhvfqhz5Twp3yt/0JlAoAoM
         3A2JY3i8ET+1rGJ2pc8KqdIc5IWbHTvJ9uUAm8sdYlnYvItXwlMNgFPdKT3iDs5UBI
         5Srt3Eg+VCb+n9J3XD6UiXoz+DKKXvwwijlVIVLk=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04EHeZC4092929;
        Thu, 14 May 2020 12:40:35 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 14
 May 2020 12:40:35 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 14 May 2020 12:40:35 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04EHeZAE034700;
        Thu, 14 May 2020 12:40:35 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>, Rob Herring <robh+dt@kernel.org>
Subject: [PATCH net-next 1/2] dt-bindings: net: dp83822: Add TI dp83822 phy
Date:   Thu, 14 May 2020 12:30:54 -0500
Message-ID: <20200514173055.15013-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514173055.15013-1-dmurphy@ti.com>
References: <20200514173055.15013-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a dt binding for the TI dp83822 ethernet phy device.

CC: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 .../devicetree/bindings/net/ti,dp83822.yaml   | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ti,dp83822.yaml

diff --git a/Documentation/devicetree/bindings/net/ti,dp83822.yaml b/Documentation/devicetree/bindings/net/ti,dp83822.yaml
new file mode 100644
index 000000000000..60afd43ad3b6
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ti,dp83822.yaml
@@ -0,0 +1,49 @@
+# SPDX-License-Identifier: (GPL-2.0+ OR BSD-2-Clause)
+# Copyright (C) 2020 Texas Instruments Incorporated
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/ti,dp83822.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: TI DP83822 ethernet PHY
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+
+maintainers:
+  - Dan Murphy <dmurphy@ti.com>
+
+description: |
+  The DP83822 is a low-power, single-port, 10/100 Mbps Ethernet PHY. It
+  provides all of the physical layer functions needed to transmit and receive
+  data over standard, twisted-pair cables or to connect to an external,
+  fiber-optic transceiver. Additionally, the DP83822 provides flexibility to
+  connect to a MAC through a standard MII, RMII, or RGMII interface
+
+  Specifications about the charger can be found at:
+    http://www.ti.com/lit/ds/symlink/dp83822i.pdf
+
+properties:
+  reg:
+    maxItems: 1
+
+  ti,signal-polarity-low:
+    type: boolean
+    description: |
+       DP83822 PHY in Fiber mode only.
+       Sets the DP83822 to detect a link drop condition when the signal goes
+       high.  If not set then link drop will occur when the signal goes low.
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
+        ti,signal-polarity-low;
+      };
+    };
-- 
2.26.2

