Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCBF38BB4D
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 03:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236220AbhEUBMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 21:12:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4563 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235906AbhEUBMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 21:12:39 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FmT4r15S1zqVBj;
        Fri, 21 May 2021 09:08:28 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 09:11:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 21 May 2021 09:11:15 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/6] net: wan: fix an code style issue about "foo* bar"
Date:   Fri, 21 May 2021 09:08:12 +0800
Message-ID: <1621559297-9651-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621559297-9651-1-git-send-email-huangguangbin2@huawei.com>
References: <1621559297-9651-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Fix the checkpatch error as "foo* bar" should be "foo *bar".

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hd64572.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wan/hd64572.c b/drivers/net/wan/hd64572.c
index 9f60e3969bf8..e7d8653c4bde 100644
--- a/drivers/net/wan/hd64572.c
+++ b/drivers/net/wan/hd64572.c
@@ -54,7 +54,7 @@
 
 static int sca_poll(struct napi_struct *napi, int budget);
 
-static inline port_t* dev_to_port(struct net_device *dev)
+static inline port_t *dev_to_port(struct net_device *dev)
 {
 	return dev_to_hdlc(dev)->priv;
 }
@@ -186,7 +186,7 @@ static void sca_init_port(port_t *port)
 static inline void sca_msci_intr(port_t *port)
 {
 	u16 msci = get_msci(port);
-	card_t* card = port->card;
+	card_t *card = port->card;
 
 	if (sca_in(msci + ST1, card) & ST1_CDCD) {
 		/* Reset MSCI CDCD status bit */
@@ -286,7 +286,7 @@ static inline int sca_rx_done(port_t *port, int budget)
 static inline void sca_tx_done(port_t *port)
 {
 	struct net_device *dev = port->netdev;
-	card_t* card = port->card;
+	card_t *card = port->card;
 	u8 stat;
 	unsigned count = 0;
 
@@ -366,7 +366,7 @@ static irqreturn_t sca_intr(int irq, void *dev_id)
 
 static void sca_set_port(port_t *port)
 {
-	card_t* card = port->card;
+	card_t *card = port->card;
 	u16 msci = get_msci(port);
 	u8 md2 = sca_in(msci + MD2, card);
 	unsigned int tmc, br = 10, brv = 1024;
@@ -421,7 +421,7 @@ static void sca_set_port(port_t *port)
 static void sca_open(struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
-	card_t* card = port->card;
+	card_t *card = port->card;
 	u16 msci = get_msci(port);
 	u8 md0, md2;
 
-- 
2.8.1

