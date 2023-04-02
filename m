Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4BE6D3857
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 16:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjDBObB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 10:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDBOa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 10:30:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DEC61B9
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 07:30:58 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjH-0002tr-6X; Sun, 02 Apr 2023 16:30:47 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjE-008TQo-QC; Sun, 02 Apr 2023 16:30:44 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjE-009zBk-2b; Sun, 02 Apr 2023 16:30:44 +0200
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
Subject: [PATCH net-next 08/11] net: stmmac: dwmac-sti: Convert to platform remove callback returning void
Date:   Sun,  2 Apr 2023 16:30:22 +0200
Message-Id: <20230402143025.2524443-9-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1735; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=KivXKxRyqI3WawoIAPjybxyqKCwHtoiZ7mSUfAXtNE4=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkKZF370O0m/BcWNpD14Twd9p/kLgcsapIrngAR iVPe6lMO7CJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZCmRdwAKCRCPgPtYfRL+ TvVpCACyGr/ohhtUx6SP6GMQO7OzrMM96PrazEV3nvKWiBst1qUQ3BBKTHYEMxYfbp9awowSCpu ErKsn35aFiGOK3e9ZdXeYr1Acs7X9EhzqdFgP8RxgufV6yR3vt/xLZ9efOif9KzHG5uIXTrNMJ2 l62VpesnP7A++hChVowShc4q1Oep3KOY23InIbozdYC0cjY1QW5P6fOXUV2OZ0nGIKu4YQd9nsB xPBcDgX6aQC4igwkRt8jCa04g4F8LlzSVpgd7GbVSfOJA4+wrBcnRTZcg64ykn2C9a4286eAnFm M5tQI6mvamWWTuHPDfETtz6mLOyK+GdJLyiPzmv3hrjGyL7w
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
 drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
index be3b1ebc06ab..0411bab64dc7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
@@ -368,15 +368,13 @@ static int sti_dwmac_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int sti_dwmac_remove(struct platform_device *pdev)
+static void sti_dwmac_remove(struct platform_device *pdev)
 {
 	struct sti_dwmac *dwmac = get_stmmac_bsp_priv(&pdev->dev);
 
 	stmmac_dvr_remove(&pdev->dev);
 
 	clk_disable_unprepare(dwmac->clk);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -423,7 +421,7 @@ MODULE_DEVICE_TABLE(of, sti_dwmac_match);
 
 static struct platform_driver sti_dwmac_driver = {
 	.probe  = sti_dwmac_probe,
-	.remove = sti_dwmac_remove,
+	.remove_new = sti_dwmac_remove,
 	.driver = {
 		.name           = "sti-dwmac",
 		.pm		= &sti_dwmac_pm_ops,
-- 
2.39.2

