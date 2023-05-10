Return-Path: <netdev+bounces-1562-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5C786FE4BD
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:03:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD67E1C20E23
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 859EB18014;
	Wed, 10 May 2023 20:03:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B58E8C0F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 20:03:21 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24AB4214
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:03:19 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pwq1l-0002XE-W3; Wed, 10 May 2023 22:03:10 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pwq1k-002Ywf-IX; Wed, 10 May 2023 22:03:08 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pwq1j-003Cdz-R7; Wed, 10 May 2023 22:03:07 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Byungho An <bh74.an@samsung.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH net-next] net: samsung: sxgbe: Make sxgbe_drv_remove() return void
Date: Wed, 10 May 2023 22:02:47 +0200
Message-Id: <20230510200247.1534793-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2749; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=WEeXELx3JkeU9UIbuFh2WwEN8VqKWBAGlRSL7POgUeY=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkW/hmwjjmTy93L4vFd5z2/1wtnamzxmcQDL4zO X+mNB5ZKAKJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZFv4ZgAKCRCPgPtYfRL+ Tty9CACvpBHQ0+DmCCL5rVbgWxI6joZ+3i6qKlaxh3Ou89fr2wSxStYWm+D0Ldb4MiZe8hyIpuE eNdi/7wUN7gwmSktxlk9BxGBqGnBVGh/cvr/E2ikz07nrpXU3MnQGOFjJjuxI1Vh1o6lmegASVo 4T1SIiBJ7a6Zdkx2gk2T+GkqHhGYU2jvF+2hIVf6aF3+aEREMNXjDorVhtRbangF4IaxPlIRDWy 3ZHaD+cLRQ/yGhDbL/VSAZ6Wdg8CCgOT2jCMa6UMmrL8iy2sh1FOzLXNXtGnVALADLQ3SG6DyDH kXxd6RqADYGUUCag3y/2ERucG9GitdtB+34+2I28qlCbv4q6
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

sxgbe_drv_remove() returned zero unconditionally, so it can be converted
to return void without losing anything. The upside is that it becomes
more obvious in its callers that there is no error to handle.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h   | 2 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c     | 4 +---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c | 5 +++--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h b/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h
index 0f45107db8dd..d14e0cfc3a6b 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h
@@ -511,7 +511,7 @@ struct sxgbe_priv_data {
 struct sxgbe_priv_data *sxgbe_drv_probe(struct device *device,
 					struct sxgbe_plat_data *plat_dat,
 					void __iomem *addr);
-int sxgbe_drv_remove(struct net_device *ndev);
+void sxgbe_drv_remove(struct net_device *ndev);
 void sxgbe_set_ethtool_ops(struct net_device *netdev);
 int sxgbe_mdio_unregister(struct net_device *ndev);
 int sxgbe_mdio_register(struct net_device *ndev);
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 9664f029fa16..71439825ea4e 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -2203,7 +2203,7 @@ struct sxgbe_priv_data *sxgbe_drv_probe(struct device *device,
  * Description: this function resets the TX/RX processes, disables the MAC RX/TX
  * changes the link status, releases the DMA descriptor rings.
  */
-int sxgbe_drv_remove(struct net_device *ndev)
+void sxgbe_drv_remove(struct net_device *ndev)
 {
 	struct sxgbe_priv_data *priv = netdev_priv(ndev);
 	u8 queue_num;
@@ -2231,8 +2231,6 @@ int sxgbe_drv_remove(struct net_device *ndev)
 	kfree(priv->hw);
 
 	free_netdev(ndev);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
index 4e5526303f07..fb59ff94509a 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
@@ -172,9 +172,10 @@ static int sxgbe_platform_probe(struct platform_device *pdev)
 static int sxgbe_platform_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
-	int ret = sxgbe_drv_remove(ndev);
 
-	return ret;
+	sxgbe_drv_remove(ndev);
+
+	return 0;
 }
 
 #ifdef CONFIG_PM

base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
2.39.2


