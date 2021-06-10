Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE753A2551
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 09:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhFJHZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 03:25:29 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:5316 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhFJHZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 03:25:12 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G0wLP41SZz1BKjl;
        Thu, 10 Jun 2021 15:18:21 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
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
Subject: [PATCH net-next 2/8] net: ixp4xx_hss: add blank line after declarations
Date:   Thu, 10 Jun 2021 15:19:59 +0800
Message-ID: <1623309605-15671-3-git-send-email-huangguangbin2@huawei.com>
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

This patch fixes the checkpatch error about missing a blank line
after declarations.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/ixp4xx_hss.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index 2c135a9..6aa01d5 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -341,6 +341,7 @@ static inline struct port* dev_to_port(struct net_device *dev)
 static inline void memcpy_swab32(u32 *dest, u32 *src, int cnt)
 {
 	int i;
+
 	for (i = 0; i < cnt; i++)
 		dest[i] = swab32(src[i]);
 }
@@ -353,6 +354,7 @@ static inline void memcpy_swab32(u32 *dest, u32 *src, int cnt)
 static void hss_npe_send(struct port *port, struct msg *msg, const char* what)
 {
 	u32 *val = (u32*)msg;
+
 	if (npe_send_message(port->npe, msg, what)) {
 		pr_crit("HSS-%i: unable to send command [%08X:%08X] to %s\n",
 			port->id, val[0], val[1], npe_name(port->npe));
@@ -1006,6 +1008,7 @@ static void destroy_hdlc_queues(struct port *port)
 		for (i = 0; i < RX_DESCS; i++) {
 			struct desc *desc = rx_desc_ptr(port, i);
 			buffer_t *buff = port->rx_buff_tab[i];
+
 			if (buff) {
 				dma_unmap_single(&port->netdev->dev,
 						 desc->data, RX_SIZE,
@@ -1016,6 +1019,7 @@ static void destroy_hdlc_queues(struct port *port)
 		for (i = 0; i < TX_DESCS; i++) {
 			struct desc *desc = tx_desc_ptr(port, i);
 			buffer_t *buff = port->tx_buff_tab[i];
+
 			if (buff) {
 				dma_unmap_tx(port, desc);
 				free_buffer(buff);
@@ -1213,6 +1217,7 @@ static void find_best_clock(u32 timer_freq, u32 rate, u32 *best, u32 *reg)
 
 	for (b = 0; b < 0x400; b++) {
 		u64 c = (b + 1) * (u64)rate;
+
 		do_div(c, timer_freq - rate * a);
 		c--;
 		if (c >= 0xFFF) { /* 12-bit - no need to check more 'b's */
-- 
2.8.1

