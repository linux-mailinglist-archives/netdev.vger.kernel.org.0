Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E59312D60
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 10:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhBHJgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 04:36:46 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:54387 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231788AbhBHJeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 04:34:23 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UOAH8ml_1612776820;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UOAH8ml_1612776820)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 08 Feb 2021 17:33:40 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     shuah@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] selftests/net: so_txtime: remove unneeded semicolon
Date:   Mon,  8 Feb 2021 17:33:38 +0800
Message-Id: <1612776818-21930-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the following coccicheck warning:
./tools/testing/selftests/net/so_txtime.c:199:3-4: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 tools/testing/selftests/net/so_txtime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/so_txtime.c b/tools/testing/selftests/net/so_txtime.c
index 3155fbb..b4cca382d 100644
--- a/tools/testing/selftests/net/so_txtime.c
+++ b/tools/testing/selftests/net/so_txtime.c
@@ -196,7 +196,7 @@ static void do_recv_errqueue_timeout(int fdt)
 		default:
 			error(1, 0, "errqueue: errno %u code %u\n",
 			      err->ee_errno, err->ee_code);
-		};
+		}
 
 		tstamp = ((int64_t) err->ee_data) << 32 | err->ee_info;
 		tstamp -= (int64_t) glob_tstart;
-- 
1.8.3.1

