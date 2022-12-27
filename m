Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0C9657012
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 22:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiL0Vpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 16:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiL0Vpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 16:45:38 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72969635B
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 13:45:37 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pAHlF-000546-MX; Tue, 27 Dec 2022 22:45:25 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pAHlD-0029R8-Pt; Tue, 27 Dec 2022 22:45:23 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pAHlD-008Nmi-4j; Tue, 27 Dec 2022 22:45:23 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 1/2] net: ethernet: broadcom: bcm63xx_enet: Drop empty platform remove function
Date:   Tue, 27 Dec 2022 22:45:07 +0100
Message-Id: <20221227214508.1576719-2-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221227214508.1576719-1-u.kleine-koenig@pengutronix.de>
References: <20221227214508.1576719-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1039; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=Q7AgBrh++/aMeB+WF19foOvDgJQ9usk2SeBwHNTPuMU=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBjq2dVpOeRWIoldz2T6cWqb6iNPWNJ6gU4cyyRPTf+ jZMS0bWJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCY6tnVQAKCRDB/BR4rcrsCbOwB/ 9mYA1APGxwxD8YTggUpYdWW6LLFHHAca2dDPsOYbBo8K71j+r9/MzL/CULfffuoeOHdWZ3fS8Qsre8 eLKofUQ+5dXTNoemcN9eKA5Ae7Zf6ILHvIkaLfTbAKfyEZxc2d69PlouS18fT2gzFoQuPAFWS1frk2 2sP4t976tJejdTe2QkaFAeE4ymP3HsIVM5EFq9LLzfuM+tpcdb3GvEQejXH/dItTIOxac87u1QBMz9 mv2bPBAMNfnIDmLRu8WpUBAPQdrmDQOKRnjsu682ufPKMemd7UH+LSUJ6TuFrovhi+eGiMvn2BOHM9 fLLZUUSdCorcAJqxztGTl9Pqh9+XL4
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
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index d91fdb0c2649..2cf96892e565 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -2784,17 +2784,11 @@ static int bcm_enet_shared_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int bcm_enet_shared_remove(struct platform_device *pdev)
-{
-	return 0;
-}
-
 /* this "shared" driver is needed because both macs share a single
  * address space
  */
 struct platform_driver bcm63xx_enet_shared_driver = {
 	.probe	= bcm_enet_shared_probe,
-	.remove	= bcm_enet_shared_remove,
 	.driver	= {
 		.name	= "bcm63xx_enet_shared",
 		.owner  = THIS_MODULE,
-- 
2.38.1

