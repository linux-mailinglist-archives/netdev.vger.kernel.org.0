Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7952D3BC819
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 10:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbhGFIwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 04:52:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51767 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbhGFIwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 04:52:43 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1m0gmE-0001VT-Rv; Tue, 06 Jul 2021 08:49:58 +0000
From:   Colin King <colin.king@canonical.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] octeontx2-af: Fix a handful of spelling mistakes and typos
Date:   Tue,  6 Jul 2021 09:49:58 +0100
Message-Id: <20210706084958.17209-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are quite a few spelling mistakes in dev_err error messages
and comments. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c  |  4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c  |  4 ++--
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c    | 10 +++++-----
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c  |  4 ++--
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c  | 16 ++++++++--------
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c  | 12 ++++++------
 6 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 9169849881bf..7b548bd7238c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -972,7 +972,7 @@ static int cgx_link_usertable_index_map(int speed)
 static void set_mod_args(struct cgx_set_link_mode_args *args,
 			 u32 speed, u8 duplex, u8 autoneg, u64 mode)
 {
-	/* Fill default values incase of user did not pass
+	/* Fill default values in case of user did not pass
 	 * valid parameters
 	 */
 	if (args->duplex == DUPLEX_UNKNOWN)
@@ -1183,7 +1183,7 @@ static irqreturn_t cgx_fwi_event_handler(int irq, void *data)
 		/* Ensure response is updated before thread context starts */
 		smp_wmb();
 
-		/* There wont be separate events for link change initiated from
+		/* There won't be separate events for link change initiated from
 		 * software; Hence report the command responses as events
 		 */
 		if (cgx_cmdresp_is_linkevent(event))
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
index 1ee37853f338..4ceda6cdacf9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -117,7 +117,7 @@ static int ptp_adjfine(struct ptp *ptp, long scaled_ppm)
 
 	/* The hardware adds the clock compensation value to the PTP clock
 	 * on every coprocessor clock cycle. Typical convention is that it
-	 * represent number of nanosecond betwen each cycle. In this
+	 * represent number of nanosecond between each cycle. In this
 	 * convention compensation value is in 64 bit fixed-point
 	 * representation where upper 32 bits are number of nanoseconds
 	 * and lower is fractions of nanosecond.
@@ -127,7 +127,7 @@ static int ptp_adjfine(struct ptp *ptp, long scaled_ppm)
 	 * arithmetic on following formula
 	 * comp = tbase + tbase * scaled_ppm / (1M * 2^16)
 	 * where tbase is the basic compensation value calculated
-	 * initialy in the probe function.
+	 * initially in the probe function.
 	 */
 	comp = ((u64)1000000000ull << 32) / ptp->clock_rate;
 	/* convert scaled_ppm to ppb */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index 8d48b64485c6..cd8c07e14c28 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -62,7 +62,7 @@ static int rvu_get_lmtaddr(struct rvu *rvu, u16 pcifunc,
 	int err;
 
 	if (!iova) {
-		dev_err(rvu->dev, "%s Requested Null address for transulation\n", __func__);
+		dev_err(rvu->dev, "%s Requested Null address for translation\n", __func__);
 		return -EINVAL;
 	}
 
@@ -74,12 +74,12 @@ static int rvu_get_lmtaddr(struct rvu *rvu, u16 pcifunc,
 
 	err = rvu_poll_reg(rvu, BLKADDR_RVUM, RVU_AF_SMMU_ADDR_RSP_STS, BIT_ULL(0), false);
 	if (err) {
-		dev_err(rvu->dev, "%s LMTLINE iova transulation failed\n", __func__);
+		dev_err(rvu->dev, "%s LMTLINE iova translation failed\n", __func__);
 		return err;
 	}
 	val = rvu_read64(rvu, BLKADDR_RVUM, RVU_AF_SMMU_ADDR_RSP_STS);
 	if (val & ~0x1ULL) {
-		dev_err(rvu->dev, "%s LMTLINE iova transulation failed err:%llx\n", __func__, val);
+		dev_err(rvu->dev, "%s LMTLINE iova translation failed err:%llx\n", __func__, val);
 		return -EIO;
 	}
 	/* PA[51:12] = RVU_AF_SMMU_TLN_FLIT1[60:21]
@@ -243,7 +243,7 @@ int rvu_set_channels_base(struct rvu *rvu)
 	/* If programmable channels are present then configure
 	 * channels such that all channel numbers are contiguous
 	 * leaving no holes. This way the new CPT channels can be
-	 * accomodated. The order of channel numbers assigned is
+	 * accommodated. The order of channel numbers assigned is
 	 * LBK, SDP, CGX and CPT.
 	 */
 	hw->sdp_chan_base = hw->lbk_chan_base + hw->lbk_links *
@@ -294,7 +294,7 @@ static void rvu_lbk_set_channels(struct rvu *rvu)
 	u16 chans;
 
 	/* To loopback packets between multiple NIX blocks
-	 * mutliple LBK blocks are needed. With two NIX blocks,
+	 * multiple LBK blocks are needed. With two NIX blocks,
 	 * four LBK blocks are needed and each LBK block
 	 * source and destination are as follows:
 	 * LBK0 - source NIX0 and destination NIX1
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 370d4ca1e5ed..637d7c0052f2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -431,7 +431,7 @@ static void print_npa_qsize(struct seq_file *m, struct rvu_pfvf *pfvf)
 /* The 'qsize' entry dumps current Aura/Pool context Qsize
  * and each context's current enable/disable status in a bitmap.
  */
-static int rvu_dbg_qsize_display(struct seq_file *filp, void *unsused,
+static int rvu_dbg_qsize_display(struct seq_file *filp, void *unused,
 				 int blktype)
 {
 	void (*print_qsize)(struct seq_file *filp,
@@ -2141,7 +2141,7 @@ static void rvu_print_npc_mcam_info(struct seq_file *s,
 	}
 }
 
-static int rvu_dbg_npc_mcam_info_display(struct seq_file *filp, void *unsued)
+static int rvu_dbg_npc_mcam_info_display(struct seq_file *filp, void *unused)
 {
 	struct rvu *rvu = filp->private;
 	int pf, vf, numvfs, blkaddr;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index aeae37704428..a611d43bc09a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -398,11 +398,11 @@ static int rvu_nix_get_bpid(struct rvu *rvu, struct nix_bp_cfg_req *req,
 	pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
 
 	/* Backpressure IDs range division
-	 * CGX channles are mapped to (0 - 191) BPIDs
-	 * LBK channles are mapped to (192 - 255) BPIDs
-	 * SDP channles are mapped to (256 - 511) BPIDs
+	 * CGX channels are mapped to (0 - 191) BPIDs
+	 * LBK channels are mapped to (192 - 255) BPIDs
+	 * SDP channels are mapped to (256 - 511) BPIDs
 	 *
-	 * Lmac channles and bpids mapped as follows
+	 * Lmac channels and bpids mapped as follows
 	 * cgx(0)_lmac(0)_chan(0 - 15) = bpid(0 - 15)
 	 * cgx(0)_lmac(1)_chan(0 - 15) = bpid(16 - 31) ....
 	 * cgx(1)_lmac(0)_chan(0 - 15) = bpid(64 - 79) ....
@@ -1491,7 +1491,7 @@ static int nix_check_txschq_alloc_req(struct rvu *rvu, int lvl, u16 pcifunc,
 		return 0;
 	}
 
-	/* Get free SCHQ count and check if request can be accomodated */
+	/* Get free SCHQ count and check if request can be accommodated */
 	if (hw->cap.nix_fixed_txschq_mapping) {
 		nix_get_txschq_range(rvu, pcifunc, link, &start, &end);
 		schq = start + (pcifunc & RVU_PFVF_FUNC_MASK);
@@ -1625,7 +1625,7 @@ int rvu_mbox_handler_nix_txsch_alloc(struct rvu *rvu,
 	mutex_lock(&rvu->rsrc_lock);
 
 	/* Check if request is valid as per HW capabilities
-	 * and can be accomodated.
+	 * and can be accommodated.
 	 */
 	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
 		rc = nix_check_txschq_alloc_req(rvu, lvl, pcifunc, nix_hw, req);
@@ -3041,7 +3041,7 @@ static int reserve_flowkey_alg_idx(struct rvu *rvu, int blkaddr, u32 flow_cfg)
 			    NIX_AF_RX_FLOW_KEY_ALGX_FIELDX(hw->flowkey.in_use,
 							   fid), field[fid]);
 
-	/* Store the flow_cfg for futher lookup */
+	/* Store the flow_cfg for further lookup */
 	rc = hw->flowkey.in_use;
 	hw->flowkey.flowkey[rc] = flow_cfg;
 	hw->flowkey.in_use++;
@@ -3723,7 +3723,7 @@ static int rvu_nix_block_init(struct rvu *rvu, struct nix_hw *nix_hw)
 				    (ltdefs->rx_apad1.ltype_match << 4) |
 				    ltdefs->rx_apad1.ltype_mask);
 
-			/* Receive ethertype defination register defines layer
+			/* Receive ethertype definition register defines layer
 			 * information in NPC_RESULT_S to identify the Ethertype
 			 * location in L2 header. Used for Ethertype overwriting
 			 * in inline IPsec flow.
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 3612e0a2cab3..35ef314a8b23 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1048,7 +1048,7 @@ void npc_enadis_default_mce_entry(struct rvu *rvu, u16 pcifunc,
 		return;
 	}
 
-	/* return incase mce list is not enabled */
+	/* return in case mce list is not enabled */
 	pfvf = rvu_get_pfvf(rvu, pcifunc & ~RVU_PFVF_FUNC_MASK);
 	if (hw->cap.nix_rx_multicast && is_vf(pcifunc) &&
 	    type != NIXLF_BCAST_ENTRY && !pfvf->use_mce_list)
@@ -2298,7 +2298,7 @@ npc_get_mcam_search_range_priority(struct npc_mcam *mcam,
 	 * - If reference entry is not in hprio zone then
 	 *      search range: ref_entry to end.
 	 * - If reference entry is in hprio zone and if
-	 *   request can be accomodated in non-hprio zone then
+	 *   request can be accommodated in non-hprio zone then
 	 *      search range: 'start of middle zone' to 'end'
 	 * - else search in reverse, so that less number of hprio
 	 *   zone entries are allocated.
@@ -2325,7 +2325,7 @@ npc_get_mcam_search_range_priority(struct npc_mcam *mcam,
 	 * - If reference entry is not in lprio zone then
 	 *      search range: 0 to ref_entry.
 	 * - If reference entry is in lprio zone and if
-	 *   request can be accomodated in middle zone then
+	 *   request can be accommodated in middle zone then
 	 *      search range: 'hprio_end' to 'lprio_start'
 	 */
 
@@ -2376,7 +2376,7 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
 	 * Reverse bitmap is used to allocate entries
 	 * - when a higher priority entry is requested
 	 * - when available free entries are less.
-	 * Lower priority ones out of avaialble free entries are always
+	 * Lower priority ones out of available free entries are always
 	 * chosen when 'high vs low' question arises.
 	 */
 
@@ -2397,7 +2397,7 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
 	hp_fcnt = npc_mcam_get_free_count(mcam->bmap, 0, mcam->hprio_end);
 	fcnt = mcam->bmap_fcnt - lp_fcnt - hp_fcnt;
 
-	/* Check if request can be accomodated in the middle zone */
+	/* Check if request can be accommodated in the middle zone */
 	if (fcnt > req->count) {
 		start = mcam->hprio_end;
 		end = mcam->lprio_start;
@@ -2461,7 +2461,7 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
 		}
 	}
 
-	/* If allocating requested no of entries is unsucessful,
+	/* If allocating requested no of entries is unsuccessful,
 	 * expand the search range to full bitmap length and retry.
 	 */
 	if (!req->priority && (rsp->count < req->count) &&
-- 
2.31.1

