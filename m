Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41887D1271
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 17:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731686AbfJIP0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 11:26:55 -0400
Received: from mail-qt1-f179.google.com ([209.85.160.179]:33356 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbfJIP0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 11:26:54 -0400
Received: by mail-qt1-f179.google.com with SMTP id r5so4036705qtd.0;
        Wed, 09 Oct 2019 08:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vV8z+kyEhV7bZFxf5/wDgbHy4ySE7RP8RD7gYio5VZ4=;
        b=s/Mu1NbQKtr8r0/EFI72ij/HltRJezBNZN09sKYTK/WgE1rs1R6F6fnyIPpe9t/dVb
         HTOnDlEoMXWr9/Lzrd3YPA4+PAvM11PtZEq78J8C4lKKoczqXueQxLFz9zUvStA2t9nx
         MNah1xWy59iVOk2D1J2rRzDqC1+tV208AM8oSI2dc780AhqVbNDBtN/DJFhQ8QzN2Zmu
         erGGX/KAIz/E7Z06C+xi6xDC5NR+TCIrULcV8DUj1ZrpagNgCB6l4C2FajPqv1yOLspk
         OWRK4sacKrun4yqPgZw13gyq+TX2Dh/TYKHyKiPEv+SCBa8RlnpkIYJHGzo6T3zln6oK
         xjXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vV8z+kyEhV7bZFxf5/wDgbHy4ySE7RP8RD7gYio5VZ4=;
        b=Nyo/XMbDYVGOiCR8LG7qxVwCc7DHSGUMDw+RJCQt9oLYwmV9yv8cxoz/sh9UborMMP
         BoDAh5g5SgoxiTlzqZXyQlX1v6X/onSPeRMFK/h3JpaeVTpYdr9BoWp1To4N+05YQ1hC
         EXm6aj3B7b/O1gHIV6KyRj7RBRDQ/+s+opNclGB4bTWanAYFJ8bk8KXEXv4cpsZUtJSG
         8ahs4ykQWEtxtxf4ALuTAZWkYA1AaPcDnQM1/I1LmY8f9WDW6adCD9A63OpFXj4C4Sjn
         2Y2z+8EhhcBjWv3Ypfj7rab2gpgZNQvJUEW98MTtJG/2dcCbGiwi8LuitPtEXqgiumm8
         PBpQ==
X-Gm-Message-State: APjAAAUbrIG06cEO3HVTJhPfPknRxcnIvd6KtFwoP6p80N3SnyhThSQj
        V0cUJhlgpaFYGCZAjM4D6RtR8AgQzPo=
X-Google-Smtp-Source: APXvYqz0ziUxgBi0wOQqVP/tHfoeVRmK+MV3fDrBUH7LuNdiy282Apbvsl3e8w5UT6y8P5QKxeopjg==
X-Received: by 2002:ac8:664b:: with SMTP id j11mr4318355qtp.137.1570634811396;
        Wed, 09 Oct 2019 08:26:51 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id l189sm1049895qke.69.2019.10.09.08.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 08:26:50 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v13 4/4] tools/testing/selftests/bpf: Add self-tests for new helper.
Date:   Wed,  9 Oct 2019 12:26:32 -0300
Message-Id: <20191009152632.14218-5-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009152632.14218-1-cneirabustos@gmail.com>
References: <20191009152632.14218-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Self tests added for new helper

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/testing/selftests/bpf/bpf_helpers.h     |  4 +
 .../bpf/prog_tests/get_ns_current_pid_tgid.c  | 85 +++++++++++++++++++
 .../bpf/progs/get_ns_current_pid_tgid_kern.c  | 53 ++++++++++++
 3 files changed, 142 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 54a50699bbfd..16261b23e011 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -233,6 +233,10 @@ static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
 static long long (*bpf_tcp_gen_syncookie)(struct bpf_sock *sk, void *ip,
 					  int ip_len, void *tcp, int tcp_len) =
 	(void *) BPF_FUNC_tcp_gen_syncookie;
+static unsigned long long (*bpf_get_ns_current_pid_tgid)(struct bpf_pidns_info *nsinfo,
+		unsigned int buf_size) =
+	(void *) BPF_FUNC_get_ns_current_pid_tgid;
+
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
diff --git a/tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
new file mode 100644
index 000000000000..a7bff0ef6677
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
+	if (CHECK(id != nspid, "Compare user pid/tgid vs. bpf pid/tgid",
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
index 000000000000..3659aaa7c71f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c
@@ -0,0 +1,53 @@
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
+	__u64 *val, *inum, *dev, nspidtgid, *expected_pid;
+	struct bpf_pidns_info nsdata;
+	__u32 key = 1;
+
+	dev = bpf_map_lookup_elem(&ns_data_map, &key);
+	if (!dev)
+		return 0;
+	key = 2;
+	inum = bpf_map_lookup_elem(&ns_data_map, &key);
+	if (!inum)
+		return 0;
+
+	nsdata.dev = *dev;
+	nsdata.inum = *inum;
+
+	if (bpf_get_ns_current_pid_tgid(&nsdata, sizeof(struct bpf_pidns_info)))
+		return 0;
+
+	nspidtgid = (__u64)nsdata.tgid << 32 | nsdata.pid;
+	key = 0;
+	expected_pid = bpf_map_lookup_elem(&ns_data_map, &key);
+
+	if (!expected_pid || *expected_pid != nspidtgid)
+		return 0;
+
+	key = 3;
+	val = bpf_map_lookup_elem(&ns_data_map, &key);
+
+	if (val)
+		*val = nspidtgid;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
-- 
2.20.1

