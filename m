Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B1F5FED8
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 01:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbfGDX6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 19:58:02 -0400
Received: from smtprelay0031.hostedemail.com ([216.40.44.31]:57128 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727748AbfGDX6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 19:58:02 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 89177100E806B;
        Thu,  4 Jul 2019 23:58:00 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1540:1568:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3865:4321:4605:5007:6261:8603:10004:10848:11026:11657:11658:11914:12043:12296:12297:12555:12895:13069:13138:13231:13311:13357:14096:14181:14384:14394:14721:21080:21627:30054:30075,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:28,LUA_SUMMARY:none
X-HE-Tag: swim69_62de18b54c925
X-Filterd-Recvd-Size: 1809
Received: from joe-laptop.perches.com (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Thu,  4 Jul 2019 23:57:59 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] net: ethernet: sun4i-emac: Fix misuse of strlcpy
Date:   Thu,  4 Jul 2019 16:57:45 -0700
Message-Id: <faf2d0e7c0260d24b6e90c55bb7fec7496e5e76a.1562283944.git.joe@perches.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <cover.1562283944.git.joe@perches.com>
References: <cover.1562283944.git.joe@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Probable cut&paste typo - use the correct field size.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 9e06dff619c3..40a359dd90b4 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -224,8 +224,8 @@ static int emac_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 static void emac_get_drvinfo(struct net_device *dev,
 			      struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(DRV_NAME));
-	strlcpy(info->version, DRV_VERSION, sizeof(DRV_VERSION));
+	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, dev_name(&dev->dev), sizeof(info->bus_info));
 }
 
-- 
2.15.0

