Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE14137F311
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 08:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhEMGbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 02:31:16 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2467 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbhEMGbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 02:31:02 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FghXD5Y1rzBv0C;
        Thu, 13 May 2021 14:27:08 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Thu, 13 May 2021 14:29:47 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <luobin9@huawei.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 2/4] net: hinic: add blank line after function declaration
Date:   Thu, 13 May 2021 14:26:51 +0800
Message-ID: <1620887213-49364-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1620887213-49364-1-git-send-email-huangguangbin2@huawei.com>
References: <1620887213-49364-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There should be a blank line after function declaration, so add two
missed blank lines.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c | 1 +
 drivers/net/ethernet/huawei/hinic/hinic_rx.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
index 5dc3743f8091..7f0f1aa3cedd 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
@@ -89,6 +89,7 @@ static inline int WQE_PAGE_NUM(struct hinic_wq *wq, u16 idx)
 	return (((idx) >> ((wq)->wqebbs_per_page_shift))
 		& ((wq)->num_q_pages - 1));
 }
+
 /**
  * queue_alloc_page - allocate page for Queue
  * @hwif: HW interface for allocating DMA
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index cce08647b9b2..fed3b6bc0d76 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -118,6 +118,7 @@ static void rx_csum(struct hinic_rxq *rxq, u32 status,
 		skb->ip_summed = CHECKSUM_NONE;
 	}
 }
+
 /**
  * rx_alloc_skb - allocate skb and map it to dma address
  * @rxq: rx queue
-- 
2.8.1

