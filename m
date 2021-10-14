Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDDE42DB3C
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhJNOQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbhJNOQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 10:16:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24131C061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:14:11 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mb1UW-00088K-8y; Thu, 14 Oct 2021 16:13:52 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mb1UT-0006xj-Ms; Thu, 14 Oct 2021 16:13:49 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mb1UT-0003bk-LZ; Thu, 14 Oct 2021 16:13:49 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel@pengutronix.de, Andrew Lunn <andrew@lunn.ch>,
        Arnd Bergmann <arnd@arndb.de>, Marek Vasut <marex@denx.de>,
        Mark Brown <broonie@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        linux-spi@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/2] net: ks8851: Make ks8851_remove_common() return void
Date:   Thu, 14 Oct 2021 16:13:40 +0200
Message-Id: <20211014141341.2740841-2-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211014141341.2740841-1-u.kleine-koenig@pengutronix.de>
References: <20211014141341.2740841-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patch-Hashes: v=1; h=sha256; i=l1tsNSm6p9jZd7n0IvRloxefcIOve97LikwVr8Otfrs=; m=Z81b43hlP8nqmd+BjML51DkyMew5mmrKlqUo0v0p6Ks=; p=WjVbobG3gAkSQOuoV+6Dje5/yqH7dJ1lV1J3rNlpgp0=; g=e490466e8cd7409f48c443c77fc7d7d95c311b3a
X-Patch-Sig: m=pgp; i=u.kleine-koenig@pengutronix.de; s=0x0D2511F322BFAB1C1580266BE2DCDD9132669BD6; b=iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmFoOwsACgkQwfwUeK3K7Al1wQf/Vuj pb/uePkoVkq+sytehMpkSXoqm8RdxDXBtwxyESAcJbc97BZTu7t5lsuMAilPgBraQdGR52S4hP6Gg 3u2kUs0un66KYgW3DLHMhXJ7N/csCWdF0nZgjHo+k+We2ZBp5T9OtpmIh1wrxWhLdwH3KLwl652bx 2jn3c0geNc3BHOqVNQjalTIwyCcwHl0QHCmG+6aQFjgN+pD5GTsGt/fJ5FgK16Tw8dLn/fogFjrKI 873QjYj+G3JEjoSOEMnXGkrkrbmF5AiajqM4T4oc3epcNGsTWXN3jUx9gCflU1WbGNBZcmh18rjY0 60qcI65iq9LA+mo+JfydECd0ZN5J5yQ==
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Up to now ks8851_remove_common() returns zero unconditionally. Make it
return void instead which makes it easier to see in the callers that
there is no error to handle.

Also the return value of platform and spi remove callbacks is ignored
anyway.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/micrel/ks8851.h        | 2 +-
 drivers/net/ethernet/micrel/ks8851_common.c | 4 +---
 drivers/net/ethernet/micrel/ks8851_par.c    | 4 +++-
 drivers/net/ethernet/micrel/ks8851_spi.c    | 4 +++-
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.h b/drivers/net/ethernet/micrel/ks8851.h
index e2eb0caeac82..6f34a61739b6 100644
--- a/drivers/net/ethernet/micrel/ks8851.h
+++ b/drivers/net/ethernet/micrel/ks8851.h
@@ -427,7 +427,7 @@ struct ks8851_net {
 
 int ks8851_probe_common(struct net_device *netdev, struct device *dev,
 			int msg_en);
-int ks8851_remove_common(struct device *dev);
+void ks8851_remove_common(struct device *dev);
 int ks8851_suspend(struct device *dev);
 int ks8851_resume(struct device *dev);
 
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index a6db1a8156e1..77f3d2f820fb 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -1247,7 +1247,7 @@ int ks8851_probe_common(struct net_device *netdev, struct device *dev,
 }
 EXPORT_SYMBOL_GPL(ks8851_probe_common);
 
-int ks8851_remove_common(struct device *dev)
+void ks8851_remove_common(struct device *dev)
 {
 	struct ks8851_net *priv = dev_get_drvdata(dev);
 
@@ -1261,8 +1261,6 @@ int ks8851_remove_common(struct device *dev)
 		gpio_set_value(priv->gpio, 0);
 	regulator_disable(priv->vdd_reg);
 	regulator_disable(priv->vdd_io);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(ks8851_remove_common);
 
diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
index 2e8fcce50f9d..2e25798c610e 100644
--- a/drivers/net/ethernet/micrel/ks8851_par.c
+++ b/drivers/net/ethernet/micrel/ks8851_par.c
@@ -327,7 +327,9 @@ static int ks8851_probe_par(struct platform_device *pdev)
 
 static int ks8851_remove_par(struct platform_device *pdev)
 {
-	return ks8851_remove_common(&pdev->dev);
+	ks8851_remove_common(&pdev->dev);
+
+	return 0;
 }
 
 static const struct of_device_id ks8851_match_table[] = {
diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ethernet/micrel/ks8851_spi.c
index 479406ecbaa3..0303e727e99f 100644
--- a/drivers/net/ethernet/micrel/ks8851_spi.c
+++ b/drivers/net/ethernet/micrel/ks8851_spi.c
@@ -454,7 +454,9 @@ static int ks8851_probe_spi(struct spi_device *spi)
 
 static int ks8851_remove_spi(struct spi_device *spi)
 {
-	return ks8851_remove_common(&spi->dev);
+	ks8851_remove_common(&spi->dev);
+
+	return 0;
 }
 
 static const struct of_device_id ks8851_match_table[] = {
-- 
2.30.2

