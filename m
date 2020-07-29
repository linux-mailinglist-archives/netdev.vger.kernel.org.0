Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C70C231D81
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 13:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgG2Lj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 07:39:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41636 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726925AbgG2LjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 07:39:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06TBZoRj006457;
        Wed, 29 Jul 2020 04:39:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=70KOka8ZRmIfhDNo0R8U+j0PqZMT5R3kmh62LR4phtU=;
 b=LpAQGbfiKnK3enI4yrpf1PUZwXjhUYzPlJo2pIY78cn4AfsK9HuIHzNYd8ftD67xMEbs
 z7gTkPjgBIdwdc+I8dbmUIfRnOnxI1orQByG2VADAypUgSxde44/7FscMeIztbgNpAih
 qL+tSoGxrRiPS8MP6dbKL50gDt0k6eO/YegTXAQZNLmWElYOcJ0CRaX2LHxXS3lytp1l
 9fmPSPayo/iyPfC6020UEs2Uv6s8exJChcv16DSTz12UzczwT8CoV44A20zGGN57e6PW
 7n0KxRauLp7VVYrqxN0DbHm1daq9sA4Fd782fEHe3JWiyaU6nYgAvjKsdVtFfs3J/EMq iA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 32gj3r0r7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Jul 2020 04:39:23 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 04:39:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 04:39:22 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 382E73F703F;
        Wed, 29 Jul 2020 04:39:19 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v3 net-next 10/11] qed: align adjacent indent
Date:   Wed, 29 Jul 2020 14:38:45 +0300
Message-ID: <20200729113846.1551-11-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200729113846.1551-1-irusskikh@marvell.com>
References: <20200729113846.1551-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_04:2020-07-29,2020-07-29 signatures=0
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

