Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC00A38EA56
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbhEXOy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:54:58 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5763 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbhEXOvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 10:51:54 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fpg5b50zrzmkmN;
        Mon, 24 May 2021 22:46:43 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 22:50:18 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 24 May 2021 22:50:18 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 09/10] net: wan: fix the comments style issue
Date:   Mon, 24 May 2021 22:47:16 +0800
Message-ID: <1621867637-2680-10-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621867637-2680-1-git-send-email-huangguangbin2@huawei.com>
References: <1621867637-2680-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Block comments use * on subsequent lines.
Block comments use a trailing */ on a separate line.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/wanxl.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index 5a89b6d4d92e..18de5f1bb0ed 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -569,12 +569,14 @@ static int wanxl_pci_init_one(struct pci_dev *pdev,
 		return i;
 
 	/* QUICC can only access first 256 MB of host RAM directly,
-	   but PLX9060 DMA does 32-bits for actual packet data transfers */
+	 * but PLX9060 DMA does 32-bits for actual packet data transfers
+	 */
 
 	/* FIXME when PCI/DMA subsystems are fixed.
-	   We set both dma_mask and consistent_dma_mask to 28 bits
-	   and pray pci_alloc_consistent() will use this info. It should
-	   work on most platforms */
+	 * We set both dma_mask and consistent_dma_mask to 28 bits
+	 * and pray pci_alloc_consistent() will use this info. It should
+	 * work on most platforms
+	 */
 	if (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(28)) ||
 	    dma_set_mask(&pdev->dev, DMA_BIT_MASK(28))) {
 		pr_err("No usable DMA configuration\n");
@@ -624,8 +626,9 @@ static int wanxl_pci_init_one(struct pci_dev *pdev,
 #endif
 
 	/* FIXME when PCI/DMA subsystems are fixed.
-	   We set both dma_mask and consistent_dma_mask back to 32 bits
-	   to indicate the card can do 32-bit DMA addressing */
+	 * We set both dma_mask and consistent_dma_mask back to 32 bits
+	 * to indicate the card can do 32-bit DMA addressing
+	 */
 	if (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32)) ||
 	    dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
 		pr_err("No usable DMA configuration\n");
-- 
2.8.1

