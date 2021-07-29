Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFEB3DA0C3
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 12:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbhG2KBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 06:01:06 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3744 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235451AbhG2KAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 06:00:51 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T9o5EI015506;
        Thu, 29 Jul 2021 03:00:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=u5hbNnwJ44C0nV37oPwh8nIhua63609vqfFbPdbf7sk=;
 b=jEjWy0j2iEzyxYZpdgDit4xslC1GiaJTNi/UYpVkvOEQwtXiodWLRyNnnOeInCg9W7s2
 Vof5yijRZYZ8VjTkDMz2Bo7JysYeQmhTkFNRRqf9aW3mjfXM5VrTTkCzjI4lY9oUki77
 sAW20w3K3+oLuMxvZzoXMcJg9/I+NHM2Nt9Qgl5PMZzDCCxvLwKd6KtOA7JOO2bpLI3e
 uG1ut7FB3Q5ZqNL13uTSyqvka16VXL2OjoAnE4EoMs1AX8XtVxmsCAoXBfjCjg/3z8M4
 xL/LavBLxgCLKBC88FeYqUgpcBwaFZWfgkCJuv82qc2bBxmH8bFbPUj54m1ujm7wYHiB wQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3a35pr46vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 03:00:30 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 29 Jul
 2021 03:00:28 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Thu, 29 Jul 2021 03:00:26 -0700
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <malin1024@gmail.com>, <smalin@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: [PATCH] qed: Remove the qed module version
Date:   Thu, 29 Jul 2021 13:00:11 +0300
Message-ID: <20210729100011.10090-1-pkushwaha@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Gbp5r_6-IXuqmc0zD0pJdiTc7OyM-BOV
X-Proofpoint-GUID: Gbp5r_6-IXuqmc0zD0pJdiTc7OyM-BOV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_09:2021-07-27,2021-07-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shai Malin <smalin@marvell.com>

Removing the qed module version which is not needed and not allowed
with inbox drivers.

Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h      | 15 ---------------
 drivers/net/ethernet/qlogic/qed/qed_main.c |  3 +--
 drivers/net/ethernet/qlogic/qed/qed_mcp.c  |  1 -
 3 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index b590c70539b5..d58e021614cd 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -26,15 +26,6 @@
 
 extern const struct qed_common_ops qed_common_ops_pass;
 
-#define QED_MAJOR_VERSION		8
-#define QED_MINOR_VERSION		37
-#define QED_REVISION_VERSION		0
-#define QED_ENGINEERING_VERSION		20
-
-#define QED_VERSION						 \
-	((QED_MAJOR_VERSION << 24) | (QED_MINOR_VERSION << 16) | \
-	 (QED_REVISION_VERSION << 8) | QED_ENGINEERING_VERSION)
-
 #define STORM_FW_VERSION				       \
 	((FW_MAJOR_VERSION << 24) | (FW_MINOR_VERSION << 16) | \
 	 (FW_REVISION_VERSION << 8) | FW_ENGINEERING_VERSION)
@@ -517,12 +508,6 @@ enum qed_hsi_def_type {
 	QED_NUM_HSI_DEFS
 };
 
-#define DRV_MODULE_VERSION		      \
-	__stringify(QED_MAJOR_VERSION) "."    \
-	__stringify(QED_MINOR_VERSION) "."    \
-	__stringify(QED_REVISION_VERSION) "." \
-	__stringify(QED_ENGINEERING_VERSION)
-
 struct qed_simd_fp_handler {
 	void	*token;
 	void	(*func)(void *);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 5bd58c65e163..aa48b1b7eddc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -49,11 +49,10 @@
 #define QED_NVM_CFG_MAX_ATTRS		50
 
 static char version[] =
-	"QLogic FastLinQ 4xxxx Core Module qed " DRV_MODULE_VERSION "\n";
+	"QLogic FastLinQ 4xxxx Core Module qed\n";
 
 MODULE_DESCRIPTION("QLogic FastLinQ 4xxxx Core Module");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_MODULE_VERSION);
 
 #define FW_FILE_VERSION				\
 	__stringify(FW_MAJOR_VERSION) "."	\
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 4387292c37e2..6e5a6cc97d0e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -944,7 +944,6 @@ int qed_mcp_load_req(struct qed_hwfn *p_hwfn,
 
 	memset(&in_params, 0, sizeof(in_params));
 	in_params.hsi_ver = QED_LOAD_REQ_HSI_VER_DEFAULT;
-	in_params.drv_ver_0 = QED_VERSION;
 	in_params.drv_ver_1 = qed_get_config_bitmap();
 	in_params.fw_ver = STORM_FW_VERSION;
 	rc = eocre_get_mfw_drv_role(p_hwfn, p_params->drv_role, &mfw_drv_role);
-- 
2.22.0

