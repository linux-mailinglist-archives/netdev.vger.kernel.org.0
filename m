Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0549D1C6F68
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgEFLeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:34:08 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:11758 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727804AbgEFLeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:34:06 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046BWeWv010403;
        Wed, 6 May 2020 04:34:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=ek4mtKQAA9sPAecrmSdae1JLQJXPdzyoBw2gMJlNAx0=;
 b=HtsnQKEFnP4RHXWA1x5Vh5eM3CEQkcAnvvQjpt37KpNGvrVJeuIxj+BzOd5UtbJbd840
 BaqiGG6b3oywEOxsEGtDECTSmSTpXsPiqHeXQSh5sMYulFecl77d7rFVKZ5T6ThK7hCL
 /7dVGuzQipwS4zG9RFXwd2TZHtyZPsI94L6H/Md+l1Xb9WMWqMWZ8n53fMOap4MZznmi
 04MMp1VmUD7cRLfq5xgbZSjOKTKk3DpPiFaNIaX+bhI4TIYpx0GTCwdPhW9J/7cHcJEy
 WvIRc3wVoXPjCPHPbGiRgojoNjEM1PHIJ0BuyTDwOsi2cohPP5M0SGvU+7iEgh4JVn/a UQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 30uaukvqmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 04:34:04 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 6 May
 2020 04:34:03 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 6 May
 2020 04:34:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 6 May 2020 04:34:02 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 08C303F7040;
        Wed,  6 May 2020 04:33:59 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net-next 05/12] net: qed: cleanup debug related declarations
Date:   Wed, 6 May 2020 14:33:07 +0300
Message-ID: <38f25d8972bf3faafd01b8ed6c6709b1a34f61b4.1588758463.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588758463.git.irusskikh@marvell.com>
References: <cover.1588758463.git.irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_05:2020-05-05,2020-05-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thats probably a legacy code had double declaration of some fields.
Cleanup this, removing copy and fixing references.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h       | 11 +++------
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 26 ++++++++++-----------
 2 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 12c40ce3d876..07f6ef930b52 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -740,12 +740,6 @@ struct qed_dbg_feature {
 	u32 dumped_dwords;
 };
 
-struct qed_dbg_params {
-	struct qed_dbg_feature features[DBG_FEATURE_NUM];
-	u8 engine_for_debug;
-	bool print_data;
-};
-
 struct qed_dev {
 	u32	dp_module;
 	u8	dp_level;
@@ -872,17 +866,18 @@ struct qed_dev {
 	} protocol_ops;
 	void				*ops_cookie;
 
-	struct qed_dbg_params		dbg_params;
-
 #ifdef CONFIG_QED_LL2
 	struct qed_cb_ll2_info		*ll2;
 	u8				ll2_mac_address[ETH_ALEN];
 #endif
 	struct qed_dbg_feature dbg_features[DBG_FEATURE_NUM];
+	u8 engine_for_debug;
 	bool disable_ilt_dump;
 	DECLARE_HASHTABLE(connections, 10);
 	const struct firmware		*firmware;
 
+	bool print_dbg_data;
+
 	u32 rdma_max_sge;
 	u32 rdma_max_inline;
 	u32 rdma_max_srq_sge;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index f4eebaabb6d0..57a0dab88431 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -7453,7 +7453,7 @@ static enum dbg_status format_feature(struct qed_hwfn *p_hwfn,
 				      enum qed_dbg_features feature_idx)
 {
 	struct qed_dbg_feature *feature =
-	    &p_hwfn->cdev->dbg_params.features[feature_idx];
+	    &p_hwfn->cdev->dbg_features[feature_idx];
 	u32 text_size_bytes, null_char_pos, i;
 	enum dbg_status rc;
 	char *text_buf;
@@ -7502,7 +7502,7 @@ static enum dbg_status format_feature(struct qed_hwfn *p_hwfn,
 		text_buf[i] = '\n';
 
 	/* Dump printable feature to log */
-	if (p_hwfn->cdev->dbg_params.print_data)
+	if (p_hwfn->cdev->print_dbg_data)
 		qed_dbg_print_feature(text_buf, text_size_bytes);
 
 	/* Free the old dump_buf and point the dump_buf to the newly allocagted
@@ -7523,7 +7523,7 @@ static enum dbg_status qed_dbg_dump(struct qed_hwfn *p_hwfn,
 				    enum qed_dbg_features feature_idx)
 {
 	struct qed_dbg_feature *feature =
-	    &p_hwfn->cdev->dbg_params.features[feature_idx];
+	    &p_hwfn->cdev->dbg_features[feature_idx];
 	u32 buf_size_dwords;
 	enum dbg_status rc;
 
@@ -7648,7 +7648,7 @@ static int qed_dbg_nvm_image(struct qed_dev *cdev, void *buffer,
 			     enum qed_nvm_images image_id)
 {
 	struct qed_hwfn *p_hwfn =
-		&cdev->hwfns[cdev->dbg_params.engine_for_debug];
+		&cdev->hwfns[cdev->engine_for_debug];
 	u32 len_rounded, i;
 	__be32 val;
 	int rc;
@@ -7780,7 +7780,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 {
 	u8 cur_engine, omit_engine = 0, org_engine;
 	struct qed_hwfn *p_hwfn =
-		&cdev->hwfns[cdev->dbg_params.engine_for_debug];
+		&cdev->hwfns[cdev->engine_for_debug];
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
 	int grc_params[MAX_DBG_GRC_PARAMS], i;
 	u32 offset = 0, feature_size;
@@ -8000,7 +8000,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 int qed_dbg_all_data_size(struct qed_dev *cdev)
 {
 	struct qed_hwfn *p_hwfn =
-		&cdev->hwfns[cdev->dbg_params.engine_for_debug];
+		&cdev->hwfns[cdev->engine_for_debug];
 	u32 regs_len = 0, image_len = 0, ilt_len = 0, total_ilt_len = 0;
 	u8 cur_engine, org_engine;
 
@@ -8059,9 +8059,9 @@ int qed_dbg_feature(struct qed_dev *cdev, void *buffer,
 		    enum qed_dbg_features feature, u32 *num_dumped_bytes)
 {
 	struct qed_hwfn *p_hwfn =
-		&cdev->hwfns[cdev->dbg_params.engine_for_debug];
+		&cdev->hwfns[cdev->engine_for_debug];
 	struct qed_dbg_feature *qed_feature =
-		&cdev->dbg_params.features[feature];
+		&cdev->dbg_features[feature];
 	enum dbg_status dbg_rc;
 	struct qed_ptt *p_ptt;
 	int rc = 0;
@@ -8084,7 +8084,7 @@ int qed_dbg_feature(struct qed_dev *cdev, void *buffer,
 	DP_VERBOSE(cdev, QED_MSG_DEBUG,
 		   "copying debugfs feature to external buffer\n");
 	memcpy(buffer, qed_feature->dump_buf, qed_feature->buf_size);
-	*num_dumped_bytes = cdev->dbg_params.features[feature].dumped_dwords *
+	*num_dumped_bytes = cdev->dbg_features[feature].dumped_dwords *
 			    4;
 
 out:
@@ -8095,7 +8095,7 @@ int qed_dbg_feature(struct qed_dev *cdev, void *buffer,
 int qed_dbg_feature_size(struct qed_dev *cdev, enum qed_dbg_features feature)
 {
 	struct qed_hwfn *p_hwfn =
-		&cdev->hwfns[cdev->dbg_params.engine_for_debug];
+		&cdev->hwfns[cdev->engine_for_debug];
 	struct qed_dbg_feature *qed_feature = &cdev->dbg_features[feature];
 	struct qed_ptt *p_ptt = qed_ptt_acquire(p_hwfn);
 	u32 buf_size_dwords;
@@ -8120,14 +8120,14 @@ int qed_dbg_feature_size(struct qed_dev *cdev, enum qed_dbg_features feature)
 
 u8 qed_get_debug_engine(struct qed_dev *cdev)
 {
-	return cdev->dbg_params.engine_for_debug;
+	return cdev->engine_for_debug;
 }
 
 void qed_set_debug_engine(struct qed_dev *cdev, int engine_number)
 {
 	DP_VERBOSE(cdev, QED_MSG_DEBUG, "set debug engine to %d\n",
 		   engine_number);
-	cdev->dbg_params.engine_for_debug = engine_number;
+	cdev->engine_for_debug = engine_number;
 }
 
 void qed_dbg_pf_init(struct qed_dev *cdev)
@@ -8146,7 +8146,7 @@ void qed_dbg_pf_init(struct qed_dev *cdev)
 	}
 
 	/* Set the hwfn to be 0 as default */
-	cdev->dbg_params.engine_for_debug = 0;
+	cdev->engine_for_debug = 0;
 }
 
 void qed_dbg_pf_exit(struct qed_dev *cdev)
-- 
2.25.1

