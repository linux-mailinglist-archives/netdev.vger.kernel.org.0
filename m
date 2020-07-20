Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A76A226DDE
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389276AbgGTSJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:09:34 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4788 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729662AbgGTSJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:09:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KHtqY1024232;
        Mon, 20 Jul 2020 11:09:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=0yWKcxs2rn5aJqrPqKEgYVyh1HYBtdMxQ9T4IhUe9Uo=;
 b=nVI8/P3uZzz61L/522dBJqLm3f6qrBhjETm8aSKOYdrWAwilhzgGcztXEK2bHBIJZH6J
 kmRmbCWAQIyEAlh+bdYxX+3GhBw5+BwOpr8cus8AUUO9VAPPjEq7SSydkuLaxJuH4OSE
 kOk5IJWlRQs+0IXduBn6oSfrYE3Mv11YWHbXSja1wjzOqYR9RhYqRxdK6Fzd0vjhz550
 Z+Eqaclp4d/7gilF50RKlOo2h4BXZxGhlzD/SN+k3MWJ7K94OVOdMATONvEO5y5wm3Rx
 wvAMCPcEKE2zETQ7jhJMM6fWSE49BDAL3yC+odfzoHm2GXb9fuOLno9flxmG0zWDC7iL uw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkf8x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:09:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:09:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:09:20 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id B98963F7043;
        Mon, 20 Jul 2020 11:09:15 -0700 (PDT)
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
Subject: [PATCH v3 net-next 07/16] qed: reformat several structures a bit
Date:   Mon, 20 Jul 2020 21:08:06 +0300
Message-ID: <20200720180815.107-8-alobakin@marvell.com>
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

Prior to adding new fields and bitfields, reformat the related
structures according to the Linux style (spaces to tabs,
lowercase hex, indentation etc.).

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_hsi.h | 256 +++++++++++-----------
 drivers/net/ethernet/qlogic/qed/qed_mcp.h |  85 ++++---
 include/linux/qed/qed_if.h                |  64 +++---
 3 files changed, 205 insertions(+), 200 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index ebc25b34e491..93d33c9cf145 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -11536,34 +11536,35 @@ typedef u32 offsize_t;		/* In DWORDS !!! */
 
 /* PHY configuration */
 struct eth_phy_cfg {
-	u32 speed;
-#define ETH_SPEED_AUTONEG	0
-#define ETH_SPEED_SMARTLINQ	0x8
-
-	u32 pause;
-#define ETH_PAUSE_NONE		0x0
-#define ETH_PAUSE_AUTONEG	0x1
-#define ETH_PAUSE_RX		0x2
-#define ETH_PAUSE_TX		0x4
-
-	u32 adv_speed;
-	u32 loopback_mode;
-#define ETH_LOOPBACK_NONE		(0)
-#define ETH_LOOPBACK_INT_PHY		(1)
-#define ETH_LOOPBACK_EXT_PHY		(2)
-#define ETH_LOOPBACK_EXT		(3)
-#define ETH_LOOPBACK_MAC		(4)
-
-	u32 eee_cfg;
+	u32					speed;
+#define ETH_SPEED_AUTONEG			0x0
+#define ETH_SPEED_SMARTLINQ			0x8
+
+	u32					pause;
+#define ETH_PAUSE_NONE				0x0
+#define ETH_PAUSE_AUTONEG			0x1
+#define ETH_PAUSE_RX				0x2
+#define ETH_PAUSE_TX				0x4
+
+	u32					adv_speed;
+
+	u32					loopback_mode;
+#define ETH_LOOPBACK_NONE			0x0
+#define ETH_LOOPBACK_INT_PHY			0x1
+#define ETH_LOOPBACK_EXT_PHY			0x2
+#define ETH_LOOPBACK_EXT			0x3
+#define ETH_LOOPBACK_MAC			0x4
+
+	u32					eee_cfg;
 #define EEE_CFG_EEE_ENABLED			BIT(0)
 #define EEE_CFG_TX_LPI				BIT(1)
 #define EEE_CFG_ADV_SPEED_1G			BIT(2)
 #define EEE_CFG_ADV_SPEED_10G			BIT(3)
-#define EEE_TX_TIMER_USEC_MASK			(0xfffffff0)
+#define EEE_TX_TIMER_USEC_MASK			0xfffffff0
 #define EEE_TX_TIMER_USEC_OFFSET		4
-#define EEE_TX_TIMER_USEC_BALANCED_TIME		(0xa00)
-#define EEE_TX_TIMER_USEC_AGGRESSIVE_TIME	(0x100)
-#define EEE_TX_TIMER_USEC_LATENCY_TIME		(0x6000)
+#define EEE_TX_TIMER_USEC_BALANCED_TIME		0xa00
+#define EEE_TX_TIMER_USEC_AGGRESSIVE_TIME	0x100
+#define EEE_TX_TIMER_USEC_LATENCY_TIME		0x6000
 
 	u32 feature_config_flags;
 #define ETH_EEE_MODE_ADV_LPI		(1 << 0)
@@ -11895,41 +11896,36 @@ struct public_path {
 };
 
 struct public_port {
-	u32 validity_map;
-
-	u32 link_status;
-#define LINK_STATUS_LINK_UP			0x00000001
-#define LINK_STATUS_SPEED_AND_DUPLEX_MASK	0x0000001e
-#define LINK_STATUS_SPEED_AND_DUPLEX_1000THD	(1 << 1)
-#define LINK_STATUS_SPEED_AND_DUPLEX_1000TFD	(2 << 1)
-#define LINK_STATUS_SPEED_AND_DUPLEX_10G	(3 << 1)
-#define LINK_STATUS_SPEED_AND_DUPLEX_20G	(4 << 1)
-#define LINK_STATUS_SPEED_AND_DUPLEX_40G	(5 << 1)
-#define LINK_STATUS_SPEED_AND_DUPLEX_50G	(6 << 1)
-#define LINK_STATUS_SPEED_AND_DUPLEX_100G	(7 << 1)
-#define LINK_STATUS_SPEED_AND_DUPLEX_25G	(8 << 1)
-
-#define LINK_STATUS_AUTO_NEGOTIATE_ENABLED	0x00000020
-
-#define LINK_STATUS_AUTO_NEGOTIATE_COMPLETE	0x00000040
-#define LINK_STATUS_PARALLEL_DETECTION_USED	0x00000080
-
+	u32						validity_map;
+
+	u32						link_status;
+#define LINK_STATUS_LINK_UP				0x00000001
+#define LINK_STATUS_SPEED_AND_DUPLEX_MASK		0x0000001e
+#define LINK_STATUS_SPEED_AND_DUPLEX_1000THD		(1 << 1)
+#define LINK_STATUS_SPEED_AND_DUPLEX_1000TFD		(2 << 1)
+#define LINK_STATUS_SPEED_AND_DUPLEX_10G		(3 << 1)
+#define LINK_STATUS_SPEED_AND_DUPLEX_20G		(4 << 1)
+#define LINK_STATUS_SPEED_AND_DUPLEX_40G		(5 << 1)
+#define LINK_STATUS_SPEED_AND_DUPLEX_50G		(6 << 1)
+#define LINK_STATUS_SPEED_AND_DUPLEX_100G		(7 << 1)
+#define LINK_STATUS_SPEED_AND_DUPLEX_25G		(8 << 1)
+#define LINK_STATUS_AUTO_NEGOTIATE_ENABLED		0x00000020
+#define LINK_STATUS_AUTO_NEGOTIATE_COMPLETE		0x00000040
+#define LINK_STATUS_PARALLEL_DETECTION_USED		0x00000080
 #define LINK_STATUS_PFC_ENABLED				0x00000100
-#define LINK_STATUS_LINK_PARTNER_1000TFD_CAPABLE 0x00000200
-#define LINK_STATUS_LINK_PARTNER_1000THD_CAPABLE 0x00000400
+#define LINK_STATUS_LINK_PARTNER_1000TFD_CAPABLE	0x00000200
+#define LINK_STATUS_LINK_PARTNER_1000THD_CAPABLE	0x00000400
 #define LINK_STATUS_LINK_PARTNER_10G_CAPABLE		0x00000800
 #define LINK_STATUS_LINK_PARTNER_20G_CAPABLE		0x00001000
 #define LINK_STATUS_LINK_PARTNER_40G_CAPABLE		0x00002000
 #define LINK_STATUS_LINK_PARTNER_50G_CAPABLE		0x00004000
 #define LINK_STATUS_LINK_PARTNER_100G_CAPABLE		0x00008000
 #define LINK_STATUS_LINK_PARTNER_25G_CAPABLE		0x00010000
-
-#define LINK_STATUS_LINK_PARTNER_FLOW_CONTROL_MASK	0x000C0000
+#define LINK_STATUS_LINK_PARTNER_FLOW_CONTROL_MASK	0x000c0000
 #define LINK_STATUS_LINK_PARTNER_NOT_PAUSE_CAPABLE	(0 << 18)
 #define LINK_STATUS_LINK_PARTNER_SYMMETRIC_PAUSE	(1 << 18)
 #define LINK_STATUS_LINK_PARTNER_ASYMMETRIC_PAUSE	(2 << 18)
 #define LINK_STATUS_LINK_PARTNER_BOTH_PAUSE		(3 << 18)
-
 #define LINK_STATUS_SFP_TX_FAULT			0x00100000
 #define LINK_STATUS_TX_FLOW_CONTROL_ENABLED		0x00200000
 #define LINK_STATUS_RX_FLOW_CONTROL_ENABLED		0x00400000
@@ -12630,49 +12626,49 @@ struct public_drv_mb {
 
 #define FW_MSG_CODE_MDUMP_INVALID_CMD		0x00030000
 
-	u32 fw_mb_param;
-#define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MAJOR_MASK	0xFFFF0000
+	u32						fw_mb_param;
+#define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MAJOR_MASK	0xffff0000
 #define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MAJOR_SHIFT	16
-#define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MINOR_MASK	0x0000FFFF
+#define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MINOR_MASK	0x0000ffff
 #define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MINOR_SHIFT	0
 
-	/* get pf rdma protocol command responce */
-#define FW_MB_PARAM_GET_PF_RDMA_NONE		0x0
-#define FW_MB_PARAM_GET_PF_RDMA_ROCE		0x1
-#define FW_MB_PARAM_GET_PF_RDMA_IWARP		0x2
-#define FW_MB_PARAM_GET_PF_RDMA_BOTH		0x3
+	/* Get PF RDMA protocol command response */
+#define FW_MB_PARAM_GET_PF_RDMA_NONE			0x0
+#define FW_MB_PARAM_GET_PF_RDMA_ROCE			0x1
+#define FW_MB_PARAM_GET_PF_RDMA_IWARP			0x2
+#define FW_MB_PARAM_GET_PF_RDMA_BOTH			0x3
 
-/* get MFW feature support response */
-#define FW_MB_PARAM_FEATURE_SUPPORT_SMARTLINQ	0x00000001
-#define FW_MB_PARAM_FEATURE_SUPPORT_EEE		0x00000002
-#define FW_MB_PARAM_FEATURE_SUPPORT_VLINK	0x00010000
+	/* Get MFW feature support response */
+#define FW_MB_PARAM_FEATURE_SUPPORT_SMARTLINQ		0x00000001
+#define FW_MB_PARAM_FEATURE_SUPPORT_EEE			0x00000002
+#define FW_MB_PARAM_FEATURE_SUPPORT_VLINK		0x00010000
 
-#define FW_MB_PARAM_LOAD_DONE_DID_EFUSE_ERROR	(1 << 0)
+#define FW_MB_PARAM_LOAD_DONE_DID_EFUSE_ERROR		BIT(0)
 
-#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALID_MASK   0x00000001
-#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALID_SHIFT 0
-#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALUE_MASK   0x00000002
-#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALUE_SHIFT 1
-#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALID_MASK    0x00000004
-#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALID_SHIFT  2
-#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALUE_MASK    0x00000008
-#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALUE_SHIFT  3
+#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALID_MASK	0x00000001
+#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALID_SHIFT	0
+#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALUE_MASK	0x00000002
+#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALUE_SHIFT	1
+#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALID_MASK		0x00000004
+#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALID_SHIFT	2
+#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALUE_MASK		0x00000008
+#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALUE_SHIFT	3
 
-#define FW_MB_PARAM_PPFID_BITMAP_MASK	0xFF
-#define FW_MB_PARAM_PPFID_BITMAP_SHIFT	0
+#define FW_MB_PARAM_PPFID_BITMAP_MASK			0xff
+#define FW_MB_PARAM_PPFID_BITMAP_SHIFT			0
 
-	u32 drv_pulse_mb;
-#define DRV_PULSE_SEQ_MASK			0x00007fff
-#define DRV_PULSE_SYSTEM_TIME_MASK		0xffff0000
-#define DRV_PULSE_ALWAYS_ALIVE			0x00008000
+	u32						drv_pulse_mb;
+#define DRV_PULSE_SEQ_MASK				0x00007fff
+#define DRV_PULSE_SYSTEM_TIME_MASK			0xffff0000
+#define DRV_PULSE_ALWAYS_ALIVE				0x00008000
 
-	u32 mcp_pulse_mb;
-#define MCP_PULSE_SEQ_MASK			0x00007fff
-#define MCP_PULSE_ALWAYS_ALIVE			0x00008000
-#define MCP_EVENT_MASK				0xffff0000
-#define MCP_EVENT_OTHER_DRIVER_RESET_REQ	0x00010000
+	u32						mcp_pulse_mb;
+#define MCP_PULSE_SEQ_MASK				0x00007fff
+#define MCP_PULSE_ALWAYS_ALIVE				0x00008000
+#define MCP_EVENT_MASK					0xffff0000
+#define MCP_EVENT_OTHER_DRIVER_RESET_REQ		0x00010000
 
-	union drv_union_data union_data;
+	union drv_union_data				union_data;
 };
 
 #define FW_MB_PARAM_NVM_PUT_FILE_REQ_OFFSET_MASK	0x00ffffff
@@ -13048,24 +13044,27 @@ struct nvm_cfg1_path {
 };
 
 struct nvm_cfg1_port {
-	u32 reserved__m_relocated_to_option_123;
-	u32 reserved__m_relocated_to_option_124;
-	u32 generic_cont0;
-#define NVM_CFG1_PORT_DCBX_MODE_MASK				0x000F0000
+	u32							rel_to_opt123;
+	u32							rel_to_opt124;
+
+	u32							generic_cont0;
+#define NVM_CFG1_PORT_DCBX_MODE_MASK				0x000f0000
 #define NVM_CFG1_PORT_DCBX_MODE_OFFSET				16
 #define NVM_CFG1_PORT_DCBX_MODE_DISABLED			0x0
 #define NVM_CFG1_PORT_DCBX_MODE_IEEE				0x1
 #define NVM_CFG1_PORT_DCBX_MODE_CEE				0x2
 #define NVM_CFG1_PORT_DCBX_MODE_DYNAMIC				0x3
-#define NVM_CFG1_PORT_DEFAULT_ENABLED_PROTOCOLS_MASK		0x00F00000
+#define NVM_CFG1_PORT_DEFAULT_ENABLED_PROTOCOLS_MASK		0x00f00000
 #define NVM_CFG1_PORT_DEFAULT_ENABLED_PROTOCOLS_OFFSET		20
 #define NVM_CFG1_PORT_DEFAULT_ENABLED_PROTOCOLS_ETHERNET	0x1
 #define NVM_CFG1_PORT_DEFAULT_ENABLED_PROTOCOLS_FCOE		0x2
 #define NVM_CFG1_PORT_DEFAULT_ENABLED_PROTOCOLS_ISCSI		0x4
-	u32 pcie_cfg;
-	u32 features;
-	u32 speed_cap_mask;
-#define NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_MASK		0x0000FFFF
+
+	u32							pcie_cfg;
+	u32							features;
+
+	u32							speed_cap_mask;
+#define NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_MASK		0x0000ffff
 #define NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_OFFSET		0
 #define NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G		0x1
 #define NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G		0x2
@@ -13074,8 +13073,9 @@ struct nvm_cfg1_port {
 #define NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G		0x10
 #define NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_50G		0x20
 #define NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_BB_100G		0x40
-	u32 link_settings;
-#define NVM_CFG1_PORT_DRV_LINK_SPEED_MASK			0x0000000F
+
+	u32							link_settings;
+#define NVM_CFG1_PORT_DRV_LINK_SPEED_MASK			0x0000000f
 #define NVM_CFG1_PORT_DRV_LINK_SPEED_OFFSET			0
 #define NVM_CFG1_PORT_DRV_LINK_SPEED_AUTONEG			0x0
 #define NVM_CFG1_PORT_DRV_LINK_SPEED_1G				0x1
@@ -13091,49 +13091,53 @@ struct nvm_cfg1_port {
 #define NVM_CFG1_PORT_DRV_FLOW_CONTROL_AUTONEG			0x1
 #define NVM_CFG1_PORT_DRV_FLOW_CONTROL_RX			0x2
 #define NVM_CFG1_PORT_DRV_FLOW_CONTROL_TX			0x4
-	u32 phy_cfg;
-	u32 mgmt_traffic;
 
-	u32 ext_phy;
+	u32							phy_cfg;
+	u32							mgmt_traffic;
+
+	u32							ext_phy;
 	/* EEE power saving mode */
-#define NVM_CFG1_PORT_EEE_POWER_SAVING_MODE_MASK		0x00FF0000
+#define NVM_CFG1_PORT_EEE_POWER_SAVING_MODE_MASK		0x00ff0000
 #define NVM_CFG1_PORT_EEE_POWER_SAVING_MODE_OFFSET		16
 #define NVM_CFG1_PORT_EEE_POWER_SAVING_MODE_DISABLED		0x0
 #define NVM_CFG1_PORT_EEE_POWER_SAVING_MODE_BALANCED		0x1
 #define NVM_CFG1_PORT_EEE_POWER_SAVING_MODE_AGGRESSIVE		0x2
 #define NVM_CFG1_PORT_EEE_POWER_SAVING_MODE_LOW_LATENCY		0x3
 
-	u32 mba_cfg1;
-	u32 mba_cfg2;
-	u32 vf_cfg;
-	struct nvm_cfg_mac_address lldp_mac_address;
-	u32 led_port_settings;
-	u32 transceiver_00;
-	u32 device_ids;
-	u32 board_cfg;
-#define NVM_CFG1_PORT_PORT_TYPE_MASK                            0x000000FF
-#define NVM_CFG1_PORT_PORT_TYPE_OFFSET                          0
-#define NVM_CFG1_PORT_PORT_TYPE_UNDEFINED                       0x0
-#define NVM_CFG1_PORT_PORT_TYPE_MODULE                          0x1
-#define NVM_CFG1_PORT_PORT_TYPE_BACKPLANE                       0x2
-#define NVM_CFG1_PORT_PORT_TYPE_EXT_PHY                         0x3
-#define NVM_CFG1_PORT_PORT_TYPE_MODULE_SLAVE                    0x4
-	u32 mnm_10g_cap;
-	u32 mnm_10g_ctrl;
-	u32 mnm_10g_misc;
-	u32 mnm_25g_cap;
-	u32 mnm_25g_ctrl;
-	u32 mnm_25g_misc;
-	u32 mnm_40g_cap;
-	u32 mnm_40g_ctrl;
-	u32 mnm_40g_misc;
-	u32 mnm_50g_cap;
-	u32 mnm_50g_ctrl;
-	u32 mnm_50g_misc;
-	u32 mnm_100g_cap;
-	u32 mnm_100g_ctrl;
-	u32 mnm_100g_misc;
-	u32 reserved[116];
+	u32							mba_cfg1;
+	u32							mba_cfg2;
+	u32							vf_cfg;
+	struct nvm_cfg_mac_address				lldp_mac_address;
+	u32							led_port_settings;
+	u32							transceiver_00;
+	u32							device_ids;
+
+	u32							board_cfg;
+#define NVM_CFG1_PORT_PORT_TYPE_MASK				0x000000ff
+#define NVM_CFG1_PORT_PORT_TYPE_OFFSET				0
+#define NVM_CFG1_PORT_PORT_TYPE_UNDEFINED			0x0
+#define NVM_CFG1_PORT_PORT_TYPE_MODULE				0x1
+#define NVM_CFG1_PORT_PORT_TYPE_BACKPLANE			0x2
+#define NVM_CFG1_PORT_PORT_TYPE_EXT_PHY				0x3
+#define NVM_CFG1_PORT_PORT_TYPE_MODULE_SLAVE			0x4
+
+	u32							mnm_10g_cap;
+	u32							mnm_10g_ctrl;
+	u32							mnm_10g_misc;
+	u32							mnm_25g_cap;
+	u32							mnm_25g_ctrl;
+	u32							mnm_25g_misc;
+	u32							mnm_40g_cap;
+	u32							mnm_40g_ctrl;
+	u32							mnm_40g_misc;
+	u32							mnm_50g_cap;
+	u32							mnm_50g_ctrl;
+	u32							mnm_50g_misc;
+	u32							mnm_100g_cap;
+	u32							mnm_100g_ctrl;
+	u32							mnm_100g_misc;
+
+	u32							reserved[116];
 };
 
 struct nvm_cfg1_func {
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index 63a22a615e94..cf678b6966f8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -34,61 +34,60 @@ enum qed_mcp_eee_mode {
 };
 
 struct qed_mcp_link_params {
-	struct qed_mcp_link_speed_params speed;
-	struct qed_mcp_link_pause_params pause;
-	u32 loopback_mode;
-	struct qed_link_eee_params eee;
+	struct qed_mcp_link_speed_params	speed;
+	struct qed_mcp_link_pause_params	pause;
+	u32					loopback_mode;
+	struct qed_link_eee_params		eee;
 };
 
 struct qed_mcp_link_capabilities {
-	u32 speed_capabilities;
-	bool default_speed_autoneg;
-	enum qed_mcp_eee_mode default_eee;
-	u32 eee_lpi_timer;
-	u8 eee_speed_caps;
+	u32					speed_capabilities;
+	bool					default_speed_autoneg;
+	enum qed_mcp_eee_mode			default_eee;
+	u32					eee_lpi_timer;
+	u8					eee_speed_caps;
 };
 
 struct qed_mcp_link_state {
-	bool    link_up;
-
-	u32	min_pf_rate;
+	bool					link_up;
+	u32					min_pf_rate;
 
 	/* Actual link speed in Mb/s */
-	u32	line_speed;
+	u32					line_speed;
 
 	/* PF max speed in Mb/s, deduced from line_speed
 	 * according to PF max bandwidth configuration.
 	 */
-	u32     speed;
-	bool    full_duplex;
-
-	bool    an;
-	bool    an_complete;
-	bool    parallel_detection;
-	bool    pfc_enabled;
-
-#define QED_LINK_PARTNER_SPEED_1G_HD    BIT(0)
-#define QED_LINK_PARTNER_SPEED_1G_FD    BIT(1)
-#define QED_LINK_PARTNER_SPEED_10G      BIT(2)
-#define QED_LINK_PARTNER_SPEED_20G      BIT(3)
-#define QED_LINK_PARTNER_SPEED_25G      BIT(4)
-#define QED_LINK_PARTNER_SPEED_40G      BIT(5)
-#define QED_LINK_PARTNER_SPEED_50G      BIT(6)
-#define QED_LINK_PARTNER_SPEED_100G     BIT(7)
-	u32     partner_adv_speed;
-
-	bool    partner_tx_flow_ctrl_en;
-	bool    partner_rx_flow_ctrl_en;
-
-#define QED_LINK_PARTNER_SYMMETRIC_PAUSE (1)
-#define QED_LINK_PARTNER_ASYMMETRIC_PAUSE (2)
-#define QED_LINK_PARTNER_BOTH_PAUSE (3)
-	u8      partner_adv_pause;
-
-	bool    sfp_tx_fault;
-	bool    eee_active;
-	u8      eee_adv_caps;
-	u8      eee_lp_adv_caps;
+	u32					speed;
+
+	bool					full_duplex;
+	bool					an;
+	bool					an_complete;
+	bool					parallel_detection;
+	bool					pfc_enabled;
+
+	u32					partner_adv_speed;
+#define QED_LINK_PARTNER_SPEED_1G_HD		BIT(0)
+#define QED_LINK_PARTNER_SPEED_1G_FD		BIT(1)
+#define QED_LINK_PARTNER_SPEED_10G		BIT(2)
+#define QED_LINK_PARTNER_SPEED_20G		BIT(3)
+#define QED_LINK_PARTNER_SPEED_25G		BIT(4)
+#define QED_LINK_PARTNER_SPEED_40G		BIT(5)
+#define QED_LINK_PARTNER_SPEED_50G		BIT(6)
+#define QED_LINK_PARTNER_SPEED_100G		BIT(7)
+
+	bool					partner_tx_flow_ctrl_en;
+	bool					partner_rx_flow_ctrl_en;
+
+	u8					partner_adv_pause;
+#define QED_LINK_PARTNER_SYMMETRIC_PAUSE	0x1
+#define QED_LINK_PARTNER_ASYMMETRIC_PAUSE	0x2
+#define QED_LINK_PARTNER_BOTH_PAUSE		0x3
+
+	bool					sfp_tx_fault;
+	bool					eee_active;
+	u8					eee_adv_caps;
+	u8					eee_lp_adv_caps;
 };
 
 struct qed_mcp_function_info {
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index f82db1b92d45..dde48f206d0d 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -662,51 +662,53 @@ enum qed_protocol {
 };
 
 struct qed_link_params {
-	bool	link_up;
+	bool					link_up;
 
-#define QED_LINK_OVERRIDE_SPEED_AUTONEG         BIT(0)
-#define QED_LINK_OVERRIDE_SPEED_ADV_SPEEDS      BIT(1)
-#define QED_LINK_OVERRIDE_SPEED_FORCED_SPEED    BIT(2)
-#define QED_LINK_OVERRIDE_PAUSE_CONFIG          BIT(3)
-#define QED_LINK_OVERRIDE_LOOPBACK_MODE         BIT(4)
-#define QED_LINK_OVERRIDE_EEE_CONFIG            BIT(5)
-	u32	override_flags;
-	bool	autoneg;
+	u32					override_flags;
+#define QED_LINK_OVERRIDE_SPEED_AUTONEG		BIT(0)
+#define QED_LINK_OVERRIDE_SPEED_ADV_SPEEDS	BIT(1)
+#define QED_LINK_OVERRIDE_SPEED_FORCED_SPEED	BIT(2)
+#define QED_LINK_OVERRIDE_PAUSE_CONFIG		BIT(3)
+#define QED_LINK_OVERRIDE_LOOPBACK_MODE		BIT(4)
+#define QED_LINK_OVERRIDE_EEE_CONFIG		BIT(5)
 
+	bool					autoneg;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_speeds);
+	u32					forced_speed;
 
-	u32	forced_speed;
-#define QED_LINK_PAUSE_AUTONEG_ENABLE           BIT(0)
-#define QED_LINK_PAUSE_RX_ENABLE                BIT(1)
-#define QED_LINK_PAUSE_TX_ENABLE                BIT(2)
-	u32	pause_config;
-#define QED_LINK_LOOPBACK_NONE                  BIT(0)
-#define QED_LINK_LOOPBACK_INT_PHY               BIT(1)
-#define QED_LINK_LOOPBACK_EXT_PHY               BIT(2)
-#define QED_LINK_LOOPBACK_EXT                   BIT(3)
-#define QED_LINK_LOOPBACK_MAC                   BIT(4)
-	u32	loopback_mode;
-	struct qed_link_eee_params eee;
+	u32					pause_config;
+#define QED_LINK_PAUSE_AUTONEG_ENABLE		BIT(0)
+#define QED_LINK_PAUSE_RX_ENABLE		BIT(1)
+#define QED_LINK_PAUSE_TX_ENABLE		BIT(2)
+
+	u32					loopback_mode;
+#define QED_LINK_LOOPBACK_NONE			BIT(0)
+#define QED_LINK_LOOPBACK_INT_PHY		BIT(1)
+#define QED_LINK_LOOPBACK_EXT_PHY		BIT(2)
+#define QED_LINK_LOOPBACK_EXT			BIT(3)
+#define QED_LINK_LOOPBACK_MAC			BIT(4)
+
+	struct qed_link_eee_params		eee;
 };
 
 struct qed_link_output {
-	bool	link_up;
+	bool					link_up;
 
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported_caps);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertised_caps);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_caps);
 
-	u32	speed;                  /* In Mb/s */
-	u8	duplex;                 /* In DUPLEX defs */
-	u8	port;                   /* In PORT defs */
-	bool	autoneg;
-	u32	pause_config;
+	u32					speed;	   /* In Mb/s */
+	u8					duplex;	   /* In DUPLEX defs */
+	u8					port;	   /* In PORT defs */
+	bool					autoneg;
+	u32					pause_config;
 
 	/* EEE - capability & param */
-	bool eee_supported;
-	bool eee_active;
-	u8 sup_caps;
-	struct qed_link_eee_params eee;
+	bool					eee_supported;
+	bool					eee_active;
+	u8					sup_caps;
+	struct qed_link_eee_params		eee;
 };
 
 struct qed_probe_params {
-- 
2.25.1

