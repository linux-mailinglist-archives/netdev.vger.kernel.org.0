Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86AA13A2547
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 09:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhFJHZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 03:25:16 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3819 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhFJHZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 03:25:12 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0wLP1zBnzWsc9;
        Thu, 10 Jun 2021 15:18:21 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:23:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:23:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/8] net: ixp4xx_hss: remove redundant blank lines
Date:   Thu, 10 Jun 2021 15:19:58 +0800
Message-ID: <1623309605-15671-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623309605-15671-1-git-send-email-huangguangbin2@huawei.com>
References: <1623309605-15671-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch removes some redundant blank lines.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/ixp4xx_hss.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index ecea09f..2c135a9 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -83,7 +83,6 @@
 #define PKT_HDLC_CRC_32			0x2 /* default = CRC-16 */
 #define PKT_HDLC_MSB_ENDIAN		0x4 /* default = LE */
 
-
 /* hss_config, PCRs */
 /* Frame sync sampling, default = active low */
 #define PCR_FRM_SYNC_ACTIVE_HIGH	0x40000000
@@ -150,7 +149,6 @@
 /* HSS number, default = 0 (first) */
 #define CCR_SECOND_HSS			0x01000000
 
-
 /* hss_config, clkCR: main:10, num:10, denom:12 */
 #define CLK42X_SPEED_EXP	((0x3FF << 22) | (  2 << 12) |   15) /*65 KHz*/
 
@@ -208,7 +206,6 @@
 #define HSS_CONFIG_TX_LUT	0x18 /* channel look-up tables */
 #define HSS_CONFIG_RX_LUT	0x38
 
-
 /* NPE command codes */
 /* writes the ConfigWord value to the location specified by offset */
 #define PORT_CONFIG_WRITE		0x40
@@ -240,7 +237,6 @@
 #define ERR_HDLC_ABORT		6 /* abort sequence received */
 #define ERR_DISCONNECTING	7 /* disconnect is in progress */
 
-
 #ifdef __ARMEB__
 typedef struct sk_buff buffer_t;
 #define free_buffer dev_kfree_skb
@@ -308,7 +304,6 @@ struct desc {
 	u32 __reserved1[4];
 };
 
-
 #define rx_desc_phys(port, n)	((port)->desc_tab_phys +		\
 				 (n) * sizeof(struct desc))
 #define rx_desc_ptr(port, n)	(&(port)->desc_tab[n])
@@ -567,7 +562,6 @@ static inline void debug_pkt(struct net_device *dev, const char *func,
 #endif
 }
 
-
 static inline void debug_desc(u32 phys, struct desc *desc)
 {
 #if DEBUG_DESC
@@ -606,7 +600,6 @@ static inline void queue_put_desc(unsigned int queue, u32 phys,
 	   length and queues >= 32 don't support this check anyway. */
 }
 
-
 static inline void dma_unmap_tx(struct port *port, struct desc *desc)
 {
 #ifdef __ARMEB__
@@ -619,7 +612,6 @@ static inline void dma_unmap_tx(struct port *port, struct desc *desc)
 #endif
 }
 
-
 static void hss_hdlc_set_carrier(void *pdev, int carrier)
 {
 	struct net_device *netdev = pdev;
@@ -784,7 +776,6 @@ static int hss_hdlc_poll(struct napi_struct *napi, int budget)
 	return received;	/* not all work done */
 }
 
-
 static void hss_hdlc_txdone_irq(void *pdev)
 {
 	struct net_device *dev = pdev;
@@ -910,7 +901,6 @@ static int hss_hdlc_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-
 static int request_hdlc_queues(struct port *port)
 {
 	int err;
@@ -1160,7 +1150,6 @@ static int hss_hdlc_close(struct net_device *dev)
 	return 0;
 }
 
-
 static int hss_hdlc_attach(struct net_device *dev, unsigned short encoding,
 			   unsigned short parity)
 {
-- 
2.8.1

