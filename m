Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7A139D358
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 05:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhFGDUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 23:20:18 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7122 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhFGDUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 23:20:16 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fyz5g1QY7zYrcy;
        Mon,  7 Jun 2021 11:15:35 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 11:18:23 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 11:18:22 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] lib/test: Fix spelling mistakes
Date:   Mon, 7 Jun 2021 11:15:37 +0800
Message-ID: <20210607031537.12366-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some spelling mistakes in comments:
thats ==> that's
unitialized ==> uninitialized
panicing ==> panicking
sucess ==> success
possitive ==> positive
intepreted ==> interpreted

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 lib/test_bitops.c | 2 +-
 lib/test_bpf.c    | 2 +-
 lib/test_kasan.c  | 2 +-
 lib/test_kmod.c   | 6 +++---
 lib/test_scanf.c  | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/test_bitops.c b/lib/test_bitops.c
index 471141ddd691..3b7bcbee84db 100644
--- a/lib/test_bitops.c
+++ b/lib/test_bitops.c
@@ -15,7 +15,7 @@
  *   get_count_order/long
  */
 
-/* use an enum because thats the most common BITMAP usage */
+/* use an enum because that's the most common BITMAP usage */
 enum bitops_fun {
 	BITOPS_4 = 4,
 	BITOPS_7 = 7,
diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 4dc4dcbecd12..d500320778c7 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -1095,7 +1095,7 @@ static struct bpf_test tests[] = {
 	{
 		"RET_A",
 		.u.insns = {
-			/* check that unitialized X and A contain zeros */
+			/* check that uninitialized X and A contain zeros */
 			BPF_STMT(BPF_MISC | BPF_TXA, 0),
 			BPF_STMT(BPF_RET | BPF_A, 0)
 		},
diff --git a/lib/test_kasan.c b/lib/test_kasan.c
index cacbbbdef768..72b8e808c39c 100644
--- a/lib/test_kasan.c
+++ b/lib/test_kasan.c
@@ -656,7 +656,7 @@ static void kasan_global_oob(struct kunit *test)
 {
 	/*
 	 * Deliberate out-of-bounds access. To prevent CONFIG_UBSAN_LOCAL_BOUNDS
-	 * from failing here and panicing the kernel, access the array via a
+	 * from failing here and panicking the kernel, access the array via a
 	 * volatile pointer, which will prevent the compiler from being able to
 	 * determine the array bounds.
 	 *
diff --git a/lib/test_kmod.c b/lib/test_kmod.c
index 38c250fbace3..ce1589391413 100644
--- a/lib/test_kmod.c
+++ b/lib/test_kmod.c
@@ -286,7 +286,7 @@ static int tally_work_test(struct kmod_test_device_info *info)
  * If this ran it means *all* tasks were created fine and we
  * are now just collecting results.
  *
- * Only propagate errors, do not override with a subsequent sucess case.
+ * Only propagate errors, do not override with a subsequent success case.
  */
 static void tally_up_work(struct kmod_test_device *test_dev)
 {
@@ -543,7 +543,7 @@ static int trigger_config_run(struct kmod_test_device *test_dev)
 	 * wrong with the setup of the test. If the test setup went fine
 	 * then userspace must just check the result of config->test_result.
 	 * One issue with relying on the return from a call in the kernel
-	 * is if the kernel returns a possitive value using this trigger
+	 * is if the kernel returns a positive value using this trigger
 	 * will not return the value to userspace, it would be lost.
 	 *
 	 * By not relying on capturing the return value of tests we are using
@@ -585,7 +585,7 @@ trigger_config_store(struct device *dev,
 	 * Note: any return > 0 will be treated as success
 	 * and the error value will not be available to userspace.
 	 * Do not rely on trying to send to userspace a test value
-	 * return value as possitive return errors will be lost.
+	 * return value as positive return errors will be lost.
 	 */
 	if (WARN_ON(ret > 0))
 		return -EINVAL;
diff --git a/lib/test_scanf.c b/lib/test_scanf.c
index 48ff5747a4da..84fe09eaf55e 100644
--- a/lib/test_scanf.c
+++ b/lib/test_scanf.c
@@ -600,7 +600,7 @@ static void __init numbers_prefix_overflow(void)
 	/*
 	 * 0x prefix in a field of width 2 using %i conversion: first field
 	 * converts to 0. Next field scan starts at the character after "0x",
-	 * which will convert if can be intepreted as decimal but will fail
+	 * which will convert if can be interpreted as decimal but will fail
 	 * if it contains any hex digits (since no 0x prefix).
 	 */
 	test_number_prefix(long long,	"0x67", "%2lli%lli", 0, 67, 2, check_ll);
-- 
2.25.1


