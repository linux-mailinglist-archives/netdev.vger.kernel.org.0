Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F176D3860
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 16:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjDBObM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 10:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjDBObG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 10:31:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EEC113E2
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 07:31:05 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjJ-0002tZ-SE; Sun, 02 Apr 2023 16:30:49 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjD-008TQR-Gw; Sun, 02 Apr 2023 16:30:43 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjC-009zBO-Py; Sun, 02 Apr 2023 16:30:42 +0200
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
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH net-next 02/11] net: stmmac: dwmac-visconti: Make visconti_eth_clock_remove() return void
Date:   Sun,  2 Apr 2023 16:30:16 +0200
Message-Id: <20230402143025.2524443-3-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1617; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=AWlXAjZ8Ru7rdnyMS6Bp0oEoCFeAMPQ9Sd9tZwp6bt4=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkKZFwESTTkfx0VtVJee/4tr8hCMjm/sabGCIxL BeZYKE/bVaJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZCmRcAAKCRCPgPtYfRL+ Tg8SB/0Uu9Y6uwYBc/ar46+3Oac+t9HCEarKVeuahv+ZzJQwVqlf3qlUMDIP7OQz5tU+A2vk2/o nQD+aTU6trAflXX9OkGP/yapNltErHD14G0gnFZzvfbyzHCeqXnWKC/sHQpms+nXNIIuglFfHzG R7IrqeQbi3NCYUMZo/2pCd9vXaOfaIJdd2G5Jt/D1CqrHDloT7UZ4TdVY6J1/GtDbK6dLJ+3LbR eJKVU3ihH+TNGZEri5rHI9OVBARX0AbgnLgKiDwlXjY6TlWXwcW5q5uxsv8XNDMin5fKH22i7hf M6UIl4u+Da+pddHimVHNeGZAV53p2H8BkPihvYcRw3RdGKDV
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

The function returns zero unconditionally. Change it to return void
instead which simplifies one caller as error handing becomes
unnecessary.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
index d43da71eb1e1..7531fcd4ffe2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -198,7 +198,7 @@ static int visconti_eth_clock_probe(struct platform_device *pdev,
 	return 0;
 }
 
-static int visconti_eth_clock_remove(struct platform_device *pdev)
+static void visconti_eth_clock_remove(struct platform_device *pdev)
 {
 	struct visconti_eth *dwmac = get_stmmac_bsp_priv(&pdev->dev);
 	struct net_device *ndev = platform_get_drvdata(pdev);
@@ -206,8 +206,6 @@ static int visconti_eth_clock_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(dwmac->phy_ref_clk);
 	clk_disable_unprepare(priv->plat->stmmac_clk);
-
-	return 0;
 }
 
 static int visconti_eth_dwmac_probe(struct platform_device *pdev)
@@ -267,9 +265,7 @@ static int visconti_eth_dwmac_remove(struct platform_device *pdev)
 
 	stmmac_pltfr_remove(pdev);
 
-	err = visconti_eth_clock_remove(pdev);
-	if (err < 0)
-		dev_err(&pdev->dev, "failed to remove clock: %d\n", err);
+	visconti_eth_clock_remove(pdev);
 
 	stmmac_remove_config_dt(pdev, priv->plat);
 
-- 
2.39.2

