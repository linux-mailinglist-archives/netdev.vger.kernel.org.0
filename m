Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4C426FDAD
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgIRM6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:58:54 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13303 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726129AbgIRM6v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 08:58:51 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 79AC7C7BCDB8C72956D4;
        Fri, 18 Sep 2020 20:58:48 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 20:58:43 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <gustavoars@kernel.org>,
        <mhabets@solarflare.com>, <mst@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net/appletalk: Supply missing net/Space.h include file
Date:   Fri, 18 Sep 2020 20:55:51 +0800
Message-ID: <20200918125551.12075-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the header file containing a function's prototype isn't included by
the sourcefile containing the associated function, the build system
complains of missing prototypes.

Fixes the following W=1 kernel build warning(s):

drivers/net/appletalk/cops.c:213:28: warning: no previous prototype for ‘cops_probe’ [-Wmissing-prototypes]
drivers/net/appletalk/ltpc.c:1014:28: warning: no previous prototype for ‘ltpc_probe’ [-Wmissing-prototypes]

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/appletalk/cops.c | 2 ++
 drivers/net/appletalk/ltpc.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
index 1c6c27f35ac4..ba8e70a8e312 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -70,6 +70,8 @@ static const char *version =
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
 
+#include <net/Space.h>
+
 #include <asm/io.h>
 #include <asm/dma.h>
 
diff --git a/drivers/net/appletalk/ltpc.c b/drivers/net/appletalk/ltpc.c
index 75a5a9b87c5a..c6f73aa3700c 100644
--- a/drivers/net/appletalk/ltpc.c
+++ b/drivers/net/appletalk/ltpc.c
@@ -229,6 +229,8 @@ static int dma;
 #include <linux/bitops.h>
 #include <linux/gfp.h>
 
+#include <net/Space.h>
+
 #include <asm/dma.h>
 #include <asm/io.h>
 
-- 
2.17.1

