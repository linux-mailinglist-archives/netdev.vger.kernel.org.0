Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BA12D98FB
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 14:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439985AbgLNNg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 08:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407976AbgLNNdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 08:33:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E79CC0617A6
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 05:31:57 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1konxD-0003Sd-Lm
        for netdev@vger.kernel.org; Mon, 14 Dec 2020 14:31:55 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 449EA5AD2B8
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 13:31:50 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 5732D5AD28E;
        Mon, 14 Dec 2020 13:31:47 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a38b67d6;
        Mon, 14 Dec 2020 13:31:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sean Nyekjaer <sean@geanix.com>, Dan Murphy <dmurphy@ti.com>
Subject: [net-next 2/7] can: m_can: convert indention to kernel coding style
Date:   Mon, 14 Dec 2020 14:31:40 +0100
Message-Id: <20201214133145.442472-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214133145.442472-1-mkl@pengutronix.de>
References: <20201214133145.442472-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch converts the  indention in the m_can driver to kernel coding style.

Link: https://lore.kernel.org/r/20201212175518.139651-3-mkl@pengutronix.de
Reviewed-by: Sean Nyekjaer <sean@geanix.com>
Reviewed-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 88 +++++++++++++++++------------------
 1 file changed, 43 insertions(+), 45 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index ec209326c3d8..f9b24fb45a8c 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -39,7 +39,7 @@ enum m_can_reg {
 	M_CAN_TOCV	= 0x2c,
 	M_CAN_ECR	= 0x40,
 	M_CAN_PSR	= 0x44,
-/* TDCR Register only available for version >=3.1.x */
+	/* TDCR Register only available for version >=3.1.x */
 	M_CAN_TDCR	= 0x48,
 	M_CAN_IR	= 0x50,
 	M_CAN_IE	= 0x54,
@@ -335,7 +335,7 @@ static u32 m_can_fifo_read(struct m_can_classdev *cdev,
 			   u32 fgi, unsigned int offset)
 {
 	u32 addr_offset = cdev->mcfg[MRAM_RXF0].off + fgi * RXF0_ELEMENT_SIZE +
-			  offset;
+		offset;
 
 	return cdev->ops->read_fifo(cdev, addr_offset);
 }
@@ -344,7 +344,7 @@ static void m_can_fifo_write(struct m_can_classdev *cdev,
 			     u32 fpi, unsigned int offset, u32 val)
 {
 	u32 addr_offset = cdev->mcfg[MRAM_TXB].off + fpi * TXB_ELEMENT_SIZE +
-			  offset;
+		offset;
 
 	cdev->ops->write_fifo(cdev, addr_offset, val);
 }
@@ -358,14 +358,14 @@ static inline void m_can_fifo_write_no_off(struct m_can_classdev *cdev,
 static u32 m_can_txe_fifo_read(struct m_can_classdev *cdev, u32 fgi, u32 offset)
 {
 	u32 addr_offset = cdev->mcfg[MRAM_TXE].off + fgi * TXE_ELEMENT_SIZE +
-			  offset;
+		offset;
 
 	return cdev->ops->read_fifo(cdev, addr_offset);
 }
 
 static inline bool m_can_tx_fifo_full(struct m_can_classdev *cdev)
 {
-		return !!(m_can_read(cdev, M_CAN_TXFQS) & TXFQS_TFQF);
+	return !!(m_can_read(cdev, M_CAN_TXFQS) & TXFQS_TFQF);
 }
 
 void m_can_config_endisable(struct m_can_classdev *cdev, bool enable)
@@ -921,14 +921,13 @@ static void m_can_echo_tx_event(struct net_device *dev)
 	m_can_txefs = m_can_read(cdev, M_CAN_TXEFS);
 
 	/* Get Tx Event fifo element count */
-	txe_count = (m_can_txefs & TXEFS_EFFL_MASK)
-			>> TXEFS_EFFL_SHIFT;
+	txe_count = (m_can_txefs & TXEFS_EFFL_MASK) >> TXEFS_EFFL_SHIFT;
 
 	/* Get and process all sent elements */
 	for (i = 0; i < txe_count; i++) {
 		/* retrieve get index */
-		fgi = (m_can_read(cdev, M_CAN_TXEFS) & TXEFS_EFGI_MASK)
-			>> TXEFS_EFGI_SHIFT;
+		fgi = (m_can_read(cdev, M_CAN_TXEFS) & TXEFS_EFGI_MASK) >>
+			TXEFS_EFGI_SHIFT;
 
 		/* get message marker */
 		msg_mark = (m_can_txe_fifo_read(cdev, fgi, 4) &
@@ -1087,7 +1086,7 @@ static int m_can_set_bittiming(struct net_device *dev)
 			 * Transmitter Delay Compensation Section
 			 */
 			tdco = (cdev->can.clock.freq / 1000) *
-			       ssp / dbt->bitrate;
+				ssp / dbt->bitrate;
 
 			/* Max valid TDCO value is 127 */
 			if (tdco > 127) {
@@ -1102,9 +1101,9 @@ static int m_can_set_bittiming(struct net_device *dev)
 		}
 
 		reg_btp |= (brp << DBTP_DBRP_SHIFT) |
-			   (sjw << DBTP_DSJW_SHIFT) |
-			   (tseg1 << DBTP_DTSEG1_SHIFT) |
-			   (tseg2 << DBTP_DTSEG2_SHIFT);
+			(sjw << DBTP_DSJW_SHIFT) |
+			(tseg1 << DBTP_DTSEG1_SHIFT) |
+			(tseg2 << DBTP_DTSEG2_SHIFT);
 
 		m_can_write(cdev, M_CAN_DBTP, reg_btp);
 	}
@@ -1137,7 +1136,7 @@ static void m_can_chip_config(struct net_device *dev)
 	if (cdev->version == 30) {
 		/* only support one Tx Buffer currently */
 		m_can_write(cdev, M_CAN_TXBC, (1 << TXBC_NDTB_SHIFT) |
-				cdev->mcfg[MRAM_TXB].off);
+			    cdev->mcfg[MRAM_TXB].off);
 	} else {
 		/* TX FIFO is used for newer IP Core versions */
 		m_can_write(cdev, M_CAN_TXBC,
@@ -1151,7 +1150,7 @@ static void m_can_chip_config(struct net_device *dev)
 	/* TX Event FIFO */
 	if (cdev->version == 30) {
 		m_can_write(cdev, M_CAN_TXEFC, (1 << TXEFC_EFS_SHIFT) |
-				cdev->mcfg[MRAM_TXE].off);
+			    cdev->mcfg[MRAM_TXE].off);
 	} else {
 		/* Full TX Event FIFO is used */
 		m_can_write(cdev, M_CAN_TXEFC,
@@ -1163,27 +1162,27 @@ static void m_can_chip_config(struct net_device *dev)
 	/* rx fifo configuration, blocking mode, fifo size 1 */
 	m_can_write(cdev, M_CAN_RXF0C,
 		    (cdev->mcfg[MRAM_RXF0].num << RXFC_FS_SHIFT) |
-		     cdev->mcfg[MRAM_RXF0].off);
+		    cdev->mcfg[MRAM_RXF0].off);
 
 	m_can_write(cdev, M_CAN_RXF1C,
 		    (cdev->mcfg[MRAM_RXF1].num << RXFC_FS_SHIFT) |
-		     cdev->mcfg[MRAM_RXF1].off);
+		    cdev->mcfg[MRAM_RXF1].off);
 
 	cccr = m_can_read(cdev, M_CAN_CCCR);
 	test = m_can_read(cdev, M_CAN_TEST);
 	test &= ~TEST_LBCK;
 	if (cdev->version == 30) {
-	/* Version 3.0.x */
+		/* Version 3.0.x */
 
 		cccr &= ~(CCCR_TEST | CCCR_MON | CCCR_DAR |
-			(CCCR_CMR_MASK << CCCR_CMR_SHIFT) |
-			(CCCR_CME_MASK << CCCR_CME_SHIFT));
+			  (CCCR_CMR_MASK << CCCR_CMR_SHIFT) |
+			  (CCCR_CME_MASK << CCCR_CME_SHIFT));
 
 		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD)
 			cccr |= CCCR_CME_CANFD_BRS << CCCR_CME_SHIFT;
 
 	} else {
-	/* Version 3.1.x or 3.2.x */
+		/* Version 3.1.x or 3.2.x */
 		cccr &= ~(CCCR_TEST | CCCR_MON | CCCR_BRSE | CCCR_FDOE |
 			  CCCR_NISO | CCCR_DAR);
 
@@ -1352,10 +1351,10 @@ static int m_can_dev_setup(struct m_can_classdev *m_can_dev)
 
 	/* Set M_CAN supported operations */
 	m_can_dev->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
-					CAN_CTRLMODE_LISTENONLY |
-					CAN_CTRLMODE_BERR_REPORTING |
-					CAN_CTRLMODE_FD |
-					CAN_CTRLMODE_ONE_SHOT;
+		CAN_CTRLMODE_LISTENONLY |
+		CAN_CTRLMODE_BERR_REPORTING |
+		CAN_CTRLMODE_FD |
+		CAN_CTRLMODE_ONE_SHOT;
 
 	/* Set properties depending on M_CAN version */
 	switch (m_can_dev->version) {
@@ -1366,8 +1365,8 @@ static int m_can_dev_setup(struct m_can_classdev *m_can_dev)
 			m_can_dev->bit_timing : &m_can_bittiming_const_30X;
 
 		m_can_dev->can.data_bittiming_const = m_can_dev->data_timing ?
-						m_can_dev->data_timing :
-						&m_can_data_bittiming_const_30X;
+			m_can_dev->data_timing :
+			&m_can_data_bittiming_const_30X;
 		break;
 	case 31:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.1.x */
@@ -1376,8 +1375,8 @@ static int m_can_dev_setup(struct m_can_classdev *m_can_dev)
 			m_can_dev->bit_timing : &m_can_bittiming_const_31X;
 
 		m_can_dev->can.data_bittiming_const = m_can_dev->data_timing ?
-						m_can_dev->data_timing :
-						&m_can_data_bittiming_const_31X;
+			m_can_dev->data_timing :
+			&m_can_data_bittiming_const_31X;
 		break;
 	case 32:
 	case 33:
@@ -1386,13 +1385,12 @@ static int m_can_dev_setup(struct m_can_classdev *m_can_dev)
 			m_can_dev->bit_timing : &m_can_bittiming_const_31X;
 
 		m_can_dev->can.data_bittiming_const = m_can_dev->data_timing ?
-						m_can_dev->data_timing :
-						&m_can_data_bittiming_const_31X;
+			m_can_dev->data_timing :
+			&m_can_data_bittiming_const_31X;
 
 		m_can_dev->can.ctrlmode_supported |=
-						(m_can_niso_supported(m_can_dev)
-						? CAN_CTRLMODE_FD_NON_ISO
-						: 0);
+			(m_can_niso_supported(m_can_dev) ?
+			 CAN_CTRLMODE_FD_NON_ISO : 0);
 		break;
 	default:
 		dev_err(m_can_dev->dev, "Unsupported version number: %2d",
@@ -1534,7 +1532,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 
 		/* get put index for frame */
 		putidx = ((m_can_read(cdev, M_CAN_TXFQS) & TXFQS_TFQPI_MASK)
-				  >> TXFQS_TFQPI_SHIFT);
+			  >> TXFQS_TFQPI_SHIFT);
 		/* Write ID Field to FIFO Element */
 		m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID, id);
 
@@ -1581,7 +1579,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 static void m_can_tx_work_queue(struct work_struct *ws)
 {
 	struct m_can_classdev *cdev = container_of(ws, struct m_can_classdev,
-						tx_work);
+						   tx_work);
 
 	m_can_tx_handler(cdev);
 	cdev->tx_skb = NULL;
@@ -1705,26 +1703,26 @@ static void m_can_of_parse_mram(struct m_can_classdev *cdev,
 	cdev->mcfg[MRAM_SIDF].off = mram_config_vals[0];
 	cdev->mcfg[MRAM_SIDF].num = mram_config_vals[1];
 	cdev->mcfg[MRAM_XIDF].off = cdev->mcfg[MRAM_SIDF].off +
-			cdev->mcfg[MRAM_SIDF].num * SIDF_ELEMENT_SIZE;
+		cdev->mcfg[MRAM_SIDF].num * SIDF_ELEMENT_SIZE;
 	cdev->mcfg[MRAM_XIDF].num = mram_config_vals[2];
 	cdev->mcfg[MRAM_RXF0].off = cdev->mcfg[MRAM_XIDF].off +
-			cdev->mcfg[MRAM_XIDF].num * XIDF_ELEMENT_SIZE;
+		cdev->mcfg[MRAM_XIDF].num * XIDF_ELEMENT_SIZE;
 	cdev->mcfg[MRAM_RXF0].num = mram_config_vals[3] &
-			(RXFC_FS_MASK >> RXFC_FS_SHIFT);
+		(RXFC_FS_MASK >> RXFC_FS_SHIFT);
 	cdev->mcfg[MRAM_RXF1].off = cdev->mcfg[MRAM_RXF0].off +
-			cdev->mcfg[MRAM_RXF0].num * RXF0_ELEMENT_SIZE;
+		cdev->mcfg[MRAM_RXF0].num * RXF0_ELEMENT_SIZE;
 	cdev->mcfg[MRAM_RXF1].num = mram_config_vals[4] &
-			(RXFC_FS_MASK >> RXFC_FS_SHIFT);
+		(RXFC_FS_MASK >> RXFC_FS_SHIFT);
 	cdev->mcfg[MRAM_RXB].off = cdev->mcfg[MRAM_RXF1].off +
-			cdev->mcfg[MRAM_RXF1].num * RXF1_ELEMENT_SIZE;
+		cdev->mcfg[MRAM_RXF1].num * RXF1_ELEMENT_SIZE;
 	cdev->mcfg[MRAM_RXB].num = mram_config_vals[5];
 	cdev->mcfg[MRAM_TXE].off = cdev->mcfg[MRAM_RXB].off +
-			cdev->mcfg[MRAM_RXB].num * RXB_ELEMENT_SIZE;
+		cdev->mcfg[MRAM_RXB].num * RXB_ELEMENT_SIZE;
 	cdev->mcfg[MRAM_TXE].num = mram_config_vals[6];
 	cdev->mcfg[MRAM_TXB].off = cdev->mcfg[MRAM_TXE].off +
-			cdev->mcfg[MRAM_TXE].num * TXE_ELEMENT_SIZE;
+		cdev->mcfg[MRAM_TXE].num * TXE_ELEMENT_SIZE;
 	cdev->mcfg[MRAM_TXB].num = mram_config_vals[7] &
-			(TXBC_NDTB_MASK >> TXBC_NDTB_SHIFT);
+		(TXBC_NDTB_MASK >> TXBC_NDTB_SHIFT);
 
 	dev_dbg(cdev->dev,
 		"sidf 0x%x %d xidf 0x%x %d rxf0 0x%x %d rxf1 0x%x %d rxb 0x%x %d txe 0x%x %d txb 0x%x %d\n",
-- 
2.29.2


