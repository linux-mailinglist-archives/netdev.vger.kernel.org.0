Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E39E5BB7DD
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 12:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiIQKj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 06:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiIQKjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 06:39:43 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D1DF5B;
        Sat, 17 Sep 2022 03:39:32 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MV6nB4LSjzpSvF;
        Sat, 17 Sep 2022 18:36:46 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 17 Sep 2022 18:39:31 +0800
Received: from localhost.localdomain (10.67.165.2) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 17 Sep 2022 18:39:30 +0800
From:   Haoyue Xu <xuhaoyue1@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.simek@xilinx.com>
CC:     <huangdaode@huawei.com>, <liyangyang20@huawei.com>,
        <xuhaoyue1@hisilicon.com>, <huangjunxian6@hisilicon.com>,
        <linuxarm@huawei.com>, <liangwenpeng@huawei.com>
Subject: [PATCH net-next 7/7] net: ll_temac: axienet: delete unnecessary blank lines and spaces
Date:   Sat, 17 Sep 2022 18:38:43 +0800
Message-ID: <20220917103843.526877-8-xuhaoyue1@hisilicon.com>
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

Cleaning some static warnings of indent.

Signed-off-by: huangjunxian <huangjunxian6@hisilicon.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c       | 1 -
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ++--
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 244070f0cd2a..a74e8872a71e 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1013,7 +1013,6 @@ static void ll_temac_recv(struct net_device *ndev)
 		if (((lp->temac_features & TEMAC_FEATURE_RX_CSUM) != 0) &&
 		    (skb->protocol == htons(ETH_P_IP)) &&
 		    (skb->len > 64)) {
-
 			/* Convert from device endianness (be32) to cpu
 			 * endianness, and if necessary swap the bytes
 			 * (back) for proper IP checksum byte order
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 15d1c8158f31..40581f40716a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -645,7 +645,7 @@ static int axienet_device_reset(struct net_device *ndev)
  * @nr_bds:	Max number of descriptors to clean up
  * @force:	Whether to clean descriptors even if not complete
  * @sizep:	Pointer to a u32 filled with the total sum of all bytes
- * 		in all cleaned-up descriptors. Ignored if NULL.
+ *		in all cleaned-up descriptors. Ignored if NULL.
  * @budget:	NAPI budget (use 0 when not called from NAPI poll)
  *
  * Would either be called after a successful transmit operation, or after
@@ -1375,7 +1375,7 @@ static int axienet_ethtools_get_regs_len(struct net_device *ndev)
 static void axienet_ethtools_get_regs(struct net_device *ndev,
 				      struct ethtool_regs *regs, void *ret)
 {
-	u32 *data = (u32 *) ret;
+	u32 *data = (u32 *)ret;
 	size_t len = sizeof(u32) * AXIENET_REGS_N;
 	struct axienet_local *lp = netdev_priv(ndev);
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 2772a79cd3ed..0b3b6935c558 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -126,7 +126,7 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
 		return ret;
 	}
 
-	axienet_iow(lp, XAE_MDIO_MWD_OFFSET, (u32) val);
+	axienet_iow(lp, XAE_MDIO_MWD_OFFSET, (u32)val);
 	axienet_iow(lp, XAE_MDIO_MCR_OFFSET,
 		    (((phy_id << XAE_MDIO_MCR_PHYAD_SHIFT) &
 		      XAE_MDIO_MCR_PHYAD_MASK) |
-- 
2.30.0

