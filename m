Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2617341C475
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343759AbhI2MQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:16:37 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16774 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343648AbhI2MQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 08:16:26 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T8e7NS008407;
        Wed, 29 Sep 2021 05:12:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=pcztnHBHd4dtss+RvywkGvSqamyIDqrg3CewYbVH+g8=;
 b=T/IIw1Hg8a+VF/4QF3XpdcXxUf3cW0q8ob9xIC8b0DtpqGvIfshoKdcn8fH9WXSuyIT4
 0wEEFwHLEwQYMprROxZUyoElSWN9aUIDIx5miyR+n3rzLvVnO8vcouNwbT78bKFQUF18
 C4W0II8NZtRWJB7nAbKDqjzcjwi0usxtoBPZEwngJk0JBZpFXnWhqvej6h8V8NwLibPI
 id/NZPe5tjLwHM1PNaSm8Ao+UrDM+L12r4+w1PeustuglTn/pXmeZMq5JIcJhFJ1vX1J
 ts9FK9eyJzFKsGw45ZNTa1myueBZtVtzKviOw/4i3+vWi7epjPP5xXUYivlkJFMc/+eH fg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bcfd4a09m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 05:12:40 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 05:12:38 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 29 Sep 2021 05:12:35 -0700
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <aelior@marvell.com>,
        <smalin@marvell.com>, <jhasan@marvell.com>,
        <mrangankar@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        Omkar Kulkarni <okulkarni@marvell.com>
Subject: [PATCH 03/12] qed: Update common_hsi for FW ver 8.59.1.0
Date:   Wed, 29 Sep 2021 15:12:06 +0300
Message-ID: <20210929121215.17864-4-pkushwaha@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210929121215.17864-1-pkushwaha@marvell.com>
References: <20210929121215.17864-1-pkushwaha@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: _VIg6G2axkFWDn7F9T9d_i11P-Qr7vEK
X-Proofpoint-ORIG-GUID: _VIg6G2axkFWDn7F9T9d_i11P-Qr7vEK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_05,2021-09-29_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The common_hsi.h has been updated for FW version 8.59.1.0 with below
changes.
  - FW and Tools version.
  - New structures related to search table, packet duplication.
  - Structure for doorbell address for legacy mode without DEM.
  - Enhanced union rdma_eqe_data for RoCE Suspend Event Data.
  - New defines.

This patch also fixes the existing checkpatch warnings and few important
checks.

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_hsi.h |   2 +-
 include/linux/qed/common_hsi.h            | 113 ++++++++++++++++++++--
 2 files changed, 106 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index ad828c7a58cb..81a12468efbc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -1093,7 +1093,7 @@ enum malicious_vf_error_id {
 /* Mstorm non-triggering VF zone */
 struct mstorm_non_trigger_vf_zone {
 	struct eth_mstorm_per_queue_stat eth_queue_stat;
-	struct eth_rx_prod_data eth_rx_queue_producers[ETH_MAX_NUM_RX_QUEUES_PER_VF_QUAD];
+	struct eth_rx_prod_data eth_rx_queue_producers[ETH_MAX_RXQ_VF_QUAD];
 };
 
 /* Mstorm VF zone */
diff --git a/include/linux/qed/common_hsi.h b/include/linux/qed/common_hsi.h
index 3742d1f7d1f7..827624840ee2 100644
--- a/include/linux/qed/common_hsi.h
+++ b/include/linux/qed/common_hsi.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2016  QLogic Corporation
- * Copyright (c) 2019-2020 Marvell International Ltd.
+ * Copyright (c) 2019-2021 Marvell International Ltd.
  */
 
 #ifndef _COMMON_HSI_H
@@ -47,10 +47,10 @@
 #define ISCSI_CDU_TASK_SEG_TYPE			0
 #define FCOE_CDU_TASK_SEG_TYPE			0
 #define RDMA_CDU_TASK_SEG_TYPE			1
+#define ETH_CDU_TASK_SEG_TYPE			2
 
 #define FW_ASSERT_GENERAL_ATTN_IDX		32
 
-
 /* Queue Zone sizes in bytes */
 #define TSTORM_QZONE_SIZE	8
 #define MSTORM_QZONE_SIZE	16
@@ -60,9 +60,12 @@
 #define PSTORM_QZONE_SIZE	0
 
 #define MSTORM_VF_ZONE_DEFAULT_SIZE_LOG		7
-#define ETH_MAX_NUM_RX_QUEUES_PER_VF_DEFAULT	16
-#define ETH_MAX_NUM_RX_QUEUES_PER_VF_DOUBLE	48
-#define ETH_MAX_NUM_RX_QUEUES_PER_VF_QUAD	112
+#define ETH_MAX_RXQ_VF_DEFAULT 16
+#define ETH_MAX_RXQ_VF_DOUBLE 48
+#define ETH_MAX_RXQ_VF_QUAD 112
+
+#define ETH_RGSRC_CTX_SIZE			6
+#define ETH_TGSRC_CTX_SIZE			6
 
 /********************************/
 /* CORE (LIGHT L2) FW CONSTANTS */
@@ -89,8 +92,8 @@
 #define MAX_NUM_LL2_TX_STATS_COUNTERS  48
 
 #define FW_MAJOR_VERSION	8
-#define FW_MINOR_VERSION	42
-#define FW_REVISION_VERSION	2
+#define FW_MINOR_VERSION	59
+#define FW_REVISION_VERSION	1
 #define FW_ENGINEERING_VERSION	0
 
 /***********************/
@@ -112,6 +115,7 @@
 #define MAX_NUM_VFS	(MAX_NUM_VFS_K2)
 
 #define MAX_NUM_FUNCTIONS_BB	(MAX_NUM_PFS_BB + MAX_NUM_VFS_BB)
+#define MAX_NUM_FUNCTIONS_K2    (MAX_NUM_PFS_K2 + MAX_NUM_VFS_K2)
 
 #define MAX_FUNCTION_NUMBER_BB	(MAX_NUM_PFS + MAX_NUM_VFS_BB)
 #define MAX_FUNCTION_NUMBER_K2  (MAX_NUM_PFS + MAX_NUM_VFS_K2)
@@ -144,7 +148,7 @@
 #define GTT_DWORD_SIZE		BIT(GTT_DWORD_SIZE_BITS)
 
 /* Tools Version */
-#define TOOLS_VERSION	10
+#define TOOLS_VERSION 11
 
 /*****************/
 /* CDU CONSTANTS */
@@ -162,6 +166,7 @@
 #define CDU_CONTEXT_VALIDATION_CFG_USE_REGION			(3)
 #define CDU_CONTEXT_VALIDATION_CFG_USE_CID			(4)
 #define CDU_CONTEXT_VALIDATION_CFG_USE_ACTIVE			(5)
+#define CDU_CONTEXT_VALIDATION_DEFAULT_CFG			(0x3d)
 
 /*****************/
 /* DQ CONSTANTS  */
@@ -302,6 +307,9 @@
 /* PWM address mapping */
 #define DQ_PWM_OFFSET_DPM_BASE		0x0
 #define DQ_PWM_OFFSET_DPM_END		0x27
+#define DQ_PWM_OFFSET_XCM32_24ICID_BASE 0x28
+#define DQ_PWM_OFFSET_UCM32_24ICID_BASE 0x30
+#define DQ_PWM_OFFSET_TCM32_24ICID_BASE 0x38
 #define DQ_PWM_OFFSET_XCM16_BASE	0x40
 #define DQ_PWM_OFFSET_XCM32_BASE	0x44
 #define DQ_PWM_OFFSET_UCM16_BASE	0x48
@@ -325,6 +333,13 @@
 #define DQ_PWM_OFFSET_TCM_LL2_PROD_UPDATE \
 	(DQ_PWM_OFFSET_TCM32_BASE + DQ_TCM_AGG_VAL_SEL_REG9 - 4)
 
+#define DQ_PWM_OFFSET_XCM_RDMA_24B_ICID_SQ_PROD \
+	(DQ_PWM_OFFSET_XCM32_24ICID_BASE + 2)
+#define DQ_PWM_OFFSET_UCM_RDMA_24B_ICID_CQ_CONS_32BIT \
+	(DQ_PWM_OFFSET_UCM32_24ICID_BASE + 4)
+#define DQ_PWM_OFFSET_TCM_ROCE_24B_ICID_RQ_PROD \
+	(DQ_PWM_OFFSET_TCM32_24ICID_BASE + 1)
+
 #define	DQ_REGION_SHIFT			(12)
 
 /* DPM */
@@ -360,6 +375,7 @@
 
 /* Number of global Vport/QCN rate limiters */
 #define MAX_QM_GLOBAL_RLS	256
+#define COMMON_MAX_QM_GLOBAL_RLS MAX_QM_GLOBAL_RLS
 
 /* QM registers data */
 #define QM_LINE_CRD_REG_WIDTH		16
@@ -700,6 +716,13 @@ enum mf_mode {
 	MAX_MF_MODE
 };
 
+/* Per protocol packet duplication enable bit vector. If set, duplicate
+ * offloaded traffic to LL2 debug queueu.
+ */
+struct offload_pkt_dup_enable {
+	__le16 enable_vector;
+};
+
 /* Per-protocol connection types */
 enum protocol_type {
 	PROTOCOLID_TCP_ULP,
@@ -717,6 +740,12 @@ enum protocol_type {
 	MAX_PROTOCOL_TYPE
 };
 
+/* Pstorm packet duplication config */
+struct pstorm_pkt_dup_cfg {
+	struct offload_pkt_dup_enable enable;
+	__le16 reserved[3];
+};
+
 struct regpair {
 	__le32 lo;
 	__le32 hi;
@@ -728,10 +757,24 @@ struct rdma_eqe_destroy_qp {
 	u8 reserved[4];
 };
 
+/* RoCE Suspend Event Data */
+struct rdma_eqe_suspend_qp {
+	__le32 cid;
+	u8 reserved[4];
+};
+
 /* RDMA Event Data Union */
 union rdma_eqe_data {
 	struct regpair async_handle;
 	struct rdma_eqe_destroy_qp rdma_destroy_qp_data;
+	struct rdma_eqe_suspend_qp rdma_suspend_qp_data;
+};
+
+/* Tstorm packet duplication config */
+struct tstorm_pkt_dup_cfg {
+	struct offload_pkt_dup_enable enable;
+	__le16 reserved;
+	__le32 cid;
 };
 
 struct tstorm_queue_zone {
@@ -891,6 +934,15 @@ struct db_legacy_addr {
 #define DB_LEGACY_ADDR_ICID_SHIFT	5
 };
 
+/* Structure for doorbell address, in legacy mode, without DEMS */
+struct db_legacy_wo_dems_addr {
+	__le32 addr;
+#define DB_LEGACY_WO_DEMS_ADDR_RESERVED0_MASK   0x3
+#define DB_LEGACY_WO_DEMS_ADDR_RESERVED0_SHIFT  0
+#define DB_LEGACY_WO_DEMS_ADDR_ICID_MASK        0x3FFFFFFF
+#define DB_LEGACY_WO_DEMS_ADDR_ICID_SHIFT       2
+};
+
 /* Structure for doorbell address, in PWM mode */
 struct db_pwm_addr {
 	__le32 addr;
@@ -906,6 +958,31 @@ struct db_pwm_addr {
 #define DB_PWM_ADDR_RESERVED1_SHIFT	28
 };
 
+/* Parameters to RDMA firmware, passed in EDPM doorbell */
+struct db_rdma_24b_icid_dpm_params {
+	__le32 params;
+#define DB_RDMA_24B_ICID_DPM_PARAMS_SIZE_MASK   0x3F
+#define DB_RDMA_24B_ICID_DPM_PARAMS_SIZE_SHIFT  0
+#define DB_RDMA_24B_ICID_DPM_PARAMS_DPM_TYPE_MASK       0x3
+#define DB_RDMA_24B_ICID_DPM_PARAMS_DPM_TYPE_SHIFT      6
+#define DB_RDMA_24B_ICID_DPM_PARAMS_OPCODE_MASK 0xFF
+#define DB_RDMA_24B_ICID_DPM_PARAMS_OPCODE_SHIFT        8
+#define DB_RDMA_24B_ICID_DPM_PARAMS_ICID_EXT_MASK       0xFF
+#define DB_RDMA_24B_ICID_DPM_PARAMS_ICID_EXT_SHIFT      16
+#define DB_RDMA_24B_ICID_DPM_PARAMS_INV_BYTE_CNT_MASK   0x7
+#define DB_RDMA_24B_ICID_DPM_PARAMS_INV_BYTE_CNT_SHIFT  24
+#define DB_RDMA_24B_ICID_DPM_PARAMS_EXT_ICID_MODE_EN_MASK       0x1
+#define DB_RDMA_24B_ICID_DPM_PARAMS_EXT_ICID_MODE_EN_SHIFT      27
+#define DB_RDMA_24B_ICID_DPM_PARAMS_COMPLETION_FLG_MASK 0x1
+#define DB_RDMA_24B_ICID_DPM_PARAMS_COMPLETION_FLG_SHIFT        28
+#define DB_RDMA_24B_ICID_DPM_PARAMS_S_FLG_MASK  0x1
+#define DB_RDMA_24B_ICID_DPM_PARAMS_S_FLG_SHIFT 29
+#define DB_RDMA_24B_ICID_DPM_PARAMS_RESERVED1_MASK      0x1
+#define DB_RDMA_24B_ICID_DPM_PARAMS_RESERVED1_SHIFT     30
+#define DB_RDMA_24B_ICID_DPM_PARAMS_CONN_TYPE_IS_IWARP_MASK     0x1
+#define DB_RDMA_24B_ICID_DPM_PARAMS_CONN_TYPE_IS_IWARP_SHIFT    31
+};
+
 /* Parameters to RDMA firmware, passed in EDPM doorbell */
 struct db_rdma_dpm_params {
 	__le32 params;
@@ -1220,6 +1297,26 @@ struct rdif_task_context {
 	__le32 reserved2;
 };
 
+/* Searcher Table struct */
+struct src_entry_header {
+	__le32 flags;
+#define SRC_ENTRY_HEADER_NEXT_PTR_TYPE_MASK     0x1
+#define SRC_ENTRY_HEADER_NEXT_PTR_TYPE_SHIFT    0
+#define SRC_ENTRY_HEADER_EMPTY_MASK     0x1
+#define SRC_ENTRY_HEADER_EMPTY_SHIFT    1
+#define SRC_ENTRY_HEADER_RESERVED_MASK  0x3FFFFFFF
+#define SRC_ENTRY_HEADER_RESERVED_SHIFT 2
+	__le32 magic_number;
+	struct regpair next_ptr;
+};
+
+/* Enumeration for address type */
+enum src_header_next_ptr_type_enum {
+	e_physical_addr,
+	e_logical_addr,
+	MAX_SRC_HEADER_NEXT_PTR_TYPE_ENUM
+};
+
 /* Status block structure */
 struct status_block {
 	__le16	pi_array[PIS_PER_SB];
-- 
2.24.1

