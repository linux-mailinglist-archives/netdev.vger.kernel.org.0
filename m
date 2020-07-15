Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAC022119A
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgGOPtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:49:17 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56316 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727863AbgGOPtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:49:16 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FFf2Lg032730;
        Wed, 15 Jul 2020 08:49:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=MB42ydB4c+ulpjTV6xX8pgW2EJVA3Y0r0e2P76f5ZnI=;
 b=VHceRx0KczkvkGWV04AxGnwpSbvWizsIaEVH4lj4ItPFFXcYO90ioZHijmT0pSZ7VN4k
 ZrLJ5TjbCwSpdyRRLG4m1uRPgNNn3Ueh5KPen2DSgN88AI4sWRyCSEe6PuEKuDK0dQ7j
 9s7pOCqcUpDVqqg5zRo542/w+yoRHRHr4bcYOAeSmnf8qh45U2nIBSf1vILRgCVsSO9S
 UMIAyT3t1KPwxy2SJx3tnKe4yU363P0dNgBmmMVe1JpL3rJCDPeNmxQvSrUobWj35DtR
 +2izqQmCIvRKzIK7TXfIWTX0BmWWG3CQo2+WPQPIHTApRXnzKSpPjug5IwIqtpjhHV68 eQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 327asnja6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 08:49:15 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 08:49:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 08:49:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jul 2020 08:49:13 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id C7BAB3F703F;
        Wed, 15 Jul 2020 08:49:11 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 07/10] net: atlantic: use U32_MAX in aq_hw_utils.c
Date:   Wed, 15 Jul 2020 18:48:39 +0300
Message-ID: <20200715154842.305-8-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715154842.305-1-irusskikh@marvell.com>
References: <20200715154842.305-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_12:2020-07-15,2020-07-15 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch replaces magic constant ~0U usage with U32_MAX in aq_hw_utils.c

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
index ae85c0a7d238..1921741f7311 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
@@ -41,9 +41,8 @@ u32 aq_hw_read_reg(struct aq_hw_s *hw, u32 reg)
 {
 	u32 value = readl(hw->mmio + reg);
 
-	if ((~0U) == value &&
-	    (~0U) == readl(hw->mmio +
-			   hw->aq_nic_cfg->aq_hw_caps->hw_alive_check_addr))
+	if (value == U32_MAX &&
+	    readl(hw->mmio + hw->aq_nic_cfg->aq_hw_caps->hw_alive_check_addr) == U32_MAX)
 		aq_utils_obj_set(&hw->flags, AQ_HW_FLAG_ERR_UNPLUG);
 
 	return value;
-- 
2.25.1

