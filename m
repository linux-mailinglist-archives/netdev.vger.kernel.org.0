Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBEC3817D7
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbhEOK4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:56:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3539 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbhEOKzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:47 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jh4Y9dzsR9L;
        Sat, 15 May 2021 18:51:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:25 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Jon Ringle <jringle@gridpoint.com>
Subject: [PATCH 14/34] net: microchip: Demote non-compliant kernel-doc headers
Date:   Sat, 15 May 2021 18:53:39 +0800
Message-ID: <1621076039-53986-15-git-send-email-shenyang39@huawei.com>
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

 drivers/net/ethernet/microchip/encx24j600.c:3: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Cc: Jon Ringle <jringle@gridpoint.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/microchip/encx24j600.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/encx24j600.c b/drivers/net/ethernet/microchip/encx24j600.c
index 3658c4ae..ee921a9 100644
--- a/drivers/net/ethernet/microchip/encx24j600.c
+++ b/drivers/net/ethernet/microchip/encx24j600.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/**
+/*
  * Microchip ENCX24J600 ethernet driver
  *
  * Copyright (C) 2015 Gridpoint
-- 
2.7.4

