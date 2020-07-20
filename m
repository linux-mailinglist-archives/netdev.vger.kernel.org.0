Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FFE226DE9
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389328AbgGTSJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:09:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:11150 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729172AbgGTSJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:09:49 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KHtqxv019581;
        Mon, 20 Jul 2020 11:09:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=MQbMYRZusqwud1j6fzV9f448dOqD046v72K1XQ1Jtu4=;
 b=VBE2mlFujLSDvfSr2y4iLEJ11ELhM1UhNd2VXsvmQBDGRVs4qWk8bh9VXy5KcXGBJTgn
 2EYPlSNkjc61r32vbKnUydeO1tc8VlDbWM3RA6WrsTUHjC2YskmKpUX81ZIm33HM9mOE
 jX8vzHFSDimd7YSFvwb2m7ZLxSQghkPUOaB3l5eOWTQ4qO1iNKXzm3oktxac0UEuTxpy
 UBSUDdeLQn3n++i0K6GDqdJgG+MQg2OLgrGibviJUhciv9FEfIVtRZLflJYjr04Xln8Q
 6m7S3FG38IxQubEeQMFpTWDn5rbPPHH0dBY3Bin5LyGI+If60GoC+nBHrDJRgugoHg5Q Tg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxenfx00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:09:41 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:09:40 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:09:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:09:39 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id CC9A23F703F;
        Mon, 20 Jul 2020 11:09:34 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 net-next 11/16] qed: reformat several structures a bit
Date:   Mon, 20 Jul 2020 21:08:10 +0300
Message-ID: <20200720180815.107-12-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720180815.107-1-alobakin@marvell.com>
References: <20200720180815.107-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reformat a few nvm_cfg* structures (and partly qed_dev) prior to adding
new fields and definitions.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h     | 109 +++----
 drivers/net/ethernet/qlogic/qed/qed_hsi.h | 345 +++++++++++-----------
 drivers/net/ethernet/qlogic/qed/qed_mcp.h |  12 +-
 3 files changed, 237 insertions(+), 229 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index ced805399e4f..e2d7a4bbab53 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -280,48 +280,49 @@ enum qed_db_rec_exec {
 
 struct qed_hw_info {
 	/* PCI personality */
-	enum qed_pci_personality personality;
-#define QED_IS_RDMA_PERSONALITY(dev)			    \
-	((dev)->hw_info.personality == QED_PCI_ETH_ROCE ||  \
-	 (dev)->hw_info.personality == QED_PCI_ETH_IWARP || \
+	enum qed_pci_personality	personality;
+#define QED_IS_RDMA_PERSONALITY(dev)					\
+	((dev)->hw_info.personality == QED_PCI_ETH_ROCE ||		\
+	 (dev)->hw_info.personality == QED_PCI_ETH_IWARP ||		\
 	 (dev)->hw_info.personality == QED_PCI_ETH_RDMA)
-#define QED_IS_ROCE_PERSONALITY(dev)			   \
-	((dev)->hw_info.personality == QED_PCI_ETH_ROCE || \
+#define QED_IS_ROCE_PERSONALITY(dev)					\
+	((dev)->hw_info.personality == QED_PCI_ETH_ROCE ||		\
 	 (dev)->hw_info.personality == QED_PCI_ETH_RDMA)
-#define QED_IS_IWARP_PERSONALITY(dev)			    \
-	((dev)->hw_info.personality == QED_PCI_ETH_IWARP || \
+#define QED_IS_IWARP_PERSONALITY(dev)					\
+	((dev)->hw_info.personality == QED_PCI_ETH_IWARP ||		\
 	 (dev)->hw_info.personality == QED_PCI_ETH_RDMA)
-#define QED_IS_L2_PERSONALITY(dev)		      \
-	((dev)->hw_info.personality == QED_PCI_ETH || \
+#define QED_IS_L2_PERSONALITY(dev)					\
+	((dev)->hw_info.personality == QED_PCI_ETH ||			\
 	 QED_IS_RDMA_PERSONALITY(dev))
-#define QED_IS_FCOE_PERSONALITY(dev) \
+#define QED_IS_FCOE_PERSONALITY(dev)					\
 	((dev)->hw_info.personality == QED_PCI_FCOE)
-#define QED_IS_ISCSI_PERSONALITY(dev) \
+#define QED_IS_ISCSI_PERSONALITY(dev)					\
 	((dev)->hw_info.personality == QED_PCI_ISCSI)
 
 	/* Resource Allocation scheme results */
 	u32				resc_start[QED_MAX_RESC];
 	u32				resc_num[QED_MAX_RESC];
-	u32				feat_num[QED_MAX_FEATURES];
+#define RESC_START(_p_hwfn, resc)	((_p_hwfn)->hw_info.resc_start[resc])
+#define RESC_NUM(_p_hwfn, resc)		((_p_hwfn)->hw_info.resc_num[resc])
+#define RESC_END(_p_hwfn, resc)		(RESC_START(_p_hwfn, resc) +	\
+					 RESC_NUM(_p_hwfn, resc))
 
-#define RESC_START(_p_hwfn, resc) ((_p_hwfn)->hw_info.resc_start[resc])
-#define RESC_NUM(_p_hwfn, resc) ((_p_hwfn)->hw_info.resc_num[resc])
-#define RESC_END(_p_hwfn, resc) (RESC_START(_p_hwfn, resc) + \
-				 RESC_NUM(_p_hwfn, resc))
-#define FEAT_NUM(_p_hwfn, resc) ((_p_hwfn)->hw_info.feat_num[resc])
+	u32				feat_num[QED_MAX_FEATURES];
+#define FEAT_NUM(_p_hwfn, resc)		((_p_hwfn)->hw_info.feat_num[resc])
 
 	/* Amount of traffic classes HW supports */
-	u8 num_hw_tc;
+	u8				num_hw_tc;
 
 	/* Amount of TCs which should be active according to DCBx or upper
 	 * layer driver configuration.
 	 */
-	u8 num_active_tc;
+	u8				num_active_tc;
+
 	u8				offload_tc;
 	bool				offload_tc_set;
 
 	bool				multi_tc_roce_en;
-#define IS_QED_MULTI_TC_ROCE(p_hwfn) (((p_hwfn)->hw_info.multi_tc_roce_en))
+#define IS_QED_MULTI_TC_ROCE(p_hwfn)	((p_hwfn)->hw_info.multi_tc_roce_en)
 
 	u32				concrete_fid;
 	u16				opaque_fid;
@@ -338,10 +339,10 @@ struct qed_hw_info {
 
 	u32				port_mode;
 	u32				hw_mode;
-	unsigned long		device_capabilities;
+	unsigned long			device_capabilities;
 	u16				mtu;
 
-	enum qed_wol_support b_wol_support;
+	enum qed_wol_support		b_wol_support;
 };
 
 /* maximun size of read/write commands (HW limit) */
@@ -715,41 +716,41 @@ struct qed_dbg_feature {
 };
 
 struct qed_dev {
-	u32	dp_module;
-	u8	dp_level;
-	char	name[NAME_SIZE];
-
-	enum	qed_dev_type type;
-/* Translate type/revision combo into the proper conditions */
-#define QED_IS_BB(dev)  ((dev)->type == QED_DEV_TYPE_BB)
-#define QED_IS_BB_B0(dev)       (QED_IS_BB(dev) && \
-				 CHIP_REV_IS_B0(dev))
-#define QED_IS_AH(dev)  ((dev)->type == QED_DEV_TYPE_AH)
-#define QED_IS_K2(dev)  QED_IS_AH(dev)
-
-	u16	vendor_id;
-	u16	device_id;
-#define QED_DEV_ID_MASK		0xff00
-#define QED_DEV_ID_MASK_BB	0x1600
-#define QED_DEV_ID_MASK_AH	0x8000
-#define QED_IS_E4(dev)  (QED_IS_BB(dev) || QED_IS_AH(dev))
-
-	u16	chip_num;
-#define CHIP_NUM_MASK                   0xffff
-#define CHIP_NUM_SHIFT                  16
-
-	u16	chip_rev;
-#define CHIP_REV_MASK                   0xf
-#define CHIP_REV_SHIFT                  12
-#define CHIP_REV_IS_B0(_cdev)   ((_cdev)->chip_rev == 1)
+	u32				dp_module;
+	u8				dp_level;
+	char				name[NAME_SIZE];
+
+	enum qed_dev_type		type;
+	/* Translate type/revision combo into the proper conditions */
+#define QED_IS_BB(dev)			((dev)->type == QED_DEV_TYPE_BB)
+#define QED_IS_BB_B0(dev)		(QED_IS_BB(dev) && CHIP_REV_IS_B0(dev))
+#define QED_IS_AH(dev)			((dev)->type == QED_DEV_TYPE_AH)
+#define QED_IS_K2(dev)			QED_IS_AH(dev)
+#define QED_IS_E4(dev)			(QED_IS_BB(dev) || QED_IS_AH(dev))
+
+	u16				vendor_id;
+
+	u16				device_id;
+#define QED_DEV_ID_MASK			0xff00
+#define QED_DEV_ID_MASK_BB		0x1600
+#define QED_DEV_ID_MASK_AH		0x8000
+
+	u16				chip_num;
+#define CHIP_NUM_MASK			0xffff
+#define CHIP_NUM_SHIFT			16
+
+	u16				chip_rev;
+#define CHIP_REV_MASK			0xf
+#define CHIP_REV_SHIFT			12
+#define CHIP_REV_IS_B0(_cdev)		((_cdev)->chip_rev == 1)
 
 	u16				chip_metal;
-#define CHIP_METAL_MASK                 0xff
-#define CHIP_METAL_SHIFT                4
+#define CHIP_METAL_MASK			0xff
+#define CHIP_METAL_SHIFT		4
 
 	u16				chip_bond_id;
-#define CHIP_BOND_ID_MASK               0xf
-#define CHIP_BOND_ID_SHIFT              0
+#define CHIP_BOND_ID_MASK		0xf
+#define CHIP_BOND_ID_SHIFT		0
 
 	u8				num_engines;
 	u8				num_ports;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 7c1d4efffbff..a4a845579fd2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -12532,67 +12532,67 @@ struct public_drv_mb {
 #define DRV_MB_PARAM_SET_LED_MODE_ON		0x1
 #define DRV_MB_PARAM_SET_LED_MODE_OFF		0x2
 
-#define DRV_MB_PARAM_TRANSCEIVER_PORT_OFFSET		0
-#define DRV_MB_PARAM_TRANSCEIVER_PORT_MASK		0x00000003
-#define DRV_MB_PARAM_TRANSCEIVER_SIZE_OFFSET		2
-#define DRV_MB_PARAM_TRANSCEIVER_SIZE_MASK		0x000000FC
-#define DRV_MB_PARAM_TRANSCEIVER_I2C_ADDRESS_OFFSET	8
-#define DRV_MB_PARAM_TRANSCEIVER_I2C_ADDRESS_MASK	0x0000FF00
-#define DRV_MB_PARAM_TRANSCEIVER_OFFSET_OFFSET		16
-#define DRV_MB_PARAM_TRANSCEIVER_OFFSET_MASK		0xFFFF0000
+#define DRV_MB_PARAM_TRANSCEIVER_PORT_OFFSET			0
+#define DRV_MB_PARAM_TRANSCEIVER_PORT_MASK			0x00000003
+#define DRV_MB_PARAM_TRANSCEIVER_SIZE_OFFSET			2
+#define DRV_MB_PARAM_TRANSCEIVER_SIZE_MASK			0x000000fc
+#define DRV_MB_PARAM_TRANSCEIVER_I2C_ADDRESS_OFFSET		8
+#define DRV_MB_PARAM_TRANSCEIVER_I2C_ADDRESS_MASK		0x0000ff00
+#define DRV_MB_PARAM_TRANSCEIVER_OFFSET_OFFSET			16
+#define DRV_MB_PARAM_TRANSCEIVER_OFFSET_MASK			0xffff0000
 
 	/* Resource Allocation params - Driver version support */
-#define DRV_MB_PARAM_RESOURCE_ALLOC_VERSION_MAJOR_MASK	0xFFFF0000
-#define DRV_MB_PARAM_RESOURCE_ALLOC_VERSION_MAJOR_SHIFT	16
-#define DRV_MB_PARAM_RESOURCE_ALLOC_VERSION_MINOR_MASK	0x0000FFFF
-#define DRV_MB_PARAM_RESOURCE_ALLOC_VERSION_MINOR_SHIFT	0
-
-#define DRV_MB_PARAM_BIST_REGISTER_TEST		1
-#define DRV_MB_PARAM_BIST_CLOCK_TEST		2
-#define DRV_MB_PARAM_BIST_NVM_TEST_NUM_IMAGES	3
-#define DRV_MB_PARAM_BIST_NVM_TEST_IMAGE_BY_INDEX	4
-
-#define DRV_MB_PARAM_BIST_RC_UNKNOWN		0
-#define DRV_MB_PARAM_BIST_RC_PASSED		1
-#define DRV_MB_PARAM_BIST_RC_FAILED		2
-#define DRV_MB_PARAM_BIST_RC_INVALID_PARAMETER	3
-
-#define DRV_MB_PARAM_BIST_TEST_INDEX_SHIFT	0
-#define DRV_MB_PARAM_BIST_TEST_INDEX_MASK	0x000000FF
-#define DRV_MB_PARAM_BIST_TEST_IMAGE_INDEX_SHIFT	8
-#define DRV_MB_PARAM_BIST_TEST_IMAGE_INDEX_MASK		0x0000FF00
-
-#define DRV_MB_PARAM_FEATURE_SUPPORT_PORT_MASK		0x0000FFFF
-#define DRV_MB_PARAM_FEATURE_SUPPORT_PORT_OFFSET	0
-#define DRV_MB_PARAM_FEATURE_SUPPORT_PORT_EEE		0x00000002
-#define DRV_MB_PARAM_FEATURE_SUPPORT_PORT_FEC_CONTROL	0x00000004
-#define DRV_MB_PARAM_FEATURE_SUPPORT_FUNC_VLINK		0x00010000
+#define DRV_MB_PARAM_RESOURCE_ALLOC_VERSION_MAJOR_MASK		0xffff0000
+#define DRV_MB_PARAM_RESOURCE_ALLOC_VERSION_MAJOR_SHIFT		16
+#define DRV_MB_PARAM_RESOURCE_ALLOC_VERSION_MINOR_MASK		0x0000ffff
+#define DRV_MB_PARAM_RESOURCE_ALLOC_VERSION_MINOR_SHIFT		0
+
+#define DRV_MB_PARAM_BIST_REGISTER_TEST				1
+#define DRV_MB_PARAM_BIST_CLOCK_TEST				2
+#define DRV_MB_PARAM_BIST_NVM_TEST_NUM_IMAGES			3
+#define DRV_MB_PARAM_BIST_NVM_TEST_IMAGE_BY_INDEX		4
+
+#define DRV_MB_PARAM_BIST_RC_UNKNOWN				0
+#define DRV_MB_PARAM_BIST_RC_PASSED				1
+#define DRV_MB_PARAM_BIST_RC_FAILED				2
+#define DRV_MB_PARAM_BIST_RC_INVALID_PARAMETER			3
+
+#define DRV_MB_PARAM_BIST_TEST_INDEX_SHIFT			0
+#define DRV_MB_PARAM_BIST_TEST_INDEX_MASK			0x000000ff
+#define DRV_MB_PARAM_BIST_TEST_IMAGE_INDEX_SHIFT		8
+#define DRV_MB_PARAM_BIST_TEST_IMAGE_INDEX_MASK			0x0000ff00
+
+#define DRV_MB_PARAM_FEATURE_SUPPORT_PORT_MASK			0x0000ffff
+#define DRV_MB_PARAM_FEATURE_SUPPORT_PORT_OFFSET		0
+#define DRV_MB_PARAM_FEATURE_SUPPORT_PORT_EEE			0x00000002
+#define DRV_MB_PARAM_FEATURE_SUPPORT_PORT_FEC_CONTROL		0x00000004
+#define DRV_MB_PARAM_FEATURE_SUPPORT_FUNC_VLINK			0x00010000
 
 /* DRV_MSG_CODE_DEBUG_DATA_SEND parameters */
-#define DRV_MSG_CODE_DEBUG_DATA_SEND_SIZE_OFFSET	0
-#define DRV_MSG_CODE_DEBUG_DATA_SEND_SIZE_MASK		0xFF
+#define DRV_MSG_CODE_DEBUG_DATA_SEND_SIZE_OFFSET		0
+#define DRV_MSG_CODE_DEBUG_DATA_SEND_SIZE_MASK			0xff
 
 /* Driver attributes params */
-#define DRV_MB_PARAM_ATTRIBUTE_KEY_OFFSET		0
-#define DRV_MB_PARAM_ATTRIBUTE_KEY_MASK			0x00FFFFFF
-#define DRV_MB_PARAM_ATTRIBUTE_CMD_OFFSET		24
-#define DRV_MB_PARAM_ATTRIBUTE_CMD_MASK			0xFF000000
-
-#define DRV_MB_PARAM_NVM_CFG_OPTION_ID_OFFSET		0
-#define DRV_MB_PARAM_NVM_CFG_OPTION_ID_SHIFT		0
-#define DRV_MB_PARAM_NVM_CFG_OPTION_ID_MASK		0x0000FFFF
-#define DRV_MB_PARAM_NVM_CFG_OPTION_ALL_SHIFT		16
-#define DRV_MB_PARAM_NVM_CFG_OPTION_ALL_MASK		0x00010000
-#define DRV_MB_PARAM_NVM_CFG_OPTION_INIT_SHIFT		17
-#define DRV_MB_PARAM_NVM_CFG_OPTION_INIT_MASK		0x00020000
-#define DRV_MB_PARAM_NVM_CFG_OPTION_COMMIT_SHIFT	18
-#define DRV_MB_PARAM_NVM_CFG_OPTION_COMMIT_MASK		0x00040000
-#define DRV_MB_PARAM_NVM_CFG_OPTION_FREE_SHIFT		19
-#define DRV_MB_PARAM_NVM_CFG_OPTION_FREE_MASK		0x00080000
-#define DRV_MB_PARAM_NVM_CFG_OPTION_ENTITY_SEL_SHIFT	20
-#define DRV_MB_PARAM_NVM_CFG_OPTION_ENTITY_SEL_MASK	0x00100000
-#define DRV_MB_PARAM_NVM_CFG_OPTION_ENTITY_ID_SHIFT	24
-#define DRV_MB_PARAM_NVM_CFG_OPTION_ENTITY_ID_MASK	0x0f000000
+#define DRV_MB_PARAM_ATTRIBUTE_KEY_OFFSET			0
+#define DRV_MB_PARAM_ATTRIBUTE_KEY_MASK				0x00ffffff
+#define DRV_MB_PARAM_ATTRIBUTE_CMD_OFFSET			24
+#define DRV_MB_PARAM_ATTRIBUTE_CMD_MASK				0xff000000
+
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ID_OFFSET			0
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ID_SHIFT			0
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ID_MASK			0x0000ffff
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ALL_SHIFT			16
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ALL_MASK			0x00010000
+#define DRV_MB_PARAM_NVM_CFG_OPTION_INIT_SHIFT			17
+#define DRV_MB_PARAM_NVM_CFG_OPTION_INIT_MASK			0x00020000
+#define DRV_MB_PARAM_NVM_CFG_OPTION_COMMIT_SHIFT		18
+#define DRV_MB_PARAM_NVM_CFG_OPTION_COMMIT_MASK			0x00040000
+#define DRV_MB_PARAM_NVM_CFG_OPTION_FREE_SHIFT			19
+#define DRV_MB_PARAM_NVM_CFG_OPTION_FREE_MASK			0x00080000
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ENTITY_SEL_SHIFT		20
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ENTITY_SEL_MASK		0x00100000
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ENTITY_ID_SHIFT		24
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ENTITY_ID_MASK		0x0f000000
 
 	u32 fw_mb_header;
 #define FW_MSG_CODE_MASK			0xffff0000
@@ -12639,56 +12639,56 @@ struct public_drv_mb {
 
 #define FW_MSG_CODE_MDUMP_INVALID_CMD		0x00030000
 
-	u32						fw_mb_param;
-#define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MAJOR_MASK	0xffff0000
-#define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MAJOR_SHIFT	16
-#define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MINOR_MASK	0x0000ffff
-#define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MINOR_SHIFT	0
+	u32							fw_mb_param;
+#define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MAJOR_MASK		0xffff0000
+#define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MAJOR_SHIFT		16
+#define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MINOR_MASK		0x0000ffff
+#define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MINOR_SHIFT		0
 
 	/* Get PF RDMA protocol command response */
-#define FW_MB_PARAM_GET_PF_RDMA_NONE			0x0
-#define FW_MB_PARAM_GET_PF_RDMA_ROCE			0x1
-#define FW_MB_PARAM_GET_PF_RDMA_IWARP			0x2
-#define FW_MB_PARAM_GET_PF_RDMA_BOTH			0x3
+#define FW_MB_PARAM_GET_PF_RDMA_NONE				0x0
+#define FW_MB_PARAM_GET_PF_RDMA_ROCE				0x1
+#define FW_MB_PARAM_GET_PF_RDMA_IWARP				0x2
+#define FW_MB_PARAM_GET_PF_RDMA_BOTH				0x3
 
 	/* Get MFW feature support response */
-#define FW_MB_PARAM_FEATURE_SUPPORT_SMARTLINQ		0x00000001
-#define FW_MB_PARAM_FEATURE_SUPPORT_EEE			0x00000002
-#define FW_MB_PARAM_FEATURE_SUPPORT_FEC_CONTROL		0x00000020
-#define FW_MB_PARAM_FEATURE_SUPPORT_VLINK		0x00010000
+#define FW_MB_PARAM_FEATURE_SUPPORT_SMARTLINQ			BIT(0)
+#define FW_MB_PARAM_FEATURE_SUPPORT_EEE				BIT(1)
+#define FW_MB_PARAM_FEATURE_SUPPORT_FEC_CONTROL			BIT(5)
+#define FW_MB_PARAM_FEATURE_SUPPORT_VLINK			BIT(16)
 
-#define FW_MB_PARAM_LOAD_DONE_DID_EFUSE_ERROR		BIT(0)
+#define FW_MB_PARAM_LOAD_DONE_DID_EFUSE_ERROR			BIT(0)
 
-#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALID_MASK	0x00000001
-#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALID_SHIFT	0
-#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALUE_MASK	0x00000002
-#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALUE_SHIFT	1
-#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALID_MASK		0x00000004
-#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALID_SHIFT	2
-#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALUE_MASK		0x00000008
-#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALUE_SHIFT	3
+#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALID_MASK		0x00000001
+#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALID_SHIFT		0
+#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALUE_MASK		0x00000002
+#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALUE_SHIFT		1
+#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALID_MASK			0x00000004
+#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALID_SHIFT		2
+#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALUE_MASK			0x00000008
+#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALUE_SHIFT		3
 
-#define FW_MB_PARAM_PPFID_BITMAP_MASK			0xff
-#define FW_MB_PARAM_PPFID_BITMAP_SHIFT			0
+#define FW_MB_PARAM_PPFID_BITMAP_MASK				0xff
+#define FW_MB_PARAM_PPFID_BITMAP_SHIFT				0
 
-	u32						drv_pulse_mb;
-#define DRV_PULSE_SEQ_MASK				0x00007fff
-#define DRV_PULSE_SYSTEM_TIME_MASK			0xffff0000
-#define DRV_PULSE_ALWAYS_ALIVE				0x00008000
+	u32							drv_pulse_mb;
+#define DRV_PULSE_SEQ_MASK					0x00007fff
+#define DRV_PULSE_SYSTEM_TIME_MASK				0xffff0000
+#define DRV_PULSE_ALWAYS_ALIVE					0x00008000
 
-	u32						mcp_pulse_mb;
-#define MCP_PULSE_SEQ_MASK				0x00007fff
-#define MCP_PULSE_ALWAYS_ALIVE				0x00008000
-#define MCP_EVENT_MASK					0xffff0000
-#define MCP_EVENT_OTHER_DRIVER_RESET_REQ		0x00010000
+	u32							mcp_pulse_mb;
+#define MCP_PULSE_SEQ_MASK					0x00007fff
+#define MCP_PULSE_ALWAYS_ALIVE					0x00008000
+#define MCP_EVENT_MASK						0xffff0000
+#define MCP_EVENT_OTHER_DRIVER_RESET_REQ			0x00010000
 
-	union drv_union_data				union_data;
+	union drv_union_data					union_data;
 };
 
-#define FW_MB_PARAM_NVM_PUT_FILE_REQ_OFFSET_MASK	0x00ffffff
-#define FW_MB_PARAM_NVM_PUT_FILE_REQ_OFFSET_SHIFT	0
-#define FW_MB_PARAM_NVM_PUT_FILE_REQ_SIZE_MASK		0xff000000
-#define FW_MB_PARAM_NVM_PUT_FILE_REQ_SIZE_SHIFT		24
+#define FW_MB_PARAM_NVM_PUT_FILE_REQ_OFFSET_MASK		0x00ffffff
+#define FW_MB_PARAM_NVM_PUT_FILE_REQ_OFFSET_SHIFT		0
+#define FW_MB_PARAM_NVM_PUT_FILE_REQ_SIZE_MASK			0xff000000
+#define FW_MB_PARAM_NVM_PUT_FILE_REQ_SIZE_SHIFT			24
 
 enum MFW_DRV_MSG_TYPE {
 	MFW_DRV_MSG_LINK_CHANGE,
@@ -12975,86 +12975,93 @@ enum tlvs {
 };
 
 struct nvm_cfg_mac_address {
-	u32 mac_addr_hi;
-#define NVM_CFG_MAC_ADDRESS_HI_MASK	0x0000FFFF
-#define NVM_CFG_MAC_ADDRESS_HI_OFFSET	0
-	u32 mac_addr_lo;
+	u32							mac_addr_hi;
+#define NVM_CFG_MAC_ADDRESS_HI_MASK				0x0000ffff
+#define NVM_CFG_MAC_ADDRESS_HI_OFFSET				0
+
+	u32							mac_addr_lo;
 };
 
 struct nvm_cfg1_glob {
-	u32 generic_cont0;
-#define NVM_CFG1_GLOB_MF_MODE_MASK		0x00000FF0
-#define NVM_CFG1_GLOB_MF_MODE_OFFSET		4
-#define NVM_CFG1_GLOB_MF_MODE_MF_ALLOWED	0x0
-#define NVM_CFG1_GLOB_MF_MODE_DEFAULT		0x1
-#define NVM_CFG1_GLOB_MF_MODE_SPIO4		0x2
-#define NVM_CFG1_GLOB_MF_MODE_NPAR1_0		0x3
-#define NVM_CFG1_GLOB_MF_MODE_NPAR1_5		0x4
-#define NVM_CFG1_GLOB_MF_MODE_NPAR2_0		0x5
-#define NVM_CFG1_GLOB_MF_MODE_BD		0x6
-#define NVM_CFG1_GLOB_MF_MODE_UFP		0x7
-	u32 engineering_change[3];
-	u32 manufacturing_id;
-	u32 serial_number[4];
-	u32 pcie_cfg;
-	u32 mgmt_traffic;
-	u32 core_cfg;
-#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_MASK		0x000000FF
-#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_OFFSET		0
-#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_BB_2X40G	0x0
-#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_2X50G		0x1
-#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_BB_1X100G	0x2
-#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X10G_F		0x3
-#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_BB_4X10G_E	0x4
-#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_BB_4X20G	0x5
-#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_1X40G		0xB
-#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_2X25G		0xC
-#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_1X25G		0xD
-#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X25G		0xE
-#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_2X10G		0xF
-
-	u32 e_lane_cfg1;
-	u32 e_lane_cfg2;
-	u32 f_lane_cfg1;
-	u32 f_lane_cfg2;
-	u32 mps10_preemphasis;
-	u32 mps10_driver_current;
-	u32 mps25_preemphasis;
-	u32 mps25_driver_current;
-	u32 pci_id;
-	u32 pci_subsys_id;
-	u32 bar;
-	u32 mps10_txfir_main;
-	u32 mps10_txfir_post;
-	u32 mps25_txfir_main;
-	u32 mps25_txfir_post;
-	u32 manufacture_ver;
-	u32 manufacture_time;
-	u32 led_global_settings;
-	u32 generic_cont1;
-	u32 mbi_version;
-#define NVM_CFG1_GLOB_MBI_VERSION_0_MASK		0x000000FF
-#define NVM_CFG1_GLOB_MBI_VERSION_0_OFFSET		0
-#define NVM_CFG1_GLOB_MBI_VERSION_1_MASK		0x0000FF00
-#define NVM_CFG1_GLOB_MBI_VERSION_1_OFFSET		8
-#define NVM_CFG1_GLOB_MBI_VERSION_2_MASK		0x00FF0000
-#define NVM_CFG1_GLOB_MBI_VERSION_2_OFFSET		16
-	u32 mbi_date;
-	u32 misc_sig;
-	u32 device_capabilities;
-#define NVM_CFG1_GLOB_DEVICE_CAPABILITIES_ETHERNET	0x1
-#define NVM_CFG1_GLOB_DEVICE_CAPABILITIES_FCOE		0x2
-#define NVM_CFG1_GLOB_DEVICE_CAPABILITIES_ISCSI		0x4
-#define NVM_CFG1_GLOB_DEVICE_CAPABILITIES_ROCE		0x8
-	u32 power_dissipated;
-	u32 power_consumed;
-	u32 efi_version;
-	u32 multi_network_modes_capability;
-	u32 reserved[41];
+	u32							generic_cont0;
+#define NVM_CFG1_GLOB_MF_MODE_MASK				0x00000ff0
+#define NVM_CFG1_GLOB_MF_MODE_OFFSET				4
+#define NVM_CFG1_GLOB_MF_MODE_MF_ALLOWED			0x0
+#define NVM_CFG1_GLOB_MF_MODE_DEFAULT				0x1
+#define NVM_CFG1_GLOB_MF_MODE_SPIO4				0x2
+#define NVM_CFG1_GLOB_MF_MODE_NPAR1_0				0x3
+#define NVM_CFG1_GLOB_MF_MODE_NPAR1_5				0x4
+#define NVM_CFG1_GLOB_MF_MODE_NPAR2_0				0x5
+#define NVM_CFG1_GLOB_MF_MODE_BD				0x6
+#define NVM_CFG1_GLOB_MF_MODE_UFP				0x7
+
+	u32							engineering_change[3];
+	u32							manufacturing_id;
+	u32							serial_number[4];
+	u32							pcie_cfg;
+	u32							mgmt_traffic;
+
+	u32							core_cfg;
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_MASK			0x000000ff
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_OFFSET			0
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_BB_2X40G		0x0
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_2X50G			0x1
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_BB_1X100G		0x2
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X10G_F			0x3
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_BB_4X10G_E		0x4
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_BB_4X20G		0x5
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_1X40G			0xb
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_2X25G			0xc
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_1X25G			0xd
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X25G			0xe
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_2X10G			0xf
+
+	u32							e_lane_cfg1;
+	u32							e_lane_cfg2;
+	u32							f_lane_cfg1;
+	u32							f_lane_cfg2;
+	u32							mps10_preemphasis;
+	u32							mps10_driver_current;
+	u32							mps25_preemphasis;
+	u32							mps25_driver_current;
+	u32							pci_id;
+	u32							pci_subsys_id;
+	u32							bar;
+	u32							mps10_txfir_main;
+	u32							mps10_txfir_post;
+	u32							mps25_txfir_main;
+	u32							mps25_txfir_post;
+	u32							manufacture_ver;
+	u32							manufacture_time;
+	u32							led_global_settings;
+	u32							generic_cont1;
+
+	u32							mbi_version;
+#define NVM_CFG1_GLOB_MBI_VERSION_0_MASK			0x000000ff
+#define NVM_CFG1_GLOB_MBI_VERSION_0_OFFSET			0
+#define NVM_CFG1_GLOB_MBI_VERSION_1_MASK			0x0000ff00
+#define NVM_CFG1_GLOB_MBI_VERSION_1_OFFSET			8
+#define NVM_CFG1_GLOB_MBI_VERSION_2_MASK			0x00ff0000
+#define NVM_CFG1_GLOB_MBI_VERSION_2_OFFSET			16
+
+	u32							mbi_date;
+	u32							misc_sig;
+
+	u32							device_capabilities;
+#define NVM_CFG1_GLOB_DEVICE_CAPABILITIES_ETHERNET		0x1
+#define NVM_CFG1_GLOB_DEVICE_CAPABILITIES_FCOE			0x2
+#define NVM_CFG1_GLOB_DEVICE_CAPABILITIES_ISCSI			0x4
+#define NVM_CFG1_GLOB_DEVICE_CAPABILITIES_ROCE			0x8
+
+	u32							power_dissipated;
+	u32							power_consumed;
+	u32							efi_version;
+	u32							multi_net_modes_cap;
+	u32							reserved[41];
 };
 
 struct nvm_cfg1_path {
-	u32 reserved[30];
+	u32							reserved[30];
 };
 
 struct nvm_cfg1_port {
@@ -13082,7 +13089,7 @@ struct nvm_cfg1_port {
 #define NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_OFFSET		0
 #define NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G		0x1
 #define NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G		0x2
-#define NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_20G             0x4
+#define NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_20G		0x4
 #define NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G		0x8
 #define NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G		0x10
 #define NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_50G		0x20
@@ -13094,7 +13101,7 @@ struct nvm_cfg1_port {
 #define NVM_CFG1_PORT_DRV_LINK_SPEED_AUTONEG			0x0
 #define NVM_CFG1_PORT_DRV_LINK_SPEED_1G				0x1
 #define NVM_CFG1_PORT_DRV_LINK_SPEED_10G			0x2
-#define NVM_CFG1_PORT_DRV_LINK_SPEED_20G                        0x3
+#define NVM_CFG1_PORT_DRV_LINK_SPEED_20G			0x3
 #define NVM_CFG1_PORT_DRV_LINK_SPEED_25G			0x4
 #define NVM_CFG1_PORT_DRV_LINK_SPEED_40G			0x5
 #define NVM_CFG1_PORT_DRV_LINK_SPEED_50G			0x6
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index 5e50405854e6..ea956c43e596 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -16,15 +16,15 @@
 #include "qed_dev_api.h"
 
 struct qed_mcp_link_speed_params {
-	bool    autoneg;
-	u32     advertised_speeds;      /* bitmask of DRV_SPEED_CAPABILITY */
-	u32     forced_speed;	   /* In Mb/s */
+	bool					autoneg;
+	u32					advertised_speeds;
+	u32					forced_speed;	   /* In Mb/s */
 };
 
 struct qed_mcp_link_pause_params {
-	bool    autoneg;
-	bool    forced_rx;
-	bool    forced_tx;
+	bool					autoneg;
+	bool					forced_rx;
+	bool					forced_tx;
 };
 
 enum qed_mcp_eee_mode {
-- 
2.25.1

