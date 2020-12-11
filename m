Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78EDA2D729B
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 10:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437290AbgLKJHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 04:07:46 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:4179 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437335AbgLKJHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 04:07:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607677633; x=1639213633;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DcLLcyitGH0v2VlQHPfKppsGNjLuBXI1WYl/OTeY9xE=;
  b=Yk9O78I1b3MO/N0VTmDukNWN8MS2PFVKweu2RxgeX0+pHvEBPm78O5fV
   xm11tn7xwA7ofrx5ppGQzLfWrqs8KuFouvqR5NSecbU0hG8IBuXynjy+a
   4O56udbO2QJBH87ZAEGbz5yVBBGlOJnWr5agdvdFJYyWF19GtuY4WfrIM
   gQagJ7IQir4Po4OotNaUTNAFFCH9u2pXWOmHF8YqPu7DP16aHRKB0gjaf
   rDPJAni5fgYYB+uJI8BQfdv20G0/Vtmi0AGSGO9D944wEReG99kAzRYXc
   QXDKcn6vU+0sibR0oJTeDQgUqXDqj+b4rsRVkJTwKUXQDjjxf8Oys84gn
   w==;
IronPort-SDR: NEVIeZEl1QGsC4X+Lz8jUrFLEWliEcOCLh1AeYE4PhvME6Bc1nnhR2V4XbCrj4uEPEqQWNl36d
 jMCgJFdtdN3LBEQ9Z/UcG9Ax7BFT5IX12VGTBFemS8WeMbzsWXyIo3VQiRZWWhNzDJNpOiawtZ
 zQPm94NTEFzo3FMCksE8VfMHp4tRN0nVt3vIWmOz/6cUg5chpR5rinHFlPMNYr7S/S/jjWu3U2
 1DM9XPME457xy8l5t7tJjRKB1mBWWtqfbH8EUp27NrjZdUDTZPapd2+E5pt/iTVXG64utnFn6E
 9Ss=
X-IronPort-AV: E=Sophos;i="5.78,410,1599548400"; 
   d="scan'208";a="37057311"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Dec 2020 02:05:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 11 Dec 2020 02:05:57 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 11 Dec 2020 02:05:54 -0700
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
        Rob Herring <robh@kernel.org>
Subject: [PATCH v10 1/4] dt-bindings: phy: Add sparx5-serdes bindings
Date:   Fri, 11 Dec 2020 10:05:38 +0100
Message-ID: <20201211090541.157926-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201211090541.157926-1-steen.hegelund@microchip.com>
References: <20201211090541.157926-1-steen.hegelund@microchip.com>
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

