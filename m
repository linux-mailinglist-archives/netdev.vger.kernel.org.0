Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F28D6D3865
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 16:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjDBObT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 10:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjDBObI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 10:31:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBA7C169
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 07:31:06 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjH-0002tc-6X; Sun, 02 Apr 2023 16:30:47 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjD-008TQU-LX; Sun, 02 Apr 2023 16:30:43 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjD-009zBR-0v; Sun, 02 Apr 2023 16:30:43 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Vinod Koul <vkoul@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Bhupesh Sharma <bhupesh.sharma@linaro.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH net-next 03/11] net: stmmac: dwmac-qcom-ethqos: Drop an if with an always false condition
Date:   Sun,  2 Apr 2023 16:30:17 +0200
Message-Id: <20230402143025.2524443-4-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1444; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=GTFyaOdgg0Lm2AhOB1Nk+U46u3Y+WjIwpoEkwcVw7V8=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkKZFx7Ov93thD7A8g5K70nz9jOqUwnbwwbngqG SDZN8L+6LqJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZCmRcQAKCRCPgPtYfRL+ Tu0zCACBVUGAuTiiPgtRM/MpzT17fCMyGqiEnOSvFSNbUSz1eQ9p3Ge8p2M4tYRqxwPNg3jHxb0 7z5Uh/yh+fLfaQYCqSO1z0B2h+LuZXQ4PpSbvWaGp+j/CUkXQA+IvYPVQsYKVmlj18UxXgB8Fwy tDvI3VOkwggEvT4eNBzGxaf299F/EQ6MSyV3eKj6wt/YXy3r9QtmdYaW4uMkMMcWgN4v9svwAHL l/h1UDAasZHOH0rETJRrsFUI+g0xb0duIqZk3F95FmcJiHbqUJzEuYSB092KREg8m3+8qBgUM/t iW1SgL3fZZd20cmniptUSBfrMLozyJkbwGvHyqPvdGq6phqk
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

The remove callback is only ever called after .probe() returned
successfully. After that get_stmmac_bsp_priv() always return non-NULL.

Side note: The early exit would also be a bug because the return value
of qcom_ethqos_remove() is ignored by the device core and the device is
unbound unconditionally. So exiting early resulted in a dangerous
resource leak as all devm allocated resources (some memory and the
register mappings) are freed but the network device stays around.  Using
the network device afterwards probably oopses.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index f9faa6f55939..fba1fc88d2dc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -580,11 +580,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 
 static int qcom_ethqos_remove(struct platform_device *pdev)
 {
-	struct qcom_ethqos *ethqos;
-
-	ethqos = get_stmmac_bsp_priv(&pdev->dev);
-	if (!ethqos)
-		return -ENODEV;
+	struct qcom_ethqos *ethqos = get_stmmac_bsp_priv(&pdev->dev);
 
 	stmmac_pltfr_remove(pdev);
 	ethqos_clks_config(ethqos, false);
-- 
2.39.2

