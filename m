Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7D43723FB
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 03:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfGXBs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 21:48:58 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2708 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728735AbfGXBs5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 21:48:57 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 206BC30DD72286730F4D;
        Wed, 24 Jul 2019 09:48:53 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Wed, 24 Jul 2019 09:48:47 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] carl9170: remove set but not used variable 'udev'
Date:   Wed, 24 Jul 2019 01:54:11 +0000
Message-ID: <20190724015411.66525-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/ath/carl9170/usb.c: In function 'carl9170_usb_disconnect':
drivers/net/wireless/ath/carl9170/usb.c:1110:21: warning:
 variable 'udev' set but not used [-Wunused-but-set-variable]

It is not used, so can be removed.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/carl9170/usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index 99f1897a775d..486957a04bd1 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -1107,12 +1107,10 @@ static int carl9170_usb_probe(struct usb_interface *intf,
 static void carl9170_usb_disconnect(struct usb_interface *intf)
 {
 	struct ar9170 *ar = usb_get_intfdata(intf);
-	struct usb_device *udev;
 
 	if (WARN_ON(!ar))
 		return;
 
-	udev = ar->udev;
 	wait_for_completion(&ar->fw_load_wait);
 
 	if (IS_INITIALIZED(ar)) {



