Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC75340795
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhCROQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:34 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55056 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231422AbhCROQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IEF9f3027309;
        Thu, 18 Mar 2021 07:16:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=SZ+UGxkXbFpkA2KcPzRUnYIYyf9aSNpAYvUcq6OsUJ8=;
 b=S/knhGN9d66jNyF6yOt4n4M7dKkgT1j90qMtJLlU8WN6OBLzcquoY2FEll9mVpH/XMmj
 i1QY1reOatFzzM0d4DRQ5TggeL/N0R3mKIDRzn9oEmOF1AX+eUh9LxFVv69ATVnHYVp6
 2iOE5WG1BCEzPpmvkPSrP91e7r4buVv5WlQgyw2kML0A5wQUL4HJ8NdA6ufrb7f51KrR
 7+0yVMOD+9qFDAztFhBlirBYz4/ZY3dN2h3EcIV89j5wfCUeelmRQujzaQQikKQ5RHox
 lNYbvyIdyrZwouwQDX0Cdt5+neGeWsvrkPgWxElnvJsYyTQCzoaz67clqpMoZznf5/Rw yw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 37b5vdpkat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 07:16:02 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Mar
 2021 07:16:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 18 Mar 2021 07:16:01 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id DF5663F7040;
        Thu, 18 Mar 2021 07:15:57 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [net PATCH v2 2/8] octeontx2-af: Formatting debugfs entry rsrc_alloc.
Date:   Thu, 18 Mar 2021 19:45:43 +0530
Message-ID: <20210318141549.2622-3-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210318141549.2622-1-hkelam@marvell.com>
References: <20210318141549.2622-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_07:2021-03-17,2021-03-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Babu <rsaladi2@marvell.com>

With the existing rsrc_alloc's format, there is misalignment for the
pcifunc entries whose VF's index is a double digit. This patch fixes
this.

    pcifunc     NPA         NIX0        NIX1        SSO GROUP   SSOWS
    TIM         CPT0        CPT1        REE0        REE1
    PF0:VF0     8           5
    PF0:VF1     9                       3
    PF0:VF10    18          10
    PF0:VF11    19                      8
    PF0:VF12    20          11
    PF0:VF13    21                      9
    PF0:VF14    22          12
    PF0:VF15    23                      10
    PF1         0           0

Fixes: 23205e6d06d4 ("octeontx2-af: Dump current resource provisioning status")
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../marvell/octeontx2/af/rvu_debugfs.c        | 46 ++++++++++++-------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index aa2ca8780b9..dc946953af0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -234,12 +234,14 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 					  char __user *buffer,
 					  size_t count, loff_t *ppos)
 {
-	int index, off = 0, flag = 0, go_back = 0, off_prev;
+	int index, off = 0, flag = 0, go_back = 0, len = 0;
 	struct rvu *rvu = filp->private_data;
 	int lf, pf, vf, pcifunc;
 	struct rvu_block block;
 	int bytes_not_copied;
+	int lf_str_size = 12;
 	int buf_size = 2048;
+	char *lfs;
 	char *buf;
 
 	/* don't allow partial reads */
@@ -249,12 +251,18 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 	buf = kzalloc(buf_size, GFP_KERNEL);
 	if (!buf)
 		return -ENOSPC;
-	off +=	scnprintf(&buf[off], buf_size - 1 - off, "\npcifunc\t\t");
+
+	lfs = kzalloc(lf_str_size, GFP_KERNEL);
+	if (!lfs)
+		return -ENOMEM;
+	off +=	scnprintf(&buf[off], buf_size - 1 - off, "%-*s", lf_str_size,
+			  "pcifunc");
 	for (index = 0; index < BLK_COUNT; index++)
-		if (strlen(rvu->hw->block[index].name))
-			off +=	scnprintf(&buf[off], buf_size - 1 - off,
-					  "%*s\t", (index - 1) * 2,
-					  rvu->hw->block[index].name);
+		if (strlen(rvu->hw->block[index].name)) {
+			off += scnprintf(&buf[off], buf_size - 1 - off,
+					 "%-*s", lf_str_size,
+					 rvu->hw->block[index].name);
+		}
 	off += scnprintf(&buf[off], buf_size - 1 - off, "\n");
 	for (pf = 0; pf < rvu->hw->total_pfs; pf++) {
 		for (vf = 0; vf <= rvu->hw->total_vfs; vf++) {
@@ -263,14 +271,15 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 				continue;
 
 			if (vf) {
+				sprintf(lfs, "PF%d:VF%d", pf, vf - 1);
 				go_back = scnprintf(&buf[off],
 						    buf_size - 1 - off,
-						    "PF%d:VF%d\t\t", pf,
-						    vf - 1);
+						    "%-*s", lf_str_size, lfs);
 			} else {
+				sprintf(lfs, "PF%d", pf);
 				go_back = scnprintf(&buf[off],
 						    buf_size - 1 - off,
-						    "PF%d\t\t", pf);
+						    "%-*s", lf_str_size, lfs);
 			}
 
 			off += go_back;
@@ -278,20 +287,22 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 				block = rvu->hw->block[index];
 				if (!strlen(block.name))
 					continue;
-				off_prev = off;
+				len = 0;
+				lfs[len] = '\0';
 				for (lf = 0; lf < block.lf.max; lf++) {
 					if (block.fn_map[lf] != pcifunc)
 						continue;
 					flag = 1;
-					off += scnprintf(&buf[off], buf_size - 1
-							- off, "%3d,", lf);
+					len += sprintf(&lfs[len], "%d,", lf);
 				}
-				if (flag && off_prev != off)
-					off--;
-				else
-					go_back++;
+
+				if (flag)
+					len--;
+				lfs[len] = '\0';
 				off += scnprintf(&buf[off], buf_size - 1 - off,
-						"\t");
+						 "%-*s", lf_str_size, lfs);
+				if (!strlen(lfs))
+					go_back += lf_str_size;
 			}
 			if (!flag)
 				off -= go_back;
@@ -303,6 +314,7 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 	}
 
 	bytes_not_copied = copy_to_user(buffer, buf, off);
+	kfree(lfs);
 	kfree(buf);
 
 	if (bytes_not_copied)
-- 
2.17.1

