Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8284E3A3A60
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 05:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhFKDlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 23:41:39 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3952 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbhFKDlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 23:41:31 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G1RMv5mFXz6xWn;
        Fri, 11 Jun 2021 11:36:27 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 11:39:33 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 11 Jun 2021 11:39:32 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 7/8] net: pc300too: add some required spaces
Date:   Fri, 11 Jun 2021 11:36:21 +0800
Message-ID: <1623382582-37854-8-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623382582-37854-1-git-send-email-huangguangbin2@huawei.com>
References: <1623382582-37854-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Add spaces required before the open parenthesis '('.
Add spaces required after that close brace '}'.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/pc300too.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wan/pc300too.c b/drivers/net/wan/pc300too.c
index ecce999..885dcc5 100644
--- a/drivers/net/wan/pc300too.c
+++ b/drivers/net/wan/pc300too.c
@@ -68,7 +68,7 @@ typedef struct {
 	u32 cs_base[4];		/* 3C-48h : Chip Select Base Addrs */
 	u32 intr_ctrl_stat;	/* 4Ch : Interrupt Control/Status */
 	u32 init_ctrl;		/* 50h : EEPROM ctrl, Init Ctrl, etc */
-}plx9050;
+} plx9050;
 
 typedef struct port_s {
 	struct napi_struct napi;
@@ -85,7 +85,7 @@ typedef struct port_s {
 	u16 txlast;
 	u8 rxs, txs, tmc;	/* SCA registers */
 	u8 chan;		/* physical port # - 0 or 1 */
-}port_t;
+} port_t;
 
 typedef struct card_s {
 	int type;		/* RSV, X21, etc. */
@@ -100,7 +100,7 @@ typedef struct card_s {
 	u8 irq;			/* interrupt request level */
 
 	port_t ports[2];
-}card_t;
+} card_t;
 
 #define get_port(card, port)	     ((port) < (card)->n_ports ? \
 					 (&(card)->ports[port]) : (NULL))
@@ -117,7 +117,7 @@ static void pc300_set_iface(port_t *port)
 
 	sca_out(EXS_TES1, (port->chan ? MSCI1_OFFSET : MSCI0_OFFSET) + EXS,
 		port->card);
-	switch(port->settings.clock_type) {
+	switch (port->settings.clock_type) {
 	case CLOCK_INT:
 		rxs |= CLK_BRG; /* BRG output */
 		txs |= CLK_PIN_OUT | CLK_TX_RXCLK; /* RX clock */
-- 
2.8.1

