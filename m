Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0934AB218
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 21:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245594AbiBFU3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 15:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237309AbiBFU3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 15:29:37 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D047BC043185
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 12:29:36 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.88,348,1635174000"; 
   d="scan'208";a="110336622"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 07 Feb 2022 05:24:34 +0900
Received: from localhost.localdomain (unknown [10.226.92.17])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 8F02B40078DA;
        Mon,  7 Feb 2022 05:24:31 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH net-next 2/2] dt-bindings: net: renesas,etheravb: Document RZ/G2UL SoC
Date:   Sun,  6 Feb 2022 20:24:25 +0000
Message-Id: <20220206202425.15829-2-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220206202425.15829-1-biju.das.jz@bp.renesas.com>
References: <20220206202425.15829-1-biju.das.jz@bp.renesas.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document Gigabit Ethernet IP found on RZ/G2UL SoC. Gigabit Ethernet
Interface is identical to one found on the RZ/G2L SoC. No driver changes
are required as generic compatible string "renesas,rzg2l-gbeth" will be
used as a fallback.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
index db0ad6fbad89..ee2ccacc39ff 100644
--- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -45,9 +45,10 @@ properties:
 
       - items:
           - enum:
+              - renesas,r9a07g043-gbeth # RZ/G2UL
               - renesas,r9a07g044-gbeth # RZ/G2{L,LC}
               - renesas,r9a07g054-gbeth # RZ/V2L
-          - const: renesas,rzg2l-gbeth  # RZ/{G2L,V2L} family
+          - const: renesas,rzg2l-gbeth  # RZ/{G2L,G2UL,V2L} family
 
   reg: true
 
-- 
2.17.1

