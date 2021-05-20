Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2719F389C0E
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 05:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhETDwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 23:52:21 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3613 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhETDwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 23:52:19 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Flwh90xq0zmXfb;
        Thu, 20 May 2021 11:48:41 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 11:50:57 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 20 May 2021 11:50:57 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tanghui20@huawei.com>, Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next 1/9] net: wan: remove leading spaces before tabs
Date:   Thu, 20 May 2021 11:47:46 +0800
Message-ID: <1621482474-26903-2-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621482474-26903-1-git-send-email-tanghui20@huawei.com>
References: <1621482474-26903-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running
the following commard:

	$ find . -name '*.[ch]' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Xie He <xie.he.0141@gmail.com>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/wan/lmc/lmc.h | 2 +-
 drivers/net/wan/wanxl.c   | 4 ++--
 drivers/net/wan/z85230.c  | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/lmc/lmc.h b/drivers/net/wan/lmc/lmc.h
index 3896179..3bd541c 100644
--- a/drivers/net/wan/lmc/lmc.h
+++ b/drivers/net/wan/lmc/lmc.h
@@ -9,7 +9,7 @@
  */
 int lmc_probe(struct net_device * dev);
 unsigned lmc_mii_readreg(lmc_softc_t * const sc, unsigned
-      			  devaddr, unsigned regno);
+			  devaddr, unsigned regno);
 void lmc_mii_writereg(lmc_softc_t * const sc, unsigned devaddr,
 			       unsigned regno, unsigned data);
 void lmc_led_on(lmc_softc_t * const, u32);
diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index a831333..f393684 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -639,7 +639,7 @@ static int wanxl_pci_init_one(struct pci_dev *pdev,
 	card->plx = ioremap(plx_phy, 0x70);
 	if (!card->plx) {
 		pr_err("ioremap() failed\n");
- 		wanxl_pci_remove_one(pdev);
+		wanxl_pci_remove_one(pdev);
 		return -EFAULT;
 	}
 
@@ -707,7 +707,7 @@ static int wanxl_pci_init_one(struct pci_dev *pdev,
 	mem = ioremap(mem_phy, PDM_OFFSET + sizeof(firmware));
 	if (!mem) {
 		pr_err("ioremap() failed\n");
- 		wanxl_pci_remove_one(pdev);
+		wanxl_pci_remove_one(pdev);
 		return -EFAULT;
 	}
 
diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index 138930c..002b8c99 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -1080,7 +1080,7 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 	z8530_rx_done(c);
 	z8530_rx_done(c);
 
- 	/*
+	/*
 	 *	Load the DMA interfaces up
 	 */
 
@@ -1092,13 +1092,13 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 	c->dma_ready=1;
 	c->dma_tx = 1;
 
- 	/*
+	/*
 	 *	Enable DMA control mode
 	 */
 
- 	/*
+	/*
 	 *	TX DMA via DIR/REQ
- 	 */
+	 */
 	c->regs[R14]|= DTRREQ;
 	write_zsreg(c, R14, c->regs[R14]);     
 	
-- 
2.8.1

