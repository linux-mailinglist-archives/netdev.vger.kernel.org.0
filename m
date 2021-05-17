Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A608B382600
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235630AbhEQIAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:00:23 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2989 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbhEQIAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:11 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FkBJF6jFBzQpVV;
        Mon, 17 May 2021 15:55:25 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:53 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:53 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>
Subject: [PATCH v2 07/24] net: cadence: Demote non-compliant kernel-doc headers
Date:   Mon, 17 May 2021 12:45:18 +0800
Message-ID: <20210517044535.21473-8-shenyang39@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210517044535.21473-1-shenyang39@huawei.com>
References: <20210517044535.21473-1-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema704-chm.china.huawei.com (10.3.20.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/cadence/macb_pci.c:3: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 drivers/net/ethernet/cadence/macb_ptp.c:3: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/cadence/macb_pci.c | 2 +-
 drivers/net/ethernet/cadence/macb_ptp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
index 353393dea639..8b7b59908a1a 100644
--- a/drivers/net/ethernet/cadence/macb_pci.c
+++ b/drivers/net/ethernet/cadence/macb_pci.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * DOC: Cadence GEM PCI wrapper.
  *
  * Copyright (C) 2016 Cadence Design Systems - https://www.cadence.com
diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index 283918aeb741..5c368a9cbbbc 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * 1588 PTP support for Cadence GEM device.
  *
  * Copyright (C) 2017 Cadence Design Systems - https://www.cadence.com
-- 
2.17.1

