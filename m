Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D311D3019
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 14:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgENMnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 08:43:01 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59338 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbgENMnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 08:43:00 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1F33EAFF5921EC6753FB;
        Thu, 14 May 2020 20:42:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 14 May 2020 20:42:50 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/5] net: hns3: remove some unused macros
Date:   Thu, 14 May 2020 20:41:25 +0800
Message-ID: <1589460086-61130-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589460086-61130-1-git-send-email-tanhuazhong@huawei.com>
References: <1589460086-61130-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some macros defined in hns3_enet.h, but not used in
anywhere.

Reported-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 240ba06..60f82ad 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -46,23 +46,6 @@ enum hns3_nic_state {
 #define HNS3_RING_CFG_VF_NUM_REG		0x00080
 #define HNS3_RING_ASID_REG			0x0008C
 #define HNS3_RING_EN_REG			0x00090
-#define HNS3_RING_T0_BE_RST			0x00094
-#define HNS3_RING_COULD_BE_RST			0x00098
-#define HNS3_RING_WRR_WEIGHT_REG		0x0009c
-
-#define HNS3_RING_INTMSK_RXWL_REG		0x000A0
-#define HNS3_RING_INTSTS_RX_RING_REG		0x000A4
-#define HNS3_RX_RING_INT_STS_REG		0x000A8
-#define HNS3_RING_INTMSK_TXWL_REG		0x000AC
-#define HNS3_RING_INTSTS_TX_RING_REG		0x000B0
-#define HNS3_TX_RING_INT_STS_REG		0x000B4
-#define HNS3_RING_INTMSK_RX_OVERTIME_REG	0x000B8
-#define HNS3_RING_INTSTS_RX_OVERTIME_REG	0x000BC
-#define HNS3_RING_INTMSK_TX_OVERTIME_REG	0x000C4
-#define HNS3_RING_INTSTS_TX_OVERTIME_REG	0x000C8
-
-#define HNS3_RING_MB_CTRL_REG			0x00100
-#define HNS3_RING_MB_DATA_BASE_REG		0x00200
 
 #define HNS3_TX_REG_OFFSET			0x40
 
-- 
2.7.4

