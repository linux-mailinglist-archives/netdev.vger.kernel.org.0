Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B5CFDCBB
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 12:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfKOLyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 06:54:37 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:35540 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726983AbfKOLyh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 06:54:37 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B8A7DB655DC9F9B2E37C;
        Fri, 15 Nov 2019 19:54:34 +0800 (CST)
Received: from A190218597.china.huawei.com (10.202.226.45) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Fri, 15 Nov 2019 19:54:26 +0800
From:   Salil Mehta <salil.mehta@huawei.com>
To:     <davem@davemloft.net>
CC:     <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <lipeng321@huawei.com>, <mehta.salil@opnsrc.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH net] net: hns3: cleanup of stray struct hns3_link_mode_mapping
Date:   Fri, 15 Nov 2019 11:52:32 +0000
Message-ID: <20191115115232.18600-1-salil.mehta@huawei.com>
X-Mailer: git-send-email 2.8.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.226.45]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch cleans-up the stray left over code. It has no
functionality impact.

Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 680c3508876d..52c9d204fe3d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -70,11 +70,6 @@ static const struct hns3_stats hns3_rxq_stats[] = {
 #define HNS3_NIC_LB_TEST_TX_CNT_ERR	2
 #define HNS3_NIC_LB_TEST_RX_CNT_ERR	3
 
-struct hns3_link_mode_mapping {
-	u32 hns3_link_mode;
-	u32 ethtool_link_mode;
-};
-
 static int hns3_lp_setup(struct net_device *ndev, enum hnae3_loop loop, bool en)
 {
 	struct hnae3_handle *h = hns3_get_handle(ndev);
-- 
2.17.1


