Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A0D6D385F
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 16:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjDBObK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 10:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjDBObG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 10:31:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11799CC24
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 07:31:05 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjH-0002u0-6X; Sun, 02 Apr 2023 16:30:47 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjF-008TR2-GS; Sun, 02 Apr 2023 16:30:45 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjE-009zBw-S8; Sun, 02 Apr 2023 16:30:44 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 11/11] net: stmmac: dwmac-tegra: Convert to platform remove callback returning void
Date:   Sun,  2 Apr 2023 16:30:25 +0200
Message-Id: <20230402143025.2524443-12-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1839; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=uHRt5tyID3sy+YzsWmQL2tOBQyY0bRA4sv5Z8ygAGyI=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkKZF6OE52KDsYV5Xv4yliz34sJ3jBSH6VKfon7 qZzKvPQ5e2JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZCmRegAKCRCPgPtYfRL+ TqCkB/9hKeMJ3O43PWdOHFqnTLSpwqfROPoS7HtPBbrTtAwRh/OwtyTpBNmMH52FjwQGw4tKLt6 d9eAz6u+JGxYCqfzn3KZ2t1mSIg6HmEgSoyYADzwN3/ar0BvYOHrU25/0qzf6WuW6s/MdYbzfNV VrFBKNO2Eq65hLFEA0hvrVpmq5h8Aj3aayg9LuaGAJX1C4b5z2193DEl7BVs96WjZzprOcym8yD FYOcIpvJzL4dVQOcdquOMH422VFn/jr0FyHWuEV0QQMLflKPNrOEVVL13pmV9NoEUmhvdeqqojq bYQTjC2zTKV+ibEsMoIIAkMm8kwO1peDBNPtqJ/8PChmbyhC
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
index bdf990cf2f31..f8367c5b490b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
@@ -353,15 +353,13 @@ static int tegra_mgbe_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int tegra_mgbe_remove(struct platform_device *pdev)
+static void tegra_mgbe_remove(struct platform_device *pdev)
 {
 	struct tegra_mgbe *mgbe = get_stmmac_bsp_priv(&pdev->dev);
 
 	clk_bulk_disable_unprepare(ARRAY_SIZE(mgbe_clks), mgbe->clks);
 
 	stmmac_pltfr_remove(pdev);
-
-	return 0;
 }
 
 static const struct of_device_id tegra_mgbe_match[] = {
@@ -374,7 +372,7 @@ static SIMPLE_DEV_PM_OPS(tegra_mgbe_pm_ops, tegra_mgbe_suspend, tegra_mgbe_resum
 
 static struct platform_driver tegra_mgbe_driver = {
 	.probe = tegra_mgbe_probe,
-	.remove = tegra_mgbe_remove,
+	.remove_new = tegra_mgbe_remove,
 	.driver = {
 		.name = "tegra-mgbe",
 		.pm		= &tegra_mgbe_pm_ops,
-- 
2.39.2

