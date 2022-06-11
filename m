Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62A9547488
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 14:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbiFKMby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 08:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiFKMbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 08:31:49 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD42D656E;
        Sat, 11 Jun 2022 05:31:46 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LKxyf4Z4PzDqpN;
        Sat, 11 Jun 2022 20:31:22 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 11 Jun 2022 20:31:44 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 11 Jun 2022 20:31:44 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 3/6] net: hns3: modify the ring param print info
Date:   Sat, 11 Jun 2022 20:25:26 +0800
Message-ID: <20220611122529.18571-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220611122529.18571-1-huangguangbin2@huawei.com>
References: <20220611122529.18571-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently tx push is also a ring param. So the original ring param print
info in hns3_is_ringparam_changed should be adjusted.

Fixes: 07fdc163ac88 ("net: hns3: refactor hns3_set_ringparam()")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 6d20974519fe..4c7988e308a2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1129,7 +1129,7 @@ hns3_is_ringparam_changed(struct net_device *ndev,
 	if (old_ringparam->tx_desc_num == new_ringparam->tx_desc_num &&
 	    old_ringparam->rx_desc_num == new_ringparam->rx_desc_num &&
 	    old_ringparam->rx_buf_len == new_ringparam->rx_buf_len) {
-		netdev_info(ndev, "ringparam not changed\n");
+		netdev_info(ndev, "descriptor number and rx buffer length not changed\n");
 		return false;
 	}
 
-- 
2.33.0

