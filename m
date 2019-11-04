Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A317AEDCE1
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 11:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbfKDKv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 05:51:27 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:7980 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726364AbfKDKv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 05:51:27 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA4AonqB008086;
        Mon, 4 Nov 2019 11:51:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=STMicroelectronics;
 bh=Qaurhduesnw25w0jh3pIp/yKxoZ09ZwN/xuDw+l7BNo=;
 b=MDi01UsaPAO8xz8ft6zNnwdNE5PplDfS44Pz4LtEZhurX/UMtGwpBALwoTVtceYbxtZB
 fuJWU5XfdN5fn0JvoZTdL5hipFgSWtcXh3Hn8ZsldHmNZ8Ebhlbs2kVJ9R89oVSjkJy6
 oNF5gppFiaNOieDmc4Lwo2OPoBWBgab5lNiWeL4qL9W5lVtKY0vJMKF5JQkjgUMvd1sQ
 i/3ie0JVmeygrKmHufnYpqE530wbY/p5nMIcID4yiCIH/pA/MKUnC5DE0HEZmbaK8BQ0
 b2LDp4twHDFT0C4FZHEMFlaAxE5w10/IhV5PXsy3Ylm8S2Mr9imz/VFbE+rius8Werdv Ew== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2w0ytchmh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Nov 2019 11:51:05 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id B21BC100034;
        Mon,  4 Nov 2019 11:51:04 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas24.st.com [10.75.90.94])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 954D62BDA87;
        Mon,  4 Nov 2019 11:51:04 +0100 (CET)
Received: from SAFEX1HUBCAS21.st.com (10.75.90.45) by Safex1hubcas24.st.com
 (10.75.90.94) with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 4 Nov 2019
 11:51:04 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 4 Nov 2019 11:51:03
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH V2 1/1] net: ethernet: stmmac: drop unused variable in stm32mp1_set_mode()
Date:   Mon, 4 Nov 2019 11:51:00 +0100
Message-ID: <20191104105100.4288-1-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-04_07:2019-11-04,2019-11-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building with W=1 (cf.scripts/Makefile.extrawarn) outputs:
warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]

Drop the unused 'ret' variable.

Signed-off-by: Christophe Roullier <christophe.roullier@st.com>

---
V2: update commit message with Marc Gonzalez recommendation
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
index 4ef041bdf6a1..595af2ec89fb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
@@ -175,7 +175,7 @@ static int stm32mp1_set_mode(struct plat_stmmacenet_data *plat_dat)
 {
 	struct stm32_dwmac *dwmac = plat_dat->bsp_priv;
 	u32 reg = dwmac->mode_reg;
-	int val, ret;
+	int val;
 
 	switch (plat_dat->interface) {
 	case PHY_INTERFACE_MODE_MII:
@@ -211,8 +211,8 @@ static int stm32mp1_set_mode(struct plat_stmmacenet_data *plat_dat)
 	}
 
 	/* Need to update PMCCLRR (clear register) */
-	ret = regmap_write(dwmac->regmap, reg + SYSCFG_PMCCLRR_OFFSET,
-			   dwmac->ops->syscfg_eth_mask);
+	regmap_write(dwmac->regmap, reg + SYSCFG_PMCCLRR_OFFSET,
+		     dwmac->ops->syscfg_eth_mask);
 
 	/* Update PMCSETR (set register) */
 	return regmap_update_bits(dwmac->regmap, reg,
-- 
2.17.1

