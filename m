Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3842E91AF
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 09:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbhADIYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 03:24:09 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:54806 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbhADIYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 03:24:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1609748647; x=1641284647;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gp0CFQRZ5FxZ0LK9GyNyeJ3bFuor8ddJpyhyjnRbeTY=;
  b=2pygeAdMtymm6eaC7JHtNVYGQ2sCM/3xsoDb06iy/9GCioPY2lCXMQ+p
   KkC224fJQ/bZyGnlbAKhC72UX40mlSdnwJFgNNRZ8Y3+u8jBZa3rzGj/G
   OA/2VpF7tvVgR65E4sFMazfnakdKaBUhImaSL0KHmqS1idtfHmlaOLGmf
   6KJGeSQhszHwdRBQ5gb5B84i06gDkaWrkCFcUC9f64fDSFF1FYpHKj04f
   srNRWUNNNKrZR/B0Yuk72D2dHcKIBtzuSx/q+tt/I8xeup4K3DHLMpshh
   CHr9GYe0mbE2To4uQ/krBqhl59E87PgF9gI8KTINV+fwlBnYI9WF4aBfJ
   g==;
IronPort-SDR: vleUMH3zOkVsCA9wn0qFSYoJBXD0ojT+wKmjWVwPt0VF/V+18fcNW8f0YD0r7MqIVhdO2I+5Rf
 krYECU5+U80BkNtOf5KpBtVKnJGoMz5twxTQUS0M35aWU9ASVWzGD0e5HhvRH/c4eTHzcBmjlP
 3tsL3ws2n4TZ7o7++BSI0UhzpEax2aZpCCpNjuEG5REYf/PdRs4LvtyYrfCjyenEj41wYeruDq
 gkFHDdFyTuJQ9lktcupiKb76ESBKaMxnOZqMqSdx5RiqYrhn2mWm4Wi0N5a5Fu0xDqf+hkT9oP
 Vf4=
X-IronPort-AV: E=Sophos;i="5.78,473,1599548400"; 
   d="scan'208";a="109665952"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2021 01:23:18 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 4 Jan 2021 01:22:30 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 4 Jan 2021 01:22:27 -0700
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
Subject: [PATCH v11 1/4] dt-bindings: phy: Add sparx5-serdes bindings
Date:   Mon, 4 Jan 2021 09:22:15 +0100
Message-ID: <20210104082218.1389450-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104082218.1389450-1-steen.hegelund@microchip.com>
References: <20210104082218.1389450-1-steen.hegelund@microchip.com>
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

