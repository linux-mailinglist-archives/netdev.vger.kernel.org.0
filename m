Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C97B41C948
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346203AbhI2QDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:03:42 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12982 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343509AbhI2QAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:01 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbZ632qzWYTn;
        Wed, 29 Sep 2021 23:56:58 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:18 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:18 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 149/167] net: ethoc: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:53:16 +0800
Message-ID: <20210929155334.12454-150-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/ethoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index 0064ebdaf4b4..0bca71d3ebf0 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -1215,7 +1215,7 @@ static int ethoc_probe(struct platform_device *pdev)
 	/* setup the net_device structure */
 	netdev->netdev_ops = &ethoc_netdev_ops;
 	netdev->watchdog_timeo = ETHOC_TIMEOUT;
-	netdev->features |= 0;
+	netdev_feature_set_bits(0, &netdev->features);
 	netdev->ethtool_ops = &ethoc_ethtool_ops;
 
 	/* setup NAPI */
-- 
2.33.0

