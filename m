Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C141936CA
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 04:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgCZDZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 23:25:10 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12136 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727575AbgCZDZJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 23:25:09 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 691EF89FE8A41A3FB5A4;
        Thu, 26 Mar 2020 11:25:07 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Thu, 26 Mar 2020
 11:24:58 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <j@w1.fi>, <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <yuehaibing@huawei.com>, <andriy.shevchenko@linux.intel.com>,
        <sfr@canb.auug.org.au>, <akpm@linux-foundation.org>,
        <adobriyan@gmail.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] hostap: Convert prism2_download_aux_dump_proc_fops to prism2_download_aux_dump_proc_ops
Date:   Thu, 26 Mar 2020 11:24:32 +0800
Message-ID: <20200326032432.20384-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 97a32539b956 ("proc: convert everything to "struct proc_ops"")
forget do this convering for prism2_download_aux_dump_proc_fops.

Fixes: 97a32539b956 ("proc: convert everything to "struct proc_ops"")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/intersil/hostap/hostap_download.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_download.c b/drivers/net/wireless/intersil/hostap/hostap_download.c
index 8722000b6c27..7c6a5a6d1d45 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_download.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_download.c
@@ -232,11 +232,11 @@ static int prism2_download_aux_dump_proc_open(struct inode *inode, struct file *
 	return ret;
 }
 
-static const struct file_operations prism2_download_aux_dump_proc_fops = {
-	.open		= prism2_download_aux_dump_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+static const struct proc_ops prism2_download_aux_dump_proc_ops = {
+	.proc_open		= prism2_download_aux_dump_proc_open,
+	.proc_read		= seq_read,
+	.proc_lseek		= seq_lseek,
+	.proc_release		= seq_release_private,
 };
 
 
-- 
2.17.1


