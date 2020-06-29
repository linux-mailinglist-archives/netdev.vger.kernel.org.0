Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D55F20DD9D
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730723AbgF2TVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:21:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26142 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731293AbgF2TVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:21:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05TB5X2X029757;
        Mon, 29 Jun 2020 04:06:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=3aOA3OUjBLYvL08USywN1kGPx4VsQhFs8Gld/FjshXY=;
 b=wJxsuJFvM40bUiApi3gsZ9gfiLXxlQW6SaJ8qRgQVDeFPpTtCnK8TwQMZpnuMbgkNDw2
 vW4U8xOENP50bJuQtpKTU/9u7SoVng7mPQVsmM6NMqoNlsKwbbxEjB8mtOrhoIf3VJoE
 DxbQauoqBj5wumJd5GxeAp+8Nn7PBz1Dug8eEj+xZXuotXb7qP0KaaLKi5yEb2D1i+P1
 yxkiVPztZFXVpaahna9VbEy7Kgbj95sDQiiXoZUoq8RR1y25lR8+dz0TkZ0PtAeZho2v
 HReRZnkMmwnkt01pMsxcVdCsf2TsFfAWSLZKnZABtdGOPds0nuhZbUe44ngfSmcQ5yAM mA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 31y0wrtfxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Jun 2020 04:06:03 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Jun
 2020 04:06:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 29 Jun 2020 04:06:02 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id D9A3E3F703F;
        Mon, 29 Jun 2020 04:05:58 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 1/6] net: qed: correct existing SPDX tags
Date:   Mon, 29 Jun 2020 14:05:07 +0300
Message-ID: <20200629110512.1812-2-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629110512.1812-1-alobakin@marvell.com>
References: <20200629110512.1812-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-29_11:2020-06-29,2020-06-29 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QLogic QED drivers source code is dual licensed under
GPL-2.0/BSD-3-Clause.
Correct already existing but wrong SPDX tags to match the actual
license.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/Makefile       | 3 ++-
 drivers/net/ethernet/qlogic/qed/qed_debug.c    | 2 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.h    | 2 +-
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c  | 3 ++-
 drivers/net/ethernet/qlogic/qed/qed_selftest.h | 3 ++-
 include/linux/qed/fcoe_common.h                | 2 +-
 include/linux/qed/qed_fcoe_if.h                | 3 ++-
 7 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/Makefile b/drivers/net/ethernet/qlogic/qed/Makefile
index a0acb94d65f0..cee566faba2f 100644
--- a/drivers/net/ethernet/qlogic/qed/Makefile
+++ b/drivers/net/ethernet/qlogic/qed/Makefile
@@ -1,4 +1,5 @@
-# SPDX-License-Identifier: GPL-2.0
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+
 obj-$(CONFIG_QED) := qed.o
 
 qed-y := qed_cxt.o qed_dev.o qed_hw.o qed_init_fw_funcs.o qed_init_ops.o \
diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 81e8fbe4a05b..8b14e6852daf 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0-only
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015 QLogic Corporation
  */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.h b/drivers/net/ethernet/qlogic/qed/qed_debug.h
index edf99d296bd1..685696878ec2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015 QLogic Corporation
  */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
index 6c16158d8090..56b7567d7a60 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
@@ -1,4 +1,5 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+
 #include <linux/types.h>
 #include <asm/byteorder.h>
 #include <linux/bug.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_selftest.h b/drivers/net/ethernet/qlogic/qed/qed_selftest.h
index ad00d082fec8..d8121fd39bc1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_selftest.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_selftest.h
@@ -1,4 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+
 #ifndef _QED_SELFTEST_API_H
 #define _QED_SELFTEST_API_H
 #include <linux/types.h>
diff --git a/include/linux/qed/fcoe_common.h b/include/linux/qed/fcoe_common.h
index 98cfc195abe2..a669d7d84284 100644
--- a/include/linux/qed/fcoe_common.h
+++ b/include/linux/qed/fcoe_common.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015 QLogic Corporation
  */
diff --git a/include/linux/qed/qed_fcoe_if.h b/include/linux/qed/qed_fcoe_if.h
index 46082480a2c3..65d0317ef67e 100644
--- a/include/linux/qed/qed_fcoe_if.h
+++ b/include/linux/qed/qed_fcoe_if.h
@@ -1,4 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+
 #ifndef _QED_FCOE_IF_H
 #define _QED_FCOE_IF_H
 #include <linux/types.h>
-- 
2.25.1

