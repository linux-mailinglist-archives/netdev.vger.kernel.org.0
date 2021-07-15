Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4DDB3CA573
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 20:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238569AbhGOSYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 14:24:54 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:45253 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238411AbhGOSYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 14:24:50 -0400
X-IronPort-AV: E=Sophos;i="5.84,243,1620658800"; 
   d="scan'208";a="87715309"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 16 Jul 2021 03:21:55 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 16E0540C555E;
        Fri, 16 Jul 2021 03:21:51 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
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
Subject: [PATCH 5/6] clk: renesas: r9a07g044-cpg: Add clock and reset entries for CANFD
Date:   Thu, 15 Jul 2021 19:21:22 +0100
Message-Id: <20210715182123.23372-6-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210715182123.23372-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210715182123.23372-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add clock and reset entries for CANFD in CPG driver.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/clk/renesas/r9a07g044-cpg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clk/renesas/r9a07g044-cpg.c b/drivers/clk/renesas/r9a07g044-cpg.c
index 0876df9c286d..78f0efb19af8 100644
--- a/drivers/clk/renesas/r9a07g044-cpg.c
+++ b/drivers/clk/renesas/r9a07g044-cpg.c
@@ -141,6 +141,8 @@ static struct rzg2l_mod_clk r9a07g044_mod_clks[] = {
 				0x584, 4),
 	DEF_MOD("sci0",		R9A07G044_SCI0_CLKP, R9A07G044_CLK_P0,
 				0x588, 0),
+	DEF_MOD("canfd",	R9A07G044_CANFD_PCLK, R9A07G044_CLK_P0,
+				0x594, 0),
 	DEF_MOD("gpio",		R9A07G044_GPIO_HCLK, R9A07G044_OSCCLK,
 				0x598, 0),
 };
@@ -169,6 +171,8 @@ static struct rzg2l_reset r9a07g044_resets[] = {
 	DEF_RST(R9A07G044_SCIF3_RST_SYSTEM_N, 0x884, 3),
 	DEF_RST(R9A07G044_SCIF4_RST_SYSTEM_N, 0x884, 4),
 	DEF_RST(R9A07G044_SCI0_RST, 0x888, 0),
+	DEF_RST(R9A07G044_CANFD_RSTP_N, 0x894, 0),
+	DEF_RST(R9A07G044_CANFD_RSTC_N, 0x894, 1),
 	DEF_RST(R9A07G044_GPIO_RSTN, 0x898, 0),
 	DEF_RST(R9A07G044_GPIO_PORT_RESETN, 0x898, 1),
 	DEF_RST(R9A07G044_GPIO_SPARE_RESETN, 0x898, 2),
-- 
2.17.1

