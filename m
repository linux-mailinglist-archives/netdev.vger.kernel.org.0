Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A4820D33C
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbgF2S46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:56:58 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46810 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729973AbgF2S4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:56:55 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05TB5U67029745;
        Mon, 29 Jun 2020 04:06:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=pXfcYFlk4yzhecT45c9aGQETTu/YSBhjEE5jo5AaoJQ=;
 b=E16JxOGxxFkXtqxvVcWwweEYNEZbE2ABic/r/Dz9j+YOrqNQLrlTzqi1fzY9NOEcPND9
 tFjAbq9igF275k1tnib9W/cZ+rdmR95OwV82ImxgmbkLwYVc1L3yE5GPl8XdXUUQzvCn
 pIlUyeiv+x1KjZ1/Pg5nISdNn2Qanq013ytLssNZxtzuKa2KUK9unbh/B90eoz5Pfm1E
 3x2WZumsbIx7cIonnbsAVqah7zb9A1rEKxMLJubUq/+VJqgc5fAItnxYUcyBa9yP+7gG
 2EL+uoH95lvCdiFxFxnvd2CL2XiVvmyy7rhBa/vUHwv4980qxUJTT+0sbIvayRp7ugn7 qw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 31y0wrtfyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Jun 2020 04:06:10 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Jun
 2020 04:06:09 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 29 Jun 2020 04:06:08 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id D77493F703F;
        Mon, 29 Jun 2020 04:06:05 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 3/6] net: qed: update copyright years
Date:   Mon, 29 Jun 2020 14:05:09 +0300
Message-ID: <20200629110512.1812-4-alobakin@marvell.com>
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

Set the actual copyright holder and years in all qed source files.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/Makefile            | 1 +
 drivers/net/ethernet/qlogic/qed/qed.h               | 1 +
 drivers/net/ethernet/qlogic/qed/qed_cxt.c           | 1 +
 drivers/net/ethernet/qlogic/qed/qed_cxt.h           | 1 +
 drivers/net/ethernet/qlogic/qed/qed_dcbx.c          | 1 +
 drivers/net/ethernet/qlogic/qed/qed_dcbx.h          | 1 +
 drivers/net/ethernet/qlogic/qed/qed_debug.c         | 1 +
 drivers/net/ethernet/qlogic/qed/qed_debug.h         | 1 +
 drivers/net/ethernet/qlogic/qed/qed_dev.c           | 1 +
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h       | 1 +
 drivers/net/ethernet/qlogic/qed/qed_fcoe.c          | 1 +
 drivers/net/ethernet/qlogic/qed/qed_fcoe.h          | 1 +
 drivers/net/ethernet/qlogic/qed/qed_hsi.h           | 1 +
 drivers/net/ethernet/qlogic/qed/qed_hw.c            | 1 +
 drivers/net/ethernet/qlogic/qed/qed_hw.h            | 1 +
 drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c | 1 +
 drivers/net/ethernet/qlogic/qed/qed_init_ops.c      | 1 +
 drivers/net/ethernet/qlogic/qed/qed_init_ops.h      | 1 +
 drivers/net/ethernet/qlogic/qed/qed_int.c           | 1 +
 drivers/net/ethernet/qlogic/qed/qed_int.h           | 1 +
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c         | 1 +
 drivers/net/ethernet/qlogic/qed/qed_iscsi.h         | 1 +
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c         | 1 +
 drivers/net/ethernet/qlogic/qed/qed_iwarp.h         | 1 +
 drivers/net/ethernet/qlogic/qed/qed_l2.c            | 1 +
 drivers/net/ethernet/qlogic/qed/qed_l2.h            | 1 +
 drivers/net/ethernet/qlogic/qed/qed_ll2.c           | 1 +
 drivers/net/ethernet/qlogic/qed/qed_ll2.h           | 1 +
 drivers/net/ethernet/qlogic/qed/qed_main.c          | 1 +
 drivers/net/ethernet/qlogic/qed/qed_mcp.c           | 1 +
 drivers/net/ethernet/qlogic/qed/qed_mcp.h           | 1 +
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c       | 1 +
 drivers/net/ethernet/qlogic/qed/qed_ooo.c           | 1 +
 drivers/net/ethernet/qlogic/qed/qed_ooo.h           | 1 +
 drivers/net/ethernet/qlogic/qed/qed_ptp.c           | 1 +
 drivers/net/ethernet/qlogic/qed/qed_rdma.c          | 1 +
 drivers/net/ethernet/qlogic/qed/qed_rdma.h          | 1 +
 drivers/net/ethernet/qlogic/qed/qed_reg_addr.h      | 1 +
 drivers/net/ethernet/qlogic/qed/qed_roce.c          | 1 +
 drivers/net/ethernet/qlogic/qed/qed_roce.h          | 1 +
 drivers/net/ethernet/qlogic/qed/qed_selftest.c      | 1 +
 drivers/net/ethernet/qlogic/qed/qed_selftest.h      | 1 +
 drivers/net/ethernet/qlogic/qed/qed_sp.h            | 1 +
 drivers/net/ethernet/qlogic/qed/qed_sp_commands.c   | 1 +
 drivers/net/ethernet/qlogic/qed/qed_spq.c           | 1 +
 drivers/net/ethernet/qlogic/qed/qed_sriov.c         | 1 +
 drivers/net/ethernet/qlogic/qed/qed_sriov.h         | 1 +
 drivers/net/ethernet/qlogic/qed/qed_vf.c            | 1 +
 include/linux/qed/common_hsi.h                      | 1 +
 include/linux/qed/eth_common.h                      | 1 +
 include/linux/qed/fcoe_common.h                     | 1 +
 include/linux/qed/iscsi_common.h                    | 1 +
 include/linux/qed/iwarp_common.h                    | 1 +
 include/linux/qed/qed_chain.h                       | 1 +
 include/linux/qed/qed_eth_if.h                      | 1 +
 include/linux/qed/qed_fcoe_if.h                     | 1 +
 include/linux/qed/qed_if.h                          | 1 +
 include/linux/qed/qed_iov_if.h                      | 1 +
 include/linux/qed/qed_iscsi_if.h                    | 1 +
 include/linux/qed/qed_ll2_if.h                      | 1 +
 include/linux/qed/qed_rdma_if.h                     | 1 +
 include/linux/qed/qede_rdma.h                       | 1 +
 include/linux/qed/rdma_common.h                     | 1 +
 include/linux/qed/roce_common.h                     | 1 +
 include/linux/qed/storage_common.h                  | 1 +
 include/linux/qed/tcp_common.h                      | 1 +
 66 files changed, 66 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/Makefile b/drivers/net/ethernet/qlogic/qed/Makefile
index cee566faba2f..4176bbf2a22b 100644
--- a/drivers/net/ethernet/qlogic/qed/Makefile
+++ b/drivers/net/ethernet/qlogic/qed/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+# Copyright (c) 2019-2020 Marvell International Ltd.
 
 obj-$(CONFIG_QED) := qed.o
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 52130dcbfe4c..68fe745c9b99 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index 3985dd746ca2..e72d25854d79 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.h b/drivers/net/ethernet/qlogic/qed/qed_cxt.h
index 05b28919653a..8b64495f8745 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_CXT_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
index a72523298307..9f16a3a66007 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dcbx.h b/drivers/net/ethernet/qlogic/qed/qed_dcbx.h
index 537d60de4e2b..ba5f3927034c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dcbx.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_dcbx.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_DCBX_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 8b14e6852daf..45cbe1c87106 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015 QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/module.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.h b/drivers/net/ethernet/qlogic/qed/qed_debug.h
index 685696878ec2..e71af82d3200 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015 QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_DEBUGFS_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index fa7c10e8aa7a..74142896b707 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev_api.h b/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
index 1f2122c699cc..395d4932c262 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_DEV_API_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_fcoe.c b/drivers/net/ethernet/qlogic/qed/qed_fcoe.c
index 91d6cdf4abe8..a10e57bba6b9 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_fcoe.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_fcoe.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_fcoe.h b/drivers/net/ethernet/qlogic/qed/qed_fcoe.h
index bf324736c7cb..13c5ccfe06e7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_fcoe.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_fcoe.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_FCOE_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index ebbca7d999a4..d7e70625bdc4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_HSI_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hw.c b/drivers/net/ethernet/qlogic/qed/qed_hw.c
index bdbb8fa8d399..e8c777f30207 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hw.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_hw.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hw.h b/drivers/net/ethernet/qlogic/qed/qed_hw.h
index 68f44b747565..6a61b88b544d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hw.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hw.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_HW_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
index 72ff2e5c5f24..1eb48ea80484 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_ops.c b/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
index 74c425640d67..736702fb81b5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_ops.h b/drivers/net/ethernet/qlogic/qed/qed_init_ops.h
index cf33c41e0952..a573c8921982 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_ops.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_ops.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_INIT_OPS_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index be336d47c934..297983d66e2f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.h b/drivers/net/ethernet/qlogic/qed/qed_int.h
index 6fca82f6c7fa..aea04b121586 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_INT_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
index 164b4d953b67..f9d9e21cb66b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iscsi.h b/drivers/net/ethernet/qlogic/qed/qed_iscsi.h
index 8b6518a31b7e..d6af7ea19bbb 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iscsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_iscsi.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_ISCSI_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index 7fac39744275..b7a0a717ee6d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/if_ether.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.h b/drivers/net/ethernet/qlogic/qed/qed_iwarp.h
index 83ca05cd74d7..c3872cd9457f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_IWARP_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index 750098e60c64..03dc804c92a9 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.h b/drivers/net/ethernet/qlogic/qed/qed_l2.h
index dce39f5a87ca..8eceeebb1a7b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_L2_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 47da6d4e226c..cce6fd27c042 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.h b/drivers/net/ethernet/qlogic/qed/qed_ll2.h
index c0d13bd6c3a6..8356c7d4a193 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_LL2_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index d00335cc145b..0cd6b8bf023a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/stddef.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index c17b140aa7ae..25433d162a54 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index 351a13215ddd..d77b4c262cff 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_MCP_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
index 56b7567d7a60..1dd01e0373ab 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+/* Copyright (c) 2019-2020 Marvell International Ltd. */
 
 #include <linux/types.h>
 #include <asm/byteorder.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ooo.c b/drivers/net/ethernet/qlogic/qed/qed_ooo.c
index d01f91f7f661..88353aa404dc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ooo.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ooo.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ooo.h b/drivers/net/ethernet/qlogic/qed/qed_ooo.h
index 2731c392a3f4..3a7e1b59d6fc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ooo.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_ooo.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_OOO_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ptp.c b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
index f10ddf9d1704..3bd2f8c961c9 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ptp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 9a3541f159dc..59d916693654 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.h b/drivers/net/ethernet/qlogic/qed/qed_rdma.h
index a20397a395cf..fba43adbb68e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_RDMA_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h b/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h
index bdfd90748042..9db22be42476 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef REG_ADDR_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index 1e03d66e33d1..d5db07db65b1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.h b/drivers/net/ethernet/qlogic/qed/qed_roce.h
index 9178904bf0e9..3a4a2d72a826 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_ROCE_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_selftest.c b/drivers/net/ethernet/qlogic/qed/qed_selftest.c
index d24ee1ea8d3c..6e70781ab87c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_selftest.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_selftest.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2016  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/crc32.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_selftest.h b/drivers/net/ethernet/qlogic/qed/qed_selftest.h
index d8121fd39bc1..e27dd9a4547e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_selftest.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_selftest.h
@@ -1,4 +1,5 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+/* Copyright (c) 2019-2020 Marvell International Ltd. */
 
 #ifndef _QED_SELFTEST_API_H
 #define _QED_SELFTEST_API_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp.h b/drivers/net/ethernet/qlogic/qed/qed_sp.h
index 4f646e101074..35539e951bee 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_sp.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_SP_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
index 23d630b37199..745d76d13732 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_spq.c b/drivers/net/ethernet/qlogic/qed/qed_spq.c
index 18c59981cab7..ee89a8f4f585 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_spq.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_spq.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 6d3c6d4f6308..fcf4d82da161 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/etherdevice.h>
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.h b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
index 43dfaf410332..552892c45670 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_SRIOV_H
diff --git a/drivers/net/ethernet/qlogic/qed/qed_vf.c b/drivers/net/ethernet/qlogic/qed/qed_vf.c
index c800f8812492..72a38d53d33f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_vf.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_vf.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/crc32.h>
diff --git a/include/linux/qed/common_hsi.h b/include/linux/qed/common_hsi.h
index 294d01eae5cb..977807e1be53 100644
--- a/include/linux/qed/common_hsi.h
+++ b/include/linux/qed/common_hsi.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2016  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _COMMON_HSI_H
diff --git a/include/linux/qed/eth_common.h b/include/linux/qed/eth_common.h
index a9566ef3c2ce..cd1207ad4ada 100644
--- a/include/linux/qed/eth_common.h
+++ b/include/linux/qed/eth_common.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef __ETH_COMMON__
diff --git a/include/linux/qed/fcoe_common.h b/include/linux/qed/fcoe_common.h
index a669d7d84284..68eda1c21cde 100644
--- a/include/linux/qed/fcoe_common.h
+++ b/include/linux/qed/fcoe_common.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015 QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef __FCOE_COMMON__
diff --git a/include/linux/qed/iscsi_common.h b/include/linux/qed/iscsi_common.h
index 7ca89fb9247f..157019f716f1 100644
--- a/include/linux/qed/iscsi_common.h
+++ b/include/linux/qed/iscsi_common.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef __ISCSI_COMMON__
diff --git a/include/linux/qed/iwarp_common.h b/include/linux/qed/iwarp_common.h
index 23583e644257..14f9e4c0ddd9 100644
--- a/include/linux/qed/iwarp_common.h
+++ b/include/linux/qed/iwarp_common.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef __IWARP_COMMON__
diff --git a/include/linux/qed/qed_chain.h b/include/linux/qed/qed_chain.h
index e6e25197f7cb..92cdc79e5019 100644
--- a/include/linux/qed/qed_chain.h
+++ b/include/linux/qed/qed_chain.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_CHAIN_H
diff --git a/include/linux/qed/qed_eth_if.h b/include/linux/qed/qed_eth_if.h
index 7803dedbcb52..812a4d751163 100644
--- a/include/linux/qed/qed_eth_if.h
+++ b/include/linux/qed/qed_eth_if.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_ETH_IF_H
diff --git a/include/linux/qed/qed_fcoe_if.h b/include/linux/qed/qed_fcoe_if.h
index 65d0317ef67e..16752eca5cbd 100644
--- a/include/linux/qed/qed_fcoe_if.h
+++ b/include/linux/qed/qed_fcoe_if.h
@@ -1,4 +1,5 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+/* Copyright (c) 2019-2020 Marvell International Ltd. */
 
 #ifndef _QED_FCOE_IF_H
 #define _QED_FCOE_IF_H
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 4a36608ff3a8..5ca081cd2ed9 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_IF_H
diff --git a/include/linux/qed/qed_iov_if.h b/include/linux/qed/qed_iov_if.h
index c2ca8196def9..8e31a28e51b9 100644
--- a/include/linux/qed/qed_iov_if.h
+++ b/include/linux/qed/qed_iov_if.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_IOV_IF_H
diff --git a/include/linux/qed/qed_iscsi_if.h b/include/linux/qed/qed_iscsi_if.h
index 89912c6c440c..04180d9af560 100644
--- a/include/linux/qed/qed_iscsi_if.h
+++ b/include/linux/qed/qed_iscsi_if.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_ISCSI_IF_H
diff --git a/include/linux/qed/qed_ll2_if.h b/include/linux/qed/qed_ll2_if.h
index 79cac277e38b..2f64ed79cee9 100644
--- a/include/linux/qed/qed_ll2_if.h
+++ b/include/linux/qed/qed_ll2_if.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_LL2_IF_H
diff --git a/include/linux/qed/qed_rdma_if.h b/include/linux/qed/qed_rdma_if.h
index 041a5b005a82..f464d85e88a4 100644
--- a/include/linux/qed/qed_rdma_if.h
+++ b/include/linux/qed/qed_rdma_if.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QED_RDMA_IF_H
diff --git a/include/linux/qed/qede_rdma.h b/include/linux/qed/qede_rdma.h
index 20ed7f2c55bb..072da2f6da37 100644
--- a/include/linux/qed/qede_rdma.h
+++ b/include/linux/qed/qede_rdma.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qedr NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef QEDE_ROCE_H
diff --git a/include/linux/qed/rdma_common.h b/include/linux/qed/rdma_common.h
index 3e3f01136c06..bab078b25834 100644
--- a/include/linux/qed/rdma_common.h
+++ b/include/linux/qed/rdma_common.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef __RDMA_COMMON__
diff --git a/include/linux/qed/roce_common.h b/include/linux/qed/roce_common.h
index 89065f023813..ccddd7a96b67 100644
--- a/include/linux/qed/roce_common.h
+++ b/include/linux/qed/roce_common.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef __ROCE_COMMON__
diff --git a/include/linux/qed/storage_common.h b/include/linux/qed/storage_common.h
index 34f069c79067..91896e8793bf 100644
--- a/include/linux/qed/storage_common.h
+++ b/include/linux/qed/storage_common.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef __STORAGE_COMMON__
diff --git a/include/linux/qed/tcp_common.h b/include/linux/qed/tcp_common.h
index 925e7cb7a582..2b2c87d10e0a 100644
--- a/include/linux/qed/tcp_common.h
+++ b/include/linux/qed/tcp_common.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qed NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef __TCP_COMMON__
-- 
2.25.1

