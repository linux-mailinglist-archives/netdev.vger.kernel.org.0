Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19E5461679
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbhK2Nfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:35:41 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12982 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232946AbhK2Ndi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:33:38 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1ATBwiGZ010651;
        Mon, 29 Nov 2021 05:30:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=WYmVCkBMX46fQcg8arNMFsnhRxK9+WeGBynRyMaHMyk=;
 b=Ga0Zj8LY/GIqJ08trDMzU0mvHucLPe0gbe5FPw63J1/K6RL/rnx1+zOQ+vS7/Nk5fokO
 2hIsKh/1r6zvLChXsCWhUal8oGgB2FIk7ioHwLVrIjITeb+BXwylrHZ7pvPkEgesNt9z
 wP29q6jUlbcRiXo/yuxlIlJPwRuOvmo16z7aqRztlJ4ZUCyiRQ/hrwJOixXlPzMTPjZS
 XNVJs5LAnoqWDXOI+wPaYBNqbIY+Ytw1OMZ/l7dOFjTQjkCsDOrjINcENrIkvr8D4Ilt
 JHRRf2evygGZ4lYZ0AcAcaHMsm8wjg9GCmhcd4H8nvpCK3uR0TRtz+ScG/1kjjz+Jxc6 Yw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cmgkptk0j-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 05:30:20 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Nov
 2021 05:30:17 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 29 Nov 2021 05:30:17 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 91C3D3F70D8;
        Mon, 29 Nov 2021 05:30:17 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1ATDUHNc016176;
        Mon, 29 Nov 2021 05:30:17 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1ATDUHjv016175;
        Mon, 29 Nov 2021 05:30:17 -0800
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <irusskikh@marvell.com>,
        <dbezrukov@marvell.com>, Sameer Saurabh <ssaurabh@marvell.com>
Subject: [PATCH net 7/7] atlantic: Remove warn trace message.
Date:   Mon, 29 Nov 2021 05:28:29 -0800
Message-ID: <20211129132829.16038-8-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211129132829.16038-1-skalluru@marvell.com>
References: <20211129132829.16038-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: dmlK2D7Ahjeub5CYjDoXWxyk60wjY5oy
X-Proofpoint-GUID: dmlK2D7Ahjeub5CYjDoXWxyk60wjY5oy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_08,2021-11-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameer Saurabh <ssaurabh@marvell.com>

Remove the warn trace message - it's not a correct check here, because
the function can still be called on the device in DOWN state

Fixes: 508f2e3dce454 ("net: atlantic: split rx and tx per-queue stats")
Signed-off-by: Sameer Saurabh <ssaurabh@marvell.com>
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index d281322d7dd2..f4774cf051c9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -362,9 +362,6 @@ unsigned int aq_vec_get_sw_stats(struct aq_vec_s *self, const unsigned int tc, u
 {
 	unsigned int count;
 
-	WARN_ONCE(!aq_vec_is_valid_tc(self, tc),
-		  "Invalid tc %u (#rx=%u, #tx=%u)\n",
-		  tc, self->rx_rings, self->tx_rings);
 	if (!aq_vec_is_valid_tc(self, tc))
 		return 0;
 
-- 
2.27.0

