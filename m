Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C390489A93
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbiAJNrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:47:53 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:26568 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234182AbiAJNrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:47:35 -0500
X-IronPort-AV: E=Sophos;i="5.88,277,1635174000"; 
   d="scan'208";a="106014830"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 10 Jan 2022 22:47:35 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 9688242E354C;
        Mon, 10 Jan 2022 22:47:32 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-renesas-soc@vger.kernel.org,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        linux-kernel@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v2 09/12] dt-bindings: net: renesas,etheravb: Document RZ/V2L SoC
Date:   Mon, 10 Jan 2022 13:46:56 +0000
Message-Id: <20220110134659.30424-10-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220110134659.30424-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20220110134659.30424-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

Document Gigabit Ethernet IP found on RZ/V2L SoC. Gigabit Ethernet
Interface is identical to one found on the RZ/G2L SoC. No driver changes
are required as generic compatible string "renesas,rzg2l-gbeth" will be
used as a fallback.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Acked-by: Rob Herring <robh@kernel.org>
---
v1->v2
* Included ACK from ROB
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

