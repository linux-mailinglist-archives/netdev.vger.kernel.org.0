Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6E6256752
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 13:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgH2L5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 07:57:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10732 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727940AbgH2L4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 07:56:38 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4496D399E81953EE2C57;
        Sat, 29 Aug 2020 19:56:31 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Sat, 29 Aug 2020
 19:56:24 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: dl2k: Remove unused macro DRV_NAME
Date:   Sat, 29 Aug 2020 19:56:23 +0800
Message-ID: <20200829115623.8076-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no caller in tree any more.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/dlink/dl2k.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index be6d8a9ada27..e8e563d6e86b 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -7,7 +7,6 @@
 
 */
 
-#define DRV_NAME	"DL2000/TC902x-based linux driver"
 #include "dl2k.h"
 #include <linux/dma-mapping.h>
 
-- 
2.17.1


