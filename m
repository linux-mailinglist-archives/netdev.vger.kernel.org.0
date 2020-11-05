Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476DA2A7A87
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 10:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731744AbgKEJ3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 04:29:34 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13720 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731654AbgKEJ3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 04:29:25 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A59PeK1017228;
        Thu, 5 Nov 2020 01:29:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=GBjYiXnN9YWzBYfs+tahyxv4Vc20bRazh8bKM59gvVY=;
 b=ZFOvqHmEM3EpUS2EuhMKts8qXJGhi3VZ19+CPP17UPDAFh0q2VY3eYYfhR+S+c/na/9W
 qJ7abbBxh6HJzjHUwmkkcq8pPHNfUEWGv0GlI9quA/NyCG9FJWPGo5vhEXg/Imu26KuG
 1sCceRc5gofLrGq3273XQQrkbxdDbMz2GScHNz7AS8LP8MpWUyvpkE9AGW6lRV3gh6IR
 HQBEcJe+m00WjfyEA6OMw8VWqpjFWcDEElJYVtZNbt8+MJNbtyVQATsDAtDFPSky05YY
 RU90GYKC4JKSaMs+2dw4ix0JOwLFKk1CBj8BjBBISXhhybWSx9VEv8pH8npEyg0g71Ka hg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34h7ep6mfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 01:29:21 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 5 Nov
 2020 01:29:19 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 5 Nov 2020 01:29:20 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 9C03D3F704F;
        Thu,  5 Nov 2020 01:29:16 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [PATCH v2 net-next 13/13] octeontx2-af: Delete NIX_RXVLAN_ALLOC mailbox message
Date:   Thu, 5 Nov 2020 14:58:16 +0530
Message-ID: <20201105092816.819-14-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20201105092816.819-1-naveenm@marvell.com>
References: <20201105092816.819-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_05:2020-11-05,2020-11-05 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Since mailbox message for installing flows is in place,
remove the RXVLAN_ALLOC mbox message which is redundant.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  1 -
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  6 ---
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 59 ----------------------
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 24 ---------
 4 files changed, 90 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 8ea132ec1784..cb4e3d86b58b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -226,7 +226,6 @@ M(NIX_SET_RX_CFG,	0x8010, nix_set_rx_cfg, nix_rx_cfg, msg_rsp)	\
 M(NIX_LSO_FORMAT_CFG,	0x8011, nix_lso_format_cfg,			\
 				 nix_lso_format_cfg,			\
 				 nix_lso_format_cfg_rsp)		\
-M(NIX_RXVLAN_ALLOC,	0x8012, nix_rxvlan_alloc, msg_req, msg_rsp)	\
 M(NIX_LF_PTP_TX_ENABLE, 0x8013, nix_lf_ptp_tx_enable, msg_req, msg_rsp)	\
 M(NIX_LF_PTP_TX_DISABLE, 0x8014, nix_lf_ptp_tx_disable, msg_req, msg_rsp) \
 M(NIX_BP_ENABLE,	0x8016, nix_bp_enable, nix_bp_cfg_req,	\
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 4bc75be6d45b..044dde24865c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -217,11 +217,6 @@ struct rvu_pfvf {
 	u16			bcast_mce_idx;
 	struct nix_mce_list	bcast_mce_list;
 
-	/* VLAN offload */
-	struct mcam_entry entry;
-	int rxvlan_index;
-	bool rxvlan;
-
 	struct rvu_npc_mcam_rule *def_ucast_rule;
 
 	bool	cgx_in_use; /* this PF/VF using CGX? */
@@ -571,7 +566,6 @@ void rvu_npc_enable_promisc_entry(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 				       int nixlf, u64 chan);
 void rvu_npc_enable_bcast_entry(struct rvu *rvu, u16 pcifunc, bool enable);
-int rvu_npc_update_rxvlan(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_free_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index f5affb809c77..89601e796c85 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3144,65 +3144,6 @@ int rvu_mbox_handler_nix_set_hw_frs(struct rvu *rvu, struct nix_frs_cfg *req,
 	return 0;
 }
 
-int rvu_mbox_handler_nix_rxvlan_alloc(struct rvu *rvu, struct msg_req *req,
-				      struct msg_rsp *rsp)
-{
-	struct npc_mcam_alloc_entry_req alloc_req = { };
-	struct npc_mcam_alloc_entry_rsp alloc_rsp = { };
-	struct npc_mcam_free_entry_req free_req = { };
-	u16 pcifunc = req->hdr.pcifunc;
-	int blkaddr, nixlf, err;
-	struct rvu_pfvf *pfvf;
-
-	/* LBK VFs do not have separate MCAM UCAST entry hence
-	 * skip allocating rxvlan for them
-	 */
-	if (is_afvf(pcifunc))
-		return 0;
-
-	pfvf = rvu_get_pfvf(rvu, pcifunc);
-	if (pfvf->rxvlan)
-		return 0;
-
-	/* alloc new mcam entry */
-	alloc_req.hdr.pcifunc = pcifunc;
-	alloc_req.count = 1;
-
-	err = rvu_mbox_handler_npc_mcam_alloc_entry(rvu, &alloc_req,
-						    &alloc_rsp);
-	if (err)
-		return err;
-
-	/* update entry to enable rxvlan offload */
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
-	if (blkaddr < 0) {
-		err = NIX_AF_ERR_AF_LF_INVALID;
-		goto free_entry;
-	}
-
-	nixlf = rvu_get_lf(rvu, &rvu->hw->block[blkaddr], pcifunc, 0);
-	if (nixlf < 0) {
-		err = NIX_AF_ERR_AF_LF_INVALID;
-		goto free_entry;
-	}
-
-	pfvf->rxvlan_index = alloc_rsp.entry_list[0];
-	/* all it means is that rxvlan_index is valid */
-	pfvf->rxvlan = true;
-
-	err = rvu_npc_update_rxvlan(rvu, pcifunc, nixlf);
-	if (err)
-		goto free_entry;
-
-	return 0;
-free_entry:
-	free_req.hdr.pcifunc = pcifunc;
-	free_req.entry = alloc_rsp.entry_list[0];
-	rvu_mbox_handler_npc_mcam_free_entry(rvu, &free_req, rsp);
-	pfvf->rxvlan = false;
-	return err;
-}
-
 int rvu_mbox_handler_nix_set_rx_cfg(struct rvu *rvu, struct nix_rx_cfg *req,
 				    struct msg_rsp *rsp)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 9b5c5b376cc6..a4764f8c1c39 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2731,30 +2731,6 @@ int rvu_mbox_handler_npc_get_kex_cfg(struct rvu *rvu, struct msg_req *req,
 	return 0;
 }
 
-int rvu_npc_update_rxvlan(struct rvu *rvu, u16 pcifunc, int nixlf)
-{
-	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
-	struct npc_mcam *mcam = &rvu->hw->mcam;
-	int blkaddr, index;
-	bool enable;
-
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
-	if (blkaddr < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
-
-	if (!pfvf->rxvlan)
-		return 0;
-
-	index = npc_get_nixlf_mcam_index(mcam, pcifunc, nixlf,
-					 NIXLF_UCAST_ENTRY);
-	pfvf->entry.action = npc_get_mcam_action(rvu, mcam, blkaddr, index);
-	enable = is_mcam_entry_enabled(rvu, mcam, blkaddr, index);
-	npc_config_mcam_entry(rvu, mcam, blkaddr, pfvf->rxvlan_index,
-			      pfvf->nix_rx_intf, &pfvf->entry, enable);
-
-	return 0;
-}
-
 bool rvu_npc_write_default_rule(struct rvu *rvu, int blkaddr, int nixlf,
 				u16 pcifunc, u8 intf, struct mcam_entry *entry,
 				int *index)
-- 
2.16.5

