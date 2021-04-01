Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CB73512A7
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 11:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhDAJpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 05:45:39 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:15847 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbhDAJp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 05:45:26 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F9yRW6tbcz93Zs;
        Thu,  1 Apr 2021 17:23:51 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.498.0; Thu, 1 Apr 2021
 17:25:52 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <trix@redhat.com>,
        <jesse.brandeburg@intel.com>, <wanghai38@huawei.com>,
        <dinghao.liu@zju.edu.cn>, <baijiaju1990@gmail.com>,
        <song.bao.hua@hisilicon.com>, <tariqt@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: hns: Fix some typos
Date:   Thu, 1 Apr 2021 17:27:01 +0800
Message-ID: <20210401092701.281820-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some typos.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index c66a7a51198e..5c61e5821d5c 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1235,7 +1235,7 @@ static int hns_nic_init_affinity_mask(int q_num, int ring_idx,
 {
 	int cpu;
 
-	/* Diffrent irq banlance between 16core and 32core.
+	/* Different irq balance between 16core and 32core.
 	 * The cpu mask set by ring index according to the ring flag
 	 * which indicate the ring is tx or rx.
 	 */
@@ -1592,7 +1592,7 @@ static void hns_disable_serdes_lb(struct net_device *ndev)
  *       which buffer size is 4096.
  *    2. we set the chip serdes loopback and set rss indirection to the ring.
  *    3. construct 64-bytes ip broadcast packages, wait the associated rx ring
- *       recieving all packages and it will fetch new descriptions.
+ *       receiving all packages and it will fetch new descriptions.
  *    4. recover to the original state.
  *
  *@ndev: net device
@@ -1621,7 +1621,7 @@ static int hns_nic_clear_all_rx_fetch(struct net_device *ndev)
 	if (!org_indir)
 		return -ENOMEM;
 
-	/* store the orginal indirection */
+	/* store the original indirection */
 	ops->get_rss(h, org_indir, NULL, NULL);
 
 	cur_indir = kzalloc(indir_size, GFP_KERNEL);
-- 
2.17.1

