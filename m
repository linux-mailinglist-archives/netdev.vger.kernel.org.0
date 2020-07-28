Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAD0230602
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgG1I7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 04:59:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:20238 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728505AbgG1I7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 04:59:37 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06S8uNJ5016355;
        Tue, 28 Jul 2020 01:59:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=70KOka8ZRmIfhDNo0R8U+j0PqZMT5R3kmh62LR4phtU=;
 b=iEur9N3PuyhpXwlvi8+hUY+o5iaC37tJBMKdqLGHZ0/FOLQhiGFkcq63xAhiXloVLVU4
 h7M4eebmhWZ3MmtvFV5pLlTi+3XV6iuGM5v/CtLaOIEiQesRuqnv8nX34COwrXj8XDah
 XsJDA6Yz2RX6EtJpcoFRFJQUlSW3cxy/D6BrEXFoPj2RpevQ2o9REl94oAsOxZTwROiP
 quIFXN4b9xV3OTrn9YBXI3TU7bu5tZl8veu9Udr4tgv/56r0fgX5Mo99RlnwCQt8KF7v
 qllmONRsnvR9lSdfOLQy1DnwUdYmcojnZ29RUrJEF9wDMydM37Pr8W0UjKrrsuf+nm4b Og== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 32gm8njhjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Jul 2020 01:59:34 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 28 Jul
 2020 01:59:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 28 Jul 2020 01:59:32 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 693383F703F;
        Tue, 28 Jul 2020 01:59:30 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v2 net-next 10/11] qed: align adjacent indent
Date:   Tue, 28 Jul 2020 11:58:58 +0300
Message-ID: <20200728085859.899-11-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200728085859.899-1-irusskikh@marvell.com>
References: <20200728085859.899-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-28_01:2020-07-28,2020-07-28 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix indent on some of adjacent declarations.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 include/linux/qed/qed_if.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 1297726f2b25..b8fb80c9be80 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -897,14 +897,14 @@ struct qed_common_ops {
 
 	void		(*simd_handler_clean)(struct qed_dev *cdev,
 					      int index);
-	int (*dbg_grc)(struct qed_dev *cdev,
-		       void *buffer, u32 *num_dumped_bytes);
+	int		(*dbg_grc)(struct qed_dev *cdev,
+				   void *buffer, u32 *num_dumped_bytes);
 
-	int (*dbg_grc_size)(struct qed_dev *cdev);
+	int		(*dbg_grc_size)(struct qed_dev *cdev);
 
-	int (*dbg_all_data) (struct qed_dev *cdev, void *buffer);
+	int		(*dbg_all_data)(struct qed_dev *cdev, void *buffer);
 
-	int (*dbg_all_data_size) (struct qed_dev *cdev);
+	int		(*dbg_all_data_size)(struct qed_dev *cdev);
 
 	int		(*report_fatal_error)(struct devlink *devlink,
 					      enum qed_hw_err_type err_type);
-- 
2.17.1

