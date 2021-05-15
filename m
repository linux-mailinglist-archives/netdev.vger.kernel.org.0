Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9D53817CA
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhEOKzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:55:52 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2602 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbhEOKzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:45 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jh4n0mzsR9k;
        Sat, 15 May 2021 18:51:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:24 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Raju Rangoju <rajur@chelsio.com>
Subject: [PATCH 11/34] net: chelsio: cxgb4vf: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:36 +0800
Message-ID: <1621076039-53986-12-git-send-email-shenyang39@huawei.com>
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

 drivers/net/ethernet/chelsio/cxgb4vf/sge.c:966: warning: expecting prototype for check_ring_tx_db(). Prototype was for ring_tx_db() instead

Cc: Raju Rangoju <rajur@chelsio.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
index 95657da..7bc80ee 100644
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
2.7.4

