Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BD0657011
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 22:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiL0Vpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 16:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiL0Vpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 16:45:38 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1313633C
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 13:45:36 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pAHlF-000549-MX; Tue, 27 Dec 2022 22:45:25 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pAHlE-0029RG-09; Tue, 27 Dec 2022 22:45:24 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pAHlD-008Nml-Ac; Tue, 27 Dec 2022 22:45:23 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 2/2] net: ethernet: freescale: enetc: Drop empty platform remove function
Date:   Tue, 27 Dec 2022 22:45:08 +0100
Message-Id: <20221227214508.1576719-3-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221227214508.1576719-1-u.kleine-koenig@pengutronix.de>
References: <20221227214508.1576719-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1099; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=RPIJSYRnUQvb0w3dYaqI7L+VADUaBVar+5J+3DoLshw=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBjq2deCALFvlpyQbV4vbdrLuvhNPh24GZSH0SHzAsB 62af+WuJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCY6tnXgAKCRDB/BR4rcrsCblNB/ 4y+sgXLhOvEu/YOOnhNXgATpge6hpqPUi5s8IxQjsRguFA67XG4bBQrLMPbJHOmN5D6H8sxZT47kut cJB5jpRkOBDd9GDYsy/fNYmSGSdcQGwOTBkil3WWafjHCbfj/uqdN2X8DK6vwZKY/QeEiOQty86MJQ 5mc+vPqSiKDDwacWW/RXGXVSYpbN94NTTUrjdQuWRz9XwBXbGsGywquur1KFffVGnDEo0GZLdd0cs/ Y6b9xpznYXAxaS729aExXaTJf5nuQd60p94PQbrT0uBiEtkqBdPZccC28fF3uMkL72LcA6EpXxfuT5 dPYcA4YBbN8c0vIwh2A7AKCX/5oodF
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

A remove callback just returning 0 is equivalent to no remove callback
at all. So drop the useless function.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/freescale/enetc/enetc_ierb.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ierb.c b/drivers/net/ethernet/freescale/enetc/enetc_ierb.c
index 91f02c505028..b307bef4dc29 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ierb.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ierb.c
@@ -127,11 +127,6 @@ static int enetc_ierb_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int enetc_ierb_remove(struct platform_device *pdev)
-{
-	return 0;
-}
-
 static const struct of_device_id enetc_ierb_match[] = {
 	{ .compatible = "fsl,ls1028a-enetc-ierb", },
 	{},
@@ -144,7 +139,6 @@ static struct platform_driver enetc_ierb_driver = {
 		.of_match_table = enetc_ierb_match,
 	},
 	.probe = enetc_ierb_probe,
-	.remove = enetc_ierb_remove,
 };
 
 module_platform_driver(enetc_ierb_driver);
-- 
2.38.1

