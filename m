Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA0547BD60
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 10:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbhLUJsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 04:48:11 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:13115 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236650AbhLUJsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 04:48:08 -0500
X-IronPort-AV: E=Sophos;i="5.88,223,1635174000"; 
   d="scan'208";a="104225032"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 21 Dec 2021 18:48:06 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 97F1A4004D02;
        Tue, 21 Dec 2021 18:48:02 +0900 (JST)
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
Subject: [PATCH 06/16] dt-bindings: serial: renesas,scif: Document RZ/V2L SoC
Date:   Tue, 21 Dec 2021 09:47:07 +0000
Message-Id: <20211221094717.16187-7-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

Add SCIF binding documentation for Renesas RZ/V2L SoC. SCIF block on RZ/V2L
is identical to one found on the RZ/G2L SoC. No driver changes are required
as RZ/G2L compatible string "renesas,scif-r9a07g044" will be used as a
fallback.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 Documentation/devicetree/bindings/serial/renesas,scif.yaml | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/serial/renesas,scif.yaml b/Documentation/devicetree/bindings/serial/renesas,scif.yaml
index 21fbfa880e29..d78f664d5eab 100644
--- a/Documentation/devicetree/bindings/serial/renesas,scif.yaml
+++ b/Documentation/devicetree/bindings/serial/renesas,scif.yaml
@@ -67,6 +67,12 @@ properties:
       - items:
           - enum:
               - renesas,scif-r9a07g044      # RZ/G2{L,LC}
+              - renesas,scif-r9a07g054      # RZ/V2L
+
+      - items:
+          - enum:
+              - renesas,scif-r9a07g054      # RZ/V2L
+          - const: renesas,scif-r9a07g044   # RZ/G2{L,LC} fallback for RZ/V2L
 
   reg:
     maxItems: 1
@@ -154,6 +160,7 @@ if:
           - renesas,rcar-gen2-scif
           - renesas,rcar-gen3-scif
           - renesas,scif-r9a07g044
+          - renesas,scif-r9a07g054
 then:
   required:
     - resets
-- 
2.17.1

