Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2985C5AFC62
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 08:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiIGG3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 02:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiIGG27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 02:28:59 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903139C2F1;
        Tue,  6 Sep 2022 23:28:57 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MMshs0DDzznVR3;
        Wed,  7 Sep 2022 14:26:21 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 7 Sep 2022 14:28:54 +0800
Received: from localhost.localdomain (10.67.165.2) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 7 Sep 2022 14:28:54 +0800
From:   Haoyue Xu <xuhaoyue1@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xuhaoyue1@hisilicon.com>, <pabeni@redhat.com>,
        <edumazet@google.com>, <huangdaode@huawei.com>,
        <liangwenpeng@huawei.com>, <liyangyang20@huawei.com>
Subject: [PATCH net-next 2/3] net: amd: Correct spelling errors
Date:   Wed, 7 Sep 2022 14:28:11 +0800
Message-ID: <20220907062812.2259309-3-xuhaoyue1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20220907062812.2259309-1-xuhaoyue1@hisilicon.com>
References: <20220907062812.2259309-1-xuhaoyue1@hisilicon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guofeng Yue <yueguofeng@hisilicon.com>

Find some spelling errors:

	interupts --> interrupts
	lenth --> length
	stoped --> stopped
	contoller --> controller

Signed-off-by: Guofeng Yue <yueguofeng@hisilicon.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
---
 drivers/net/ethernet/amd/amd8111e.c | 6 +++---
 drivers/net/ethernet/amd/amd8111e.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index aaa527dc1b6f..7b4d9bbb079c 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -43,7 +43,7 @@ Revision History:
 	3.0.4 12/09/2003
 	 1. Added set_mac_address routine for bonding driver support.
 	 2. Tested the driver for bonding support
-	 3. Bug fix: Fixed mismach in actual receive buffer lenth and lenth
+	 3. Bug fix: Fixed mismach in actual receive buffer length and length
 	    indicated to the h/w.
 	 4. Modified amd8111e_rx() routine to receive all the received packets
 	    in the first interrupt.
@@ -1109,7 +1109,7 @@ static irqreturn_t amd8111e_interrupt(int irq, void *dev_id)
 	/* Check if Receive Interrupt has occurred. */
 	if (intr0 & RINT0) {
 		if (napi_schedule_prep(&lp->napi)) {
-			/* Disable receive interupts */
+			/* Disable receive interrupts */
 			writel(RINTEN0, mmio + INTEN0);
 			/* Schedule a polling routine */
 			__napi_schedule(&lp->napi);
@@ -1554,7 +1554,7 @@ static int amd8111e_enable_magicpkt(struct amd8111e_priv *lp)
 static int amd8111e_enable_link_change(struct amd8111e_priv *lp)
 {
 
-	/* Adapter is already stoped/suspended/interrupt-disabled */
+	/* Adapter is already stopped/suspended/interrupt-disabled */
 	writel(VAL0 | LCMODE_SW, lp->mmio + CMD7);
 
 	/* To eliminate PCI posting bug */
diff --git a/drivers/net/ethernet/amd/amd8111e.h b/drivers/net/ethernet/amd/amd8111e.h
index 37da79da5f5e..9d570adb295b 100644
--- a/drivers/net/ethernet/amd/amd8111e.h
+++ b/drivers/net/ethernet/amd/amd8111e.h
@@ -600,7 +600,7 @@ typedef enum {
 #define CSTATE  1
 #define SSTATE  2
 
-/* Assume contoller gets data 10 times the maximum processing time */
+/* Assume controller gets data 10 times the maximum processing time */
 #define  REPEAT_CNT			10
 
 /* amd8111e descriptor flag definitions */
-- 
2.30.0

