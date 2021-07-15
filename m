Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B513CA567
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 20:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbhGOSYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 14:24:47 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:47270 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238283AbhGOSYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 14:24:42 -0400
X-IronPort-AV: E=Sophos;i="5.84,243,1620658800"; 
   d="scan'208";a="87775120"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 16 Jul 2021 03:21:47 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 44F6940C5552;
        Fri, 16 Jul 2021 03:21:44 +0900 (JST)
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
Subject: [PATCH 3/6] dt-bindings: clk: r9a07g044-cpg: Add entry for P0_DIV2 core clock
Date:   Thu, 15 Jul 2021 19:21:20 +0100
Message-Id: <20210715182123.23372-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210715182123.23372-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210715182123.23372-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add P0_DIV2 core clock required for CANFD module. CANFD core clock is
sourced from P0_DIV2 referenced from HW manual Rev.0.50.

Also add R9A07G044_LAST_CORE_CLK entry to avoid changes in
r9a07g044-cpg.c file.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 include/dt-bindings/clock/r9a07g044-cpg.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/dt-bindings/clock/r9a07g044-cpg.h b/include/dt-bindings/clock/r9a07g044-cpg.h
index 0728ad07ff7a..2fd20db0b2f4 100644
--- a/include/dt-bindings/clock/r9a07g044-cpg.h
+++ b/include/dt-bindings/clock/r9a07g044-cpg.h
@@ -30,6 +30,8 @@
 #define R9A07G044_CLK_P2		19
 #define R9A07G044_CLK_AT		20
 #define R9A07G044_OSCCLK		21
+#define R9A07G044_CLK_P0_DIV2		22
+#define R9A07G044_LAST_CORE_CLK		23
 
 /* R9A07G044 Module Clocks */
 #define R9A07G044_CA55_SCLK		0
-- 
2.17.1

