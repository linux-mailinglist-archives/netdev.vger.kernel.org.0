Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE8F6D3858
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 16:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjDBObC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 10:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbjDBOa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 10:30:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5405959DC
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 07:30:58 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjH-0002tj-6Y; Sun, 02 Apr 2023 16:30:47 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjE-008TQe-69; Sun, 02 Apr 2023 16:30:44 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjD-009zBY-Du; Sun, 02 Apr 2023 16:30:43 +0200
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
Subject: [PATCH net-next 05/11] net: stmmac: dwmac-dwc-qos-eth: Convert to platform remove callback returning void
Date:   Sun,  2 Apr 2023 16:30:19 +0200
Message-Id: <20230402143025.2524443-6-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1980; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=iCZltnHIgn5VzrpA6UpCQ5r32RaCL6Op4sTXZpqLYvE=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkKZFznhhVmSoqSW6+4ktWuucmBmh21c5mEVuhR T/av4eup86JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZCmRcwAKCRCPgPtYfRL+ Ts+SCACjAPaMhCz5qPB+M7W0JQDyVtFWB98/AIp0a/oNOPod8nh6OqrZyVz/E7aH8R/cey0hEQO 6ty2NFIDS11f7EnMso3ZPKjmDncBCQAAivFwwvjAGOu9Lc/Sj7EFvhG3GLzaniMwUJB0Rlmg9Zc CfLoIkktfHp3Oye1z6UCtDsKkd1ilx8b93s6JNa2/H+zfQHh9BkHfptivF8CTZnAfWfft3qITaz rs7C5YCCrVIuGByNEgzOOpbHQJaWantu7A27NRGoGY7Z7aCo1tbTqn0eTo+jB1bjCAtnpbanmkS 2hb7GCTAyIiAK9znuznYt4/i/j/a899mEOMpT/QbCncmeOCV
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
 drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index 18acf7dd74e5..9f88530c5e8c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -464,7 +464,7 @@ static int dwc_eth_dwmac_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int dwc_eth_dwmac_remove(struct platform_device *pdev)
+static void dwc_eth_dwmac_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -477,8 +477,6 @@ static int dwc_eth_dwmac_remove(struct platform_device *pdev)
 	data->remove(pdev);
 
 	stmmac_remove_config_dt(pdev, priv->plat);
-
-	return 0;
 }
 
 static const struct of_device_id dwc_eth_dwmac_match[] = {
@@ -490,7 +488,7 @@ MODULE_DEVICE_TABLE(of, dwc_eth_dwmac_match);
 
 static struct platform_driver dwc_eth_dwmac_driver = {
 	.probe  = dwc_eth_dwmac_probe,
-	.remove = dwc_eth_dwmac_remove,
+	.remove_new = dwc_eth_dwmac_remove,
 	.driver = {
 		.name           = "dwc-eth-dwmac",
 		.pm             = &stmmac_pltfr_pm_ops,
-- 
2.39.2

