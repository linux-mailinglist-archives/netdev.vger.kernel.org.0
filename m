Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53DC56A479
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 15:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbiGGNsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 09:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236145AbiGGNs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 09:48:29 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903A31022;
        Thu,  7 Jul 2022 06:48:27 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LdyPs15xgzkX62;
        Thu,  7 Jul 2022 21:46:57 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 7 Jul 2022 21:48:25 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 7 Jul
 2022 21:48:25 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH -next] bcm63xx_enet: change the driver variables to static
Date:   Thu, 7 Jul 2022 21:58:01 +0800
Message-ID: <20220707135801.1483941-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bcm63xx_enetsw_driver and bcm63xx_enet_driver are only used in
bcm63xx_enet.c now, change them to static.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 514d61dd91c7..fcaa6a2d067f 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1935,7 +1935,7 @@ static int bcm_enet_remove(struct platform_device *pdev)
 	return 0;
 }
 
-struct platform_driver bcm63xx_enet_driver = {
+static struct platform_driver bcm63xx_enet_driver = {
 	.probe	= bcm_enet_probe,
 	.remove	= bcm_enet_remove,
 	.driver	= {
@@ -2756,7 +2756,7 @@ static int bcm_enetsw_remove(struct platform_device *pdev)
 	return 0;
 }
 
-struct platform_driver bcm63xx_enetsw_driver = {
+static struct platform_driver bcm63xx_enetsw_driver = {
 	.probe	= bcm_enetsw_probe,
 	.remove	= bcm_enetsw_remove,
 	.driver	= {
-- 
2.25.1

