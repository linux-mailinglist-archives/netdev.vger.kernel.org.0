Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C611E6E3BC7
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 22:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjDPUF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 16:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDPUF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 16:05:27 -0400
X-Greylist: delayed 545 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 16 Apr 2023 13:05:26 PDT
Received: from st43p00im-zteg10073501.me.com (st43p00im-zteg10073501.me.com [17.58.63.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2661FC4
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 13:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1681674979; bh=O2TgTgX7Cq2LJV67gutPlIPCO8dEwx+fpuc5YkEkMmg=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=XiM+52YdQzHlNrICnD+SpK/PumIEIs8y6iUR1ed6CEDCdOcJkhnx55KiZBI3ClnlR
         yt4rOX2A8yuFRrT7QadN9Wjsm/dycbOo7vNnI/0sfuycIH+MwwIzDO8mhLZ5n3set4
         l+JPOXApJelaJsInpXAQXEiH6gZpCZW+DgFT6aUvkxFGZ/zJjN+Z/igEp5wJpeoeX7
         WWJt46cw+Zg1gnIuVewk8LrJRxgdW6+MjO+JbxTHeKPEfI2SQ+uJ8vrQ+5Hx/BMhHU
         hV+jMVdnnuqa0lZPKLvUpyEfh6qohD7Xvv84a4V6myVVRuDshccQet2i5krPaAeLBm
         pbXbt3Gmo48JA==
Received: from localhost (st43p00im-dlb-asmtp-mailmevip.me.com [17.42.251.41])
        by st43p00im-zteg10073501.me.com (Postfix) with ESMTPSA id B440936071D;
        Sun, 16 Apr 2023 19:56:18 +0000 (UTC)
From:   Alain Volmat <avolmat@me.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     patrice.chotard@foss.st.com, Alain Volmat <avolmat@me.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: stmmac: dwmac-sti: remove stih415/stih416/stid127
Date:   Sun, 16 Apr 2023 21:55:23 +0200
Message-Id: <20230416195523.61075-1-avolmat@me.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: -BnxXXwNbnJuEUZ46-1HnoonediJYxBc
X-Proofpoint-ORIG-GUID: -BnxXXwNbnJuEUZ46-1HnoonediJYxBc
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.816,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-17=5F04:2020-02-14=5F02,2022-01-17=5F04,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 clxscore=1015 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2304160188
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove no more supported platforms (stih415/stih416 and stid127)

Signed-off-by: Alain Volmat <avolmat@me.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
Patch sent previously as part of serie: https://lore.kernel.org/all/20230209091659.1409-8-avolmat@me.com/

 .../net/ethernet/stmicro/stmmac/dwmac-sti.c   | 60 +------------------
 1 file changed, 1 insertion(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
index be3b1ebc06ab..465ce66ef9c1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
@@ -35,7 +35,7 @@
 #define IS_PHY_IF_MODE_GBIT(iface)	(IS_PHY_IF_MODE_RGMII(iface) || \
 					 iface == PHY_INTERFACE_MODE_GMII)
 
-/* STiH4xx register definitions (STiH415/STiH416/STiH407/STiH410 families)
+/* STiH4xx register definitions (STiH407/STiH410 families)
  *
  * Below table summarizes the clock requirement and clock sources for
  * supported phy interface modes with link speeds.
@@ -75,27 +75,6 @@
 #define STIH4XX_ETH_SEL_INTERNAL_NOTEXT_PHYCLK	BIT(7)
 #define STIH4XX_ETH_SEL_TXCLK_NOT_CLK125	BIT(6)
 
-/* STiD127 register definitions
- *-----------------------
- * src	 |BIT(6)| BIT(7)|
- *-----------------------
- * MII   |  1	|   n/a	|
- *-----------------------
- * RMII  |  n/a	|   1	|
- * clkgen|	|	|
- *-----------------------
- * RMII  |  n/a	|   0	|
- * phyclk|	|	|
- *-----------------------
- * RGMII |  1	|  n/a	|
- * clkgen|	|	|
- *-----------------------
- */
-
-#define STID127_RETIME_SRC_MASK			GENMASK(7, 6)
-#define STID127_ETH_SEL_INTERNAL_NOTEXT_PHYCLK	BIT(7)
-#define STID127_ETH_SEL_INTERNAL_NOTEXT_TXCLK	BIT(6)
-
 #define ENMII_MASK	GENMASK(5, 5)
 #define ENMII		BIT(5)
 #define EN_MASK		GENMASK(1, 1)
@@ -194,36 +173,6 @@ static void stih4xx_fix_retime_src(void *priv, u32 spd)
 			   stih4xx_tx_retime_val[src]);
 }
 
-static void stid127_fix_retime_src(void *priv, u32 spd)
-{
-	struct sti_dwmac *dwmac = priv;
-	u32 reg = dwmac->ctrl_reg;
-	u32 freq = 0;
-	u32 val = 0;
-
-	if (dwmac->interface == PHY_INTERFACE_MODE_MII) {
-		val = STID127_ETH_SEL_INTERNAL_NOTEXT_TXCLK;
-	} else if (dwmac->interface == PHY_INTERFACE_MODE_RMII) {
-		if (!dwmac->ext_phyclk) {
-			val = STID127_ETH_SEL_INTERNAL_NOTEXT_PHYCLK;
-			freq = DWMAC_50MHZ;
-		}
-	} else if (IS_PHY_IF_MODE_RGMII(dwmac->interface)) {
-		val = STID127_ETH_SEL_INTERNAL_NOTEXT_TXCLK;
-		if (spd == SPEED_1000)
-			freq = DWMAC_125MHZ;
-		else if (spd == SPEED_100)
-			freq = DWMAC_25MHZ;
-		else if (spd == SPEED_10)
-			freq = DWMAC_2_5MHZ;
-	}
-
-	if (freq)
-		clk_set_rate(dwmac->clk, freq);
-
-	regmap_update_bits(dwmac->regmap, reg, STID127_RETIME_SRC_MASK, val);
-}
-
 static int sti_dwmac_set_mode(struct sti_dwmac *dwmac)
 {
 	struct regmap *regmap = dwmac->regmap;
@@ -408,14 +357,7 @@ static const struct sti_dwmac_of_data stih4xx_dwmac_data = {
 	.fix_retime_src = stih4xx_fix_retime_src,
 };
 
-static const struct sti_dwmac_of_data stid127_dwmac_data = {
-	.fix_retime_src = stid127_fix_retime_src,
-};
-
 static const struct of_device_id sti_dwmac_match[] = {
-	{ .compatible = "st,stih415-dwmac", .data = &stih4xx_dwmac_data},
-	{ .compatible = "st,stih416-dwmac", .data = &stih4xx_dwmac_data},
-	{ .compatible = "st,stid127-dwmac", .data = &stid127_dwmac_data},
 	{ .compatible = "st,stih407-dwmac", .data = &stih4xx_dwmac_data},
 	{ }
 };
-- 
2.34.1

