Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27F7382603
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235680AbhEQIA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:00:29 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3774 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234378AbhEQIAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:11 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FkBJH00Vgzmj1L;
        Mon, 17 May 2021 15:55:26 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:54 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:54 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Raju Rangoju <rajur@chelsio.com>
Subject: [PATCH v2 11/24] net: chelsio: cxgb4vf: Fix wrong function name in comments
Date:   Mon, 17 May 2021 12:45:22 +0800
Message-ID: <20210517044535.21473-12-shenyang39@huawei.com>
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

 drivers/net/ethernet/chelsio/cxgb4vf/sge.c:966: warning: expecting prototype for check_ring_tx_db(). Prototype was for ring_tx_db() instead

Cc: Raju Rangoju <rajur@chelsio.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
index 95657da0aa4b..7bc80eeb2c21 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
@@ -954,7 +954,7 @@ static void write_sgl(const struct sk_buff *skb, struct sge_txq *tq,
 }
 
 /**
- *	check_ring_tx_db - check and potentially ring a TX queue's doorbell
+ *	ring_tx_db - check and potentially ring a TX queue's doorbell
  *	@adapter: the adapter
  *	@tq: the TX queue
  *	@n: number of new descriptors to give to HW
-- 
2.17.1

