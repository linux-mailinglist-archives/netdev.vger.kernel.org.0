Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1317E479E67
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbhLRXzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:55:00 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25724 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234962AbhLRXyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=sinBnLCkTHw0t/yG9XyJF667Cq9tEjWOwIYZimlz2fI=;
        b=oMcJxPsyVLauYPrdCbrnJ+MOBf7W0JPsXJMtsJJ/sw2QAipj5tjZaOJpRtEHX9jfhvwd
        1yGbdOMgg0TuEwCJhl74LbshNcmJZT8q53UvscoHnSkf08aC9CfCaKHv2K0oM6NBGlg04C
        NbCOKRqBZUY6OCJTvJ9oTkkvJGBaLwUqLkWfxWbwHG8447zcSHraPz8g3/MLuN+MggTcA3
        7/bZHNuEOlXFR9W9PD5Pf6+O73qDiThuloEdHr/Fhiya1PY3eF5NvjId6CcdeK4JzepojG
        ArvM4p58tVKfwClqQgaC3WRkfzuZqCUoAq+qjPb/CeET/QuZMvYTMBD9LaIr46kQ==
Received: by filterdrecv-656998cfdd-vtnvg with SMTP id filterdrecv-656998cfdd-vtnvg-1-61BE74A9-6
        2021-12-18 23:54:17.271696307 +0000 UTC m=+7604818.321476290
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-4-1 (SG)
        with ESMTP
        id qiWQH8zgTK2qOWAia0hduw
        Sat, 18 Dec 2021 23:54:17.110 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id E35AD701463; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 23/23] wilc1000: introduce symbolic names for two tx-related
 control bits
Date:   Sat, 18 Dec 2021 23:54:17 +0000 (UTC)
Message-Id: <20211218235404.3963475-24-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvJSzRgudYonBolmfI?=
 =?us-ascii?Q?0YU2DoSFm5tqSCL4wZQyH3747ovQKXVWM8m16oO?=
 =?us-ascii?Q?Q0L2V7G0GjotG2D4xN5xA=2FnEHEKuDcJ9Kkj8bd2?=
 =?us-ascii?Q?bvHhWi=2F6aol4sAmQqedGIfgEfhGtNmWt0XmFuXV?=
 =?us-ascii?Q?TOykQ9D2xSysST1PMeTGeYOQuGvnmE7sgHujq9?=
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

I wish these registers were documented so I wouldn't have to guess at
their meanings and make up my own names.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 6 +++---
 drivers/net/wireless/microchip/wilc1000/wlan.h | 2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 4ec23b2b2da05..b7a792edea187 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -672,7 +672,7 @@ static int fill_vmm_table(const struct wilc *wilc,
 					goto out;
 				vmm_table[i] = vmm_sz / 4;
 				if (tx_cb->type == WILC_CFG_PKT)
-					vmm_table[i] |= BIT(10);
+					vmm_table[i] |= WILC_VMM_CFG_PKT;
 
 				cpu_to_le32s(&vmm_table[i]);
 				vmm_entries_ac[i] = ac;
@@ -715,7 +715,7 @@ static int send_vmm_table(struct wilc *wilc, int i, const u32 *vmm_table)
 		if (ret)
 			break;
 
-		if ((reg & 0x1) == 0) {
+		if ((reg & WILC_HOST_TX_CTRL_BUSY) == 0) {
 			ac_update_fw_ac_pkt_info(wilc, reg);
 			break;
 		}
@@ -763,7 +763,7 @@ static int send_vmm_table(struct wilc *wilc, int i, const u32 *vmm_table)
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

