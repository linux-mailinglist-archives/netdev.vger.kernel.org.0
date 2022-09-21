Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3558B5BF9C0
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 10:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiIUIsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 04:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiIUIsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 04:48:41 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54A2589CCF;
        Wed, 21 Sep 2022 01:48:40 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.93,332,1654527600"; 
   d="scan'208";a="135683814"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 21 Sep 2022 17:48:38 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id B13E941D8A18;
        Wed, 21 Sep 2022 17:48:38 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     kishon@ti.com, vkoul@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, geert+renesas@glider.be
Cc:     andrew@lunn.ch, linux-phy@lists.infradead.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH v2 2/8] dt-bindings: phy: renesas: Document Renesas Ethernet SERDES
Date:   Wed, 21 Sep 2022 17:47:39 +0900
Message-Id: <20220921084745.3355107-3-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document Renesas Etherent SERDES for R-Car S4-8 (r8a779f0).

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 .../bindings/phy/renesas,ether-serdes.yaml    | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/renesas,ether-serdes.yaml

diff --git a/Documentation/devicetree/bindings/phy/renesas,ether-serdes.yaml b/Documentation/devicetree/bindings/phy/renesas,ether-serdes.yaml
new file mode 100644
index 000000000000..04d650244a6a
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/renesas,ether-serdes.yaml
@@ -0,0 +1,54 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/renesas,ether-serdes.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Renesas Ethernet SERDES
+
+maintainers:
+  - Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
+
+properties:
+  compatible:
+    const: renesas,r8a779f0-ether-serdes
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+  power-domains:
+    maxItems: 1
+
+  '#phy-cells':
+    description: Port number of SERDES.
+    const: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - resets
+  - power-domains
+  - '#phy-cells'
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/r8a779f0-cpg-mssr.h>
+    #include <dt-bindings/power/r8a779f0-sysc.h>
+
+    ethernet@e6880000 {
+            compatible = "renesas,r8a779f0-ether-serdes";
+            reg = <0xe6444000 0xc00>;
+            clocks = <&cpg CPG_MOD 1506>;
+            power-domains = <&sysc R8A779F0_PD_ALWAYS_ON>;
+            resets = <&cpg 1506>;
+            #phy-cells = <1>;
+    };
-- 
2.25.1

