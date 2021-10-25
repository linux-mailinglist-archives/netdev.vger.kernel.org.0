Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F4E439F24
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbhJYTRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:17:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23874 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234047AbhJYTRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 15:17:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PFnXo1024367;
        Mon, 25 Oct 2021 12:15:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=qrn3UP3h3iNPkbjwnnb/op4yWi3v3asPOytzREyn+W4=;
 b=kRXc/IU9wCNxFlw3Ayozo0j72+9ZB5BQuz9iaxL+/lpmsnJKx8c6z7+6Ba8mUZEbLXRO
 TGY8W5Q8OnUY2Kexfp5C+1U/pAOJ9222mIqdgKiI4bB2DqLsYqfzYkhkmiEairYtIL2P
 ckZTvs4567hOSgFui7b7rO3wdVdJOAX3SuW2kLdJJr6Daz1AtN6BPytvk34Nh/bx8u2f
 F2DedFvqo9LF7jwz1rAn4bnlOeSU29djWX7lQskzZ1mmRZWTgD21duCQdEzTKdHleFW2
 ki0md9BCCW+bka0P1ij7XPXiz7Jp0r2BLBrC/+IRuwrzcCv1XhaZakdXPbHtV+Vk60qz hg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bwyjg8tsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 12:15:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 25 Oct
 2021 12:15:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 25 Oct 2021 12:15:04 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id CACB63F70CB;
        Mon, 25 Oct 2021 12:15:01 -0700 (PDT)
From:   Rakesh Babu <rsaladi2@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>
CC:     Rakesh Babu <rsaladi2@marvell.com>
Subject: [net-next PATCH 1/3] octeontx2-af: debugfs: Minor changes.
Date:   Tue, 26 Oct 2021 00:44:40 +0530
Message-ID: <20211025191442.10084-2-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211025191442.10084-1-rsaladi2@marvell.com>
References: <20211025191442.10084-1-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 1L7tlWRQno62TQXqZe0N7WRx-VtbjImY
X-Proofpoint-GUID: 1L7tlWRQno62TQXqZe0N7WRx-VtbjImY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_06,2021-10-25_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few changes in rvu_debugfs.c file to remove unwanted characters,
indenting the code etc.

Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../marvell/octeontx2/af/rvu_debugfs.c        | 26 +++++++++----------
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  3 +++
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 9338765da048..54f8fac34215 100644
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
@@ -487,7 +487,7 @@ static ssize_t rvu_dbg_qsize_write(struct file *filp,
 	int ret, lf;
 
 	cmd_buf = memdup_user(buffer, count + 1);
-	if (IS_ERR(cmd_buf))
+	if (IS_ERR_OR_NULL(cmd_buf))
 		return -ENOMEM;
 
 	cmd_buf[count] = '\0';
@@ -504,7 +504,7 @@ static ssize_t rvu_dbg_qsize_write(struct file *filp,
 	if (cmd_buf)
 		ret = -EINVAL;
 
-	if (!strncmp(subtoken, "help", 4) || ret < 0) {
+	if (ret < 0 || !strncmp(subtoken, "help", 4)) {
 		dev_info(rvu->dev, "Use echo <%s-lf > qsize\n", blk_string);
 		goto qsize_write_done;
 	}
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
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 7761dcf17b91..d8b1948aaa0a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2583,6 +2583,9 @@ static void nix_free_tx_vtag_entries(struct rvu *rvu, u16 pcifunc)
 		return;
 
 	nix_hw = get_nix_hw(rvu->hw, blkaddr);
+	if (!nix_hw)
+		return;
+
 	vlan = &nix_hw->txvlan;
 
 	mutex_lock(&vlan->rsrc_lock);
-- 
2.17.1

