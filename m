Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCB75BB7D3
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 12:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiIQKjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 06:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiIQKjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 06:39:32 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EFCCEA;
        Sat, 17 Sep 2022 03:39:30 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MV6n84cfszpSsw;
        Sat, 17 Sep 2022 18:36:44 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 17 Sep 2022 18:39:29 +0800
Received: from localhost.localdomain (10.67.165.2) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 17 Sep 2022 18:39:28 +0800
From:   Haoyue Xu <xuhaoyue1@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.simek@xilinx.com>
CC:     <huangdaode@huawei.com>, <liyangyang20@huawei.com>,
        <xuhaoyue1@hisilicon.com>, <huangjunxian6@hisilicon.com>,
        <linuxarm@huawei.com>, <liangwenpeng@huawei.com>
Subject: [PATCH net-next 3/7] net: ll_temac: axienet: align with open parenthesis
Date:   Sat, 17 Sep 2022 18:38:39 +0800
Message-ID: <20220917103843.526877-4-xuhaoyue1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20220917103843.526877-1-xuhaoyue1@hisilicon.com>
References: <20220917103843.526877-1-xuhaoyue1@hisilicon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: huangjunxian <huangjunxian6@hisilicon.com>

Cleaning some static warnings of open parenthesis.

Signed-off-by: huangjunxian <huangjunxian6@hisilicon.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c       | 7 +++----
 drivers/net/ethernet/xilinx/xilinx_axienet.h      | 2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 26fbe60e2cf4..562b461224e7 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -261,7 +261,7 @@ static void temac_dma_dcr_out(struct temac_local *lp, int reg, u32 value)
  * I/O  functions
  */
 static int temac_dcr_setup(struct temac_local *lp, struct platform_device *op,
-				struct device_node *np)
+			   struct device_node *np)
 {
 	unsigned int dcrs;
 
@@ -286,7 +286,7 @@ static int temac_dcr_setup(struct temac_local *lp, struct platform_device *op,
  * such as with MicroBlaze and x86
  */
 static int temac_dcr_setup(struct temac_local *lp, struct platform_device *op,
-				struct device_node *np)
+			   struct device_node *np)
 {
 	return -1;
 }
@@ -309,7 +309,7 @@ static void temac_dma_bd_release(struct net_device *ndev)
 			break;
 		else {
 			dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
-					XTE_MAX_JUMBO_FRAME_SIZE, DMA_FROM_DEVICE);
+					 XTE_MAX_JUMBO_FRAME_SIZE, DMA_FROM_DEVICE);
 			dev_kfree_skb(lp->rx_skb[i]);
 		}
 	}
@@ -682,7 +682,6 @@ static void temac_device_reset(struct net_device *ndev)
 	if (temac_dma_bd_init(ndev)) {
 		dev_err(&ndev->dev,
 			"%s descriptor allocation failed\n", __func__);
-
 	}
 
 	spin_lock_irqsave(lp->indirect_lock, flags);
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 8ff4333de2ad..6370c447ac5c 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -603,7 +603,7 @@ static inline void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
 #else /* CONFIG_64BIT */
 
 static inline void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
-				 dma_addr_t addr)
+					dma_addr_t addr)
 {
 	axienet_dma_out32(lp, reg, lower_32_bits(addr));
 }
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 9fde5941a469..15d1c8158f31 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -597,7 +597,7 @@ static int axienet_device_reset(struct net_device *ndev)
 	lp->options &= (~XAE_OPTION_JUMBO);
 
 	if ((ndev->mtu > XAE_MTU) &&
-		(ndev->mtu <= XAE_JUMBO_MTU)) {
+	    (ndev->mtu <= XAE_JUMBO_MTU)) {
 		lp->max_frm_size = ndev->mtu + VLAN_ETH_HLEN +
 					XAE_TRL_SIZE;
 
-- 
2.30.0

