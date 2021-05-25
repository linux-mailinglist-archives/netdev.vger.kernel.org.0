Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F89038FF97
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 12:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhEYK50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 06:57:26 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:60920 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229581AbhEYK5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 06:57:24 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Ua4PMDc_1621940147;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Ua4PMDc_1621940147)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 25 May 2021 18:55:53 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ajk@comnets.uni-bremen.de
Cc:     davem@davemloft.net, kuba@kernel.org, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] net/hamradio/6pack: Fix inconsistent indenting
Date:   Tue, 25 May 2021 18:55:45 +0800
Message-Id: <1621940145-70195-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow smatch warning:

drivers/net/hamradio/6pack.c:728 sixpack_ioctl() warn: inconsistent
indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/hamradio/6pack.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 686c38c..fcf3af7 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -716,11 +716,11 @@ static int sixpack_ioctl(struct tty_struct *tty, struct file *file,
 		err = 0;
 		break;
 
-	 case SIOCSIFHWADDR: {
-		char addr[AX25_ADDR_LEN];
+	case SIOCSIFHWADDR: {
+			char addr[AX25_ADDR_LEN];
 
-		if (copy_from_user(&addr,
-		                   (void __user *) arg, AX25_ADDR_LEN)) {
+			if (copy_from_user(&addr,
+					   (void __user *)arg, AX25_ADDR_LEN)) {
 				err = -EFAULT;
 				break;
 			}
@@ -728,11 +728,9 @@ static int sixpack_ioctl(struct tty_struct *tty, struct file *file,
 			netif_tx_lock_bh(dev);
 			memcpy(dev->dev_addr, &addr, AX25_ADDR_LEN);
 			netif_tx_unlock_bh(dev);
-
 			err = 0;
 			break;
 		}
-
 	default:
 		err = tty_mode_ioctl(tty, file, cmd, arg);
 	}
-- 
1.8.3.1

