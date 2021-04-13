Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9126B35DB8B
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbhDMJqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:46:37 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:50595 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230447AbhDMJqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:46:35 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UVRhDJ6_1618307174;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UVRhDJ6_1618307174)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 13 Apr 2021 17:46:14 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     amitkarwar@gmail.com
Cc:     siva8118@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] rsi: remove unused including <linux/version.h>
Date:   Tue, 13 Apr 2021 17:46:12 +0800
Message-Id: <1618307172-70927-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following versioncheck warning:
./drivers/net/wireless/rsi/rsi_91x_ps.c: 19 linux/version.h not needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/rsi/rsi_91x_ps.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_ps.c b/drivers/net/wireless/rsi/rsi_91x_ps.c
index fdaa5a7..a029049 100644
--- a/drivers/net/wireless/rsi/rsi_91x_ps.c
+++ b/drivers/net/wireless/rsi/rsi_91x_ps.c
@@ -16,7 +16,6 @@
 
 #include <linux/etherdevice.h>
 #include <linux/if.h>
-#include <linux/version.h>
 #include "rsi_debugfs.h"
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
-- 
1.8.3.1

