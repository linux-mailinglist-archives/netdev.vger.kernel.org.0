Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9EC6D3859
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 16:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjDBObD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 10:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbjDBObA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 10:31:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9F5A5D6
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 07:30:58 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjK-0002tx-T6; Sun, 02 Apr 2023 16:30:50 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjF-008TQz-7z; Sun, 02 Apr 2023 16:30:45 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjE-009zBp-Am; Sun, 02 Apr 2023 16:30:44 +0200
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
Subject: [PATCH net-next 09/11] net: stmmac: dwmac-stm32: Convert to platform remove callback returning void
Date:   Sun,  2 Apr 2023 16:30:23 +0200
Message-Id: <20230402143025.2524443-10-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1929; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=7A6pAj+3q8Uu5gkI+mEIx2fxMYRiMJrByzqccM+Yk0g=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkKZF4bC02Hp6K8BSUYWJoZT0GHZKqzrffcC8nA Wfq1RNorLWJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZCmReAAKCRCPgPtYfRL+ TjgEB/4kybicIoTieRhF0unJoF/hvKAH8fza5XMEOGzK0s3LlIaJLmObfXTH6AD73An1obCSklO XjuojiN5ZIUJ5zH4BwLLlc4PSozfxDsyDqF34xtoQbnPx5bF5i2QHjq7Qskj95IRJifMZc1m++z ffVl0c0SKYMtTEk0NrTn9UNcj3P7EyN52iMndWmaf1kefkUykJoRkU2pn2eXycWMsnPc54Ob93Q YYqm3zoSM7lO+JBIYka+xclXKJsROaQiCx+uokTosAJ7ZpRPxKznQsmh0lP1XnB9cfsZgv5Sf/q LD9qaOEAhNeMBSicOxx9U8YIHJEGywosUjCw7gnqf5JbGCAa
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
 drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
index 0616b3a04ff3..bdb4de59a672 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
@@ -417,7 +417,7 @@ static int stm32_dwmac_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int stm32_dwmac_remove(struct platform_device *pdev)
+static void stm32_dwmac_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -431,8 +431,6 @@ static int stm32_dwmac_remove(struct platform_device *pdev)
 		dev_pm_clear_wake_irq(&pdev->dev);
 		device_init_wakeup(&pdev->dev, false);
 	}
-
-	return 0;
 }
 
 static int stm32mp1_suspend(struct stm32_dwmac *dwmac)
@@ -528,7 +526,7 @@ MODULE_DEVICE_TABLE(of, stm32_dwmac_match);
 
 static struct platform_driver stm32_dwmac_driver = {
 	.probe  = stm32_dwmac_probe,
-	.remove = stm32_dwmac_remove,
+	.remove_new = stm32_dwmac_remove,
 	.driver = {
 		.name           = "stm32-dwmac",
 		.pm		= &stm32_dwmac_pm_ops,
-- 
2.39.2

