Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F04D3974DE
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbhFAOEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:04:42 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3495 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbhFAOEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:04:40 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FvYhF1hqbzYs4B;
        Tue,  1 Jun 2021 22:00:13 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 22:02:55 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <dsahern@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] vrf: Fix a typo
Date:   Tue, 1 Jun 2021 22:16:35 +0800
Message-ID: <20210601141635.4131513-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

possibile  ==> possible

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/vrf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 503e2fd7ce51..07eaef5e73c2 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -274,7 +274,7 @@ vrf_map_register_dev(struct net_device *dev, struct netlink_ext_ack *extack)
 	int res;
 
 	/* we pre-allocate elements used in the spin-locked section (so that we
-	 * keep the spinlock as short as possibile).
+	 * keep the spinlock as short as possible).
 	 */
 	new_me = vrf_map_elem_alloc(GFP_KERNEL);
 	if (!new_me)
-- 
2.25.1

