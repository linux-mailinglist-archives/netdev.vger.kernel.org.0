Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3384F427FBA
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 09:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhJJHb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 03:31:29 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:2512 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229697AbhJJHb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 03:31:28 -0400
X-IronPort-AV: E=Sophos;i="5.85,362,1624287600"; 
   d="scan'208";a="96511103"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 10 Oct 2021 16:29:29 +0900
Received: from localhost.localdomain (unknown [10.226.92.12])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 3D5B5400197C;
        Sun, 10 Oct 2021 16:29:26 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: [PATCH net-next v2 01/14] ravb: Use ALIGN macro for max_rx_len
Date:   Sun, 10 Oct 2021 08:29:07 +0100
Message-Id: <20211010072920.20706-2-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211010072920.20706-1-biju.das.jz@bp.renesas.com>
References: <20211010072920.20706-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use ALIGN macro for calculating the value for max_rx_len.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
v1->v2:
 * No change.
RFC->v1:
 * No Change. Added Sergey's Rb tag
---
 drivers/net/ethernet/renesas/ravb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 9a4888543384..56a97d583950 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2227,7 +2227,7 @@ static const struct ravb_hw_info gbeth_hw_info = {
 	.set_feature = ravb_set_features_gbeth,
 	.dmac_init = ravb_dmac_init_gbeth,
 	.emac_init = ravb_emac_init_gbeth,
-	.max_rx_len = GBETH_RX_BUFF_MAX + RAVB_ALIGN - 1,
+	.max_rx_len = ALIGN(GBETH_RX_BUFF_MAX, RAVB_ALIGN),
 	.tsrq = TCCR_TSRQ0,
 	.aligned_tx = 1,
 	.tx_counters = 1,
-- 
2.17.1

