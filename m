Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC018382613
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235618AbhEQIAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:00:53 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2936 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234956AbhEQIAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:11 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FkBK52Yw5zCtXB;
        Mon, 17 May 2021 15:56:09 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:54 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:53 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Raju Rangoju <rajur@chelsio.com>
Subject: [PATCH v2 09/24] net: chelsio: cxgb3: Fix wrong function name in comments
Date:   Mon, 17 May 2021 12:45:20 +0800
Message-ID: <20210517044535.21473-10-shenyang39@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210517044535.21473-1-shenyang39@huawei.com>
References: <20210517044535.21473-1-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema704-chm.china.huawei.com (10.3.20.68)
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
index 1cc3c51eff71..cec7308e2d5b 100644
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
2.17.1

