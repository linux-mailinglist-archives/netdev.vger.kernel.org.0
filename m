Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913AC389D9F
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 08:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhETGW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 02:22:56 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3618 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhETGW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 02:22:56 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fm01w6jKyzmWwT;
        Thu, 20 May 2021 14:19:16 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 14:21:33 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 20 May 2021 14:21:33 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/4] net: bonding: remove unnecessary braces
Date:   Thu, 20 May 2021 14:18:34 +0800
Message-ID: <1621491515-53459-4-git-send-email-huangguangbin2@huawei.com>
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

Braces {} are not necessary for single statement blocks,
so remove these braces {}.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/bonding/bond_debugfs.c | 3 +--
 drivers/net/bonding/bond_main.c    | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_debugfs.c b/drivers/net/bonding/bond_debugfs.c
index f3f86ef68ae0..4f9b4a18c74c 100644
--- a/drivers/net/bonding/bond_debugfs.c
+++ b/drivers/net/bonding/bond_debugfs.c
@@ -88,9 +88,8 @@ void bond_create_debugfs(void)
 {
 	bonding_debug_root = debugfs_create_dir("bonding", NULL);
 
-	if (!bonding_debug_root) {
+	if (!bonding_debug_root)
 		pr_warn("Warning: Cannot create bonding directory in debugfs\n");
-	}
 }
 
 void bond_destroy_debugfs(void)
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e786a9c42bfd..dafeaef3cbd3 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1013,9 +1013,8 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 			if (bond_is_lb(bond))
 				bond_alb_handle_link_change(bond, new_active, BOND_LINK_UP);
 		} else {
-			if (bond_uses_primary(bond)) {
+			if (bond_uses_primary(bond))
 				slave_info(bond->dev, new_active->dev, "making interface the new active one\n");
-			}
 		}
 	}
 
-- 
2.8.1

