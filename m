Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D0333D0D0
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236331AbhCPJ21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:28:27 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25202 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233380AbhCPJ2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:28:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G9QR2u020151;
        Tue, 16 Mar 2021 02:27:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=beTtpW1LAxHA1z76FxzIMnNtJUUnyxNm+MsVZEUyeIs=;
 b=GBK6FHWLiMUcqrDH7HEq16IklUlrx5jnswoV59Kd68k30fgfnu2ruUuCtYqUdXByZRYT
 CM3JrsG/4Ah2VFR0OGDhISI28poirkQXbbiDmB0jjBQMRSDn7GZ++UEWI1I/AIjIIW/g
 jcUFCV1lsV1TxFUH4wf1P2d4HEBZn++JszD0n/umjnbRF2lroKiZgi6kfbL8lr7l3geV
 hteYQQazJHx0Vs5WrBiyEOoLst8dtUZKJGGphAD2Gk4uexo6Fcayofbf78XdLTUiiVBn
 O0Bg77EjyuLZzZg51EcDieblA0cA/vE2COZqrpxaWwd0Ea7uuR6lt4dKaA+eCdBY2zke +g== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0a-0016f401.pphosted.com with ESMTP id 378umtfrcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 02:27:50 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Mar 2021 05:27:48 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Mar 2021 05:27:48 -0400
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id 650443F703F;
        Tue, 16 Mar 2021 02:27:45 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 9/9] octeontx2-af: Fix uninitialized variable warning
Date:   Tue, 16 Mar 2021 14:57:13 +0530
Message-ID: <1615886833-71688-10-git-send-email-hkelam@marvell.com>
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

From: Subbaraya Sundeep <sbhatta@marvell.com>

Initialize l4_key_offset variable to fix uninitialized
variable compiler warning.

Fixes: b9b7421("octeontx2-af: Support ESP/AH RSS hashing")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index d300019..3d068b7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2629,7 +2629,7 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 	struct nix_rx_flowkey_alg *field;
 	struct nix_rx_flowkey_alg tmp;
 	u32 key_type, valid_key;
-	int l4_key_offset;
+	int l4_key_offset = 0;
 
 	if (!alg)
 		return -EINVAL;
-- 
2.7.4

