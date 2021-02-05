Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED7D311891
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhBFClG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:41:06 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2706 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231299AbhBFChM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:37:12 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 115MfcQM031924;
        Fri, 5 Feb 2021 14:52:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ZaZkecJKxNpzWEEBJda2pqskAKLc1zpJBajeov5J00I=;
 b=VVtGqMbucR/8sgUTdDpJJsw57kYjLESc2ZvtjAzXAxeOkLFVkY2O0Zhoa3FhgzjLbJyA
 U12T0vyWrOOwZxGXLg2DZol0dkKimZJOJpMl5t6T7bmXGmXtzupQ5/FCzrA1Xl4zWt/l
 syq74puLDlPP0/Ot0lE8GjaKIXJVL/D+hdAXACfuYk6CBtwM8IGDPOp9iNGxC0OOJ0fd
 4g2E5+KWbvttVwBwySbJroj6QGjy4YirhGvjZRrwAqCYcB8VGam3xalR81N/pXD0WWcw
 YQnuaPe3tMo1QvKoNIAOXNMB6M2+d2rBQyMfcZqZNYnU2FyE00CWG8acU6my6DfaYv+S 0Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36gg1t5mvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 14:52:10 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Feb
 2021 14:52:09 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Feb
 2021 14:52:09 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 5 Feb 2021 14:52:08 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 903793F704A;
        Fri,  5 Feb 2021 14:52:04 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <jerinj@marvell.com>,
        <lcherian@marvell.com>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <schalla@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
Subject: [net-next v4 12/14] octeontx2-af: cn10k: Add RPM LMAC pause frame support
Date:   Sat, 6 Feb 2021 04:20:11 +0530
Message-ID: <20210205225013.15961-13-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210205225013.15961-1-gakula@marvell.com>
References: <20210205225013.15961-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-05_13:2021-02-05,2021-02-05 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Babu <rsaladi2@marvell.com>

Flow control configuration is different for CGX(Octeontx2)
and RPM(CN10K) functional blocks. This patch adds the necessary
changes for RPM to support 802.3 pause frames configuration on
cn10k platforms.

Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  27 ++---
 .../ethernet/marvell/octeontx2/af/lmac_common.h    |  18 +++
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    | 134 +++++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |  18 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  19 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   8 +-
 6 files changed, 201 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index be039a8..9a343fd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -306,9 +306,6 @@ void cgx_lmac_enadis_rx_pause_fwding(void *cgxd, int lmac_id, bool enable)
 	struct cgx *cgx = cgxd;
 	u64 cfg;
 
-	if (is_dev_rpm(cgx))
-		return;
-
 	if (!cgx)
 		return;
 
@@ -397,8 +394,8 @@ int cgx_lmac_tx_enable(void *cgxd, int lmac_id, bool enable)
 	return !!(last & DATA_PKT_TX_EN);
 }
 
-int cgx_lmac_get_pause_frm(void *cgxd, int lmac_id,
-			   u8 *tx_pause, u8 *rx_pause)
+static int cgx_lmac_get_pause_frm_status(void *cgxd, int lmac_id,
+					 u8 *tx_pause, u8 *rx_pause)
 {
 	struct cgx *cgx = cgxd;
 	u64 cfg;
@@ -417,8 +414,8 @@ int cgx_lmac_get_pause_frm(void *cgxd, int lmac_id,
 	return 0;
 }
 
-int cgx_lmac_set_pause_frm(void *cgxd, int lmac_id,
-			   u8 tx_pause, u8 rx_pause)
+static int cgx_lmac_enadis_pause_frm(void *cgxd, int lmac_id,
+				     u8 tx_pause, u8 rx_pause)
 {
 	struct cgx *cgx = cgxd;
 	u64 cfg;
@@ -450,13 +447,11 @@ int cgx_lmac_set_pause_frm(void *cgxd, int lmac_id,
 	return 0;
 }
 
-static void cgx_lmac_pause_frm_config(struct cgx *cgx, int lmac_id, bool enable)
+static void cgx_lmac_pause_frm_config(void *cgxd, int lmac_id, bool enable)
 {
+	struct cgx *cgx = cgxd;
 	u64 cfg;
 
-	if (is_dev_rpm(cgx))
-		return;
-
 	if (!is_lmac_valid(cgx, lmac_id))
 		return;
 	if (enable) {
@@ -996,7 +991,7 @@ static int cgx_lmac_init(struct cgx *cgx)
 
 		/* Add reference */
 		cgx->lmac_idmap[lmac->lmac_id] = lmac;
-		cgx_lmac_pause_frm_config(cgx, lmac->lmac_id, true);
+		cgx->mac_ops->mac_pause_frm_config(cgx, lmac->lmac_id, true);
 		set_bit(lmac->lmac_id, &cgx->lmac_bmap);
 	}
 
@@ -1025,7 +1020,7 @@ static int cgx_lmac_exit(struct cgx *cgx)
 		lmac = cgx->lmac_idmap[i];
 		if (!lmac)
 			continue;
-		cgx_lmac_pause_frm_config(cgx, lmac->lmac_id, false);
+		cgx->mac_ops->mac_pause_frm_config(cgx, lmac->lmac_id, false);
 		cgx_configure_interrupt(cgx, lmac, lmac->lmac_id, true);
 		kfree(lmac->name);
 		kfree(lmac);
@@ -1037,7 +1032,7 @@ static int cgx_lmac_exit(struct cgx *cgx)
 static void cgx_populate_features(struct cgx *cgx)
 {
 	if (is_dev_rpm(cgx))
-		cgx->hw_features =  RVU_MAC_RPM;
+		cgx->hw_features =  (RVU_MAC_RPM | RVU_LMAC_FEAT_FC);
 	else
 		cgx->hw_features = (RVU_LMAC_FEAT_FC | RVU_LMAC_FEAT_PTP);
 }
@@ -1053,6 +1048,10 @@ struct mac_ops	cgx_mac_ops    = {
 	.lmac_fwi	=	CGX_LMAC_FWI,
 	.non_contiguous_serdes_lane = false,
 	.get_nr_lmacs	=	cgx_get_nr_lmacs,
+	.mac_enadis_rx_pause_fwding =	cgx_lmac_enadis_rx_pause_fwding,
+	.mac_get_pause_frm_status =	cgx_lmac_get_pause_frm_status,
+	.mac_enadis_pause_frm =		cgx_lmac_enadis_pause_frm,
+	.mac_pause_frm_config =		cgx_lmac_pause_frm_config,
 };
 
 static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index 9c5a9c5..b4eb337 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -67,6 +67,24 @@ struct mac_ops {
 	 * number of setbits in lmac_exist tells number of lmacs
 	 */
 	int			(*get_nr_lmacs)(void *cgx);
+
+	/* Enable LMAC Pause Frame Configuration */
+	void			(*mac_enadis_rx_pause_fwding)(void *cgxd,
+							      int lmac_id,
+							      bool enable);
+	int			(*mac_get_pause_frm_status)(void *cgxd,
+							    int lmac_id,
+							    u8 *tx_pause,
+							    u8 *rx_pause);
+
+	int			(*mac_enadis_pause_frm)(void *cgxd,
+							int lmac_id,
+							u8 tx_pause,
+							u8 rx_pause);
+	void			(*mac_pause_frm_config)(void  *cgxd,
+							int lmac_id,
+							bool enable);
+
 };
 
 struct cgx {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index e97baee..8a4241a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -19,6 +19,10 @@ static struct mac_ops	rpm_mac_ops   = {
 	.lmac_fwi	=	RPM_LMAC_FWI,
 	.non_contiguous_serdes_lane = true,
 	.get_nr_lmacs	=	rpm_get_nr_lmacs,
+	.mac_enadis_rx_pause_fwding =	rpm_lmac_enadis_rx_pause_fwding,
+	.mac_get_pause_frm_status =	rpm_lmac_get_pause_frm_status,
+	.mac_enadis_pause_frm =		rpm_lmac_enadis_pause_frm,
+	.mac_pause_frm_config =		rpm_lmac_pause_frm_config,
 };
 
 struct mac_ops *rpm_get_mac_ops(void)
@@ -26,6 +30,11 @@ struct mac_ops *rpm_get_mac_ops(void)
 	return &rpm_mac_ops;
 }
 
+static void rpm_write(rpm_t *rpm, u64 lmac, u64 offset, u64 val)
+{
+	cgx_write(rpm, lmac, offset, val);
+}
+
 static u64 rpm_read(rpm_t *rpm, u64 lmac, u64 offset)
 {
 	return	cgx_read(rpm, lmac, offset);
@@ -37,3 +46,128 @@ int rpm_get_nr_lmacs(void *rpmd)
 
 	return hweight8(rpm_read(rpm, 0, CGXX_CMRX_RX_LMACS) & 0xFULL);
 }
+
+void rpm_lmac_enadis_rx_pause_fwding(void *rpmd, int lmac_id, bool enable)
+{
+	struct cgx *rpm = rpmd;
+	u64 cfg;
+
+	if (!rpm)
+		return;
+
+	if (enable) {
+		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+		cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE;
+		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+	} else {
+		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+		cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE;
+		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+	}
+}
+
+int rpm_lmac_get_pause_frm_status(void *rpmd, int lmac_id,
+				  u8 *tx_pause, u8 *rx_pause)
+{
+	rpm_t *rpm = rpmd;
+	u64 cfg;
+
+	if (!is_lmac_valid(rpm, lmac_id))
+		return -ENODEV;
+
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	*rx_pause = !(cfg & RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE);
+
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	*tx_pause = !(cfg & RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE);
+	return 0;
+}
+
+int rpm_lmac_enadis_pause_frm(void *rpmd, int lmac_id, u8 tx_pause,
+			      u8 rx_pause)
+{
+	rpm_t *rpm = rpmd;
+	u64 cfg;
+
+	if (!is_lmac_valid(rpm, lmac_id))
+		return -ENODEV;
+
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE;
+	cfg |= rx_pause ? 0x0 : RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE;
+	cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE;
+	cfg |= rx_pause ? 0x0 : RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE;
+	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE;
+	cfg |= tx_pause ? 0x0 : RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE;
+	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+
+	cfg = rpm_read(rpm, 0, RPMX_CMR_RX_OVR_BP);
+	if (tx_pause) {
+		cfg &= ~RPMX_CMR_RX_OVR_BP_EN(lmac_id);
+	} else {
+		cfg |= RPMX_CMR_RX_OVR_BP_EN(lmac_id);
+		cfg &= ~RPMX_CMR_RX_OVR_BP_BP(lmac_id);
+	}
+	rpm_write(rpm, 0, RPMX_CMR_RX_OVR_BP, cfg);
+	return 0;
+}
+
+void rpm_lmac_pause_frm_config(void *rpmd, int lmac_id, bool enable)
+{
+	rpm_t *rpm = rpmd;
+	u64 cfg;
+
+	if (enable) {
+		/* Enable 802.3 pause frame mode */
+		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+		cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_PFC_MODE;
+		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+
+		/* Enable receive pause frames */
+		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+		cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE;
+		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+
+		/* Enable forward pause to TX block */
+		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+		cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE;
+		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+
+		/* Enable pause frames transmission */
+		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+		cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE;
+		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+
+		/* Set pause time and interval */
+		cfg = rpm_read(rpm, lmac_id,
+			       RPMX_MTI_MAC100X_CL01_PAUSE_QUANTA);
+		cfg &= ~0xFFFFULL;
+		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_CL01_PAUSE_QUANTA,
+			  cfg | RPM_DEFAULT_PAUSE_TIME);
+		/* Set pause interval as the hardware default is too short */
+		cfg = rpm_read(rpm, lmac_id,
+			       RPMX_MTI_MAC100X_CL01_QUANTA_THRESH);
+		cfg &= ~0xFFFFULL;
+		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_CL01_QUANTA_THRESH,
+			  cfg | (RPM_DEFAULT_PAUSE_TIME / 2));
+
+	} else {
+		/* ALL pause frames received are completely ignored */
+		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+		cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE;
+		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+
+		/* Disable forward pause to TX block */
+		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+		cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE;
+		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+
+		/* Disable pause frames transmission */
+		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+		cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE;
+		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+	}
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index 1779e8b..0e8b456 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -21,9 +21,25 @@
 
 #define RPMX_CMRX_LINK_RANGE_MASK	GENMASK_ULL(19, 16)
 #define RPMX_CMRX_LINK_BASE_MASK	GENMASK_ULL(11, 0)
-
+#define RPMX_MTI_MAC100X_COMMAND_CONFIG	0x8010
+#define RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE	BIT_ULL(29)
+#define RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE	BIT_ULL(28)
+#define RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE	BIT_ULL(8)
+#define RPMX_MTI_MAC100X_COMMAND_CONFIG_PFC_MODE	BIT_ULL(19)
+#define RPMX_MTI_MAC100X_CL01_PAUSE_QUANTA		0x80A8
+#define RPMX_MTI_MAC100X_CL01_QUANTA_THRESH		0x80C8
+#define RPM_DEFAULT_PAUSE_TIME			0xFFFF
+#define RPMX_CMR_RX_OVR_BP		0x4120
+#define RPMX_CMR_RX_OVR_BP_EN(x)	BIT_ULL((x) + 8)
+#define RPMX_CMR_RX_OVR_BP_BP(x)	BIT_ULL((x) + 4)
 #define RPM_LMAC_FWI			0xa
 
 /* Function Declarations */
+void rpm_lmac_enadis_rx_pause_fwding(void *rpmd, int lmac_id, bool enable);
+int rpm_lmac_get_pause_frm_status(void *cgxd, int lmac_id, u8 *tx_pause,
+				  u8 *rx_pause);
+void rpm_lmac_pause_frm_config(void *rpmd, int lmac_id, bool enable);
+int rpm_lmac_enadis_pause_frm(void *rpmd, int lmac_id, u8 tx_pause,
+			      u8 rx_pause);
 int rpm_get_nr_lmacs(void *cgxd);
 #endif /* RPM_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 5e514f2..1c980c8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -406,6 +406,7 @@ static bool is_cgx_config_permitted(struct rvu *rvu, u16 pcifunc)
 
 void rvu_cgx_enadis_rx_bp(struct rvu *rvu, int pf, bool enable)
 {
+	struct mac_ops *mac_ops;
 	u8 cgx_id, lmac_id;
 	void *cgxd;
 
@@ -415,11 +416,12 @@ void rvu_cgx_enadis_rx_bp(struct rvu *rvu, int pf, bool enable)
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	cgxd = rvu_cgx_pdata(cgx_id, rvu);
 
+	mac_ops = get_mac_ops(cgxd);
 	/* Set / clear CTL_BCK to control pause frame forwarding to NIX */
 	if (enable)
-		cgx_lmac_enadis_rx_pause_fwding(cgxd, lmac_id, true);
+		mac_ops->mac_enadis_rx_pause_fwding(cgxd, lmac_id, true);
 	else
-		cgx_lmac_enadis_rx_pause_fwding(cgxd, lmac_id, false);
+		mac_ops->mac_enadis_rx_pause_fwding(cgxd, lmac_id, false);
 }
 
 int rvu_cgx_config_rxtx(struct rvu *rvu, u16 pcifunc, bool start)
@@ -715,7 +717,9 @@ int rvu_mbox_handler_cgx_cfg_pause_frm(struct rvu *rvu,
 				       struct cgx_pause_frm_cfg *rsp)
 {
 	int pf = rvu_get_pf(req->hdr.pcifunc);
+	struct mac_ops *mac_ops;
 	u8 cgx_id, lmac_id;
+	void *cgxd;
 
 	if (!is_mac_feature_supported(rvu, pf, RVU_LMAC_FEAT_FC))
 		return 0;
@@ -727,13 +731,16 @@ int rvu_mbox_handler_cgx_cfg_pause_frm(struct rvu *rvu,
 		return -ENODEV;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	cgxd = rvu_cgx_pdata(cgx_id, rvu);
+	mac_ops = get_mac_ops(cgxd);
 
 	if (req->set)
-		cgx_lmac_set_pause_frm(rvu_cgx_pdata(cgx_id, rvu), lmac_id,
-				       req->tx_pause, req->rx_pause);
+		mac_ops->mac_enadis_pause_frm(cgxd, lmac_id,
+					      req->tx_pause, req->rx_pause);
 	else
-		cgx_lmac_get_pause_frm(rvu_cgx_pdata(cgx_id, rvu), lmac_id,
-				       &rsp->tx_pause, &rsp->rx_pause);
+		mac_ops->mac_get_pause_frm_status(cgxd, lmac_id,
+						  &rsp->tx_pause,
+						  &rsp->rx_pause);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index ee27ddd..d300019 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -16,6 +16,7 @@
 #include "rvu.h"
 #include "npc.h"
 #include "cgx.h"
+#include "lmac_common.h"
 
 static void nix_free_tx_vtag_entries(struct rvu *rvu, u16 pcifunc);
 static int rvu_nix_get_bpid(struct rvu *rvu, struct nix_bp_cfg_req *req,
@@ -214,6 +215,7 @@ static bool is_valid_txschq(struct rvu *rvu, int blkaddr,
 static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	struct mac_ops *mac_ops;
 	int pkind, pf, vf, lbkid;
 	u8 cgx_id, lmac_id;
 	int err;
@@ -240,10 +242,12 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 		cgx_set_pkind(rvu_cgx_pdata(cgx_id, rvu), lmac_id, pkind);
 		rvu_npc_set_pkind(rvu, pkind, pfvf);
 
+		mac_ops = get_mac_ops(rvu_cgx_pdata(cgx_id, rvu));
 		/* By default we enable pause frames */
 		if ((pcifunc & RVU_PFVF_FUNC_MASK) == 0)
-			cgx_lmac_set_pause_frm(rvu_cgx_pdata(cgx_id, rvu),
-					       lmac_id, true, true);
+			mac_ops->mac_enadis_pause_frm(rvu_cgx_pdata(cgx_id,
+								    rvu),
+						      lmac_id, true, true);
 		break;
 	case NIX_INTF_TYPE_LBK:
 		vf = (pcifunc & RVU_PFVF_FUNC_MASK) - 1;
-- 
2.7.4

