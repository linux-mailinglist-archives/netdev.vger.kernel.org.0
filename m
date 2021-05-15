Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5863817DE
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbhEOK5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:57:00 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3545 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbhEOKzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:48 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jh5VFMzsRBH;
        Sat, 15 May 2021 18:51:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:22 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>
Subject: [PATCH 07/34] net: cadence: macb_ptp: Demote non-compliant kernel-doc headers
Date:   Sat, 15 May 2021 18:53:32 +0800
Message-ID: <1621076039-53986-8-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/cadence/macb_ptp.c:3: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/cadence/macb_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index 283918a..5c368a9 100644
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
2.7.4

