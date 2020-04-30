Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3891BF1FE
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgD3IFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:05:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1194 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726420AbgD3IFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 04:05:07 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03U852sf011030;
        Thu, 30 Apr 2020 01:05:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=36DHBbvpmdyzeU+0kyIaccaXvZml36JpwFoe1u6QmWA=;
 b=BW5xRu/G+iwdkq4Wz0I/Gq5zSNkpcJ2ye9TnaS9pSEBgmJN6T3kfFRzxjbzxhQME89Vd
 U9HAfdH/ZVXY5KxcS4vA2gd+LkAWiXCl04incNoTbr74h+V0TtVPskK2EqStJ7zuTcot
 BJ0YqiQTCRMtHYny/Hxv5+i+BQApPgvHRIn/sBI4ZRB6wUdSyYtD1qrVek0R3CvB4VPW
 ItcmfbP10zugIOZJ8cXPG3tnFs0XMvnqxVX5b7Utzo4fo+jFni+9KX1Vr4bsc2o+TqEv
 x2N4Qh/fuL4jQ0Mnj5wPgIyEdCCCyti4EygIvlSuPXda7xLeR6EMw98dVNNy+ikq1EYB 6Q== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 30mjjqnshf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 01:05:06 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Apr
 2020 01:05:05 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Apr
 2020 01:05:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Apr 2020 01:05:05 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 43D883F705B;
        Thu, 30 Apr 2020 01:05:03 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 01/17] net: atlantic: update company name in the driver description
Date:   Thu, 30 Apr 2020 11:04:29 +0300
Message-ID: <20200430080445.1142-2-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430080445.1142-1-irusskikh@marvell.com>
References: <20200430080445.1142-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_02:2020-04-30,2020-04-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aquantia is now part of Marvell. Thus, update the driver description.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_cfg.h    | 4 ++--
 drivers/net/ethernet/aquantia/atlantic/aq_common.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
index 7560f5506e55..52b9833fda99 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
@@ -80,8 +80,8 @@
 
 #define AQ_CFG_LOCK_TRYS   100U
 
-#define AQ_CFG_DRV_AUTHOR      "aQuantia"
-#define AQ_CFG_DRV_DESC        "aQuantia Corporation(R) Network Driver"
+#define AQ_CFG_DRV_AUTHOR      "Marvell"
+#define AQ_CFG_DRV_DESC        "Marvell (Aquantia) Corporation(R) Network Driver"
 #define AQ_CFG_DRV_NAME        "atlantic"
 
 #endif /* AQ_CFG_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_common.h b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
index c8c402b013bb..d5beb798bab6 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_common.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
@@ -37,7 +37,7 @@
 #define AQ_DEVICE_ID_AQC111S	0x91B1
 #define AQ_DEVICE_ID_AQC112S	0x92B1
 
-#define HW_ATL_NIC_NAME "aQuantia AQtion 10Gbit Network Adapter"
+#define HW_ATL_NIC_NAME "Marvell (aQuantia) AQtion 10Gbit Network Adapter"
 
 #define AQ_HWREV_ANY	0
 #define AQ_HWREV_1	1
-- 
2.20.1

