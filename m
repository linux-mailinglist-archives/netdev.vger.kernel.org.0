Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3672F0EF9
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 10:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbhAKJXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 04:23:16 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:44607 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727690AbhAKJXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 04:23:15 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0ULMRbj6_1610356933;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0ULMRbj6_1610356933)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 11 Jan 2021 17:22:22 +0800
From:   YANG LI <abaci-bugfix@linux.alibaba.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        YANG LI <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] rtw88: debug: style: Simplify bool comparison
Date:   Mon, 11 Jan 2021 17:22:12 +0800
Message-Id: <1610356932-56073-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:
 ./drivers/net/wireless/realtek/rtw88/debug.c:800:17-23: WARNING:
Comparison of 0/1 to bool variable

Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci Robot<abaci@linux.alibaba.com>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index 19fc2d8..948cb79 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -800,7 +800,7 @@ static ssize_t rtw_debugfs_set_coex_enable(struct file *filp,
 	}
 
 	mutex_lock(&rtwdev->mutex);
-	coex->manual_control = enable == 0;
+	coex->manual_control = !enable;
 	mutex_unlock(&rtwdev->mutex);
 
 	return count;
-- 
1.8.3.1

