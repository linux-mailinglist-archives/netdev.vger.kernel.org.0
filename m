Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB523817CF
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhEOK4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:56:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2605 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbhEOKzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:45 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jh5zrnzsRBK;
        Sat, 15 May 2021 18:51:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:23 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>
Subject: [PATCH 08/34] net: calxeda: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:33 +0800
Message-ID: <1621076039-53986-9-git-send-email-shenyang39@huawei.com>
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

 drivers/net/ethernet/calxeda/xgmac.c:720: warning: expecting prototype for init_xgmac_dma_desc_rings(). Prototype was for xgmac_dma_desc_rings_init() instead
 drivers/net/ethernet/calxeda/xgmac.c:867: warning: expecting prototype for xgmac_tx(). Prototype was for xgmac_tx_complete() instead
 drivers/net/ethernet/calxeda/xgmac.c:1049: warning: expecting prototype for xgmac_release(). Prototype was for xgmac_stop() instead
 drivers/net/ethernet/calxeda/xgmac.c:1822: warning: expecting prototype for xgmac_dvr_remove(). Prototype was for xgmac_remove() instead

Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/calxeda/xgmac.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index bbb453c..b6a0664 100644
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
2.7.4

