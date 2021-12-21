Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFAE47BD48
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 10:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236648AbhLUJr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 04:47:56 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:20076 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236603AbhLUJry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 04:47:54 -0500
X-IronPort-AV: E=Sophos;i="5.88,223,1635174000"; 
   d="scan'208";a="104225009"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 21 Dec 2021 18:47:53 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id BE7CC4006199;
        Tue, 21 Dec 2021 18:47:48 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        dmaengine@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-serial@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH 03/16] dt-bindings: power: renesas,rzg2l-sysc: Document RZ/V2L SoC
Date:   Tue, 21 Dec 2021 09:47:04 +0000
Message-Id: <20211221094717.16187-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

Add DT binding documentation for SYSC controller found on RZ/V2L SoC.
SYSC controller found on the RZ/V2L SoC is almost identical to one found
on the RZ/G2L SoC's only difference being that the RZ/V2L has an
additional register to control the DRP-AI.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 .../devicetree/bindings/power/renesas,rzg2l-sysc.yaml      | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/power/renesas,rzg2l-sysc.yaml b/Documentation/devicetree/bindings/power/renesas,rzg2l-sysc.yaml
index 84ddc772b003..bb433e75a0ee 100644
--- a/Documentation/devicetree/bindings/power/renesas,rzg2l-sysc.yaml
+++ b/Documentation/devicetree/bindings/power/renesas,rzg2l-sysc.yaml
@@ -4,14 +4,14 @@
 $id: "http://devicetree.org/schemas/power/renesas,rzg2l-sysc.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Renesas RZ/G2L System Controller (SYSC)
+title: Renesas RZ/{G2L,V2L} System Controller (SYSC)
 
 maintainers:
   - Geert Uytterhoeven <geert+renesas@glider.be>
 
 description:
-  The RZ/G2L System Controller (SYSC) performs system control of the LSI and
-  supports following functions,
+  The RZ/{G2L,V2L} System Controller (SYSC) performs system control of the LSI
+  and supports following functions,
   - External terminal state capture function
   - 34-bit address space access function
   - Low power consumption control
@@ -21,6 +21,7 @@ properties:
   compatible:
     enum:
       - renesas,r9a07g044-sysc # RZ/G2{L,LC}
+      - renesas,r9a07g054-sysc # RZ/V2L
 
   reg:
     maxItems: 1
-- 
2.17.1

