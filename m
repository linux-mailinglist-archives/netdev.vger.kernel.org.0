Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42926180F52
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 06:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgCKFHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 01:07:50 -0400
Received: from smtprelay0189.hostedemail.com ([216.40.44.189]:51892 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728367AbgCKFHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 01:07:48 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id ABEA1101957E9;
        Wed, 11 Mar 2020 05:07:45 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:541:800:960:967:973:982:988:989:1260:1311:1314:1345:1359:1437:1515:1535:1544:1711:1730:1747:1777:1792:2194:2199:2393:2525:2560:2563:2682:2685:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3355:3865:3866:3867:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6117:6261:7903:9025:9592:10004:10848:11026:11473:11657:11658:11914:12043:12048:12296:12297:12438:12555:12679:12895:12986:13255:13894:14096:14181:14394:14721:21080:21433:21627:21740:21811:21939:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: part64_266fa05205b03
X-Filterd-Recvd-Size: 5757
Received: from joe-laptop.perches.com (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 11 Mar 2020 05:07:44 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Michael Chan <michael.chan@broadcom.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH -next 029/491] BROADCOM BNXT_EN 50 GIGABIT ETHERNET DRIVER: Use fallthrough;
Date:   Tue, 10 Mar 2020 21:51:43 -0700
Message-Id: <c15f5754b9479b3dc353e1a01de8b6706458d057.1583896349.git.joe@perches.com>
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
 drivers/net/ethernet/broadcom/bnxt/bnxt.c       | 17 ++++++++---------
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c   |  4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c   |  4 ++--
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 663dcf..f964c2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1923,7 +1923,7 @@ u32 bnxt_fw_health_readl(struct bnxt *bp, int reg_idx)
 		break;
 	case BNXT_FW_HEALTH_REG_TYPE_GRC:
 		reg_off = fw_health->mapped_regs[reg_idx];
-		/* fall through */
+		fallthrough;
 	case BNXT_FW_HEALTH_REG_TYPE_BAR0:
 		val = readl(bp->bar0 + reg_off);
 		break;
@@ -1966,11 +1966,11 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		}
 		set_bit(BNXT_LINK_SPEED_CHNG_SP_EVENT, &bp->sp_event);
 	}
-	/* fall through */
+		fallthrough;
 	case ASYNC_EVENT_CMPL_EVENT_ID_LINK_SPEED_CHANGE:
 	case ASYNC_EVENT_CMPL_EVENT_ID_PORT_PHY_CFG_CHANGE:
 		set_bit(BNXT_LINK_CFG_CHANGE_SP_EVENT, &bp->sp_event);
-		/* fall through */
+		fallthrough;
 	case ASYNC_EVENT_CMPL_EVENT_ID_LINK_STATUS_CHANGE:
 		set_bit(BNXT_LINK_CHNG_SP_EVENT, &bp->sp_event);
 		break;
@@ -9400,8 +9400,7 @@ static int bnxt_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	switch (cmd) {
 	case SIOCGMIIPHY:
 		mdio->phy_id = bp->link_info.phy_addr;
-
-		/* fallthru */
+		fallthrough;
 	case SIOCGMIIREG: {
 		u16 mii_regval = 0;
 
@@ -10644,7 +10643,7 @@ static void bnxt_fw_reset_writel(struct bnxt *bp, int reg_idx)
 		writel(reg_off & BNXT_GRC_BASE_MASK,
 		       bp->bar0 + BNXT_GRCPF_REG_WINDOW_BASE_OUT + 4);
 		reg_off = (reg_off & BNXT_GRC_OFFSET_MASK) + 0x2000;
-		/* fall through */
+		fallthrough;
 	case BNXT_FW_HEALTH_REG_TYPE_BAR0:
 		writel(val, bp->bar0 + reg_off);
 		break;
@@ -10757,7 +10756,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		}
 		bp->fw_reset_state = BNXT_FW_RESET_STATE_RESET_FW;
 	}
-	/* fall through */
+		fallthrough;
 	case BNXT_FW_RESET_STATE_RESET_FW:
 		bnxt_reset_all(bp);
 		bp->fw_reset_state = BNXT_FW_RESET_STATE_ENABLE_DEV;
@@ -10780,7 +10779,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		}
 		pci_set_master(bp->pdev);
 		bp->fw_reset_state = BNXT_FW_RESET_STATE_POLL_FW;
-		/* fall through */
+		fallthrough;
 	case BNXT_FW_RESET_STATE_POLL_FW:
 		bp->hwrm_cmd_timeout = SHORT_HWRM_CMD_TIMEOUT;
 		rc = __bnxt_hwrm_ver_get(bp, true);
@@ -10795,7 +10794,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		}
 		bp->hwrm_cmd_timeout = DFLT_HWRM_CMD_TIMEOUT;
 		bp->fw_reset_state = BNXT_FW_RESET_STATE_OPENING;
-		/* fall through */
+		fallthrough;
 	case BNXT_FW_RESET_STATE_OPENING:
 		while (!rtnl_trylock()) {
 			bnxt_queue_fw_reset_work(bp, HZ / 10);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 677bab..af76ba6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1029,7 +1029,7 @@ static int bnxt_grxfh(struct bnxt *bp, struct ethtool_rxnfc *cmd)
 		if (bp->rss_hash_cfg & VNIC_RSS_CFG_REQ_HASH_TYPE_UDP_IPV4)
 			cmd->data |= RXH_IP_SRC | RXH_IP_DST |
 				     RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		/* fall through */
+		fallthrough;
 	case SCTP_V4_FLOW:
 	case AH_ESP_V4_FLOW:
 	case AH_V4_FLOW:
@@ -1048,7 +1048,7 @@ static int bnxt_grxfh(struct bnxt *bp, struct ethtool_rxnfc *cmd)
 		if (bp->rss_hash_cfg & VNIC_RSS_CFG_REQ_HASH_TYPE_UDP_IPV6)
 			cmd->data |= RXH_IP_SRC | RXH_IP_DST |
 				     RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		/* fall through */
+		fallthrough;
 	case SCTP_V6_FLOW:
 	case AH_ESP_V6_FLOW:
 	case AH_V6_FLOW:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index c6f6f20..a974cb2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -200,10 +200,10 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-		/* Fall thru */
+		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(bp->dev, xdp_prog, act);
-		/* Fall thru */
+		fallthrough;
 	case XDP_DROP:
 		bnxt_reuse_rx_data(rxr, cons, page);
 		break;
-- 
2.24.0

