Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5DA882081
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 17:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbfHEPlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 11:41:04 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:41750 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728868AbfHEPlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 11:41:03 -0400
Received: by mail-pg1-f201.google.com with SMTP id b18so52954429pgg.8
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 08:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cc8140ROS7FIUIcfJ9DfbRrzgw85EaOQXKVrYia7RL8=;
        b=DS9lXArLepwOMhOOzDEz+2E2TwQK2LZT4gGfx8qfbMlqbkwIG0m0v84Cdcaw0dWemf
         kp19Nj6Cq3AnDHGGSynjvcFp1x6zcQlWOfqYf2uOvrn6yP2iIMuQPCZGojVWqUGV2CIQ
         EM86X8UtMSXrkXo+RnkUtAgx5jd/KpsfPm94nw79wQNRuPykQTZ06a33y7dds7jow/px
         qg/ewYzyr2IoF+7izHR54DObFkm0kZbqAcOIVCkU5FU9/Y9x6KWc4rduRKu3l2z7JGFv
         lnHfYLfvqFhwPLik5qkFmn+zipdXwxUNegj+LF8VvbXNq/wnJee6yefzTdfYZNyP2WY8
         xamQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cc8140ROS7FIUIcfJ9DfbRrzgw85EaOQXKVrYia7RL8=;
        b=tGIR2X9Dg2CzRUs7JEh4gTpOBGtmREH4M6cYr2KfASTTdfy/RiVGh8N2O6PC7Ewo9D
         4LWu67oa5Ktru1mj5G2TwGk6rNeBboA6pZjXR1Apdvs+CSIYi5bjHGa8ALnI30MdgSXp
         KY4/kG6o0O7RM8QXmzake9rhVtmUzUfNj++tzwZYJ2VsF9ySO9HkYDHHeIh6SZGQbT/o
         ej/a71LVNWc4VcJ+ZEbAhoY8Srxtno8XmHgAw4YujIUDng5A+Y/NNl71S1p+sU3psmia
         t6Srjv2n7ANl0Mgr33//w9TBoeivnDvc8dVhsbydNBk4UWhWrXk6Tb+jPpR1DSKqAGBO
         dhXA==
X-Gm-Message-State: APjAAAVwnztjC3dhM5I6A8SqSIz+QMiAUCdMyA5kewqkMApYXS8bNWcT
        A+3YJCJJfiSQi32mfY9QY5SuS6vEOCsDbwsT20jenf/is0tQiC3Lu1eLT4txQfg34y3KXB/vKSk
        S1gJtXFKADwYzefhQ0IkPSJ7ylFsP/t8LP0KHRzcAGlZQ0puSil78sw==
X-Google-Smtp-Source: APXvYqz0PRT2NfpoI/BfN3hiTY3AKl4QlSqxORB3/nPz5Td4liHLi7Ysh4LPX79fqkdSKYhpPkOUOtg=
X-Received: by 2002:a63:fe52:: with SMTP id x18mr137739329pgj.344.1565019661971;
 Mon, 05 Aug 2019 08:41:01 -0700 (PDT)
Date:   Mon,  5 Aug 2019 08:40:54 -0700
In-Reply-To: <20190805154055.197664-1-sdf@google.com>
Message-Id: <20190805154055.197664-3-sdf@google.com>
Mime-Version: 1.0
References: <20190805154055.197664-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
Subject: [PATCH bpf-next v3 2/3] selftests/bpf: test_progs: test__printf -> printf
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that test__printf is a simple wraper around printf, let's drop it
(and test__vprintf as well).

Cc: Andrii Nakryiko <andriin@fb.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/bpf_verif_scale.c   |  4 ++--
 .../testing/selftests/bpf/prog_tests/l4lb_all.c  |  2 +-
 .../testing/selftests/bpf/prog_tests/map_lock.c  | 10 +++++-----
 .../selftests/bpf/prog_tests/send_signal.c       |  4 ++--
 .../testing/selftests/bpf/prog_tests/spinlock.c  |  2 +-
 .../bpf/prog_tests/stacktrace_build_id.c         |  4 ++--
 .../bpf/prog_tests/stacktrace_build_id_nmi.c     |  4 ++--
 .../selftests/bpf/prog_tests/xdp_noinline.c      |  4 ++--
 tools/testing/selftests/bpf/test_progs.c         | 16 +---------------
 tools/testing/selftests/bpf/test_progs.h         | 10 ++++------
 10 files changed, 22 insertions(+), 38 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
index b4be96162ff4..3548ba2f24a8 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
@@ -5,13 +5,13 @@ static int libbpf_debug_print(enum libbpf_print_level level,
 			      const char *format, va_list args)
 {
 	if (level != LIBBPF_DEBUG) {
-		test__vprintf(format, args);
+		vprintf(format, args);
 		return 0;
 	}
 
 	if (!strstr(format, "verifier log"))
 		return 0;
-	test__vprintf("%s", args);
+	vprintf("%s", args);
 	return 0;
 }
 
diff --git a/tools/testing/selftests/bpf/prog_tests/l4lb_all.c b/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
index 5ce572c03a5f..20ddca830e68 100644
--- a/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
+++ b/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
@@ -74,7 +74,7 @@ static void test_l4lb(const char *file)
 	}
 	if (bytes != MAGIC_BYTES * NUM_ITER * 2 || pkts != NUM_ITER * 2) {
 		error_cnt++;
-		test__printf("test_l4lb:FAIL:stats %lld %lld\n", bytes, pkts);
+		printf("test_l4lb:FAIL:stats %lld %lld\n", bytes, pkts);
 	}
 out:
 	bpf_object__close(obj);
diff --git a/tools/testing/selftests/bpf/prog_tests/map_lock.c b/tools/testing/selftests/bpf/prog_tests/map_lock.c
index 2e78217ed3fd..ee99368c595c 100644
--- a/tools/testing/selftests/bpf/prog_tests/map_lock.c
+++ b/tools/testing/selftests/bpf/prog_tests/map_lock.c
@@ -9,12 +9,12 @@ static void *parallel_map_access(void *arg)
 	for (i = 0; i < 10000; i++) {
 		err = bpf_map_lookup_elem_flags(map_fd, &key, vars, BPF_F_LOCK);
 		if (err) {
-			test__printf("lookup failed\n");
+			printf("lookup failed\n");
 			error_cnt++;
 			goto out;
 		}
 		if (vars[0] != 0) {
-			test__printf("lookup #%d var[0]=%d\n", i, vars[0]);
+			printf("lookup #%d var[0]=%d\n", i, vars[0]);
 			error_cnt++;
 			goto out;
 		}
@@ -22,8 +22,8 @@ static void *parallel_map_access(void *arg)
 		for (j = 2; j < 17; j++) {
 			if (vars[j] == rnd)
 				continue;
-			test__printf("lookup #%d var[1]=%d var[%d]=%d\n",
-				     i, rnd, j, vars[j]);
+			printf("lookup #%d var[1]=%d var[%d]=%d\n",
+			       i, rnd, j, vars[j]);
 			error_cnt++;
 			goto out;
 		}
@@ -43,7 +43,7 @@ void test_map_lock(void)
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_CGROUP_SKB, &obj, &prog_fd);
 	if (err) {
-		test__printf("test_map_lock:bpf_prog_load errno %d\n", errno);
+		printf("test_map_lock:bpf_prog_load errno %d\n", errno);
 		goto close_prog;
 	}
 	map_fd[0] = bpf_find_map(__func__, obj, "hash_map");
diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
index 461b423d0584..1575f0a1f586 100644
--- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
+++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
@@ -202,8 +202,8 @@ static int test_send_signal_nmi(void)
 			 -1 /* cpu */, -1 /* group_fd */, 0 /* flags */);
 	if (pmu_fd == -1) {
 		if (errno == ENOENT) {
-			test__printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n",
-				     __func__);
+			printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n",
+			       __func__);
 			return 0;
 		}
 		/* Let the test fail with a more informative message */
diff --git a/tools/testing/selftests/bpf/prog_tests/spinlock.c b/tools/testing/selftests/bpf/prog_tests/spinlock.c
index deb2db5b85b0..114ebe6a438e 100644
--- a/tools/testing/selftests/bpf/prog_tests/spinlock.c
+++ b/tools/testing/selftests/bpf/prog_tests/spinlock.c
@@ -12,7 +12,7 @@ void test_spinlock(void)
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_CGROUP_SKB, &obj, &prog_fd);
 	if (err) {
-		test__printf("test_spin_lock:bpf_prog_load errno %d\n", errno);
+		printf("test_spin_lock:bpf_prog_load errno %d\n", errno);
 		goto close_prog;
 	}
 	for (i = 0; i < 4; i++)
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
index 356d2c017a9c..ac44fda84833 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
@@ -109,8 +109,8 @@ void test_stacktrace_build_id(void)
 	if (build_id_matches < 1 && retry--) {
 		bpf_link__destroy(link);
 		bpf_object__close(obj);
-		test__printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
-			     __func__);
+		printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
+		       __func__);
 		goto retry;
 	}
 
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
index f44f2c159714..9557b7dfb782 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
@@ -140,8 +140,8 @@ void test_stacktrace_build_id_nmi(void)
 	if (build_id_matches < 1 && retry--) {
 		bpf_link__destroy(link);
 		bpf_object__close(obj);
-		test__printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
-			     __func__);
+		printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
+		       __func__);
 		goto retry;
 	}
 
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c b/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
index b5404494b8aa..15f7c272edb0 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
@@ -75,8 +75,8 @@ void test_xdp_noinline(void)
 	}
 	if (bytes != MAGIC_BYTES * NUM_ITER * 2 || pkts != NUM_ITER * 2) {
 		error_cnt++;
-		test__printf("test_xdp_noinline:FAIL:stats %lld %lld\n",
-			     bytes, pkts);
+		printf("test_xdp_noinline:FAIL:stats %lld %lld\n",
+		       bytes, pkts);
 	}
 out:
 	bpf_object__close(obj);
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 9556439c607c..963912008042 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -105,20 +105,6 @@ void test__force_log() {
 	env.test->force_log = true;
 }
 
-void test__vprintf(const char *fmt, va_list args)
-{
-	vprintf(fmt, args);
-}
-
-void test__printf(const char *fmt, ...)
-{
-	va_list args;
-
-	va_start(args, fmt);
-	test__vprintf(fmt, args);
-	va_end(args);
-}
-
 struct ipv4_packet pkt_v4 = {
 	.eth.h_proto = __bpf_constant_htons(ETH_P_IP),
 	.iph.ihl = 5,
@@ -310,7 +296,7 @@ static int libbpf_print_fn(enum libbpf_print_level level,
 {
 	if (!env.very_verbose && level == LIBBPF_DEBUG)
 		return 0;
-	test__vprintf(format, args);
+	vprintf(format, args);
 	return 0;
 }
 
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 4c00fc79ac5f..f346ea213140 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -69,8 +69,6 @@ extern int error_cnt;
 extern int pass_cnt;
 extern struct test_env env;
 
-extern void test__printf(const char *fmt, ...);
-extern void test__vprintf(const char *fmt, va_list args);
 extern void test__force_log();
 extern bool test__start_subtest(const char *name);
 
@@ -96,12 +94,12 @@ extern struct ipv6_packet pkt_v6;
 	int __ret = !!(condition);					\
 	if (__ret) {							\
 		error_cnt++;						\
-		test__printf("%s:FAIL:%s ", __func__, tag);		\
-		test__printf(format);					\
+		printf("%s:FAIL:%s ", __func__, tag);			\
+		printf(format);						\
 	} else {							\
 		pass_cnt++;						\
-		test__printf("%s:PASS:%s %d nsec\n",			\
-			      __func__, tag, duration);			\
+		printf("%s:PASS:%s %d nsec\n",				\
+		       __func__, tag, duration);			\
 	}								\
 	__ret;								\
 })
-- 
2.22.0.770.g0f2c4a37fd-goog

