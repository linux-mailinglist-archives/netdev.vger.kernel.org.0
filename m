Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A5F19BA5A
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 04:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387419AbgDBCeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 22:34:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12666 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727135AbgDBCeI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 22:34:08 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id ED6EB8EE69BEE25C2339;
        Thu,  2 Apr 2020 10:33:56 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Apr 2020
 10:33:49 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ayush.sawal@chelsio.com>, <vinay.yadav@chelsio.com>,
        <rohitm@chelsio.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net] crypto/chcr: Add missing include file <linux/highmem.h>
Date:   Thu, 2 Apr 2020 10:32:58 +0800
Message-ID: <20200402023258.33336-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/crypto/chelsio/chcr_ktls.c: In function ‘chcr_short_record_handler’:
drivers/crypto/chelsio/chcr_ktls.c:1770:12: error: implicit declaration of function ‘kmap_atomic’;
 did you mean ‘in_atomic’? [-Werror=implicit-function-declaration]
    vaddr = kmap_atomic(skb_frag_page(f));
            ^~~~~~~~~~~

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: dc05f3df8fac ("chcr: Handle first or middle part of record")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/chelsio/chcr_ktls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index 73658b71d4a3..cd1769ecdc1c 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2020 Chelsio Communications.  All rights reserved. */
 
 #ifdef CONFIG_CHELSIO_TLS_DEVICE
+#include <linux/highmem.h>
 #include "chcr_ktls.h"
 #include "clip_tbl.h"
 
-- 
2.17.1


