Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E7D69304C
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 12:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjBKL0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 06:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKL0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 06:26:07 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5909ED4
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 03:26:02 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pQo10-0000OS-4t; Sat, 11 Feb 2023 12:25:58 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pQo0w-004CUt-Og; Sat, 11 Feb 2023 12:25:55 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pQo0x-002fAh-9S; Sat, 11 Feb 2023 12:25:55 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH 2/2] net: stmmac: dwc-qos: Make struct dwc_eth_dwmac_data::remove return void
Date:   Sat, 11 Feb 2023 12:24:31 +0100
Message-Id: <20230211112431.214252-2-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230211112431.214252-1-u.kleine-koenig@pengutronix.de>
References: <20230211112431.214252-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2699; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=4BU461RB5eJjfSuBpdV/EuyEVzwdP4GItG87V7TBGiI=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBj53rrPM02aIhWnYFNYUsKWDZCfD/SwQRMXQEk8q/x kpNoXd+JATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCY+d66wAKCRDB/BR4rcrsCbGNCA CALtXK+Ez856iCqbWBmGtorFkSoNgj5mSf8VkP716wgxF6kyFJQfe4CieNhFAnU/8JC1f+UK9KWxWy kD1hLrPfh/bRc07nJAV8/VvnOMTTKCmkMjJ+7QMZSayrQ2VTgbMxF41mDfPTl3p3MpYxfKCs/uKQ/0 3od7marCMpUn6Kzypq0v+B2MdYAvSHZX6B5ANwPS2ikDih0phs1iPLm7XG6mbu4z8OvQ23d4ArmypO a6MfNCU4RQ7DT83nRZsAECQbRU0DJEmgHII9OEqqIb5JycyVbAkKfd7/FQYsdFMA7TqCu+wfkE4Xzu cr3nf6iVK8leN4r7A2TYqbA0lJnV4U
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All implementations of the remove callback return 0 unconditionally. So
in dwc_eth_dwmac_remove() there is no error handling necessary. Simplify
accordingly.

This is a preparation for making struct platform_driver::remove return
void, too.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 .../ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index 87a2c1a18638..18acf7dd74e5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -159,15 +159,13 @@ static int dwc_qos_probe(struct platform_device *pdev,
 	return err;
 }
 
-static int dwc_qos_remove(struct platform_device *pdev)
+static void dwc_qos_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
 
 	clk_disable_unprepare(priv->plat->pclk);
 	clk_disable_unprepare(priv->plat->stmmac_clk);
-
-	return 0;
 }
 
 #define SDMEMCOMPPADCTRL 0x8800
@@ -384,7 +382,7 @@ static int tegra_eqos_probe(struct platform_device *pdev,
 	return err;
 }
 
-static int tegra_eqos_remove(struct platform_device *pdev)
+static void tegra_eqos_remove(struct platform_device *pdev)
 {
 	struct tegra_eqos *eqos = get_stmmac_bsp_priv(&pdev->dev);
 
@@ -394,15 +392,13 @@ static int tegra_eqos_remove(struct platform_device *pdev)
 	clk_disable_unprepare(eqos->clk_rx);
 	clk_disable_unprepare(eqos->clk_slave);
 	clk_disable_unprepare(eqos->clk_master);
-
-	return 0;
 }
 
 struct dwc_eth_dwmac_data {
 	int (*probe)(struct platform_device *pdev,
 		     struct plat_stmmacenet_data *data,
 		     struct stmmac_resources *res);
-	int (*remove)(struct platform_device *pdev);
+	void (*remove)(struct platform_device *pdev);
 };
 
 static const struct dwc_eth_dwmac_data dwc_qos_data = {
@@ -473,19 +469,16 @@ static int dwc_eth_dwmac_remove(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	const struct dwc_eth_dwmac_data *data;
-	int err;
 
 	data = device_get_match_data(&pdev->dev);
 
 	stmmac_dvr_remove(&pdev->dev);
 
-	err = data->remove(pdev);
-	if (err < 0)
-		dev_err(&pdev->dev, "failed to remove subdriver: %d\n", err);
+	data->remove(pdev);
 
 	stmmac_remove_config_dt(pdev, priv->plat);
 
-	return err;
+	return 0;
 }
 
 static const struct of_device_id dwc_eth_dwmac_match[] = {
-- 
2.39.0

