Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1F247DD3D
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346927AbhLWBQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:39 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18340 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345812AbhLWBOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=P3vjFpDJHEWW7SWSpRLhpleR6qDxnZjgnmLnPz6G8BU=;
        b=snT890lOOe4TeW91I9cPz+4/ladedXzhvy20QFJaibRKlF6/txys+ynk2ZZrS/wIUfEJ
        oR2Z/TvDaVsvnrbuTeo/UCtZHDbWagzLAKSzX3V9G1gfhO7+Od6/BeUhjFO15UOxxVPrde
        oVWhUj5x3NqAn+oy3zK8yWeHgKqAlKgYlxgFNOGj9HAEr3be+oi20Pk7gr5tvhqaLQmQ8b
        z12UO4XVxiGoXNlf21CQGz2SVAhvQRkLf7vPEsg1Hll401WCLoEUlya/aAW/T7rrhKlNy+
        9bjKkH/uyBQJQX0nf0fXRMBR53pT2F5qmF+yCWdRrqwKcrufDd/OQCURTMH9ASdA==
Received: by filterdrecv-7bf5c69d5-5zdgz with SMTP id filterdrecv-7bf5c69d5-5zdgz-1-61C3CD5E-30
        2021-12-23 01:14:06.61160249 +0000 UTC m=+9687225.820325608
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-2-0 (SG)
        with ESMTP
        id 0V7qflYNS7iEC4FxhBJa7g
        Thu, 23 Dec 2021 01:14:06.475 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 5813070144B; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 23/50] wilc1000: introduce symbolic names for two
 tx-related control bits
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-24-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvJD+x2smqDgMhvITP?=
 =?us-ascii?Q?dFZ8LpvZ4l0gufVGuiwD1p5mR9rphOFgG4bG=2F4z?=
 =?us-ascii?Q?=2F+tkUCDTCYhl0x1an9kXtm6YdZV+BObQy6oSvJV?=
 =?us-ascii?Q?jFykJVgaD0+a9WFv6XrOO=2FV7MRySn1pTU56Eemm?=
 =?us-ascii?Q?iVFBjdIum8YLcYKz9wMKIXfIjq4GYeaMU4xvhP?=
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

I wish these registers were documented so I wouldn't have to guess at
their meanings and make up my own names.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 6 +++---
 drivers/net/wireless/microchip/wilc1000/wlan.h | 2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 27b1d317dc0c4..f82857cebe35e 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -675,7 +675,7 @@ static int fill_vmm_table(const struct wilc *wilc,
 					goto out;
 				vmm_table[i] = vmm_sz / 4;
 				if (tx_cb->type == WILC_CFG_PKT)
-					vmm_table[i] |= BIT(10);
+					vmm_table[i] |= WILC_VMM_CFG_PKT;
 
 				cpu_to_le32s(&vmm_table[i]);
 				vmm_entries_ac[i] = ac;
@@ -721,7 +721,7 @@ static int send_vmm_table(struct wilc *wilc, int i, const u32 *vmm_table)
 		if (ret)
 			break;
 
-		if ((reg & 0x1) == 0) {
+		if ((reg & WILC_HOST_TX_CTRL_BUSY) == 0) {
 			ac_update_fw_ac_pkt_info(wilc, reg);
 			break;
 		}
@@ -769,7 +769,7 @@ static int send_vmm_table(struct wilc *wilc, int i, const u32 *vmm_table)
 			ret = func->hif_read_reg(wilc, WILC_HOST_TX_CTRL, &reg);
 			if (ret)
 				break;
-			reg &= ~BIT(0);
+			reg &= ~WILC_HOST_TX_CTRL_BUSY;
 			ret = func->hif_write_reg(wilc, WILC_HOST_TX_CTRL, reg);
 		} else {
 			ret = entries;
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.h b/drivers/net/wireless/microchip/wilc1000/wlan.h
index 10618327133ce..f5d32ec93fdb9 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.h
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.h
@@ -224,6 +224,7 @@
 #define BE_AC_ACM_STAT_FIELD		BIT(8)
 #define BK_AC_COUNT_FIELD		GENMASK(7, 3)
 #define BK_AC_ACM_STAT_FIELD		BIT(1)
+#define WILC_HOST_TX_CTRL_BUSY		BIT(0)
 
 #define WILC_PKT_HDR_CONFIG_FIELD	BIT(31)
 #define WILC_PKT_HDR_OFFSET_FIELD	GENMASK(30, 22)
@@ -233,6 +234,7 @@
 #define WILC_INTERRUPT_DATA_SIZE	GENMASK(14, 0)
 
 #define WILC_VMM_BUFFER_SIZE		GENMASK(9, 0)
+#define WILC_VMM_CFG_PKT		BIT(10)
 
 #define WILC_VMM_HDR_TYPE		BIT(31)
 #define WILC_VMM_HDR_MGMT_FIELD		BIT(30)
-- 
2.25.1

