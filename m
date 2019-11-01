Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713B2EC3FB
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 14:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfKANpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 09:45:33 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5250 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727296AbfKANpd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 09:45:33 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EEA71D51D3AB2207736E;
        Fri,  1 Nov 2019 21:45:30 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Fri, 1 Nov 2019
 21:45:20 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <isdn@linux-pingi.de>, <yuehaibing@huawei.com>,
        <swinslow@gmail.com>, <tglx@linutronix.de>,
        <sergey.senozhatsky@gmail.com>, <davem@davemloft.net>,
        <wangkefeng.wang@huawei.com>, <elfring@users.sourceforge.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] mISDN: remove unused variable 'faxmodulation_s'
Date:   Fri, 1 Nov 2019 21:44:47 +0800
Message-ID: <20191101134447.30280-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/isdn/hardware/mISDN/mISDNisar.c:30:17:
 warning: faxmodulation_s defined but not used [-Wunused-const-variable=]

It is never used, so can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/isdn/hardware/mISDN/mISDNisar.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/mISDNisar.c b/drivers/isdn/hardware/mISDN/mISDNisar.c
index 096d8c5..e325e87 100644
--- a/drivers/isdn/hardware/mISDN/mISDNisar.c
+++ b/drivers/isdn/hardware/mISDN/mISDNisar.c
@@ -27,7 +27,6 @@ MODULE_VERSION(ISAR_REV);
 
 #define DEBUG_HW_FIRMWARE_FIFO	0x10000
 
-static const u8 faxmodulation_s[] = "3,24,48,72,73,74,96,97,98,121,122,145,146";
 static const u8 faxmodulation[] = {3, 24, 48, 72, 73, 74, 96, 97, 98, 121,
 				   122, 145, 146};
 #define FAXMODCNT 13
-- 
2.7.4


