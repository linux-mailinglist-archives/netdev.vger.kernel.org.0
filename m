Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C05F3817FF
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbhEOK6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:58:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3544 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbhEOKz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:57 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jt5PwyzsR7d;
        Sat, 15 May 2021 18:51:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:31 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        "Siva Rebbagondla" <siva8118@gmail.com>
Subject: [PATCH 32/34] net: rsi: Fix missing function name in comments
Date:   Sat, 15 May 2021 18:53:57 +0800
Message-ID: <1621076039-53986-33-git-send-email-shenyang39@huawei.com>
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

 drivers/net/wireless/rsi/rsi_91x_mgmt.c:1550: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 33c76d3..dffe1d6 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1547,8 +1547,8 @@ static int rsi_eeprom_read(struct rsi_common *common)
 }
 
 /**
- * This function sends a frame to block/unblock
- * data queues in the firmware
+ * rsi_send_block_unblock_frame() - This function sends a frame to block/unblock
+ *                                  data queues in the firmware
  *
  * @common: Pointer to the driver private structure.
  * @block_event: Event block if true, unblock if false
-- 
2.7.4

