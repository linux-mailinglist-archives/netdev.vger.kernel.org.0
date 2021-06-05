Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B358039C67D
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 09:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhFEHFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 03:05:32 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:4363 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhFEHF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 03:05:26 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Fxr9K2BP3z68TM;
        Sat,  5 Jun 2021 14:59:49 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 15:03:35 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 5 Jun 2021 15:03:34 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/8] net: hd64570: fix the code style issue about "foo* bar"
Date:   Sat, 5 Jun 2021 15:00:24 +0800
Message-ID: <1622876429-47278-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622876429-47278-1-git-send-email-huangguangbin2@huawei.com>
References: <1622876429-47278-1-git-send-email-huangguangbin2@huawei.com>
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

Fix the checkpatch error as "foo* bar" and should be "foo *bar",
and "(foo*)" should be "(foo *)".

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hd64570.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/hd64570.c b/drivers/net/wan/hd64570.c
index cca6101..6237da6 100644
--- a/drivers/net/wan/hd64570.c
+++ b/drivers/net/wan/hd64570.c
@@ -75,7 +75,7 @@ static inline int sca_intr_status(card_t *card)
 	return result;
 }
 
-static inline port_t* dev_to_port(struct net_device *dev)
+static inline port_t *dev_to_port(struct net_device *dev)
 {
 	return dev_to_hdlc(dev)->priv;
 }
@@ -211,7 +211,7 @@ static void sca_init_port(port_t *port)
 static inline void sca_msci_intr(port_t *port)
 {
 	u16 msci = get_msci(port);
-	card_t* card = port_to_card(port);
+	card_t *card = port_to_card(port);
 	u8 stat = sca_in(msci + ST1, card); /* read MSCI ST1 status */
 
 	/* Reset MSCI TX underrun and CDCD status bit */
@@ -329,7 +329,7 @@ static inline void sca_tx_intr(port_t *port)
 {
 	struct net_device *dev = port_to_dev(port);
 	u16 dmac = get_dmac_tx(port);
-	card_t* card = port_to_card(port);
+	card_t *card = port_to_card(port);
 	u8 stat;
 
 	spin_lock(&port->lock);
@@ -360,7 +360,7 @@ static inline void sca_tx_intr(port_t *port)
 	spin_unlock(&port->lock);
 }
 
-static irqreturn_t sca_intr(int irq, void* dev_id)
+static irqreturn_t sca_intr(int irq, void *dev_id)
 {
 	card_t *card = dev_id;
 	int i;
@@ -392,7 +392,7 @@ static irqreturn_t sca_intr(int irq, void* dev_id)
 
 static void sca_set_port(port_t *port)
 {
-	card_t* card = port_to_card(port);
+	card_t *card = port_to_card(port);
 	u16 msci = get_msci(port);
 	u8 md2 = sca_in(msci + MD2, card);
 	unsigned int tmc, br = 10, brv = 1024;
@@ -443,7 +443,7 @@ static void sca_set_port(port_t *port)
 static void sca_open(struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
-	card_t* card = port_to_card(port);
+	card_t *card = port_to_card(port);
 	u16 msci = get_msci(port);
 	u8 md0, md2;
 
@@ -506,7 +506,7 @@ static void sca_open(struct net_device *dev)
 static void sca_close(struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
-	card_t* card = port_to_card(port);
+	card_t *card = port_to_card(port);
 
 	/* reset channel */
 	sca_out(CMD_RESET, get_msci(port) + CMD, port_to_card(port));
-- 
2.8.1

