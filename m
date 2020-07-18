Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE45B224B0B
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 13:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGRLxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 07:53:03 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39076 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726481AbgGRLxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jul 2020 07:53:03 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E8ABE508C0CCB2E37E53;
        Sat, 18 Jul 2020 19:53:00 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Sat, 18 Jul 2020
 19:52:59 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] bpf: Make some functions static
Date:   Sat, 18 Jul 2020 19:51:35 +0800
Message-ID: <20200718115135.34856-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse build warning:

net/bpf/test_run.c:120:14: warning:
 symbol 'bpf_fentry_test1' was not declared. Should it be static?
net/bpf/test_run.c:125:14: warning:
 symbol 'bpf_fentry_test2' was not declared. Should it be static?
net/bpf/test_run.c:130:14: warning:
 symbol 'bpf_fentry_test3' was not declared. Should it be static?
net/bpf/test_run.c:135:14: warning:
 symbol 'bpf_fentry_test4' was not declared. Should it be static?
net/bpf/test_run.c:140:14: warning:
 symbol 'bpf_fentry_test5' was not declared. Should it be static?
net/bpf/test_run.c:145:14: warning:
 symbol 'bpf_fentry_test6' was not declared. Should it be static?
net/bpf/test_run.c:154:14: warning:
 symbol 'bpf_fentry_test7' was not declared. Should it be static?
net/bpf/test_run.c:159:14: warning:
 symbol 'bpf_fentry_test8' was not declared. Should it be static?
net/bpf/test_run.c:164:14: warning:
 symbol 'bpf_modify_return_test' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/bpf/test_run.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index b03c469cd01f..0d78bd9b6c9d 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -117,32 +117,32 @@ static int bpf_test_finish(const union bpf_attr *kattr,
 __diag_push();
 __diag_ignore(GCC, 8, "-Wmissing-prototypes",
 	      "Global functions as their definitions will be in vmlinux BTF");
-int noinline bpf_fentry_test1(int a)
+static noinline int bpf_fentry_test1(int a)
 {
 	return a + 1;
 }
 
-int noinline bpf_fentry_test2(int a, u64 b)
+static noinline int bpf_fentry_test2(int a, u64 b)
 {
 	return a + b;
 }
 
-int noinline bpf_fentry_test3(char a, int b, u64 c)
+static noinline int bpf_fentry_test3(char a, int b, u64 c)
 {
 	return a + b + c;
 }
 
-int noinline bpf_fentry_test4(void *a, char b, int c, u64 d)
+static noinline int bpf_fentry_test4(void *a, char b, int c, u64 d)
 {
 	return (long)a + b + c + d;
 }
 
-int noinline bpf_fentry_test5(u64 a, void *b, short c, int d, u64 e)
+static noinline int bpf_fentry_test5(u64 a, void *b, short c, int d, u64 e)
 {
 	return a + (long)b + c + d + e;
 }
 
-int noinline bpf_fentry_test6(u64 a, void *b, short c, int d, void *e, u64 f)
+static noinline int bpf_fentry_test6(u64 a, void *b, short c, int d, void *e, u64 f)
 {
 	return a + (long)b + c + d + (long)e + f;
 }
@@ -151,17 +151,17 @@ struct bpf_fentry_test_t {
 	struct bpf_fentry_test_t *a;
 };
 
-int noinline bpf_fentry_test7(struct bpf_fentry_test_t *arg)
+static noinline int bpf_fentry_test7(struct bpf_fentry_test_t *arg)
 {
 	return (long)arg;
 }
 
-int noinline bpf_fentry_test8(struct bpf_fentry_test_t *arg)
+static noinline int bpf_fentry_test8(struct bpf_fentry_test_t *arg)
 {
 	return (long)arg->a;
 }
 
-int noinline bpf_modify_return_test(int a, int *b)
+static noinline int bpf_modify_return_test(int a, int *b)
 {
 	*b += 1;
 	return a + *b;
-- 
2.17.1

