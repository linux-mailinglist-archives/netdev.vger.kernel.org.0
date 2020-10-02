Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0753E281D61
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 23:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgJBVIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 17:08:43 -0400
Received: from inva021.nxp.com ([92.121.34.21]:46924 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJBVIm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 17:08:42 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0F9D3200EE8;
        Fri,  2 Oct 2020 23:08:40 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 03851200178;
        Fri,  2 Oct 2020 23:08:40 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B23F2202AC;
        Fri,  2 Oct 2020 23:08:39 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     shawnguo@kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 01/10] dt-bindings: net: add the dpaa2-mac DTS definition
Date:   Sat,  3 Oct 2020 00:07:28 +0300
Message-Id: <20201002210737.27645-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201002210737.27645-1-ioana.ciornei@nxp.com>
References: <20201002210737.27645-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a documentation entry for the DTS bindings needed and supported by
the dpaa2-mac driver.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - new patch

 .../devicetree/bindings/net/dpaa2-mac.yaml    | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dpaa2-mac.yaml

diff --git a/Documentation/devicetree/bindings/net/dpaa2-mac.yaml b/Documentation/devicetree/bindings/net/dpaa2-mac.yaml
new file mode 100644
index 000000000000..744b0590278d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dpaa2-mac.yaml
@@ -0,0 +1,55 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dpaa2-mac.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: DPAA2 MAC bindings
+
+maintainers:
+  - Ioana Ciornei <ioana.ciornei@nxp.com>
+
+description:
+  This binding represents the DPAA2 MAC objects found on the fsl-mc bus and
+  located under the 'dpmacs' node for the fsl-mc bus DTS node.
+
+properties:
+  compatible:
+    const: "fsl,qoriq-mc-dpmac"
+
+  reg:
+    maxItems: 1
+    description: The DPMAC number
+
+  phy-handle: true
+
+  phy-connection-type: true
+
+  phy-mode: true
+
+  pcs-handle:
+    $ref: /schemas/types.yaml#definitions/phandle
+    description:
+      A reference to a node representing a PCS PHY device found on
+      the internal MDIO bus.
+
+  managed: true
+
+required:
+  - reg
+
+examples:
+  - |
+    dpmacs {
+      #address-cells = <1>;
+      #size-cells = <0>;
+
+      dpmac@4 {
+        compatible = "fsl,qoriq-mc-dpmac";
+        reg = <0x4>;
+        phy-handle = <&mdio1_phy6>;
+        phy-connection-type = "qsgmii";
+        managed = "in-band-status";
+        pcs-handle = <&pcs3_1>;
+      };
+    };
-- 
2.28.0

