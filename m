Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39657180F56
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 06:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgCKFHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 01:07:52 -0400
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:42648 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728384AbgCKFHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 01:07:51 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 933DE18224506;
        Wed, 11 Mar 2020 05:07:49 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:541:800:960:967:973:982:988:989:1260:1311:1314:1345:1359:1437:1515:1534:1542:1711:1730:1747:1777:1792:2194:2199:2393:2525:2560:2563:2682:2685:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3865:3866:3867:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4225:4321:5007:6119:6261:9025:9592:10004:10848:11026:11473:11657:11658:11914:12043:12296:12297:12438:12555:12679:12895:12986:13894:14181:14394:14721:21080:21433:21627:21811:21939:21987:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: dust64_2714a444d1e09
X-Filterd-Recvd-Size: 3604
Received: from joe-laptop.perches.com (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 11 Mar 2020 05:07:48 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next 031/491] BROCADE BNA 10 GIGABIT ETHERNET DRIVER: Use fallthrough;
Date:   Tue, 10 Mar 2020 21:51:45 -0700
Message-Id: <ea7518e03a5bda3fb9de0f25a0e6624d4d6e7eea.1583896349.git.joe@perches.com>
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
 drivers/net/ethernet/brocade/bna/bfa_ioc.c   | 8 +++-----
 drivers/net/ethernet/brocade/bna/bna_enet.c  | 2 +-
 drivers/net/ethernet/brocade/bna/bna_tx_rx.c | 3 +--
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bfa_ioc.c b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
index e17bfc..e9248c 100644
--- a/drivers/net/ethernet/brocade/bna/bfa_ioc.c
+++ b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
@@ -321,7 +321,7 @@ bfa_ioc_sm_getattr(struct bfa_ioc *ioc, enum ioc_event event)
 	case IOC_E_PFFAILED:
 	case IOC_E_HWERROR:
 		del_timer(&ioc->ioc_timer);
-		/* fall through */
+		fallthrough;
 	case IOC_E_TIMEOUT:
 		ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_fail);
@@ -780,8 +780,7 @@ bfa_iocpf_sm_enabling(struct bfa_iocpf *iocpf, enum iocpf_event event)
 
 	case IOCPF_E_INITFAIL:
 		del_timer(&ioc->iocpf_timer);
-		/* fall through */
-
+		fallthrough;
 	case IOCPF_E_TIMEOUT:
 		bfa_nw_ioc_hw_sem_release(ioc);
 		if (event == IOCPF_E_TIMEOUT)
@@ -849,8 +848,7 @@ bfa_iocpf_sm_disabling(struct bfa_iocpf *iocpf, enum iocpf_event event)
 
 	case IOCPF_E_FAIL:
 		del_timer(&ioc->iocpf_timer);
-		/* fall through*/
-
+		fallthrough;
 	case IOCPF_E_TIMEOUT:
 		bfa_ioc_set_cur_ioc_fwstate(ioc, BFI_IOC_FAIL);
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabling_sync);
diff --git a/drivers/net/ethernet/brocade/bna/bna_enet.c b/drivers/net/ethernet/brocade/bna/bna_enet.c
index 40107a9..a2c983 100644
--- a/drivers/net/ethernet/brocade/bna/bna_enet.c
+++ b/drivers/net/ethernet/brocade/bna/bna_enet.c
@@ -1084,7 +1084,7 @@ bna_enet_sm_cfg_wait(struct bna_enet *enet,
 
 	case ENET_E_CHLD_STOPPED:
 		bna_enet_rx_start(enet);
-		/* Fall through */
+		fallthrough;
 	case ENET_E_FWRESP_PAUSE:
 		if (enet->flags & BNA_ENET_F_PAUSE_CHANGED) {
 			enet->flags &= ~BNA_ENET_F_PAUSE_CHANGED;
diff --git a/drivers/net/ethernet/brocade/bna/bna_tx_rx.c b/drivers/net/ethernet/brocade/bna/bna_tx_rx.c
index b5ecbfe..cd2bfb 100644
--- a/drivers/net/ethernet/brocade/bna/bna_tx_rx.c
+++ b/drivers/net/ethernet/brocade/bna/bna_tx_rx.c
@@ -1636,8 +1636,7 @@ bna_bfi_rx_enet_start(struct bna_rx *rx)
 						&q1->qpt);
 			cfg_req->q_cfg[i].qs.rx_buffer_size =
 				htons((u16)q1->buffer_size);
-			/* Fall through */
-
+			fallthrough;
 		case BNA_RXP_SINGLE:
 			/* Large/Single RxQ */
 			bfi_enet_datapath_q_init(&cfg_req->q_cfg[i].ql.q,
-- 
2.24.0

