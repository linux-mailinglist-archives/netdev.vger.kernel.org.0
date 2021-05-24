Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308DD38EA53
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbhEXOyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:54:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3652 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233973AbhEXOvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 10:51:54 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fpg5Z1pJ7zNykh;
        Mon, 24 May 2021 22:46:42 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 22:50:17 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 24 May 2021 22:50:17 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 03/10] net: wan: add blank line after declarations
Date:   Mon, 24 May 2021 22:47:10 +0800
Message-ID: <1621867637-2680-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621867637-2680-1-git-send-email-huangguangbin2@huawei.com>
References: <1621867637-2680-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch fixes the checkpatch error about missing a blank line
after declarations.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/wanxl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index afca54cf3e82..566c519c6f65 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -93,6 +93,7 @@ static inline dma_addr_t pci_map_single_debug(struct pci_dev *pdev, void *ptr,
 					      size_t size, int direction)
 {
 	dma_addr_t addr = dma_map_single(&pdev->dev, ptr, size, direction);
+
 	if (addr + size > 0x100000000LL)
 		pr_crit("%s: pci_map_single() returned memory at 0x%llx!\n",
 			pci_name(pdev), (unsigned long long)addr);
@@ -150,6 +151,7 @@ static inline void wanxl_cable_intr(struct port *port)
 static inline void wanxl_tx_intr(struct port *port)
 {
 	struct net_device *dev = port->dev;
+
 	while (1) {
                 desc_t *desc = &get_status(port)->tx_descs[port->tx_in];
 		struct sk_buff *skb = port->tx_skbs[port->tx_in];
@@ -181,6 +183,7 @@ static inline void wanxl_tx_intr(struct port *port)
 static inline void wanxl_rx_intr(struct card *card)
 {
 	desc_t *desc;
+
 	while (desc = &card->status->rx_descs[card->rx_in],
 	       desc->stat != PACKET_EMPTY) {
 		if ((desc->stat & PACKET_PORT_MASK) > card->n_ports)
@@ -662,6 +665,7 @@ static int wanxl_pci_init_one(struct pci_dev *pdev,
 
 	for (i = 0; i < RX_QUEUE_LENGTH; i++) {
 		struct sk_buff *skb = dev_alloc_skb(BUFFER_LENGTH);
+
 		card->rx_skbs[i] = skb;
 		if (skb)
 			card->status->rx_descs[i].address =
@@ -729,6 +733,7 @@ static int wanxl_pci_init_one(struct pci_dev *pdev,
 		hdlc_device *hdlc;
 		struct port *port = &card->ports[i];
 		struct net_device *dev = alloc_hdlcdev(port);
+
 		if (!dev) {
 			pr_err("%s: unable to allocate memory\n",
 			       pci_name(pdev));
-- 
2.8.1

