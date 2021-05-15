Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F543817F1
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbhEOK5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:57:53 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3549 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbhEOKzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:55 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jn6LHRzsRJT;
        Sat, 15 May 2021 18:51:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:29 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH 28/34] net: intel: ipw2x00: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:53 +0800
Message-ID: <1621076039-53986-29-git-send-email-shenyang39@huawei.com>
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

 drivers/net/wireless/intel/ipw2x00/ipw2100.c:5359: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 drivers/net/wireless/intel/ipw2x00/ipw2100.c:6533: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 drivers/net/wireless/intel/ipw2x00/ipw2100.c:6565: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 23fbddd..a1c7b04 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -5356,7 +5356,7 @@ struct ipw2100_wep_key {
 #define WEP_STR_128(x) x[0],x[1],x[2],x[3],x[4],x[5],x[6],x[7],x[8],x[9],x[10]
 
 /**
- * Set a the wep key
+ * ipw2100_set_key - Set a the wep key
  *
  * @priv: struct to work on
  * @idx: index of the key we want to set
@@ -6530,7 +6530,7 @@ static struct pci_driver ipw2100_pci_driver = {
 };
 
 /**
- * Initialize the ipw2100 driver/module
+ * ipw2100_init - Initialize the ipw2100 driver/module
  *
  * @returns 0 if ok, < 0 errno node con error.
  *
@@ -6562,7 +6562,7 @@ static int __init ipw2100_init(void)
 }
 
 /**
- * Cleanup ipw2100 driver registration
+ * ipw2100_exit - Cleanup ipw2100 driver registration
  */
 static void __exit ipw2100_exit(void)
 {
@@ -7197,7 +7197,7 @@ static int ipw2100_wx_set_txpow(struct net_device *dev,
 {
 	struct ipw2100_priv *priv = libipw_priv(dev);
 	int err = 0, value;
-	
+
 	if (ipw_radio_kill_sw(priv, wrqu->txpower.disabled))
 		return -EINPROGRESS;
 
-- 
2.7.4

