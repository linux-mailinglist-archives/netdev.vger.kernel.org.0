Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCF820B87E
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgFZSm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:42:27 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47040 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbgFZSm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:42:27 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QIeCYv018180;
        Fri, 26 Jun 2020 11:42:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=KsQeZ9dN5QqHWI10+ILGNm3AbqqE46rOxnWQN8jXhSs=;
 b=YsLg+k0vlMJocGCUCiMU4lRGA25KUYsA8v9OwTNWPuawnhdRH7EnqDU5L56cM2VXntjU
 Hf9ir03e4v/15YJFleGEsN8rOi6ETuDk99Mh5qPbvWxz/4Chbm/44V4xtc4wCKH4+OvP
 5WAX5BCSqrnfXgSitvUl37uzb+6Y/1Izu4te0Wd1LhoIDDHItCuoAvN8Y0vtaVZL/8iq
 Xhly6hk9liqxoYpjg+LEzedaVbJmaRWP9RAJVdKiFC6gJVQHOz/FotQ1HAfoJPbkD/qC
 Xg3Wpw5SMh3igq+LI42yl3XcEHkEoZ7W2n7lNQMuLGbkveHv0bHKAdpRWemWErzvbxPa CQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 31wa37jrkr-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 11:42:24 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 11:40:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 26 Jun 2020 11:40:54 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 18E3F3F703F;
        Fri, 26 Jun 2020 11:40:52 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bezrukov <dbezrukov@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 6/8] net: atlantic: missing space in a comment in aq_nic.h
Date:   Fri, 26 Jun 2020 21:40:36 +0300
Message-ID: <20200626184038.857-7-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200626184038.857-1-irusskikh@marvell.com>
References: <20200626184038.857-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_10:2020-06-26,2020-06-26 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bezrukov <dbezrukov@marvell.com>

This patch add a missing space in the comment in aq_nic.h

Signed-off-by: Dmitry Bezrukov <dbezrukov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 2ab003065e62..317bfc646f0a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File aq_nic.h: Declaration of common code for NIC. */
@@ -111,7 +112,7 @@ struct aq_hw_rx_fltrs_s {
 	u16                   active_filters;
 	struct aq_hw_rx_fl2   fl2;
 	struct aq_hw_rx_fl3l4 fl3l4;
-	/*filter ether type */
+	/* filter ether type */
 	u8 fet_reserved_count;
 };
 
-- 
2.25.1

