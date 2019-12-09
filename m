Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51691116AC6
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 11:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfLIKTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 05:19:22 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:39762 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfLIKTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 05:19:22 -0500
Received: by mail-yw1-f68.google.com with SMTP id h126so5581545ywc.6;
        Mon, 09 Dec 2019 02:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kfJJcbBCtP2J5q6yO63evUfynsnsxLvvCJ773MPUEuA=;
        b=Ma3N+JtK7nruXZYsUdJNld9kFQdW2aBkcD1kjYbGBX9hAa2s7I+IUzxdCECHUvYuGF
         zGpp/tU4+99lnfPkh34QEDnvnCFUxEgiLR6y805/D4WZF9OWa6InE9G2wEjoPmFZfO4m
         mlUu7oC7sv3HtH7XDJl9eyL8N2Ueek0EBBEhk1/Uh/bsvkIRseP/PK4V9QlvS7x0r92R
         7tUfFGLzdq3ERnzyVE/9QhH6wPByphkk/ZPxCYEl7xMY0jAO9AazE+PZLK+TFAnVS2F8
         Op2HpFBJP0oh+v37w0IdOfio2G+AEHz+s2Kn46jjl2T3zHu+b/wvA5ZKE6OyxGLEIIOM
         kQlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kfJJcbBCtP2J5q6yO63evUfynsnsxLvvCJ773MPUEuA=;
        b=B9qZk2sbX64LYUhhojLvZfCrDs0k2Rs5q6ZYGC7ApV2TNb1/xJLY62Zo8PSXHHJHVg
         BWemom+NnIypFt8q+AuMJuol2iqUejg5ErwfDxBKL+v2bzjGSl3EhECRmLepMekwd5af
         BzRPjMymLtgB4VPiXRkGz8POHcXyVcU+aV7v25OU6wAut9FOz7dDPWKZ3K3vkONXyIOy
         v5hUCrvpxD91AcPHEaJjjbwdLSIKE4RvDLb30xzrHnSWUYxhFvgd3QnA0vOTefLErtGc
         jiiDz1Pc2PCIJKMB3T9ZI4sv169iIGnY4TXZdx0C+RS+0ugwbKMBwqrPtHbc2GKpyAwe
         gR4Q==
X-Gm-Message-State: APjAAAVoYySIJuklMVrnP3mVAgQNF6zO/qgsYb6c8hhIDNDyPYFwesfm
        I369NCqhQtd1zhcjuYj9mVN4qlrc6i/k7g==
X-Google-Smtp-Source: APXvYqybZF5QzKydT/LE1jUr5ytCmmr6NJnb7T7X1akDgzfB6NIg7H27WuB42i7MMYoUAhlqt7QAQA==
X-Received: by 2002:a0d:db49:: with SMTP id d70mr19255094ywe.370.1575886760637;
        Mon, 09 Dec 2019 02:19:20 -0800 (PST)
Received: from karen ([2604:2d80:d68c:d900:c4d5:fc84:cce:f8b4])
        by smtp.gmail.com with ESMTPSA id p133sm2400557ywb.71.2019.12.09.02.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 02:19:20 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: Fix CamelCase in qlge.h and qlge_dbg.c
Date:   Mon,  9 Dec 2019 04:19:08 -0600
Message-Id: <20191209101908.23878-1-schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch addresses CamelCase warnings in qlge.h under struct
mpi_coredump_global_header and mpi_coredump_segment_header. As
well ass addresses CamelCase warnings in qlge_dbg.c when the
structs are used.

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge.h     | 14 +++++++-------
 drivers/staging/qlge/qlge_dbg.c | 20 ++++++++++----------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 6ec7e3ce3863..57884aac308f 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -1627,18 +1627,18 @@ enum {
 #define MPI_COREDUMP_COOKIE 0x5555aaaa
 struct mpi_coredump_global_header {
 	u32	cookie;
-	u8	idString[16];
-	u32	timeLo;
-	u32	timeHi;
-	u32	imageSize;
-	u32	headerSize;
+	u8	id_string[16];
+	u32	time_lo;
+	u32	time_hi;
+	u32	image_size;
+	u32	header_size;
 	u8	info[220];
 };
 
 struct mpi_coredump_segment_header {
 	u32	cookie;
-	u32	segNum;
-	u32	segSize;
+	u32	seg_num;
+	u32	seg_size;
 	u32	extra;
 	u8	description[16];
 };
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 83f34ca43aa4..aac20db565fa 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -702,8 +702,8 @@ static void ql_build_coredump_seg_header(
 {
 	memset(seg_hdr, 0, sizeof(struct mpi_coredump_segment_header));
 	seg_hdr->cookie = MPI_COREDUMP_COOKIE;
-	seg_hdr->segNum = seg_number;
-	seg_hdr->segSize = seg_size;
+	seg_hdr->seg_num = seg_number;
+	seg_hdr->seg_size = seg_size;
 	strncpy(seg_hdr->description, desc, (sizeof(seg_hdr->description)) - 1);
 }
 
@@ -741,12 +741,12 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 	memset(&(mpi_coredump->mpi_global_header), 0,
 	       sizeof(struct mpi_coredump_global_header));
 	mpi_coredump->mpi_global_header.cookie = MPI_COREDUMP_COOKIE;
-	mpi_coredump->mpi_global_header.headerSize =
+	mpi_coredump->mpi_global_header.header_size =
 		sizeof(struct mpi_coredump_global_header);
-	mpi_coredump->mpi_global_header.imageSize =
+	mpi_coredump->mpi_global_header.image_size =
 		sizeof(struct ql_mpi_coredump);
-	strncpy(mpi_coredump->mpi_global_header.idString, "MPI Coredump",
-		sizeof(mpi_coredump->mpi_global_header.idString));
+	strncpy(mpi_coredump->mpi_global_header.id_string, "MPI Coredump",
+		sizeof(mpi_coredump->mpi_global_header.id_string));
 
 	/* Get generic NIC reg dump */
 	ql_build_coredump_seg_header(&mpi_coredump->nic_regs_seg_hdr,
@@ -1231,12 +1231,12 @@ static void ql_gen_reg_dump(struct ql_adapter *qdev,
 	memset(&(mpi_coredump->mpi_global_header), 0,
 	       sizeof(struct mpi_coredump_global_header));
 	mpi_coredump->mpi_global_header.cookie = MPI_COREDUMP_COOKIE;
-	mpi_coredump->mpi_global_header.headerSize =
+	mpi_coredump->mpi_global_header.header_size =
 		sizeof(struct mpi_coredump_global_header);
-	mpi_coredump->mpi_global_header.imageSize =
+	mpi_coredump->mpi_global_header.image_size =
 		sizeof(struct ql_reg_dump);
-	strncpy(mpi_coredump->mpi_global_header.idString, "MPI Coredump",
-		sizeof(mpi_coredump->mpi_global_header.idString));
+	strncpy(mpi_coredump->mpi_global_header.id_string, "MPI Coredump",
+		sizeof(mpi_coredump->mpi_global_header.id_string));
 
 
 	/* segment 16 */
-- 
2.20.1

