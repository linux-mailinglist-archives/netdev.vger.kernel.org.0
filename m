Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCF51B6F02
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgDXH2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:28:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46464 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726709AbgDXH2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:28:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O7QKUv021188;
        Fri, 24 Apr 2020 00:28:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=IXuZQIWScai6be6VB2ynryIrgDpPds0Tv1X5PF4cZTI=;
 b=yM2QbdCoI17aYmm3VtvLE0cQjwmk3Dd9YYfBNQ0V+keXRMOqdMzg+S47YzxPQEAoRpuv
 8tpG3LaQDbrwbP2bFaXYbK6nSMykrEnQMTEruPYD2I0ALAi/8hcwJ5aCeMZOJmAtiavQ
 aLsrCNgQ8eVoSdZYKTlY4W1f/Z48FmecpczawI6PIAZP/ru4RNwet7v/c5ThW/LF5wym
 X1IA4Fw33ppgehQWhSXPelVOi0wq3LhP0SHFFtBm2vyih5/8kOZNlnmfn6rHq/R5V3Z0
 o3DDtqXwSRYrx5gyMdUgWwcYL+MLH2G4ZW3Y2pI/pDIpSuv2yQYYs+p2ctbxCtApqwJg fQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsb47w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 00:28:04 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:28:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 00:28:02 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 5EF083F7040;
        Fri, 24 Apr 2020 00:28:00 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 09/17] net: atlantic: minimal A2 HW bindings required for fw_ops
Date:   Fri, 24 Apr 2020 10:27:21 +0300
Message-ID: <20200424072729.953-10-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200424072729.953-1-irusskikh@marvell.com>
References: <20200424072729.953-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_02:2020-04-23,2020-04-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch adds the bare minimum of A2 HW bindings required to
get fw_ops working.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/Makefile   |  1 +
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  1 +
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.c   | 56 +++++++++++++++++++
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.h   | 31 ++++++++++
 .../atlantic/hw_atl2/hw_atl2_llh_internal.h   | 48 ++++++++++++++++
 5 files changed, 137 insertions(+)
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h

diff --git a/drivers/net/ethernet/aquantia/atlantic/Makefile b/drivers/net/ethernet/aquantia/atlantic/Makefile
index 8b555665a33a..86824f1868ab 100644
--- a/drivers/net/ethernet/aquantia/atlantic/Makefile
+++ b/drivers/net/ethernet/aquantia/atlantic/Makefile
@@ -25,6 +25,7 @@ atlantic-objs := aq_main.o \
 	hw_atl/hw_atl_utils.o \
 	hw_atl/hw_atl_utils_fw2x.o \
 	hw_atl/hw_atl_llh.o \
+	hw_atl2/hw_atl2_llh.o \
 	macsec/macsec_api.o
 
 atlantic-$(CONFIG_MACSEC) += aq_macsec.o
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index f420ef40b627..e770d91e0876 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -172,6 +172,7 @@ struct aq_hw_s {
 	struct hw_atl_utils_fw_rpc rpc;
 	s64 ptp_clk_offset;
 	u16 phy_id;
+	void *priv;
 };
 
 struct aq_ring_s;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
new file mode 100644
index 000000000000..b6164bc5fffd
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Atlantic Network Driver
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#include "hw_atl2_llh.h"
+#include "hw_atl2_llh_internal.h"
+#include "aq_hw_utils.h"
+
+void hw_atl2_mif_shared_buf_get(struct aq_hw_s *aq_hw, int offset, u32 *data,
+				int len)
+{
+	int j = 0;
+	int i;
+
+	for (i = offset; i < offset + len; i++, j++)
+		data[j] = aq_hw_read_reg(aq_hw,
+					 HW_ATL2_MIF_SHARED_BUFFER_IN_ADR(i));
+}
+
+void hw_atl2_mif_shared_buf_write(struct aq_hw_s *aq_hw, int offset, u32 *data,
+				  int len)
+{
+	int j = 0;
+	int i;
+
+	for (i = offset; i < offset + len; i++, j++)
+		aq_hw_write_reg(aq_hw, HW_ATL2_MIF_SHARED_BUFFER_IN_ADR(i),
+				data[j]);
+}
+
+void hw_atl2_mif_shared_buf_read(struct aq_hw_s *aq_hw, int offset, u32 *data,
+				 int len)
+{
+	int j = 0;
+	int i;
+
+	for (i = offset; i < offset + len; i++, j++)
+		data[j] = aq_hw_read_reg(aq_hw,
+					 HW_ATL2_MIF_SHARED_BUFFER_OUT_ADR(i));
+}
+
+void hw_atl2_mif_host_finished_write_set(struct aq_hw_s *aq_hw, u32 finish)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL2_MIF_HOST_FINISHED_WRITE_ADR,
+			    HW_ATL2_MIF_HOST_FINISHED_WRITE_MSK,
+			    HW_ATL2_MIF_HOST_FINISHED_WRITE_SHIFT,
+			    finish);
+}
+
+u32 hw_atl2_mif_mcp_finished_read_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg_bit(aq_hw, HW_ATL2_MIF_MCP_FINISHED_READ_ADR,
+				  HW_ATL2_MIF_MCP_FINISHED_READ_MSK,
+				  HW_ATL2_MIF_MCP_FINISHED_READ_SHIFT);
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
new file mode 100644
index 000000000000..8ef8bd6b2534
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Atlantic Network Driver
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#ifndef HW_ATL2_LLH_H
+#define HW_ATL2_LLH_H
+
+#include <linux/types.h>
+
+struct aq_hw_s;
+
+/* get data from firmware shared input buffer */
+void hw_atl2_mif_shared_buf_get(struct aq_hw_s *aq_hw, int offset, u32 *data,
+				int len);
+
+/* set data into firmware shared input buffer */
+void hw_atl2_mif_shared_buf_write(struct aq_hw_s *aq_hw, int offset, u32 *data,
+				  int len);
+
+/* get data from firmware shared output buffer */
+void hw_atl2_mif_shared_buf_read(struct aq_hw_s *aq_hw, int offset, u32 *data,
+				 int len);
+
+/* set host finished write shared buffer indication */
+void hw_atl2_mif_host_finished_write_set(struct aq_hw_s *aq_hw, u32 finish);
+
+/* get mcp finished read shared buffer indication */
+u32 hw_atl2_mif_mcp_finished_read_get(struct aq_hw_s *aq_hw);
+
+#endif /* HW_ATL2_LLH_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
new file mode 100644
index 000000000000..835deb2d1950
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Atlantic Network Driver
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#ifndef HW_ATL2_LLH_INTERNAL_H
+#define HW_ATL2_LLH_INTERNAL_H
+
+/* Register address for firmware shared input buffer */
+#define HW_ATL2_MIF_SHARED_BUFFER_IN_ADR(dword) (0x00012000U + (dword) * 0x4U)
+/* Register address for firmware shared output buffer */
+#define HW_ATL2_MIF_SHARED_BUFFER_OUT_ADR(dword) (0x00013000U + (dword) * 0x4U)
+
+/* pif_host_finished_buf_wr_i Bitfield Definitions
+ * Preprocessor definitions for the bitfield "pif_host_finished_buf_wr_i".
+ * PORT="pif_host_finished_buf_wr_i"
+ */
+/* Register address for bitfield rpif_host_finished_buf_wr_i */
+#define HW_ATL2_MIF_HOST_FINISHED_WRITE_ADR 0x00000e00u
+/* Bitmask for bitfield pif_host_finished_buf_wr_i */
+#define HW_ATL2_MIF_HOST_FINISHED_WRITE_MSK 0x00000001u
+/* Inverted bitmask for bitfield pif_host_finished_buf_wr_i */
+#define HW_ATL2_MIF_HOST_FINISHED_WRITE_MSKN 0xFFFFFFFEu
+/* Lower bit position of bitfield pif_host_finished_buf_wr_i */
+#define HW_ATL2_MIF_HOST_FINISHED_WRITE_SHIFT 0
+/* Width of bitfield pif_host_finished_buf_wr_i */
+#define HW_ATL2_MIF_HOST_FINISHED_WRITE_WIDTH 1
+/* Default value of bitfield pif_host_finished_buf_wr_i */
+#define HW_ATL2_MIF_HOST_FINISHED_WRITE_DEFAULT 0x0
+
+/* pif_mcp_finished_buf_rd_i Bitfield Definitions
+ * Preprocessor definitions for the bitfield "pif_mcp_finished_buf_rd_i".
+ * PORT="pif_mcp_finished_buf_rd_i"
+ */
+/* Register address for bitfield pif_mcp_finished_buf_rd_i */
+#define HW_ATL2_MIF_MCP_FINISHED_READ_ADR 0x00000e04u
+/* Bitmask for bitfield pif_mcp_finished_buf_rd_i */
+#define HW_ATL2_MIF_MCP_FINISHED_READ_MSK 0x00000001u
+/* Inverted bitmask for bitfield pif_mcp_finished_buf_rd_i */
+#define HW_ATL2_MIF_MCP_FINISHED_READ_MSKN 0xFFFFFFFEu
+/* Lower bit position of bitfield pif_mcp_finished_buf_rd_i */
+#define HW_ATL2_MIF_MCP_FINISHED_READ_SHIFT 0
+/* Width of bitfield pif_mcp_finished_buf_rd_i */
+#define HW_ATL2_MIF_MCP_FINISHED_READ_WIDTH 1
+/* Default value of bitfield pif_mcp_finished_buf_rd_i */
+#define HW_ATL2_MIF_MCP_FINISHED_READ_DEFAULT 0x0
+
+#endif /* HW_ATL2_LLH_INTERNAL_H */
-- 
2.17.1

