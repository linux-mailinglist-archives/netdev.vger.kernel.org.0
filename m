Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A48522478D
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 02:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgGRAoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 20:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbgGRAog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 20:44:36 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3961C0619D2;
        Fri, 17 Jul 2020 17:44:35 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id u12so8986505qth.12;
        Fri, 17 Jul 2020 17:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2tqVato+GeUPAizvVRQoNj9dgAjuhICboxmwjSIV8YA=;
        b=Edj2yf6SuJ34UW+SMRkshEiUOmdEaMKUtUCNilb4JWzJ210Dvdkg4ixi2F2PH8UtZm
         RQLu6gOl8AfDYTgHYwFjrFI3v50ZcFiM8oWBJwsBkWlixlokB53/ac8eIPWiyDKWysCO
         5cXINiecu9+4gX/GaGEchBCVZHBUG/OCudcZyp0G+5CgKvamU5fkTt3SK6KfUkeEjhqo
         5X+sJKhc+mgVfx8G9n1GPCqptTfZ3BvN7byHmk9pjPdoOarcwPtAntx/GxMR7MmFZab5
         w7eq+rW69COa22X7wN/EcO7lLlEgNokB22BHXuJkG5RsWUrOoPEfDdivX5CIQErjGMMS
         jCyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2tqVato+GeUPAizvVRQoNj9dgAjuhICboxmwjSIV8YA=;
        b=ecT1qMbPyYcnzrDC6/P+QdpHh+ZlMOYqH7vtSQVeLbsqGGKFTIgxBuhCODkYRZgEem
         FygDTqawM5wnzdQpnD1r7nOcBvKvrvv/EJTHPLJ+LSLsuUeSP8u5ssjfXgx55UUHKxEx
         MRnXnkZ4LpmU0K5DwUtwK98RU4W7IgJRcWDPLr3XrT0bBUd728k/xXk9ShoSfRBUm8Of
         taHcqNS1KNYzzFeVcn4SdADkDL4B8su2jGDKEBlQV29Y02Nejvvr+PCIHviac/rel3QO
         k80IKkUBs3pqmaiH1NsIBm6ALzUU+oh3vnpZSsHU+NJfNpsmS2HAK5xr19k7jsaeFKca
         SgWw==
X-Gm-Message-State: AOAM531wJQCSZcF6GUpRooGbdMdfk2wmOLMIbiS7V9bxqhQ7fnvVV1VM
        eerB+YF0QrzaCuZFTGgbNT9vDAQm
X-Google-Smtp-Source: ABdhPJyAtay/RIjSwyYHTt56DVmS5IHCxJEKTgMbzusKGMepwYUPclEKG7l2WX7zf15ApmI/mRp5AA==
X-Received: by 2002:ac8:748b:: with SMTP id v11mr13272732qtq.293.1595033074080;
        Fri, 17 Jul 2020 17:44:34 -0700 (PDT)
Received: from localhost.localdomain (pc-199-79-45-190.cm.vtr.net. [190.45.79.199])
        by smtp.googlemail.com with ESMTPSA id a11sm10446411qkh.103.2020.07.17.17.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 17:44:33 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v3] folds tests from test_current_pid_tgid_new_ns into test_progs.
Date:   Fri, 17 Jul 2020 20:41:22 -0400
Message-Id: <20200718004122.37775-1-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/testing/selftests/bpf/.gitignore        |  2 +-
 tools/testing/selftests/bpf/Makefile          |  3 +-
 .../bpf/prog_tests/ns_current_pid_tgid.c      | 85 -----------------
 .../bpf/prog_tests/ns_current_pidtgid.c       | 59 ++++++++++++
 .../bpf/progs/test_ns_current_pid_tgid.c      | 37 --------
 .../bpf/progs/test_ns_current_pidtgid.c       | 25 +++++
 ...new_ns.c => test_current_pidtgid_new_ns.c} |  0
 .../bpf/test_ns_current_pidtgid_newns.c       | 91 +++++++++++++++++++
 8 files changed, 178 insertions(+), 124 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c
 delete mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
 rename tools/testing/selftests/bpf/{test_current_pid_tgid_new_ns.c => test_current_pidtgid_new_ns.c} (100%)
 create mode 100644 tools/testing/selftests/bpf/test_ns_current_pidtgid_newns.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 1bb204cee853..022055f23592 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -30,8 +30,8 @@ test_tcpnotify_user
 test_libbpf
 test_tcp_check_syncookie_user
 test_sysctl
-test_current_pid_tgid_new_ns
 xdping
+test_ns_current_pidtgid_newns
 test_cpp
 *.skel.h
 /no_alu32
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index e7a8cf83ba48..c1ba9c947196 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -37,7 +37,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_cgroup_storage \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
 	test_progs-no_alu32 \
-	test_current_pid_tgid_new_ns
+	test_ns_current_pidtgid_newns
 
 # Also test bpf-gcc, if present
 ifneq ($(BPF_GCC),)
@@ -163,6 +163,7 @@ $(OUTPUT)/test_cgroup_storage: cgroup_helpers.c
 $(OUTPUT)/test_netcnt: cgroup_helpers.c
 $(OUTPUT)/test_sock_fields: cgroup_helpers.c
 $(OUTPUT)/test_sysctl: cgroup_helpers.c
+$(OUTPUT)/test_ns_current_pidtgid_newns: test_ns_current_pidtgid_newns.c
 
 DEFAULT_BPFTOOL := $(SCRATCH_DIR)/sbin/bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
deleted file mode 100644
index e74dc501b27f..000000000000
--- a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
+++ /dev/null
@@ -1,85 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
-#include <test_progs.h>
-#include <sys/stat.h>
-#include <sys/types.h>
-#include <unistd.h>
-#include <sys/syscall.h>
-
-struct bss {
-	__u64 dev;
-	__u64 ino;
-	__u64 pid_tgid;
-	__u64 user_pid_tgid;
-};
-
-void test_ns_current_pid_tgid(void)
-{
-	const char *probe_name = "raw_tracepoint/sys_enter";
-	const char *file = "test_ns_current_pid_tgid.o";
-	int err, key = 0, duration = 0;
-	struct bpf_link *link = NULL;
-	struct bpf_program *prog;
-	struct bpf_map *bss_map;
-	struct bpf_object *obj;
-	struct bss bss;
-	struct stat st;
-	__u64 id;
-
-	obj = bpf_object__open_file(file, NULL);
-	if (CHECK(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
-		return;
-
-	err = bpf_object__load(obj);
-	if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
-		goto cleanup;
-
-	bss_map = bpf_object__find_map_by_name(obj, "test_ns_.bss");
-	if (CHECK(!bss_map, "find_bss_map", "failed\n"))
-		goto cleanup;
-
-	prog = bpf_object__find_program_by_title(obj, probe_name);
-	if (CHECK(!prog, "find_prog", "prog '%s' not found\n",
-		  probe_name))
-		goto cleanup;
-
-	memset(&bss, 0, sizeof(bss));
-	pid_t tid = syscall(SYS_gettid);
-	pid_t pid = getpid();
-
-	id = (__u64) tid << 32 | pid;
-	bss.user_pid_tgid = id;
-
-	if (CHECK_FAIL(stat("/proc/self/ns/pid", &st))) {
-		perror("Failed to stat /proc/self/ns/pid");
-		goto cleanup;
-	}
-
-	bss.dev = st.st_dev;
-	bss.ino = st.st_ino;
-
-	err = bpf_map_update_elem(bpf_map__fd(bss_map), &key, &bss, 0);
-	if (CHECK(err, "setting_bss", "failed to set bss : %d\n", err))
-		goto cleanup;
-
-	link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
-	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
-		  PTR_ERR(link))) {
-		link = NULL;
-		goto cleanup;
-	}
-
-	/* trigger some syscalls */
-	usleep(1);
-
-	err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
-	if (CHECK(err, "set_bss", "failed to get bss : %d\n", err))
-		goto cleanup;
-
-	if (CHECK(id != bss.pid_tgid, "Compare user pid/tgid vs. bpf pid/tgid",
-		  "User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
-		goto cleanup;
-cleanup:
-	bpf_link__destroy(link);
-	bpf_object__close(obj);
-}
diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c
new file mode 100644
index 000000000000..49578c0afbe0
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
+
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include "test_ns_current_pidtgid.skel.h"
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <sched.h>
+#include <sys/wait.h>
+#include <sys/mount.h>
+#include <sys/fcntl.h>
+
+void test_ns_current_pidtgid(void)
+{
+	int err, duration = 0;
+	struct test_ns_current_pidtgid *skel;
+	struct test_ns_current_pidtgid__bss  *bss;
+	struct stat st;
+	__u64 id;
+
+	skel = test_ns_current_pidtgid__open();
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		return;
+
+	err = test_ns_current_pidtgid__load(skel);
+	if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
+		goto cleanup;
+
+	pid_t tid = syscall(SYS_gettid);
+	pid_t pid = getpid();
+
+	id = (__u64) tid << 32 | pid;
+
+	if (CHECK_FAIL(stat("/proc/self/ns/pid", &st))) {
+		perror("Failed to stat /proc/self/ns/pid");
+		goto cleanup;
+	}
+
+	bss = skel->bss;
+	bss->dev = st.st_dev;
+	bss->ino = st.st_ino;
+	bss->user_pid_tgid = 0;
+
+	err = test_ns_current_pidtgid__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	/* trigger tracepoint */
+	usleep(1);
+
+	CHECK(bss->user_pid_tgid != id, "pid/tgid", "got %llu != exp %llu\n",
+		bss->user_pid_tgid, id);
+cleanup:
+	test_ns_current_pidtgid__destroy(skel);
+
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
deleted file mode 100644
index 1dca70a6de2f..000000000000
--- a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
+++ /dev/null
@@ -1,37 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
-
-#include <linux/bpf.h>
-#include <stdint.h>
-#include <bpf/bpf_helpers.h>
-
-static volatile struct {
-	__u64 dev;
-	__u64 ino;
-	__u64 pid_tgid;
-	__u64 user_pid_tgid;
-} res;
-
-SEC("raw_tracepoint/sys_enter")
-int trace(void *ctx)
-{
-	__u64  ns_pid_tgid, expected_pid;
-	struct bpf_pidns_info nsdata;
-	__u32 key = 0;
-
-	if (bpf_get_ns_current_pid_tgid(res.dev, res.ino, &nsdata,
-		   sizeof(struct bpf_pidns_info)))
-		return 0;
-
-	ns_pid_tgid = (__u64)nsdata.tgid << 32 | nsdata.pid;
-	expected_pid = res.user_pid_tgid;
-
-	if (expected_pid != ns_pid_tgid)
-		return 0;
-
-	res.pid_tgid = ns_pid_tgid;
-
-	return 0;
-}
-
-char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c b/tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
new file mode 100644
index 000000000000..9818a56510d9
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include <bpf/bpf_helpers.h>
+
+__u64 user_pid_tgid = 0;
+__u64 dev = 0;
+__u64 ino = 0;
+
+SEC("raw_tracepoint/sys_enter")
+int handler(const void *ctx)
+{
+	struct bpf_pidns_info nsdata;
+
+	if (bpf_get_ns_current_pid_tgid(dev, ino, &nsdata,
+		   sizeof(struct bpf_pidns_info)))
+		return 0;
+	user_pid_tgid = (__u64)nsdata.tgid << 32 | nsdata.pid;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c b/tools/testing/selftests/bpf/test_current_pidtgid_new_ns.c
similarity index 100%
rename from tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
rename to tools/testing/selftests/bpf/test_current_pidtgid_new_ns.c
diff --git a/tools/testing/selftests/bpf/test_ns_current_pidtgid_newns.c b/tools/testing/selftests/bpf/test_ns_current_pidtgid_newns.c
new file mode 100644
index 000000000000..3bca38941c99
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_ns_current_pidtgid_newns.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
+
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include "test_ns_current_pidtgid.skel.h"
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <sched.h>
+#include <sys/wait.h>
+#include <sys/mount.h>
+#include <sys/fcntl.h>
+
+#define STACK_SIZE (1024 * 1024)
+static char child_stack[STACK_SIZE];
+
+static int newns_pidtgid(void *arg)
+{
+	struct test_ns_current_pidtgid__bss  *bss;
+	struct test_ns_current_pidtgid *skel;
+	int pidns_fd = 0, err = 0;
+	pid_t pid, tid;
+	struct stat st;
+	__u64 id;
+
+	skel = test_ns_current_pidtgid__open();
+	err = test_ns_current_pidtgid__load(skel);
+	if (err) {
+		perror("Failed to load skeleton");
+		goto cleanup;
+	}
+
+	tid = syscall(SYS_gettid);
+	pid = getpid();
+	id = (__u64) tid << 32 | pid;
+
+	if (stat("/proc/self/ns/pid", &st)) {
+		printf("Failed to stat /proc/self/ns/pid: %s\n",
+			strerror(errno));
+		goto cleanup;
+	}
+
+	bss = skel->bss;
+	bss->dev = st.st_dev;
+	bss->ino = st.st_ino;
+	bss->user_pid_tgid = 0;
+
+	err = test_ns_current_pidtgid__attach(skel);
+	if (err) {
+		printf("Failed to attach: %s err: %d\n", strerror(errno), err);
+		goto cleanup;
+	}
+	/* trigger tracepoint */
+	usleep(1);
+
+	if (bss->user_pid_tgid != id) {
+		printf("test_ns_current_pidtgid_newns:FAIL\n");
+		err = EXIT_FAILURE;
+	} else {
+		printf("test_ns_current_pidtgid_newns:PASS\n");
+		err = EXIT_SUCCESS;
+	}
+
+cleanup:
+		setns(pidns_fd, CLONE_NEWPID);
+		test_ns_current_pidtgid__destroy(skel);
+
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	pid_t cpid;
+	int wstatus;
+
+	cpid = clone(newns_pidtgid,
+			child_stack + STACK_SIZE,
+			CLONE_NEWPID | SIGCHLD, NULL);
+	if (cpid == -1) {
+		printf("test_ns_current_pidtgid_newns:Failed on CLONE: %s\n",
+			 strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+	if (waitpid(cpid, &wstatus, 0) == -1) {
+		printf("test_ns_current_pidtgid_newns:Failed on waitpid: %s\n",
+			strerror(errno));
+	}
+	return (WEXITSTATUS(wstatus));
+}
-- 
2.20.1

