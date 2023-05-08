Return-Path: <netdev+bounces-880-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC5A56FB2CA
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:28:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B3AB1C2099E
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B8C1DDC4;
	Mon,  8 May 2023 14:27:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD56440B
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 14:27:00 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84DA7AB5
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 07:26:58 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1p7-0008Np-FZ; Mon, 08 May 2023 16:26:45 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1p3-0021Gq-NC; Mon, 08 May 2023 16:26:41 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1p2-002SkD-TI; Mon, 08 May 2023 16:26:40 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Vinod Koul <vkoul@kernel.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 03/11] net: stmmac: dwmac-qcom-ethqos: Drop an if with an always false condition
Date: Mon,  8 May 2023 16:26:29 +0200
Message-Id: <20230508142637.1449363-4-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508142637.1449363-1-u.kleine-koenig@pengutronix.de>
References: <20230508142637.1449363-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1499; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=M3Zeb985dqvOyNIprDkcPrQUCdgAjxyUk1k33m1aTkA=; b=owGbwMvMwMXY3/A7olbonx/jabUkhpRItgnxf63uTA9Rs74UvTRKRVB1f4yp/3vzh8rN5Ymcr 1ao/TPvZDRmYWDkYpAVU2Sxb1yTaVUlF9m59t9lmEGsTCBTGLg4BWAir7dyMHQcLLnpvDT3vL6v zTuzP79PBallXOuQn7AjVsc7+STnl2Wtrot2c4qz3FZU6IrreRRWMHvd+Yb9IWz9KnsVv6/MvbP weALbv2d5YkH82Zc5hIX/q3wuF1z2Yksfy557TXv2PGczqMnYM0MiMKJBgOfD89nfLkadny4ecb vZL+jozjrvhq6JgkKaj/bw8N0ziO1MjUsq5Cwrezy9P+ybWLHLrrW3HstsiWXOKU92z3vZz6qxz He1Ouv9fwt8r+9aYRQib9jY42aUc/TPW08W/5Ur9D0msdYa1q/WjdVZevj6pbMeFzqdpG7tsb6i lnPjNafMr1W3Tu2uY5vY4z/5xsWsfF77M+fq00LUKvUTAA==
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The remove callback is only ever called after .probe() returned
successfully. After that get_stmmac_bsp_priv() always return non-NULL.

Side note: The early exit would also be a bug because the return value
of qcom_ethqos_remove() is ignored by the device core and the device is
unbound unconditionally. So exiting early resulted in a dangerous
resource leak as all devm allocated resources (some memory and the
register mappings) are freed but the network device stays around.  Using
the network device afterwards probably oopses.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 494c22243259..bf17c6c8f2eb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -667,11 +667,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 
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


