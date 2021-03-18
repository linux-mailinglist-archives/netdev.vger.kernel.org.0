Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDCD13407AE
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhCROQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26272 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231571AbhCROQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IEEs2t027855;
        Thu, 18 Mar 2021 07:16:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=kpeSn8v90YEJviX1ovgSy75sqWQAXIWZv+1IaP4SvTI=;
 b=hVW+LTioyKu4Mh7uOZLSj84lm32phJ3xOeOjEBaZjIU5XVZnlGmKzXhUcAz1Qb+Q60c9
 Fa6X/2x4O21N8esMaQiWS4gSpfuZJao48K2kmW8bWu2c2w4/hyTjwiN/w9V3zBhm/bWf
 H0q8XUrn9V41g2lAiCUkwF0M3Z9xZdEo/kN2UCqzszsgRZ/OHRvHk3lf7zrTCHr4q0Jj
 12j7vjx5aiBqClOzXxlGMRt69qVuUxDtL8t76sdItzz37nXYvumddZuzr7zi6tm0qc/A
 ELrQH/JvVIk31rOR/5AANoeVg995WgzuM1A7MVd/dtZT91g9hbjQRKXZWav582Zj0S9I 5A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 37c5bf0q8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 07:16:26 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Mar
 2021 07:16:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 18 Mar 2021 07:16:24 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 244853F703F;
        Thu, 18 Mar 2021 07:16:20 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [net PATCH v2 8/8] octeontx2-af: Fix uninitialized variable warning
Date:   Thu, 18 Mar 2021 19:45:49 +0530
Message-ID: <20210318141549.2622-9-hkelam@marvell.com>
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

From: Subbaraya Sundeep <sbhatta@marvell.com>

Initialize l4_key_offset variable to fix uninitialized
variable compiler warning.

Fixes: b9b7421a01d8 ("octeontx2-af: Support ESP/AH RSS hashing")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index d3000194e2d..3d068b7d46b 100644
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
2.17.1

