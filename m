Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D57E47DD08
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346128AbhLWBOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:14:33 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18448 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345816AbhLWBOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=3vwCxlA4ciJJxDou6+Vb/H7rVta8Jut/SEU831ryMNU=;
        b=aMLSvbfJFTCyE2NGkfucRE4R2mGDyxR2qAeqVCy6M7NHL3w51yP2L9P0O3/PTJnM4eHm
        z9fxAMb8WcWmmQaKjB1qMlY3etdM94RthIavutZLG+DkZIzLPrh/ge0ma0beOYgO6Tr2xc
        06puuOtJMBVm8MAWTdWj16TVWy1fvqTo4SuV9g5lhhpvIIahxEpkW/yLoS0a/gSGrTQsIH
        MrdM19HrPlWfNs/kEaIEUYhXvxYi5Lfdi7GRD67kZ+OVUCOc09TcsUJsffvQe/U0BwIl38
        rASRv8uHr9/B5lQabJ5+GwxiVqvpLAquD39u7rYgGNbA2tHrAM0F76iPDtawz5TA==
Received: by filterdrecv-64fcb979b9-st7n5 with SMTP id filterdrecv-64fcb979b9-st7n5-1-61C3CD5E-3C
        2021-12-23 01:14:06.739937721 +0000 UTC m=+8644640.723524771
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-5-0 (SG)
        with ESMTP
        id dhLYRvACTEmHBYzBDu_11g
        Thu, 23 Dec 2021 01:14:06.600 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 8F3127014AD; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 30/50] wilc1000: use more descriptive variable names
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-31-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvFxBP+gfd73CXFX+b?=
 =?us-ascii?Q?N=2FzdCv1aaMpRvyqQ7QMMfTi3rjMRuYumSNBl00O?=
 =?us-ascii?Q?AOZq92YF2soepP4nF+7m7Rwi9ECmoO59TUiEaZg?=
 =?us-ascii?Q?it+tgk79IwKbGwFCqTfLcBY+6PWl9R3y9KzW+JQ?=
 =?us-ascii?Q?O0+sLvoGyVuV2EujHeoaSUyYtCSVQI540TqeZP?=
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

Rename "i" to "vmm_table_len" to improve readability and update
kernel-doc for send_vmm_table() as well.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/wlan.c    | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 1cd9a7761343a..a4523b0860878 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -712,9 +712,9 @@ static int fill_vmm_table(const struct wilc *wilc,
 }
 
 /**
- * send_vmm_table() - Send the VMM table to the chip
+ * send_vmm_table() - send the VMM table to the chip
  * @wilc: Pointer to the wilc structure.
- * @i: The number of entries in the VMM table.
+ * @vmm_table_len: The number of entries in the VMM table.
  * @vmm_table: The VMM table to send.
  *
  * Send the VMM table to the chip and get back the number of entries
@@ -723,10 +723,10 @@ static int fill_vmm_table(const struct wilc *wilc,
  * Context: The bus must have been acquired before calling this
  * function.
  *
- * Return:
- *	The number of VMM table entries the chip can accept.
+ * Return: The number of VMM table entries the chip can accept.
  */
-static int send_vmm_table(struct wilc *wilc, int i, const u32 *vmm_table)
+static int send_vmm_table(struct wilc *wilc,
+			  int vmm_table_len, const u32 *vmm_table)
 {
 	const struct wilc_hif_func *func;
 	int ret, counter, entries, timeout;
@@ -758,7 +758,8 @@ static int send_vmm_table(struct wilc *wilc, int i, const u32 *vmm_table)
 	timeout = 200;
 	do {
 		ret = func->hif_block_tx(wilc, WILC_VMM_TBL_RX_SHADOW_BASE,
-					 (u8 *)vmm_table, (i + 1) * 4);
+					 (u8 *)vmm_table,
+					 (vmm_table_len + 1) * 4);
 		if (ret)
 			break;
 
@@ -899,7 +900,7 @@ static int send_packets(struct wilc *wilc, int len)
 
 int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 {
-	int i, entries, len;
+	int vmm_table_len, entries, len;
 	u8 ac_desired_ratio[NQUEUES] = {0, 0, 0, 0};
 	u8 vmm_entries_ac[WILC_VMM_TBL_SIZE];
 	int ret = 0;
@@ -919,13 +920,13 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 		wilc_wlan_txq_filter_dup_tcp_ack(vif->ndev);
 	srcu_read_unlock(&wilc->srcu, srcu_idx);
 
-	i = fill_vmm_table(wilc, ac_desired_ratio, vmm_table, vmm_entries_ac);
-	if (i == 0)
+	vmm_table_len = fill_vmm_table(wilc, ac_desired_ratio, vmm_table, vmm_entries_ac);
+	if (vmm_table_len == 0)
 		goto out_unlock;
 
 	acquire_bus(wilc, WILC_BUS_ACQUIRE_AND_WAKEUP);
 
-	ret = send_vmm_table(wilc, i, vmm_table);
+	ret = send_vmm_table(wilc, vmm_table_len, vmm_table);
 	if (ret <= 0) {
 		if (ret == 0)
 			/* No VMM space available in firmware.  Inform
-- 
2.25.1

