Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936AC24C5EA
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 20:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgHTSxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 14:53:20 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40010 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728034AbgHTSwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 14:52:45 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KIUfAL014446;
        Thu, 20 Aug 2020 11:52:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=70KOka8ZRmIfhDNo0R8U+j0PqZMT5R3kmh62LR4phtU=;
 b=IetIvDr1ZSxNRLVQIF2AjTwgHNdUxn22HxLhidDOgH0W897Xuq7BIi7CPUKHF7uA6W5e
 MW0hCdCYasYzZSpcKSMkoo5q89nlIGFuS3i/URaRfXSTxge3+NVbIHzkAbX+kcPO55vs
 hq5GeSm/8Rb6LZbTYQ9Zt+0OL5vLx/PWysKvdrSo6zahjVpZY0em7FoHhlrABWxZmRPX
 dyvjKVDpCOoCW1QFCkiO9+8ct+VcPUdt06oisi2cMoVkZiWg8u/MsuqASjJCICwCJdC1
 ZVfXBIK495v/nG8tK98b2XFsybsjU8eIK25u+RGP5hsh2KNySDvxLVYbVhLWWB8rhKYq Eg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 3304hhxnwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Aug 2020 11:52:42 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Aug
 2020 11:52:40 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Aug
 2020 11:52:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 20 Aug 2020 11:52:39 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 3CE403F7043;
        Thu, 20 Aug 2020 11:52:37 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v6 net-next 09/10] qed: align adjacent indent
Date:   Thu, 20 Aug 2020 21:52:03 +0300
Message-ID: <20200820185204.652-10-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200820185204.652-1-irusskikh@marvell.com>
References: <20200820185204.652-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
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

