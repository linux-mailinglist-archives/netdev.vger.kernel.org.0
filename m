Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910B43D160B
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 20:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237131AbhGURgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 13:36:54 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:42300 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229948AbhGURgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 13:36:53 -0400
X-IronPort-AV: E=Sophos;i="5.84,258,1620658800"; 
   d="scan'208";a="88346506"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 22 Jul 2021 03:17:27 +0900
Received: from localhost.localdomain (unknown [10.226.92.105])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id D9E4D4000A89;
        Thu, 22 Jul 2021 03:17:23 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andrew Lunn <andrew@lunn.ch>, Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH] ravb: Fix a typo in comment
Date:   Wed, 21 Jul 2021 19:17:21 +0100
Message-Id: <20210721181721.17314-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the typo RX->TX in comment, as the code following the comment
process TX and not RX.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 69c50f81e1cb..805397088850 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -920,7 +920,7 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	if (ravb_rx(ndev, &quota, q))
 		goto out;
 
-	/* Processing RX Descriptor Ring */
+	/* Processing TX Descriptor Ring */
 	spin_lock_irqsave(&priv->lock, flags);
 	/* Clear TX interrupt */
 	ravb_write(ndev, ~(mask | TIS_RESERVED), TIS);
-- 
2.17.1

