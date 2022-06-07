Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E7753F6AA
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 08:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237295AbiFGG5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 02:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbiFGG5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 02:57:02 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2892DFF68;
        Mon,  6 Jun 2022 23:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1654585020; x=1686121020;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hlo1WukUYxzK83xoEPYlRos2jIXat8SOHdXU82yGAEc=;
  b=xZ/ORtwa9P/eU5Kl9P0RnF2tNmLGrp20/tu8TbUrDJthPFpMZHizhF4J
   5L9cIEtSv9H70RlTI8LMwQZkHIw127dKOJiK/S1KLDOqchENBlWLRIfZR
   fztjXwOa4+IWPkSzOcS4nCynWYrvUWxUsju2FdU7UBbIM7/EFyBX9qR2z
   rK+lovFsZzDOAOJVr0y3/r7kIWTJuPvCRnwppHy3aA/EXquqbA2itipCT
   qDq8RTH1Y7xBne0o4IV5hqczteQjx/qaKTDcHf8+NaB9C+cXKM+XbgJ4m
   w8qELpxRt6Sp3rIizNK4bF1WhqTZp5d9M5RNkq7ZLS9A3ubVqKzqUrPZF
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="162177021"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2022 23:56:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 6 Jun 2022 23:56:56 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 6 Jun 2022 23:56:53 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Palmer Dabbelt <palmer@dabbelt.com>
CC:     Conor Dooley <conor.dooley@microchip.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Daire McNamara <daire.mcnamara@microchip.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>
Subject: [PATCH net-next 1/2] dt-bindings: can: mpfs: document the mpfs can controller
Date:   Tue, 7 Jun 2022 07:54:59 +0100
Message-ID: <20220607065459.2035746-2-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607065459.2035746-1-conor.dooley@microchip.com>
References: <20220607065459.2035746-1-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a binding for the can controller on PolarFire SoC (MPFS).

Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
 .../bindings/net/can/microchip,mpfs-can.yaml  | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/microchip,mpfs-can.yaml

diff --git a/Documentation/devicetree/bindings/net/can/microchip,mpfs-can.yaml b/Documentation/devicetree/bindings/net/can/microchip,mpfs-can.yaml
new file mode 100644
index 000000000000..45aa3de7cf01
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/microchip,mpfs-can.yaml
@@ -0,0 +1,45 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/can/microchip,mpfs-can.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title:
+  Microchip PolarFire SoC (MPFS) can controller
+
+maintainers:
+  - Conor Dooley <conor.dooley@microchip.com>
+
+allOf:
+  - $ref: can-controller.yaml#
+
+properties:
+  compatible:
+    const: microchip,mpfs-can
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+
+additionalProperties: false
+
+examples:
+  - |
+    can@2010c000 {
+        compatible = "microchip,mpfs-can";
+        reg = <0x2010c000 0x1000>;
+        clocks = <&clkcfg 17>;
+        interrupt-parent = <&plic>;
+        interrupts = <56>;
+    };
-- 
2.36.1

