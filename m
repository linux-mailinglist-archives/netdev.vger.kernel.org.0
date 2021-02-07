Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5254C312250
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 08:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhBGHyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 02:54:05 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:34132 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229445AbhBGHyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 02:54:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UO3FsJh_1612684362;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UO3FsJh_1612684362)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 07 Feb 2021 15:52:42 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     shuah@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] bpf/benchs/bench_ringbufs: remove unneeded semicolon
Date:   Sun,  7 Feb 2021 15:52:40 +0800
Message-Id: <1612684360-115910-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the following coccicheck warning:
./tools/testing/selftests/bpf/benchs/bench_ringbufs.c:322:2-3: Unneeded
semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 tools/testing/selftests/bpf/benchs/bench_ringbufs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/benchs/bench_ringbufs.c b/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
index da87c7f..bde6c9d 100644
--- a/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
+++ b/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
@@ -319,7 +319,7 @@ static void ringbuf_custom_process_ring(struct ringbuf_custom *r)
 			smp_store_release(r->consumer_pos, cons_pos);
 		else
 			break;
-	};
+	}
 }
 
 static void *ringbuf_custom_consumer(void *input)
-- 
1.8.3.1

