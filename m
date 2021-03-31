Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE9F34FB75
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhCaIVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:21:41 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15113 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbhCaIVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:21:17 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F9K3L2L3xz1BFwC;
        Wed, 31 Mar 2021 16:19:10 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Wed, 31 Mar 2021 16:21:04 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Yixing Liu <liuyixing1@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 2/7] net: ena: remove extra words from comments
Date:   Wed, 31 Mar 2021 16:18:29 +0800
Message-ID: <1617178714-14031-3-git-send-email-liweihang@huawei.com>
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

From: Yixing Liu <liuyixing1@huawei.com>

Remove the redundant "for" from the commment.

Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 5c062c5..881f887 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3975,7 +3975,7 @@ static u32 ena_calc_max_io_queue_num(struct pci_dev *pdev,
 	max_num_io_queues = min_t(u32, max_num_io_queues, io_rx_num);
 	max_num_io_queues = min_t(u32, max_num_io_queues, io_tx_sq_num);
 	max_num_io_queues = min_t(u32, max_num_io_queues, io_tx_cq_num);
-	/* 1 IRQ for for mgmnt and 1 IRQs for each IO direction */
+	/* 1 IRQ for mgmnt and 1 IRQs for each IO direction */
 	max_num_io_queues = min_t(u32, max_num_io_queues, pci_msix_vec_count(pdev) - 1);
 	if (unlikely(!max_num_io_queues)) {
 		dev_err(&pdev->dev, "The device doesn't have io queues\n");
-- 
2.8.1

