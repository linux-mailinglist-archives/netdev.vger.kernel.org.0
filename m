Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F005A4B86CE
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 12:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbiBPLfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 06:35:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbiBPLfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 06:35:30 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693F19F6D7;
        Wed, 16 Feb 2022 03:35:17 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JzG751cf8z9scb;
        Wed, 16 Feb 2022 19:33:37 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 16 Feb
 2022 19:35:14 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: hns3: Remove unused inline function hclge_is_reset_pending()
Date:   Wed, 16 Feb 2022 19:35:07 +0800
Message-ID: <20220216113507.22368-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is unused since commit 8e2288cad6cb ("net: hns3: refactor PF
cmdq init and uninit APIs with new common APIs").

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index adfb26e79262..3c5e76eaf90b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1060,11 +1060,6 @@ static inline int hclge_get_queue_id(struct hnae3_queue *queue)
 	return tqp->index;
 }
 
-static inline bool hclge_is_reset_pending(struct hclge_dev *hdev)
-{
-	return !!hdev->reset_pending;
-}
-
 int hclge_inform_reset_assert_to_vf(struct hclge_vport *vport);
 int hclge_cfg_mac_speed_dup(struct hclge_dev *hdev, int speed, u8 duplex);
 int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
-- 
2.17.1

