Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A941B6EFA
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgDXH1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:27:52 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38472 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726686AbgDXH1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:27:51 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O7QcKx021618;
        Fri, 24 Apr 2020 00:27:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=2I3SyvikjlGWKKeuM7JQqNozmifbsg/7O3WNEF/sga8=;
 b=ocNn1ZUvkoce/SQTGsV8qh1IG/rkNQTni3wNH32XOhAwWU+FkLAQtNVWUuh8P9IGqu0B
 wRR9W6jYq6dEsQ3eKy/wonxeJ7l9icTGToot62rVNIPktaE8TkK3/bABAVO9ZFjIz/XY
 uWDeb8+BoAvr6SSPk/LyPE2e7/DxKXafWTMihG2yF02O23Qk7GJPyVFXY/GfuYGp79aZ
 EcO12O8RI0Yrr/85t3fDAsaYUaCAUX03z7ABThJfFdlV9nKtOYQjz8XUYd91BiBX89+c
 X8CWHR/uDJyJg4bd+QqwLNxmcq2EeX/gPR6lHJuvPzVBg+2ZSA11+r3FLP7JDE7Asui4 sw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsb46m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 00:27:49 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:27:46 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:27:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 00:27:46 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 8555D3F703F;
        Fri, 24 Apr 2020 00:27:44 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 02/17] net: atlantic: add A2 device IDs
Date:   Fri, 24 Apr 2020 10:27:14 +0300
Message-ID: <20200424072729.953-3-irusskikh@marvell.com>
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
2.17.1

