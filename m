Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C42E7185929
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 03:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbgCOCgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 22:36:48 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11695 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726712AbgCOCgr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 22:36:47 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 36F5E8A47D899E3BDB75;
        Sat, 14 Mar 2020 18:51:31 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Sat, 14 Mar 2020
 18:51:23 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ayush.sawal@chelsio.com>, <vinay.yadav@chelsio.com>,
        <rohitm@chelsio.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] chcr: remove set but not used variable 'status'
Date:   Sat, 14 Mar 2020 18:51:20 +0800
Message-ID: <20200314105120.20968-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/crypto/chelsio/chcr_ktls.c: In function chcr_ktls_cpl_set_tcb_rpl:
drivers/crypto/chelsio/chcr_ktls.c:662:11: warning:
 variable status set but not used [-Wunused-but-set-variable]

commit 8a30923e1598 ("cxgb4/chcr: Save tx keys and handle HW response")
involved this unused variable, remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/chelsio/chcr_ktls.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index f0c3834eda4f..00099e793e63 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -659,10 +659,9 @@ int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input)
 	const struct cpl_set_tcb_rpl *p = (void *)input;
 	struct chcr_ktls_info *tx_info = NULL;
 	struct tid_info *t;
-	u32 tid, status;
+	u32 tid;
 
 	tid = GET_TID(p);
-	status = p->status;
 
 	t = &adap->tids;
 	tx_info = lookup_tid(t, tid);
-- 
2.20.1


