Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196391C6F70
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgEFLe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:34:27 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35426 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727940AbgEFLeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:34:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046BXfMs011164;
        Wed, 6 May 2020 04:34:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=9WQlIkhrKQD1xazHU2HslZIiKo7E0Lul5qopz3Q3g14=;
 b=lasdXtTKgyU+Ods4s/RfOgoRWiDSXiEtf9aW44QwBih8/FfRCLeKro3brSTXa6O52u5i
 rCN92udEJ09/mrmOgBBZfFe7ZgX8B9xvpi0ntHP2qUwvyLVqqFNa9Bn75HzbfLUJikpE
 tUJFdCG5MLnR88qAM5CnqtwVsMEjbFeuPKDjlgUp5ls3XVhCCULYzIVxWtCGMOEzyt/7
 5j0yk35aTeNtgcIXxUI5C1/OsV5pCuRPRkf8qwagFYDYM5JjbxaTN2mHIV9Fm+tT9eGm
 7f4c8qeBMVBE2EW2yCGhI6xBVRTaXix0Zg5/dBTP/03NGfQwvJ8bqG94BhFZWH4+rSab qA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 30uaukvqnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 04:34:24 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 6 May
 2020 04:34:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 6 May 2020 04:34:22 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 7FB2A3F703F;
        Wed,  6 May 2020 04:34:19 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net-next 12/12] net: qed: fix bad formatting
Date:   Wed, 6 May 2020 14:33:14 +0300
Message-ID: <b22da6629c37b0ebec5a917ecf9c7544bca4b24e.1588758464.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588758463.git.irusskikh@marvell.com>
References: <cover.1588758463.git.irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_05:2020-05-05,2020-05-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some adjacent code, fix bad code formatting

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 include/linux/qed/qed_if.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 7b47fd7b77e2..2f58a9b722a8 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -821,12 +821,11 @@ enum qed_nvm_flash_cmd {
 
 struct qed_common_cb_ops {
 	void (*arfs_filter_op)(void *dev, void *fltr, u8 fw_rc);
-	void	(*link_update)(void			*dev,
-			       struct qed_link_output	*link);
+	void (*link_update)(void *dev, struct qed_link_output *link);
 	void (*schedule_recovery_handler)(void *dev);
 	void (*schedule_hw_err_handler)(void *dev,
 					enum qed_hw_err_type err_type);
-	void	(*dcbx_aen)(void *dev, struct qed_dcbx_get *get, u32 mib_type);
+	void (*dcbx_aen)(void *dev, struct qed_dcbx_get *get, u32 mib_type);
 	void (*get_generic_tlv_data)(void *dev, struct qed_generic_tlvs *data);
 	void (*get_protocol_tlv_data)(void *dev, void *data);
 };
-- 
2.25.1

