Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6302D3825F8
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbhEQIAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:00:15 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2996 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbhEQIAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:11 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FkBKg36FszmWrZ;
        Mon, 17 May 2021 15:56:39 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:53 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:53 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>
Subject: [PATCH v2 08/24] net: calxeda: Fix wrong function name in comments
Date:   Mon, 17 May 2021 12:45:19 +0800
Message-ID: <20210517044535.21473-9-shenyang39@huawei.com>
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

 drivers/net/ethernet/calxeda/xgmac.c:720: warning: expecting prototype for init_xgmac_dma_desc_rings(). Prototype was for xgmac_dma_desc_rings_init() instead
 drivers/net/ethernet/calxeda/xgmac.c:867: warning: expecting prototype for xgmac_tx(). Prototype was for xgmac_tx_complete() instead
 drivers/net/ethernet/calxeda/xgmac.c:1049: warning: expecting prototype for xgmac_release(). Prototype was for xgmac_stop() instead
 drivers/net/ethernet/calxeda/xgmac.c:1822: warning: expecting prototype for xgmac_dvr_remove(). Prototype was for xgmac_remove() instead

Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/calxeda/xgmac.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index bbb453c6a5f7..b6a066404f4b 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -711,7 +711,7 @@ static void xgmac_rx_refill(struct xgmac_priv *priv)
 }
 
 /**
- * init_xgmac_dma_desc_rings - init the RX/TX descriptor rings
+ * xgmac_dma_desc_rings_init - init the RX/TX descriptor rings
  * @dev: net device structure
  * Description:  this function initializes the DMA RX/TX descriptors
  * and allocates the socket buffers.
@@ -859,7 +859,7 @@ static void xgmac_free_dma_desc_rings(struct xgmac_priv *priv)
 }
 
 /**
- * xgmac_tx:
+ * xgmac_tx_complete:
  * @priv: private driver structure
  * Description: it reclaims resources after transmission completes.
  */
@@ -1040,7 +1040,7 @@ static int xgmac_open(struct net_device *dev)
 }
 
 /**
- *  xgmac_release - close entry point of the driver
+ *  xgmac_stop - close entry point of the driver
  *  @dev : device pointer.
  *  Description:
  *  This is the stop entry point of the driver.
@@ -1812,7 +1812,7 @@ static int xgmac_probe(struct platform_device *pdev)
 }
 
 /**
- * xgmac_dvr_remove
+ * xgmac_remove
  * @pdev: platform device pointer
  * Description: this function resets the TX/RX processes, disables the MAC RX/TX
  * changes the link status, releases the DMA descriptor rings,
-- 
2.17.1

