Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571F720B878
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgFZSlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:41:08 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61888 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725906AbgFZSlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:41:05 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QIf4u1010740;
        Fri, 26 Jun 2020 11:41:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=+48dLjDAgGRMReridKRqz6cQc8UBMksUbVHpUJ+0Aio=;
 b=HOCRjNIvjVufk0e4rrsffKTQOndMXnE+iHvFYAsui7KpbdaCtucO+ls8947TSeaAR5Yh
 rRX5or8qwFUO0XRRCbuGQkVKteSARDjPNOFreQFzfu3jOaQON0dQForhqBYayePxUSO+
 9KIz5R+bScSR1PEUwY3tC9fmrLFdi9lU9TCtcqWxn8M5SsilF+BfnI72pWrfUSj2k9EJ
 WP9+nRg2XqxbpftBkTDIeKFqIYJMB0ZHQSwicojICsKVWaaXfomrq1y0qkK7pg9/F3vx
 12BDccQtOK/SG+5nEM9rXbuTJZWwtSUH6fB0lBZzmzUCBHIdhE8lX2hWiisQ/6egCJ5c mA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 31uuqh5u88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 11:41:04 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 11:40:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 26 Jun 2020 11:40:50 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 43B273F7043;
        Fri, 26 Jun 2020 11:40:49 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 4/8] net: atlantic: make aq_pci_func_init static
Date:   Fri, 26 Jun 2020 21:40:34 +0300
Message-ID: <20200626184038.857-5-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200626184038.857-1-irusskikh@marvell.com>
References: <20200626184038.857-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_10:2020-06-26,2020-06-26 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch makes aq_pci_func_init() static, because it's not used anywhere
outside the file itself.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 9 +++++----
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.h | 8 ++++----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 41c0f560f95b..59253846e885 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File aq_pci_func.c: Definition of PCI functions. */
@@ -114,7 +115,7 @@ static int aq_pci_probe_get_hw_by_id(struct pci_dev *pdev,
 	return 0;
 }
 
-int aq_pci_func_init(struct pci_dev *pdev)
+static int aq_pci_func_init(struct pci_dev *pdev)
 {
 	int err;
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.h b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.h
index 77be7ee0d7b3..3fa5f7a73680 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File aq_pci_func.h: Declaration of PCI functions. */
@@ -19,7 +20,6 @@ struct aq_board_revision_s {
 	const struct aq_hw_caps_s *caps;
 };
 
-int aq_pci_func_init(struct pci_dev *pdev);
 int aq_pci_func_alloc_irq(struct aq_nic_s *self, unsigned int i,
 			  char *name, irq_handler_t irq_handler,
 			  void *irq_arg, cpumask_t *affinity_mask);
-- 
2.25.1

