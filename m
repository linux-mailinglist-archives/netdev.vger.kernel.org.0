Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57D31C8494
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 10:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgEGIPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 04:15:50 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29906 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727825AbgEGIPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 04:15:39 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0478ANZu019653;
        Thu, 7 May 2020 01:15:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=syHoqBmNqOh4cZN7nFTgToX+h5xlAwPXz3MznaXFQ48=;
 b=DdAiRHHczkknNSJ282rHUIHt/4C7mbqQqt63u9YM+eCZAjmspn0pmNO75pt7//gPIimk
 De9xmUTK2+SEfGiqtD4p49oAa0EtVvYsVH3y8Yssvw2FKI/2gRauDemX7TFb7ZD/ogqO
 wyzVNv8zqNOwkFX4Au3AdE5TLZLOGGTDod7QekZI1MsdXWkugBq3WkOzi8fIEtkdn+E9
 i9WyoTtQn6bGQrWvyyb3ikTtrp1j+J29F8xE4hUN/yHrwVOSK378tU+gkAt2dpgN4HHm
 vWwHmDcyAfPiDCVZWT7ANvoPPKqP/0Y9VVFqO8lgkmfP1nJdIkMTXq2rqlIGDlpunhng gg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 30uaum1are-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 01:15:38 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 May
 2020 01:15:37 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 May
 2020 01:15:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 7 May 2020 01:15:36 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 453463F703F;
        Thu,  7 May 2020 01:15:35 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 6/7] net: atlantic: remove check for boot code survivability before reset request
Date:   Thu, 7 May 2020 11:15:09 +0300
Message-ID: <20200507081510.2120-7-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200507081510.2120-1-irusskikh@marvell.com>
References: <20200507081510.2120-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_04:2020-05-05,2020-05-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch removes unnecessary check for boot code survivability before
reset request.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c    | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c
index 85ccc9a011a0..f3766780e975 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c
@@ -75,14 +75,6 @@ int hw_atl2_utils_soft_reset(struct aq_hw_s *self)
 	u32 rbl_request;
 	int err;
 
-	err = readx_poll_timeout_atomic(hw_atl2_mif_mcp_boot_reg_get, self,
-				rbl_status,
-				((rbl_status & AQ_A2_BOOT_STARTED) &&
-				 (rbl_status != 0xFFFFFFFFu)),
-				10, 500000);
-	if (err)
-		aq_pr_trace("Boot code probably hanged, reboot anyway");
-
 	hw_atl2_mif_host_req_int_clr(self, 0x01);
 	rbl_request = AQ_A2_FW_BOOT_REQ_REBOOT;
 #ifdef AQ_CFG_FAST_START
-- 
2.20.1

