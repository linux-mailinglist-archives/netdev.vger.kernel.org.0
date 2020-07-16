Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31692221CC
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 13:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgGPLzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 07:55:50 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34414 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728453AbgGPLzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 07:55:49 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GBpRih032120;
        Thu, 16 Jul 2020 04:55:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=mBf7wYTPOBWmrQy/3lp/pg+GFC45a7X4xUXAz5I7r+o=;
 b=AG3kM0P5pOlekIQkov4Hqnsk/S25WfbmEZ1KG11QGwVbz+2+wMREQLmDIj17Q/bIWhOa
 OU1/ZjmLyJ5bGnuNwpLr5/1aW6SwdoXzKuZlA/qXXOd9bfKgGEZq+wSAJpoEjOQHLjAi
 Q8hGavAg+4Z1QWlHRgs4VJllrfPNlNZn6Oy1YuRWVCIzVwxcup8/YyMYT0lK/JpFCWvb
 FD8iZ3rrTZjqv+9tL5oF9gj8wXJCrNq1jSW1hMWj73RCuSsmkzJF7z6b6aKVDrVrYINn
 v1TagrYFYNvzZHvgJoFkzPrVjbz1+1u8LM1cJ+eYZ10p2afuqxGJyPF7VZnT3HAMS+Em FA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 32ap7v81p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 04:55:46 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Jul
 2020 04:55:44 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Jul 2020 04:55:45 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 60AAB3F703F;
        Thu, 16 Jul 2020 04:55:41 -0700 (PDT)
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
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@cavium.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 02/13] qed: reformat public_port::transceiver_data a bit
Date:   Thu, 16 Jul 2020 14:54:35 +0300
Message-ID: <20200716115446.994-3-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716115446.994-1-alobakin@marvell.com>
References: <20200716115446.994-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_05:2020-07-16,2020-07-16 signatures=0
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

