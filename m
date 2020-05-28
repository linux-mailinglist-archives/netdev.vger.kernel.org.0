Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C951E62C3
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390635AbgE1NvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:51:10 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5376 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390533AbgE1NvB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 09:51:01 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3FC9FD799B746F9EE206;
        Thu, 28 May 2020 21:50:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Thu, 28 May 2020 21:50:50 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 07/12] net: hns3: remove some unused fields in struct hns3_nic_priv
Date:   Thu, 28 May 2020 21:48:14 +0800
Message-ID: <1590673699-63819-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590673699-63819-1-git-send-email-tanhuazhong@huawei.com>
References: <1590673699-63819-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove some fileds which defined in struct hns3_nic_priv,
but not used, and remove the related definition of struct
hns3_udp_tunnel and enum hns3_udp_tnl_type.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 60f82ad..66cd439 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -469,21 +469,8 @@ struct hns3_enet_tqp_vector {
 	unsigned long last_jiffies;
 } ____cacheline_internodealigned_in_smp;
 
-enum hns3_udp_tnl_type {
-	HNS3_UDP_TNL_VXLAN,
-	HNS3_UDP_TNL_GENEVE,
-	HNS3_UDP_TNL_MAX,
-};
-
-struct hns3_udp_tunnel {
-	u16 dst_port;
-	int used;
-};
-
 struct hns3_nic_priv {
 	struct hnae3_handle *ae_handle;
-	u32 enet_ver;
-	u32 port_id;
 	struct net_device *netdev;
 	struct device *dev;
 
@@ -495,19 +482,10 @@ struct hns3_nic_priv {
 	struct hns3_enet_tqp_vector *tqp_vector;
 	u16 vector_num;
 
-	/* The most recently read link state */
-	int link;
 	u64 tx_timeout_count;
 
 	unsigned long state;
 
-	struct timer_list service_timer;
-
-	struct work_struct service_task;
-
-	struct notifier_block notifier_block;
-	/* Vxlan/Geneve information */
-	struct hns3_udp_tunnel udp_tnl[HNS3_UDP_TNL_MAX];
 	struct hns3_enet_coalesce tx_coal;
 	struct hns3_enet_coalesce rx_coal;
 };
-- 
2.7.4

