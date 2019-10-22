Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93043E0C6C
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 21:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732886AbfJVTSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 15:18:14 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:35785 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732810AbfJVTSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 15:18:13 -0400
Received: by mail-qt1-f170.google.com with SMTP id m15so28564190qtq.2;
        Tue, 22 Oct 2019 12:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MulQUD6rGJeM5sHo2oz8MH20hWywb8PTM9mTAlClRgQ=;
        b=IszFyBHam6KaaN6+58bXUAW4AjgncJy7nPwyNBMRYkzLkIzt3n3otgFTTVXTvNBZTW
         55PL/5irZGMPoxzWViKAmNZu/gqKwo2qa7zIeEx80E+Wj/ZzCSPxdHVmCYAJJ7zScrC9
         T475vqMMAF0Bqk6nc/ZeiJYfOqBYufHkZnFwaFinPiAWkhe+aGNjuO51QGuGse7HKZig
         FCrDyKPL0pkA6FJOsDAQYYTTtTvQD1oAaupb0liSVeXpqT1r4bgYab/kNXcT2O8PbWvr
         gVyd5Ziz+1GKW4L/BE3iueZgFwNJ1eEIfUyU86ekyQy44mwiscaB9HZ+qV24yCobQmMj
         fH7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MulQUD6rGJeM5sHo2oz8MH20hWywb8PTM9mTAlClRgQ=;
        b=Z9/mMmkaGa+5O+ArEgRgGwD+vWpScUJbmI5qrFpVVao1iBnyvdXbivQGHKgnRZmPp8
         B+yVgN9oRpJgX+bUM3rHR8iy0clsyPxyDpIe1DtQ2Pb/PDBhk9/T/blM1oCjyQe5XhtQ
         zr/1TGaXHCuvFLn8SSyqgs3JE1KdGCKd53tzINWxN+MTcyLLOy5UrTuKYa27rQGV8JGR
         OP1FB/P3dqk+4sLrbj1O3wgU3itMjSGOKzZZPoBCNJx9w2Izt1o/kWIMzQrzoo/MaXiH
         Pu1MLNGi6xA/Hzf0eKian//Y4CTGgfFQsFZulmlkObG3UnAIkLKOK+/bk11lgOhBvgaZ
         m8SA==
X-Gm-Message-State: APjAAAWMhRxILAifSWagaeNMVwmi7vCOvd7LWm2uNLwTtyDyjLX+55sR
        t70lKQRrUtoZw6Iu3XyatCFCvTlop9Kf0Q51
X-Google-Smtp-Source: APXvYqxm1dFy04+qvI75wHgG6GhNLXCv5pn88h/fNR8DqRcQgB3slFRnBW9AF7IwmAMbkXIv7202ng==
X-Received: by 2002:a0c:b918:: with SMTP id u24mr4954192qvf.212.1571771891662;
        Tue, 22 Oct 2019 12:18:11 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id r36sm8015969qta.27.2019.10.22.12.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 12:18:11 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v15 4/5]  tools/testing/selftests/bpf: Add self-tests for new  helper.
Date:   Tue, 22 Oct 2019 16:17:50 -0300
Message-Id: <20191022191751.3780-5-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191022191751.3780-1-cneirabustos@gmail.com>
References: <20191022191751.3780-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Self tests added for new helper

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 .../bpf/prog_tests/ns_current_pid_tgid.c      | 87 +++++++++++++++++++
 .../bpf/progs/test_ns_current_pid_tgid.c      | 37 ++++++++
 2 files changed, 124 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c

diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
new file mode 100644
index 000000000000..257f18999bb6
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
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
+		  PTR_ERR(link)))
+		goto cleanup;
+
+	/* trigger some syscalls */
+	usleep(1);
+
+	err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
+	if (CHECK(err, "set_bss", "failed to get bss : %d\n", err))
+		goto cleanup;
+
+	if (CHECK(id != bss.pid_tgid, "Compare user pid/tgid vs. bpf pid/tgid",
+		  "User pid/tgid %llu EBPF pid/tgid %llu\n", id, bss.pid_tgid))
+		goto cleanup;
+cleanup:
+
+	if (!IS_ERR_OR_NULL(link)) {
+		bpf_link__destroy(link);
+		link = NULL;
+	}
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
new file mode 100644
index 000000000000..cdb77eb1a4fb
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include "bpf_helpers.h"
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
-- 
2.20.1

