Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E141E6150
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389824AbgE1Msd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:48:33 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5368 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389969AbgE1MsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 08:48:23 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 42C145B864B9E6210307;
        Thu, 28 May 2020 20:46:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 28 May 2020 20:46:38 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 08/11] net: hns3: remove unused struct hnae3_unic_private_info
Date:   Thu, 28 May 2020 20:45:09 +0800
Message-ID: <1590669912-21867-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590669912-21867-1-git-send-email-tanhuazhong@huawei.com>
References: <1590669912-21867-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since field .uinfo in struct hnae3_handle never be used,
so remove it and its structure definition.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 0a4aac4..d041cac 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -621,16 +621,6 @@ struct hnae3_roce_private_info {
 	unsigned long state;
 };
 
-struct hnae3_unic_private_info {
-	struct net_device *netdev;
-	u16 rx_buf_len;
-	u16 num_tx_desc;
-	u16 num_rx_desc;
-
-	u16 num_tqps;	/* total number of tqps in this handle */
-	struct hnae3_queue **tqp;  /* array base of all TQPs of this instance */
-};
-
 #define HNAE3_SUPPORT_APP_LOOPBACK    BIT(0)
 #define HNAE3_SUPPORT_PHY_LOOPBACK    BIT(1)
 #define HNAE3_SUPPORT_SERDES_SERIAL_LOOPBACK	BIT(2)
@@ -656,7 +646,6 @@ struct hnae3_handle {
 	union {
 		struct net_device *netdev; /* first member */
 		struct hnae3_knic_private_info kinfo;
-		struct hnae3_unic_private_info uinfo;
 		struct hnae3_roce_private_info rinfo;
 	};
 
-- 
2.7.4

