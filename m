Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3CF20D18B
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 20:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgF2Slx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:41:53 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37612 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726990AbgF2Sls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:41:48 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05TB5rnp011065;
        Mon, 29 Jun 2020 04:06:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=E5tA5Jj509A0j/xJfq0Z42Wn1QKuKSifS2wgZV6zkvg=;
 b=MlX1BXGehq3B/Cq6ifarvN6+FSrT7+FFSjLXRi9VVannJ2UA5GGTFZodLwKIRwHBL8wi
 YtLoz2tj6x8Kdc/PqPxKtilGeRP3MnNNuveXbUAz1/o+LAkBCXuqyzqhl2DJtD56SnpQ
 2yGNFE2xOlJTsAiHTKjhEyLPx5Ar7/+FXFI1+0PU7zH1Cf/x87EdFqGzc7n5x443qSVP
 JMdZrL/eW93e3O6GIaHK/SxlU1mdXs7qWYqLKH4FFh0tamg3A1U8j/LiE1l/hBmHJTrf
 LKN4E5IMekT+VnHpCR/wNbQ9YwcGXCRUPLiBnkqIN2zwLMWJUQS4eIqBlHcO+lpEmxAM yA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 31x5mnek8r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Jun 2020 04:06:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Jun
 2020 04:06:12 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Jun
 2020 04:06:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 29 Jun 2020 04:06:12 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 39FEB3F7040;
        Mon, 29 Jun 2020 04:06:08 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 4/6] net: qede: correct existing SPDX tags
Date:   Mon, 29 Jun 2020 14:05:10 +0300
Message-ID: <20200629110512.1812-5-alobakin@marvell.com>
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
 drivers/net/ethernet/qlogic/qede/Makefile     | 3 ++-
 drivers/net/ethernet/qlogic/qede/qede_dcbnl.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/Makefile b/drivers/net/ethernet/qlogic/qede/Makefile
index 3fc91d12413f..1d26ffc82290 100644
--- a/drivers/net/ethernet/qlogic/qede/Makefile
+++ b/drivers/net/ethernet/qlogic/qede/Makefile
@@ -1,4 +1,5 @@
-# SPDX-License-Identifier: GPL-2.0-only
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+
 obj-$(CONFIG_QEDE) := qede.o
 
 qede-y := qede_main.o qede_fp.o qede_filter.o qede_ethtool.o qede_ptp.o
diff --git a/drivers/net/ethernet/qlogic/qede/qede_dcbnl.c b/drivers/net/ethernet/qlogic/qede/qede_dcbnl.c
index e6e844a8cbc7..f6b7ee51e056 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_dcbnl.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_dcbnl.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0-only
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /* QLogic qede NIC Driver
 * Copyright (c) 2015 QLogic Corporation
 */
-- 
2.25.1

