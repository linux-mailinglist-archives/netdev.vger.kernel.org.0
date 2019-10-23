Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D37AE133B
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 09:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389932AbfJWHhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 03:37:11 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4749 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727574AbfJWHhK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 03:37:10 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6D2969933A402C0EA6F8;
        Wed, 23 Oct 2019 15:37:07 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Wed, 23 Oct 2019
 15:36:59 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: lan78xx: remove set but not used variable 'event'
Date:   Wed, 23 Oct 2019 15:36:26 +0800
Message-ID: <20191023073626.33956-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/usb/lan78xx.c:3995:6: warning:
 variable event set but not used [-Wunused-but-set-variable]

It is never used, so can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/usb/lan78xx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 6294809..f8c0818 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3992,9 +3992,6 @@ static int lan78xx_suspend(struct usb_interface *intf, pm_message_t message)
 	struct lan78xx_priv *pdata = (struct lan78xx_priv *)(dev->data[0]);
 	u32 buf;
 	int ret;
-	int event;
-
-	event = message.event;
 
 	if (!dev->suspend_count++) {
 		spin_lock_irq(&dev->txq.lock);
-- 
2.7.4


