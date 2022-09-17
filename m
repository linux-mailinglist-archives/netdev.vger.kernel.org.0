Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597325BB7DA
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 12:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiIQKj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 06:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIQKjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 06:39:32 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D287C52;
        Sat, 17 Sep 2022 03:39:30 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MV6lv0YLqzmV8l;
        Sat, 17 Sep 2022 18:35:39 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 17 Sep 2022 18:39:28 +0800
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
Subject: [PATCH net-next 2/7] net: ll_temac: Cleanup for function name in a string
Date:   Sat, 17 Sep 2022 18:38:38 +0800
Message-ID: <20220917103843.526877-3-xuhaoyue1@hisilicon.com>
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

As Checkpatch.pl warns, prefer using '"%s...", __func__'
to using 'temac_device_reset', this function's name, in a string.

Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 1dfbd85b848d..26fbe60e2cf4 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -642,7 +642,7 @@ static void temac_device_reset(struct net_device *ndev)
 		udelay(1);
 		if (--timeout == 0) {
 			dev_err(&ndev->dev,
-				"temac_device_reset RX reset timeout!!\n");
+				"%s RX reset timeout!!\n", __func__);
 			break;
 		}
 	}
@@ -654,7 +654,7 @@ static void temac_device_reset(struct net_device *ndev)
 		udelay(1);
 		if (--timeout == 0) {
 			dev_err(&ndev->dev,
-				"temac_device_reset TX reset timeout!!\n");
+				"%s TX reset timeout!!\n", __func__);
 			break;
 		}
 	}
@@ -673,7 +673,7 @@ static void temac_device_reset(struct net_device *ndev)
 		udelay(1);
 		if (--timeout == 0) {
 			dev_err(&ndev->dev,
-				"temac_device_reset DMA reset timeout!!\n");
+				"%s DMA reset timeout!!\n", __func__);
 			break;
 		}
 	}
@@ -681,7 +681,8 @@ static void temac_device_reset(struct net_device *ndev)
 
 	if (temac_dma_bd_init(ndev)) {
 		dev_err(&ndev->dev,
-				"temac_device_reset descriptor allocation failed\n");
+			"%s descriptor allocation failed\n", __func__);
+
 	}
 
 	spin_lock_irqsave(lp->indirect_lock, flags);
-- 
2.30.0

