Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939384AB216
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 21:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245578AbiBFU3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 15:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiBFU3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 15:29:35 -0500
X-Greylist: delayed 304 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 12:29:35 PST
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3DD4AC043184
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 12:29:35 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.88,348,1635174000"; 
   d="scan'208";a="110336605"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 07 Feb 2022 05:24:31 +0900
Received: from localhost.localdomain (unknown [10.226.92.17])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 6061F40062BD;
        Mon,  7 Feb 2022 05:24:28 +0900 (JST)
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
Subject: [PATCH RESEND net-next 1/2] dt-bindings: net: renesas,etheravb: Document RZ/V2L SoC
Date:   Sun,  6 Feb 2022 20:24:24 +0000
Message-Id: <20220206202425.15829-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document Gigabit Ethernet IP found on RZ/V2L SoC. Gigabit Ethernet
Interface is identical to one found on the RZ/G2L SoC. No driver changes
are required as generic compatible string "renesas,rzg2l-gbeth" will be
used as a fallback.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Resending to net-next, as patchwork state[1] shows not applicable

[1] https://patchwork.kernel.org/project/netdevbpf/list/?submitter=190075&state=*
---
 Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
index bda821065a2b..db0ad6fbad89 100644
--- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -46,7 +46,8 @@ properties:
       - items:
           - enum:
               - renesas,r9a07g044-gbeth # RZ/G2{L,LC}
-          - const: renesas,rzg2l-gbeth  # RZ/G2L
+              - renesas,r9a07g054-gbeth # RZ/V2L
+          - const: renesas,rzg2l-gbeth  # RZ/{G2L,V2L} family
 
   reg: true
 
-- 
2.17.1

