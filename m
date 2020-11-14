Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF2A2B3066
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgKNTyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:54:09 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27866 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726597AbgKNTyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 14:54:06 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AEJoKUN028813;
        Sat, 14 Nov 2020 11:54:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=RDKnjkMWcb9XcxquCZp7Id0IDj54WEsA//SP/QEzMq0=;
 b=df8786DY8Kga4cueaFwnUIagBbFnSbP5+xrZTO0W0DDfhLN4iOo06SnJPjvnD1FNq5Jl
 FfvCdJypbP6upzYAyGFVg2cFhXwTXpuB5BvE+eoaLc8myaYJLuKyt9/HgobZqw4oNDnV
 bfNdAEyR4FyJ0k5xf8UbbYTL3ld0JD46IuKNsLdeigoD/Uf+AVlthAzR47aeBwR3caXE
 jHKiOtX/eCzWQ6HBDqmk17lk1PSGXqoZGBaGvtfvyJrNn9GXd2r+HlNNH/CA2ekPaIzd
 ZvuEspeP74G0iMwycqTjoLd/AQi9os/Yq4h2zPFXGVmEDrLvPBe7Tb/ggseaGGuk547Q oQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 34tdfts05w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 14 Nov 2020 11:54:03 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 11:54:02 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 14 Nov 2020 11:54:02 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id D95B83F703F;
        Sat, 14 Nov 2020 11:53:58 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <saeed@kernel.org>,
        <alexander.duyck@gmail.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [PATCH v4 net-next 13/13] octeontx2-af: Delete NIX_RXVLAN_ALLOC mailbox message
Date:   Sun, 15 Nov 2020 01:23:03 +0530
Message-ID: <20201114195303.25967-14-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20201114195303.25967-1-naveenm@marvell.com>
References: <20201114195303.25967-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-14_07:2020-11-13,2020-11-14 signatures=0
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
index fd46092ad189..37774bac32b0 100644
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
index 9444c857ed3d..e8d039503097 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3142,65 +3142,6 @@ int rvu_mbox_handler_nix_set_hw_frs(struct rvu *rvu, struct nix_frs_cfg *req,
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
index dd54d41801fb..5cf9b7a907ae 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2730,30 +2730,6 @@ int rvu_mbox_handler_npc_get_kex_cfg(struct rvu *rvu, struct msg_req *req,
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

