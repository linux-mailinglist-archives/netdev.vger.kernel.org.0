Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A75F3817F3
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbhEOK6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:58:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3766 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbhEOKzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:55 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fj2J34fKSzmgYR;
        Sat, 15 May 2021 18:51:15 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:32 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 34/34] net: ti: wlcore: Fix missing function name in comments
Date:   Sat, 15 May 2021 18:53:59 +0800
Message-ID: <1621076039-53986-35-git-send-email-shenyang39@huawei.com>
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

 drivers/net/wireless/ti/wlcore/cmd.c:824: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 drivers/net/wireless/ti/wlcore/cmd.c:853: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 drivers/net/wireless/ti/wlcore/cmd.c:882: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 32a2e27..8b798b5 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -821,7 +821,7 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 
 /**
- * send test command to firmware
+ * wl1271_cmd_test - send test command to firmware
  *
  * @wl: wl struct
  * @buf: buffer containing the command, with all headers, must work with dma
@@ -850,7 +850,7 @@ int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer)
 EXPORT_SYMBOL_GPL(wl1271_cmd_test);
 
 /**
- * read acx from firmware
+ * wl1271_cmd_interrogate - read acx from firmware
  *
  * @wl: wl struct
  * @id: acx id
@@ -879,7 +879,7 @@ int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf,
 }
 
 /**
- * write acx value to firmware
+ * wlcore_cmd_configure_failsafe - write acx value to firmware
  *
  * @wl: wl struct
  * @id: acx id
-- 
2.7.4

