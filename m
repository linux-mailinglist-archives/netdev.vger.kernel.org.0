Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BD1226DD4
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389227AbgGTSJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:09:16 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9512 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729029AbgGTSJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:09:14 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KHtqUx024237;
        Mon, 20 Jul 2020 11:09:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=mBf7wYTPOBWmrQy/3lp/pg+GFC45a7X4xUXAz5I7r+o=;
 b=SP4yXOBGPAKcLzDO/R49yPfJERfHsZs4KIvx22zcH+kzIpE6FwInWg8T9adJ3FCUuJen
 /beau0qPr47FiPqOr/Y7yzmhAdbRf905L5jpgjNLfzzWxf80OIkI+qGiWKI6t6VTg+RA
 YDXqzuW/i2h0CAhNFC40mJSgMqv3MCivyG9IPkVyeqbVS8K/L/DGTlMcvcqhZ4M9xtX1
 jlXwwMSnp3Q2qHTGuFD5HeoB7lacf+3Y0j2iBrEc3qdIgOVvV707sFHvhf2uuJ/fybQx
 qhJAE9oS/G2CJ8Drre6j2v/LIyhCgTYNhshs9BqiSWTqnzqxK/+jgvyPcO+Eu9HTL350 bg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkf8w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:09:08 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:09:07 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:09:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:09:05 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 96E153F7041;
        Mon, 20 Jul 2020 11:09:01 -0700 (PDT)
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
Subject: [PATCH v3 net-next 04/16] qed: reformat public_port::transceiver_data a bit
Date:   Mon, 20 Jul 2020 21:08:03 +0300
Message-ID: <20200720180815.107-5-alobakin@marvell.com>
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

Prior to adding new bitfields, reformat the existing ones from spaces
to tabs, and unify all hex values to lowercase.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_hsi.h | 108 +++++++++++-----------
 1 file changed, 55 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 6bb0bbc0013b..0d0a109d94b4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -11973,59 +11973,61 @@ struct public_port {
 	struct dcbx_mib operational_dcbx_mib;
 
 	u32 reserved[2];
-	u32 transceiver_data;
-#define ETH_TRANSCEIVER_STATE_MASK	0x000000FF
-#define ETH_TRANSCEIVER_STATE_SHIFT	0x00000000
-#define ETH_TRANSCEIVER_STATE_OFFSET	0x00000000
-#define ETH_TRANSCEIVER_STATE_UNPLUGGED	0x00000000
-#define ETH_TRANSCEIVER_STATE_PRESENT	0x00000001
-#define ETH_TRANSCEIVER_STATE_VALID	0x00000003
-#define ETH_TRANSCEIVER_STATE_UPDATING	0x00000008
-#define ETH_TRANSCEIVER_TYPE_MASK       0x0000FF00
-#define ETH_TRANSCEIVER_TYPE_OFFSET     0x8
-#define ETH_TRANSCEIVER_TYPE_NONE                       0x00
-#define ETH_TRANSCEIVER_TYPE_UNKNOWN                    0xFF
-#define ETH_TRANSCEIVER_TYPE_1G_PCC                     0x01
-#define ETH_TRANSCEIVER_TYPE_1G_ACC                     0x02
-#define ETH_TRANSCEIVER_TYPE_1G_LX                      0x03
-#define ETH_TRANSCEIVER_TYPE_1G_SX                      0x04
-#define ETH_TRANSCEIVER_TYPE_10G_SR                     0x05
-#define ETH_TRANSCEIVER_TYPE_10G_LR                     0x06
-#define ETH_TRANSCEIVER_TYPE_10G_LRM                    0x07
-#define ETH_TRANSCEIVER_TYPE_10G_ER                     0x08
-#define ETH_TRANSCEIVER_TYPE_10G_PCC                    0x09
-#define ETH_TRANSCEIVER_TYPE_10G_ACC                    0x0a
-#define ETH_TRANSCEIVER_TYPE_XLPPI                      0x0b
-#define ETH_TRANSCEIVER_TYPE_40G_LR4                    0x0c
-#define ETH_TRANSCEIVER_TYPE_40G_SR4                    0x0d
-#define ETH_TRANSCEIVER_TYPE_40G_CR4                    0x0e
-#define ETH_TRANSCEIVER_TYPE_100G_AOC                   0x0f
-#define ETH_TRANSCEIVER_TYPE_100G_SR4                   0x10
-#define ETH_TRANSCEIVER_TYPE_100G_LR4                   0x11
-#define ETH_TRANSCEIVER_TYPE_100G_ER4                   0x12
-#define ETH_TRANSCEIVER_TYPE_100G_ACC                   0x13
-#define ETH_TRANSCEIVER_TYPE_100G_CR4                   0x14
-#define ETH_TRANSCEIVER_TYPE_4x10G_SR                   0x15
-#define ETH_TRANSCEIVER_TYPE_25G_CA_N                   0x16
-#define ETH_TRANSCEIVER_TYPE_25G_ACC_S                  0x17
-#define ETH_TRANSCEIVER_TYPE_25G_CA_S                   0x18
-#define ETH_TRANSCEIVER_TYPE_25G_ACC_M                  0x19
-#define ETH_TRANSCEIVER_TYPE_25G_CA_L                   0x1a
-#define ETH_TRANSCEIVER_TYPE_25G_ACC_L                  0x1b
-#define ETH_TRANSCEIVER_TYPE_25G_SR                     0x1c
-#define ETH_TRANSCEIVER_TYPE_25G_LR                     0x1d
-#define ETH_TRANSCEIVER_TYPE_25G_AOC                    0x1e
-#define ETH_TRANSCEIVER_TYPE_4x10G                      0x1f
-#define ETH_TRANSCEIVER_TYPE_4x25G_CR                   0x20
-#define ETH_TRANSCEIVER_TYPE_1000BASET                  0x21
-#define ETH_TRANSCEIVER_TYPE_10G_BASET                  0x22
-#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_40G_SR      0x30
-#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_40G_CR      0x31
-#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_40G_LR      0x32
-#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_SR     0x33
-#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_CR     0x34
-#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_LR     0x35
-#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_AOC    0x36
+
+	u32						transceiver_data;
+#define ETH_TRANSCEIVER_STATE_MASK			0x000000ff
+#define ETH_TRANSCEIVER_STATE_SHIFT			0x00000000
+#define ETH_TRANSCEIVER_STATE_OFFSET			0x00000000
+#define ETH_TRANSCEIVER_STATE_UNPLUGGED			0x00000000
+#define ETH_TRANSCEIVER_STATE_PRESENT			0x00000001
+#define ETH_TRANSCEIVER_STATE_VALID			0x00000003
+#define ETH_TRANSCEIVER_STATE_UPDATING			0x00000008
+#define ETH_TRANSCEIVER_TYPE_MASK			0x0000ff00
+#define ETH_TRANSCEIVER_TYPE_OFFSET			0x8
+#define ETH_TRANSCEIVER_TYPE_NONE			0x00
+#define ETH_TRANSCEIVER_TYPE_UNKNOWN			0xff
+#define ETH_TRANSCEIVER_TYPE_1G_PCC			0x01
+#define ETH_TRANSCEIVER_TYPE_1G_ACC			0x02
+#define ETH_TRANSCEIVER_TYPE_1G_LX			0x03
+#define ETH_TRANSCEIVER_TYPE_1G_SX			0x04
+#define ETH_TRANSCEIVER_TYPE_10G_SR			0x05
+#define ETH_TRANSCEIVER_TYPE_10G_LR			0x06
+#define ETH_TRANSCEIVER_TYPE_10G_LRM			0x07
+#define ETH_TRANSCEIVER_TYPE_10G_ER			0x08
+#define ETH_TRANSCEIVER_TYPE_10G_PCC			0x09
+#define ETH_TRANSCEIVER_TYPE_10G_ACC			0x0a
+#define ETH_TRANSCEIVER_TYPE_XLPPI			0x0b
+#define ETH_TRANSCEIVER_TYPE_40G_LR4			0x0c
+#define ETH_TRANSCEIVER_TYPE_40G_SR4			0x0d
+#define ETH_TRANSCEIVER_TYPE_40G_CR4			0x0e
+#define ETH_TRANSCEIVER_TYPE_100G_AOC			0x0f
+#define ETH_TRANSCEIVER_TYPE_100G_SR4			0x10
+#define ETH_TRANSCEIVER_TYPE_100G_LR4			0x11
+#define ETH_TRANSCEIVER_TYPE_100G_ER4			0x12
+#define ETH_TRANSCEIVER_TYPE_100G_ACC			0x13
+#define ETH_TRANSCEIVER_TYPE_100G_CR4			0x14
+#define ETH_TRANSCEIVER_TYPE_4x10G_SR			0x15
+#define ETH_TRANSCEIVER_TYPE_25G_CA_N			0x16
+#define ETH_TRANSCEIVER_TYPE_25G_ACC_S			0x17
+#define ETH_TRANSCEIVER_TYPE_25G_CA_S			0x18
+#define ETH_TRANSCEIVER_TYPE_25G_ACC_M			0x19
+#define ETH_TRANSCEIVER_TYPE_25G_CA_L			0x1a
+#define ETH_TRANSCEIVER_TYPE_25G_ACC_L			0x1b
+#define ETH_TRANSCEIVER_TYPE_25G_SR			0x1c
+#define ETH_TRANSCEIVER_TYPE_25G_LR			0x1d
+#define ETH_TRANSCEIVER_TYPE_25G_AOC			0x1e
+#define ETH_TRANSCEIVER_TYPE_4x10G			0x1f
+#define ETH_TRANSCEIVER_TYPE_4x25G_CR			0x20
+#define ETH_TRANSCEIVER_TYPE_1000BASET			0x21
+#define ETH_TRANSCEIVER_TYPE_10G_BASET			0x22
+#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_40G_SR	0x30
+#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_40G_CR	0x31
+#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_40G_LR	0x32
+#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_SR	0x33
+#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_CR	0x34
+#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_LR	0x35
+#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_AOC	0x36
+
 	u32 wol_info;
 	u32 wol_pkt_len;
 	u32 wol_pkt_details;
-- 
2.25.1

