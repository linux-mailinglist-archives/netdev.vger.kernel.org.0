Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9103CD6EB
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 16:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241259AbhGSN7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 09:59:25 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:33803 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241227AbhGSN7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 09:59:21 -0400
X-IronPort-AV: E=Sophos;i="5.84,252,1620658800"; 
   d="scan'208";a="88086585"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 19 Jul 2021 23:40:00 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 85ABD4008545;
        Mon, 19 Jul 2021 23:39:56 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH v2 4/5] clk: renesas: r9a07g044-cpg: Add entry for fixed clock P0_DIV2
Date:   Mon, 19 Jul 2021 15:38:10 +0100
Message-Id: <20210719143811.2135-5-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210719143811.2135-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210719143811.2135-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add entry for fixed core clock P0_DIV2 and assign LAST_DT_CORE_CLK
to R9A07G044_CLK_P0_DIV2.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/clk/renesas/r9a07g044-cpg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/r9a07g044-cpg.c b/drivers/clk/renesas/r9a07g044-cpg.c
index f4ebbde358c6..523521a87713 100644
--- a/drivers/clk/renesas/r9a07g044-cpg.c
+++ b/drivers/clk/renesas/r9a07g044-cpg.c
@@ -16,7 +16,7 @@
 
 enum clk_ids {
 	/* Core Clock Outputs exported to DT */
-	LAST_DT_CORE_CLK = R9A07G044_OSCCLK,
+	LAST_DT_CORE_CLK = R9A07G044_CLK_P0_DIV2,
 
 	/* External Input Clocks */
 	CLK_EXTAL,
@@ -76,6 +76,7 @@ static const struct cpg_core_clk r9a07g044_core_clks[] __initconst = {
 	DEF_FIXED("I", R9A07G044_CLK_I, CLK_PLL1, 1, 1),
 	DEF_DIV("P0", R9A07G044_CLK_P0, CLK_PLL2_DIV16, DIVPL2A,
 		dtable_1_32, CLK_DIVIDER_HIWORD_MASK),
+	DEF_FIXED("P0_DIV2", R9A07G044_CLK_P0_DIV2, R9A07G044_CLK_P0, 1, 2),
 	DEF_FIXED("TSU", R9A07G044_CLK_TSU, CLK_PLL2_DIV20, 1, 1),
 	DEF_DIV("P1", R9A07G044_CLK_P1, CLK_PLL3_DIV2_4,
 		DIVPL3B, dtable_1_32, CLK_DIVIDER_HIWORD_MASK),
-- 
2.17.1

