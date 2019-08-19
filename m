Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 990A094DBC
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 21:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbfHSTSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 15:18:08 -0400
Received: from mail-ua1-f74.google.com ([209.85.222.74]:57342 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728417AbfHSTSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 15:18:06 -0400
Received: by mail-ua1-f74.google.com with SMTP id u25so466360uap.23
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 12:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dLxQ1wYSS3RWXesnQ+cpyN7aVwgKkyNbwf3Df6Ls4XE=;
        b=P+6ae/IRhmtFDTjDrd8/CdmmRGJePgXo0FRhoShFaQSkufDiXAmyTnzznJlCTMfisb
         SBseoJD3hNAjtzzqeqBtCDcv/M+OB3VcpjotcXE8zOHn7HqYUm/7pFBxNbKyr7o+hdB/
         VsWsxRveM+faoYaCD0tRz8Ux6PDqx0sbNC40ywS07uSzV8KtJ5Rr7CyK/GUkVEkQI27X
         7ql+F3I7qfwb6prfX8zm37vTcg8n34YpOfQkFUQbdIkbi/NlPaijZphLzOYzWCmaGlEg
         RRX1YMTaVGz7bJ1541FTFRyLUSDI5/B8jNWhmJjDX7EDuGRMm9nC/rkQF92qIrnvZVu/
         DG0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dLxQ1wYSS3RWXesnQ+cpyN7aVwgKkyNbwf3Df6Ls4XE=;
        b=coUsRqkXq7fU16IbRGdbd9yHAT3R912YpXlvefMdZQVxwD7dSyTyiWjZ9dtSnAZseA
         bNTilomRCCe1EiuVJFCaujgWcCpotAQ7FSBi6Mo89e5HQaLD/bqYn89eKEWt0DaNzfh/
         X/pMlfarpY/ZLK+Jc3220zQbgSXeHy8D7TQYeMxVXaT3bAFAbaAP7AaPbDxQQ5hIsp5I
         qbmfl/x+MUFRLlH20IqW0Q190ED8qo84/FDHL8Si3xAfAUqmhCafRk44DEDbOCtQFdfV
         acxpV5NyFbqUXzOo2JSScd1IlLdQX/LeuD4S7Sjhs7T6dRmtE5CKAHj6+GKgrE60SDR8
         yXjw==
X-Gm-Message-State: APjAAAWGblmYidyrqyD5kcB8wbaBgMLlTfgOLffDmiJpA92h52wsNfFJ
        9U2DSUn/bTfRjhWhofg8AcQ0Ph6CX8YJvl2yMRRsE6kx/aHDkE1eCzrSK6RiShtyKi12jNg/A8O
        6zBXuCBwupilE/ifI/vhws2RKzBIOrqGFjjWANf/DqSVDaNOrBZaCFQ==
X-Google-Smtp-Source: APXvYqzftsnGwitMmF89Y23dNMecTdI0QeymHwQw43YvyfRWQ4kz8jpls8uPQrRyNrA2rogEAj11JtU=
X-Received: by 2002:ab0:14a9:: with SMTP id d38mr4242685uae.94.1566242285320;
 Mon, 19 Aug 2019 12:18:05 -0700 (PDT)
Date:   Mon, 19 Aug 2019 12:17:52 -0700
In-Reply-To: <20190819191752.241637-1-sdf@google.com>
Message-Id: <20190819191752.241637-5-sdf@google.com>
Mime-Version: 1.0
References: <20190819191752.241637-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH bpf-next v2 4/4] selftests/bpf: test_progs: remove unused ret
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

send_signal test returns static codes from the subtests which
nobody looks at, let's rely on the CHECK macros instead.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/send_signal.c    | 42 +++++++++----------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
index 40c2c5efdd3e..b607112c64e7 100644
--- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
+++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
@@ -8,7 +8,7 @@ static void sigusr1_handler(int signum)
 	sigusr1_received++;
 }
 
-static int test_send_signal_common(struct perf_event_attr *attr,
+static void test_send_signal_common(struct perf_event_attr *attr,
 				    int prog_type,
 				    const char *test_name)
 {
@@ -23,13 +23,13 @@ static int test_send_signal_common(struct perf_event_attr *attr,
 
 	if (CHECK(pipe(pipe_c2p), test_name,
 		  "pipe pipe_c2p error: %s\n", strerror(errno)))
-		goto no_fork_done;
+		return;
 
 	if (CHECK(pipe(pipe_p2c), test_name,
 		  "pipe pipe_p2c error: %s\n", strerror(errno))) {
 		close(pipe_c2p[0]);
 		close(pipe_c2p[1]);
-		goto no_fork_done;
+		return;
 	}
 
 	pid = fork();
@@ -38,7 +38,7 @@ static int test_send_signal_common(struct perf_event_attr *attr,
 		close(pipe_c2p[1]);
 		close(pipe_p2c[0]);
 		close(pipe_p2c[1]);
-		goto no_fork_done;
+		return;
 	}
 
 	if (pid == 0) {
@@ -125,7 +125,7 @@ static int test_send_signal_common(struct perf_event_attr *attr,
 		goto disable_pmu;
 	}
 
-	err = CHECK(buf[0] != '2', test_name, "incorrect result\n");
+	CHECK(buf[0] != '2', test_name, "incorrect result\n");
 
 	/* notify child safe to exit */
 	write(pipe_p2c[1], buf, 1);
@@ -138,11 +138,9 @@ static int test_send_signal_common(struct perf_event_attr *attr,
 	close(pipe_c2p[0]);
 	close(pipe_p2c[1]);
 	wait(NULL);
-no_fork_done:
-	return err;
 }
 
-static int test_send_signal_tracepoint(void)
+static void test_send_signal_tracepoint(void)
 {
 	const char *id_path = "/sys/kernel/debug/tracing/events/syscalls/sys_enter_nanosleep/id";
 	struct perf_event_attr attr = {
@@ -159,21 +157,21 @@ static int test_send_signal_tracepoint(void)
 	if (CHECK(efd < 0, "tracepoint",
 		  "open syscalls/sys_enter_nanosleep/id failure: %s\n",
 		  strerror(errno)))
-		return -1;
+		return;
 
 	bytes = read(efd, buf, sizeof(buf));
 	close(efd);
 	if (CHECK(bytes <= 0 || bytes >= sizeof(buf), "tracepoint",
 		  "read syscalls/sys_enter_nanosleep/id failure: %s\n",
 		  strerror(errno)))
-		return -1;
+		return;
 
 	attr.config = strtol(buf, NULL, 0);
 
-	return test_send_signal_common(&attr, BPF_PROG_TYPE_TRACEPOINT, "tracepoint");
+	test_send_signal_common(&attr, BPF_PROG_TYPE_TRACEPOINT, "tracepoint");
 }
 
-static int test_send_signal_perf(void)
+static void test_send_signal_perf(void)
 {
 	struct perf_event_attr attr = {
 		.sample_period = 1,
@@ -181,11 +179,11 @@ static int test_send_signal_perf(void)
 		.config = PERF_COUNT_SW_CPU_CLOCK,
 	};
 
-	return test_send_signal_common(&attr, BPF_PROG_TYPE_PERF_EVENT,
-				       "perf_sw_event");
+	test_send_signal_common(&attr, BPF_PROG_TYPE_PERF_EVENT,
+				"perf_sw_event");
 }
 
-static int test_send_signal_nmi(void)
+static void test_send_signal_nmi(void)
 {
 	struct perf_event_attr attr = {
 		.sample_freq = 50,
@@ -205,25 +203,23 @@ static int test_send_signal_nmi(void)
 			printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n",
 			       __func__);
 			test__skip();
-			return 0;
+			return;
 		}
 		/* Let the test fail with a more informative message */
 	} else {
 		close(pmu_fd);
 	}
 
-	return test_send_signal_common(&attr, BPF_PROG_TYPE_PERF_EVENT,
-				       "perf_hw_event");
+	test_send_signal_common(&attr, BPF_PROG_TYPE_PERF_EVENT,
+				"perf_hw_event");
 }
 
 void test_send_signal(void)
 {
-	int ret = 0;
-
 	if (test__start_subtest("send_signal_tracepoint"))
-		ret |= test_send_signal_tracepoint();
+		test_send_signal_tracepoint();
 	if (test__start_subtest("send_signal_perf"))
-		ret |= test_send_signal_perf();
+		test_send_signal_perf();
 	if (test__start_subtest("send_signal_nmi"))
-		ret |= test_send_signal_nmi();
+		test_send_signal_nmi();
 }
-- 
2.23.0.rc1.153.gdeed80330f-goog

