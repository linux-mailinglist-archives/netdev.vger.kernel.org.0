Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33AB47DD49
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346292AbhLWBQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:48 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18308 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345750AbhLWBOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=+rDeixZ7MJSx6InnY+u1z6fli4Hj5k1B4JVFs6766eU=;
        b=fehs5hthNSvBBSTyskZKbAzPyTqgZjqfQ/jS+p9Ph4LoWr/V/zHU5EePqlvAGEQBmxHj
        NU4/6nmxnMVjlDgS1u6IRFAnhWi+tkZfQlvsRWH9VPbyroPrdzNs2cSEwyuQKoDsRP1lGZ
        3Cx2JYQkRNC66xLxS4RCoNUtZV6O7MiwR8PgZq3LB7D+AKYaPUEvrUBIpkO0ELJtwkCQmY
        DedxsmJ8y+lyKSxsN3RYiBjR06zZJW1fuF6rtVbYX4zgSIKsuvln2AXdyBuTYvhZIt0hEB
        CRYANGPpn/JkKubcMqZo5M5B/0zsky6xkHqZeTErrhSYDlQoLAYHM+C8wHhdNvEw==
Received: by filterdrecv-656998cfdd-ptr8m with SMTP id filterdrecv-656998cfdd-ptr8m-1-61C3CD5E-32
        2021-12-23 01:14:06.611838373 +0000 UTC m=+7955208.471421114
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-5-0 (SG)
        with ESMTP
        id 0znaJCznRG-yQLmOzbTajw
        Thu, 23 Dec 2021 01:14:06.470 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 5122870144A; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 22/50] wilc1000: minor syntax cleanup
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-23-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvJKfYCcYkBmI5xpqF?=
 =?us-ascii?Q?oSD34tNpJNDAhFw+fPQk430jNmTlt1liYNUH15c?=
 =?us-ascii?Q?CnQ=2Ffa6zQty9oXEWTbqAz5=2F=2FJ0EIGQ6Qkt7F0mJ?=
 =?us-ascii?Q?XMaoicZG1Ml4osxMuq3KxR33JXEtS5RVLI1Lqnf?=
 =?us-ascii?Q?0CY7gWiFKNIRSzGi1IL1PbHzaZ8cJkKnkwUXiR?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove extraneous parentheses and braces.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index bdc31a4fd0f6a..27b1d317dc0c4 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -656,10 +656,9 @@ static int fill_vmm_table(const struct wilc *wilc,
 				continue;
 
 			ac_exist = 1;
-			for (k = 0; (k < num_pkts_to_add[ac]) && tqe_q[ac]; k++) {
-				if (i >= (WILC_VMM_TBL_SIZE - 1)) {
+			for (k = 0; k < num_pkts_to_add[ac] && tqe_q[ac]; k++) {
+				if (i >= WILC_VMM_TBL_SIZE - 1)
 					goto out;
-				}
 
 				tx_cb = WILC_SKB_TX_CB(tqe_q[ac]);
 				if (tx_cb->type == WILC_CFG_PKT)
@@ -672,9 +671,8 @@ static int fill_vmm_table(const struct wilc *wilc,
 				vmm_sz += tqe_q[ac]->len;
 				vmm_sz = ALIGN(vmm_sz, 4);
 
-				if ((sum + vmm_sz) > WILC_TX_BUFF_SIZE) {
+				if (sum + vmm_sz > WILC_TX_BUFF_SIZE)
 					goto out;
-				}
 				vmm_table[i] = vmm_sz / 4;
 				if (tx_cb->type == WILC_CFG_PKT)
 					vmm_table[i] |= BIT(10);
@@ -741,10 +739,8 @@ static int send_vmm_table(struct wilc *wilc, int i, const u32 *vmm_table)
 
 	timeout = 200;
 	do {
-		ret = func->hif_block_tx(wilc,
-					 WILC_VMM_TBL_RX_SHADOW_BASE,
-					 (u8 *)vmm_table,
-					 ((i + 1) * 4));
+		ret = func->hif_block_tx(wilc, WILC_VMM_TBL_RX_SHADOW_BASE,
+					 (u8 *)vmm_table, (i + 1) * 4);
 		if (ret)
 			break;
 
-- 
2.25.1

