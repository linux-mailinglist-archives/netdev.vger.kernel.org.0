Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572E143D04E
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 20:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243410AbhJ0SLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 14:11:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54452 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243405AbhJ0SLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 14:11:05 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RFW69j032300;
        Wed, 27 Oct 2021 11:08:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=4SwAuwSasCqpoa3zq6JsohxkO2y1rPWT103jTLpqaPg=;
 b=FVy3qHbFeh9B5/MQkLn/mmaBj2+6PAGET3E7BDoJfQ6HoMwsfVuqkeEkfDkotBsvgl16
 OWocESWUwsl2bb7MduzbtOjV5aenNwP+H2zDnAXj28kPIayvyRSJC9dqj3zWaLnkkHyI
 sdTWM+jENhAvtySrTnu/w0oacfFaH2gW48wgnn9YIFHWnLQjYp7A161A6D7A6UnNzejw
 XDltjcr+jo+B2KO4Va3r4J4hgOKq4hDNo3jnDhxsDdJEtjdKp5M5KeqE4T/7zTr637XS
 gdsFN2cdX0X4q9spPbWWUpnjIdssU3qKvp/HC5Klk4pyfFnm/cZGBAD/pKjhqVo8AHrX Fw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3by1caaurt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 11:08:37 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 11:08:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 11:08:35 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 17B103F706D;
        Wed, 27 Oct 2021 11:08:32 -0700 (PDT)
From:   Rakesh Babu Saladi <rsaladi2@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>
Subject: [net-next PATCH v3 1/3] octeontx2-af: debugfs: Minor changes.
Date:   Wed, 27 Oct 2021 23:37:43 +0530
Message-ID: <20211027180745.27947-2-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211027180745.27947-1-rsaladi2@marvell.com>
References: <20211027180745.27947-1-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: igcZhTED5fY2bLm7_VuGH4Aehtgxw-JR
X-Proofpoint-ORIG-GUID: igcZhTED5fY2bLm7_VuGH4Aehtgxw-JR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_05,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few changes in rvu_debugfs.c file to remove unwanted characters,
indenting the code, added a new comment line etc.

Signed-off-by: Rakesh Babu Saladi <rsaladi2@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../marvell/octeontx2/af/rvu_debugfs.c        | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 9338765da048..a8f2cf53c83b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -95,7 +95,7 @@ static char *cgx_tx_stats_fields[] = {
 	[CGX_STAT5]	= "Total frames sent on the interface",
 	[CGX_STAT6]	= "Packets sent with an octet count < 64",
 	[CGX_STAT7]	= "Packets sent with an octet count == 64",
-	[CGX_STAT8]	= "Packets sent with an octet count of 65–127",
+	[CGX_STAT8]	= "Packets sent with an octet count of 65-127",
 	[CGX_STAT9]	= "Packets sent with an octet count of 128-255",
 	[CGX_STAT10]	= "Packets sent with an octet count of 256-511",
 	[CGX_STAT11]	= "Packets sent with an octet count of 512-1023",
@@ -125,7 +125,7 @@ static char *rpm_rx_stats_fields[] = {
 	"Total frames received on interface",
 	"Packets received with an octet count < 64",
 	"Packets received with an octet count == 64",
-	"Packets received with an octet count of 65â127",
+	"Packets received with an octet count of 65-127",
 	"Packets received with an octet count of 128-255",
 	"Packets received with an octet count of 256-511",
 	"Packets received with an octet count of 512-1023",
@@ -164,7 +164,7 @@ static char *rpm_tx_stats_fields[] = {
 	"Packets sent to the multicast DMAC",
 	"Packets sent to a broadcast DMAC",
 	"Packets sent with an octet count == 64",
-	"Packets sent with an octet count of 65â127",
+	"Packets sent with an octet count of 65-127",
 	"Packets sent with an octet count of 128-255",
 	"Packets sent with an octet count of 256-511",
 	"Packets sent with an octet count of 512-1023",
@@ -1878,7 +1878,7 @@ static int cgx_print_stats(struct seq_file *s, int lmac_id)
 		return -ENODEV;
 
 	mac_ops = get_mac_ops(cgxd);
-
+	/* There can be no CGX devices at all */
 	if (!mac_ops)
 		return 0;
 
@@ -1956,13 +1956,13 @@ static int cgx_print_stats(struct seq_file *s, int lmac_id)
 		if (err)
 			return err;
 
-	if (is_rvu_otx2(rvu))
-		seq_printf(s, "%s: %llu\n", cgx_tx_stats_fields[stat],
-			   tx_stat);
-	else
-		seq_printf(s, "%s: %llu\n", rpm_tx_stats_fields[stat],
-			   tx_stat);
-	stat++;
+		if (is_rvu_otx2(rvu))
+			seq_printf(s, "%s: %llu\n", cgx_tx_stats_fields[stat],
+				   tx_stat);
+		else
+			seq_printf(s, "%s: %llu\n", rpm_tx_stats_fields[stat],
+				   tx_stat);
+		stat++;
 	}
 
 	return err;
-- 
2.17.1

