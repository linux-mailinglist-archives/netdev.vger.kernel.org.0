Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01F1427D0A
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 21:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhJITK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 15:10:58 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:40815 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230520AbhJITKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 15:10:52 -0400
X-IronPort-AV: E=Sophos;i="5.85,361,1624287600"; 
   d="scan'208";a="96477027"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 10 Oct 2021 04:08:54 +0900
Received: from localhost.localdomain (unknown [10.226.92.6])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 8C7FD4001B64;
        Sun, 10 Oct 2021 04:08:51 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 13/14] ravb: Update EMAC configuration mode comment
Date:   Sat,  9 Oct 2021 20:08:01 +0100
Message-Id: <20211009190802.18585-14-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211009190802.18585-1-biju.das.jz@bp.renesas.com>
References: <20211009190802.18585-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update EMAC configuration mode comment from "PAUSE prohibition"
to "EMAC Mode: PAUSE prohibition; Duplex; TX; RX; CRC Pass Through;
Promiscuous".

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
V1:
 * New patch.
---
 drivers/net/ethernet/renesas/ravb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 9a770a05c017..b78aca235c37 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -519,7 +519,7 @@ static void ravb_emac_init_gbeth(struct net_device *ndev)
 	/* Receive frame limit set register */
 	ravb_write(ndev, GBETH_RX_BUFF_MAX + ETH_FCS_LEN, RFLR);
 
-	/* PAUSE prohibition */
+	/* EMAC Mode: PAUSE prohibition; Duplex; TX; RX; CRC Pass Through; Promiscuous */
 	ravb_write(ndev, ECMR_ZPF | ((priv->duplex > 0) ? ECMR_DM : 0) |
 			 ECMR_TE | ECMR_RE | ECMR_RCPT |
 			 ECMR_TXF | ECMR_RXF | ECMR_PRM, ECMR);
-- 
2.17.1

