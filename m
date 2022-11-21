Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1820B631D09
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiKUJlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiKUJlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:41:44 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA454920B2;
        Mon, 21 Nov 2022 01:41:43 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NG2T53wvgz15Mmv;
        Mon, 21 Nov 2022 17:41:13 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 21 Nov
 2022 17:41:41 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <s.shtylyov@omp.ru>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <yoshihiro.shimoda.uh@renesas.com>
CC:     <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: ethernet: renesas: Add missing slash in rswitch_init
Date:   Mon, 21 Nov 2022 17:41:38 +0800
Message-ID: <20221121094138.21028-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix smatch warning:

drivers/net/ethernet/renesas/rswitch.c:1717
 rswitch_init() warn: '%pM' cannot be followed by 'n'

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index c098b27093ea..e42ceaa0099f 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1714,7 +1714,7 @@ static int rswitch_init(struct rswitch_private *priv)
 	}
 
 	for (i = 0; i < RSWITCH_NUM_PORTS; i++)
-		netdev_info(priv->rdev[i]->ndev, "MAC address %pMn",
+		netdev_info(priv->rdev[i]->ndev, "MAC address %pM\n",
 			    priv->rdev[i]->ndev->dev_addr);
 
 	return 0;
-- 
2.20.1

