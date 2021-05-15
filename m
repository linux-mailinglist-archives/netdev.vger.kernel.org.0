Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF29381801
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbhEOK6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:58:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3543 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbhEOKz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:57 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jn6YFBzsRJV;
        Sat, 15 May 2021 18:51:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:29 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 26/34] net: ath: wil6210: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:51 +0800
Message-ID: <1621076039-53986-27-git-send-email-shenyang39@huawei.com>
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

 drivers/net/wireless/ath/wil6210/interrupt.c:28: warning: expecting prototype for Theory of operation(). Prototype was for WIL6210_IRQ_DISABLE() instead
 drivers/net/wireless/ath/wil6210/wmi.c:227: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 drivers/net/wireless/ath/wil6210/wmi.c:245: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 drivers/net/wireless/ath/wil6210/wmi.c:263: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Cc: Maya Erez <merez@codeaurora.org>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 2 +-
 drivers/net/wireless/ath/wil6210/wmi.c       | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index d13d081..6717238 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -9,7 +9,7 @@
 #include "wil6210.h"
 #include "trace.h"
 
-/**
+/*
  * Theory of operation:
  *
  * There is ISR pseudo-cause register,
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 02ad449..2dc8406 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -224,7 +224,7 @@ struct auth_no_hdr {
 u8 led_polarity = LED_POLARITY_LOW_ACTIVE;
 
 /**
- * return AHB address for given firmware internal (linker) address
+ * wmi_addr_remap - return AHB address for given firmware internal (linker) address
  * @x: internal address
  * If address have no valid AHB mapping, return 0
  */
@@ -242,7 +242,7 @@ static u32 wmi_addr_remap(u32 x)
 }
 
 /**
- * find fw_mapping entry by section name
+ * wil_find_fw_mapping - find fw_mapping entry by section name
  * @section: section name
  *
  * Return pointer to section or NULL if not found
@@ -260,7 +260,7 @@ struct fw_map *wil_find_fw_mapping(const char *section)
 }
 
 /**
- * Check address validity for WMI buffer; remap if needed
+ * wmi_buffer_block - Check address validity for WMI buffer; remap if needed
  * @wil: driver data
  * @ptr_: internal (linker) fw/ucode address
  * @size: if non zero, validate the block does not
-- 
2.7.4

