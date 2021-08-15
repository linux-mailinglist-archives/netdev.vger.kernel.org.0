Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABFB3EC956
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 15:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238188AbhHONkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 09:40:08 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:6914 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232412AbhHONkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 09:40:03 -0400
X-IronPort-AV: E=Sophos;i="5.84,322,1620658800"; 
   d="scan'208";a="90675795"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 15 Aug 2021 22:39:31 +0900
Received: from localhost.localdomain (unknown [10.226.92.6])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 18E88428F88C;
        Sun, 15 Aug 2021 22:39:28 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH] dt-bindings: net: renesas,etheravb: Drop "int_" prefix and "_n" suffix from interrupt names
Date:   Sun, 15 Aug 2021 14:39:26 +0100
Message-Id: <20210815133926.22860-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch updates interrupt-names with dropping "int_" prefix and
"_n" suffix.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
Ref:- https://lore.kernel.org/linux-renesas-soc/CAMuHMdU6iO+LkL5WURGMN7kkYLRJe9v3MbrqA_CBp74oskdeyA@mail.gmail.com/T/#t
---
 Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
index 5e12a759004f..4c927d2c17d3 100644
--- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -154,8 +154,8 @@ allOf:
           minItems: 1
           items:
             - const: mux
-            - const: int_fil_n
-            - const: int_arp_ns_n
+            - const: fil
+            - const: arp_ns
         rx-internal-delay-ps: false
     else:
       properties:
-- 
2.17.1

