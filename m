Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4518233D0BD
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbhCPJ1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:27:49 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46636 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232847AbhCPJ12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:27:28 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G9QNKN020140;
        Tue, 16 Mar 2021 02:27:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ROStXfr4gKVq5pQjOHD1ordgPf8xJcc3PdHDqIdLOYY=;
 b=dh33dYNyUEOLz/VZmUttJh2reIvwTOIppkUFVvhJOIMtR8xqqMI4s6JqvkJqvp6g8XEF
 2gh1wBJb37Joh0U1RYAepfVOIaygRJskKzd98k0vUiEZO82xCBxhHOgjW4R2Sw6pKGc5
 TeFAuzY3k9yaRQ7w8TmdKDZ/+OPERT5RSlG9qasj1V2cl/jjF5p2P2f9ZwLx/iA+MAgw
 x8hQcmVIE/S79VNQlB5Hl+dQ68qFapjqe4i6unoLTbgyA31qH9nmmKQLjChI5D3Ow+vY
 4mUGfMZTJqPM4lZFud43PkmspikRmKfq4ISDCUA8VEDV9MRpxLzyXES8zKe6j3gX9M0R fg== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0a-0016f401.pphosted.com with ESMTP id 378umtfrb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 02:27:26 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Mar 2021 05:27:25 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Mar 2021 05:27:24 -0400
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id 9F9863F703F;
        Tue, 16 Mar 2021 02:27:21 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 2/9] octeontx2-af: Formatting debugfs entry rsrc_alloc.
Date:   Tue, 16 Mar 2021 14:57:06 +0530
Message-ID: <1615886833-71688-3-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
References: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_03:2021-03-15,2021-03-16 signatures=0
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

Fixes: 23205e6d("octeontx2-af: Dump current resource provisioning status")
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 46 ++++++++++++++--------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index aa2ca87..dc94695 100644
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
2.7.4

