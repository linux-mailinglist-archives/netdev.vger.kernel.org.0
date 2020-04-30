Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98281BF1FF
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgD3IFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:05:10 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54784 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726424AbgD3IFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 04:05:09 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03U852cA011045;
        Thu, 30 Apr 2020 01:05:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=tn9jbC7/ij901B2RkllXfirUysWJSGmhHGBMTo3Hf/g=;
 b=tWCk372iHq8depn6E5k0hrV67dTlw4Nw8I48QtMVq//golD4s09s3QxhUrbPJTYBXnGk
 B8yVg3T4OiNlZDWEJUHZh8ppCB7ccFp7F/Utfnz//Cp3s3eKWB/8R0ec2LIXQUpqaenj
 TifVmaKNR9E8WaxFLnPZsuTOM2HKnWMnyjPFM4Xz2T33lZBWqI6ipwbrfPcW2g2jwZra
 DRxMaob49ohRqaQ5siB4eWXVWEK7vDdpFGKwIjWuLnfPBEsqcW7mv3Z0JpLvMhAyyzAo
 ss1fUJq3QLff8jQ8fDAgWNJyj/EMC+v27Hsnzz2GwOT8/OYBi0d17R+heiQzw4wEgdSJ iA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 30mjjqnshh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 01:05:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Apr
 2020 01:05:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Apr 2020 01:05:07 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 39D843F703F;
        Thu, 30 Apr 2020 01:05:04 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 02/17] net: atlantic: add A2 device IDs
Date:   Thu, 30 Apr 2020 11:04:30 +0300
Message-ID: <20200430080445.1142-3-irusskikh@marvell.com>
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

Adding device ids for the new generation of atlantic nic.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_common.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_common.h b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
index d5beb798bab6..1261e7c7a01e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_common.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
@@ -37,6 +37,13 @@
 #define AQ_DEVICE_ID_AQC111S	0x91B1
 #define AQ_DEVICE_ID_AQC112S	0x92B1
 
+#define AQ_DEVICE_ID_AQC113DEV	0x00C0
+#define AQ_DEVICE_ID_AQC113CS	0x94C0
+#define AQ_DEVICE_ID_AQC114CS	0x93C0
+#define AQ_DEVICE_ID_AQC113	0x04C0
+#define AQ_DEVICE_ID_AQC113C	0x14C0
+#define AQ_DEVICE_ID_AQC115C	0x12C0
+
 #define HW_ATL_NIC_NAME "Marvell (aQuantia) AQtion 10Gbit Network Adapter"
 
 #define AQ_HWREV_ANY	0
-- 
2.20.1

