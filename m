Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEF245B815
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 11:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240626AbhKXKNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 05:13:20 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:57759 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230515AbhKXKNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 05:13:19 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Uy5htFm_1637748599;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Uy5htFm_1637748599)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 18:10:08 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     woojung.huh@microchip.com
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] lan78xx: Clean up some inconsistent indenting
Date:   Wed, 24 Nov 2021 18:09:56 +0800
Message-Id: <1637748596-19168-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow smatch warning:

drivers/net/usb/lan78xx.c:4961 lan78xx_resume() warn: inconsistent
indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/usb/lan78xx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index a9e7cbe..2bfb59a 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -4957,8 +4957,7 @@ static int lan78xx_resume(struct usb_interface *intf)
 			if (ret < 0) {
 				if (ret == -ENODEV)
 					netif_device_detach(dev->net);
-
-			netdev_warn(dev->net, "Failed to submit intr URB");
+				netdev_warn(dev->net, "Failed to submit intr URB");
 			}
 		}
 
-- 
1.8.3.1

