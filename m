Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE0A2DBD8D
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 10:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgLPJbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 04:31:22 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:38257 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725835AbgLPJbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 04:31:22 -0500
X-UUID: 461a26c33c184d9a99b2bb02568526a5-20201216
X-UUID: 461a26c33c184d9a99b2bb02568526a5-20201216
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1052347228; Wed, 16 Dec 2020 17:30:37 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs06n1.mediatek.inc (172.21.101.129) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 16 Dec 2020 17:30:36 +0800
Received: from mtkslt301.mediatek.inc (10.21.14.114) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 16 Dec 2020 17:30:35 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Rob Herring <robh+dt@kernel.org>
CC:     Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Min Guo <min.guo@mediatek.com>,
        <dri-devel@lists.freedesktop.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>
Subject: [PATCH v4 07/11] dt-bindings: phy: convert MIPI DSI PHY binding to YAML schema
Date:   Wed, 16 Dec 2020 17:30:08 +0800
Message-ID: <20201216093012.24406-7-chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201216093012.24406-1-chunfeng.yun@mediatek.com>
References: <20201216093012.24406-1-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert MIPI DSI PHY binding to YAML schema mediatek,dsi-phy.yaml

Cc: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
---
v4:
  1. add maintainer Philipp add support mt8183 suggested by Chun-Kuang
  2. use keyword multipleOf suggested by Rob
  3. fix typo of 'MIPI' in title

v3: new patch
---
 .../display/mediatek/mediatek,dsi.txt         | 18 +---
 .../bindings/phy/mediatek,dsi-phy.yaml        | 85 +++++++++++++++++++
 2 files changed, 86 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/mediatek,dsi-phy.yaml

diff --git a/Documentation/devicetree/bindings/display/mediatek/mediatek,dsi.txt b/Documentation/devicetree/bindings/display/mediatek/mediatek,dsi.txt
index f06f24d405a5..8238a86686be 100644
--- a/Documentation/devicetree/bindings/display/mediatek/mediatek,dsi.txt
+++ b/Documentation/devicetree/bindings/display/mediatek/mediatek,dsi.txt
@@ -22,23 +22,7 @@ Required properties:
 MIPI TX Configuration Module
 ============================
 
-The MIPI TX configuration module controls the MIPI D-PHY.
-
-Required properties:
-- compatible: "mediatek,<chip>-mipi-tx"
-- the supported chips are mt2701, 7623, mt8173 and mt8183.
-- reg: Physical base address and length of the controller's registers
-- clocks: PLL reference clock
-- clock-output-names: name of the output clock line to the DSI encoder
-- #clock-cells: must be <0>;
-- #phy-cells: must be <0>.
-
-Optional properties:
-- drive-strength-microamp: adjust driving current, should be 3000 ~ 6000. And
-						   the step is 200.
-- nvmem-cells: A phandle to the calibration data provided by a nvmem device. If
-               unspecified default values shall be used.
-- nvmem-cell-names: Should be "calibration-data"
+See phy/mediatek,dsi-phy.yaml
 
 Example:
 
diff --git a/Documentation/devicetree/bindings/phy/mediatek,dsi-phy.yaml b/Documentation/devicetree/bindings/phy/mediatek,dsi-phy.yaml
new file mode 100644
index 000000000000..71d4acea1f66
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/mediatek,dsi-phy.yaml
@@ -0,0 +1,85 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+# Copyright (c) 2020 MediaTek
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/mediatek,dsi-phy.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek MIPI Display Serial Interface (DSI) PHY binding
+
+maintainers:
+  - Chun-Kuang Hu <chunkuang.hu@kernel.org>
+  - Philipp Zabel <p.zabel@pengutronix.de>
+  - Chunfeng Yun <chunfeng.yun@mediatek.com>
+
+description: The MIPI DSI PHY supports up to 4-lane output.
+
+properties:
+  $nodename:
+    pattern: "^dsi-phy@[0-9a-f]+$"
+
+  compatible:
+    enum:
+      - mediatek,mt2701-mipi-tx
+      - mediatek,mt7623-mipi-tx
+      - mediatek,mt8173-mipi-tx
+      - mediatek,mt8183-mipi-tx
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: PLL reference clock
+
+  clock-output-names:
+    maxItems: 1
+
+  "#phy-cells":
+    const: 0
+
+  "#clock-cells":
+    const: 0
+
+  nvmem-cells:
+    maxItems: 1
+    description: A phandle to the calibration data provided by a nvmem device,
+      if unspecified, default values shall be used.
+
+  nvmem-cell-names:
+    items:
+      - const: calibration-data
+
+  drive-strength-microamp:
+    description: adjust driving current
+    multipleOf: 200
+    minimum: 2000
+    maximum: 6000
+    default: 4600
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-output-names
+  - "#phy-cells"
+  - "#clock-cells"
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/mt8173-clk.h>
+    dsi-phy@10215000 {
+        compatible = "mediatek,mt8173-mipi-tx";
+        reg = <0x10215000 0x1000>;
+        clocks = <&clk26m>;
+        clock-output-names = "mipi_tx0_pll";
+        drive-strength-microamp = <4000>;
+        nvmem-cells= <&mipi_tx_calibration>;
+        nvmem-cell-names = "calibration-data";
+        #clock-cells = <0>;
+        #phy-cells = <0>;
+    };
+
+...
-- 
2.18.0

