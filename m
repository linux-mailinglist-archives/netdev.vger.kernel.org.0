Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C1B197494
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 08:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgC3GbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 02:31:07 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35288 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729202AbgC3GbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 02:31:07 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02U6V6ql021924;
        Sun, 29 Mar 2020 23:31:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=7gGr11O9pJ8x+bhlsX0sq/SG/BniIeMo/dlvqZux8FM=;
 b=EK7DFgUs+4OHq1eVb5EtBoWnZ0ZzQGocJSZcsYu3IBg2k3ArtLx1vSl3x611af/YN/a1
 clU4WVV4WsqzP7V4cBRX7j83Vez4N9e/o9fKNZysMMqM0U6AzzV7PahvciXIAX1jpPiB
 Hxll5X+i/Oct44hfguyTCKSKw57SyNKoSlV7abriVD1EoZSmoLsqYcLdMMAkM53ZW8Bh
 +9be3UXN8SgO19ZeSiaAD/wNq/V/rRlxcS8FwwXjWyF5qQ4kUHGXJfIQfwyyMeiawWMs
 XOeuY4o2GyPy80+JbPGtCrcYup1T+iKTH/vjR70vpDSOVrFusF/6SM+xeBt4BujuYGsD Yw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3023xnwdb4-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 29 Mar 2020 23:31:06 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 29 Mar
 2020 23:31:00 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 29 Mar 2020 23:31:00 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 75E423F7040;
        Sun, 29 Mar 2020 23:31:00 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02U6V0QR027376;
        Sun, 29 Mar 2020 23:31:00 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02U6V0sP027375;
        Sun, 29 Mar 2020 23:31:00 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 8/8] qedf: Update the driver version to 8.42.3.5.
Date:   Sun, 29 Mar 2020 23:30:34 -0700
Message-ID: <20200330063034.27309-9-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200330063034.27309-1-skashyap@marvell.com>
References: <20200330063034.27309-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-30_01:2020-03-27,2020-03-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Update version to 8.42.3.5.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_version.h b/drivers/scsi/qedf/qedf_version.h
index b0e37af..7661a5d 100644
--- a/drivers/scsi/qedf/qedf_version.h
+++ b/drivers/scsi/qedf/qedf_version.h
@@ -4,9 +4,9 @@
  *  Copyright (c) 2016-2018 Cavium Inc.
  */
 
-#define QEDF_VERSION		"8.42.3.0"
+#define QEDF_VERSION		"8.42.3.5"
 #define QEDF_DRIVER_MAJOR_VER		8
 #define QEDF_DRIVER_MINOR_VER		42
 #define QEDF_DRIVER_REV_VER		3
-#define QEDF_DRIVER_ENG_VER		0
+#define QEDF_DRIVER_ENG_VER		5
 
-- 
1.8.3.1

