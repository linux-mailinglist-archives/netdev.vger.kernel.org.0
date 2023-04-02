Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5596D385D
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 16:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjDBObG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 10:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjDBObA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 10:31:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B28886AF
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 07:30:58 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjH-0002tt-6Y; Sun, 02 Apr 2023 16:30:47 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjE-008TQs-W8; Sun, 02 Apr 2023 16:30:45 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjD-009zBh-TB; Sun, 02 Apr 2023 16:30:43 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH net-next 07/11] net: stmmac: dwmac-rk: Convert to platform remove callback returning void
Date:   Sun,  2 Apr 2023 16:30:21 +0200
Message-Id: <20230402143025.2524443-8-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1732; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=fxCKmEymoJYPgVGLdcyiZGDvDmj2Rlb4SVqHmzyzH00=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkKZF2RCEdp1Q7CskjV1JbaY49EPedD3TRBx+DE TSws19dxNGJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZCmRdgAKCRCPgPtYfRL+ TjdWB/0dNSQIBoq68nKj6Gl+9ipcJ/l8eThXCjQiW9Q2QGztjrQPYPpp3QJThHwujfadCM/2cuv yQ0rD0qVd0puIS5sZHdN1HEtsglv5UsERAL/pXEKPJMqXaG5+c4eR52dU5o2D+Ygys0K00sH2OW U+Rvsy/8JUlMxvR+S4rFYEcWDPK3P6lW/au6VuUZfYoOoJmcbW/Dl4AKKxuwOpo5TMbdOhliqz/ 1T2DM8/UZBy3pjoCiezGHpDNdH9GZH4eZgyH/87CwPYuBntZtVe+onSmeho/VL/jfm/M8yp4H9J jJtJqXkjOpaiWz+44fujxrgf7MxifRgapiIsy/HgVgB9Krqm
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
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 4b8fd11563e4..82b23d182db6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1912,15 +1912,13 @@ static int rk_gmac_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int rk_gmac_remove(struct platform_device *pdev)
+static void rk_gmac_remove(struct platform_device *pdev)
 {
 	struct rk_priv_data *bsp_priv = get_stmmac_bsp_priv(&pdev->dev);
 
 	stmmac_dvr_remove(&pdev->dev);
 
 	rk_gmac_powerdown(bsp_priv);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -1974,7 +1972,7 @@ MODULE_DEVICE_TABLE(of, rk_gmac_dwmac_match);
 
 static struct platform_driver rk_gmac_dwmac_driver = {
 	.probe  = rk_gmac_probe,
-	.remove = rk_gmac_remove,
+	.remove_new = rk_gmac_remove,
 	.driver = {
 		.name           = "rk_gmac-dwmac",
 		.pm		= &rk_gmac_pm_ops,
-- 
2.39.2

