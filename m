Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7265E47DD3F
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345814AbhLWBQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:41 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18698 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238646AbhLWBOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=3Uz4xO2jk3PwsoBap/NCYCWsUTTJtakQF5q2JJp4lHQ=;
        b=AZzNDwI6isj4Br0GlK+kU9dM02F55UA7gnqhdWD4g8J9QC8JK5gEL8nqvU30FKtTH49i
        NSw1KGcWfQOGA6WrxwehnMkuTcELkuhfmyefoefLBvWE8H8C9g3zI6qunfFcje3ESFh+is
        0nX4c6szL6ltEyjbImHFOT7Uoi7/3YZ7D5Wz3p5PJVqUCheDVgkPrEd9SwH7QjuryPS1pn
        SQM/GiZHMfnD0rqlnpcHOtg3IqPsbkbUSP7KTY4rm6honUjP9v0kMWvSgrqc/29aIsCmui
        ICFxsO7sEc2wao74pm2osw1hddjyx5g+Mb2B5P4Ui4DRYXJ1TdE0/ij+1QXT/JgQ==
Received: by filterdrecv-656998cfdd-ngmx2 with SMTP id filterdrecv-656998cfdd-ngmx2-1-61C3CD5E-3B
        2021-12-23 01:14:07.038024374 +0000 UTC m=+7955207.334259020
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-0 (SG)
        with ESMTP
        id qOYqVE5dTvSY-kPoDwTdQg
        Thu, 23 Dec 2021 01:14:06.874 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id C5063701508; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 41/50] wilc1000: use more descriptive variable name
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-42-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvPuMcF=2FBHm6zz5zzm?=
 =?us-ascii?Q?psOhjqu7S67FdJWIs8jvoN5AmbDIi6dQ8lNtN54?=
 =?us-ascii?Q?xxhDmyuQ276OPAzpKlpaoXNFiJAEfxpKnM8rU0u?=
 =?us-ascii?Q?2vnGeKcOiwzmhFwF+u20ZkuFymVbl8xOc4s9kXK?=
 =?us-ascii?Q?IJfBLZzHwUBw=2FC4hINcpZvxIEOEj7pFe6uT6T7?=
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

Now that the factoring is done, again rename "i" to "vmm_table_len" to
improve readability.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/wlan.c    | 31 +++++++++----------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index f01f7bade6189..f89ea4839aa61 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -681,7 +681,7 @@ static void set_header(struct wilc *wilc, struct sk_buff *tqe,
  * WILC_VMM_TBL_SIZE packets or up to WILC_TX_BUFF_SIZE bytes.
  */
 static int schedule_packets(struct wilc *wilc,
-			    int i, u32 vmm_table[WILC_VMM_TBL_SIZE])
+			    int vmm_table_len, u32 vmm_table[WILC_VMM_TBL_SIZE])
 {
 	u8 k, ac;
 	static const u8 ac_preserve_ratio[NQUEUES] = {1, 1, 1, 1};
@@ -702,8 +702,8 @@ static int schedule_packets(struct wilc *wilc,
 
 			ac_exist = 1;
 			for (k = 0; k < num_pkts_to_add[ac]; k++) {
-				if (i >= WILC_VMM_TBL_SIZE - 1)
-					return i;
+				if (vmm_table_len >= WILC_VMM_TBL_SIZE - 1)
+					return vmm_table_len;
 
 				tqe = skb_dequeue(&wilc->txq[ac]);
 				if (!tqe)
@@ -717,21 +717,21 @@ static int schedule_packets(struct wilc *wilc,
 				if (wilc->chipq_bytes + vmm_sz > WILC_TX_BUFF_SIZE) {
 					/* return packet to its queue */
 					skb_queue_head(&wilc->txq[ac], tqe);
-					return i;
+					return vmm_table_len;
 				}
 				atomic_dec(&wilc->txq_entries);
 
 				__skb_queue_tail(&wilc->chipq, tqe);
 				wilc->chipq_bytes += tqe->len;
 
-				vmm_table[i] = vmm_table_entry(tqe, vmm_sz);
-				i++;
+				vmm_table[vmm_table_len] = vmm_table_entry(tqe, vmm_sz);
+				vmm_table_len++;
 
 			}
 		}
 		num_pkts_to_add = ac_preserve_ratio;
 	} while (ac_exist);
-	return i;
+	return vmm_table_len;
 }
 
 /**
@@ -747,13 +747,10 @@ static int schedule_packets(struct wilc *wilc,
  */
 static int fill_vmm_table(struct wilc *wilc, u32 vmm_table[WILC_VMM_TBL_SIZE])
 {
-	int i;
-	int vmm_sz = 0;
+	int vmm_table_len = 0, vmm_sz = 0;
 	struct sk_buff *tqe;
 	struct wilc_skb_tx_cb *tx_cb;
 
-	i = 0;
-
 	if (unlikely(wilc->chipq_bytes > 0)) {
 		/* fill in packets that are already on the chipq: */
 		skb_queue_walk(&wilc->chipq, tqe) {
@@ -761,16 +758,16 @@ static int fill_vmm_table(struct wilc *wilc, u32 vmm_table[WILC_VMM_TBL_SIZE])
 			vmm_sz = tx_hdr_len(tx_cb->type);
 			vmm_sz += tqe->len;
 			vmm_sz = ALIGN(vmm_sz, 4);
-			vmm_table[i++] = vmm_table_entry(tqe, vmm_sz);
+			vmm_table[vmm_table_len++] = vmm_table_entry(tqe, vmm_sz);
 		}
 	}
 
-	i = schedule_packets(wilc, i, vmm_table);
-	if (i > 0) {
-		WARN_ON(i >= WILC_VMM_TBL_SIZE);
-		vmm_table[i] = 0x0;
+	vmm_table_len = schedule_packets(wilc, vmm_table_len, vmm_table);
+	if (vmm_table_len > 0) {
+		WARN_ON(vmm_table_len >= WILC_VMM_TBL_SIZE);
+		vmm_table[vmm_table_len] = 0x0;
 	}
-	return i;
+	return vmm_table_len;
 }
 
 /**
-- 
2.25.1

