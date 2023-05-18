Return-Path: <netdev+bounces-3757-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 271DC70898D
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 22:31:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E08C51C211C4
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 20:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37CEE134BA;
	Thu, 18 May 2023 20:31:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A52929AD
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 20:31:24 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977BE10D0
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 13:31:22 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pzkHK-0003fW-Oa; Thu, 18 May 2023 22:31:14 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pzkHI-0019vd-QC; Thu, 18 May 2023 22:31:12 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pzkHI-005l13-1H; Thu, 18 May 2023 22:31:12 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Heiko Stuebner <heiko@sntech.de>
Cc: netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	kernel@pengutronix.de
Subject: [PATCH net-next] net: arc: Make arc_emac_remove() return void
Date: Thu, 18 May 2023 22:30:49 +0200
Message-Id: <20230518203049.275805-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3231; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=i7bRACr8XsrDpvJ8bE6eLVkYIMKYRoc+4qMA9lSuxN8=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkZor4CJXvMs9TXqgHgZE5EouRnhESGxz7YJqe7 mM7rpW01B6JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZGaK+AAKCRCPgPtYfRL+ TtybCACT15vZHTZHoZw2wmk/mJ7SJqLap1dZWKuflXUSpEAXhzLlUAj+m2xWbYAKKxq13ygVysa dpR1nlXMsKugf39Lo3k6IrrXJPm/PGuYWFn9vMnqWt+gUNs4rtSYRFCnvVB0x/vh8H9slT/sYjL 94ZPLPyP5nPkz5OLBoetV1htMFvWnK6w8/Uj0ni2BIQ8FkNg3PQaD20tTJYU8PKkJeJIzZ1JT42 wYJGMGOu6FwEdCReeWK/MlopGqpS3HsULDKvKA2Q2Y27RAeytEWrDlP0raL26EdIOUrdS5WttXK uJXUuqMBobcgwg3lFvqPNB+g0u6Sbr/rv5Pczu3e98FOTPoB
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

The function returns zero unconditionally. Change it to return void instead
which simplifies its callers as error handing becomes unnecessary.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/arc/emac.h          | 2 +-
 drivers/net/ethernet/arc/emac_arc.c      | 6 +++---
 drivers/net/ethernet/arc/emac_main.c     | 4 +---
 drivers/net/ethernet/arc/emac_rockchip.c | 5 ++---
 4 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/arc/emac.h b/drivers/net/ethernet/arc/emac.h
index d820ae03a966..0e244f0e25fd 100644
--- a/drivers/net/ethernet/arc/emac.h
+++ b/drivers/net/ethernet/arc/emac.h
@@ -220,6 +220,6 @@ static inline void arc_reg_clr(struct arc_emac_priv *priv, int reg, int mask)
 int arc_mdio_probe(struct arc_emac_priv *priv);
 int arc_mdio_remove(struct arc_emac_priv *priv);
 int arc_emac_probe(struct net_device *ndev, int interface);
-int arc_emac_remove(struct net_device *ndev);
+void arc_emac_remove(struct net_device *ndev);
 
 #endif /* ARC_EMAC_H */
diff --git a/drivers/net/ethernet/arc/emac_arc.c b/drivers/net/ethernet/arc/emac_arc.c
index 800620b8f10d..ce3147e886a1 100644
--- a/drivers/net/ethernet/arc/emac_arc.c
+++ b/drivers/net/ethernet/arc/emac_arc.c
@@ -61,11 +61,11 @@ static int emac_arc_probe(struct platform_device *pdev)
 static int emac_arc_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
-	int err;
 
-	err = arc_emac_remove(ndev);
+	arc_emac_remove(ndev);
 	free_netdev(ndev);
-	return err;
+
+	return 0;
 }
 
 static const struct of_device_id emac_arc_dt_ids[] = {
diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index ba0646b3b122..2b427d8a1831 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -1008,7 +1008,7 @@ int arc_emac_probe(struct net_device *ndev, int interface)
 }
 EXPORT_SYMBOL_GPL(arc_emac_probe);
 
-int arc_emac_remove(struct net_device *ndev)
+void arc_emac_remove(struct net_device *ndev)
 {
 	struct arc_emac_priv *priv = netdev_priv(ndev);
 
@@ -1019,8 +1019,6 @@ int arc_emac_remove(struct net_device *ndev)
 
 	if (!IS_ERR(priv->clk))
 		clk_disable_unprepare(priv->clk);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(arc_emac_remove);
 
diff --git a/drivers/net/ethernet/arc/emac_rockchip.c b/drivers/net/ethernet/arc/emac_rockchip.c
index 1c9ca3bcb871..509101112279 100644
--- a/drivers/net/ethernet/arc/emac_rockchip.c
+++ b/drivers/net/ethernet/arc/emac_rockchip.c
@@ -248,9 +248,8 @@ static int emac_rockchip_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct rockchip_priv_data *priv = netdev_priv(ndev);
-	int err;
 
-	err = arc_emac_remove(ndev);
+	arc_emac_remove(ndev);
 
 	clk_disable_unprepare(priv->refclk);
 
@@ -261,7 +260,7 @@ static int emac_rockchip_remove(struct platform_device *pdev)
 		clk_disable_unprepare(priv->macclk);
 
 	free_netdev(ndev);
-	return err;
+	return 0;
 }
 
 static struct platform_driver emac_rockchip_driver = {

base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
2.39.2


