Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A5D1458BE
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 16:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgAVP1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 10:27:09 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8176 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729012AbgAVP1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 10:27:03 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00MFQJ8B024737;
        Wed, 22 Jan 2020 07:27:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=rIn/pL/bgT3SVQj8o/m8PxpOVkFAf2a+3x0BDOSWqr4=;
 b=m/3H21pX3gWEi9WON5pjMBYCIMgjnQ3yeqxsq9E0jrY+iNvvSoKpfU/uTFJhr8nNNNI1
 sHHpXjnCfqjxjPUvrvtSGfCKYGIukxgJ9/lvz7FvgOIQf5UvO2J+Yj4ivgkcX0p4CblR
 6O6/KN04Ob8jI1qLv1wPtCj7vE03jVLf+T4Tms28DVkxnOnQN5QxDc6rlf7XMant6Pb+
 yfFB6W5MfiKUH/DS4jYeI2Va+86ckX+WERrQKdx40CFamo4fvBm3sV0JyCIYqO5yTa5u
 GkzXJKr/QuEstYSy9WG0M4ERd8ERO+6or46cehg3sNrAnfABxqNwM53qNcSat4DP/81z jA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xpm9015u2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jan 2020 07:27:02 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jan
 2020 07:27:01 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jan 2020 07:27:01 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 979E83F703F;
        Wed, 22 Jan 2020 07:26:59 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH net-next 14/14] qed: bump driver version
Date:   Wed, 22 Jan 2020 17:26:27 +0200
Message-ID: <20200122152627.14903-15-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200122152627.14903-1-michal.kalderon@marvell.com>
References: <20200122152627.14903-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FW brings along a large set of fixes and features which will be added
at a later phase. This is an adaquete point to bump the driver version.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 8b6d6f884245..c628c4b0b7ba 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -53,7 +53,7 @@
 extern const struct qed_common_ops qed_common_ops_pass;
 
 #define QED_MAJOR_VERSION		8
-#define QED_MINOR_VERSION		37
+#define QED_MINOR_VERSION		42
 #define QED_REVISION_VERSION		0
 #define QED_ENGINEERING_VERSION		20
 
-- 
2.14.5

