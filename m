Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D4142A9A5
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhJLQjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:39:18 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:11336 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231655AbhJLQjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 12:39:17 -0400
X-IronPort-AV: E=Sophos;i="5.85,368,1624287600"; 
   d="scan'208";a="96771860"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 13 Oct 2021 01:37:12 +0900
Received: from localhost.localdomain (unknown [10.226.92.46])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 4F52B40AA82C;
        Wed, 13 Oct 2021 01:37:09 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH net-next v3 14/14] ravb: Fix typo AVB->DMAC
Date:   Tue, 12 Oct 2021 17:36:13 +0100
Message-Id: <20211012163613.30030-15-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the typo AVB->DMAC in comment, as the code following the comment
is for DMAC on Gigabit Ethernet IP.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
v2->v3:
 * Added Sergey's Rb tag.
v1->v2:
 * No change
v1:
 * New patch.
---
 drivers/net/ethernet/renesas/ravb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index f3f676e433d1..e5243cc87a19 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -588,7 +588,7 @@ static int ravb_dmac_init_gbeth(struct net_device *ndev)
 	/* Descriptor format */
 	ravb_ring_format(ndev, RAVB_BE);
 
-	/* Set AVB RX */
+	/* Set DMAC RX */
 	ravb_write(ndev, 0x60000000, RCR);
 
 	/* Set Max Frame Length (RTC) */
-- 
2.17.1

