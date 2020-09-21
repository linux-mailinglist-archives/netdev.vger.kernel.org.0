Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9B42724C6
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgIUNLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:11:15 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13811 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727477AbgIUNLC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 09:11:02 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 24ADA27BFA3DD12BA083;
        Mon, 21 Sep 2020 21:10:59 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 21:10:50 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH -next] zd1201: simplify the return expression of zd1201_set_maxassoc()
Date:   Mon, 21 Sep 2020 21:11:15 +0800
Message-ID: <20200921131115.93504-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/net/wireless/zydas/zd1201.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/zydas/zd1201.c b/drivers/net/wireless/zydas/zd1201.c
index 41641fc2b..718c4ee86 100644
--- a/drivers/net/wireless/zydas/zd1201.c
+++ b/drivers/net/wireless/zydas/zd1201.c
@@ -1652,15 +1652,11 @@ static int zd1201_set_maxassoc(struct net_device *dev,
     struct iw_request_info *info, struct iw_param *rrq, char *extra)
 {
 	struct zd1201 *zd = netdev_priv(dev);
-	int err;
 
 	if (!zd->ap)
 		return -EOPNOTSUPP;
 
-	err = zd1201_setconfig16(zd, ZD1201_RID_CNFMAXASSOCSTATIONS, rrq->value);
-	if (err)
-		return err;
-	return 0;
+	return zd1201_setconfig16(zd, ZD1201_RID_CNFMAXASSOCSTATIONS, rrq->value);
 }
 
 static int zd1201_get_maxassoc(struct net_device *dev,
-- 
2.23.0

