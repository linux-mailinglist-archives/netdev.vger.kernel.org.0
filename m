Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC0943C95F
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 14:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241844AbhJ0MSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 08:18:43 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14870 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241810AbhJ0MSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 08:18:40 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HfSMr32hGz90MJ;
        Wed, 27 Oct 2021 20:16:08 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 27 Oct 2021 20:16:11 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 27 Oct 2021 20:16:11 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 5/7] net: hns3: add more string spaces for dumping packets number of queue info in debugfs
Date:   Wed, 27 Oct 2021 20:11:47 +0800
Message-ID: <20211027121149.45897-6-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211027121149.45897-1-huangguangbin2@huawei.com>
References: <20211027121149.45897-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

As the width of packets number registers is 32 bits, they needs at most
10 characters for decimal data printing, but now the string spaces is not
enough, so this patch fixes it.

Fixes: e44c495d95e ("net: hns3: refactor queue info of debugfs")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 2b66c59f5eaf..3aaad96d0176 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -462,7 +462,7 @@ static const struct hns3_dbg_item rx_queue_info_items[] = {
 	{ "TAIL", 2 },
 	{ "HEAD", 2 },
 	{ "FBDNUM", 2 },
-	{ "PKTNUM", 2 },
+	{ "PKTNUM", 5 },
 	{ "COPYBREAK", 2 },
 	{ "RING_EN", 2 },
 	{ "RX_RING_EN", 2 },
@@ -565,7 +565,7 @@ static const struct hns3_dbg_item tx_queue_info_items[] = {
 	{ "HEAD", 2 },
 	{ "FBDNUM", 2 },
 	{ "OFFSET", 2 },
-	{ "PKTNUM", 2 },
+	{ "PKTNUM", 5 },
 	{ "RING_EN", 2 },
 	{ "TX_RING_EN", 2 },
 	{ "BASE_ADDR", 10 },
-- 
2.33.0

