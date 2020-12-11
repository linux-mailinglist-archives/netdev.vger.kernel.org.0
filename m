Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F028A2D71EF
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 09:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391451AbgLKIi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 03:38:59 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9427 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388615AbgLKIi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 03:38:26 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Cskg1144NzhqZS;
        Fri, 11 Dec 2020 16:37:17 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Fri, 11 Dec 2020 16:37:32 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sagis@google.com>, <jonolson@google.com>, <nbd@nbd.name>,
        <john@phrozen.org>, <sean.wang@mediatek.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net/mediatek: simplify the mediatek code return expression
Date:   Fri, 11 Dec 2020 16:38:01 +0800
Message-ID: <20201211083801.1632-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression at mtk_eth_path.c file, simplify this all.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_path.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_path.c b/drivers/net/ethernet/mediatek/mtk_eth_path.c
index 6bc9f2487384..72648535a14d 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_path.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_path.c
@@ -252,7 +252,7 @@ int mtk_gmac_sgmii_path_setup(struct mtk_eth *eth, int mac_id)
 
 int mtk_gmac_gephy_path_setup(struct mtk_eth *eth, int mac_id)
 {
-	int err, path = 0;
+	int path = 0;
 
 	if (mac_id == 1)
 		path = MTK_ETH_PATH_GMAC2_GEPHY;
@@ -261,25 +261,17 @@ int mtk_gmac_gephy_path_setup(struct mtk_eth *eth, int mac_id)
 		return -EINVAL;
 
 	/* Setup proper MUXes along the path */
-	err = mtk_eth_mux_setup(eth, path);
-	if (err)
-		return err;
-
-	return 0;
+	return mtk_eth_mux_setup(eth, path);
 }
 
 int mtk_gmac_rgmii_path_setup(struct mtk_eth *eth, int mac_id)
 {
-	int err, path;
+	int path;
 
 	path = (mac_id == 0) ?  MTK_ETH_PATH_GMAC1_RGMII :
 				MTK_ETH_PATH_GMAC2_RGMII;
 
 	/* Setup proper MUXes along the path */
-	err = mtk_eth_mux_setup(eth, path);
-	if (err)
-		return err;
-
-	return 0;
+	return mtk_eth_mux_setup(eth, path);
 }
 
-- 
2.22.0

