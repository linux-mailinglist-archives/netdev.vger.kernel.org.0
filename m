Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787E3272507
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbgIUNKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:10:16 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13758 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727245AbgIUNKP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 09:10:15 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 171CC431CE6BBDCBA1C4;
        Mon, 21 Sep 2020 21:10:12 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 21:10:03 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH -next] enetc: simplify the return expression of enetc_vf_set_mac_addr()
Date:   Mon, 21 Sep 2020 21:10:26 +0800
Message-ID: <20200921131026.91790-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_vf.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index f14576212..7b5c82c7e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -78,16 +78,11 @@ static int enetc_vf_set_mac_addr(struct net_device *ndev, void *addr)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct sockaddr *saddr = addr;
-	int err;
 
 	if (!is_valid_ether_addr(saddr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	err = enetc_msg_vsi_set_primary_mac_addr(priv, saddr);
-	if (err)
-		return err;
-
-	return 0;
+	return enetc_msg_vsi_set_primary_mac_addr(priv, saddr);
 }
 
 static int enetc_vf_set_features(struct net_device *ndev,
-- 
2.23.0

