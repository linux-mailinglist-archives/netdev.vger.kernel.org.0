Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB27120B877
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgFZSlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:41:05 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35934 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725855AbgFZSlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:41:04 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QIf4Sv010743;
        Fri, 26 Jun 2020 11:41:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=j0jNJ+eIxGCrFIIZ7X59ZXlEizEJpqWeh0LzguJjJ6c=;
 b=YCekD8O8rdYKxT5/Z4O1vMNMCttxJVrEQQ5jGDAx0exxrrbxCjep3g/YAH4CBBumsj+c
 dN7U294dcINx65q5o0Uvo6h82hFIOZCvPACPjHkYm1nWsDawhEImH9WbHA5gbmJz+yoe
 iLwzOx7GRnqPrAJHS4FKKxf2DCiEY7TGXdg+jjNt1AoKA7EHunVeWu3O4sVK9O9IAvyM
 VB1Qqo6Pdu9uHxpgDloeI6ZtRH+UYeHOJMW8EorXg4L9O3bKzIJC05ylTzBZLfCXnoba
 Luq1tM7R6o4EAS4EMgLLjGG0h4m1a3BlnQGX7Jb71n69251T3/eIiEZtdvqGjeUt9RiV OQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 31uuqh5u8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 11:41:03 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 11:40:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 26 Jun 2020 11:40:52 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 297093F703F;
        Fri, 26 Jun 2020 11:40:50 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 5/8] net: atlantic: fix typo in aq_ring_tx_clean
Date:   Fri, 26 Jun 2020 21:40:35 +0300
Message-ID: <20200626184038.857-6-irusskikh@marvell.com>
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

This patch fixes a typo in aq_ring_tx_clean.
stats is a union, so the typo doesn't cause any issues, but it's a typo
nonetheless.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 68fdb3994088..b67b24a0d9a6 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
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
 
 /* File aq_ring.c: Definition of functions for Rx/Tx rings. */
@@ -279,7 +280,7 @@ bool aq_ring_tx_clean(struct aq_ring_s *self)
 		}
 
 		if (unlikely(buff->is_eop)) {
-			++self->stats.rx.packets;
+			++self->stats.tx.packets;
 			self->stats.tx.bytes += buff->skb->len;
 
 			dev_kfree_skb_any(buff->skb);
-- 
2.25.1

