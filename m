Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E74320DD3D
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgF2SjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:39:20 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32568 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726120AbgF2SjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:39:16 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05TB5ghl029788;
        Mon, 29 Jun 2020 04:06:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=NtX0T5CFmELPfbKTe7Qime63AOwMwqjGySKmn+kwvHc=;
 b=ppw5zcIiv9W6p4ZDPDrlZW4dtW+EDq0/v9pGFoEmYdZOyVS2Ulei8NjEC2yPCOp5oWjs
 bx7RCv8IaW8gdoZUomUXostcTG/8SL5crg7+kv2OlVgKb3kY85Uhf4rrjccL3Hv2qH8z
 bBqQ/XuFrfLaQGu/n9dai9C1br3CPh8XRNTcKPTCexVmTiF2RXF11zyfvMUTwirEj/cb
 7x4uQbzXJlzjOg6awPYxsOPvEh3S+rXR62o2PzJEFrkVaqtmo4ySRhkDc1EfvKONYEwu
 vY2mfXk2lSPcLfPS3sXLXAckYEZoyWFoj6vSo5PcDAlHT4xjv1aWF+g29+46mv2cIMq+ vQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 31y0wrtg06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Jun 2020 04:06:20 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Jun
 2020 04:06:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 29 Jun 2020 04:06:19 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 0E41B3F703F;
        Mon, 29 Jun 2020 04:06:15 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 6/6] net: qede: update copyright years
Date:   Mon, 29 Jun 2020 14:05:12 +0300
Message-ID: <20200629110512.1812-7-alobakin@marvell.com>
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

Set the actual copyright holder and years in all qede source files.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/Makefile       | 1 +
 drivers/net/ethernet/qlogic/qede/qede.h         | 1 +
 drivers/net/ethernet/qlogic/qede/qede_dcbnl.c   | 5 +++--
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c | 1 +
 drivers/net/ethernet/qlogic/qede/qede_filter.c  | 1 +
 drivers/net/ethernet/qlogic/qede/qede_fp.c      | 1 +
 drivers/net/ethernet/qlogic/qede/qede_main.c    | 1 +
 drivers/net/ethernet/qlogic/qede/qede_ptp.c     | 1 +
 drivers/net/ethernet/qlogic/qede/qede_ptp.h     | 1 +
 drivers/net/ethernet/qlogic/qede/qede_rdma.c    | 1 +
 10 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/Makefile b/drivers/net/ethernet/qlogic/qede/Makefile
index 1d26ffc82290..a6e8d9fc8832 100644
--- a/drivers/net/ethernet/qlogic/qede/Makefile
+++ b/drivers/net/ethernet/qlogic/qede/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+# Copyright (c) 2019-2020 Marvell International Ltd.
 
 obj-$(CONFIG_QEDE) := qede.o
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 8567f295a12f..591dd4051d06 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qede NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QEDE_H_
diff --git a/drivers/net/ethernet/qlogic/qede/qede_dcbnl.c b/drivers/net/ethernet/qlogic/qede/qede_dcbnl.c
index f6b7ee51e056..2763369bbc61 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_dcbnl.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_dcbnl.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qede NIC Driver
-* Copyright (c) 2015 QLogic Corporation
-*/
+ * Copyright (c) 2015 QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
+ */
 
 #include <linux/types.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 26acfb380dc3..d3fc7403d095 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qede NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/version.h>
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index e03d6a957ceb..db17a675bd02 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qede NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/netdevice.h>
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index c21d4c53121b..1c4ece0713f8 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qede NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/netdevice.h>
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 01c20b2d81e2..8cd27f8f1b3a 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qede NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/crash_dump.h>
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ptp.c b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
index 797ce187d683..60a29a937a94 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ptp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qede NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include "qede_ptp.h"
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ptp.h b/drivers/net/ethernet/qlogic/qede/qede_ptp.h
index 00ff981efa66..1db0f021c645 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ptp.h
+++ b/drivers/net/ethernet/qlogic/qede/qede_ptp.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /* QLogic qede NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef _QEDE_PTP_H_
diff --git a/drivers/net/ethernet/qlogic/qede/qede_rdma.c b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
index 2228f1d1166f..769ec2f4d0b7 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_rdma.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qedr NIC Driver
  * Copyright (c) 2015-2017  QLogic Corporation
+ * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
 #include <linux/pci.h>
-- 
2.25.1

