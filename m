Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C116F180F51
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 06:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgCKFHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 01:07:49 -0400
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:52618 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728337AbgCKFHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 01:07:44 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 45D6C841B;
        Wed, 11 Mar 2020 05:07:43 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:541:800:960:966:967:973:982:988:989:1260:1311:1314:1345:1359:1437:1515:1535:1544:1711:1730:1747:1777:1792:2196:2199:2393:2525:2560:2563:2682:2685:2859:2895:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3865:3866:3867:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4385:4605:5007:6119:6261:9025:9592:10004:10848:11026:11473:11657:11658:11914:12043:12296:12297:12438:12555:12679:12895:12986:13255:13894:14181:14394:14721:21080:21433:21627:21811:21939:21987:21990:30034:30054:30070,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: fuel84_2627d25592301
X-Filterd-Recvd-Size: 5022
Received: from joe-laptop.perches.com (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 11 Mar 2020 05:07:42 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next 028/491] BROADCOM BNX2X 10 GIGABIT ETHERNET DRIVER: Use fallthrough;
Date:   Tue, 10 Mar 2020 21:51:42 -0700
Message-Id: <dc611bfdc1f2f77aa7ddda8b91d12e03541ccba5.1583896349.git.joe@perches.com>
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
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c  | 14 +++++++-------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  6 ++----
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c |  4 ++--
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index 9638d65..07bc87 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -4708,14 +4708,14 @@ static void bnx2x_sync_link(struct link_params *params,
 			LINK_STATUS_SPEED_AND_DUPLEX_MASK) {
 		case LINK_10THD:
 			vars->duplex = DUPLEX_HALF;
-			/* Fall thru */
+			fallthrough;
 		case LINK_10TFD:
 			vars->line_speed = SPEED_10;
 			break;
 
 		case LINK_100TXHD:
 			vars->duplex = DUPLEX_HALF;
-			/* Fall thru */
+			fallthrough;
 		case LINK_100T4:
 		case LINK_100TXFD:
 			vars->line_speed = SPEED_100;
@@ -4723,14 +4723,14 @@ static void bnx2x_sync_link(struct link_params *params,
 
 		case LINK_1000THD:
 			vars->duplex = DUPLEX_HALF;
-			/* Fall thru */
+			fallthrough;
 		case LINK_1000TFD:
 			vars->line_speed = SPEED_1000;
 			break;
 
 		case LINK_2500THD:
 			vars->duplex = DUPLEX_HALF;
-			/* Fall thru */
+			fallthrough;
 		case LINK_2500TFD:
 			vars->line_speed = SPEED_2500;
 			break;
@@ -6335,7 +6335,7 @@ int bnx2x_set_led(struct link_params *params,
 		 */
 		if (!vars->link_up)
 			break;
-		/* fall through */
+		fallthrough;
 	case LED_MODE_ON:
 		if (((params->phy[EXT_PHY1].type ==
 			  PORT_HW_CFG_XGXS_EXT_PHY_TYPE_BCM8727) ||
@@ -12503,13 +12503,13 @@ static void bnx2x_phy_def_cfg(struct link_params *params,
 	switch (link_config  & PORT_FEATURE_LINK_SPEED_MASK) {
 	case PORT_FEATURE_LINK_SPEED_10M_HALF:
 		phy->req_duplex = DUPLEX_HALF;
-		/* fall through */
+		fallthrough;
 	case PORT_FEATURE_LINK_SPEED_10M_FULL:
 		phy->req_line_speed = SPEED_10;
 		break;
 	case PORT_FEATURE_LINK_SPEED_100M_HALF:
 		phy->req_duplex = DUPLEX_HALF;
-		/* fall through */
+		fallthrough;
 	case PORT_FEATURE_LINK_SPEED_100M_FULL:
 		phy->req_line_speed = SPEED_100;
 		break;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index db5107e7..d0580d 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -8583,12 +8583,10 @@ int bnx2x_set_int_mode(struct bnx2x *bp)
 		BNX2X_DEV_INFO("Failed to enable multiple MSI-X (%d), set number of queues to %d\n",
 			       bp->num_queues,
 			       1 + bp->num_cnic_queues);
-
-		/* fall through */
+		fallthrough;
 	case BNX2X_INT_MODE_MSI:
 		bnx2x_enable_msi(bp);
-
-		/* fall through */
+		fallthrough;
 	case BNX2X_INT_MODE_INTX:
 		bp->num_ethernet_queues = 1;
 		bp->num_queues = bp->num_ethernet_queues + bp->num_cnic_queues;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 5097a44..eeaeb9 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -1830,7 +1830,7 @@ int bnx2x_iov_eq_sp_event(struct bnx2x *bp, union event_ring_elem *elem)
 		DP(BNX2X_MSG_IOV, "got VF [%d:%d] RSS update ramrod\n",
 		   vf->abs_vfid, qidx);
 		bnx2x_vf_handle_rss_update_eqe(bp, vf);
-		/* fall through */
+		fallthrough;
 	case EVENT_RING_OPCODE_VF_FLR:
 		/* Do nothing for now */
 		return 0;
@@ -2228,7 +2228,7 @@ int bnx2x_vf_free(struct bnx2x *bp, struct bnx2x_virtf *vf)
 		rc = bnx2x_vf_close(bp, vf);
 		if (rc)
 			goto op_err;
-		/* Fall through - to release resources */
+		fallthrough;	/* to release resources */
 	case VF_ACQUIRED:
 		DP(BNX2X_MSG_IOV, "about to free resources\n");
 		bnx2x_vf_free_resc(bp, vf);
-- 
2.24.0

