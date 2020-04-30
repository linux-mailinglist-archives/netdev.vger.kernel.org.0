Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BB61BF20D
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbgD3IFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:05:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32260 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726808AbgD3IFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 04:05:36 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03U858dX011459;
        Thu, 30 Apr 2020 01:05:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=tRETlVKSkqe+5/A/KGos9VUKh2TjwToIJ69mS5eYVNY=;
 b=LgtVbSbirFUIEYOPVODwSrAfi/NTJk7ymbSi0r1h27rVwUy6ZvDof2x9VcWHdBapLKFE
 t/eWj6hJcJcL2akmWsXTGy9R7Mub59mpO63s9kLLG5UliwO++1LhMOve1qLjeXwToDtF
 l/ehX1+dlrXIJ5wIg3xOIxPxaOBfD/JSpdItAPu3BPrHAd67LrdwYPaJu60KCzGbfk7c
 UB3i1dFI9I5EHRRUbuTCH2PlnUWNusgyY6OAr7hpbxwVkxR10j72ahn3BtHqShLaNwHt
 ADQFXXcW8R5nLituagoqxhMVPcG7x7xHhqLrtdCo144XqS3HX1lCfEsmewvVjcZgmfUh pA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 30mjjqnsmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 01:05:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Apr
 2020 01:05:33 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Apr
 2020 01:05:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Apr 2020 01:05:32 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id CF06C3F703F;
        Thu, 30 Apr 2020 01:05:29 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "Egor Pomozov" <epomozov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "Nikita Danilov" <ndanilov@marvell.com>
Subject: [PATCH v2 net-next 14/17] net: atlantic: HW bindings for basic A2 init/deinit hw_ops
Date:   Thu, 30 Apr 2020 11:04:42 +0300
Message-ID: <20200430080445.1142-15-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430080445.1142-1-irusskikh@marvell.com>
References: <20200430080445.1142-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_02:2020-04-30,2020-04-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch adds A2 register definitions for basic A2 HW
initialization / deinitialization.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Co-developed-by: Egor Pomozov <epomozov@marvell.com>
Signed-off-by: Egor Pomozov <epomozov@marvell.com>
Co-developed-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Co-developed-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
---
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.c   |  70 ++++++++++++
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.h   |  29 +++++
 .../atlantic/hw_atl2/hw_atl2_llh_internal.h   | 108 ++++++++++++++++++
 3 files changed, 207 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
index 67f46a7bdcda..af176e1e5a18 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
@@ -58,6 +58,55 @@ void hw_atl2_rpf_vlan_flr_tag_set(struct aq_hw_s *aq_hw, u32 tag, u32 filter)
 			    tag);
 }
 
+/* TX */
+
+void hw_atl2_tpb_tx_buf_clk_gate_en_set(struct aq_hw_s *aq_hw, u32 clk_gate_en)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL2_TPB_TX_BUF_CLK_GATE_EN_ADR,
+			    HW_ATL2_TPB_TX_BUF_CLK_GATE_EN_MSK,
+			    HW_ATL2_TPB_TX_BUF_CLK_GATE_EN_SHIFT,
+			    clk_gate_en);
+}
+
+void hw_atl2_tps_tx_pkt_shed_tc_data_max_credit_set(struct aq_hw_s *aq_hw,
+						    u32 max_credit,
+						    u32 tc)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL2_TPS_DATA_TCTCREDIT_MAX_ADR(tc),
+			    HW_ATL2_TPS_DATA_TCTCREDIT_MAX_MSK,
+			    HW_ATL2_TPS_DATA_TCTCREDIT_MAX_SHIFT,
+			    max_credit);
+}
+
+void hw_atl2_tps_tx_pkt_shed_tc_data_weight_set(struct aq_hw_s *aq_hw,
+						u32 tx_pkt_shed_tc_data_weight,
+						u32 tc)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL2_TPS_DATA_TCTWEIGHT_ADR(tc),
+			    HW_ATL2_TPS_DATA_TCTWEIGHT_MSK,
+			    HW_ATL2_TPS_DATA_TCTWEIGHT_SHIFT,
+			    tx_pkt_shed_tc_data_weight);
+}
+
+u32 hw_atl2_get_hw_version(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg(aq_hw, HW_ATL2_FPGA_VER_ADR);
+}
+
+void hw_atl2_init_launchtime(struct aq_hw_s *aq_hw)
+{
+	u32 hw_ver = hw_atl2_get_hw_version(aq_hw);
+
+	aq_hw_write_reg_bit(aq_hw, HW_ATL2_LT_CTRL_ADR,
+			    HW_ATL2_LT_CTRL_CLK_RATIO_MSK,
+			    HW_ATL2_LT_CTRL_CLK_RATIO_SHIFT,
+			    hw_ver  < HW_ATL2_FPGA_VER_U32(1, 0, 0, 0) ?
+			    HW_ATL2_LT_CTRL_CLK_RATIO_FULL_SPEED :
+			    hw_ver >= HW_ATL2_FPGA_VER_U32(1, 0, 85, 2) ?
+			    HW_ATL2_LT_CTRL_CLK_RATIO_HALF_SPEED :
+			    HW_ATL2_LT_CTRL_CLK_RATIO_QUATER_SPEED);
+}
+
 /* set action resolver record */
 void hw_atl2_rpf_act_rslvr_record_set(struct aq_hw_s *aq_hw, u8 location,
 				      u32 tag, u32 mask, u32 action)
@@ -128,3 +177,24 @@ u32 hw_atl2_mif_mcp_finished_read_get(struct aq_hw_s *aq_hw)
 				  HW_ATL2_MIF_MCP_FINISHED_READ_MSK,
 				  HW_ATL2_MIF_MCP_FINISHED_READ_SHIFT);
 }
+
+u32 hw_atl2_mif_mcp_boot_reg_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg(aq_hw, HW_ATL2_MIF_BOOT_REG_ADR);
+}
+
+void hw_atl2_mif_mcp_boot_reg_set(struct aq_hw_s *aq_hw, u32 val)
+{
+	return aq_hw_write_reg(aq_hw, HW_ATL2_MIF_BOOT_REG_ADR, val);
+}
+
+u32 hw_atl2_mif_host_req_int_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg(aq_hw, HW_ATL2_MCP_HOST_REQ_INT_ADR);
+}
+
+void hw_atl2_mif_host_req_int_clr(struct aq_hw_s *aq_hw, u32 val)
+{
+	return aq_hw_write_reg(aq_hw, HW_ATL2_MCP_HOST_REQ_INT_CLR_ADR,
+			       val);
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
index bd5b0d5a8084..4acbbceb623f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
@@ -29,6 +29,23 @@ void hw_atl2_new_rpf_rss_redir_set(struct aq_hw_s *aq_hw, u32 tc, u32 index,
 /* Set VLAN filter tag */
 void hw_atl2_rpf_vlan_flr_tag_set(struct aq_hw_s *aq_hw, u32 tag, u32 filter);
 
+/* set tx buffer clock gate enable */
+void hw_atl2_tpb_tx_buf_clk_gate_en_set(struct aq_hw_s *aq_hw, u32 clk_gate_en);
+
+/* set tx packet scheduler tc data max credit */
+void hw_atl2_tps_tx_pkt_shed_tc_data_max_credit_set(struct aq_hw_s *aq_hw,
+						    u32 max_credit,
+						    u32 tc);
+
+/* set tx packet scheduler tc data weight */
+void hw_atl2_tps_tx_pkt_shed_tc_data_weight_set(struct aq_hw_s *aq_hw,
+						u32 tx_pkt_shed_tc_data_weight,
+						u32 tc);
+
+u32 hw_atl2_get_hw_version(struct aq_hw_s *aq_hw);
+
+void hw_atl2_init_launchtime(struct aq_hw_s *aq_hw);
+
 /* set action resolver record */
 void hw_atl2_rpf_act_rslvr_record_set(struct aq_hw_s *aq_hw, u8 location,
 				      u32 tag, u32 mask, u32 action);
@@ -54,4 +71,16 @@ void hw_atl2_mif_host_finished_write_set(struct aq_hw_s *aq_hw, u32 finish);
 /* get mcp finished read shared buffer indication */
 u32 hw_atl2_mif_mcp_finished_read_get(struct aq_hw_s *aq_hw);
 
+/* get mcp boot register */
+u32 hw_atl2_mif_mcp_boot_reg_get(struct aq_hw_s *aq_hw);
+
+/* set mcp boot register */
+void hw_atl2_mif_mcp_boot_reg_set(struct aq_hw_s *aq_hw, u32 val);
+
+/* get host interrupt request */
+u32 hw_atl2_mif_host_req_int_get(struct aq_hw_s *aq_hw);
+
+/* clear host interrupt request */
+void hw_atl2_mif_host_req_int_clr(struct aq_hw_s *aq_hw, u32 val);
+
 #endif /* HW_ATL2_LLH_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
index 886491b6ab73..14b78e090950 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
@@ -105,6 +105,105 @@
 /* default value of bitfield vlan_req_tag0{f}[3:0] */
 #define HW_ATL2_RPF_VL_TAG_DEFAULT 0x0
 
+/* RX rx_q{Q}_tc_map[2:0] Bitfield Definitions
+ * Preprocessor definitions for the bitfield "rx_q{Q}_tc_map[2:0]".
+ * Parameter: Queue {Q} | bit-level stride | range [0, 31]
+ * PORT="pif_rx_q0_tc_map_i[2:0]"
+ */
+
+/* Register address for bitfield rx_q{Q}_tc_map[2:0] */
+#define HW_ATL2_RX_Q_TC_MAP_ADR(queue) \
+	(((queue) < 32) ? 0x00005900 + ((queue) / 8) * 4 : 0)
+/* Lower bit position of bitfield rx_q{Q}_tc_map[2:0] */
+#define HW_ATL2_RX_Q_TC_MAP_SHIFT(queue) \
+	(((queue) < 32) ? ((queue) * 4) % 32 : 0)
+/* Width of bitfield rx_q{Q}_tc_map[2:0] */
+#define HW_ATL2_RX_Q_TC_MAP_WIDTH 3
+/* Default value of bitfield rx_q{Q}_tc_map[2:0] */
+#define HW_ATL2_RX_Q_TC_MAP_DEFAULT 0x0
+
+/* tx tx_buffer_clk_gate_en bitfield definitions
+ * preprocessor definitions for the bitfield "tx_buffer_clk_gate_en".
+ * port="pif_tpb_tx_buffer_clk_gate_en_i"
+ */
+
+/* register address for bitfield tx_buffer_clk_gate_en */
+#define HW_ATL2_TPB_TX_BUF_CLK_GATE_EN_ADR 0x00007900
+/* bitmask for bitfield tx_buffer_clk_gate_en */
+#define HW_ATL2_TPB_TX_BUF_CLK_GATE_EN_MSK 0x00000020
+/* inverted bitmask for bitfield tx_buffer_clk_gate_en */
+#define HW_ATL2_TPB_TX_BUF_CLK_GATE_EN_MSKN 0xffffffdf
+/* lower bit position of bitfield tx_buffer_clk_gate_en */
+#define HW_ATL2_TPB_TX_BUF_CLK_GATE_EN_SHIFT 5
+/* width of bitfield tx_buffer_clk_gate_en */
+#define HW_ATL2_TPB_TX_BUF_CLK_GATE_EN_WIDTH 1
+/* default value of bitfield tx_buffer_clk_gate_en */
+#define HW_ATL2_TPB_TX_BUF_CLK_GATE_EN_DEFAULT 0x0
+
+/* tx data_tc{t}_credit_max[b:0] bitfield definitions
+ * preprocessor definitions for the bitfield "data_tc{t}_credit_max[b:0]".
+ * parameter: tc {t} | stride size 0x4 | range [0, 7]
+ * port="pif_tps_data_tc0_credit_max_i[11:0]"
+ */
+
+/* register address for bitfield data_tc{t}_credit_max[b:0] */
+#define HW_ATL2_TPS_DATA_TCTCREDIT_MAX_ADR(tc) (0x00007110 + (tc) * 0x4)
+/* bitmask for bitfield data_tc{t}_credit_max[b:0] */
+#define HW_ATL2_TPS_DATA_TCTCREDIT_MAX_MSK 0x0fff0000
+/* inverted bitmask for bitfield data_tc{t}_credit_max[b:0] */
+#define HW_ATL2_TPS_DATA_TCTCREDIT_MAX_MSKN 0xf000ffff
+/* lower bit position of bitfield data_tc{t}_credit_max[b:0] */
+#define HW_ATL2_TPS_DATA_TCTCREDIT_MAX_SHIFT 16
+/* width of bitfield data_tc{t}_credit_max[b:0] */
+#define HW_ATL2_TPS_DATA_TCTCREDIT_MAX_WIDTH 12
+/* default value of bitfield data_tc{t}_credit_max[b:0] */
+#define HW_ATL2_TPS_DATA_TCTCREDIT_MAX_DEFAULT 0x0
+
+/* tx data_tc{t}_weight[8:0] bitfield definitions
+ * preprocessor definitions for the bitfield "data_tc{t}_weight[8:0]".
+ * parameter: tc {t} | stride size 0x4 | range [0, 7]
+ * port="pif_tps_data_tc0_weight_i[8:0]"
+ */
+
+/* register address for bitfield data_tc{t}_weight[8:0] */
+#define HW_ATL2_TPS_DATA_TCTWEIGHT_ADR(tc) (0x00007110 + (tc) * 0x4)
+/* bitmask for bitfield data_tc{t}_weight[8:0] */
+#define HW_ATL2_TPS_DATA_TCTWEIGHT_MSK 0x000001ff
+/* inverted bitmask for bitfield data_tc{t}_weight[8:0] */
+#define HW_ATL2_TPS_DATA_TCTWEIGHT_MSKN 0xfffffe00
+/* lower bit position of bitfield data_tc{t}_weight[8:0] */
+#define HW_ATL2_TPS_DATA_TCTWEIGHT_SHIFT 0
+/* width of bitfield data_tc{t}_weight[8:0] */
+#define HW_ATL2_TPS_DATA_TCTWEIGHT_WIDTH 9
+/* default value of bitfield data_tc{t}_weight[8:0] */
+#define HW_ATL2_TPS_DATA_TCTWEIGHT_DEFAULT 0x0
+
+/* Launch time control register */
+#define HW_ATL2_LT_CTRL_ADR 0x00007a1c
+
+#define HW_ATL2_LT_CTRL_AVB_LEN_CMP_TRSHLD_MSK 0xFFFF0000
+#define HW_ATL2_LT_CTRL_AVB_LEN_CMP_TRSHLD_SHIFT 16
+
+#define HW_ATL2_LT_CTRL_CLK_RATIO_MSK 0x0000FF00
+#define HW_ATL2_LT_CTRL_CLK_RATIO_SHIFT 8
+#define HW_ATL2_LT_CTRL_CLK_RATIO_QUATER_SPEED 4
+#define HW_ATL2_LT_CTRL_CLK_RATIO_HALF_SPEED 2
+#define HW_ATL2_LT_CTRL_CLK_RATIO_FULL_SPEED 1
+
+#define HW_ATL2_LT_CTRL_25G_MODE_SUPPORT_MSK 0x00000008
+#define HW_ATL2_LT_CTRL_25G_MODE_SUPPORT_SHIFT 3
+
+#define HW_ATL2_LT_CTRL_LINK_SPEED_MSK 0x00000007
+#define HW_ATL2_LT_CTRL_LINK_SPEED_SHIFT 0
+
+/* FPGA VER register */
+#define HW_ATL2_FPGA_VER_ADR 0x000000f4
+#define HW_ATL2_FPGA_VER_U32(mj, mi, bl, rv) \
+	((((mj) & 0xff) << 24) | \
+	 (((mi) & 0xff) << 16) | \
+	 (((bl) & 0xff) << 8) | \
+	 (((rv) & 0xff) << 0))
+
 /* ahb_mem_addr{f}[31:0] Bitfield Definitions
  * Preprocessor definitions for the bitfield "ahb_mem_addr{f}[31:0]".
  * Parameter: filter {f} | stride size 0x10 | range [0, 127]
@@ -209,4 +308,13 @@
 /* Default value of bitfield pif_mcp_finished_buf_rd_i */
 #define HW_ATL2_MIF_MCP_FINISHED_READ_DEFAULT 0x0
 
+/* Register address for bitfield pif_mcp_boot_reg */
+#define HW_ATL2_MIF_BOOT_REG_ADR 0x00003040u
+
+#define HW_ATL2_MCP_HOST_REQ_INT_READY BIT(0)
+
+#define HW_ATL2_MCP_HOST_REQ_INT_ADR 0x00000F00u
+#define HW_ATL2_MCP_HOST_REQ_INT_SET_ADR 0x00000F04u
+#define HW_ATL2_MCP_HOST_REQ_INT_CLR_ADR 0x00000F08u
+
 #endif /* HW_ATL2_LLH_INTERNAL_H */
-- 
2.20.1

