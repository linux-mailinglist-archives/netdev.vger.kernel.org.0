Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D64C1A4EC7
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 09:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgDKHwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 03:52:15 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:32618 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgDKHwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 03:52:15 -0400
Received: from localhost.localdomain ([93.22.135.18])
        by mwinf5d37 with ME
        id RKsC2200B0Pz5GD03KsCpe; Sat, 11 Apr 2020 09:52:13 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 11 Apr 2020 09:52:13 +0200
X-ME-IP: 93.22.135.18
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, grygorii.strashko@ti.com,
        colin.king@canonical.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: ethernet: ti: Add missing '\n' in log messages
Date:   Sat, 11 Apr 2020 09:52:11 +0200
Message-Id: <20200411075211.9027-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Message logged by 'dev_xxx()' or 'pr_xxx()' should end with a '\n'.

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index f71c15c39492..2bf56733ba94 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1372,7 +1372,7 @@ static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
 err:
 	i = devm_add_action(dev, am65_cpsw_nuss_free_tx_chns, common);
 	if (i) {
-		dev_err(dev, "failed to add free_tx_chns action %d", i);
+		dev_err(dev, "Failed to add free_tx_chns action %d\n", i);
 		return i;
 	}
 
@@ -1481,7 +1481,7 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 err:
 	i = devm_add_action(dev, am65_cpsw_nuss_free_rx_chns, common);
 	if (i) {
-		dev_err(dev, "failed to add free_rx_chns action %d", i);
+		dev_err(dev, "Failed to add free_rx_chns action %d\n", i);
 		return i;
 	}
 
@@ -1691,7 +1691,7 @@ static int am65_cpsw_nuss_init_ndev_2g(struct am65_cpsw_common *common)
 	ret = devm_add_action_or_reset(dev, am65_cpsw_pcpu_stats_free,
 				       ndev_priv->stats);
 	if (ret) {
-		dev_err(dev, "failed to add percpu stat free action %d", ret);
+		dev_err(dev, "Failed to add percpu stat free action %d\n", ret);
 		return ret;
 	}
 
-- 
2.20.1

