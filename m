Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E2C3689DE
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240046AbhDWA2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240246AbhDWA1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:27:48 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEB6C061343;
        Thu, 22 Apr 2021 17:27:11 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id f29so34010934pgm.8;
        Thu, 22 Apr 2021 17:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MSZWEa5YKt5V7xHQPx3Lj/jMJcC28D8C/YC9LTbupCg=;
        b=H/J937bnUKklAeWNs82hYsmwTr8X6iusjzYttsazgVhweuFeCSXnKZdArRmMkFDwrU
         cZ4Sp/psQmtwAejLzfFkt19imddvk/fS32Nbo7wN7ARcmeIjmCf7TFkieQsn3wiKBWVc
         bIRuql3NLX6Dl4MGdKPwFYUXqzUWaEKWDLoCo1K2ULte/BUOWoC1zgOoTGYXYtXI7me/
         xGmHtRywwrHpSitKt78QUC41zIttvoEi2jEO7AHsGS9qIIfvPB/sfwjg3QcUeXmkJ+K7
         bWbmkbmWNxgRc8drSwzal49hc548zsfiEVPVb8WTchcOJaEwQQqLQ8TJ2jZ3MOTmXYjL
         ZLmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MSZWEa5YKt5V7xHQPx3Lj/jMJcC28D8C/YC9LTbupCg=;
        b=rYwIOyNFTEI3GGNiEE6MalwSw14I3xTZ6s08qXWwbUaipLMuwWW+B6b2gPDk9VLM5p
         UYoDeK8Q3fCQ2/YRQCcj9z5DNJXJqsV4ZuBu3wULoeNcVdOAzaJex5CDacoW3uNmnJ48
         lubyAH1cc2MkO1xFJIsaaSNq8QRtIFDUW1GBHj6f0Etq4R6JA/MDpjLIpwdEWT7vRqCL
         LGXcfuROq3ppYI53NQWOF9r9XUrUT3Aw8sYHlw0KXoRSyyHxV6iX9n0eeJBS/KS+b7RN
         GW81mihJo59hroOHsv43uBTAwVk+F05TvVirSEjI+kOGSV/4EXPbArfB7YV/h3PWQgEv
         Uo+g==
X-Gm-Message-State: AOAM531lAHm/JrOyJ/VGrIdZKrLraaQADPjtHuQzhSV7m5J3XQNEanRa
        7EhXjfzbRiVGcivzHXleS9U=
X-Google-Smtp-Source: ABdhPJyR101Roowr0YQgy3WLmLD1T/WXihR/FqpFnjeZJ9uGs4LMFQX5of2YwOVtG9yXQ0fLOdPLRA==
X-Received: by 2002:a65:5801:: with SMTP id g1mr1215943pgr.322.1619137631151;
        Thu, 22 Apr 2021 17:27:11 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u12sm6390987pji.45.2021.04.22.17.27.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 17:27:10 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 16/16] selftests/bpf: Convert few tests to light skeleton.
Date:   Thu, 22 Apr 2021 17:26:46 -0700
Message-Id: <20210423002646.35043-17-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Convert few tests that don't use CO-RE to light skeleton.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/.gitignore            |  1 +
 tools/testing/selftests/bpf/Makefile              | 15 ++++++++++++++-
 .../selftests/bpf/prog_tests/fentry_fexit.c       |  6 +++---
 .../selftests/bpf/prog_tests/fentry_test.c        |  4 ++--
 .../selftests/bpf/prog_tests/fexit_sleep.c        |  6 +++---
 .../testing/selftests/bpf/prog_tests/fexit_test.c |  4 ++--
 .../testing/selftests/bpf/prog_tests/kfunc_call.c |  6 +++---
 .../selftests/bpf/prog_tests/ksyms_module.c       |  2 +-
 8 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 4866f6a21901..a030aa4a8a9e 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -30,6 +30,7 @@ test_sysctl
 xdping
 test_cpp
 *.skel.h
+*.lskel.h
 /no_alu32
 /bpf_gcc
 /tools
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 9fdfdbc61857..2db4262b2f40 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -312,6 +312,9 @@ SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
 
 LINKED_SKELS := test_static_linked.skel.h
 
+LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c test_ksyms_module.c
+SKEL_BLACKLIST += $$(LSKELS)
+
 test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
 
 # Set up extra TRUNNER_XXX "temporary" variables in the environment (relies on
@@ -334,6 +337,7 @@ TRUNNER_BPF_OBJS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.o, $$(TRUNNER_BPF_SRCS)
 TRUNNER_BPF_SKELS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.skel.h,	\
 				 $$(filter-out $(SKEL_BLACKLIST),	\
 					       $$(TRUNNER_BPF_SRCS)))
+TRUNNER_BPF_LSKELS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.lskel.h, $$(LSKELS))
 TRUNNER_BPF_SKELS_LINKED := $$(addprefix $$(TRUNNER_OUTPUT)/,$(LINKED_SKELS))
 TEST_GEN_FILES += $$(TRUNNER_BPF_OBJS)
 
@@ -375,6 +379,14 @@ $(TRUNNER_BPF_SKELS): %.skel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$(Q)diff $$(<:.o=.linked2.o) $$(<:.o=.linked3.o)
 	$(Q)$$(BPFTOOL) gen skeleton $$(<:.o=.linked3.o) name $$(notdir $$(<:.o=)) > $$@
 
+$(TRUNNER_BPF_LSKELS): %.lskel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
+	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
+	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked1.o) $$<
+	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked2.o) $$(<:.o=.linked1.o)
+	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked3.o) $$(<:.o=.linked2.o)
+	$(Q)diff $$(<:.o=.linked2.o) $$(<:.o=.linked3.o)
+	$(Q)$$(BPFTOOL) gen skeleton -L $$(<:.o=.linked3.o) name $$(notdir $$(<:.o=)) > $$@
+
 $(TRUNNER_BPF_SKELS_LINKED): $(TRUNNER_BPF_OBJS) $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$$(call msg,LINK-BPF,$(TRUNNER_BINARY),$$(@:.skel.h=.o))
 	$(Q)$$(BPFTOOL) gen object $$(@:.skel.h=.linked1.o) $$(addprefix $(TRUNNER_OUTPUT)/,$$($$(@F)-deps))
@@ -404,6 +416,7 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:			\
 		      $(TRUNNER_EXTRA_HDRS)				\
 		      $(TRUNNER_BPF_OBJS)				\
 		      $(TRUNNER_BPF_SKELS)				\
+		      $(TRUNNER_BPF_LSKELS)				\
 		      $(TRUNNER_BPF_SKELS_LINKED)			\
 		      $$(BPFOBJ) | $(TRUNNER_OUTPUT)
 	$$(call msg,TEST-OBJ,$(TRUNNER_BINARY),$$@)
@@ -511,6 +524,6 @@ $(OUTPUT)/bench: $(OUTPUT)/bench.o $(OUTPUT)/testing_helpers.o \
 EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR) $(HOST_SCRATCH_DIR)	\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
 	feature								\
-	$(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32 bpf_gcc bpf_testmod.ko)
+	$(addprefix $(OUTPUT)/,*.o *.skel.h *.lskel.h no_alu32 bpf_gcc bpf_testmod.ko)
 
 .PHONY: docs docs-clean
diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c b/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
index 109d0345a2be..91154c2ba256 100644
--- a/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 Facebook */
 #include <test_progs.h>
-#include "fentry_test.skel.h"
-#include "fexit_test.skel.h"
+#include "fentry_test.lskel.h"
+#include "fexit_test.lskel.h"
 
 void test_fentry_fexit(void)
 {
@@ -26,7 +26,7 @@ void test_fentry_fexit(void)
 	if (CHECK(err, "fexit_attach", "fexit attach failed: %d\n", err))
 		goto close_prog;
 
-	prog_fd = bpf_program__fd(fexit_skel->progs.test1);
+	prog_fd = fexit_skel->progs.test1.prog_fd;
 	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
 				NULL, NULL, &retval, &duration);
 	CHECK(err || retval, "ipv6",
diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
index 04ebbf1cb390..78062855b142 100644
--- a/tools/testing/selftests/bpf/prog_tests/fentry_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 Facebook */
 #include <test_progs.h>
-#include "fentry_test.skel.h"
+#include "fentry_test.lskel.h"
 
 void test_fentry_test(void)
 {
@@ -18,7 +18,7 @@ void test_fentry_test(void)
 	if (CHECK(err, "fentry_attach", "fentry attach failed: %d\n", err))
 		goto cleanup;
 
-	prog_fd = bpf_program__fd(fentry_skel->progs.test1);
+	prog_fd = fentry_skel->progs.test1.prog_fd;
 	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
 				NULL, NULL, &retval, &duration);
 	CHECK(err || retval, "test_run",
diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_sleep.c b/tools/testing/selftests/bpf/prog_tests/fexit_sleep.c
index ccc7e8a34ab6..4e7f4b42ea29 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_sleep.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_sleep.c
@@ -6,7 +6,7 @@
 #include <time.h>
 #include <sys/mman.h>
 #include <sys/syscall.h>
-#include "fexit_sleep.skel.h"
+#include "fexit_sleep.lskel.h"
 
 static int do_sleep(void *skel)
 {
@@ -58,8 +58,8 @@ void test_fexit_sleep(void)
 	 * waiting for percpu_ref_kill to confirm). The other one
 	 * will be freed quickly.
 	 */
-	close(bpf_program__fd(fexit_skel->progs.nanosleep_fentry));
-	close(bpf_program__fd(fexit_skel->progs.nanosleep_fexit));
+	close(fexit_skel->progs.nanosleep_fentry.prog_fd);
+	close(fexit_skel->progs.nanosleep_fexit.prog_fd);
 	fexit_sleep__detach(fexit_skel);
 
 	/* kill the thread to unwind sys_nanosleep stack through the trampoline */
diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_test.c b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
index 78d7a2765c27..be75d0c1018a 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 Facebook */
 #include <test_progs.h>
-#include "fexit_test.skel.h"
+#include "fexit_test.lskel.h"
 
 void test_fexit_test(void)
 {
@@ -18,7 +18,7 @@ void test_fexit_test(void)
 	if (CHECK(err, "fexit_attach", "fexit attach failed: %d\n", err))
 		goto cleanup;
 
-	prog_fd = bpf_program__fd(fexit_skel->progs.test1);
+	prog_fd = fexit_skel->progs.test1.prog_fd;
 	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
 				NULL, NULL, &retval, &duration);
 	CHECK(err || retval, "test_run",
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index 7fc0951ee75f..30a7b9b837bf 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -2,7 +2,7 @@
 /* Copyright (c) 2021 Facebook */
 #include <test_progs.h>
 #include <network_helpers.h>
-#include "kfunc_call_test.skel.h"
+#include "kfunc_call_test.lskel.h"
 #include "kfunc_call_test_subprog.skel.h"
 
 static void test_main(void)
@@ -14,13 +14,13 @@ static void test_main(void)
 	if (!ASSERT_OK_PTR(skel, "skel"))
 		return;
 
-	prog_fd = bpf_program__fd(skel->progs.kfunc_call_test1);
+	prog_fd = skel->progs.kfunc_call_test1.prog_fd;
 	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
 				NULL, NULL, (__u32 *)&retval, NULL);
 	ASSERT_OK(err, "bpf_prog_test_run(test1)");
 	ASSERT_EQ(retval, 12, "test1-retval");
 
-	prog_fd = bpf_program__fd(skel->progs.kfunc_call_test2);
+	prog_fd = skel->progs.kfunc_call_test2.prog_fd;
 	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
 				NULL, NULL, (__u32 *)&retval, NULL);
 	ASSERT_OK(err, "bpf_prog_test_run(test2)");
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
index 4c232b456479..2cd5cded543f 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
@@ -4,7 +4,7 @@
 #include <test_progs.h>
 #include <bpf/libbpf.h>
 #include <bpf/btf.h>
-#include "test_ksyms_module.skel.h"
+#include "test_ksyms_module.lskel.h"
 
 static int duration;
 
-- 
2.30.2

