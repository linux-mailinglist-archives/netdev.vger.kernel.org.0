Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6511BCB13
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732432AbfIXPUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:20:34 -0400
Received: from mail-qk1-f169.google.com ([209.85.222.169]:42003 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731643AbfIXPUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:20:34 -0400
Received: by mail-qk1-f169.google.com with SMTP id f16so2151840qkl.9;
        Tue, 24 Sep 2019 08:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=39ft0VWg4fce//AGmM6MxERxPxbG5AIm3iEKhOWgxnk=;
        b=JZuUEeD5ov84QjGV0tmmE5WwBtm5sHvZpajTodCDXTKF1u2j8AnbdTO5RMFeD0Y+wS
         BtdoYfraJ+CkqEzn5+vUw/bN7J1eu62wsI+QpMywxp2m8JrZoaadMFUg6pbkgdv/2HaV
         tpqH1jVQjEpolCs43C9++WRCHImlaSgFR2/+rizLH5fOTW+jT85rOqgCk0xvBdlvWa2P
         de9sKHfk8m+y600MpNUCh0AZrrS5Eu0ILNnsyPUrQ24eZmzwOTtBPbE3HtX06oXh3ub9
         VL3aok8dRinmQPm4Z6Qjyzv9zo47MTw5Lp4qzrGSlOWnt+xmcc9WhRLCrbtIMFCo0zZA
         RbOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=39ft0VWg4fce//AGmM6MxERxPxbG5AIm3iEKhOWgxnk=;
        b=UU+OmBAnxnLmBwDNfLCkRX8Da5UTD66m/a9B9gbrNtoP1KA+oqCWmyffkoyNtDTLbS
         5ZCKsbfbm2TyJpwatIm5dbX99uQB0qNJi5ZbVp+/tieivgWrY55wp3nNtMEXLw/50QsX
         gy3dW7UU3eR64zOX+ZNTWAo9EAJtxrEu4ItC9yAI97kN582t3455T7ST97/mp1YMQsNa
         o+8DsvHgfd0BT09hLqJ1u8zrYWZf961AeiOZl0aBoMekLQ94nTwSmilg5J6XLktVmV/R
         NkQHE91DAdsC8sSV4nwIP1+4juODG/UB72Ra6kq5iBcazkrKDYfckv9xrkTCgFrfZA16
         XwNQ==
X-Gm-Message-State: APjAAAX8L8NVVQidxLEN/mkn4jm04HYuNeIq8ONqD00UomMplrlvEY5g
        NalwG8amUWKDjBX92GNDdmWPpdFPxaU=
X-Google-Smtp-Source: APXvYqwqtz/sE7IXdJWR4aEyZzqqKkoITIFV7ru1pQONA74gv7P3vaUSL0wk8EBoFJpfGoIo1lRd2A==
X-Received: by 2002:a37:5cc1:: with SMTP id q184mr2994415qkb.212.1569338432234;
        Tue, 24 Sep 2019 08:20:32 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id h68sm1073533qkd.35.2019.09.24.08.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 08:20:31 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH bpf-next v11 4/4] tools/testing/selftests/bpf: Add self-tests for new helper. 
Date:   Tue, 24 Sep 2019 12:20:05 -0300
Message-Id: <20190924152005.4659-5-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924152005.4659-1-cneirabustos@gmail.com>
References: <20190924152005.4659-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Self tests added for new helper

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/testing/selftests/bpf/Makefile          |   2 +-
 tools/testing/selftests/bpf/bpf_helpers.h     |   3 +
 .../selftests/bpf/progs/test_pidns_kern.c     |  71 ++++++++
 tools/testing/selftests/bpf/test_pidns.c      | 152 ++++++++++++++++++
 4 files changed, 227 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_pidns_kern.c
 create mode 100644 tools/testing/selftests/bpf/test_pidns.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 7f3196af1ae4..d86b28aa8f44 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -28,7 +28,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
-	test_btf_dump test_cgroup_attach xdping
+	test_btf_dump test_cgroup_attach xdping test_pidns
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 6c4930bc6e2e..03d0e15ae29f 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -231,6 +231,9 @@ static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
 static long long (*bpf_tcp_gen_syncookie)(struct bpf_sock *sk, void *ip,
 					  int ip_len, void *tcp, int tcp_len) =
 	(void *) BPF_FUNC_tcp_gen_syncookie;
+static int (*bpf_get_ns_current_pid_tgid)(__u32 dev, __u64 inum) =
+	(void *) BPF_FUNC_get_ns_current_pid_tgid;
+
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
diff --git a/tools/testing/selftests/bpf/progs/test_pidns_kern.c b/tools/testing/selftests/bpf/progs/test_pidns_kern.c
new file mode 100644
index 000000000000..96cb707db3ee
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_pidns_kern.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Carlos Neira cneirabustos@gmail.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} ns_inum_map SEC(".maps");
+
+struct  {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} ns_dev_map SEC(".maps");
+
+struct   {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} pidmap SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} ns_pid_map SEC(".maps");
+
+
+
+SEC("tracepoint/syscalls/sys_enter_nanosleep")
+int trace(void *ctx)
+{
+	__u32 key = 0, *expected_pid, *dev;
+	__u64 *val, *inum, nspid;
+	__u32 pid;
+
+	dev = bpf_map_lookup_elem(&ns_dev_map, &key);
+	if (!dev)
+		return 0;
+
+	inum = bpf_map_lookup_elem(&ns_inum_map, &key);
+	if (!inum)
+		return 0;
+
+	nspid = bpf_get_ns_current_pid_tgid(*dev, *inum);
+	expected_pid = bpf_map_lookup_elem(&pidmap, &key);
+
+	if (!expected_pid || *expected_pid != nspid)
+		return 0;
+
+	val = bpf_map_lookup_elem(&ns_pid_map, &key);
+	if (val)
+		*val = nspid;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/test_pidns.c b/tools/testing/selftests/bpf/test_pidns.c
new file mode 100644
index 000000000000..088f8025f2bf
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_pidns.c
@@ -0,0 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Carlos Neira cneirabustos@gmail.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <syscall.h>
+#include <unistd.h>
+#include <linux/perf_event.h>
+#include <sys/ioctl.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include <linux/bpf.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "cgroup_helpers.h"
+#include "bpf_rlimit.h"
+
+#define CHECK(condition, tag, format...) ({		\
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
+static int bpf_find_map(const char *test, struct bpf_object *obj,
+			const char *name)
+{
+	struct bpf_map *map;
+
+	map = bpf_object__find_map_by_name(obj, name);
+	if (!map)
+		return -1;
+	return bpf_map__fd(map);
+}
+
+
+int main(int argc, char **argv)
+{
+	int pidmap_fd, ns_inum_map_fd, ns_dev_map_fd, ns_pid_map_fd;
+	const char *probe_name = "syscalls/sys_enter_nanosleep";
+	const char *file = "test_pidns_kern.o";
+	int err, bytes, efd, prog_fd, pmu_fd;
+	struct perf_event_attr attr = {};
+	struct bpf_object *obj;
+	__u32 nspid = 0;
+	__u32 key = 0, pid;
+	int exit_code = 1;
+	struct stat st;
+	char buf[256];
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_TRACEPOINT, &obj, &prog_fd);
+	if (CHECK(err, "bpf_prog_load", "err %d errno %d\n", err, errno))
+		goto cleanup_cgroup_env;
+
+	ns_dev_map_fd = bpf_find_map(__func__, obj, "ns_dev_map");
+	if (CHECK(ns_dev_map_fd < 0, "bpf_find_map", "err %d errno %d\n",
+		  ns_dev_map_fd, errno))
+		goto close_prog;
+
+	ns_inum_map_fd = bpf_find_map(__func__, obj, "ns_inum_map");
+	if (CHECK(ns_inum_map_fd < 0, "bpf_find_map", "err %d errno %d\n",
+		  ns_inum_map_fd, errno))
+		goto close_prog;
+
+	ns_pid_map_fd = bpf_find_map(__func__, obj, "ns_pid_map");
+	if (CHECK(ns_pid_map_fd < 0, "bpf_find_map", "err %d errno %d\n",
+		  ns_pid_map_fd, errno))
+		goto close_prog;
+
+	pidmap_fd = bpf_find_map(__func__, obj, "pidmap");
+	if (CHECK(pidmap_fd < 0, "bpf_find_map", "err %d errno %d\n",
+		  pidmap_fd, errno))
+		goto close_prog;
+
+	pid = getpid();
+	bpf_map_update_elem(pidmap_fd, &key, &pid, 0);
+
+	if (stat("/proc/self/ns/pid", &st))
+		goto close_prog;
+
+	bpf_map_update_elem(ns_inum_map_fd, &key, &st.st_ino, 0);
+	bpf_map_update_elem(ns_dev_map_fd, &key, &st.st_dev, 0);
+
+
+	snprintf(buf, sizeof(buf),
+		 "/sys/kernel/debug/tracing/events/%s/id", probe_name);
+	efd = open(buf, O_RDONLY, 0);
+	if (CHECK(efd < 0, "open", "err %d errno %d\n", efd, errno))
+		goto close_prog;
+	bytes = read(efd, buf, sizeof(buf));
+	close(efd);
+	if (CHECK(bytes <= 0 || bytes >= sizeof(buf), "read",
+		  "bytes %d errno %d\n", bytes, errno))
+		goto close_prog;
+
+	attr.config = strtol(buf, NULL, 0);
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.sample_type = PERF_SAMPLE_RAW;
+	attr.sample_period = 1;
+	attr.wakeup_events = 1;
+
+	pmu_fd = syscall(__NR_perf_event_open, &attr, getpid(), -1, -1, 0);
+	if (CHECK(pmu_fd < 0, "perf_event_open", "err %d errno %d\n", pmu_fd,
+		  errno))
+		goto close_prog;
+
+	err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
+	if (CHECK(err, "perf_event_ioc_enable", "err %d errno %d\n", err,
+		  errno))
+		goto close_pmu;
+
+	err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
+	if (CHECK(err, "perf_event_ioc_set_bpf", "err %d errno %d\n", err,
+		  errno))
+		goto close_pmu;
+
+	/* trigger some syscalls */
+	sleep(1);
+
+	err = bpf_map_lookup_elem(ns_pid_map_fd, &key, &nspid);
+	if (CHECK(err, "bpf_map_lookup_elem", "err %d errno %d\n", err, errno))
+		goto close_pmu;
+
+	if (CHECK(nspid != pid, "compare nspid vs pid",
+		  "kern nspid %u user pid %u", nspid, pid))
+		goto close_pmu;
+
+	exit_code = 0;
+	printf("%s:PASS\n", argv[0]);
+
+close_pmu:
+	close(pmu_fd);
+close_prog:
+	bpf_object__close(obj);
+cleanup_cgroup_env:
+	return exit_code;
+}
-- 
2.20.1

