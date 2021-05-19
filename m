Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948953886C3
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 07:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239602AbhESFjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 01:39:40 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3593 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242806AbhESFgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 01:36:03 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FlM1f6BZQzsRGb;
        Wed, 19 May 2021 13:31:50 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:36 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:35 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH 08/20] net: dlink: remove leading spaces before tabs
Date:   Wed, 19 May 2021 13:30:41 +0800
Message-ID: <1621402253-27200-9-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
References: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running the
following commard:

	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
	$ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'
Cc: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/ethernet/dlink/sundance.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet/dlink/sundance.c
index ce61f79f..ee0ca71 100644
--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -1847,20 +1847,20 @@ static int netdev_close(struct net_device *dev)
 	/* Stop the chip's Tx and Rx processes. */
 	iowrite16(TxDisable | RxDisable | StatsDisable, ioaddr + MACCtrl1);
 
-    	for (i = 2000; i > 0; i--) {
- 		if ((ioread32(ioaddr + DMACtrl) & 0xc000) == 0)
+	for (i = 2000; i > 0; i--) {
+		if ((ioread32(ioaddr + DMACtrl) & 0xc000) == 0)
 			break;
 		mdelay(1);
-    	}
+	}
 
-    	iowrite16(GlobalReset | DMAReset | FIFOReset | NetworkReset,
+	iowrite16(GlobalReset | DMAReset | FIFOReset | NetworkReset,
 			ioaddr + ASIC_HI_WORD(ASICCtrl));
 
-    	for (i = 2000; i > 0; i--) {
+	for (i = 2000; i > 0; i--) {
 		if ((ioread16(ioaddr + ASIC_HI_WORD(ASICCtrl)) & ResetBusy) == 0)
 			break;
 		mdelay(1);
-    	}
+	}
 
 #ifdef __i386__
 	if (netif_msg_hw(np)) {
-- 
2.8.1

