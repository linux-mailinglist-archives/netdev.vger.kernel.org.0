Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A8F3A9660
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 11:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbhFPJji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 05:39:38 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4946 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbhFPJjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 05:39:17 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G4g486dZMz70ST;
        Wed, 16 Jun 2021 17:34:00 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 17:37:10 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 17:37:10 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 7/8] net: hdlc_ppp: remove redundant spaces
Date:   Wed, 16 Jun 2021 17:33:56 +0800
Message-ID: <1623836037-26812-8-git-send-email-huangguangbin2@huawei.com>
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

According to the chackpatch.pl,
no spaces is necessary at the start of a line.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc_ppp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index 7b7c02d..53c668e 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -34,8 +34,8 @@
 
 enum {IDX_LCP = 0, IDX_IPCP, IDX_IPV6CP, IDX_COUNT};
 enum {CP_CONF_REQ = 1, CP_CONF_ACK, CP_CONF_NAK, CP_CONF_REJ, CP_TERM_REQ,
-      CP_TERM_ACK, CP_CODE_REJ, LCP_PROTO_REJ, LCP_ECHO_REQ, LCP_ECHO_REPLY,
-      LCP_DISC_REQ, CP_CODES};
+	CP_TERM_ACK, CP_CODE_REJ, LCP_PROTO_REJ, LCP_ECHO_REQ, LCP_ECHO_REPLY,
+	LCP_DISC_REQ, CP_CODES};
 #if DEBUG_CP
 static const char *const code_names[CP_CODES] = {
 	"0", "ConfReq", "ConfAck", "ConfNak", "ConfRej", "TermReq",
@@ -80,11 +80,11 @@ struct ppp {
 };
 
 enum {CLOSED = 0, STOPPED, STOPPING, REQ_SENT, ACK_RECV, ACK_SENT, OPENED,
-      STATES, STATE_MASK = 0xF};
+	STATES, STATE_MASK = 0xF};
 enum {START = 0, STOP, TO_GOOD, TO_BAD, RCR_GOOD, RCR_BAD, RCA, RCN, RTR, RTA,
-      RUC, RXJ_GOOD, RXJ_BAD, EVENTS};
+	RUC, RXJ_GOOD, RXJ_BAD, EVENTS};
 enum {INV = 0x10, IRC = 0x20, ZRC = 0x40, SCR = 0x80, SCA = 0x100,
-      SCN = 0x200, STR = 0x400, STA = 0x800, SCJ = 0x1000};
+	SCN = 0x200, STR = 0x400, STA = 0x800, SCJ = 0x1000};
 
 #if DEBUG_STATE
 static const char *const state_names[STATES] = {
-- 
2.8.1

