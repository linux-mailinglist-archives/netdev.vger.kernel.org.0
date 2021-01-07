Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC272ECC98
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbhAGJUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:20:52 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:55668 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbhAGJUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:20:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610011251; x=1641547251;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gp0CFQRZ5FxZ0LK9GyNyeJ3bFuor8ddJpyhyjnRbeTY=;
  b=0NOUSwgw9Nfqalpveo9mwYAAQsC5A80y98syvC4Kgg5ihjY2+Uok+sLS
   LrzFAZo/oL07IGbbvSlsLiSLfqQhzxFjIxwrJ6HvNTzrqxHatpicqQR5o
   ZM44AcrobvBHUqZ//aybnawUQYqEu8G4AgXlIxQIdw4JMBoCwTFXZYn17
   KkAGTgpeU6t2pB70Onf2E/VC/SLepd+IOI5LbhsRMlizmZOaKL+FC16Oq
   uz1mK9B6SxDVXBMt/eRmPW/hk0WeRs6B1YA6B/V4FxqEk6fhiJqQtYN+i
   b96QLvMAiWtlO8TChhYYparHEqlvnUHNW/nO2JybLVYVmugv8mevafrqE
   A==;
IronPort-SDR: 7JX5pJ5anfoSpwEmOB0NPZT1LfeL8mChBcw9kDB7EUV3GZ5JzH2QkkvnE9BzIHXX7l0si97xju
 GNWBOA8YYPw4TyDpTg3v6/Zag2r1uKvpGNiuOUqughO9VgemUUkZ4lx2h8OGRMRHfO5Z9C+IPg
 1MRPnVlY0ljDN55mzNR28WVAtXKk6l0ja1GR0kSg24XOKePxzqrK2wUMLVPhO/CFyRXU/C1QXU
 wcWF3ffIovQvNtMmNsH1MO+EpFbAZFnCFqvGZ4Nxjo6e9DWgSQbC/S+bxOk/fcz50LR9PcHVDC
 oYc=
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="104566787"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jan 2021 02:19:35 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 7 Jan 2021 02:19:33 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 7 Jan 2021 02:19:31 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v12 1/4] dt-bindings: phy: Add sparx5-serdes bindings
Date:   Thu, 7 Jan 2021 10:19:21 +0100
Message-ID: <20210107091924.1569575-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107091924.1569575-1-steen.hegelund@microchip.com>
References: <20210107091924.1569575-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the Sparx5 ethernet serdes phy driver bindings.

Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 .../bindings/phy/microchip,sparx5-serdes.yaml | 100 ++++++++++++++++++
 1 file changed, 100 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/microchip,sparx5-serdes.yaml

diff --git a/Documentation/devicetree/bindings/phy/microchip,sparx5-serdes.yaml b/Documentation/devicetree/bindings/phy/microchip,sparx5-serdes.yaml
new file mode 100644
index 000000000000..bdbdb3bbddbe
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/microchip,sparx5-serdes.yaml
@@ -0,0 +1,100 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/microchip,sparx5-serdes.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Microchip Sparx5 Serdes controller
+
+maintainers:
+  - Steen Hegelund <steen.hegelund@microchip.com>
+
+description: |
+  The Sparx5 SERDES interfaces share the same basic functionality, but
+  support different operating modes and line rates.
+
+  The following list lists the SERDES features:
+
+  * RX Adaptive Decision Feedback Equalizer (DFE)
+  * Programmable continuous time linear equalizer (CTLE)
+  * Rx variable gain control
+  * Rx built-in fault detector (loss-of-lock/loss-of-signal)
+  * Adjustable tx de-emphasis (FFE)
+  * Tx output amplitude control
+  * Supports rx eye monitor
+  * Multiple loopback modes
+  * Prbs generator and checker
+  * Polarity inversion control
+
+  SERDES6G:
+
+  The SERDES6G is a high-speed SERDES interface, which can operate at
+  the following data rates:
+
+  * 100 Mbps (100BASE-FX)
+  * 1.25 Gbps (SGMII/1000BASE-X/1000BASE-KX)
+  * 3.125 Gbps (2.5GBASE-X/2.5GBASE-KX)
+  * 5.15625 Gbps (5GBASE-KR/5G-USXGMII)
+
+  SERDES10G
+
+  The SERDES10G is a high-speed SERDES interface, which can operate at
+  the following data rates:
+
+  * 100 Mbps (100BASE-FX)
+  * 1.25 Gbps (SGMII/1000BASE-X/1000BASE-KX)
+  * 3.125 Gbps (2.5GBASE-X/2.5GBASE-KX)
+  * 5 Gbps (QSGMII/USGMII)
+  * 5.15625 Gbps (5GBASE-KR/5G-USXGMII)
+  * 10 Gbps (10G-USGMII)
+  * 10.3125 Gbps (10GBASE-R/10GBASE-KR/USXGMII)
+
+  SERDES25G
+
+  The SERDES25G is a high-speed SERDES interface, which can operate at
+  the following data rates:
+
+  * 1.25 Gbps (SGMII/1000BASE-X/1000BASE-KX)
+  * 3.125 Gbps (2.5GBASE-X/2.5GBASE-KX)
+  * 5 Gbps (QSGMII/USGMII)
+  * 5.15625 Gbps (5GBASE-KR/5G-USXGMII)
+  * 10 Gbps (10G-USGMII)
+  * 10.3125 Gbps (10GBASE-R/10GBASE-KR/USXGMII)
+  * 25.78125 Gbps (25GBASE-KR/25GBASE-CR/25GBASE-SR/25GBASE-LR/25GBASE-ER)
+
+properties:
+  $nodename:
+    pattern: "^serdes@[0-9a-f]+$"
+
+  compatible:
+    const: microchip,sparx5-serdes
+
+  reg:
+    minItems: 1
+
+  '#phy-cells':
+    const: 1
+    description: |
+      - The main serdes input port
+
+  clocks:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - '#phy-cells'
+  - clocks
+
+additionalProperties: false
+
+examples:
+  - |
+    serdes: serdes@10808000 {
+      compatible = "microchip,sparx5-serdes";
+      #phy-cells = <1>;
+      clocks = <&sys_clk>;
+      reg = <0x10808000 0x5d0000>;
+    };
+
+...
-- 
2.29.2

