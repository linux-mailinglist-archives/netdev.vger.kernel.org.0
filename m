Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F46F8D85E
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfHNQrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:47:49 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:53265 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbfHNQrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:47:48 -0400
Received: by mail-ua1-f73.google.com with SMTP id z23so10081600uag.20
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 09:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5ek1EVAZRm+qabxMqMu9irrjkFWPa5puXpEJvWK1CPc=;
        b=JjGJU8FXjx72USEfNiHz8y2IRJdjutfZjUekmWtYRD+00SKpLSw/97erYQMrhGpo1O
         Xoe/UXMW0uyXam6u7OelkgXEA0iXlRZMar8e93b9Cbcvrrx9mJa7lHRABbKG1ZJZEsIc
         J7BNTRZjVHhGnT802eD+V5iVNNASdyrvk2nxJlQei3RnETKMLuaKMOBS/hZSePs4kSyF
         f1690+wyrmBHi9jOqWS9SsZqDX7t843+mCzH79NdUYLvUMPeq2HOBgpteCZcAxJ2td4+
         /dA0Hdhh2q6JUaWeH0eduH9MywQoOzG3mfeHvAR1BpBo1RoeOqrl9q8atd4V6Bll2P9h
         frpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5ek1EVAZRm+qabxMqMu9irrjkFWPa5puXpEJvWK1CPc=;
        b=HLdRkk5xXrVHI3g5s3ZiXC0aGZMziogdmv6OmjfATasIgq4cQZJnThn4yC1ZLs3Axa
         vodkhr/8IhBD47AuZBLGDaPcwWNwHzKcfMa17kOTO4TfNkoUK6MPRnqqLKbHBBDBuIoU
         BhtWMFd9/yk+CKsQBRcpWAZFVCTSvog6MPWPjgYlUy0cBP092RbKhFKkO2/l0haPjA/o
         fynf/4DyfXogv2QrA5fBhgD37VOzHZUTZJbRe0uzpsgAsc6AzF0EDcqBZ68I+lCshSRt
         7EVpu9zrKe3jaCitX4CXZwG3+/yAIWi9M4tYZaf1xMKwa7Hl5OA4l/WoEoPxtKEtjRnA
         L3wQ==
X-Gm-Message-State: APjAAAWFd4YimcMg+8lPWH8F5dMVHjoJ+dS6b8y4MrUESzxzMJWuINSU
        0irtVEGAkXMsb5QwkVW6Rjhk9RnSbaeLgcMPK7s7BNZml/+cNWQbEgGrDhdYUbF9BgpjS1Zp+bN
        2+vAhhsa6NTdtlQ0lvobhwVz6Zcq65H5+8ITTxVm0f3xggwMSXvLxmg==
X-Google-Smtp-Source: APXvYqwj69o47JQ7jW03Tjv21//xstWKWAQPpr5QkxWl/JkW/mGq+pNtMoXZDMbaEX2a/vykrqcAiiE=
X-Received: by 2002:a1f:4588:: with SMTP id s130mr72229vka.58.1565801267231;
 Wed, 14 Aug 2019 09:47:47 -0700 (PDT)
Date:   Wed, 14 Aug 2019 09:47:39 -0700
In-Reply-To: <20190814164742.208909-1-sdf@google.com>
Message-Id: <20190814164742.208909-2-sdf@google.com>
Mime-Version: 1.0
References: <20190814164742.208909-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH bpf-next 1/4] selftests/bpf: test_progs: change formatting of
 the condenced output
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes it visually simpler to follow the output.
Also, highlight with red color failures when outputting to tty.

Before:
  #1 attach_probe:FAIL
  #2 bpf_obj_id:OK
  #3/1 bpf_verif_scale:loop3.o:OK
  #3/2 bpf_verif_scale:test_verif_scale1.o:OK
  #3/3 bpf_verif_scale:test_verif_scale2.o:OK
  #3/4 bpf_verif_scale:test_verif_scale3.o:OK
  #3/5 bpf_verif_scale:pyperf50.o:OK
  #3/6 bpf_verif_scale:pyperf100.o:OK
  #3/7 bpf_verif_scale:pyperf180.o:OK
  #3/8 bpf_verif_scale:pyperf600.o:OK
  #3/9 bpf_verif_scale:pyperf600_nounroll.o:OK
  #3/10 bpf_verif_scale:loop1.o:OK
  #3/11 bpf_verif_scale:loop2.o:OK
  #3/12 bpf_verif_scale:loop4.o:OK
  #3/13 bpf_verif_scale:loop5.o:OK
  #3/14 bpf_verif_scale:strobemeta.o:OK
  #3/15 bpf_verif_scale:strobemeta_nounroll1.o:OK
  #3/16 bpf_verif_scale:strobemeta_nounroll2.o:OK
  #3/17 bpf_verif_scale:test_sysctl_loop1.o:OK
  #3/18 bpf_verif_scale:test_sysctl_loop2.o:OK
  #3/19 bpf_verif_scale:test_xdp_loop.o:OK
  #3/20 bpf_verif_scale:test_seg6_loop.o:OK
  #3 bpf_verif_scale:OK
  #4 flow_dissector:OK

After:
  #  1     FAIL attach_probe
  #  2       OK bpf_obj_id
  #  3/1     OK bpf_verif_scale:loop3.o
  #  3/2     OK bpf_verif_scale:test_verif_scale1.o
  #  3/3     OK bpf_verif_scale:test_verif_scale2.o
  #  3/4     OK bpf_verif_scale:test_verif_scale3.o
  #  3/5     OK bpf_verif_scale:pyperf50.o
  #  3/6     OK bpf_verif_scale:pyperf100.o
  #  3/7     OK bpf_verif_scale:pyperf180.o
  #  3/8     OK bpf_verif_scale:pyperf600.o
  #  3/9     OK bpf_verif_scale:pyperf600_nounroll.o
  #  3/10    OK bpf_verif_scale:loop1.o
  #  3/11    OK bpf_verif_scale:loop2.o
  #  3/12    OK bpf_verif_scale:loop4.o
  #  3/13    OK bpf_verif_scale:loop5.o
  #  3/14    OK bpf_verif_scale:strobemeta.o
  #  3/15    OK bpf_verif_scale:strobemeta_nounroll1.o
  #  3/16    OK bpf_verif_scale:strobemeta_nounroll2.o
  #  3/17    OK bpf_verif_scale:test_sysctl_loop1.o
  #  3/18    OK bpf_verif_scale:test_sysctl_loop2.o
  #  3/19    OK bpf_verif_scale:test_xdp_loop.o
  #  3/20    OK bpf_verif_scale:test_seg6_loop.o
  #  3       OK bpf_verif_scale
  #  4       OK flow_dissector

Cc: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/test_progs.c | 29 +++++++++++++++++++-----
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 12895d03d58b..1a7a2a0c0a11 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -56,6 +56,21 @@ static void dump_test_log(const struct prog_test_def *test, bool failed)
 	fseeko(stdout, 0, SEEK_SET); /* rewind */
 }
 
+static const char *test_status_string(bool success)
+{
+#define COLOR_RED	"\033[31m"
+#define COLOR_RESET	"\033[m"
+	if (success)
+		return "OK";
+
+	if (isatty(fileno(env.stdout)))
+		return COLOR_RED "FAIL" COLOR_RESET;
+	else
+		return "FAIL";
+#undef COLOR_RED
+#undef COLOR_RESET
+}
+
 void test__end_subtest()
 {
 	struct prog_test_def *test = env.test;
@@ -68,9 +83,10 @@ void test__end_subtest()
 
 	dump_test_log(test, sub_error_cnt);
 
-	fprintf(env.stdout, "#%d/%d %s:%s\n",
-	       test->test_num, test->subtest_num,
-	       test->subtest_name, sub_error_cnt ? "FAIL" : "OK");
+	fprintf(env.stdout, "#%3d/%-3d %4s %s:%s\n",
+		test->test_num, test->subtest_num,
+		test_status_string(test->fail_cnt == 0),
+		test->test_name, test->subtest_name);
 }
 
 bool test__start_subtest(const char *name)
@@ -513,9 +529,10 @@ int main(int argc, char **argv)
 
 		dump_test_log(test, test->error_cnt);
 
-		fprintf(env.stdout, "#%d %s:%s\n",
-			test->test_num, test->test_name,
-			test->error_cnt ? "FAIL" : "OK");
+		fprintf(env.stdout, "#%3d     %4s %s\n",
+			test->test_num,
+			test_status_string(test->fail_cnt == 0),
+			test->test_name);
 	}
 	stdio_restore();
 	printf("Summary: %d/%d PASSED, %d FAILED\n",
-- 
2.23.0.rc1.153.gdeed80330f-goog

