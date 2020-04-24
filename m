Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBE31B6EF9
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgDXH1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:27:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34506 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725898AbgDXH1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:27:49 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O7Qfwd021724;
        Fri, 24 Apr 2020 00:27:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=lzQ5sJ1xV0jEKNQLxIuhl2Fpbw+odOSn7a24efz2Ihk=;
 b=H8SOXZpFLDZwDkY0Bg/bT5dvANnCkpsIkJ1FJgG8QUmtvav0BK+U1tn7nPbG8lmFSD5y
 Hxn59MB/4ta70a3JHCUb7CHW7z+o2mFlJLiJ28zpiRfwJyYr+VEYTsi1ZniFuecZFUF1
 ZnpTrYjFC/fDWnwLzJ0BRbN/hSEeGzB+J1rnj6Od/+3tqLVRs/nrdUwbMUnl1hw5+5MI
 8fUSoMykIu/ciXp5ECznUAjVUvG2c6cdh/30atyjk+WGPXJ7ocAYI6OXL2UImfqVCyC0
 qWi8bwtB8Nqi+wNGQu4YiXUkfTY7d5rsK8usdJPSdl80wKPR5c4qNp4q2plbx3IMs47F rA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsb46e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 00:27:46 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:27:45 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:27:44 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 00:27:44 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 5EFB03F7040;
        Fri, 24 Apr 2020 00:27:42 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 01/17] net: atlantic: update company name in the driver description
Date:   Fri, 24 Apr 2020 10:27:13 +0300
Message-ID: <20200424072729.953-2-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200424072729.953-1-irusskikh@marvell.com>
References: <20200424072729.953-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_02:2020-04-23,2020-04-24 signatures=0
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
2.17.1

