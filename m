Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA01C4812F
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 13:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfFQLqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 07:46:10 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41044 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726599AbfFQLqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 07:46:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HBk6DT000474;
        Mon, 17 Jun 2019 04:46:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=O7wx8IuykDT9a2Gl8vZjczajcpF0qh52XQTlnMnVAss=;
 b=h6sPkEg5uaR/ESVtPXayztxYuthfWYpidXUtEuvq5Mby/XI1Xvv8lZHzJLovfTwHKHyw
 R6wNAr+bMVIq+cr8nNFWIotvrWntP5a7TZqYfCYKVa95jZR6xHJWpOoSZ2tB/HD8VfRT
 Kp8KDug9vGv1YVly5cOe4wdznnNElbEzZQ+QKukwkR7wP12A4NlL2tAcnnnDIXNZzntB
 cdTT1m/IpUrmBP1bgjEuSLxC57s7Hohvun/kjo48G4tW8Sv0QICpD0fgJP4Kmk8Czpva
 lTBAgro8RucXLH/sVBcV63+YHOc5tsHSMPbVh8kGRXR33yRM1jP7UQR5eLsN073lXlsx kQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2t506hxdr9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Jun 2019 04:46:07 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 17 Jun
 2019 04:46:05 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 17 Jun 2019 04:46:05 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8C1943F703F;
        Mon, 17 Jun 2019 04:46:05 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x5HBk5Mr017143;
        Mon, 17 Jun 2019 04:46:05 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x5HBk5gD017142;
        Mon, 17 Jun 2019 04:46:05 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 3/4] qed: Add new file for devlink implementation.
Date:   Mon, 17 Jun 2019 04:45:27 -0700
Message-ID: <20190617114528.17086-4-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190617114528.17086-1-skalluru@marvell.com>
References: <20190617114528.17086-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_06:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch introduces new files for qed devlink implementation.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/Makefile      |   3 +-
 drivers/net/ethernet/qlogic/qed/qed_devlink.c |  97 ++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_devlink.h |  18 +++++
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 102 +-------------------------
 4 files changed, 118 insertions(+), 102 deletions(-)
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_devlink.c
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_devlink.h

diff --git a/drivers/net/ethernet/qlogic/qed/Makefile b/drivers/net/ethernet/qlogic/qed/Makefile
index a0acb94..2e9f3cc 100644
--- a/drivers/net/ethernet/qlogic/qed/Makefile
+++ b/drivers/net/ethernet/qlogic/qed/Makefile
@@ -3,7 +3,8 @@ obj-$(CONFIG_QED) := qed.o
 
 qed-y := qed_cxt.o qed_dev.o qed_hw.o qed_init_fw_funcs.o qed_init_ops.o \
 	 qed_int.o qed_main.o qed_mcp.o qed_sp_commands.o qed_spq.o qed_l2.o \
-	 qed_selftest.o qed_dcbx.o qed_debug.o qed_ptp.o qed_mng_tlv.o
+	 qed_selftest.o qed_dcbx.o qed_debug.o qed_ptp.o qed_mng_tlv.o \
+	 qed_devlink.o
 qed-$(CONFIG_QED_SRIOV) += qed_sriov.o qed_vf.o
 qed-$(CONFIG_QED_LL2) += qed_ll2.o
 qed-$(CONFIG_QED_RDMA) += qed_roce.o qed_rdma.o qed_iwarp.o
diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
new file mode 100644
index 0000000..acb6c87
--- /dev/null
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <net/devlink.h>
+#include "qed.h"
+#include "qed_devlink.h"
+#include "qed_mcp.h"
+
+static int qed_dl_param_get(struct devlink *dl, u32 id,
+			    struct devlink_param_gset_ctx *ctx)
+{
+	struct qed_devlink *qed_dl;
+	struct qed_dev *cdev;
+
+	qed_dl = devlink_priv(dl);
+	cdev = qed_dl->cdev;
+	ctx->val.vbool = cdev->iwarp_cmt;
+
+	return 0;
+}
+
+static int qed_dl_param_set(struct devlink *dl, u32 id,
+			    struct devlink_param_gset_ctx *ctx)
+{
+	struct qed_devlink *qed_dl;
+	struct qed_dev *cdev;
+
+	qed_dl = devlink_priv(dl);
+	cdev = qed_dl->cdev;
+	cdev->iwarp_cmt = ctx->val.vbool;
+
+	return 0;
+}
+
+static const struct devlink_param qed_devlink_params[] = {
+	DEVLINK_PARAM_DRIVER(QED_DEVLINK_PARAM_ID_IWARP_CMT,
+			     "iwarp_cmt", DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     qed_dl_param_get, qed_dl_param_set, NULL),
+};
+
+static const struct devlink_ops qed_dl_ops;
+
+int qed_devlink_register(struct qed_dev *cdev)
+{
+	union devlink_param_value value;
+	struct qed_devlink *qed_dl;
+	struct devlink *dl;
+	int rc;
+
+	dl = devlink_alloc(&qed_dl_ops, sizeof(*qed_dl));
+	if (!dl)
+		return -ENOMEM;
+
+	qed_dl = devlink_priv(dl);
+
+	cdev->dl = dl;
+	qed_dl->cdev = cdev;
+
+	rc = devlink_register(dl, &cdev->pdev->dev);
+	if (rc)
+		goto err_free;
+
+	rc = devlink_params_register(dl, qed_devlink_params,
+				     ARRAY_SIZE(qed_devlink_params));
+	if (rc)
+		goto err_unregister;
+
+	value.vbool = false;
+	devlink_param_driverinit_value_set(dl,
+					   QED_DEVLINK_PARAM_ID_IWARP_CMT,
+					   value);
+
+	devlink_params_publish(dl);
+	cdev->iwarp_cmt = false;
+
+	return 0;
+
+err_unregister:
+	devlink_unregister(dl);
+
+err_free:
+	cdev->dl = NULL;
+	devlink_free(dl);
+
+	return rc;
+}
+
+void qed_devlink_unregister(struct qed_dev *cdev)
+{
+	if (!cdev->dl)
+		return;
+
+	devlink_params_unregister(cdev->dl, qed_devlink_params,
+				  ARRAY_SIZE(qed_devlink_params));
+
+	devlink_unregister(cdev->dl);
+	devlink_free(cdev->dl);
+}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.h b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
new file mode 100644
index 0000000..86e1caa
--- /dev/null
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _QED_DEVLINK_H
+#define _QED_DEVLINK_H
+#include "qed.h"
+
+struct qed_devlink {
+	struct qed_dev *cdev;
+};
+
+enum qed_devlink_param_id {
+	QED_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	QED_DEVLINK_PARAM_ID_IWARP_CMT,
+};
+
+int qed_devlink_register(struct qed_dev *cdev);
+void qed_devlink_unregister(struct qed_dev *cdev);
+
+#endif
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index fdd84f5..e3a8754 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -63,6 +63,7 @@
 #include "qed_hw.h"
 #include "qed_selftest.h"
 #include "qed_debug.h"
+#include "qed_devlink.h"
 
 #define QED_ROCE_QPS			(8192)
 #define QED_ROCE_DPIS			(8)
@@ -343,107 +344,6 @@ static int qed_set_power_state(struct qed_dev *cdev, pci_power_t state)
 	return 0;
 }
 
-struct qed_devlink {
-	struct qed_dev *cdev;
-};
-
-enum qed_devlink_param_id {
-	QED_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
-	QED_DEVLINK_PARAM_ID_IWARP_CMT,
-};
-
-static int qed_dl_param_get(struct devlink *dl, u32 id,
-			    struct devlink_param_gset_ctx *ctx)
-{
-	struct qed_devlink *qed_dl;
-	struct qed_dev *cdev;
-
-	qed_dl = devlink_priv(dl);
-	cdev = qed_dl->cdev;
-	ctx->val.vbool = cdev->iwarp_cmt;
-
-	return 0;
-}
-
-static int qed_dl_param_set(struct devlink *dl, u32 id,
-			    struct devlink_param_gset_ctx *ctx)
-{
-	struct qed_devlink *qed_dl;
-	struct qed_dev *cdev;
-
-	qed_dl = devlink_priv(dl);
-	cdev = qed_dl->cdev;
-	cdev->iwarp_cmt = ctx->val.vbool;
-
-	return 0;
-}
-
-static const struct devlink_param qed_devlink_params[] = {
-	DEVLINK_PARAM_DRIVER(QED_DEVLINK_PARAM_ID_IWARP_CMT,
-			     "iwarp_cmt", DEVLINK_PARAM_TYPE_BOOL,
-			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
-			     qed_dl_param_get, qed_dl_param_set, NULL),
-};
-
-static const struct devlink_ops qed_dl_ops;
-
-static int qed_devlink_register(struct qed_dev *cdev)
-{
-	union devlink_param_value value;
-	struct qed_devlink *qed_dl;
-	struct devlink *dl;
-	int rc;
-
-	dl = devlink_alloc(&qed_dl_ops, sizeof(*qed_dl));
-	if (!dl)
-		return -ENOMEM;
-
-	qed_dl = devlink_priv(dl);
-
-	cdev->dl = dl;
-	qed_dl->cdev = cdev;
-
-	rc = devlink_register(dl, &cdev->pdev->dev);
-	if (rc)
-		goto err_free;
-
-	rc = devlink_params_register(dl, qed_devlink_params,
-				     ARRAY_SIZE(qed_devlink_params));
-	if (rc)
-		goto err_unregister;
-
-	value.vbool = false;
-	devlink_param_driverinit_value_set(dl,
-					   QED_DEVLINK_PARAM_ID_IWARP_CMT,
-					   value);
-
-	devlink_params_publish(dl);
-	cdev->iwarp_cmt = false;
-
-	return 0;
-
-err_unregister:
-	devlink_unregister(dl);
-
-err_free:
-	cdev->dl = NULL;
-	devlink_free(dl);
-
-	return rc;
-}
-
-static void qed_devlink_unregister(struct qed_dev *cdev)
-{
-	if (!cdev->dl)
-		return;
-
-	devlink_params_unregister(cdev->dl, qed_devlink_params,
-				  ARRAY_SIZE(qed_devlink_params));
-
-	devlink_unregister(cdev->dl);
-	devlink_free(cdev->dl);
-}
-
 /* probing */
 static struct qed_dev *qed_probe(struct pci_dev *pdev,
 				 struct qed_probe_params *params)
-- 
1.8.3.1

