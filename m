Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B751B461676
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244849AbhK2Nfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:35:39 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2222 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244761AbhK2Ndh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:33:37 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1ATBwiGX010651;
        Mon, 29 Nov 2021 05:30:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=vP1DnLLv87sT+RUEuQr2gwaH7AXiU1CWNNvXaXg38gQ=;
 b=JYXAa0VZGu9y1IqTYCYTAQ0OzSvpVxAqoTeLvg6InTDC9Aw2SYebPg4Xl6N0LWDwJgI4
 IQw4gNQvh6BJB5mJYZ0JACGrZv5BXugUtCghveX1J9Pd6QXLyeDMJ1b3afrqzZHF00ag
 /B3WKNWtAAugcd4A/jH2yjK1T3q7mwk7q3FiUNjjp4h3kXedoH5k98zIm2XPJWM+2IQK
 0EPURtpPNhnK0tpzid0r1RT9LAOg/soJOLuyIeWbhLkMA1IPnF/3qfPV27ACYBpVdOKe
 AeOxHhIvXoTPaq4K1DgXYrD8yqveZJySO8DEmAsYKZnCz1r+kqkF1WnzQmPRhXNEeyxN Fw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cmgkptk0j-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 05:30:19 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Nov
 2021 05:30:17 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 29 Nov 2021 05:30:17 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 517B33F70C3;
        Mon, 29 Nov 2021 05:30:17 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1ATDUHY8016168;
        Mon, 29 Nov 2021 05:30:17 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1ATDUH8j016167;
        Mon, 29 Nov 2021 05:30:17 -0800
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <irusskikh@marvell.com>,
        <dbezrukov@marvell.com>, Sameer Saurabh <ssaurabh@marvell.com>
Subject: [PATCH net 5/7] Remove Half duplex mode speed capabilities.
Date:   Mon, 29 Nov 2021 05:28:27 -0800
Message-ID: <20211129132829.16038-6-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211129132829.16038-1-skalluru@marvell.com>
References: <20211129132829.16038-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Ej4b7d8hALa6M8AoHPjtd_ny_oh3f6We
X-Proofpoint-GUID: Ej4b7d8hALa6M8AoHPjtd_ny_oh3f6We
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_08,2021-11-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameer Saurabh <ssaurabh@marvell.com>

Since Half Duplex mode has been deprecated by the firmware, driver should
not advertise Half Duplex speed in ethtool support link speed values.

Fixes: 071a02046c262 ("net: atlantic: A2: half duplex support")
Signed-off-by: Sameer Saurabh <ssaurabh@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index 0a28428a0cb7..5dfc751572ed 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -65,11 +65,8 @@ const struct aq_hw_caps_s hw_atl2_caps_aqc113 = {
 			  AQ_NIC_RATE_5G  |
 			  AQ_NIC_RATE_2G5 |
 			  AQ_NIC_RATE_1G  |
-			  AQ_NIC_RATE_1G_HALF   |
 			  AQ_NIC_RATE_100M      |
-			  AQ_NIC_RATE_100M_HALF |
-			  AQ_NIC_RATE_10M       |
-			  AQ_NIC_RATE_10M_HALF,
+			  AQ_NIC_RATE_10M,
 };
 
 const struct aq_hw_caps_s hw_atl2_caps_aqc115c = {
-- 
2.27.0

