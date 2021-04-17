Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E14362D53
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 05:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbhDQDeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 23:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235672AbhDQDdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 23:33:53 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1DDC061345;
        Fri, 16 Apr 2021 20:32:49 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id u7so13145192plr.6;
        Fri, 16 Apr 2021 20:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Xwi8qmk85vARK+v/2qMVVBWBRVIxCX543LfuhxAUyzA=;
        b=b7YM8WJIRO9RnQ+oNSrLXRaRP7ZmdmGbC6eJYF5sROzNoF+UL9kDu12RAmdjMo0y+P
         LxQWZZSWaonwr1fTlqhAMt/90i4J5WtfN+RkzFOfB9lIZt9+OLHXQOuRnyTz5Qw8JTFZ
         tuvtXcHcrq2Vn7+msOG4wVaWNDOCRkSANVatTqffF+TYZdfOugj55qRwApHU2Lf3wymX
         hHkN76NA7kkvZ0jPg0jxdmmu74j29gXnY5gqweN5/x4gsknbuNV66qgr4tFXVyemvoyR
         SoSEW1cLl/h/9OdX9S8SCSFjHPhMupObbhRUsfW6ellm+RZdQ6PhTictN7qwMd0BGm1w
         kEHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Xwi8qmk85vARK+v/2qMVVBWBRVIxCX543LfuhxAUyzA=;
        b=CKX9jBe1s9zYQBhS50I4KQAdBQei9oo0ACxcjlA4QIrAHfzbzDadghE2HDd0Fi8ueg
         CePSUG25qFFmCbGuJ8h8pLHBtDTE6d8zgQVL0srBfHGj6Cmu2AnoQoSIeBYUHSM8/YGq
         hIPCMUSDt6uRQABZ+odyWWMWrx4i6bl7fWMymtbMRugfSUOKNpZY1Sz0lh4Hme7JDnuh
         rT1c7rSv0+OLwmLkUTd4NJzWUNfPKITi9Akr7DH/l4xyoQaik2sGGvrftTf0h4h6TdKM
         l46cahMVqvJhIth9MEYON2GB2F9UTQgYRQ/1MtPiARqCnab3qFsMk8Dtlh4X6RIXJzau
         aI8w==
X-Gm-Message-State: AOAM531U5i5M5mu52OE8rrMdA30qumSzXBFWkV73YXR5KA3TvYstjy5l
        N4XNlu85eTOP8P+bFagZS8YLZkPzkj0=
X-Google-Smtp-Source: ABdhPJwGb52siwy8OZypB3cIjYpqOKA/exgcnm5FvAExJpg6yD4SvqhUydbjPEatLtGISTZj3HMbMg==
X-Received: by 2002:a17:902:d645:b029:e8:ec90:d097 with SMTP id y5-20020a170902d645b02900e8ec90d097mr12350186plh.47.1618630368519;
        Fri, 16 Apr 2021 20:32:48 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id h1sm6069870pgv.88.2021.04.16.20.32.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Apr 2021 20:32:47 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 15/15] selftests/bpf: Convert few tests to light skeleton.
Date:   Fri, 16 Apr 2021 20:32:24 -0700
Message-Id: <20210417033224.8063-16-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
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
 7 files changed, 28 insertions(+), 14 deletions(-)

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
index 5e618ff1e8fd..e3f42df0e250 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -311,6 +311,9 @@ SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
 
 LINKED_SKELS := test_static_linked.skel.h
 
+LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c
+SKEL_BLACKLIST += $$(LSKELS)
+
 test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
 
 # Set up extra TRUNNER_XXX "temporary" variables in the environment (relies on
@@ -333,6 +336,7 @@ TRUNNER_BPF_OBJS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.o, $$(TRUNNER_BPF_SRCS)
 TRUNNER_BPF_SKELS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.skel.h,	\
 				 $$(filter-out $(SKEL_BLACKLIST),	\
 					       $$(TRUNNER_BPF_SRCS)))
+TRUNNER_BPF_LSKELS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.lskel.h, $$(LSKELS))
 TRUNNER_BPF_SKELS_LINKED := $$(addprefix $$(TRUNNER_OUTPUT)/,$(LINKED_SKELS))
 TEST_GEN_FILES += $$(TRUNNER_BPF_OBJS)
 
@@ -374,6 +378,14 @@ $(TRUNNER_BPF_SKELS): %.skel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
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
@@ -403,6 +415,7 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:			\
 		      $(TRUNNER_EXTRA_HDRS)				\
 		      $(TRUNNER_BPF_OBJS)				\
 		      $(TRUNNER_BPF_SKELS)				\
+		      $(TRUNNER_BPF_LSKELS)				\
 		      $(TRUNNER_BPF_SKELS_LINKED)			\
 		      $$(BPFOBJ) | $(TRUNNER_OUTPUT)
 	$$(call msg,TEST-OBJ,$(TRUNNER_BINARY),$$@)
@@ -510,6 +523,6 @@ $(OUTPUT)/bench: $(OUTPUT)/bench.o $(OUTPUT)/testing_helpers.o \
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
-- 
2.30.2

