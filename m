Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04168256753
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 13:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgH2L5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 07:57:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10731 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726876AbgH2L4K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 07:56:10 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 956A9FB7F4F87F9EC5F6;
        Sat, 29 Aug 2020 19:56:01 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Sat, 29 Aug 2020
 19:55:53 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: wan: slic_ds26522: Remove unused macro DRV_NAME
Date:   Sat, 29 Aug 2020 19:55:49 +0800
Message-ID: <20200829115549.14144-1-yuehaibing@huawei.com>
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
 drivers/net/wan/slic_ds26522.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wan/slic_ds26522.c b/drivers/net/wan/slic_ds26522.c
index 29053bec694e..8e3b1c717c10 100644
--- a/drivers/net/wan/slic_ds26522.c
+++ b/drivers/net/wan/slic_ds26522.c
@@ -22,8 +22,6 @@
 #include <linux/io.h>
 #include "slic_ds26522.h"
 
-#define DRV_NAME "ds26522"
-
 #define SLIC_TRANS_LEN 1
 #define SLIC_TWO_LEN 2
 #define SLIC_THREE_LEN 3
-- 
2.17.1


