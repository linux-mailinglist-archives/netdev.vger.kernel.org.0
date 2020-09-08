Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DACC2608DC
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 05:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgIHDDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 23:03:02 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47872 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728241AbgIHDCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 23:02:30 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CC0E3FF86FAEEF52E2C4;
        Tue,  8 Sep 2020 11:02:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Sep 2020 11:02:20 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 7/7] net: hns3: remove some unused function hns3_update_promisc_mode()
Date:   Tue, 8 Sep 2020 10:59:54 +0800
Message-ID: <1599533994-32744-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599533994-32744-1-git-send-email-tanhuazhong@huawei.com>
References: <1599533994-32744-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

hns3_update_promisc_mode is defined, but not be used, so remove it.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 14 --------------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |  1 -
 2 files changed, 15 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 1d66f84..93825a4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -623,20 +623,6 @@ void hns3_request_update_promisc_mode(struct hnae3_handle *handle)
 		ops->request_update_promisc_mode(handle);
 }
 
-int hns3_update_promisc_mode(struct net_device *netdev, u8 promisc_flags)
-{
-	struct hns3_nic_priv *priv = netdev_priv(netdev);
-	struct hnae3_handle *h = priv->ae_handle;
-
-	if (h->ae_algo->ops->set_promisc_mode) {
-		return h->ae_algo->ops->set_promisc_mode(h,
-						promisc_flags & HNAE3_UPE,
-						promisc_flags & HNAE3_MPE);
-	}
-
-	return 0;
-}
-
 void hns3_enable_vlan_filter(struct net_device *netdev, bool enable)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index cef6f9a..98ca6ea 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -601,7 +601,6 @@ void hns3_set_vector_coalesce_rl(struct hns3_enet_tqp_vector *tqp_vector,
 				 u32 rl_value);
 
 void hns3_enable_vlan_filter(struct net_device *netdev, bool enable);
-int hns3_update_promisc_mode(struct net_device *netdev, u8 promisc_flags);
 void hns3_request_update_promisc_mode(struct hnae3_handle *handle);
 
 #ifdef CONFIG_HNS3_DCB
-- 
2.7.4

