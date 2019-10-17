Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7DDDB09E
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 17:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409406AbfJQPAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 11:00:53 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:43370 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731768AbfJQPAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 11:00:52 -0400
Received: by mail-qt1-f170.google.com with SMTP id t20so3981655qtr.10;
        Thu, 17 Oct 2019 08:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q37tUh9xqxmgGI/s8GNG5ls9HK4DNX5e/Lei/51fEg4=;
        b=Lbnd3PGqhgjLTaRiIgymehYNrW2iTh545LykuEay+Huctvv4JNbsj1j9uM/yb4B2pA
         /X2cF31piI0Qq2z0ehWr2f8hA26ZQY1CF4yF7TpuFpnjQivMiUBsxRJJitUiISld7tWg
         igZ9YrnvJ19P/uPz1551pYKEdP5hWQyFwz+scR5PCdHBTK7SMol4xIxkZ6HSwR+wColt
         d6Xxpl0RuZKZ/UdwiDdLXwM0daN5vZe5TlYENm1hjQ1FUv1vsMbJl6BmMx43OM/gwNmQ
         KZDaybG9Id8xGQj8HeqMMlNnivhz2qetZWAJdTpqI6thvzEIaOkISjTnrj85gWNxQDd7
         ejrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q37tUh9xqxmgGI/s8GNG5ls9HK4DNX5e/Lei/51fEg4=;
        b=NFGf6PxSrLs0hvlcUB04+cJNt86OxzJlaZ0ehWjQU+MoTDG3/IyttjPgqe2nAlR+MP
         I/FVVFVH4djAnPQpX9/l9pfbOUqr8sP+2rZ8n9f3JAG7KZXOYrQxfdUbKewbsW0dQUV7
         zXyWudUkFQUn0g/PSOO1S7/xhbaxJ+K0JtrhOOTx7UF9JkCYZhzFXQpF+m6fvOsiIYLg
         PdLwNokq5n7geHj60Lnefe1zPWWKs+zVXnA3yjHlrsGIDlDAJ70psH8aOSx3zpDbo1RU
         hVsDqlskkK5Hcj7vIpkJqZa88PsJ9ctsf8nZiO7nwcR855iyE8QbvynigyAwzbIHIUZt
         RWag==
X-Gm-Message-State: APjAAAXjBZaij1SUKJDJ7UU/ff24Vr/Bp/3gwmgC6JBASr4HfW9cupaO
        HLKNq0nStcyAzODIfuMWU89Z/hZ8xwk=
X-Google-Smtp-Source: APXvYqy/48aSjpBMzOfcVu621D9xK2jv8wz0k6ifVskJIrAVrkqHd5wNCX2Sc52SG6B6jFzwLwyzEg==
X-Received: by 2002:ac8:714e:: with SMTP id h14mr4256830qtp.147.1571324450492;
        Thu, 17 Oct 2019 08:00:50 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id z20sm1550859qtu.91.2019.10.17.08.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 08:00:49 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v14 4/5]  tools/testing/selftests/bpf: Add self-tests for new  helper.
Date:   Thu, 17 Oct 2019 12:00:31 -0300
Message-Id: <20191017150032.14359-5-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017150032.14359-1-cneirabustos@gmail.com>
References: <20191017150032.14359-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Self tests added for new helper

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 .../bpf/prog_tests/get_ns_current_pid_tgid.c  | 96 +++++++++++++++++++
 .../bpf/progs/get_ns_current_pid_tgid_kern.c  | 53 ++++++++++
 2 files changed, 149 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c

diff --git a/tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
new file mode 100644
index 000000000000..48d9785f89d0
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
+#include <test_progs.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <sys/syscall.h>
+
+struct bss {
+	__u64 dev;
+	__u64 ino;
+	__u64 pidtgid;
+	__u64 userpidtgid;
+} data;
+
+void test_get_ns_current_pid_tgid(void)
+{
+	const char *probe_name = "raw_tracepoint/sys_enter";
+	const char *file = "get_ns_current_pid_tgid_kern.o";
+	struct bpf_object_load_attr load_attr = {};
+	struct bpf_link *link = NULL;
+	struct bpf_program *prog;
+	struct bpf_map *bss_map;
+	struct bpf_object *obj;
+	int err, duration = 0;
+	const __u32 key = 0;
+	struct stat st;
+	__u64 id;
+
+	obj = bpf_object__open(file);
+	if (CHECK(IS_ERR_OR_NULL(obj), "obj_open",
+		  "failed to open '%s': %ld\n",
+		  file, PTR_ERR(obj)))
+		goto cleanup;
+
+	prog = bpf_object__find_program_by_title(obj, probe_name);
+	if (CHECK(!prog, "find_probe",
+		  "prog '%s' not found\n", probe_name))
+		goto cleanup;
+
+	bpf_program__set_type(prog, BPF_PROG_TYPE_RAW_TRACEPOINT);
+
+	load_attr.obj = obj;
+	load_attr.log_level = 0;
+	load_attr.target_btf_path = NULL;
+	err = bpf_object__load_xattr(&load_attr);
+	if (CHECK(err, "obj_load",
+		  "failed to load prog '%s': %d\n",
+		  probe_name, err))
+		goto cleanup;
+
+	link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
+	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
+		  PTR_ERR(link)))
+		goto cleanup;
+
+	bss_map = bpf_object__find_map_by_name(obj, "ns_data_map");
+	if (CHECK(!bss_map, "find_bss_map", "failed\n"))
+		goto cleanup;
+
+	memset(&data, 0, sizeof(data));
+	pid_t tid = syscall(SYS_gettid);
+	pid_t pid = getpid();
+
+	id = (__u64) tid << 32 | pid;
+	data.userpidtgid = id;
+
+	if (CHECK(stat("/proc/self/ns/pid", &st), "stat","failed\n"))
+		goto cleanup;
+
+	data.dev = st.st_dev;
+	data.ino = st.st_ino;
+
+	err = bpf_map_update_elem(bpf_map__fd(bss_map), &key, &data, 0);
+	if (CHECK(err, "setting_bss", "failed to set bss data: %d\n", err))
+		goto cleanup;
+
+	/* trigger some syscalls */
+	usleep(1);
+
+	err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &data);
+	if (CHECK(err, "set_bss", "failed to get bss data: %d\n", err))
+		goto cleanup;
+
+	if (CHECK(id != data.pidtgid, "Compare user pid/tgid vs. bpf pid/tgid",
+		  "User pid/tgid %llu EBPF pid/tgid %llu\n", id, data.pidtgid))
+		goto cleanup;
+cleanup:
+
+	if (!IS_ERR_OR_NULL(link)) {
+		bpf_link__destroy(link);
+		link = NULL;
+	}
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c b/tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c
new file mode 100644
index 000000000000..1fd847b63105
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include "bpf_helpers.h"
+#include "bpf_core_read.h"
+
+struct res {
+	__u64 dev;
+	__u64 ino;
+	__u64 pidtgid;
+	__u64 userpidtgid;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct res);
+} ns_data_map SEC(".maps");
+
+static struct res data;
+
+SEC("raw_tracepoint/sys_enter")
+int trace(void *ctx)
+{
+	__u64  nspidtgid, expected_pid;
+	struct bpf_pidns_info nsdata;
+	const __u32 key = 0;
+	struct res *pres;
+
+	pres = bpf_map_lookup_elem(&ns_data_map, &key);
+	if (!pres)
+		return 0;
+
+	if (bpf_get_ns_current_pid_tgid(pres->dev, pres->ino, &nsdata,
+		   sizeof(struct bpf_pidns_info)))
+		return 0;
+
+	nspidtgid = (__u64)nsdata.tgid << 32 | nsdata.pid;
+	expected_pid = pres->userpidtgid;
+
+	if (expected_pid != nspidtgid)
+		return 0;
+
+	data.pidtgid = nspidtgid;
+	bpf_map_update_elem(&ns_data_map, &key, &data, 0);
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.20.1

