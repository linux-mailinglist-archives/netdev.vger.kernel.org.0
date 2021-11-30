Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7EA463239
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbhK3LZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:25:05 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:27319 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238912AbhK3LZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:25:00 -0500
Received: from dggeml709-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J3KY86p7rzbjBB;
        Tue, 30 Nov 2021 19:21:32 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 dggeml709-chm.china.huawei.com (10.3.17.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Tue, 30 Nov 2021 19:21:39 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>,
        liaoguojia <liaoguojia@huawei.com>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net: hns3: make symbol 'hclge_mac_speed_map_to_fw' static
Date:   Tue, 30 Nov 2021 11:34:37 +0000
Message-ID: <20211130113437.1770221-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeml709-chm.china.huawei.com (10.3.17.139)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sparse tool complains as follows:

drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c:2656:28: warning:
 symbol 'hclge_mac_speed_map_to_fw' was not declared. Should it be static?

This symbol is not used outside of hclge_main.c, so marks it static.

Fixes: e46da6a3d4d3 ("net: hns3: refine function hclge_cfg_mac_speed_dup_hw()")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7de4c56ef014..1815fcf168b0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2653,7 +2653,7 @@ static u8 hclge_check_speed_dup(u8 duplex, int speed)
 	return duplex;
 }
 
-struct hclge_mac_speed_map hclge_mac_speed_map_to_fw[] = {
+static struct hclge_mac_speed_map hclge_mac_speed_map_to_fw[] = {
 	{HCLGE_MAC_SPEED_10M, HCLGE_FW_MAC_SPEED_10M},
 	{HCLGE_MAC_SPEED_100M, HCLGE_FW_MAC_SPEED_100M},
 	{HCLGE_MAC_SPEED_1G, HCLGE_FW_MAC_SPEED_1G},

