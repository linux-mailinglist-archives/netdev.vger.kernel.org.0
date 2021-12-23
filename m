Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F49647DFF5
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 08:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbhLWHzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 02:55:49 -0500
Received: from mo-csw-fb1115.securemx.jp ([210.130.202.174]:53982 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbhLWHzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 02:55:49 -0500
X-Greylist: delayed 1111 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Dec 2021 02:55:48 EST
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1115) id 1BN7bHj7026402; Thu, 23 Dec 2021 16:37:18 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 1BN7adcW008795; Thu, 23 Dec 2021 16:36:40 +0900
X-Iguazu-Qid: 2wHI0yQhQ8hP2HHHqV
X-Iguazu-QSIG: v=2; s=0; t=1640244999; q=2wHI0yQhQ8hP2HHHqV; m=qKf+CMBUuKdT3FU747l1zYcu/o0MDRoKty3UCBazYIc=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1112) id 1BN7abRJ007928
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Dec 2021 16:36:38 +0900
Received: from enc01.toshiba.co.jp (enc01.toshiba.co.jp [106.186.93.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx2-a.toshiba.co.jp (Postfix) with ESMTPS id 824B81000FC;
        Thu, 23 Dec 2021 16:36:37 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 1BN7aYCi017417;
        Thu, 23 Dec 2021 16:36:37 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        yuji2.ishikawa@toshiba.co.jp, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH] net: stmmac: dwmac-visconti: Fix value of ETHER_CLK_SEL_FREQ_SEL_2P5M
Date:   Thu, 23 Dec 2021 16:36:33 +0900
X-TSB-HOP: ON
Message-Id: <20211223073633.101306-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ETHER_CLK_SEL_FREQ_SEL_2P5M is not 0 bit of the register. This is a
value, which is 0. Fix from BIT(0) to 0.

Reported-by: Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
index 66fc8be34bb7..e2e0f977875d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -26,7 +26,7 @@
 #define ETHER_CLK_SEL_FREQ_SEL_125M	(BIT(9) | BIT(8))
 #define ETHER_CLK_SEL_FREQ_SEL_50M	BIT(9)
 #define ETHER_CLK_SEL_FREQ_SEL_25M	BIT(8)
-#define ETHER_CLK_SEL_FREQ_SEL_2P5M	BIT(0)
+#define ETHER_CLK_SEL_FREQ_SEL_2P5M	0
 #define ETHER_CLK_SEL_TX_CLK_EXT_SEL_IN BIT(0)
 #define ETHER_CLK_SEL_TX_CLK_EXT_SEL_TXC BIT(10)
 #define ETHER_CLK_SEL_TX_CLK_EXT_SEL_DIV BIT(11)
-- 
2.34.1


