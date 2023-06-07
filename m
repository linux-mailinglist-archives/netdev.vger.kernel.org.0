Return-Path: <netdev+bounces-8829-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9376A725E10
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:09:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F02EA1C20D8F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:09:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB2933CBC;
	Wed,  7 Jun 2023 12:08:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF25130B90
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 12:08:32 +0000 (UTC)
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603191BE6;
	Wed,  7 Jun 2023 05:08:29 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686139708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GrgFo3H2q3uXB3KxPepXLazZqm3F9wUP/Ceq11kw4Q8=;
	b=nm3p9FV59L0k4MrGfuiIlocHxtlxOZzyPfwuLhO6PHUtoWG0jIeVTzi63C4dLmHlIzmhWP
	HC4I3WsB1dkwCA37y5K9fl2xlurC93+5OeM7N9Hc9mamvRkgaElDfx846Rbhu39HgBoPnN
	eoU+89Wdvfu06pVv6cDMjU9DtJQ6vMpPDlIdOjhi+WuMfGwGQxRtKljK+tMB7YExKjjmKf
	IZg0cjpAgq8eazVFhPUh3vHZy1fsravHOhrgVo6zhIA7Zl6oauZcN7bf8T0X3+ymndnRHO
	6/BN+g5frqE7XVHKTSlsbV7ggCya8VnZlWSs2CoA/OL6ZcWWBRuMYFOtprcezA==
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 94C32E0007;
	Wed,  7 Jun 2023 12:08:25 +0000 (UTC)
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: davem@davemloft.net
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	alexis.lothore@bootlin.com,
	thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Simon Horman <simon.horman@corigine.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Feiyang Chen <chenfeiyang@loongson.cn>,
	Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v4 5/5] net: dwmac_socfpga: initialize local data for mdio regmap configuration
Date: Wed,  7 Jun 2023 15:59:41 +0200
Message-Id: <20230607135941.407054-6-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607135941.407054-1-maxime.chevallier@bootlin.com>
References: <20230607135941.407054-1-maxime.chevallier@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Explicitely zero-ize the local mdio_regmap_config data, and explicitely
set the .autoscan parameter, as we only have a PCS on this bus.

Fixes: 5d1f3fe7d2d5 ("net: stmmac: dwmac-sogfpga: use the lynx pcs driver")
Suggested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V3->V4 : Move pcs_regmap_cfg into a more local block, and zeroize mrc
V2->V3 : New patch

 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c   | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index 1fb808be843b..6267bcb60206 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -389,7 +389,6 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
 	struct net_device	*ndev;
 	struct stmmac_priv	*stpriv;
 	const struct socfpga_dwmac_ops *ops;
-	struct regmap_config pcs_regmap_cfg;
 
 	ops = device_get_match_data(&pdev->dev);
 	if (!ops) {
@@ -447,19 +446,22 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_dvr_remove;
 
-	memset(&pcs_regmap_cfg, 0, sizeof(pcs_regmap_cfg));
-	pcs_regmap_cfg.reg_bits = 16;
-	pcs_regmap_cfg.val_bits = 16;
-	pcs_regmap_cfg.reg_shift = REGMAP_UPSHIFT(1);
-
 	/* Create a regmap for the PCS so that it can be used by the PCS driver,
 	 * if we have such a PCS
 	 */
 	if (dwmac->tse_pcs_base) {
+		struct regmap_config pcs_regmap_cfg;
 		struct mdio_regmap_config mrc;
 		struct regmap *pcs_regmap;
 		struct mii_bus *pcs_bus;
 
+		memset(&pcs_regmap_cfg, 0, sizeof(pcs_regmap_cfg));
+		memset(&mrc, 0, sizeof(mrc));
+
+		pcs_regmap_cfg.reg_bits = 16;
+		pcs_regmap_cfg.val_bits = 16;
+		pcs_regmap_cfg.reg_shift = REGMAP_UPSHIFT(1);
+
 		pcs_regmap = devm_regmap_init_mmio(&pdev->dev, dwmac->tse_pcs_base,
 						   &pcs_regmap_cfg);
 		if (IS_ERR(pcs_regmap)) {
@@ -470,6 +472,7 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
 		mrc.regmap = pcs_regmap;
 		mrc.parent = &pdev->dev;
 		mrc.valid_addr = 0x0;
+		mrc.autoscan = false;
 
 		snprintf(mrc.name, MII_BUS_ID_SIZE, "%s-pcs-mii", ndev->name);
 		pcs_bus = devm_mdio_regmap_register(&pdev->dev, &mrc);
-- 
2.40.1


