Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7326D47BD78
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 10:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhLUJs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 04:48:29 -0500
Received: from relmlor2.renesas.com ([210.160.252.172]:12386 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235492AbhLUJsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 04:48:22 -0500
X-IronPort-AV: E=Sophos;i="5.88,223,1635174000"; 
   d="scan'208";a="104695801"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 21 Dec 2021 18:48:20 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 887F54006199;
        Tue, 21 Dec 2021 18:48:16 +0900 (JST)
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
Subject: [PATCH 09/16] dt-bindings: clock: renesas: Document RZ/V2L SoC
Date:   Tue, 21 Dec 2021 09:47:10 +0000
Message-Id: <20211221094717.16187-10-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

Document the device tree binding for the Renesas RZ/V2L SoC.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 .../bindings/clock/renesas,rzg2l-cpg.yaml          | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/renesas,rzg2l-cpg.yaml b/Documentation/devicetree/bindings/clock/renesas,rzg2l-cpg.yaml
index 30b2e3d0d25d..bd3af8fc616b 100644
--- a/Documentation/devicetree/bindings/clock/renesas,rzg2l-cpg.yaml
+++ b/Documentation/devicetree/bindings/clock/renesas,rzg2l-cpg.yaml
@@ -4,13 +4,13 @@
 $id: "http://devicetree.org/schemas/clock/renesas,rzg2l-cpg.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: Renesas RZ/G2L Clock Pulse Generator / Module Standby Mode
+title: Renesas RZ/{G2L,V2L} Clock Pulse Generator / Module Standby Mode
 
 maintainers:
   - Geert Uytterhoeven <geert+renesas@glider.be>
 
 description: |
-  On Renesas RZ/G2L SoC, the CPG (Clock Pulse Generator) and Module
+  On Renesas RZ/{G2L,V2L} SoC, the CPG (Clock Pulse Generator) and Module
   Standby Mode share the same register block.
 
   They provide the following functionalities:
@@ -22,7 +22,9 @@ description: |
 
 properties:
   compatible:
-    const: renesas,r9a07g044-cpg  # RZ/G2{L,LC}
+    enum:
+      - renesas,r9a07g044-cpg  # RZ/G2{L,LC}
+      - renesas,r9a07g054-cpg  # RZ/V2L
 
   reg:
     maxItems: 1
@@ -40,9 +42,9 @@ properties:
     description: |
       - For CPG core clocks, the two clock specifier cells must be "CPG_CORE"
         and a core clock reference, as defined in
-        <dt-bindings/clock/r9a07g044-cpg.h>
+        <dt-bindings/clock/r9a07g*-cpg.h>
       - For module clocks, the two clock specifier cells must be "CPG_MOD" and
-        a module number, as defined in the <dt-bindings/clock/r9a07g044-cpg.h>.
+        a module number, as defined in the <dt-bindings/clock/r9a07g0*-cpg.h>.
     const: 2
 
   '#power-domain-cells':
@@ -56,7 +58,7 @@ properties:
   '#reset-cells':
     description:
       The single reset specifier cell must be the module number, as defined in
-      the <dt-bindings/clock/r9a07g044-cpg.h>.
+      the <dt-bindings/clock/r9a07g0*-cpg.h>.
     const: 1
 
 required:
-- 
2.17.1

