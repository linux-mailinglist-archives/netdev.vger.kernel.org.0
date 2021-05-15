Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7EF3817D4
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbhEOK41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:56:27 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3538 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbhEOKzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:47 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jh6BsNzsRCX;
        Sat, 15 May 2021 18:51:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:23 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Raju Rangoju <rajur@chelsio.com>
Subject: [PATCH 09/34] net: chelsio: cxgb3: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:34 +0800
Message-ID: <1621076039-53986-10-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/chelsio/cxgb3/sge.c:677: warning: expecting prototype for free_qset(). Prototype was for t3_free_qset() instead
 drivers/net/ethernet/chelsio/cxgb3/sge.c:1266: warning: expecting prototype for eth_xmit(). Prototype was for t3_eth_xmit() instead

Cc: Raju Rangoju <rajur@chelsio.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb3/sge.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index 1cc3c51..cec7308 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -665,7 +665,7 @@ static void t3_reset_qset(struct sge_qset *q)
 
 
 /**
- *	free_qset - free the resources of an SGE queue set
+ *	t3_free_qset - free the resources of an SGE queue set
  *	@adapter: the adapter owning the queue set
  *	@q: the queue set
  *
@@ -1256,7 +1256,7 @@ static inline void t3_stop_tx_queue(struct netdev_queue *txq,
 }
 
 /**
- *	eth_xmit - add a packet to the Ethernet Tx queue
+ *	t3_eth_xmit - add a packet to the Ethernet Tx queue
  *	@skb: the packet
  *	@dev: the egress net device
  *
-- 
2.7.4

