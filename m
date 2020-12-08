Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B21A2D2C42
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 14:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgLHNyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 08:54:18 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9555 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbgLHNyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 08:54:17 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cr1pZ2djPzM1L7;
        Tue,  8 Dec 2020 21:52:54 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Dec 2020 21:53:27 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <drivers@pensando.io>, <davem@davemloft.net>, <kuba@kernel.org>,
        <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] drivers: net: ionic: simplify the return expression of ionic_set_rxfh()
Date:   Tue, 8 Dec 2020 21:53:53 +0800
Message-ID: <20201208135353.11708-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 35c72d4a78b3..0832bedcb3b4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -738,16 +738,11 @@ static int ionic_set_rxfh(struct net_device *netdev, const u32 *indir,
 			  const u8 *key, const u8 hfunc)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
-	int err;
 
 	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
 		return -EOPNOTSUPP;
 
-	err = ionic_lif_rss_config(lif, lif->rss_types, key, indir);
-	if (err)
-		return err;
-
-	return 0;
+	return ionic_lif_rss_config(lif, lif->rss_types, key, indir);
 }
 
 static int ionic_set_tunable(struct net_device *dev,
-- 
2.22.0

