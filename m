Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A15B491F27
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 06:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239769AbiARFw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 00:52:57 -0500
Received: from mo-csw-fb1515.securemx.jp ([210.130.202.171]:57876 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239742AbiARFw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 00:52:56 -0500
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jan 2022 00:52:56 EST
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1515) id 20I5k9f8032622; Tue, 18 Jan 2022 14:46:10 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id 20I5jjnr006451; Tue, 18 Jan 2022 14:45:45 +0900
X-Iguazu-Qid: 34trEBPRjdLYs2IbyW
X-Iguazu-QSIG: v=2; s=0; t=1642484744; q=34trEBPRjdLYs2IbyW; m=528tXebc3ETxb6iOW3urXJxBf10IaN7YaOPM9/hwg+4=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1512) id 20I5jhQl013820
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Jan 2022 14:45:44 +0900
X-SA-MID: 30475371
From:   Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nobuhiro1.iwamatsu@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp
Subject: [PATCH 1/2] net: stmmac: dwmac-visconti: Fix bit definitions for ETHER_CLK_SEL
Date:   Tue, 18 Jan 2022 14:39:49 +0900
X-TSB-HOP: ON
X-TSB-HOP2: ON
Message-Id: <20220118053950.2605-2-yuji2.ishikawa@toshiba.co.jp>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220118053950.2605-1-yuji2.ishikawa@toshiba.co.jp>
References: <20220118053950.2605-1-yuji2.ishikawa@toshiba.co.jp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

just 0 should be used to represent cleared bits

* ETHER_CLK_SEL_DIV_SEL_20
* ETHER_CLK_SEL_TX_CLK_EXT_SEL_IN
* ETHER_CLK_SEL_RX_CLK_EXT_SEL_IN
* ETHER_CLK_SEL_TX_CLK_O_TX_I
* ETHER_CLK_SEL_RMII_CLK_SEL_IN

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


