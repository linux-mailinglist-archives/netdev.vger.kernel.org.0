Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBC12D5C58
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 14:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgLJNvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 08:51:31 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9493 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389641AbgLJNvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 08:51:15 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CsFfH6cyKzhpxK;
        Thu, 10 Dec 2020 21:49:59 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Dec 2020 21:50:22 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nbd@nbd.name>, <john@phrozen.org>, <sean.wang@mediatek.com>,
        <Mark-MC.Lee@mediatek.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: mediatek: simplify the return expression of mtk_gmac_sgmii_path_setup()
Date:   Thu, 10 Dec 2020 21:50:50 +0800
Message-ID: <20201210135050.1076-1-zhengyongjun3@huawei.com>
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
 drivers/net/ethernet/mediatek/mtk_eth_path.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_path.c b/drivers/net/ethernet/mediatek/mtk_eth_path.c
index 0fe97155dd8f..6bc9f2487384 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_path.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_path.c
@@ -241,17 +241,13 @@ static int mtk_eth_mux_setup(struct mtk_eth *eth, int path)
 
 int mtk_gmac_sgmii_path_setup(struct mtk_eth *eth, int mac_id)
 {
-	int err, path;
+	int path;
 
 	path = (mac_id == 0) ?  MTK_ETH_PATH_GMAC1_SGMII :
 				MTK_ETH_PATH_GMAC2_SGMII;
 
 	/* Setup proper MUXes along the path */
-	err = mtk_eth_mux_setup(eth, path);
-	if (err)
-		return err;
-
-	return 0;
+	return mtk_eth_mux_setup(eth, path);
 }
 
 int mtk_gmac_gephy_path_setup(struct mtk_eth *eth, int mac_id)
-- 
2.22.0

