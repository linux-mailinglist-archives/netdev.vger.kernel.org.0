Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56B15179A57
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgCDUmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:42:54 -0500
Received: from mail-qk1-f178.google.com ([209.85.222.178]:33655 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388230AbgCDUmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 15:42:54 -0500
Received: by mail-qk1-f178.google.com with SMTP id p62so3088086qkb.0;
        Wed, 04 Mar 2020 12:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HQgb+cG4NkJXbnS+nj0Rdtq6SmKME6zMCxCGCB6CvAY=;
        b=gvnIrR+Fo17aHtz6sgCzGEJbMkWl5bKEWAXpa1xKU1XXDrOGm/OiMIAlxolImZQftc
         E+Kw/OzRo9FRlKmldQwpVpfzkxuRnPemQRkGmjOVd9GNjWsD5rOl1GvDKysjqJm/aMC7
         +tnfEGGvkRdYq32n/dpA5Uh6HWwa07X+kjW6Pdvl2psSX+tMjKHUA4o/xysLTv/9T3+w
         HEGsgUQJjvzZQmCkKyo7qrihNo4ewsTR78MxR4b8ONU5+BZND+pC1DbA0kUlXMVwMIBm
         cFbsFg+ev14fbtTheuryBCRx3fN2ZvSbypr2HpU85kxKCkrjGFtLJEggJa0KZvy/0P2Z
         CSzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HQgb+cG4NkJXbnS+nj0Rdtq6SmKME6zMCxCGCB6CvAY=;
        b=XwGWMqbV3Pz7YVaWf1ov1GvGwIRfxHFhTEc48u4mz+2SpbjW/oL/vQnJZZ6opheMWn
         iVlhWN/5v9AYKE/YgdICmMWTKT7jXi0Fj0FdgBrnEM2nv+HmyoUHew9vpHEjeAzKSWMX
         uC5Mc8tdNSdOAhucVbDK4NHBHCjIBAlVmrExLu99cKr1T0mRZuzkIpm4hhLuCys23r6C
         iFyvYM4F1/6UVUhDfbtLFQ0vIzgNvoK7w6rnuvO0GEonUMzTxHYaWvmzkIk8X3dA3FGf
         Sg1YectW4itoSqdruyibf5+vrKGZSBgN1IGGvHcOrrX1WJGwwhAmc+oKsWrPxV6/nZC6
         DIMg==
X-Gm-Message-State: ANhLgQ3ma/Rb+bn/3Tw5KEAo6hqxy2/muvPbc2ZtKvRiEZa6mWHLWWqM
        gRuFvDY1A81IYKPZW2pdKltGRzqqqnA=
X-Google-Smtp-Source: ADFU+vvf4fC5BLknlP1Of1MfY9/b3dGqUj1faYZIH7gpgJjiE18Y7hA4ncnSsZrPTd7aPIOxUlDS6A==
X-Received: by 2002:a05:620a:228f:: with SMTP id o15mr344854qkh.197.1583354572768;
        Wed, 04 Mar 2020 12:42:52 -0800 (PST)
Received: from localhost.localdomain (pc-184-104-160-190.cm.vtr.net. [190.160.104.184])
        by smtp.googlemail.com with ESMTPSA id 82sm1750232qko.91.2020.03.04.12.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 12:42:52 -0800 (PST)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v17 3/3] tools/testing/selftests/bpf: Add self-tests for new helper bpf_get_ns_current_pid_tgid.
Date:   Wed,  4 Mar 2020 17:41:57 -0300
Message-Id: <20200304204157.58695-4-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200304204157.58695-1-cneirabustos@gmail.com>
References: <20200304204157.58695-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Self tests added for new helper bpf_get_ns_current_pid_tgid

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/prog_tests/ns_current_pid_tgid.c      |  88 ++++++++++
 .../bpf/progs/test_ns_current_pid_tgid.c      |  37 ++++
 .../bpf/test_current_pid_tgid_new_ns.c        | 159 ++++++++++++++++++
 4 files changed, 286 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 2d7f5df33f04..ea77239095a1 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -32,7 +32,8 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
-	test_progs-no_alu32
+	test_progs-no_alu32 \
+	test_current_pid_tgid_new_ns
 
 # Also test bpf-gcc, if present
 ifneq ($(BPF_GCC),)
diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
new file mode 100644
index 000000000000..542240e16564
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
+#include <test_progs.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <sys/syscall.h>
+
+struct bss {
+	__u64 dev;
+	__u64 ino;
+	__u64 pid_tgid;
+	__u64 user_pid_tgid;
+};
+
+void test_ns_current_pid_tgid(void)
+{
+	const char *probe_name = "raw_tracepoint/sys_enter";
+	const char *file = "test_ns_current_pid_tgid.o";
+	int err, key = 0, duration = 0;
+	struct bpf_link *link = NULL;
+	struct bpf_program *prog;
+	struct bpf_map *bss_map;
+	struct bpf_object *obj;
+	struct bss bss;
+	struct stat st;
+	__u64 id;
+
+	obj = bpf_object__open_file(file, NULL);
+	if (CHECK(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
+		return;
+
+	err = bpf_object__load(obj);
+	if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
+		goto cleanup;
+
+	bss_map = bpf_object__find_map_by_name(obj, "test_ns_.bss");
+	if (CHECK(!bss_map, "find_bss_map", "failed\n"))
+		goto cleanup;
+
+	prog = bpf_object__find_program_by_title(obj, probe_name);
+	if (CHECK(!prog, "find_prog", "prog '%s' not found\n",
+		  probe_name))
+		goto cleanup;
+
+	memset(&bss, 0, sizeof(bss));
+	pid_t tid = syscall(SYS_gettid);
+	pid_t pid = getpid();
+
+	id = (__u64) tid << 32 | pid;
+	bss.user_pid_tgid = id;
+
+	if (CHECK_FAIL(stat("/proc/self/ns/pid", &st))) {
+		perror("Failed to stat /proc/self/ns/pid");
+		goto cleanup;
+	}
+
+	bss.dev = st.st_dev;
+	bss.ino = st.st_ino;
+
+	err = bpf_map_update_elem(bpf_map__fd(bss_map), &key, &bss, 0);
+	if (CHECK(err, "setting_bss", "failed to set bss : %d\n", err))
+		goto cleanup;
+
+	link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
+	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
+		  PTR_ERR(link))) {
+		link = NULL;
+		goto cleanup;
+	}
+
+	/* trigger some syscalls */
+	usleep(1);
+
+	err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
+	if (CHECK(err, "set_bss", "failed to get bss : %d\n", err))
+		goto cleanup;
+
+	if (CHECK(id != bss.pid_tgid, "Compare user pid/tgid vs. bpf pid/tgid",
+		  "User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
+		goto cleanup;
+cleanup:
+	if (!link) {
+		bpf_link__destroy(link);
+		link = NULL;
+	}
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
new file mode 100644
index 000000000000..1dca70a6de2f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include <bpf/bpf_helpers.h>
+
+static volatile struct {
+	__u64 dev;
+	__u64 ino;
+	__u64 pid_tgid;
+	__u64 user_pid_tgid;
+} res;
+
+SEC("raw_tracepoint/sys_enter")
+int trace(void *ctx)
+{
+	__u64  ns_pid_tgid, expected_pid;
+	struct bpf_pidns_info nsdata;
+	__u32 key = 0;
+
+	if (bpf_get_ns_current_pid_tgid(res.dev, res.ino, &nsdata,
+		   sizeof(struct bpf_pidns_info)))
+		return 0;
+
+	ns_pid_tgid = (__u64)nsdata.tgid << 32 | nsdata.pid;
+	expected_pid = res.user_pid_tgid;
+
+	if (expected_pid != ns_pid_tgid)
+		return 0;
+
+	res.pid_tgid = ns_pid_tgid;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c b/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
new file mode 100644
index 000000000000..16e94effa5f5
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
@@ -0,0 +1,159 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
+#define _GNU_SOURCE
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <sched.h>
+#include <sys/wait.h>
+#include <sys/mount.h>
+#include "test_progs.h"
+
+#define CHECK_NEWNS(condition, tag, format...) ({		\
+	int __ret = !!(condition);			\
+	if (__ret) {					\
+		printf("%s:FAIL:%s ", __func__, tag);	\
+		printf(format);				\
+	} else {					\
+		printf("%s:PASS:%s\n", __func__, tag);	\
+	}						\
+	__ret;						\
+})
+
+struct bss {
+	__u64 dev;
+	__u64 ino;
+	__u64 pid_tgid;
+	__u64 user_pid_tgid;
+};
+
+int main(int argc, char **argv)
+{
+	pid_t pid;
+	int exit_code = 1;
+	struct stat st;
+
+	printf("Testing bpf_get_ns_current_pid_tgid helper in new ns\n"); 
+
+	if (stat("/proc/self/ns/pid", &st)) {
+		perror("stat failed on /proc/self/ns/pid ns\n");
+		printf("%s:FAILED\n", argv[0]);
+		return exit_code;
+	}
+
+	if (CHECK_NEWNS(unshare(CLONE_NEWPID | CLONE_NEWNS),
+			"unshare CLONE_NEWPID | CLONE_NEWNS", "error errno=%d\n", errno))
+		return exit_code;
+
+	pid = fork();
+	if (pid == -1) {
+		perror("Fork() failed\n");
+		printf("%s:FAILED\n", argv[0]);
+		return exit_code;
+	}
+
+	if (pid > 0) {
+		int status;
+
+		usleep(5);
+		waitpid(pid, &status, 0);
+		return 0;
+	} else {
+
+		pid = fork();
+		if (pid == -1) {
+			perror("Fork() failed\n");
+			printf("%s:FAILED\n", argv[0]);
+			return exit_code;
+		}
+
+		if (pid > 0) {
+			int status;
+			waitpid(pid, &status, 0);
+			return 0;
+		} else {
+			if (CHECK_NEWNS(mount("none", "/proc", NULL, MS_PRIVATE|MS_REC, NULL),
+				"Unmounting proc", "Cannot umount proc! errno=%d\n", errno))
+				return exit_code;
+
+			if (CHECK_NEWNS(mount("proc", "/proc", "proc", MS_NOSUID|MS_NOEXEC|MS_NODEV, NULL),
+				"Mounting proc", "Cannot mount proc! errno=%d\n", errno))
+				return exit_code;
+
+			const char *probe_name = "raw_tracepoint/sys_enter";
+			const char *file = "test_ns_current_pid_tgid.o";
+			struct bpf_link *link = NULL;
+			struct bpf_program *prog;
+			struct bpf_map *bss_map;
+			struct bpf_object *obj;
+			int exit_code = 1;
+			int err, key = 0;
+			struct bss bss;
+			struct stat st;
+			__u64 id;
+
+			obj = bpf_object__open_file(file, NULL);
+			if (CHECK_NEWNS(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
+				return exit_code;
+
+			err = bpf_object__load(obj);
+			if (CHECK_NEWNS(err, "obj_load", "err %d errno %d\n", err, errno))
+				goto cleanup;
+
+			bss_map = bpf_object__find_map_by_name(obj, "test_ns_.bss");
+			if (CHECK_NEWNS(!bss_map, "find_bss_map", "failed\n"))
+				goto cleanup;
+
+			prog = bpf_object__find_program_by_title(obj, probe_name);
+			if (CHECK_NEWNS(!prog, "find_prog", "prog '%s' not found\n",
+						probe_name))
+				goto cleanup;
+
+			memset(&bss, 0, sizeof(bss));
+			pid_t tid = syscall(SYS_gettid);
+			pid_t pid = getpid();
+
+			id = (__u64) tid << 32 | pid;
+			bss.user_pid_tgid = id;
+
+			if (CHECK_NEWNS(stat("/proc/self/ns/pid", &st),
+				"stat new ns", "Failed to stat /proc/self/ns/pid errno=%d\n", errno))
+				goto cleanup;
+
+			bss.dev = st.st_dev;
+			bss.ino = st.st_ino;
+
+			err = bpf_map_update_elem(bpf_map__fd(bss_map), &key, &bss, 0);
+			if (CHECK_NEWNS(err, "setting_bss", "failed to set bss : %d\n", err))
+				goto cleanup;
+
+			link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
+			if (CHECK_NEWNS(IS_ERR(link), "attach_raw_tp", "err %ld\n",
+						PTR_ERR(link))) {
+				link = NULL;
+				goto cleanup;
+			}
+
+			/* trigger some syscalls */
+			usleep(1);
+
+			err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
+			if (CHECK_NEWNS(err, "set_bss", "failed to get bss : %d\n", err))
+				goto cleanup;
+
+			if (CHECK_NEWNS(id != bss.pid_tgid, "Compare user pid/tgid vs. bpf pid/tgid",
+						"User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
+				goto cleanup;
+
+			exit_code = 0;
+			printf("%s:PASS\n", argv[0]);
+cleanup:
+			if (!link) {
+				bpf_link__destroy(link);
+				link = NULL;
+			}
+			bpf_object__close(obj);
+		}
+	}
+}
-- 
2.20.1

