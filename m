Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B532A50359D
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 11:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbiDPJWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 05:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiDPJWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 05:22:01 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1F749F2D;
        Sat, 16 Apr 2022 02:19:30 -0700 (PDT)
Received: from kwepemi500014.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KgSLJ72yCz1HBtM;
        Sat, 16 Apr 2022 17:18:48 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500014.china.huawei.com (7.221.188.232) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Apr 2022 17:19:28 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Apr 2022 17:19:28 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 9/9] net: hns3: remove unnecessary line wrap for hns3_set_tunable
Date:   Sat, 16 Apr 2022 17:13:43 +0800
Message-ID: <20220416091343.35817-10-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220416091343.35817-1-huangguangbin2@huawei.com>
References: <20220416091343.35817-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Remove unnecessary line wrap for hns3_set_tunable to improve
function readability.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 51ee8adab6a3..1e641083bd60 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1172,8 +1172,7 @@ static int hns3_set_ringparam(struct net_device *ndev,
 
 	tmp_rings = hns3_backup_ringparam(priv);
 	if (!tmp_rings) {
-		netdev_err(ndev,
-			   "backup ring param failed by allocating memory fail\n");
+		netdev_err(ndev, "backup ring param failed by allocating memory fail\n");
 		return -ENOMEM;
 	}
 
@@ -1875,13 +1874,11 @@ static int hns3_set_tunable(struct net_device *netdev,
 		    (!priv->ring->tx_spare && new_tx_spare_buf_size != 0)) {
 			int ret1;
 
-			netdev_warn(netdev,
-				    "change tx spare buf size fail, revert to old value\n");
+			netdev_warn(netdev, "change tx spare buf size fail, revert to old value\n");
 			ret1 = hns3_set_tx_spare_buf_size(netdev,
 							  old_tx_spare_buf_size);
 			if (ret1) {
-				netdev_err(netdev,
-					   "revert to old tx spare buf size fail\n");
+				netdev_err(netdev, "revert to old tx spare buf size fail\n");
 				return ret1;
 			}
 
-- 
2.33.0

