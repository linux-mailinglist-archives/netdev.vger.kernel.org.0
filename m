Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1B2626810
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 09:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbiKLIRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 03:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234810AbiKLIR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 03:17:29 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6555313F17
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 00:17:28 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N8T2K1xMzzRp68;
        Sat, 12 Nov 2022 16:17:13 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 12 Nov 2022 16:17:26 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 12 Nov 2022 16:17:26 +0800
From:   Hao Lan <lanhao@huawei.com>
To:     <lanhao@huawei.com>, <lipeng321@huawei.com>,
        <shenjian15@huawei.com>, <linyunsheng@huawei.com>,
        <liuyonglong@huawei.com>, <chenhao418@huawei.com>,
        <wangjie125@huawei.com>, <huangguangbin2@huawei.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <xiaojiantao1@h-partners.com>
Subject: [PATCH net-next 2/2] net: hns3: add complete parentheses for some macros
Date:   Sat, 12 Nov 2022 16:17:49 +0800
Message-ID: <20221112081749.56229-3-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20221112081749.56229-1-lanhao@huawei.com>
References: <20221112081749.56229-1-lanhao@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiantao Xiao <xiaojiantao1@h-partners.com>

Add complete parentheses for some macros to fix static check
warning.

Signed-off-by: Jiantao Xiao <xiaojiantao1@h-partners.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 557a5fa70d0a..7df4cf656d22 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -692,7 +692,7 @@ static inline unsigned int hns3_page_order(struct hns3_enet_ring *ring)
 
 /* iterator for handling rings in ring group */
 #define hns3_for_each_ring(pos, head) \
-	for (pos = (head).ring; (pos); pos = (pos)->next)
+	for ((pos) = (head).ring; (pos); (pos) = (pos)->next)
 
 #define hns3_get_handle(ndev) \
 	(((struct hns3_nic_priv *)netdev_priv(ndev))->ae_handle)
-- 
2.30.0

