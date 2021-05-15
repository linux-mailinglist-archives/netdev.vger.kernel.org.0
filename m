Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCEFF3817E7
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbhEOK52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:57:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3539 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbhEOKzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:54 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jn5CBTzsRHV;
        Sat, 15 May 2021 18:51:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:26 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Byungho An <bh74.an@samsung.com>
Subject: [PATCH 19/34] net: samsung: sxgbe: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:44 +0800
Message-ID: <1621076039-53986-20-git-send-email-shenyang39@huawei.com>
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

 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:797: warning: expecting prototype for sxgbe_tx_clean(). Prototype was for sxgbe_tx_all_clean() instead
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:1026: warning: expecting prototype for sxgbe_init_tx_coalesce(). Prototype was for sxgbe_tx_init_coalesce() instead

Cc: Byungho An <bh74.an@samsung.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 971f1e5..090bcd2 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -789,7 +789,7 @@ static void sxgbe_tx_queue_clean(struct sxgbe_tx_queue *tqueue)
 }
 
 /**
- * sxgbe_tx_clean:
+ * sxgbe_tx_all_clean:
  * @priv: driver private structure
  * Description: it reclaims resources after transmission completes.
  */
@@ -1015,7 +1015,7 @@ static void sxgbe_tx_timer(struct timer_list *t)
 }
 
 /**
- * sxgbe_init_tx_coalesce: init tx mitigation options.
+ * sxgbe_tx_init_coalesce: init tx mitigation options.
  * @priv: driver private structure
  * Description:
  * This inits the transmit coalesce parameters: i.e. timer rate,
-- 
2.7.4

