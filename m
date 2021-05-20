Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F948389DA2
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 08:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhETGW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 02:22:59 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3439 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhETGW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 02:22:56 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fm01L0n61zCs8H;
        Thu, 20 May 2021 14:18:46 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 14:21:33 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 20 May 2021 14:21:32 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/4] net: bonding: fix code indent for conditional statements
Date:   Thu, 20 May 2021 14:18:33 +0800
Message-ID: <1621491515-53459-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621491515-53459-1-git-send-email-huangguangbin2@huawei.com>
References: <1621491515-53459-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Fix incorrect code indent for conditional statements.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/bonding/bond_alb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index c63e0d1faa63..269dad176df4 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -835,7 +835,7 @@ static void rlb_purge_src_ip(struct bonding *bond, struct arp_pkt *arp)
 
 		if (entry->ip_src == arp->ip_src &&
 		    !ether_addr_equal_64bits(arp->mac_src, entry->mac_src))
-				rlb_delete_table_entry(bond, index);
+			rlb_delete_table_entry(bond, index);
 		index = next_index;
 	}
 	spin_unlock_bh(&bond->mode_lock);
-- 
2.8.1

