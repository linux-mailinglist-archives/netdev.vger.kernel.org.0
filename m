Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B35DC42DF
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbfJAVmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:42:07 -0400
Received: from mail-qt1-f180.google.com ([209.85.160.180]:39549 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbfJAVmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:42:05 -0400
Received: by mail-qt1-f180.google.com with SMTP id n7so23637267qtb.6;
        Tue, 01 Oct 2019 14:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6ZCudQkJo34iD4d2cux5rc3LwCd+AdYRLKzvHuPbh88=;
        b=PMp/14GdI76R8wdVS8L+RqMs+q6+zKyNbffs41+D9hS/+2H1naDud5jaRCkD/FLeJj
         jDepTviTr7F7Pc0xyUjf0NQJQL81wtZ7YMtXcL8dofMaP2hk43XPj6xiVShLmANYHz7D
         XR+SBKNLqwG8iaPAn7Hc/AQ9J8C9rxIXlireHfPhuCZdOSBmjLXIm/ObUuJLCrvlOAzA
         8/zf4remYzeogpGAzA25yCfOt6Qmktsym4rLgM/2iN7dTOxLMfXCHcdLgzSQllxZ0Lxt
         HwrexLW4boy+ap9ppqYIAJjQiE+MD00gJ1lvSFynmTGMIdaErnIoMDC2bNcb8x3Egtfu
         U8CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6ZCudQkJo34iD4d2cux5rc3LwCd+AdYRLKzvHuPbh88=;
        b=UKc2GtZ1ZxxiNpEMtYbOP0CTly4vnnhcNHF6qilnJPpX2/4J1Hn1TZwShJULheZ+hc
         Kf9khnSCn/RUIUAU1EVMq/Kpy9kJ1wnNiKI/UER0EDfMHAfvGg7Ryk/ipm9J1Y4rsocf
         ULsQolcBpyQygeABJ9U0gBqKV6O/iGKHUIhFE6HcsC+gNbHQSYtDpsUg7DKq4VPqIqax
         v1Mb7k3XRPlqGmtKcp/EoNH15GrMhc9TkZXDJGxlFCFub/6BOfK65KDehZX5HMjgxBxp
         Rv2Lki0iR91UvQXgDI+bHvIFP3w7qwNCltyxNjUrdIbFKXlaV8fSe0QOohwE4oF9JvOy
         ZTwA==
X-Gm-Message-State: APjAAAWO3wXXAu/F6rEdgATaxfLybghBpAGOaPBg/pnJ26iOGvh7ODCe
        A+NxywQNfxq0FRJ+tNxQsKsbQkgWqO8=
X-Google-Smtp-Source: APXvYqzmS6d54RBI9VhzsXGZFkQtGZpOJbYcwCjgko10gVDEgd5ZotpRe7i8wponao2Hf4Mm38i76g==
X-Received: by 2002:ac8:2c8f:: with SMTP id 15mr538201qtw.3.1569966123665;
        Tue, 01 Oct 2019 14:42:03 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id v13sm8559352qtp.61.2019.10.01.14.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 14:42:03 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH V12 4/4] tools/testing/selftests/bpf: Add self-tests for new helper.
Date:   Tue,  1 Oct 2019 18:41:41 -0300
Message-Id: <20191001214141.6294-5-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001214141.6294-1-cneirabustos@gmail.com>
References: <20191001214141.6294-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Self tests added for new helper

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/testing/selftests/bpf/bpf_helpers.h     |  3 +
 .../bpf/prog_tests/get_ns_current_pid_tgid.c  | 85 +++++++++++++++++++
 .../bpf/progs/get_ns_current_pid_tgid_kern.c  | 47 ++++++++++
 3 files changed, 135 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 54a50699bbfd..19c03ba066b1 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -233,6 +233,9 @@ static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
 static long long (*bpf_tcp_gen_syncookie)(struct bpf_sock *sk, void *ip,
 					  int ip_len, void *tcp, int tcp_len) =
 	(void *) BPF_FUNC_tcp_gen_syncookie;
+static unsigned long long (*bpf_get_ns_current_pid_tgid)(__u64 dev, __u64 inum) =
+	(void *) BPF_FUNC_get_ns_current_pid_tgid;
+
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
diff --git a/tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
new file mode 100644
index 000000000000..4d8ec524d373
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
+#include <test_progs.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <sys/syscall.h>
+
+void test_get_ns_current_pid_tgid(void)
+{
+	const char *probe_name = "syscalls/sys_enter_nanosleep";
+	const char *file = "get_ns_current_pid_tgid_kern.o";
+	int ns_data_map_fd, duration = 0;
+	struct perf_event_attr attr = {};
+	int err, efd, prog_fd, pmu_fd;
+	__u64 ino, dev, id, nspid;
+	struct bpf_object *obj;
+	struct stat st;
+	__u32 key = 0;
+	char buf[256];
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_TRACEPOINT, &obj, &prog_fd);
+	if (CHECK(err, "prog_load", "err %d errno %d\n", err, errno))
+		return;
+
+	ns_data_map_fd = bpf_find_map(__func__, obj, "ns_data_map");
+	if (CHECK_FAIL(ns_data_map_fd < 0))
+		goto close_prog;
+
+	pid_t tid = syscall(SYS_gettid);
+	pid_t pid = getpid();
+
+	id = (__u64) tid << 32 | pid;
+	bpf_map_update_elem(ns_data_map_fd, &key, &id, 0);
+
+	if (stat("/proc/self/ns/pid", &st))
+		goto close_prog;
+
+	dev = st.st_dev;
+	ino = st.st_ino;
+	key = 1;
+	bpf_map_update_elem(ns_data_map_fd, &key, &dev, 0);
+	key = 2;
+	bpf_map_update_elem(ns_data_map_fd, &key, &ino, 0);
+
+	snprintf(buf, sizeof(buf),
+		 "/sys/kernel/debug/tracing/events/%s/id", probe_name);
+	efd = open(buf, O_RDONLY, 0);
+	read(efd, buf, sizeof(buf));
+	close(efd);
+	attr.config = strtol(buf, NULL, 0);
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.sample_type = PERF_SAMPLE_RAW;
+	attr.sample_period = 1;
+	attr.wakeup_events = 1;
+
+	pmu_fd = syscall(__NR_perf_event_open, &attr, getpid(), -1, -1, 0);
+	if (CHECK_FAIL(pmu_fd < 0))
+		goto cleanup;
+
+	err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
+	if (CHECK_FAIL(err))
+		goto cleanup;
+
+	err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
+	if (CHECK_FAIL(err))
+		goto cleanup;
+
+	/* trigger some syscalls */
+	sleep(1);
+	key = 3;
+	err = bpf_map_lookup_elem(ns_data_map_fd, &key, &nspid);
+	if (CHECK_FAIL(err))
+		goto cleanup;
+
+	if (CHECK(id != nspid, "Compare user pid/tgid %llu vs. bpf pid/tgid %llu",
+		  "Userspace pid/tgid %llu EBPF pid/tgid %llu\n", id, nspid))
+		goto cleanup;
+
+cleanup:
+	close(pmu_fd);
+close_prog:
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c b/tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c
new file mode 100644
index 000000000000..00a325e85e8c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
+
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 4);
+	__type(key, __u32);
+	__type(value, __u64);
+} ns_data_map SEC(".maps");
+
+
+SEC("tracepoint/syscalls/sys_enter_nanosleep")
+int trace(void *ctx)
+{
+	__u64 *val, *inum, *dev, nspid, *expected_pid;
+	__u32 key = 1;
+
+	dev = bpf_map_lookup_elem(&ns_data_map, &key);
+	if (!dev)
+		return 0;
+	key = 2;
+	inum = bpf_map_lookup_elem(&ns_data_map, &key);
+
+	if (!inum)
+		return 0;
+
+	nspid =  bpf_get_ns_current_pid_tgid(*dev, *inum);
+	key = 0;
+	expected_pid = bpf_map_lookup_elem(&ns_data_map, &key);
+
+	if (!expected_pid || *expected_pid != nspid)
+		return 0;
+
+	key = 3;
+	val = bpf_map_lookup_elem(&ns_data_map, &key);
+
+	if (val)
+		*val = nspid;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
-- 
2.20.1

