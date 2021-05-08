Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E21F37713D
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 12:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhEHKhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 06:37:04 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:38071 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230234AbhEHKhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 06:37:03 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UY8vJLO_1620470154;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UY8vJLO_1620470154)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 08 May 2021 18:35:59 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] rtw88: 8822c: Fix duplicate included coex.h
Date:   Sat,  8 May 2021 18:35:53 +0800
Message-Id: <1620470153-25018-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up the following includecheck warning:

./drivers/net/wireless/realtek/rtw88/rtw8822c.c: coex.h is included more
than once.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 6cb593cc3..1cb7059 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -17,7 +17,6 @@
 #include "util.h"
 #include "bf.h"
 #include "efuse.h"
-#include "coex.h"
 
 #define IQK_DONE_8822C 0xaa
 
-- 
1.8.3.1

