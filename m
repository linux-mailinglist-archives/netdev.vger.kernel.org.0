Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 621E3EDAA2
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 09:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfKDIfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 03:35:11 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:50545 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726633AbfKDIfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 03:35:11 -0500
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA48WDmY020782;
        Mon, 4 Nov 2019 09:34:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=STMicroelectronics;
 bh=kUIJgRUYCwvUGrw3/RFfJamPn8ewXorlKg57BCT1g9k=;
 b=ggTtJZfbLXrpe7IVac3NHsuCCM1T0mR+J5gz2uZVeltPsXpyBplF1EeNGCcOF2MKq+c2
 AuhouYABvIY1Le9BTCb5rG1SRKg5dG89gUPzd6sOdbfY+guwi6g6l00sc1ViEU6Ft/kj
 r1+pDVPfGja3agydPg0IsIPnIXC0ojIrVfM9zhehFNm+KfhQTHegYcvmoeR2H1TI9kIN
 XuyJmV+bJSZFYLCKVzyb/2HiQC1ODqFjMcS4jLGuaAmnYGKX7uBxXqetfmm+xvEhTrDH
 p62zM52eZdKPnBhKRedpwVkfDZpKNiQ/zxyt+hNtBrj57wh7uCdFIzMHjKJUKVdcsy0W 8Q== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2w10f188yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Nov 2019 09:34:49 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 346E1100039;
        Mon,  4 Nov 2019 09:34:47 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas22.st.com [10.75.90.92])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 139D12AD33A;
        Mon,  4 Nov 2019 09:34:47 +0100 (CET)
Received: from SAFEX1HUBCAS21.st.com (10.75.90.45) by Safex1hubcas22.st.com
 (10.75.90.92) with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 4 Nov 2019
 09:34:46 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 4 Nov 2019 09:34:46
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH  1/1] net: ethernet: stmmac: fix warning when w=1 option is used during build
Date:   Mon, 4 Nov 2019 09:34:38 +0100
Message-ID: <20191104083438.8288-1-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-04_06:2019-11-01,2019-11-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fix the following warning:

warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
  int val, ret;

Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
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

