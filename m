Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F15D50CA5F
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 15:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbiDWNK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 09:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiDWNKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 09:10:53 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BD6B1C919;
        Sat, 23 Apr 2022 06:07:51 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.90,284,1643641200"; 
   d="scan'208";a="118905945"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 23 Apr 2022 22:07:51 +0900
Received: from localhost.localdomain (unknown [10.226.92.16])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id C34E2421455F;
        Sat, 23 Apr 2022 22:07:45 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH] dt-bindings: can: renesas,rcar-canfd: Document RZ/G2UL support
Date:   Sat, 23 Apr 2022 14:07:43 +0100
Message-Id: <20220423130743.123198-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add CANFD binding documentation for Renesas R9A07G043 (RZ/G2UL) SoC.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml          | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
index f98c53dc1894..96259868df43 100644
--- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
@@ -32,6 +32,7 @@ properties:
 
       - items:
           - enum:
+              - renesas,r9a07g043-canfd    # RZ/G2UL
               - renesas,r9a07g044-canfd    # RZ/G2{L,LC}
               - renesas,r9a07g054-canfd    # RZ/V2L
           - const: renesas,rzg2l-canfd     # RZ/G2L family
-- 
2.25.1

