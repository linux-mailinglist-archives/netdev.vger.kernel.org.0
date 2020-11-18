Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8322B7D00
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 12:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgKRLox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 06:44:53 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12244 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726385AbgKRLow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 06:44:52 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AIBf9Wi009100;
        Wed, 18 Nov 2020 03:44:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=M2FBQ6FG+zlG43HsdXNIgzkAINiD5WRTnxBJUwYnoog=;
 b=ZORTuJ6+Q8GqF4P8tHtD51arPCudokqzjIFanZmW0RUVnD4SA8qNRhHFvNmeno94r9f1
 RsqZtkqr7dYAvfZ6neDZrkXCThCgGVOtqkwvTPy8BhxiUmKNkX7Ok23X2+DBNPNbJBv1
 f5txjHVHnhtM+iiL9SZHKJkZxDWUWGurBzh4bFIX2ZCHzyAfQ3oJFYOk+lHu37XXXyJZ
 1RGQiERN6O/sw2USWExDK8YSHGIHoXRx2jaL34ftQ1HjS3yfQcwB5CPRENeQOMw3A0Jk
 561FIFFSTXIuinktjh9ZUCO2WHSotiSzY8ge87bLvWc0TAjr2sno8F3YuJzcGTgr4Oth zg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 34vd2scyse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 03:44:49 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Nov
 2020 03:44:48 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Nov 2020 03:44:48 -0800
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 169603F703F;
        Wed, 18 Nov 2020 03:44:44 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v10,net-next,3/3] octeontx2-af: add debugfs entries for CPT block
Date:   Wed, 18 Nov 2020 17:14:16 +0530
Message-ID: <20201118114416.28307-4-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201118114416.28307-1-schalla@marvell.com>
References: <20201118114416.28307-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_04:2020-11-17,2020-11-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add entries to debugfs at /sys/kernel/debug/octeontx2/cpt.

cpt_pc: dump cpt performance HW registers.
Usage:
cat /sys/kernel/debug/octeontx2/cpt/cpt_pc

cpt_ae_sts: show cpt asymmetric engines current state
Usage:
cat /sys/kernel/debug/octeontx2/cpt/cpt_ae_sts

cpt_se_sts: show cpt symmetric engines current state
Usage:
cat /sys/kernel/debug/octeontx2/cpt/cpt_se_sts

cpt_engines_info: dump cpt engine control registers.
Usage:
cat /sys/kernel/debug/octeontx2/cpt/cpt_engines_info

cpt_lfs_info: dump cpt lfs control registers.
Usage:
cat /sys/kernel/debug/octeontx2/cpt/cpt_lfs_info

cpt_err_info: dump cpt error registers.
Usage:
cat /sys/kernel/debug/octeontx2/cpt/cpt_err_info

Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   1 +
 .../marvell/octeontx2/af/rvu_debugfs.c        | 272 ++++++++++++++++++
 2 files changed, 273 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 37774bac32b0..b6c0977499ab 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -52,6 +52,7 @@ struct rvu_debugfs {
 	struct dentry *npa;
 	struct dentry *nix;
 	struct dentry *npc;
+	struct dentry *cpt;
 	struct dump_ctx npa_aura_ctx;
 	struct dump_ctx npa_pool_ctx;
 	struct dump_ctx nix_cq_ctx;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 39e1a614aaf8..c383efc6b90c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -109,6 +109,12 @@ static char *cgx_tx_stats_fields[] = {
 	[CGX_STAT17]	= "Control/PAUSE packets sent",
 };
 
+enum cpt_eng_type {
+	CPT_AE_TYPE = 1,
+	CPT_SE_TYPE = 2,
+	CPT_IE_TYPE = 3,
+};
+
 #define NDC_MAX_BANK(rvu, blk_addr) (rvu_read64(rvu, \
 						blk_addr, NDC_AF_CONST) & 0xFF)
 
@@ -1993,6 +1999,271 @@ static void rvu_dbg_npc_init(struct rvu *rvu)
 	debugfs_remove_recursive(rvu->rvu_dbg.npc);
 }
 
+/* CPT debugfs APIs */
+static int cpt_eng_sts_display(struct seq_file *filp, u8 eng_type)
+{
+	struct rvu *rvu = filp->private;
+	u64 busy_sts = 0, free_sts = 0;
+	u32 e_min = 0, e_max = 0, e, i;
+	u16 max_ses, max_ies, max_aes;
+	int blkaddr;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
+	max_ses = reg & 0xffff;
+	max_ies = (reg >> 16) & 0xffff;
+	max_aes = (reg >> 32) & 0xffff;
+
+	switch (eng_type) {
+	case CPT_AE_TYPE:
+		e_min = max_ses + max_ies;
+		e_max = max_ses + max_ies + max_aes;
+		break;
+	case CPT_SE_TYPE:
+		e_min = 0;
+		e_max = max_ses;
+		break;
+	case CPT_IE_TYPE:
+		e_min = max_ses;
+		e_max = max_ses + max_ies;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	for (e = e_min, i = 0; e < e_max; e++, i++) {
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_STS(e));
+		if (reg & 0x1)
+			busy_sts |= 1ULL << i;
+
+		if (reg & 0x2)
+			free_sts |= 1ULL << i;
+	}
+	seq_printf(filp, "FREE STS : 0x%016llx\n", free_sts);
+	seq_printf(filp, "BUSY STS : 0x%016llx\n", busy_sts);
+
+	return 0;
+}
+
+static int rvu_dbg_cpt_ae_sts_display(struct seq_file *filp, void *unused)
+{
+	return cpt_eng_sts_display(filp, CPT_AE_TYPE);
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_ae_sts, cpt_ae_sts_display, NULL);
+
+static int rvu_dbg_cpt_se_sts_display(struct seq_file *filp, void *unused)
+{
+	return cpt_eng_sts_display(filp, CPT_SE_TYPE);
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_se_sts, cpt_se_sts_display, NULL);
+
+static int rvu_dbg_cpt_ie_sts_display(struct seq_file *filp, void *unused)
+{
+	return cpt_eng_sts_display(filp, CPT_IE_TYPE);
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_ie_sts, cpt_ie_sts_display, NULL);
+
+static int rvu_dbg_cpt_engines_info_display(struct seq_file *filp, void *unused)
+{
+	struct rvu *rvu = filp->private;
+	u16 max_ses, max_ies, max_aes;
+	u32 e_max, e;
+	int blkaddr;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
+	max_ses = reg & 0xffff;
+	max_ies = (reg >> 16) & 0xffff;
+	max_aes = (reg >> 32) & 0xffff;
+
+	e_max = max_ses + max_ies + max_aes;
+
+	seq_puts(filp, "===========================================\n");
+	for (e = 0; e < e_max; e++) {
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_CTL2(e));
+		seq_printf(filp, "CPT Engine[%u] Group Enable   0x%02llx\n", e,
+			   reg & 0xff);
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_ACTIVE(e));
+		seq_printf(filp, "CPT Engine[%u] Active Info    0x%llx\n", e,
+			   reg);
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_CTL(e));
+		seq_printf(filp, "CPT Engine[%u] Control        0x%llx\n", e,
+			   reg);
+		seq_puts(filp, "===========================================\n");
+	}
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_engines_info, cpt_engines_info_display, NULL);
+
+static int rvu_dbg_cpt_lfs_info_display(struct seq_file *filp, void *unused)
+{
+	struct rvu *rvu = filp->private;
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_block *block;
+	int blkaddr;
+	u64 reg;
+	u32 lf;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	block = &hw->block[blkaddr];
+	if (!block->lf.bmap)
+		return -ENODEV;
+
+	seq_puts(filp, "===========================================\n");
+	for (lf = 0; lf < block->lf.max; lf++) {
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL(lf));
+		seq_printf(filp, "CPT Lf[%u] CTL          0x%llx\n", lf, reg);
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL2(lf));
+		seq_printf(filp, "CPT Lf[%u] CTL2         0x%llx\n", lf, reg);
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_LFX_PTR_CTL(lf));
+		seq_printf(filp, "CPT Lf[%u] PTR_CTL      0x%llx\n", lf, reg);
+		reg = rvu_read64(rvu, blkaddr, block->lfcfg_reg |
+				(lf << block->lfshift));
+		seq_printf(filp, "CPT Lf[%u] CFG          0x%llx\n", lf, reg);
+		seq_puts(filp, "===========================================\n");
+	}
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_lfs_info, cpt_lfs_info_display, NULL);
+
+static int rvu_dbg_cpt_err_info_display(struct seq_file *filp, void *unused)
+{
+	struct rvu *rvu = filp->private;
+	u64 reg0, reg1;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(0));
+	reg1 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(1));
+	seq_printf(filp, "CPT_AF_FLTX_INT:       0x%llx 0x%llx\n", reg0, reg1);
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_PSNX_EXE(0));
+	reg1 = rvu_read64(rvu, blkaddr, CPT_AF_PSNX_EXE(1));
+	seq_printf(filp, "CPT_AF_PSNX_EXE:       0x%llx 0x%llx\n", reg0, reg1);
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_PSNX_LF(0));
+	seq_printf(filp, "CPT_AF_PSNX_LF:        0x%llx\n", reg0);
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_RVU_INT);
+	seq_printf(filp, "CPT_AF_RVU_INT:        0x%llx\n", reg0);
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_RAS_INT);
+	seq_printf(filp, "CPT_AF_RAS_INT:        0x%llx\n", reg0);
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_EXE_ERR_INFO);
+	seq_printf(filp, "CPT_AF_EXE_ERR_INFO:   0x%llx\n", reg0);
+
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_err_info, cpt_err_info_display, NULL);
+
+static int rvu_dbg_cpt_pc_display(struct seq_file *filp, void *unused)
+{
+	struct rvu *rvu;
+	int blkaddr;
+	u64 reg;
+
+	rvu = filp->private;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_INST_REQ_PC);
+	seq_printf(filp, "CPT instruction requests   %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_INST_LATENCY_PC);
+	seq_printf(filp, "CPT instruction latency    %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_RD_REQ_PC);
+	seq_printf(filp, "CPT NCB read requests      %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_RD_LATENCY_PC);
+	seq_printf(filp, "CPT NCB read latency       %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_RD_UC_PC);
+	seq_printf(filp, "CPT read requests caused by UC fills   %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_ACTIVE_CYCLES_PC);
+	seq_printf(filp, "CPT active cycles pc       %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_CPTCLK_CNT);
+	seq_printf(filp, "CPT clock count pc         %llu\n", reg);
+
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_pc, cpt_pc_display, NULL);
+
+static void rvu_dbg_cpt_init(struct rvu *rvu)
+{
+	const struct device *dev = &rvu->pdev->dev;
+	struct dentry *pfile;
+
+	if (!is_block_implemented(rvu->hw, BLKADDR_CPT0))
+		return;
+
+	rvu->rvu_dbg.cpt = debugfs_create_dir("cpt", rvu->rvu_dbg.root);
+	if (!rvu->rvu_dbg.cpt)
+		return;
+
+	pfile = debugfs_create_file("cpt_pc", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_pc_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("cpt_ae_sts", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_ae_sts_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("cpt_se_sts", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_se_sts_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("cpt_ie_sts", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_ie_sts_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("cpt_engines_info", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_engines_info_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("cpt_lfs_info", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_lfs_info_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("cpt_err_info", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_err_info_fops);
+	if (!pfile)
+		goto create_failed;
+
+	return;
+
+create_failed:
+	dev_err(dev, "Failed to create debugfs dir/file for CPT\n");
+	debugfs_remove_recursive(rvu->rvu_dbg.cpt);
+}
+
 void rvu_dbg_init(struct rvu *rvu)
 {
 	struct device *dev = &rvu->pdev->dev;
@@ -2019,6 +2290,7 @@ void rvu_dbg_init(struct rvu *rvu)
 	rvu_dbg_nix_init(rvu, BLKADDR_NIX1);
 	rvu_dbg_cgx_init(rvu);
 	rvu_dbg_npc_init(rvu);
+	rvu_dbg_cpt_init(rvu);
 
 	return;
 
-- 
2.29.0

