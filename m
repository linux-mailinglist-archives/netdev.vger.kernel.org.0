Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800D0265054
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgIJULq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:11:46 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57162 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731104AbgIJO7X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:59:23 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BE9B23FBCEBC2E6F4CDE;
        Thu, 10 Sep 2020 22:59:18 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 22:59:09 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <snelson@pensando.io>,
        <colin.king@canonical.com>, <maz@kernel.org>, <luobin9@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 4/6] net: hns: Fix some kernel-doc warnings in hns_enet.c
Date:   Thu, 10 Sep 2020 22:56:18 +0800
Message-ID: <20200910145620.27470-5-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910145620.27470-1-wanghai38@huawei.com>
References: <20200910145620.27470-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

drivers/net/ethernet/hisilicon/hns/hns_enet.c:1841: warning: Excess function parameter 'netdev' description in 'hns_set_multicast_list'
drivers/net/ethernet/hisilicon/hns/hns_enet.c:1841: warning: Excess function parameter 'p' description in 'hns_set_multicast_list'

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index b13f3a5cdf59..b658b9de81d7 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1829,8 +1829,7 @@ static int hns_nic_uc_unsync(struct net_device *netdev,
 
 /**
  * nic_set_multicast_list - set mutl mac address
- * @netdev: net device
- * @p: mac address
+ * @ndev: net device
  *
  * return void
  */
-- 
2.17.1

