Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C79215AE3
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgGFPjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:39:16 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38788 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729499AbgGFPjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:39:15 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066FaFmd005977;
        Mon, 6 Jul 2020 08:39:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=4eGp2l6PoWzeQRq5FWf3aRqtRaMQIOZeMGFXaF9Wezk=;
 b=M8rUYgd5UiPjKzmNapk+Z3pusCP4+Vx6kB4EVY3O5TDIoeZabngTa4JZTLE7Gh+jLmyN
 5MZcmqmKr3PVR6+AH50ieyoM2zud2NnwSlKV1TQfCncXNjy+C5ZDJTGGrYF57Wzf3DTi
 2q705KQh4qzzdv9UFZqbhEqaOPEOlXETgd0WiUgHP05sGT4qPQSSHT3+p4SOR29BvLa4
 avzgiE9CZvOIJWP/47/hYjUzN0HtxBVVfxdiJVkf2Kd6j44E6eohS8V+UFe/tcY99OHt
 0YvENZVZnrGH/e9mlqJSLvOYpCenUOzAq9eGUKRwCgSOg4bgDihr2o6CQDILNx0Ajzd/ Iw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 322s9n6wac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 08:39:11 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jul
 2020 08:39:09 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jul 2020 08:39:09 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id EE3D63F703F;
        Mon,  6 Jul 2020 08:39:05 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 5/9] net: qed: improve indentation of some parts of code
Date:   Mon, 6 Jul 2020 18:38:17 +0300
Message-ID: <20200706153821.786-6-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706153821.786-1-alobakin@marvell.com>
References: <20200706153821.786-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_12:2020-07-06,2020-07-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To not mix functional and stylistic changes, correct indentation
of code that will be modified in the subsequent commits.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c     |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c   |   5 +-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     | 194 +++++++++---------
 .../ethernet/qlogic/qed/qed_init_fw_funcs.c   |  40 ++--
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c   |   7 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c   |  10 +-
 drivers/net/ethernet/qlogic/qed/qed_roce.c    |   7 +-
 drivers/net/ethernet/qlogic/qed/qed_sp.h      |   9 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c   |   4 +-
 9 files changed, 136 insertions(+), 144 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index e72d25854d79..e3fe982532d5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -73,8 +73,8 @@ union type1_task_context {
 };
 
 struct src_ent {
-	u8 opaque[56];
-	u64 next;
+	u8				opaque[56];
+	u64				next;
 };
 
 #define CDUT_SEG_ALIGNMET		3 /* in 4k chunks */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 45cbe1c87106..f856bb9a3897 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -1122,9 +1122,8 @@ static u32 qed_dump_fw_ver_param(struct qed_hwfn *p_hwfn,
 				     dump, "fw-version", fw_ver_str);
 	offset += qed_dump_str_param(dump_buf + offset,
 				     dump, "fw-image", fw_img_str);
-	offset += qed_dump_num_param(dump_buf + offset,
-				     dump,
-				     "fw-timestamp", fw_info.ver.timestamp);
+	offset += qed_dump_num_param(dump_buf + offset, dump, "fw-timestamp",
+				     fw_info.ver.timestamp);
 
 	return offset;
 }
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 1b5506c1364b..71809ff97a03 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -2793,34 +2793,34 @@ struct fw_overlay_buf_hdr {
 
 /* init array header: raw */
 struct init_array_raw_hdr {
-	u32 data;
-#define INIT_ARRAY_RAW_HDR_TYPE_MASK	0xF
-#define INIT_ARRAY_RAW_HDR_TYPE_SHIFT	0
-#define INIT_ARRAY_RAW_HDR_PARAMS_MASK	0xFFFFFFF
-#define INIT_ARRAY_RAW_HDR_PARAMS_SHIFT	4
+	u32						data;
+#define INIT_ARRAY_RAW_HDR_TYPE_MASK			0xF
+#define INIT_ARRAY_RAW_HDR_TYPE_SHIFT			0
+#define INIT_ARRAY_RAW_HDR_PARAMS_MASK			0xFFFFFFF
+#define INIT_ARRAY_RAW_HDR_PARAMS_SHIFT			4
 };
 
 /* init array header: standard */
 struct init_array_standard_hdr {
-	u32 data;
-#define INIT_ARRAY_STANDARD_HDR_TYPE_MASK	0xF
-#define INIT_ARRAY_STANDARD_HDR_TYPE_SHIFT	0
-#define INIT_ARRAY_STANDARD_HDR_SIZE_MASK	0xFFFFFFF
-#define INIT_ARRAY_STANDARD_HDR_SIZE_SHIFT	4
+	u32						data;
+#define INIT_ARRAY_STANDARD_HDR_TYPE_MASK		0xF
+#define INIT_ARRAY_STANDARD_HDR_TYPE_SHIFT		0
+#define INIT_ARRAY_STANDARD_HDR_SIZE_MASK		0xFFFFFFF
+#define INIT_ARRAY_STANDARD_HDR_SIZE_SHIFT		4
 };
 
 /* init array header: zipped */
 struct init_array_zipped_hdr {
-	u32 data;
-#define INIT_ARRAY_ZIPPED_HDR_TYPE_MASK		0xF
-#define INIT_ARRAY_ZIPPED_HDR_TYPE_SHIFT	0
-#define INIT_ARRAY_ZIPPED_HDR_ZIPPED_SIZE_MASK	0xFFFFFFF
-#define INIT_ARRAY_ZIPPED_HDR_ZIPPED_SIZE_SHIFT	4
+	u32						data;
+#define INIT_ARRAY_ZIPPED_HDR_TYPE_MASK			0xF
+#define INIT_ARRAY_ZIPPED_HDR_TYPE_SHIFT		0
+#define INIT_ARRAY_ZIPPED_HDR_ZIPPED_SIZE_MASK		0xFFFFFFF
+#define INIT_ARRAY_ZIPPED_HDR_ZIPPED_SIZE_SHIFT		4
 };
 
 /* init array header: pattern */
 struct init_array_pattern_hdr {
-	u32 data;
+	u32						data;
 #define INIT_ARRAY_PATTERN_HDR_TYPE_MASK		0xF
 #define INIT_ARRAY_PATTERN_HDR_TYPE_SHIFT		0
 #define INIT_ARRAY_PATTERN_HDR_PATTERN_SIZE_MASK	0xF
@@ -2831,10 +2831,10 @@ struct init_array_pattern_hdr {
 
 /* init array header union */
 union init_array_hdr {
-	struct init_array_raw_hdr raw;
-	struct init_array_standard_hdr standard;
-	struct init_array_zipped_hdr zipped;
-	struct init_array_pattern_hdr pattern;
+	struct init_array_raw_hdr			raw;
+	struct init_array_standard_hdr			standard;
+	struct init_array_zipped_hdr			zipped;
+	struct init_array_pattern_hdr			pattern;
 };
 
 /* init array types */
@@ -2847,54 +2847,54 @@ enum init_array_types {
 
 /* init operation: callback */
 struct init_callback_op {
-	u32 op_data;
-#define INIT_CALLBACK_OP_OP_MASK	0xF
-#define INIT_CALLBACK_OP_OP_SHIFT	0
-#define INIT_CALLBACK_OP_RESERVED_MASK	0xFFFFFFF
-#define INIT_CALLBACK_OP_RESERVED_SHIFT	4
-	u16 callback_id;
-	u16 block_id;
+	u32						op_data;
+#define INIT_CALLBACK_OP_OP_MASK			0xF
+#define INIT_CALLBACK_OP_OP_SHIFT			0
+#define INIT_CALLBACK_OP_RESERVED_MASK			0xFFFFFFF
+#define INIT_CALLBACK_OP_RESERVED_SHIFT			4
+	u16						callback_id;
+	u16						block_id;
 };
 
 /* init operation: delay */
 struct init_delay_op {
-	u32 op_data;
-#define INIT_DELAY_OP_OP_MASK		0xF
-#define INIT_DELAY_OP_OP_SHIFT		0
-#define INIT_DELAY_OP_RESERVED_MASK	0xFFFFFFF
-#define INIT_DELAY_OP_RESERVED_SHIFT	4
-	u32 delay;
+	u32						op_data;
+#define INIT_DELAY_OP_OP_MASK				0xF
+#define INIT_DELAY_OP_OP_SHIFT				0
+#define INIT_DELAY_OP_RESERVED_MASK			0xFFFFFFF
+#define INIT_DELAY_OP_RESERVED_SHIFT			4
+	u32						delay;
 };
 
 /* init operation: if_mode */
 struct init_if_mode_op {
-	u32 op_data;
-#define INIT_IF_MODE_OP_OP_MASK			0xF
-#define INIT_IF_MODE_OP_OP_SHIFT		0
-#define INIT_IF_MODE_OP_RESERVED1_MASK		0xFFF
-#define INIT_IF_MODE_OP_RESERVED1_SHIFT		4
-#define INIT_IF_MODE_OP_CMD_OFFSET_MASK		0xFFFF
-#define INIT_IF_MODE_OP_CMD_OFFSET_SHIFT	16
-	u16 reserved2;
-	u16 modes_buf_offset;
+	u32						op_data;
+#define INIT_IF_MODE_OP_OP_MASK				0xF
+#define INIT_IF_MODE_OP_OP_SHIFT			0
+#define INIT_IF_MODE_OP_RESERVED1_MASK			0xFFF
+#define INIT_IF_MODE_OP_RESERVED1_SHIFT			4
+#define INIT_IF_MODE_OP_CMD_OFFSET_MASK			0xFFFF
+#define INIT_IF_MODE_OP_CMD_OFFSET_SHIFT		16
+	u16						reserved2;
+	u16						modes_buf_offset;
 };
 
 /* init operation: if_phase */
 struct init_if_phase_op {
-	u32 op_data;
-#define INIT_IF_PHASE_OP_OP_MASK		0xF
-#define INIT_IF_PHASE_OP_OP_SHIFT		0
-#define INIT_IF_PHASE_OP_RESERVED1_MASK		0xFFF
-#define INIT_IF_PHASE_OP_RESERVED1_SHIFT	4
-#define INIT_IF_PHASE_OP_CMD_OFFSET_MASK	0xFFFF
-#define INIT_IF_PHASE_OP_CMD_OFFSET_SHIFT	16
-	u32 phase_data;
-#define INIT_IF_PHASE_OP_PHASE_MASK		0xFF
-#define INIT_IF_PHASE_OP_PHASE_SHIFT		0
-#define INIT_IF_PHASE_OP_RESERVED2_MASK		0xFF
-#define INIT_IF_PHASE_OP_RESERVED2_SHIFT	8
-#define INIT_IF_PHASE_OP_PHASE_ID_MASK		0xFFFF
-#define INIT_IF_PHASE_OP_PHASE_ID_SHIFT		16
+	u32						op_data;
+#define INIT_IF_PHASE_OP_OP_MASK			0xF
+#define INIT_IF_PHASE_OP_OP_SHIFT			0
+#define INIT_IF_PHASE_OP_RESERVED1_MASK			0xFFF
+#define INIT_IF_PHASE_OP_RESERVED1_SHIFT		4
+#define INIT_IF_PHASE_OP_CMD_OFFSET_MASK		0xFFFF
+#define INIT_IF_PHASE_OP_CMD_OFFSET_SHIFT		16
+	u32						phase_data;
+#define INIT_IF_PHASE_OP_PHASE_MASK			0xFF
+#define INIT_IF_PHASE_OP_PHASE_SHIFT			0
+#define INIT_IF_PHASE_OP_RESERVED2_MASK			0xFF
+#define INIT_IF_PHASE_OP_RESERVED2_SHIFT		8
+#define INIT_IF_PHASE_OP_PHASE_ID_MASK			0xFFFF
+#define INIT_IF_PHASE_OP_PHASE_ID_SHIFT			16
 };
 
 /* init mode operators */
@@ -2907,67 +2907,67 @@ enum init_mode_ops {
 
 /* init operation: raw */
 struct init_raw_op {
-	u32 op_data;
-#define INIT_RAW_OP_OP_MASK		0xF
-#define INIT_RAW_OP_OP_SHIFT		0
-#define INIT_RAW_OP_PARAM1_MASK		0xFFFFFFF
-#define INIT_RAW_OP_PARAM1_SHIFT	4
-	u32 param2;
+	u32						op_data;
+#define INIT_RAW_OP_OP_MASK				0xF
+#define INIT_RAW_OP_OP_SHIFT				0
+#define INIT_RAW_OP_PARAM1_MASK				0xFFFFFFF
+#define INIT_RAW_OP_PARAM1_SHIFT			4
+	u32						param2;
 };
 
 /* init array params */
 struct init_op_array_params {
-	u16 size;
-	u16 offset;
+	u16						size;
+	u16						offset;
 };
 
 /* Write init operation arguments */
 union init_write_args {
-	u32 inline_val;
-	u32 zeros_count;
-	u32 array_offset;
-	struct init_op_array_params runtime;
+	u32						inline_val;
+	u32						zeros_count;
+	u32						array_offset;
+	struct init_op_array_params			runtime;
 };
 
 /* init operation: write */
 struct init_write_op {
-	u32 data;
-#define INIT_WRITE_OP_OP_MASK		0xF
-#define INIT_WRITE_OP_OP_SHIFT		0
-#define INIT_WRITE_OP_SOURCE_MASK	0x7
-#define INIT_WRITE_OP_SOURCE_SHIFT	4
-#define INIT_WRITE_OP_RESERVED_MASK	0x1
-#define INIT_WRITE_OP_RESERVED_SHIFT	7
-#define INIT_WRITE_OP_WIDE_BUS_MASK	0x1
-#define INIT_WRITE_OP_WIDE_BUS_SHIFT	8
-#define INIT_WRITE_OP_ADDRESS_MASK	0x7FFFFF
-#define INIT_WRITE_OP_ADDRESS_SHIFT	9
-	union init_write_args args;
+	u32						data;
+#define INIT_WRITE_OP_OP_MASK				0xF
+#define INIT_WRITE_OP_OP_SHIFT				0
+#define INIT_WRITE_OP_SOURCE_MASK			0x7
+#define INIT_WRITE_OP_SOURCE_SHIFT			4
+#define INIT_WRITE_OP_RESERVED_MASK			0x1
+#define INIT_WRITE_OP_RESERVED_SHIFT			7
+#define INIT_WRITE_OP_WIDE_BUS_MASK			0x1
+#define INIT_WRITE_OP_WIDE_BUS_SHIFT			8
+#define INIT_WRITE_OP_ADDRESS_MASK			0x7FFFFF
+#define INIT_WRITE_OP_ADDRESS_SHIFT			9
+	union init_write_args				args;
 };
 
 /* init operation: read */
 struct init_read_op {
-	u32 op_data;
-#define INIT_READ_OP_OP_MASK		0xF
-#define INIT_READ_OP_OP_SHIFT		0
-#define INIT_READ_OP_POLL_TYPE_MASK	0xF
-#define INIT_READ_OP_POLL_TYPE_SHIFT	4
-#define INIT_READ_OP_RESERVED_MASK	0x1
-#define INIT_READ_OP_RESERVED_SHIFT	8
-#define INIT_READ_OP_ADDRESS_MASK	0x7FFFFF
-#define INIT_READ_OP_ADDRESS_SHIFT	9
-	u32 expected_val;
+	u32						op_data;
+#define INIT_READ_OP_OP_MASK				0xF
+#define INIT_READ_OP_OP_SHIFT				0
+#define INIT_READ_OP_POLL_TYPE_MASK			0xF
+#define INIT_READ_OP_POLL_TYPE_SHIFT			4
+#define INIT_READ_OP_RESERVED_MASK			0x1
+#define INIT_READ_OP_RESERVED_SHIFT			8
+#define INIT_READ_OP_ADDRESS_MASK			0x7FFFFF
+#define INIT_READ_OP_ADDRESS_SHIFT			9
+	u32						expected_val;
 };
 
 /* Init operations union */
 union init_op {
-	struct init_raw_op raw;
-	struct init_write_op write;
-	struct init_read_op read;
-	struct init_if_mode_op if_mode;
-	struct init_if_phase_op if_phase;
-	struct init_callback_op callback;
-	struct init_delay_op delay;
+	struct init_raw_op				raw;
+	struct init_write_op				write;
+	struct init_read_op				read;
+	struct init_if_mode_op				if_mode;
+	struct init_if_phase_op				if_phase;
+	struct init_callback_op				callback;
+	struct init_delay_op				delay;
 };
 
 /* Init command operation types */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
index 2ce1f5180231..775ef5eaefd4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
@@ -156,23 +156,26 @@ static u16 task_region_offsets[1][NUM_OF_CONNECTION_TYPES_E4] = {
 		  cmd ## _ ## field, \
 		  value)
 
-#define QM_INIT_TX_PQ_MAP(p_hwfn, map, chip, pq_id, vp_pq_id, rl_valid, rl_id, \
-			  ext_voq, wrr) \
-	do { \
-		typeof(map) __map; \
-		memset(&__map, 0, sizeof(__map)); \
-		SET_FIELD(__map.reg, QM_RF_PQ_MAP_ ## chip ## _PQ_VALID, 1); \
-		SET_FIELD(__map.reg, QM_RF_PQ_MAP_ ## chip ## _RL_VALID, \
-			  rl_valid ? 1 : 0);\
-		SET_FIELD(__map.reg, QM_RF_PQ_MAP_ ## chip ## _VP_PQ_ID, \
-			  vp_pq_id); \
-		SET_FIELD(__map.reg, QM_RF_PQ_MAP_ ## chip ## _RL_ID, rl_id); \
-		SET_FIELD(__map.reg, QM_RF_PQ_MAP_ ## chip ## _VOQ, ext_voq); \
-		SET_FIELD(__map.reg, \
-			  QM_RF_PQ_MAP_ ## chip ## _WRR_WEIGHT_GROUP, wrr); \
-		STORE_RT_REG(p_hwfn, QM_REG_TXPQMAP_RT_OFFSET + (pq_id), \
-			     *((u32 *)&__map)); \
-		(map) = __map; \
+#define QM_INIT_TX_PQ_MAP(p_hwfn, map, chip, pq_id, vp_pq_id, rl_valid,	      \
+			  rl_id, ext_voq, wrr)				      \
+	do {								      \
+		typeof(map) __map;					      \
+									      \
+		memset(&__map, 0, sizeof(__map));			      \
+									      \
+		SET_FIELD(__map.reg, QM_RF_PQ_MAP_##chip##_PQ_VALID, 1);      \
+		SET_FIELD(__map.reg, QM_RF_PQ_MAP_##chip##_RL_VALID,	      \
+			  !!(rl_valid));				      \
+		SET_FIELD(__map.reg, QM_RF_PQ_MAP_##chip##_VP_PQ_ID,	      \
+			  (vp_pq_id));					      \
+		SET_FIELD(__map.reg, QM_RF_PQ_MAP_##chip##_RL_ID, (rl_id));   \
+		SET_FIELD(__map.reg, QM_RF_PQ_MAP_##chip##_VOQ, (ext_voq));   \
+		SET_FIELD(__map.reg, QM_RF_PQ_MAP_##chip##_WRR_WEIGHT_GROUP,  \
+			  (wrr));					      \
+									      \
+		STORE_RT_REG((p_hwfn), QM_REG_TXPQMAP_RT_OFFSET + (pq_id),    \
+			     *((u32 *)&__map));				      \
+		(map) = __map;						      \
 	} while (0)
 
 #define WRITE_PQ_INFO_TO_RAM	1
@@ -1008,8 +1011,7 @@ bool qed_send_qm_stop_cmd(struct qed_hwfn *p_hwfn,
  * Return: Length of the written data in dwords (u32) or -1 on invalid
  *         input.
  */
-static int qed_dmae_to_grc(struct qed_hwfn *p_hwfn,
-			   struct qed_ptt *p_ptt,
+static int qed_dmae_to_grc(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 			   u32 *p_data, u32 addr, u32 len_in_dwords)
 {
 	struct qed_dmae_params params = {};
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
index f9d9e21cb66b..8abb31b63e4e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
@@ -117,10 +117,9 @@ struct qed_iscsi_conn {
 	u8 abortive_dsconnect;
 };
 
-static int
-qed_iscsi_async_event(struct qed_hwfn *p_hwfn,
-		      u8 fw_event_code,
-		      u16 echo, union event_ring_data *data, u8 fw_return_code)
+static int qed_iscsi_async_event(struct qed_hwfn *p_hwfn, u8 fw_event_code,
+				 u16 echo, union event_ring_data *data,
+				 u8 fw_return_code)
 {
 	if (p_hwfn->p_iscsi_info->event_cb) {
 		struct qed_iscsi_info *p_iscsi = p_hwfn->p_iscsi_info;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index b7a0a717ee6d..6f2cd5a18e5f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -59,9 +59,8 @@ struct mpa_v2_hdr {
 #define QED_IWARP_DEF_KA_TIMEOUT	(1200000)	/* 20 min */
 #define QED_IWARP_DEF_KA_INTERVAL	(1000)		/* 1 sec */
 
-static int qed_iwarp_async_event(struct qed_hwfn *p_hwfn,
-				 u8 fw_event_code, u16 echo,
-				 union event_ring_data *data,
+static int qed_iwarp_async_event(struct qed_hwfn *p_hwfn, u8 fw_event_code,
+				 u16 echo, union event_ring_data *data,
 				 u8 fw_return_code);
 
 /* Override devinfo with iWARP specific values */
@@ -3008,9 +3007,8 @@ qed_iwarp_check_ep_ok(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 	return true;
 }
 
-static int qed_iwarp_async_event(struct qed_hwfn *p_hwfn,
-				 u8 fw_event_code, u16 echo,
-				 union event_ring_data *data,
+static int qed_iwarp_async_event(struct qed_hwfn *p_hwfn, u8 fw_event_code,
+				 u16 echo, union event_ring_data *data,
 				 u8 fw_return_code)
 {
 	struct qed_rdma_events events = p_hwfn->p_rdma_info->events;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index d5db07db65b1..871282187268 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -37,10 +37,9 @@
 
 static void qed_roce_free_real_icid(struct qed_hwfn *p_hwfn, u16 icid);
 
-static int
-qed_roce_async_event(struct qed_hwfn *p_hwfn,
-		     u8 fw_event_code,
-		     u16 echo, union event_ring_data *data, u8 fw_return_code)
+static int qed_roce_async_event(struct qed_hwfn *p_hwfn, u8 fw_event_code,
+				u16 echo, union event_ring_data *data,
+				u8 fw_return_code)
 {
 	struct qed_rdma_events events = p_hwfn->p_rdma_info->events;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp.h b/drivers/net/ethernet/qlogic/qed/qed_sp.h
index 35539e951bee..f7f983a8bf44 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_sp.h
@@ -154,12 +154,9 @@ struct qed_consq {
 	struct qed_chain chain;
 };
 
-typedef int
-(*qed_spq_async_comp_cb)(struct qed_hwfn *p_hwfn,
-			 u8 opcode,
-			 u16 echo,
-			 union event_ring_data *data,
-			 u8 fw_return_code);
+typedef int (*qed_spq_async_comp_cb)(struct qed_hwfn *p_hwfn, u8 opcode,
+				     u16 echo, union event_ring_data *data,
+				     u8 fw_return_code);
 
 int
 qed_spq_register_async_cb(struct qed_hwfn *p_hwfn,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 3930958f0ffa..b4e21e4792b7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -4037,9 +4037,7 @@ static void qed_sriov_vfpf_malicious(struct qed_hwfn *p_hwfn,
 	}
 }
 
-static int qed_sriov_eqe_event(struct qed_hwfn *p_hwfn,
-			       u8 opcode,
-			       __le16 echo,
+static int qed_sriov_eqe_event(struct qed_hwfn *p_hwfn, u8 opcode, u16 echo,
 			       union event_ring_data *data, u8 fw_return_code)
 {
 	switch (opcode) {
-- 
2.25.1

