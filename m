Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89CD6A6348
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 10:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbfICIAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 04:00:17 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56228 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725878AbfICIAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 04:00:17 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7FAAB650D523DD740224;
        Tue,  3 Sep 2019 16:00:13 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Tue, 3 Sep 2019 16:00:05 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>
CC:     <zhongjiang@huawei.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] hostap: remove set but not used variable 'copied' in prism2_io_debug_proc_read
Date:   Tue, 3 Sep 2019 15:57:10 +0800
Message-ID: <1567497430-22539-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Obviously, variable 'copied' is initialized to zero. But it is not used.
hence just remove it.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/wireless/intersil/hostap/hostap_proc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_proc.c b/drivers/net/wireless/intersil/hostap/hostap_proc.c
index 703d74c..6151d8d 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_proc.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_proc.c
@@ -234,7 +234,7 @@ static int prism2_io_debug_proc_read(char *page, char **start, off_t off,
 {
 	local_info_t *local = (local_info_t *) data;
 	int head = local->io_debug_head;
-	int start_bytes, left, copy, copied;
+	int start_bytes, left, copy;
 
 	if (off + count > PRISM2_IO_DEBUG_SIZE * 4) {
 		*eof = 1;
@@ -243,7 +243,6 @@ static int prism2_io_debug_proc_read(char *page, char **start, off_t off,
 		count = PRISM2_IO_DEBUG_SIZE * 4 - off;
 	}
 
-	copied = 0;
 	start_bytes = (PRISM2_IO_DEBUG_SIZE - head) * 4;
 	left = count;
 
-- 
1.7.12.4

