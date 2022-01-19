Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B349549341F
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 05:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351553AbiASExS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 23:53:18 -0500
Received: from mo-csw1515.securemx.jp ([210.130.202.154]:49738 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351546AbiASExR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 23:53:17 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id 20J4qHiP010223; Wed, 19 Jan 2022 13:52:18 +0900
X-Iguazu-Qid: 34trEBPRjez1XDs3Pd
X-Iguazu-QSIG: v=2; s=0; t=1642567937; q=34trEBPRjez1XDs3Pd; m=aosDiG3bchN5bA2fkb+lKSgUundvPjPEDj8C0koca20=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1511) id 20J4qG7J028765
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Jan 2022 13:52:16 +0900
X-SA-MID: 30555174
From:   Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nobuhiro1.iwamatsu@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp
Subject: [PATCH v2 1/2] net: stmmac: dwmac-visconti: Fix bit definitions for ETHER_CLK_SEL
Date:   Wed, 19 Jan 2022 13:46:47 +0900
X-TSB-HOP: ON
X-TSB-HOP2: ON
Message-Id: <20220119044648.18094-2-yuji2.ishikawa@toshiba.co.jp>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220119044648.18094-1-yuji2.ishikawa@toshiba.co.jp>
References: <20220119044648.18094-1-yuji2.ishikawa@toshiba.co.jp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

just 0 should be used to represent cleared bits

* ETHER_CLK_SEL_DIV_SEL_20
* ETHER_CLK_SEL_TX_CLK_EXT_SEL_IN
* ETHER_CLK_SEL_RX_CLK_EXT_SEL_IN
* ETHER_CLK_SEL_TX_CLK_O_TX_I
* ETHER_CLK_SEL_RMII_CLK_SEL_IN

Fixes: b38dd98ff8d0 ("net: stmmac: Add Toshiba Visconti SoCs glue driver")
Signed-off-by: Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
Reviewed-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
index e2e0f9778..43a446cea 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -22,21 +22,21 @@
 #define ETHER_CLK_SEL_RMII_CLK_EN BIT(2)
 #define ETHER_CLK_SEL_RMII_CLK_RST BIT(3)
 #define ETHER_CLK_SEL_DIV_SEL_2 BIT(4)
-#define ETHER_CLK_SEL_DIV_SEL_20 BIT(0)
+#define ETHER_CLK_SEL_DIV_SEL_20 0
 #define ETHER_CLK_SEL_FREQ_SEL_125M	(BIT(9) | BIT(8))
 #define ETHER_CLK_SEL_FREQ_SEL_50M	BIT(9)
 #define ETHER_CLK_SEL_FREQ_SEL_25M	BIT(8)
 #define ETHER_CLK_SEL_FREQ_SEL_2P5M	0
-#define ETHER_CLK_SEL_TX_CLK_EXT_SEL_IN BIT(0)
+#define ETHER_CLK_SEL_TX_CLK_EXT_SEL_IN 0
 #define ETHER_CLK_SEL_TX_CLK_EXT_SEL_TXC BIT(10)
 #define ETHER_CLK_SEL_TX_CLK_EXT_SEL_DIV BIT(11)
-#define ETHER_CLK_SEL_RX_CLK_EXT_SEL_IN  BIT(0)
+#define ETHER_CLK_SEL_RX_CLK_EXT_SEL_IN  0
 #define ETHER_CLK_SEL_RX_CLK_EXT_SEL_RXC BIT(12)
 #define ETHER_CLK_SEL_RX_CLK_EXT_SEL_DIV BIT(13)
-#define ETHER_CLK_SEL_TX_CLK_O_TX_I	 BIT(0)
+#define ETHER_CLK_SEL_TX_CLK_O_TX_I	 0
 #define ETHER_CLK_SEL_TX_CLK_O_RMII_I	 BIT(14)
 #define ETHER_CLK_SEL_TX_O_E_N_IN	 BIT(15)
-#define ETHER_CLK_SEL_RMII_CLK_SEL_IN	 BIT(0)
+#define ETHER_CLK_SEL_RMII_CLK_SEL_IN	 0
 #define ETHER_CLK_SEL_RMII_CLK_SEL_RX_C	 BIT(16)
 
 #define ETHER_CLK_SEL_RX_TX_CLK_EN (ETHER_CLK_SEL_RX_CLK_EN | ETHER_CLK_SEL_TX_CLK_EN)
-- 
2.17.1


