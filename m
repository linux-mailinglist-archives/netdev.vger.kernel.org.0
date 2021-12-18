Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D03479E5E
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbhLRXyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:51 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25746 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234968AbhLRXy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=L4jrxjI60V18U1KfdB6NjFsObHJc3K9dkEXY7jnJOIY=;
        b=tCTjJY0CsCNWIqe8qw53n7lkhgCLfogkvYOGmNXDrF3CaQwIKc5sPLXDgRzteQLdtLLJ
        2MEcjQS/tCHacgSE+TRdk0UT3+ESOy2REXFGqEfnDV2nkJXaVnnNL1oxYvUj1EKi49A2ZA
        zSzBNlmPtzHtTP/KtxsmN6BHc3HyvtNiauspfX2EYVjSM6CE26kJbu5vfFq1wD+KkEuny+
        CXY81bbSbEuZWPf6oGRpAP8RBufWqp+5YeOZIAEnoLDHfn7ta2zB9+kWkRucVACQziQ2hm
        gHrHiVAbF6wkyO15w1LDyfhfFia9GfTEKWzcxxx8M1JO3otHQ8SQ+Rc4QJDcX9hg==
Received: by filterdrecv-64fcb979b9-6sxlb with SMTP id filterdrecv-64fcb979b9-6sxlb-1-61BE74A9-9
        2021-12-18 23:54:17.267529153 +0000 UTC m=+8294205.257723544
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-0 (SG)
        with ESMTP
        id uH6ySRw9RY6s7dhCBnIeqw
        Sat, 18 Dec 2021 23:54:17.120 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id DDBC8701456; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 22/23] wilc1000: minor syntax cleanup
Date:   Sat, 18 Dec 2021 23:54:17 +0000 (UTC)
Message-Id: <20211218235404.3963475-23-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvOyBcWEdJk+6TgtIk?=
 =?us-ascii?Q?W4kHOENRwsRKyKvxEg1Xg4ZujUJ=2FQuiR6NhPsGd?=
 =?us-ascii?Q?Dm4hR4B807UtsqD+ucPQmTOnkdVodNt1uPwzdv0?=
 =?us-ascii?Q?9aqREdWgcb41hhO=2FJOQil64N2=2FZk9SMIYM0JaGi?=
 =?us-ascii?Q?9=2FJYDqae2qE9ybaPwe29BpChnKJWS=2Fs1WaL1+l?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
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
index debed2f159215..4ec23b2b2da05 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -653,10 +653,9 @@ static int fill_vmm_table(const struct wilc *wilc,
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
@@ -669,9 +668,8 @@ static int fill_vmm_table(const struct wilc *wilc,
 				vmm_sz += tqe_q[ac]->len;
 				vmm_sz = ALIGN(vmm_sz, 4);
 
-				if ((sum + vmm_sz) > WILC_TX_BUFF_SIZE) {
+				if (sum + vmm_sz > WILC_TX_BUFF_SIZE)
 					goto out;
-				}
 				vmm_table[i] = vmm_sz / 4;
 				if (tx_cb->type == WILC_CFG_PKT)
 					vmm_table[i] |= BIT(10);
@@ -735,10 +733,8 @@ static int send_vmm_table(struct wilc *wilc, int i, const u32 *vmm_table)
 
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

