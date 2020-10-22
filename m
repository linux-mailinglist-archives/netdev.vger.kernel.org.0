Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71508295A29
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895492AbgJVIXC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 04:23:02 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:56546 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895445AbgJVIW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:22:57 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-IawCvyt2OLSZqIgMHxnCnQ-1; Thu, 22 Oct 2020 04:22:53 -0400
X-MC-Unique: IawCvyt2OLSZqIgMHxnCnQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0070510E2186;
        Thu, 22 Oct 2020 08:22:52 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D845060BFA;
        Thu, 22 Oct 2020 08:22:48 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: [RFC bpf-next 16/16] selftests/bpf: Add attach batch test (NOT TO BE MERGED)
Date:   Thu, 22 Oct 2020 10:21:38 +0200
Message-Id: <20201022082138.2322434-17-jolsa@kernel.org>
In-Reply-To: <20201022082138.2322434-1-jolsa@kernel.org>
References: <20201022082138.2322434-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding test that attaches to 50 known functions,
that are also added to kernel.

This test is meant only for fast check on attach times,
and can be probably in a different mergeable way, but
at the moment it fits the need.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 net/bpf/test_run.c                            | 55 ++++++++++++++++
 .../selftests/bpf/prog_tests/attach_test.c    | 27 ++++++++
 .../testing/selftests/bpf/progs/attach_test.c | 62 +++++++++++++++++++
 3 files changed, 144 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/attach_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/attach_test.c

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index c1c30a9f76f3..8fc6d27fc07f 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -167,6 +167,61 @@ int noinline bpf_modify_return_test(int a, int *b)
 	*b += 1;
 	return a + *b;
 }
+
+#define ATTACH_TEST(__n) \
+	int noinline __PASTE(bpf_attach_test, __n)(void) { return 0; }
+
+ATTACH_TEST(0)
+ATTACH_TEST(1)
+ATTACH_TEST(2)
+ATTACH_TEST(3)
+ATTACH_TEST(4)
+ATTACH_TEST(5)
+ATTACH_TEST(6)
+ATTACH_TEST(7)
+ATTACH_TEST(8)
+ATTACH_TEST(9)
+ATTACH_TEST(10)
+ATTACH_TEST(11)
+ATTACH_TEST(12)
+ATTACH_TEST(13)
+ATTACH_TEST(14)
+ATTACH_TEST(15)
+ATTACH_TEST(16)
+ATTACH_TEST(17)
+ATTACH_TEST(18)
+ATTACH_TEST(19)
+ATTACH_TEST(20)
+ATTACH_TEST(21)
+ATTACH_TEST(22)
+ATTACH_TEST(23)
+ATTACH_TEST(24)
+ATTACH_TEST(25)
+ATTACH_TEST(26)
+ATTACH_TEST(27)
+ATTACH_TEST(28)
+ATTACH_TEST(29)
+ATTACH_TEST(30)
+ATTACH_TEST(31)
+ATTACH_TEST(32)
+ATTACH_TEST(33)
+ATTACH_TEST(34)
+ATTACH_TEST(35)
+ATTACH_TEST(36)
+ATTACH_TEST(37)
+ATTACH_TEST(38)
+ATTACH_TEST(39)
+ATTACH_TEST(40)
+ATTACH_TEST(41)
+ATTACH_TEST(42)
+ATTACH_TEST(43)
+ATTACH_TEST(44)
+ATTACH_TEST(45)
+ATTACH_TEST(46)
+ATTACH_TEST(47)
+ATTACH_TEST(48)
+ATTACH_TEST(49)
+
 __diag_pop();
 
 ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
diff --git a/tools/testing/selftests/bpf/prog_tests/attach_test.c b/tools/testing/selftests/bpf/prog_tests/attach_test.c
new file mode 100644
index 000000000000..c5c6534c49c9
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/attach_test.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "attach_test.skel.h"
+
+void test_attach_test(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts);
+	struct attach_test *attach_skel = NULL;
+	__u32 duration = 0;
+	int err;
+
+	opts.trampoline_attach_batch = true;
+	attach_skel = attach_test__open_opts(&opts);
+	if (CHECK(!attach_skel, "attach_test__open_opts", "open skeleton failed\n"))
+		goto cleanup;
+
+	err = attach_test__load(attach_skel);
+	if (CHECK(err, "attach_skel_load", "attach skeleton failed\n"))
+		goto cleanup;
+
+	err = attach_test__attach(attach_skel);
+	if (CHECK(err, "attach", "attach failed: %d\n", err))
+		goto cleanup;
+
+cleanup:
+	attach_test__destroy(attach_skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/attach_test.c b/tools/testing/selftests/bpf/progs/attach_test.c
new file mode 100644
index 000000000000..51b18f83c109
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/attach_test.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+#define ATTACH_PROG(__n)			\
+SEC("fentry/bpf_attach_test" #__n)		\
+int BPF_PROG(prog ## __n) { return 0; }
+
+ATTACH_PROG(0)
+ATTACH_PROG(1)
+ATTACH_PROG(2)
+ATTACH_PROG(3)
+ATTACH_PROG(4)
+ATTACH_PROG(5)
+ATTACH_PROG(6)
+ATTACH_PROG(7)
+ATTACH_PROG(8)
+ATTACH_PROG(9)
+ATTACH_PROG(10)
+ATTACH_PROG(11)
+ATTACH_PROG(12)
+ATTACH_PROG(13)
+ATTACH_PROG(14)
+ATTACH_PROG(15)
+ATTACH_PROG(16)
+ATTACH_PROG(17)
+ATTACH_PROG(18)
+ATTACH_PROG(19)
+ATTACH_PROG(20)
+ATTACH_PROG(21)
+ATTACH_PROG(22)
+ATTACH_PROG(23)
+ATTACH_PROG(24)
+ATTACH_PROG(25)
+ATTACH_PROG(26)
+ATTACH_PROG(27)
+ATTACH_PROG(28)
+ATTACH_PROG(29)
+ATTACH_PROG(30)
+ATTACH_PROG(31)
+ATTACH_PROG(32)
+ATTACH_PROG(33)
+ATTACH_PROG(34)
+ATTACH_PROG(35)
+ATTACH_PROG(36)
+ATTACH_PROG(37)
+ATTACH_PROG(38)
+ATTACH_PROG(39)
+ATTACH_PROG(40)
+ATTACH_PROG(41)
+ATTACH_PROG(42)
+ATTACH_PROG(43)
+ATTACH_PROG(44)
+ATTACH_PROG(45)
+ATTACH_PROG(46)
+ATTACH_PROG(47)
+ATTACH_PROG(48)
+ATTACH_PROG(49)
-- 
2.26.2

