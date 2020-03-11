Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7BF8180F53
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 06:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgCKFHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 01:07:50 -0400
Received: from smtprelay0211.hostedemail.com ([216.40.44.211]:44666 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728349AbgCKFHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 01:07:42 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 5379A1802E2C7;
        Wed, 11 Mar 2020 05:07:41 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:541:800:960:967:973:982:988:989:1260:1311:1314:1345:1359:1437:1515:1534:1542:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3865:3866:3867:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6117:6119:6261:9025:10004:10848:11026:11473:11657:11658:11914:12043:12297:12438:12555:12679:12895:12986:13894:14096:14181:14394:14721:21080:21433:21627:21811:21939:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:0,LUA_SUMMARY:none
X-HE-Tag: magic61_25e9dec9d9c62
X-Filterd-Recvd-Size: 2826
Received: from joe-laptop.perches.com (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 11 Mar 2020 05:07:40 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next 027/491] AMD XGBE DRIVER: Use fallthrough;
Date:   Tue, 10 Mar 2020 21:51:41 -0700
Message-Id: <05794ab3463ec40162689e651e3b6c2245e27984.1583896349.git.joe@perches.com>
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
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index b71f9b0..a51abf 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1612,7 +1612,7 @@ static int xgbe_set_hwtstamp_settings(struct xgbe_prv_data *pdata,
 	/* PTP v2, UDP, any kind of event packet */
 	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
 		XGMAC_SET_BITS(mac_tscr, MAC_TSCR, TSVER2ENA, 1);
-		/* Fall through - to PTP v1, UDP, any kind of event packet */
+		fallthrough;	/* to PTP v1, UDP, any kind of event packet */
 	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
 		XGMAC_SET_BITS(mac_tscr, MAC_TSCR, TSIPV4ENA, 1);
 		XGMAC_SET_BITS(mac_tscr, MAC_TSCR, TSIPV6ENA, 1);
@@ -1623,7 +1623,7 @@ static int xgbe_set_hwtstamp_settings(struct xgbe_prv_data *pdata,
 	/* PTP v2, UDP, Sync packet */
 	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
 		XGMAC_SET_BITS(mac_tscr, MAC_TSCR, TSVER2ENA, 1);
-		/* Fall through - to PTP v1, UDP, Sync packet */
+		fallthrough;	/* to PTP v1, UDP, Sync packet */
 	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
 		XGMAC_SET_BITS(mac_tscr, MAC_TSCR, TSIPV4ENA, 1);
 		XGMAC_SET_BITS(mac_tscr, MAC_TSCR, TSIPV6ENA, 1);
@@ -1634,7 +1634,7 @@ static int xgbe_set_hwtstamp_settings(struct xgbe_prv_data *pdata,
 	/* PTP v2, UDP, Delay_req packet */
 	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
 		XGMAC_SET_BITS(mac_tscr, MAC_TSCR, TSVER2ENA, 1);
-		/* Fall through - to PTP v1, UDP, Delay_req packet */
+		fallthrough;	/* to PTP v1, UDP, Delay_req packet */
 	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
 		XGMAC_SET_BITS(mac_tscr, MAC_TSCR, TSIPV4ENA, 1);
 		XGMAC_SET_BITS(mac_tscr, MAC_TSCR, TSIPV6ENA, 1);
-- 
2.24.0

