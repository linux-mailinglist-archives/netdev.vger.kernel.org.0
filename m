Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB6638260E
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235781AbhEQIAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:00:46 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2992 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235489AbhEQIAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:13 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FkBJH5zttzQpRD;
        Mon, 17 May 2021 15:55:27 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:55 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:55 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Byungho An <bh74.an@samsung.com>
Subject: [PATCH v2 19/24] net: samsung: sxgbe: Fix wrong function name in comments
Date:   Mon, 17 May 2021 12:45:30 +0800
Message-ID: <20210517044535.21473-20-shenyang39@huawei.com>
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

 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:797: warning: expecting prototype for sxgbe_tx_clean(). Prototype was for sxgbe_tx_all_clean() instead
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:1026: warning: expecting prototype for sxgbe_init_tx_coalesce(). Prototype was for sxgbe_tx_init_coalesce() instead

Cc: Byungho An <bh74.an@samsung.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 971f1e54b652..090bcd2fb758 100644
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
2.17.1

