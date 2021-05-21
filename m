Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7043138BCEE
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 05:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238881AbhEUDWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 23:22:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5710 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbhEUDWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 23:22:30 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FmWxq0CwdzqVTj;
        Fri, 21 May 2021 11:17:35 +0800 (CST)
Received: from dggeme766-chm.china.huawei.com (10.3.19.112) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 11:21:06 +0800
Received: from huawei.com (10.175.113.133) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 21
 May 2021 11:21:05 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <j.vosburgh@gmail.com>,
        <vfalico@gmail.com>, <andy@greyhouse.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: bonding: bond_alb: Fix some typos in bond_alb.c
Date:   Fri, 21 May 2021 11:31:35 +0800
Message-ID: <20210521033135.32014-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/becase/because/
s/reqeusts/requests/
s/funcions/functions/
s/addreses/addresses/

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/bonding/bond_alb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 3455f2cc13f2..ddc416323867 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -228,7 +228,7 @@ static struct slave *tlb_choose_channel(struct bonding *bond, u32 hash_index,
 {
 	struct slave *tx_slave;
 
-	/* We don't need to disable softirq here, becase
+	/* We don't need to disable softirq here, because
 	 * tlb_choose_channel() is only called by bond_alb_xmit()
 	 * which already has softirq disabled.
 	 */
@@ -608,7 +608,7 @@ static struct slave *rlb_choose_channel(struct sk_buff *skb,
 
 		client_info->ip_src = arp->ip_src;
 		client_info->ip_dst = arp->ip_dst;
-		/* arp->mac_dst is broadcast for arp reqeusts.
+		/* arp->mac_dst is broadcast for arp requests.
 		 * will be updated with clients actual unicast mac address
 		 * upon receiving an arp reply.
 		 */
@@ -1268,7 +1268,7 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
 	return res;
 }
 
-/************************ exported alb funcions ************************/
+/************************ exported alb functions ************************/
 
 int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
 {
@@ -1547,7 +1547,7 @@ void bond_alb_monitor(struct work_struct *work)
 
 		bond_for_each_slave_rcu(bond, slave, iter) {
 			/* If updating current_active, use all currently
-			 * user mac addreses (!strict_match).  Otherwise, only
+			 * user mac addresses (!strict_match).  Otherwise, only
 			 * use mac of the slave device.
 			 * In RLB mode, we always use strict matches.
 			 */
-- 
2.17.1

