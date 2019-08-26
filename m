Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363C79C757
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 04:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbfHZCpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 22:45:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5655 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729263AbfHZCpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Aug 2019 22:45:51 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A42AA55E33B4801E62BB;
        Mon, 26 Aug 2019 10:45:48 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Mon, 26 Aug 2019 10:45:38 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     "David S . Miller" <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH v2 net-next] cirrus: cs89x0: remove set but not used variable 'lp'
Date:   Mon, 26 Aug 2019 02:49:15 +0000
Message-ID: <20190826024915.67642-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822063517.71231-1-yuehaibing@huawei.com>
References: <20190822063517.71231-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/cirrus/cs89x0.c: In function 'cs89x0_platform_probe':
drivers/net/ethernet/cirrus/cs89x0.c:1847:20: warning:
 variable 'lp' set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 6751edeb8700 ("cirrus: cs89x0: Use managed interfaces")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: add Fixes tag
---
 drivers/net/ethernet/cirrus/cs89x0.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/cirrus/cs89x0.c b/drivers/net/ethernet/cirrus/cs89x0.c
index 2d30972df06b..c9aebcde403a 100644
--- a/drivers/net/ethernet/cirrus/cs89x0.c
+++ b/drivers/net/ethernet/cirrus/cs89x0.c
@@ -1844,15 +1844,12 @@ cleanup_module(void)
 static int __init cs89x0_platform_probe(struct platform_device *pdev)
 {
 	struct net_device *dev = alloc_etherdev(sizeof(struct net_local));
-	struct net_local *lp;
 	void __iomem *virt_addr;
 	int err;
 
 	if (!dev)
 		return -ENOMEM;
 
-	lp = netdev_priv(dev);
-
 	dev->irq = platform_get_irq(pdev, 0);
 	if (dev->irq <= 0) {
 		dev_warn(&dev->dev, "interrupt resource missing\n");



