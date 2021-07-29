Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314F63DA0C4
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 12:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbhG2KBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 06:01:09 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53992 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231622AbhG2KBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 06:01:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T9oN93015543;
        Thu, 29 Jul 2021 03:00:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=7qkxdV8qf1nb90+5pIEBJ36TVxbUXcm0lZyqdonU0bM=;
 b=DssCtBkjc8kVelpXFKLPhbOy2p2Kae64Gj2qMqIw5V/xRHoPG13z0YBSDZ1DPGPPXgn+
 TKR+dhbjBEEt8QgpFVi0dXUG7bQy7CtW38xFbji9FXcVntC0r1/LoKuI0XZPOKlnY5+P
 OSl9indff5kHUGurnHkP6MpQCiUNIS+OakzdLmILD3eoq4cGItT0whNwW/wCo/WSVyym
 UZbAVfWDzwo1oLvv9VUDlNoy0l9iL2C+lr7uMW2rujm2fegZ63CyFRziYxzPdhBclK+/
 QAtnN1gakuoYULsnFffxKeMyO1WkzXrZzr65NrUfLO1FsGSrlxXMAuLMuDHhhdmVSeqC Fw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3a35pr46x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 03:00:59 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 29 Jul
 2021 03:00:57 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Thu, 29 Jul 2021 03:00:55 -0700
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <malin1024@gmail.com>, <smalin@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: [PATCH] qede: Remove the qede module version
Date:   Thu, 29 Jul 2021 13:00:42 +0300
Message-ID: <20210729100042.10332-1-pkushwaha@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: MTcTF2dvn6yTHompYA_waXiM5Y_mVDLt
X-Proofpoint-GUID: MTcTF2dvn6yTHompYA_waXiM5Y_mVDLt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_09:2021-07-27,2021-07-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shai Malin <smalin@marvell.com>

Removing the qede module version which is not needed and not allowed
with inbox drivers.

Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h         |  9 ---------
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c |  6 +++---
 drivers/net/ethernet/qlogic/qede/qede_main.c    | 10 +---------
 3 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 2e62a2c4eb63..8693117a6180 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -30,15 +30,6 @@
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_gact.h>
 
-#define QEDE_MAJOR_VERSION		8
-#define QEDE_MINOR_VERSION		37
-#define QEDE_REVISION_VERSION		0
-#define QEDE_ENGINEERING_VERSION	20
-#define DRV_MODULE_VERSION __stringify(QEDE_MAJOR_VERSION) "."	\
-		__stringify(QEDE_MINOR_VERSION) "."		\
-		__stringify(QEDE_REVISION_VERSION) "."		\
-		__stringify(QEDE_ENGINEERING_VERSION)
-
 #define DRV_MODULE_SYM		qede
 
 struct qede_stats_common {
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 1560ad3d9290..9c6aa6859646 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -625,13 +625,13 @@ static void qede_get_drvinfo(struct net_device *ndev,
 		 (edev->dev_info.common.mfw_rev >> 8) & 0xFF,
 		 edev->dev_info.common.mfw_rev & 0xFF);
 
-	if ((strlen(storm) + strlen(DRV_MODULE_VERSION) + strlen("[storm]  ")) <
+	if ((strlen(storm) + strlen("[storm]")) <
 	    sizeof(info->version))
 		snprintf(info->version, sizeof(info->version),
-			 "%s [storm %s]", DRV_MODULE_VERSION, storm);
+			 "[storm %s]", storm);
 	else
 		snprintf(info->version, sizeof(info->version),
-			 "%s %s", DRV_MODULE_VERSION, storm);
+			 "%s", storm);
 
 	if (edev->dev_info.common.mbi_version) {
 		snprintf(mbi, ETHTOOL_FWVERS_LEN, "%d.%d.%d",
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 173878696143..033bf2c7f56c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -39,12 +39,8 @@
 #include "qede.h"
 #include "qede_ptp.h"
 
-static char version[] =
-	"QLogic FastLinQ 4xxxx Ethernet Driver qede " DRV_MODULE_VERSION "\n";
-
 MODULE_DESCRIPTION("QLogic FastLinQ 4xxxx Ethernet Driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_MODULE_VERSION);
 
 static uint debug;
 module_param(debug, uint, 0);
@@ -258,7 +254,7 @@ int __init qede_init(void)
 {
 	int ret;
 
-	pr_info("qede_init: %s\n", version);
+	pr_info("qede init: QLogic FastLinQ 4xxxx Ethernet Driver qede\n");
 
 	qede_forced_speed_maps_init();
 
@@ -1150,10 +1146,6 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
 	/* Start the Slowpath-process */
 	memset(&sp_params, 0, sizeof(sp_params));
 	sp_params.int_mode = QED_INT_MODE_MSIX;
-	sp_params.drv_major = QEDE_MAJOR_VERSION;
-	sp_params.drv_minor = QEDE_MINOR_VERSION;
-	sp_params.drv_rev = QEDE_REVISION_VERSION;
-	sp_params.drv_eng = QEDE_ENGINEERING_VERSION;
 	strlcpy(sp_params.name, "qede LAN", QED_DRV_VER_STR_SIZE);
 	rc = qed_ops->common->slowpath_start(cdev, &sp_params);
 	if (rc) {
-- 
2.22.0

