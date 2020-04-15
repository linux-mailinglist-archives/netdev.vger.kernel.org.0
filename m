Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7351A95FD
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 10:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635722AbgDOIQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 04:16:14 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33004 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2635530AbgDOIQL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 04:16:11 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 927995B08CF3362D2E9A;
        Wed, 15 Apr 2020 16:16:08 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Wed, 15 Apr 2020
 16:15:59 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <isdn@linux-pingi.de>, <davem@davemloft.net>,
        <yuehaibing@huawei.com>, <gregkh@linuxfoundation.org>,
        <tglx@linutronix.de>, <wangkefeng.wang@huawei.com>,
        <elfring@users.sourceforge.net>, <yanaijie@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] mISDN: make dmril and dmrim static
Date:   Wed, 15 Apr 2020 16:42:26 +0800
Message-ID: <20200415084226.23971-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warning:

drivers/isdn/hardware/mISDN/mISDNisar.c:746:12: warning: symbol 'dmril'
was not declared. Should it be static?
drivers/isdn/hardware/mISDN/mISDNisar.c:749:12: warning: symbol 'dmrim'
was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/isdn/hardware/mISDN/mISDNisar.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/mISDNisar.c b/drivers/isdn/hardware/mISDN/mISDNisar.c
index e325e87c0593..11e8c7d8b6e8 100644
--- a/drivers/isdn/hardware/mISDN/mISDNisar.c
+++ b/drivers/isdn/hardware/mISDN/mISDNisar.c
@@ -743,10 +743,10 @@ check_send(struct isar_hw *isar, u8 rdm)
 	}
 }
 
-const char *dmril[] = {"NO SPEED", "1200/75", "NODEF2", "75/1200", "NODEF4",
+static const char *dmril[] = {"NO SPEED", "1200/75", "NODEF2", "75/1200", "NODEF4",
 		       "300", "600", "1200", "2400", "4800", "7200",
 		       "9600nt", "9600t", "12000", "14400", "WRONG"};
-const char *dmrim[] = {"NO MOD", "NO DEF", "V32/V32b", "V22", "V21",
+static const char *dmrim[] = {"NO MOD", "NO DEF", "V32/V32b", "V22", "V21",
 		       "Bell103", "V23", "Bell202", "V17", "V29", "V27ter"};
 
 static void
-- 
2.21.1

