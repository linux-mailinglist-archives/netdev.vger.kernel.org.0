Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749DE3A9658
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 11:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbhFPJjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 05:39:18 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:10099 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbhFPJjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 05:39:16 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4g4Q3dYczZdPC;
        Wed, 16 Jun 2021 17:34:14 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 17:37:09 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 17:37:09 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/8] net: hdlc_ppp: add blank line after declarations
Date:   Wed, 16 Jun 2021 17:33:51 +0800
Message-ID: <1623836037-26812-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623836037-26812-1-git-send-email-huangguangbin2@huawei.com>
References: <1623836037-26812-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
 drivers/net/wan/hdlc_ppp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index e25b2f0..32f01d7 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -41,6 +41,7 @@ static const char *const code_names[CP_CODES] = {
 	"0", "ConfReq", "ConfAck", "ConfNak", "ConfRej", "TermReq",
 	"TermAck", "CodeRej", "ProtoRej", "EchoReq", "EchoReply", "Discard"
 };
+
 static char debug_buffer[64 + 3 * DEBUG_CP];
 #endif
 
@@ -90,6 +91,7 @@ static const char *const state_names[STATES] = {
 	"Closed", "Stopped", "Stopping", "ReqSent", "AckRecv", "AckSent",
 	"Opened"
 };
+
 static const char *const event_names[EVENTS] = {
 	"Start", "Stop", "TO+", "TO-", "RCR+", "RCR-", "RCA", "RCN",
 	"RTR", "RTA", "RUC", "RXJ+", "RXJ-"
@@ -194,6 +196,7 @@ static int ppp_hard_header(struct sk_buff *skb, struct net_device *dev,
 static void ppp_tx_flush(void)
 {
 	struct sk_buff *skb;
+
 	while ((skb = skb_dequeue(&tx_queue)) != NULL)
 		dev_queue_xmit(skb);
 }
@@ -616,6 +619,7 @@ static void ppp_start(struct net_device *dev)
 
 	for (i = 0; i < IDX_COUNT; i++) {
 		struct proto *proto = &ppp->protos[i];
+
 		proto->dev = dev;
 		timer_setup(&proto->timer, ppp_timer, 0);
 		proto->state = CLOSED;
-- 
2.8.1

