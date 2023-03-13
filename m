Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4F26B7438
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjCMKhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjCMKhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:37:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CEA5C101
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 03:37:13 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY3-0008TB-LJ; Mon, 13 Mar 2023 11:36:59 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY1-003pKq-RD; Mon, 13 Mar 2023 11:36:57 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY0-004W3o-UC; Mon, 13 Mar 2023 11:36:56 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 6/9] net: fs_enet: Convert to platform remove callback returning void
Date:   Mon, 13 Mar 2023 11:36:50 +0100
Message-Id: <20230313103653.2753139-7-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=4317; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=f76Nc+3Oj46FRb2E4EO2ZY/wW5QfMQpwCUVv+HL4buI=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBkDvy0aILmjnPX5g40v+YBRkVfpaZRrV7rMZSSv lt9XXtQK6+JATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCZA78tAAKCRDB/BR4rcrs CYXqB/kBbTM4n38sSUi5JLd5T5vzRR0UY8hprexhA2dm4GaAksUxGWpjHO2/QpzLpl4FVFQ93FJ f+vY5gf/L5+NEAoUfYcyzW1llhcU0v4gEnV1X7etBzvuQL9PVVvKVq2eo5LWgzZWZwhfZbigkeX sbZ5XcJdUFXGEH8n0weSKLmD3Md8qfDAs1+FQCJq6Qm/J2u5FCkU5vf57XiWCdG0MYSoqr3ep1J B9cg2+O48COY20utQ/Q5dGj5SplL75Vdm/Vy5RiHUhAeROVLbzpG5vls6kX7bPseBTrSoru9nBQ Nht6dB/Uet26KlzCmgYAAj0czWSFeIqEjYLgvVKHOBuov0/B
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c | 5 ++---
 drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c  | 6 ++----
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c      | 6 ++----
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index 8844a9a04fcf..f9f5b28cc72e 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -1051,7 +1051,7 @@ static int fs_enet_probe(struct platform_device *ofdev)
 	return ret;
 }
 
-static int fs_enet_remove(struct platform_device *ofdev)
+static void fs_enet_remove(struct platform_device *ofdev)
 {
 	struct net_device *ndev = platform_get_drvdata(ofdev);
 	struct fs_enet_private *fep = netdev_priv(ndev);
@@ -1066,7 +1066,6 @@ static int fs_enet_remove(struct platform_device *ofdev)
 	if (of_phy_is_fixed_link(ofdev->dev.of_node))
 		of_phy_deregister_fixed_link(ofdev->dev.of_node);
 	free_netdev(ndev);
-	return 0;
 }
 
 static const struct of_device_id fs_enet_match[] = {
@@ -1113,7 +1112,7 @@ static struct platform_driver fs_enet_driver = {
 		.of_match_table = fs_enet_match,
 	},
 	.probe = fs_enet_probe,
-	.remove = fs_enet_remove,
+	.remove_new = fs_enet_remove,
 };
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c b/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
index 21de56345503..91a69fc2f7c2 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
@@ -192,7 +192,7 @@ static int fs_enet_mdio_probe(struct platform_device *ofdev)
 	return ret;
 }
 
-static int fs_enet_mdio_remove(struct platform_device *ofdev)
+static void fs_enet_mdio_remove(struct platform_device *ofdev)
 {
 	struct mii_bus *bus = platform_get_drvdata(ofdev);
 	struct bb_info *bitbang = bus->priv;
@@ -201,8 +201,6 @@ static int fs_enet_mdio_remove(struct platform_device *ofdev)
 	free_mdio_bitbang(bus);
 	iounmap(bitbang->dir);
 	kfree(bitbang);
-
-	return 0;
 }
 
 static const struct of_device_id fs_enet_mdio_bb_match[] = {
@@ -219,7 +217,7 @@ static struct platform_driver fs_enet_bb_mdio_driver = {
 		.of_match_table = fs_enet_mdio_bb_match,
 	},
 	.probe = fs_enet_mdio_probe,
-	.remove = fs_enet_mdio_remove,
+	.remove_new = fs_enet_mdio_remove,
 };
 
 module_platform_driver(fs_enet_bb_mdio_driver);
diff --git a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
index d37d7a19a759..94bd76c6cf9e 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
@@ -187,7 +187,7 @@ static int fs_enet_mdio_probe(struct platform_device *ofdev)
 	return ret;
 }
 
-static int fs_enet_mdio_remove(struct platform_device *ofdev)
+static void fs_enet_mdio_remove(struct platform_device *ofdev)
 {
 	struct mii_bus *bus = platform_get_drvdata(ofdev);
 	struct fec_info *fec = bus->priv;
@@ -196,8 +196,6 @@ static int fs_enet_mdio_remove(struct platform_device *ofdev)
 	iounmap(fec->fecp);
 	kfree(fec);
 	mdiobus_free(bus);
-
-	return 0;
 }
 
 static const struct of_device_id fs_enet_mdio_fec_match[] = {
@@ -220,7 +218,7 @@ static struct platform_driver fs_enet_fec_mdio_driver = {
 		.of_match_table = fs_enet_mdio_fec_match,
 	},
 	.probe = fs_enet_mdio_probe,
-	.remove = fs_enet_mdio_remove,
+	.remove_new = fs_enet_mdio_remove,
 };
 
 module_platform_driver(fs_enet_fec_mdio_driver);
-- 
2.39.1

