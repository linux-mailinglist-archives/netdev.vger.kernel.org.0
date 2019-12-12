Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAE511D294
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 17:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbfLLQmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 11:42:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49768 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729995AbfLLQmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 11:42:16 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBCGXLoT006844
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 08:42:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=dtQfHiyDf70O1lWplQTXJFHaogiluj/48FGdb75qOOM=;
 b=qJaLRiRIui6IodrywaWz4CjNlAJTE9HDDX+jk0ih1RhM4UM+hsIiDjeKRzcH1KBrEdtr
 E+88QYarhrZAyZy0hvxMqGxoc4ZtUIS43yhBf7u44edK3WXmb2K2NvDd1rymm+kIAbrk
 QeB6kncyD2LwYqmvbJ/5bfLFa+DzCtOAEqc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wu4ksd7nj-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 08:42:15 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 12 Dec 2019 08:42:13 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 75B7C2EC1AD2; Thu, 12 Dec 2019 08:42:07 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 15/15] bpftool: add `gen skeleton` BASH completions
Date:   Thu, 12 Dec 2019 08:41:28 -0800
Message-ID: <20191212164129.494329-16-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212164129.494329-1-andriin@fb.com>
References: <20191212164129.494329-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_04:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=8 adultscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=942 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912120129
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BASH completions for gen sub-command.

Cc: Quentin Monnet <quentin.monnet@netronome.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/bash-completion/bpftool         | 11 +++++++++++
 tools/bpf/bpftool/main.c                          |  2 +-
 tools/testing/selftests/bpf/prog_tests/skeleton.c |  6 ++++--
 tools/testing/selftests/bpf/progs/test_skeleton.c |  3 ++-
 4 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 70493a6da206..986519cc58d1 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -716,6 +716,17 @@ _bpftool()
                     ;;
             esac
             ;;
+        gen)
+            case $command in
+                skeleton)
+                    _filedir
+		    ;;
+                *)
+                    [[ $prev == $object ]] && \
+                        COMPREPLY=( $( compgen -W 'skeleton help' -- "$cur" ) )
+                    ;;
+            esac
+            ;;
         cgroup)
             case $command in
                 show|list|tree)
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 758b294e8a7d..1fe91c558508 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -58,7 +58,7 @@ static int do_help(int argc, char **argv)
 		"       %s batch file FILE\n"
 		"       %s version\n"
 		"\n"
-		"       OBJECT := { prog | map | cgroup | perf | net | feature | btf }\n"
+		"       OBJECT := { prog | map | cgroup | perf | net | feature | btf | gen }\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
 		bin_name, bin_name, bin_name);
diff --git a/tools/testing/selftests/bpf/prog_tests/skeleton.c b/tools/testing/selftests/bpf/prog_tests/skeleton.c
index d65a0203e1df..94e0300f437a 100644
--- a/tools/testing/selftests/bpf/prog_tests/skeleton.c
+++ b/tools/testing/selftests/bpf/prog_tests/skeleton.c
@@ -39,8 +39,10 @@ void test_skeleton(void)
 	CHECK(bss->out2 != 2, "res2", "got %lld != exp %d\n", bss->out2, 2);
 	CHECK(bss->out3 != 3, "res3", "got %d != exp %d\n", (int)bss->out3, 3);
 	CHECK(bss->out4 != 4, "res4", "got %lld != exp %d\n", bss->out4, 4);
-	CHECK(bss->out5.a != 5, "res5", "got %d != exp %d\n", bss->out5.a, 5);
-	CHECK(bss->out5.b != 6, "res6", "got %lld != exp %d\n", bss->out5.b, 6);
+	CHECK(bss->handler_out5.a != 5, "res5", "got %d != exp %d\n",
+	      bss->handler_out5.a, 5);
+	CHECK(bss->handler_out5.b != 6, "res6", "got %lld != exp %d\n",
+	      bss->handler_out5.b, 6);
 
 cleanup:
 	test_skeleton__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/test_skeleton.c b/tools/testing/selftests/bpf/progs/test_skeleton.c
index 303a841c4d1c..db4fd88f3ecb 100644
--- a/tools/testing/selftests/bpf/progs/test_skeleton.c
+++ b/tools/testing/selftests/bpf/progs/test_skeleton.c
@@ -16,7 +16,6 @@ long long in4 __attribute__((aligned(64))) = 0;
 struct s in5 = {};
 
 long long out2 = 0;
-struct s out5 = {};
 char out3 = 0;
 long long out4 = 0;
 int out1 = 0;
@@ -25,6 +24,8 @@ int out1 = 0;
 SEC("raw_tp/sys_enter")
 int handler(const void *ctx)
 {
+	static volatile struct s out5;
+
 	out1 = in1;
 	out2 = in2;
 	out3 = in3;
-- 
2.17.1

