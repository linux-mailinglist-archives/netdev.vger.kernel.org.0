Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0C9443BFE
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 04:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhKCDry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 23:47:54 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:55968 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhKCDrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 23:47:53 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UupXUma_1635911111;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UupXUma_1635911111)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Nov 2021 11:45:16 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ap420073@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] amt: Remove duplicate include
Date:   Wed,  3 Nov 2021 11:45:07 +0800
Message-Id: <1635911107-63759-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up the following includecheck warning:

./drivers/net/amt.c: net/protocol.h is included more than once.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/amt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 60a7053..6697f8b 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -12,7 +12,6 @@
 #include <linux/igmp.h>
 #include <linux/workqueue.h>
 #include <net/net_namespace.h>
-#include <net/protocol.h>
 #include <net/ip.h>
 #include <net/udp.h>
 #include <net/udp_tunnel.h>
-- 
1.8.3.1

