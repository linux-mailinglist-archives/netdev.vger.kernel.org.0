Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC80E14661B
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbgAWK7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:59:09 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18138 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728921AbgAWK7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:59:07 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00NAvgMu006062;
        Thu, 23 Jan 2020 02:59:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=66MZRXubr2quB7aQp+Ore8oL3B3tjcMP9j1HNfvyzPQ=;
 b=yrHw0s4T5cd5z0+iHV5pbtbQO2mheF3b7Fbv1ju10BBa8PirAjGaQ3zaWYwCOZ3DLMnN
 zoNE3yaH7U29tOUBdH9owzqp4LcwDiCz0ZC5wvwgagMhLQ0jJ/T4lxTl50ipMaH4eiWy
 gP5bgzLfX4bSRLPjvlQ4/YS3Le5gMs+tZO7DSaPbjLCCCOLg1aFhT+vb+hJw/fbVYsUX
 ZrWHrJ8ewaPmZR3X4NpAzHMkTimYZh+fNiAEFhM5fjUbfFTEQpfymlAeYPDOM/2CaGx/
 2FsY2KI8sjXY/T/AwIAgzxMw5D8UdnsWZGUDcGVaqD9LfaLsVoU7Lt86oyhAHfujvue8 Sw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xm2dtbd43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 Jan 2020 02:59:04 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Jan
 2020 02:59:02 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 23 Jan 2020 02:59:02 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 3E8F83F7040;
        Thu, 23 Jan 2020 02:59:00 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        Manish Rangankar <manish.rangankar@marvell.com>,
        Saurav Kashyap <saurav.kashyap@marvell.com>
Subject: [PATCH v2 net-next 08/13] qed: FW 8.42.2.0 iscsi/fcoe changes
Date:   Thu, 23 Jan 2020 12:58:31 +0200
Message-ID: <20200123105836.15090-9-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200123105836.15090-1-michal.kalderon@marvell.com>
References: <20200123105836.15090-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-23_08:2020-01-23,2020-01-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Remove struct iscsi_slow_path_hdr and field fw_cid from several structs
- Remove struct iscsi_spe_func_dstry
- Remove fields pbe_page_size_log and pbl_page_size_log from struct
  iscsi_conn_offload_param

Signed-off-by: Manish Rangankar <manish.rangankar@marvell.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@marvell.com>
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_fcoe.c  |  2 +
 drivers/net/ethernet/qlogic/qed/qed_hsi.h   |  8 ++--
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c | 31 --------------
 drivers/net/ethernet/qlogic/qed/qed_sp.h    |  2 -
 include/linux/qed/iscsi_common.h            | 64 +++++++++++------------------
 include/linux/qed/storage_common.h          |  3 +-
 6 files changed, 32 insertions(+), 78 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_fcoe.c b/drivers/net/ethernet/qlogic/qed/qed_fcoe.c
index de31a382f58e..4c7fa391fd33 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_fcoe.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_fcoe.c
@@ -167,6 +167,8 @@ qed_sp_fcoe_func_start(struct qed_hwfn *p_hwfn,
 		goto err;
 	}
 	p_cxt = cxt_info.p_cxt;
+	memset(p_cxt, 0, sizeof(*p_cxt));
+
 	SET_FIELD(p_cxt->tstorm_ag_context.flags3,
 		  E4_TSTORM_FCOE_CONN_AG_CTX_DUMMY_TIMER_CF_EN, 1);
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 8cec6dc179d6..904ed3e372d2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -11497,8 +11497,8 @@ struct e4_tstorm_iscsi_conn_ag_ctx {
 	u8 flags3;
 #define E4_TSTORM_ISCSI_CONN_AG_CTX_FLUSH_Q0_MASK		0x3
 #define E4_TSTORM_ISCSI_CONN_AG_CTX_FLUSH_Q0_SHIFT		0
-#define E4_TSTORM_ISCSI_CONN_AG_CTX_CF10_MASK			0x3
-#define E4_TSTORM_ISCSI_CONN_AG_CTX_CF10_SHIFT			2
+#define E4_TSTORM_ISCSI_CONN_AG_CTX_FLUSH_OOO_ISLES_CF_MASK	0x3
+#define E4_TSTORM_ISCSI_CONN_AG_CTX_FLUSH_OOO_ISLES_CF_SHIFT	2
 #define E4_TSTORM_ISCSI_CONN_AG_CTX_CF0EN_MASK			0x1
 #define E4_TSTORM_ISCSI_CONN_AG_CTX_CF0EN_SHIFT			4
 #define E4_TSTORM_ISCSI_CONN_AG_CTX_P2T_FLUSH_CF_EN_MASK	0x1
@@ -11520,8 +11520,8 @@ struct e4_tstorm_iscsi_conn_ag_ctx {
 #define E4_TSTORM_ISCSI_CONN_AG_CTX_CF8EN_SHIFT		4
 #define E4_TSTORM_ISCSI_CONN_AG_CTX_FLUSH_Q0_EN_MASK	0x1
 #define E4_TSTORM_ISCSI_CONN_AG_CTX_FLUSH_Q0_EN_SHIFT	5
-#define E4_TSTORM_ISCSI_CONN_AG_CTX_CF10EN_MASK		0x1
-#define E4_TSTORM_ISCSI_CONN_AG_CTX_CF10EN_SHIFT	6
+#define E4_TSTORM_ISCSI_CONN_AG_CTX_FLUSH_OOO_ISLES_CF_EN_MASK	0x1
+#define E4_TSTORM_ISCSI_CONN_AG_CTX_FLUSH_OOO_ISLES_CF_EN_SHIFT	6
 #define E4_TSTORM_ISCSI_CONN_AG_CTX_RULE0EN_MASK	0x1
 #define E4_TSTORM_ISCSI_CONN_AG_CTX_RULE0EN_SHIFT	7
 	u8 flags5;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
index 8ee668d66b4b..7245a615517a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
@@ -204,10 +204,6 @@ qed_sp_iscsi_func_start(struct qed_hwfn *p_hwfn,
 		return -EINVAL;
 	}
 
-	SET_FIELD(p_init->hdr.flags,
-		  ISCSI_SLOW_PATH_HDR_LAYER_CODE, ISCSI_SLOW_PATH_LAYER_CODE);
-	p_init->hdr.op_code = ISCSI_RAMROD_CMD_ID_INIT_FUNC;
-
 	val = p_params->half_way_close_timeout;
 	p_init->half_way_close_timeout = cpu_to_le16(val);
 	p_init->num_sq_pages_in_ring = p_params->num_sq_pages_in_ring;
@@ -332,12 +328,7 @@ static int qed_sp_iscsi_conn_offload(struct qed_hwfn *p_hwfn,
 	p_conn->physical_q1 = cpu_to_le16(physical_q);
 	p_ramrod->iscsi.physical_q1 = cpu_to_le16(physical_q);
 
-	p_ramrod->hdr.op_code = ISCSI_RAMROD_CMD_ID_OFFLOAD_CONN;
-	SET_FIELD(p_ramrod->hdr.flags, ISCSI_SLOW_PATH_HDR_LAYER_CODE,
-		  p_conn->layer_code);
-
 	p_ramrod->conn_id = cpu_to_le16(p_conn->conn_id);
-	p_ramrod->fw_cid = cpu_to_le32(p_conn->icid);
 
 	DMA_REGPAIR_LE(p_ramrod->iscsi.sq_pbl_addr, p_conn->sq_pbl_addr);
 
@@ -493,12 +484,8 @@ static int qed_sp_iscsi_conn_update(struct qed_hwfn *p_hwfn,
 		return rc;
 
 	p_ramrod = &p_ent->ramrod.iscsi_conn_update;
-	p_ramrod->hdr.op_code = ISCSI_RAMROD_CMD_ID_UPDATE_CONN;
-	SET_FIELD(p_ramrod->hdr.flags,
-		  ISCSI_SLOW_PATH_HDR_LAYER_CODE, p_conn->layer_code);
 
 	p_ramrod->conn_id = cpu_to_le16(p_conn->conn_id);
-	p_ramrod->fw_cid = cpu_to_le32(p_conn->icid);
 	p_ramrod->flags = p_conn->update_flag;
 	p_ramrod->max_seq_size = cpu_to_le32(p_conn->max_seq_size);
 	dval = p_conn->max_recv_pdu_length;
@@ -538,12 +525,8 @@ qed_sp_iscsi_mac_update(struct qed_hwfn *p_hwfn,
 		return rc;
 
 	p_ramrod = &p_ent->ramrod.iscsi_conn_mac_update;
-	p_ramrod->hdr.op_code = ISCSI_RAMROD_CMD_ID_MAC_UPDATE;
-	SET_FIELD(p_ramrod->hdr.flags,
-		  ISCSI_SLOW_PATH_HDR_LAYER_CODE, p_conn->layer_code);
 
 	p_ramrod->conn_id = cpu_to_le16(p_conn->conn_id);
-	p_ramrod->fw_cid = cpu_to_le32(p_conn->icid);
 	ucval = p_conn->remote_mac[1];
 	((u8 *)(&p_ramrod->remote_mac_addr_hi))[0] = ucval;
 	ucval = p_conn->remote_mac[0];
@@ -584,12 +567,8 @@ static int qed_sp_iscsi_conn_terminate(struct qed_hwfn *p_hwfn,
 		return rc;
 
 	p_ramrod = &p_ent->ramrod.iscsi_conn_terminate;
-	p_ramrod->hdr.op_code = ISCSI_RAMROD_CMD_ID_TERMINATION_CONN;
-	SET_FIELD(p_ramrod->hdr.flags,
-		  ISCSI_SLOW_PATH_HDR_LAYER_CODE, p_conn->layer_code);
 
 	p_ramrod->conn_id = cpu_to_le16(p_conn->conn_id);
-	p_ramrod->fw_cid = cpu_to_le32(p_conn->icid);
 	p_ramrod->abortive = p_conn->abortive_dsconnect;
 
 	DMA_REGPAIR_LE(p_ramrod->query_params_addr,
@@ -604,7 +583,6 @@ static int qed_sp_iscsi_conn_clear_sq(struct qed_hwfn *p_hwfn,
 				      enum spq_mode comp_mode,
 				      struct qed_spq_comp_cb *p_comp_addr)
 {
-	struct iscsi_slow_path_hdr *p_ramrod = NULL;
 	struct qed_spq_entry *p_ent = NULL;
 	struct qed_sp_init_data init_data;
 	int rc = -EINVAL;
@@ -622,11 +600,6 @@ static int qed_sp_iscsi_conn_clear_sq(struct qed_hwfn *p_hwfn,
 	if (rc)
 		return rc;
 
-	p_ramrod = &p_ent->ramrod.iscsi_empty;
-	p_ramrod->op_code = ISCSI_RAMROD_CMD_ID_CLEAR_SQ;
-	SET_FIELD(p_ramrod->flags,
-		  ISCSI_SLOW_PATH_HDR_LAYER_CODE, p_conn->layer_code);
-
 	return qed_spq_post(p_hwfn, p_ent, NULL);
 }
 
@@ -634,7 +607,6 @@ static int qed_sp_iscsi_func_stop(struct qed_hwfn *p_hwfn,
 				  enum spq_mode comp_mode,
 				  struct qed_spq_comp_cb *p_comp_addr)
 {
-	struct iscsi_spe_func_dstry *p_ramrod = NULL;
 	struct qed_spq_entry *p_ent = NULL;
 	struct qed_sp_init_data init_data;
 	int rc = 0;
@@ -652,9 +624,6 @@ static int qed_sp_iscsi_func_stop(struct qed_hwfn *p_hwfn,
 	if (rc)
 		return rc;
 
-	p_ramrod = &p_ent->ramrod.iscsi_destroy;
-	p_ramrod->hdr.op_code = ISCSI_RAMROD_CMD_ID_DESTROY_FUNC;
-
 	rc = qed_spq_post(p_hwfn, p_ent, NULL);
 
 	qed_spq_unregister_async_cb(p_hwfn, PROTOCOLID_ISCSI);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp.h b/drivers/net/ethernet/qlogic/qed/qed_sp.h
index 96ab77ae6af5..b7b4fbbbccfe 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_sp.h
@@ -120,9 +120,7 @@ union ramrod_data {
 	struct fcoe_conn_terminate_ramrod_params fcoe_conn_terminate;
 	struct fcoe_stat_ramrod_params fcoe_stat;
 
-	struct iscsi_slow_path_hdr iscsi_empty;
 	struct iscsi_init_ramrod_params iscsi_init;
-	struct iscsi_spe_func_dstry iscsi_destroy;
 	struct iscsi_spe_conn_offload iscsi_conn_offload;
 	struct iscsi_conn_update_ramrod_params iscsi_conn_update;
 	struct iscsi_spe_conn_mac_update iscsi_conn_mac_update;
diff --git a/include/linux/qed/iscsi_common.h b/include/linux/qed/iscsi_common.h
index 66aba505ec56..2f0a771a9176 100644
--- a/include/linux/qed/iscsi_common.h
+++ b/include/linux/qed/iscsi_common.h
@@ -999,7 +999,6 @@ struct iscsi_conn_offload_params {
 	struct regpair r2tq_pbl_addr;
 	struct regpair xhq_pbl_addr;
 	struct regpair uhq_pbl_addr;
-	__le32 initial_ack;
 	__le16 physical_q0;
 	__le16 physical_q1;
 	u8 flags;
@@ -1011,10 +1010,10 @@ struct iscsi_conn_offload_params {
 #define ISCSI_CONN_OFFLOAD_PARAMS_RESTRICTED_MODE_SHIFT	2
 #define ISCSI_CONN_OFFLOAD_PARAMS_RESERVED1_MASK	0x1F
 #define ISCSI_CONN_OFFLOAD_PARAMS_RESERVED1_SHIFT	3
-	u8 pbl_page_size_log;
-	u8 pbe_page_size_log;
 	u8 default_cq;
+	__le16 reserved0;
 	__le32 stat_sn;
+	__le32 initial_ack;
 };
 
 /* iSCSI connection statistics */
@@ -1029,25 +1028,14 @@ struct iscsi_conn_stats_params {
 	__le32 reserved;
 };
 
-/* spe message header */
-struct iscsi_slow_path_hdr {
-	u8 op_code;
-	u8 flags;
-#define ISCSI_SLOW_PATH_HDR_RESERVED0_MASK	0xF
-#define ISCSI_SLOW_PATH_HDR_RESERVED0_SHIFT	0
-#define ISCSI_SLOW_PATH_HDR_LAYER_CODE_MASK	0x7
-#define ISCSI_SLOW_PATH_HDR_LAYER_CODE_SHIFT	4
-#define ISCSI_SLOW_PATH_HDR_RESERVED1_MASK	0x1
-#define ISCSI_SLOW_PATH_HDR_RESERVED1_SHIFT	7
-};
 
 /* iSCSI connection update params passed by driver to FW in ISCSI update
  *ramrod.
  */
 struct iscsi_conn_update_ramrod_params {
-	struct iscsi_slow_path_hdr hdr;
+	__le16 reserved0;
 	__le16 conn_id;
-	__le32 fw_cid;
+	__le32 reserved1;
 	u8 flags;
 #define ISCSI_CONN_UPDATE_RAMROD_PARAMS_HD_EN_MASK		0x1
 #define ISCSI_CONN_UPDATE_RAMROD_PARAMS_HD_EN_SHIFT		0
@@ -1065,7 +1053,7 @@ struct iscsi_conn_update_ramrod_params {
 #define ISCSI_CONN_UPDATE_RAMROD_PARAMS_DIF_ON_IMM_EN_SHIFT	6
 #define ISCSI_CONN_UPDATE_RAMROD_PARAMS_LUN_MAPPER_EN_MASK	0x1
 #define ISCSI_CONN_UPDATE_RAMROD_PARAMS_LUN_MAPPER_EN_SHIFT	7
-	u8 reserved0[3];
+	u8 reserved3[3];
 	__le32 max_seq_size;
 	__le32 max_send_pdu_length;
 	__le32 max_recv_pdu_length;
@@ -1251,22 +1239,22 @@ enum iscsi_ramrod_cmd_id {
 
 /* iSCSI connection termination request */
 struct iscsi_spe_conn_mac_update {
-	struct iscsi_slow_path_hdr hdr;
+	__le16 reserved0;
 	__le16 conn_id;
-	__le32 fw_cid;
+	__le32 reserved1;
 	__le16 remote_mac_addr_lo;
 	__le16 remote_mac_addr_mid;
 	__le16 remote_mac_addr_hi;
-	u8 reserved0[2];
+	u8 reserved2[2];
 };
 
 /* iSCSI and TCP connection (Option 1) offload params passed by driver to FW in
  * iSCSI offload ramrod.
  */
 struct iscsi_spe_conn_offload {
-	struct iscsi_slow_path_hdr hdr;
+	__le16 reserved0;
 	__le16 conn_id;
-	__le32 fw_cid;
+	__le32 reserved1;
 	struct iscsi_conn_offload_params iscsi;
 	struct tcp_offload_params tcp;
 };
@@ -1275,44 +1263,36 @@ struct iscsi_spe_conn_offload {
  * iSCSI offload ramrod.
  */
 struct iscsi_spe_conn_offload_option2 {
-	struct iscsi_slow_path_hdr hdr;
+	__le16 reserved0;
 	__le16 conn_id;
-	__le32 fw_cid;
+	__le32 reserved1;
 	struct iscsi_conn_offload_params iscsi;
 	struct tcp_offload_params_opt2 tcp;
 };
 
 /* iSCSI collect connection statistics request */
 struct iscsi_spe_conn_statistics {
-	struct iscsi_slow_path_hdr hdr;
+	__le16 reserved0;
 	__le16 conn_id;
-	__le32 fw_cid;
+	__le32 reserved1;
 	u8 reset_stats;
-	u8 reserved0[7];
+	u8 reserved2[7];
 	struct regpair stats_cnts_addr;
 };
 
 /* iSCSI connection termination request */
 struct iscsi_spe_conn_termination {
-	struct iscsi_slow_path_hdr hdr;
+	__le16 reserved0;
 	__le16 conn_id;
-	__le32 fw_cid;
+	__le32 reserved1;
 	u8 abortive;
-	u8 reserved0[7];
+	u8 reserved2[7];
 	struct regpair queue_cnts_addr;
 	struct regpair query_params_addr;
 };
 
-/* iSCSI firmware function destroy parameters */
-struct iscsi_spe_func_dstry {
-	struct iscsi_slow_path_hdr hdr;
-	__le16 reserved0;
-	__le32 reserved1;
-};
-
 /* iSCSI firmware function init parameters */
 struct iscsi_spe_func_init {
-	struct iscsi_slow_path_hdr hdr;
 	__le16 half_way_close_timeout;
 	u8 num_sq_pages_in_ring;
 	u8 num_r2tq_pages_in_ring;
@@ -1324,8 +1304,12 @@ struct iscsi_spe_func_init {
 #define ISCSI_SPE_FUNC_INIT_RESERVED0_MASK	0x7F
 #define ISCSI_SPE_FUNC_INIT_RESERVED0_SHIFT	1
 	struct iscsi_debug_modes debug_mode;
-	__le16 reserved1;
-	__le32 reserved2;
+	u8 params;
+#define ISCSI_SPE_FUNC_INIT_MAX_SYN_RT_MASK	0xF
+#define ISCSI_SPE_FUNC_INIT_MAX_SYN_RT_SHIFT	0
+#define ISCSI_SPE_FUNC_INIT_RESERVED1_MASK	0xF
+#define ISCSI_SPE_FUNC_INIT_RESERVED1_SHIFT	4
+	u8 reserved2[7];
 	struct scsi_init_func_params func_params;
 	struct scsi_init_func_queues q_params;
 };
diff --git a/include/linux/qed/storage_common.h b/include/linux/qed/storage_common.h
index 505c0b48a761..9a973ffbbff5 100644
--- a/include/linux/qed/storage_common.h
+++ b/include/linux/qed/storage_common.h
@@ -107,8 +107,9 @@ struct scsi_drv_cmdq {
 struct scsi_init_func_params {
 	__le16 num_tasks;
 	u8 log_page_size;
+	u8 log_page_size_conn;
 	u8 debug_mode;
-	u8 reserved2[12];
+	u8 reserved2[11];
 };
 
 /* SCSI RQ/CQ/CMDQ firmware function init parameters */
-- 
2.14.5

