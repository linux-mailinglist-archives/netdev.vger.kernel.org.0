Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A182834FB74
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbhCaIVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:21:40 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15114 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbhCaIVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:21:17 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F9K3L2mP4z1BFwG;
        Wed, 31 Mar 2021 16:19:10 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Wed, 31 Mar 2021 16:21:06 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Yangyang Li <liyangyang20@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 7/7] net: lpc_eth: fix format warnings of block comments
Date:   Wed, 31 Mar 2021 16:18:34 +0800
Message-ID: <1617178714-14031-8-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617178714-14031-1-git-send-email-liweihang@huawei.com>
References: <1617178714-14031-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangyang Li <liyangyang20@huawei.com>

Fix the following format warning:
1. Block comments use * on subsequent lines
2. Block comments use a trailing */ on a separate line

Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/ethernet/nxp/lpc_eth.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index d3cbb42..e72fd33 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1044,7 +1044,8 @@ static netdev_tx_t lpc_eth_hard_start_xmit(struct sk_buff *skb,
 
 	if (pldat->num_used_tx_buffs >= (ENET_TX_DESC - 1)) {
 		/* This function should never be called when there are no
-		   buffers */
+		 * buffers
+		 */
 		netif_stop_queue(ndev);
 		spin_unlock_irq(&pldat->lock);
 		WARN(1, "BUG! TX request when no free TX buffers!\n");
@@ -1318,7 +1319,8 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 		pldat->dma_buff_size = PAGE_ALIGN(pldat->dma_buff_size);
 
 		/* Allocate a chunk of memory for the DMA ethernet buffers
-		   and descriptors */
+		 * and descriptors
+		 */
 		pldat->dma_buff_base_v =
 			dma_alloc_coherent(dev,
 					   pldat->dma_buff_size, &dma_handle,
@@ -1365,7 +1367,8 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	__lpc_mii_mngt_reset(pldat);
 
 	/* Force default PHY interface setup in chip, this will probably be
-	   changed by the PHY driver */
+	 * changed by the PHY driver
+	 */
 	pldat->link = 0;
 	pldat->speed = 100;
 	pldat->duplex = DUPLEX_FULL;
-- 
2.8.1

