Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A3F5062B7
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 05:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348061AbiDSDfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 23:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347776AbiDSDfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 23:35:41 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552632BB2E;
        Mon, 18 Apr 2022 20:32:57 -0700 (PDT)
Received: from kwepemi500003.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Kj8Wk5xsGzdZlJ;
        Tue, 19 Apr 2022 11:32:50 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500003.china.huawei.com (7.221.188.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 11:32:55 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 11:32:55 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH V2 net-next 9/9] net: hns3: remove unnecessary line wrap for hns3_set_tunable
Date:   Tue, 19 Apr 2022 11:27:09 +0800
Message-ID: <20220419032709.15408-10-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220419032709.15408-1-huangguangbin2@huawei.com>
References: <20220419032709.15408-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
index 73498e125492..bb001f597857 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1202,8 +1202,7 @@ static int hns3_set_ringparam(struct net_device *ndev,
 
 	tmp_rings = hns3_backup_ringparam(priv);
 	if (!tmp_rings) {
-		netdev_err(ndev,
-			   "backup ring param failed by allocating memory fail\n");
+		netdev_err(ndev, "backup ring param failed by allocating memory fail\n");
 		return -ENOMEM;
 	}
 
@@ -1905,13 +1904,11 @@ static int hns3_set_tunable(struct net_device *netdev,
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

