Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DAD5A68A4
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 18:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiH3Qpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 12:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiH3Qpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 12:45:34 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DFF552E9C1;
        Tue, 30 Aug 2022 09:45:32 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.93,275,1654527600"; 
   d="scan'208";a="133114590"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 31 Aug 2022 01:45:32 +0900
Received: from localhost.localdomain (unknown [10.226.92.122])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 2E97D4035E90;
        Wed, 31 Aug 2022 01:45:25 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 1/3] dt-bindings: can: nxp,sja1000: Document RZ/N1 power-domains support
Date:   Tue, 30 Aug 2022 17:45:16 +0100
Message-Id: <20220830164518.1381632-2-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220830164518.1381632-1-biju.das.jz@bp.renesas.com>
References: <20220830164518.1381632-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document RZ/N1 power-domains support. Also update the example with
power-domains property.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v3:
 * Documented power-domains support.
---
 Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
index b1327c5b86cf..5b588726853f 100644
--- a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
+++ b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
@@ -30,6 +30,9 @@ properties:
   clocks:
     maxItems: 1
 
+  power-domains:
+    maxItems: 1
+
   reg-io-width:
     $ref: /schemas/types.yaml#/definitions/uint32
     description: I/O register width (in bytes) implemented by this device
@@ -105,6 +108,7 @@ allOf:
     then:
       required:
         - clocks
+        - power-domains
 
 unevaluatedProperties: false
 
@@ -129,4 +133,5 @@ examples:
         reg-io-width = <4>;
         interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
         clocks = <&sysctrl R9A06G032_HCLK_CAN0>;
+        power-domains = <&sysctrl>;
     };
-- 
2.25.1

