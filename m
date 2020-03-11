Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39EEB180F54
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 06:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgCKFHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 01:07:51 -0400
Received: from smtprelay0164.hostedemail.com ([216.40.44.164]:42642 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728368AbgCKFHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 01:07:49 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 9E98E18224519;
        Wed, 11 Mar 2020 05:07:47 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:541:800:960:967:973:982:988:989:1260:1311:1314:1345:1359:1437:1515:1534:1541:1711:1730:1747:1777:1792:2194:2199:2393:2525:2560:2563:2682:2685:2693:2859:2898:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3865:3866:3867:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6117:6119:6261:7904:9025:10004:10848:11026:11473:11657:11658:11914:12043:12296:12297:12438:12555:12679:12895:12986:13069:13311:13357:13894:14096:14181:14384:14394:14721:21080:21433:21627:21811:21939:30054:30070,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:111,LUA_SUMMARY:none
X-HE-Tag: loaf64_26c7a77479406
X-Filterd-Recvd-Size: 2589
Received: from joe-laptop.perches.com (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 11 Mar 2020 05:07:46 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next 030/491] BROADCOM GENET ETHERNET DRIVER: Use fallthrough;
Date:   Tue, 10 Mar 2020 21:51:44 -0700
Message-Id: <e78fb08d1dcf0d95175fc2866c344fbef2ff7065.1583896349.git.joe@perches.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583896344.git.joe@perches.com>
References: <cover.1583896344.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the various uses of fallthrough comments to fallthrough;

Done via script
Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe.com/

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 ++--
 drivers/net/ethernet/broadcom/genet/bcmmii.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index c2fda12..f8c15ec 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -963,10 +963,10 @@ static void bcmgenet_update_mib_counters(struct bcmgenet_priv *priv)
 			continue;
 		case BCMGENET_STAT_RUNT:
 			offset += BCMGENET_STAT_OFFSET;
-			/* fall through */
+			fallthrough;
 		case BCMGENET_STAT_MIB_TX:
 			offset += BCMGENET_STAT_OFFSET;
-			/* fall through */
+			fallthrough;
 		case BCMGENET_STAT_MIB_RX:
 			val = bcmgenet_umac_readl(priv,
 						  UMAC_MIB_START + j + offset);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index d3003cb..b8e704f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -216,7 +216,7 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 	switch (priv->phy_interface) {
 	case PHY_INTERFACE_MODE_INTERNAL:
 		phy_name = "internal PHY";
-		/* fall through */
+		fallthrough;
 	case PHY_INTERFACE_MODE_MOCA:
 		/* Irrespective of the actually configured PHY speed (100 or
 		 * 1000) GENETv4 only has an internal GPHY so we will just end
-- 
2.24.0

