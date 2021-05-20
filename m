Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30789389DA1
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 08:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhETGW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 02:22:58 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3617 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhETGW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 02:22:56 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fm01w4SJ4zmWv5;
        Thu, 20 May 2021 14:19:16 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
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
Subject: [PATCH net-next 1/4] net: bonding: add some required blank lines
Date:   Thu, 20 May 2021 14:18:32 +0800
Message-ID: <1621491515-53459-2-git-send-email-huangguangbin2@huawei.com>
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

Add some blank lines after declarations as required.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/bonding/bond_alb.c    | 3 +++
 drivers/net/bonding/bond_main.c   | 2 ++
 drivers/net/bonding/bond_procfs.c | 1 +
 drivers/net/bonding/bond_sysfs.c  | 7 +++++++
 4 files changed, 13 insertions(+)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 3455f2cc13f2..c63e0d1faa63 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -104,6 +104,7 @@ static void __tlb_clear_slave(struct bonding *bond, struct slave *slave,
 		index = SLAVE_TLB_INFO(slave).head;
 		while (index != TLB_NULL_INDEX) {
 			u32 next_index = tx_hash_table[index].next;
+
 			tlb_init_table_entry(&tx_hash_table[index], save_load);
 			index = next_index;
 		}
@@ -628,6 +629,7 @@ static struct slave *rlb_choose_channel(struct sk_buff *skb,
 
 		if (!client_info->assigned) {
 			u32 prev_tbl_head = bond_info->rx_hashtbl_used_head;
+
 			bond_info->rx_hashtbl_used_head = hash_index;
 			client_info->used_next = prev_tbl_head;
 			if (prev_tbl_head != RLB_NULL_INDEX) {
@@ -830,6 +832,7 @@ static void rlb_purge_src_ip(struct bonding *bond, struct arp_pkt *arp)
 	while (index != RLB_NULL_INDEX) {
 		struct rlb_client_info *entry = &(bond_info->rx_hashtbl[index]);
 		u32 next_index = entry->src_next;
+
 		if (entry->ip_src == arp->ip_src &&
 		    !ether_addr_equal_64bits(arp->mac_src, entry->mac_src))
 				rlb_delete_table_entry(bond, index);
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 20bbda1b36e1..e786a9c42bfd 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2272,6 +2272,7 @@ static int bond_release_and_destroy(struct net_device *bond_dev,
 static void bond_info_query(struct net_device *bond_dev, struct ifbond *info)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
+
 	bond_fill_ifbond(bond, info);
 }
 
@@ -4849,6 +4850,7 @@ static const struct device_type bond_type = {
 static void bond_destructor(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
+
 	if (bond->wq)
 		destroy_workqueue(bond->wq);
 }
diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index 56d34be5e797..0fb1da361bb1 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -112,6 +112,7 @@ static void bond_info_show_master(struct seq_file *seq)
 	/* ARP information */
 	if (bond->params.arp_interval > 0) {
 		int printed = 0;
+
 		seq_printf(seq, "ARP Polling Interval (ms): %d\n",
 				bond->params.arp_interval);
 
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 2d615a93685e..5f9e9a240226 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -385,6 +385,7 @@ static ssize_t bonding_show_num_peer_notif(struct device *d,
 					   char *buf)
 {
 	struct bonding *bond = to_bond(d);
+
 	return sprintf(buf, "%d\n", bond->params.num_peer_notif);
 }
 static DEVICE_ATTR(num_grat_arp, 0644,
@@ -496,6 +497,7 @@ static ssize_t bonding_show_ad_aggregator(struct device *d,
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 		struct ad_info ad_info;
+
 		count = sprintf(buf, "%d\n",
 				bond_3ad_get_active_agg_info(bond, &ad_info)
 				?  0 : ad_info.aggregator_id);
@@ -516,6 +518,7 @@ static ssize_t bonding_show_ad_num_ports(struct device *d,
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 		struct ad_info ad_info;
+
 		count = sprintf(buf, "%d\n",
 				bond_3ad_get_active_agg_info(bond, &ad_info)
 				?  0 : ad_info.ports);
@@ -536,6 +539,7 @@ static ssize_t bonding_show_ad_actor_key(struct device *d,
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD && capable(CAP_NET_ADMIN)) {
 		struct ad_info ad_info;
+
 		count = sprintf(buf, "%d\n",
 				bond_3ad_get_active_agg_info(bond, &ad_info)
 				?  0 : ad_info.actor_key);
@@ -556,6 +560,7 @@ static ssize_t bonding_show_ad_partner_key(struct device *d,
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD && capable(CAP_NET_ADMIN)) {
 		struct ad_info ad_info;
+
 		count = sprintf(buf, "%d\n",
 				bond_3ad_get_active_agg_info(bond, &ad_info)
 				?  0 : ad_info.partner_key);
@@ -576,6 +581,7 @@ static ssize_t bonding_show_ad_partner_mac(struct device *d,
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD && capable(CAP_NET_ADMIN)) {
 		struct ad_info ad_info;
+
 		if (!bond_3ad_get_active_agg_info(bond, &ad_info))
 			count = sprintf(buf, "%pM\n", ad_info.partner_system);
 	}
@@ -660,6 +666,7 @@ static ssize_t bonding_show_tlb_dynamic_lb(struct device *d,
 					   char *buf)
 {
 	struct bonding *bond = to_bond(d);
+
 	return sprintf(buf, "%d\n", bond->params.tlb_dynamic_lb);
 }
 static DEVICE_ATTR(tlb_dynamic_lb, 0644,
-- 
2.8.1

