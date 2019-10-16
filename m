Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C228D886B
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 08:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388509AbfJPGB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 02:01:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58234 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388369AbfJPGB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 02:01:26 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9G5vee2029088
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 23:01:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=xF005ppeIz9eQEmT9f5AlYOPMgJ70Fb7umyT6QPV2zc=;
 b=GLet9lsnI6KoFJpIaZYqj50IOdxCsgP+GiW1Ols966W+j6+c5I7ALdbX2/O1DU3lR2+E
 fWY8UtQNl0qRwRUE8T9eK9Z9XI06nRJ2d4ts4gnsnRZGex/HMAOXrvnSn8/HcnNA32PA
 6XmM1OO0uC61LJXCz0GhFb5l3xVgS+DLvIU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2vn6m8dve3-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 23:01:25 -0700
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Oct 2019 23:01:17 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 2A15586195B; Tue, 15 Oct 2019 23:01:16 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v4 bpf-next 7/7] selftest/bpf: remove test_libbpf.sh and test_libbpf_open
Date:   Tue, 15 Oct 2019 23:00:51 -0700
Message-ID: <20191016060051.2024182-8-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016060051.2024182-1-andriin@fb.com>
References: <20191016060051.2024182-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_02:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015 suspectscore=9
 lowpriorityscore=0 spamscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160056
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_progs is much more sophisticated superset of tests compared to
test_libbpf.sh and test_libbpf_open. Remove test_libbpf.sh and
test_libbpf_open.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 -
 tools/testing/selftests/bpf/Makefile          |   3 +-
 tools/testing/selftests/bpf/test_libbpf.sh    |  43 ------
 .../testing/selftests/bpf/test_libbpf_open.c  | 144 ------------------
 4 files changed, 1 insertion(+), 190 deletions(-)
 delete mode 100755 tools/testing/selftests/bpf/test_libbpf.sh
 delete mode 100644 tools/testing/selftests/bpf/test_libbpf_open.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index c51f356f84b5..6f46170e09c1 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -11,7 +11,6 @@ test_dev_cgroup
 test_tcpbpf_user
 test_verifier_log
 feature
-test_libbpf_open
 test_sock
 test_sock_addr
 test_sock_fields
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 16056e5d399d..4ff5f4aada08 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -52,7 +52,6 @@ TEST_FILES =
 
 # Order correspond to 'make run_tests' order
 TEST_PROGS := test_kmod.sh \
-	test_libbpf.sh \
 	test_xdp_redirect.sh \
 	test_xdp_meta.sh \
 	test_xdp_veth.sh \
@@ -79,7 +78,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 	test_xdp_vlan.sh
 
 # Compile but not part of 'make run_tests'
-TEST_GEN_PROGS_EXTENDED = test_libbpf_open test_sock_addr test_skb_cgroup_id_user \
+TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
 	test_lirc_mode2_user
 
diff --git a/tools/testing/selftests/bpf/test_libbpf.sh b/tools/testing/selftests/bpf/test_libbpf.sh
deleted file mode 100755
index 2989b2e2d856..000000000000
--- a/tools/testing/selftests/bpf/test_libbpf.sh
+++ /dev/null
@@ -1,43 +0,0 @@
-#!/bin/sh
-# SPDX-License-Identifier: GPL-2.0
-
-export TESTNAME=test_libbpf
-
-# Determine selftest success via shell exit code
-exit_handler()
-{
-	if [ $? -eq 0 ]; then
-		echo "selftests: $TESTNAME [PASS]";
-	else
-		echo "$TESTNAME: failed at file $LAST_LOADED" 1>&2
-		echo "selftests: $TESTNAME [FAILED]";
-	fi
-}
-
-libbpf_open_file()
-{
-	LAST_LOADED=$1
-	if [ -n "$VERBOSE" ]; then
-	    ./test_libbpf_open $1
-	else
-	    ./test_libbpf_open --quiet $1
-	fi
-}
-
-# Exit script immediately (well catched by trap handler) if any
-# program/thing exits with a non-zero status.
-set -e
-
-# (Use 'trap -l' to list meaning of numbers)
-trap exit_handler 0 2 3 6 9
-
-libbpf_open_file test_l4lb.o
-
-# Load a program with BPF-to-BPF calls
-libbpf_open_file test_l4lb_noinline.o
-
-# Load a program compiled without the "-target bpf" flag
-libbpf_open_file test_xdp.o
-
-# Success
-exit 0
diff --git a/tools/testing/selftests/bpf/test_libbpf_open.c b/tools/testing/selftests/bpf/test_libbpf_open.c
deleted file mode 100644
index 9e9db202d218..000000000000
--- a/tools/testing/selftests/bpf/test_libbpf_open.c
+++ /dev/null
@@ -1,144 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Copyright (c) 2018 Jesper Dangaard Brouer, Red Hat Inc.
- */
-static const char *__doc__ =
-	"Libbpf test program for loading BPF ELF object files";
-
-#include <stdlib.h>
-#include <stdio.h>
-#include <string.h>
-#include <stdarg.h>
-#include <bpf/libbpf.h>
-#include <getopt.h>
-
-#include "bpf_rlimit.h"
-
-static const struct option long_options[] = {
-	{"help",	no_argument,		NULL, 'h' },
-	{"debug",	no_argument,		NULL, 'D' },
-	{"quiet",	no_argument,		NULL, 'q' },
-	{0, 0, NULL,  0 }
-};
-
-static void usage(char *argv[])
-{
-	int i;
-
-	printf("\nDOCUMENTATION:\n%s\n\n", __doc__);
-	printf(" Usage: %s (options-see-below) BPF_FILE\n", argv[0]);
-	printf(" Listing options:\n");
-	for (i = 0; long_options[i].name != 0; i++) {
-		printf(" --%-12s", long_options[i].name);
-		printf(" short-option: -%c",
-		       long_options[i].val);
-		printf("\n");
-	}
-	printf("\n");
-}
-
-static bool debug = 0;
-static int libbpf_debug_print(enum libbpf_print_level level,
-			      const char *fmt, va_list args)
-{
-	if (level == LIBBPF_DEBUG && !debug)
-		return 0;
-
-	fprintf(stderr, "[%d] ", level);
-	return vfprintf(stderr, fmt, args);
-}
-
-#define EXIT_FAIL_LIBBPF EXIT_FAILURE
-#define EXIT_FAIL_OPTION 2
-
-int test_walk_progs(struct bpf_object *obj, bool verbose)
-{
-	struct bpf_program *prog;
-	int cnt = 0;
-
-	bpf_object__for_each_program(prog, obj) {
-		cnt++;
-		if (verbose)
-			printf("Prog (count:%d) section_name: %s\n", cnt,
-			       bpf_program__title(prog, false));
-	}
-	return 0;
-}
-
-int test_walk_maps(struct bpf_object *obj, bool verbose)
-{
-	struct bpf_map *map;
-	int cnt = 0;
-
-	bpf_object__for_each_map(map, obj) {
-		cnt++;
-		if (verbose)
-			printf("Map (count:%d) name: %s\n", cnt,
-			       bpf_map__name(map));
-	}
-	return 0;
-}
-
-int test_open_file(char *filename, bool verbose)
-{
-	struct bpf_object *bpfobj = NULL;
-	long err;
-
-	if (verbose)
-		printf("Open BPF ELF-file with libbpf: %s\n", filename);
-
-	/* Load BPF ELF object file and check for errors */
-	bpfobj = bpf_object__open(filename);
-	err = libbpf_get_error(bpfobj);
-	if (err) {
-		char err_buf[128];
-		libbpf_strerror(err, err_buf, sizeof(err_buf));
-		if (verbose)
-			printf("Unable to load eBPF objects in file '%s': %s\n",
-			       filename, err_buf);
-		return EXIT_FAIL_LIBBPF;
-	}
-	test_walk_progs(bpfobj, verbose);
-	test_walk_maps(bpfobj, verbose);
-
-	if (verbose)
-		printf("Close BPF ELF-file with libbpf: %s\n",
-		       bpf_object__name(bpfobj));
-	bpf_object__close(bpfobj);
-
-	return 0;
-}
-
-int main(int argc, char **argv)
-{
-	char filename[1024] = { 0 };
-	bool verbose = 1;
-	int longindex = 0;
-	int opt;
-
-	libbpf_set_print(libbpf_debug_print);
-
-	/* Parse commands line args */
-	while ((opt = getopt_long(argc, argv, "hDq",
-				  long_options, &longindex)) != -1) {
-		switch (opt) {
-		case 'D':
-			debug = 1;
-			break;
-		case 'q': /* Use in scripting mode */
-			verbose = 0;
-			break;
-		case 'h':
-		default:
-			usage(argv);
-			return EXIT_FAIL_OPTION;
-		}
-	}
-	if (optind >= argc) {
-		usage(argv);
-		printf("ERROR: Expected BPF_FILE argument after options\n");
-		return EXIT_FAIL_OPTION;
-	}
-	snprintf(filename, sizeof(filename), "%s", argv[optind]);
-
-	return test_open_file(filename, verbose);
-}
-- 
2.17.1

