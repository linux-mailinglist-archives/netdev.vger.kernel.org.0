Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3C822D2AC
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgGYAEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:04:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46108 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727942AbgGYAEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:04:50 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ONkkuT031620
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=UPt568j60N+HV7l0Q5xR/5SqExMETuX6RnydBT572ss=;
 b=MKnljs4yvKjqXwzdnY0YHSXmGIbKGWjzPy8CptR9IJcP8jdon3+b/kP6cIzANVxMtC9D
 kciTGEE8rRC+IYLIzJxip8dsppQx7k5ZqsG97RPMDqWT+qqDWAVdSXzpDd5zrfNUCqrm
 QrvX66NQVtoihRBXvEOrrfFfVcrr3uBAiOc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32etmwm9f4-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:49 -0700
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 17:04:40 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 535AB1B35AAC; Fri, 24 Jul 2020 17:04:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next 32/35] bpf: selftests: delete bpf_rlimit.h
Date:   Fri, 24 Jul 2020 17:04:07 -0700
Message-ID: <20200725000410.3566700-33-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200725000410.3566700-1-guro@fb.com>
References: <20200725000410.3566700-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_10:2020-07-24,2020-07-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=38 bulkscore=0 spamscore=0 clxscore=1015 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007240164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As rlimit-based memory accounting is not used by bpf anymore,
there are no more reasons to play with memlock rlimit.

Delete bpf_rlimit.h which contained a code to bump the limit.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 samples/bpf/hbm.c                             |  1 -
 tools/testing/selftests/bpf/bpf_rlimit.h      | 28 -------------------
 .../selftests/bpf/flow_dissector_load.c       |  1 -
 .../selftests/bpf/get_cgroup_id_user.c        |  1 -
 .../bpf/prog_tests/select_reuseport.c         |  1 -
 .../selftests/bpf/prog_tests/sk_lookup.c      |  1 -
 tools/testing/selftests/bpf/test_btf.c        |  1 -
 .../selftests/bpf/test_cgroup_storage.c       |  1 -
 tools/testing/selftests/bpf/test_dev_cgroup.c |  1 -
 tools/testing/selftests/bpf/test_lpm_map.c    |  1 -
 tools/testing/selftests/bpf/test_lru_map.c    |  1 -
 tools/testing/selftests/bpf/test_maps.c       |  1 -
 tools/testing/selftests/bpf/test_netcnt.c     |  1 -
 tools/testing/selftests/bpf/test_progs.c      |  1 -
 .../selftests/bpf/test_skb_cgroup_id_user.c   |  1 -
 tools/testing/selftests/bpf/test_sock.c       |  1 -
 tools/testing/selftests/bpf/test_sock_addr.c  |  1 -
 .../testing/selftests/bpf/test_sock_fields.c  |  1 -
 .../selftests/bpf/test_socket_cookie.c        |  1 -
 tools/testing/selftests/bpf/test_sockmap.c    |  1 -
 tools/testing/selftests/bpf/test_sysctl.c     |  1 -
 tools/testing/selftests/bpf/test_tag.c        |  1 -
 .../bpf/test_tcp_check_syncookie_user.c       |  1 -
 .../testing/selftests/bpf/test_tcpbpf_user.c  |  1 -
 .../selftests/bpf/test_tcpnotify_user.c       |  1 -
 tools/testing/selftests/bpf/test_verifier.c   |  1 -
 .../testing/selftests/bpf/test_verifier_log.c |  2 --
 27 files changed, 55 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/bpf_rlimit.h

diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
index 7d7153777678..e4b38ceb20a7 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -46,7 +46,6 @@
 #include <getopt.h>
=20
 #include "bpf_load.h"
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
 #include "hbm.h"
 #include "bpf_util.h"
diff --git a/tools/testing/selftests/bpf/bpf_rlimit.h b/tools/testing/sel=
ftests/bpf/bpf_rlimit.h
deleted file mode 100644
index 9dac9b30f8ef..000000000000
--- a/tools/testing/selftests/bpf/bpf_rlimit.h
+++ /dev/null
@@ -1,28 +0,0 @@
-#include <sys/resource.h>
-#include <stdio.h>
-
-static  __attribute__((constructor)) void bpf_rlimit_ctor(void)
-{
-	struct rlimit rlim_old, rlim_new =3D {
-		.rlim_cur	=3D RLIM_INFINITY,
-		.rlim_max	=3D RLIM_INFINITY,
-	};
-
-	getrlimit(RLIMIT_MEMLOCK, &rlim_old);
-	/* For the sake of running the test cases, we temporarily
-	 * set rlimit to infinity in order for kernel to focus on
-	 * errors from actual test cases and not getting noise
-	 * from hitting memlock limits. The limit is on per-process
-	 * basis and not a global one, hence destructor not really
-	 * needed here.
-	 */
-	if (setrlimit(RLIMIT_MEMLOCK, &rlim_new) < 0) {
-		perror("Unable to lift memlock rlimit");
-		/* Trying out lower limit, but expect potential test
-		 * case failures from this!
-		 */
-		rlim_new.rlim_cur =3D rlim_old.rlim_cur + (1UL << 20);
-		rlim_new.rlim_max =3D rlim_old.rlim_max + (1UL << 20);
-		setrlimit(RLIMIT_MEMLOCK, &rlim_new);
-	}
-}
diff --git a/tools/testing/selftests/bpf/flow_dissector_load.c b/tools/te=
sting/selftests/bpf/flow_dissector_load.c
index 3fd83b9dc1bf..75818141f318 100644
--- a/tools/testing/selftests/bpf/flow_dissector_load.c
+++ b/tools/testing/selftests/bpf/flow_dissector_load.c
@@ -11,7 +11,6 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
=20
-#include "bpf_rlimit.h"
 #include "flow_dissector_load.h"
=20
 const char *cfg_pin_path =3D "/sys/fs/bpf/flow_dissector";
diff --git a/tools/testing/selftests/bpf/get_cgroup_id_user.c b/tools/tes=
ting/selftests/bpf/get_cgroup_id_user.c
index e8da7b39158d..597bc70286f2 100644
--- a/tools/testing/selftests/bpf/get_cgroup_id_user.c
+++ b/tools/testing/selftests/bpf/get_cgroup_id_user.c
@@ -19,7 +19,6 @@
 #include <bpf/libbpf.h>
=20
 #include "cgroup_helpers.h"
-#include "bpf_rlimit.h"
=20
 #define CHECK(condition, tag, format...) ({		\
 	int __ret =3D !!(condition);			\
diff --git a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c b/=
tools/testing/selftests/bpf/prog_tests/select_reuseport.c
index 821b4146b7b6..520c8de8ee03 100644
--- a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
+++ b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
@@ -18,7 +18,6 @@
 #include <netinet/in.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
=20
 #include "test_progs.h"
diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/t=
esting/selftests/bpf/prog_tests/sk_lookup.c
index 9bbd2b2b7630..9d3faf6cf92d 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -30,7 +30,6 @@
 #include <bpf/bpf.h>
=20
 #include "test_progs.h"
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
 #include "cgroup_helpers.h"
 #include "network_helpers.h"
diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selft=
ests/bpf/test_btf.c
index 305fae8f80a9..e4b7bd9e3abf 100644
--- a/tools/testing/selftests/bpf/test_btf.c
+++ b/tools/testing/selftests/bpf/test_btf.c
@@ -22,7 +22,6 @@
 #include <bpf/libbpf.h>
 #include <bpf/btf.h>
=20
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
 #include "test_btf.h"
=20
diff --git a/tools/testing/selftests/bpf/test_cgroup_storage.c b/tools/te=
sting/selftests/bpf/test_cgroup_storage.c
index 655729004391..0bde741ad84c 100644
--- a/tools/testing/selftests/bpf/test_cgroup_storage.c
+++ b/tools/testing/selftests/bpf/test_cgroup_storage.c
@@ -6,7 +6,6 @@
 #include <stdlib.h>
 #include <sys/sysinfo.h>
=20
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
=20
 char bpf_log_buf[BPF_LOG_BUF_SIZE];
diff --git a/tools/testing/selftests/bpf/test_dev_cgroup.c b/tools/testin=
g/selftests/bpf/test_dev_cgroup.c
index d850fb9076b5..4d6df9d99d50 100644
--- a/tools/testing/selftests/bpf/test_dev_cgroup.c
+++ b/tools/testing/selftests/bpf/test_dev_cgroup.c
@@ -14,7 +14,6 @@
 #include <bpf/libbpf.h>
=20
 #include "cgroup_helpers.h"
-#include "bpf_rlimit.h"
=20
 #define DEV_CGROUP_PROG "./dev_cgroup.o"
=20
diff --git a/tools/testing/selftests/bpf/test_lpm_map.c b/tools/testing/s=
elftests/bpf/test_lpm_map.c
index 006be3963977..ec595b5135e2 100644
--- a/tools/testing/selftests/bpf/test_lpm_map.c
+++ b/tools/testing/selftests/bpf/test_lpm_map.c
@@ -26,7 +26,6 @@
 #include <bpf/bpf.h>
=20
 #include "bpf_util.h"
-#include "bpf_rlimit.h"
=20
 struct tlpm_node {
 	struct tlpm_node *next;
diff --git a/tools/testing/selftests/bpf/test_lru_map.c b/tools/testing/s=
elftests/bpf/test_lru_map.c
index 6a5349f9eb14..76748ff51de8 100644
--- a/tools/testing/selftests/bpf/test_lru_map.c
+++ b/tools/testing/selftests/bpf/test_lru_map.c
@@ -18,7 +18,6 @@
 #include <bpf/libbpf.h>
=20
 #include "bpf_util.h"
-#include "bpf_rlimit.h"
 #include "../../../include/linux/filter.h"
=20
 #define LOCAL_FREE_TARGET	(128)
diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/self=
tests/bpf/test_maps.c
index 754cf611723e..350fee74a6b3 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -23,7 +23,6 @@
 #include <bpf/libbpf.h>
=20
 #include "bpf_util.h"
-#include "bpf_rlimit.h"
 #include "test_maps.h"
=20
 #ifndef ENOTSUPP
diff --git a/tools/testing/selftests/bpf/test_netcnt.c b/tools/testing/se=
lftests/bpf/test_netcnt.c
index c1da5404454a..7a3e07b4627d 100644
--- a/tools/testing/selftests/bpf/test_netcnt.c
+++ b/tools/testing/selftests/bpf/test_netcnt.c
@@ -12,7 +12,6 @@
 #include <bpf/libbpf.h>
=20
 #include "cgroup_helpers.h"
-#include "bpf_rlimit.h"
 #include "netcnt_common.h"
=20
 #define BPF_PROG "./netcnt_prog.o"
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/sel=
ftests/bpf/test_progs.c
index b1e4dadacd9b..406716d305dc 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -4,7 +4,6 @@
 #define _GNU_SOURCE
 #include "test_progs.h"
 #include "cgroup_helpers.h"
-#include "bpf_rlimit.h"
 #include <argp.h>
 #include <pthread.h>
 #include <sched.h>
diff --git a/tools/testing/selftests/bpf/test_skb_cgroup_id_user.c b/tool=
s/testing/selftests/bpf/test_skb_cgroup_id_user.c
index 356351c0ac28..8155e2c1d6ce 100644
--- a/tools/testing/selftests/bpf/test_skb_cgroup_id_user.c
+++ b/tools/testing/selftests/bpf/test_skb_cgroup_id_user.c
@@ -15,7 +15,6 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
=20
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
=20
 #define CGROUP_PATH		"/skb_cgroup_test"
diff --git a/tools/testing/selftests/bpf/test_sock.c b/tools/testing/self=
tests/bpf/test_sock.c
index 52bf14955797..cd1ebce8b1a7 100644
--- a/tools/testing/selftests/bpf/test_sock.c
+++ b/tools/testing/selftests/bpf/test_sock.c
@@ -14,7 +14,6 @@
=20
 #include "cgroup_helpers.h"
 #include <bpf/bpf_endian.h>
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
=20
 #define CG_PATH		"/foo"
diff --git a/tools/testing/selftests/bpf/test_sock_addr.c b/tools/testing=
/selftests/bpf/test_sock_addr.c
index 0358814c67dc..7b8cd4fafb3d 100644
--- a/tools/testing/selftests/bpf/test_sock_addr.c
+++ b/tools/testing/selftests/bpf/test_sock_addr.c
@@ -19,7 +19,6 @@
 #include <bpf/libbpf.h>
=20
 #include "cgroup_helpers.h"
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
=20
 #ifndef ENOTSUPP
diff --git a/tools/testing/selftests/bpf/test_sock_fields.c b/tools/testi=
ng/selftests/bpf/test_sock_fields.c
index f0fc103261a4..8ffdda96aeb6 100644
--- a/tools/testing/selftests/bpf/test_sock_fields.c
+++ b/tools/testing/selftests/bpf/test_sock_fields.c
@@ -14,7 +14,6 @@
 #include <bpf/libbpf.h>
=20
 #include "cgroup_helpers.h"
-#include "bpf_rlimit.h"
=20
 enum bpf_addr_array_idx {
 	ADDR_SRV_IDX,
diff --git a/tools/testing/selftests/bpf/test_socket_cookie.c b/tools/tes=
ting/selftests/bpf/test_socket_cookie.c
index 15653b0e26eb..998efb7158b7 100644
--- a/tools/testing/selftests/bpf/test_socket_cookie.c
+++ b/tools/testing/selftests/bpf/test_socket_cookie.c
@@ -12,7 +12,6 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
=20
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
=20
 #define CG_PATH			"/foo"
diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/s=
elftests/bpf/test_sockmap.c
index 78789b27e573..7094b93f44ec 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -37,7 +37,6 @@
 #include <bpf/libbpf.h>
=20
 #include "bpf_util.h"
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
=20
 int running;
diff --git a/tools/testing/selftests/bpf/test_sysctl.c b/tools/testing/se=
lftests/bpf/test_sysctl.c
index d196e2a4a6e0..b5fd51efb4c7 100644
--- a/tools/testing/selftests/bpf/test_sysctl.c
+++ b/tools/testing/selftests/bpf/test_sysctl.c
@@ -14,7 +14,6 @@
 #include <bpf/libbpf.h>
=20
 #include <bpf/bpf_endian.h>
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
 #include "cgroup_helpers.h"
=20
diff --git a/tools/testing/selftests/bpf/test_tag.c b/tools/testing/selft=
ests/bpf/test_tag.c
index 6272c784ca2a..bcbf14dd00e1 100644
--- a/tools/testing/selftests/bpf/test_tag.c
+++ b/tools/testing/selftests/bpf/test_tag.c
@@ -20,7 +20,6 @@
 #include <bpf/bpf.h>
=20
 #include "../../../include/linux/filter.h"
-#include "bpf_rlimit.h"
=20
 static struct bpf_insn prog[BPF_MAXINSNS];
=20
diff --git a/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c =
b/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
index b9e991d43155..894eb0710d6f 100644
--- a/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
+++ b/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
@@ -15,7 +15,6 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
=20
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
=20
 static int start_server(const struct sockaddr *addr, socklen_t len)
diff --git a/tools/testing/selftests/bpf/test_tcpbpf_user.c b/tools/testi=
ng/selftests/bpf/test_tcpbpf_user.c
index 3ae127620463..100393afeb12 100644
--- a/tools/testing/selftests/bpf/test_tcpbpf_user.c
+++ b/tools/testing/selftests/bpf/test_tcpbpf_user.c
@@ -10,7 +10,6 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
=20
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
 #include "cgroup_helpers.h"
=20
diff --git a/tools/testing/selftests/bpf/test_tcpnotify_user.c b/tools/te=
sting/selftests/bpf/test_tcpnotify_user.c
index f9765ddf0761..9d14fedd47e4 100644
--- a/tools/testing/selftests/bpf/test_tcpnotify_user.c
+++ b/tools/testing/selftests/bpf/test_tcpnotify_user.c
@@ -19,7 +19,6 @@
 #include <linux/perf_event.h>
 #include <linux/err.h>
=20
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
 #include "cgroup_helpers.h"
=20
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/=
selftests/bpf/test_verifier.c
index 78a6bae56ea6..7c5e005c237f 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -41,7 +41,6 @@
 #  define CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS 1
 # endif
 #endif
-#include "bpf_rlimit.h"
 #include "bpf_rand.h"
 #include "bpf_util.h"
 #include "test_btf.h"
diff --git a/tools/testing/selftests/bpf/test_verifier_log.c b/tools/test=
ing/selftests/bpf/test_verifier_log.c
index 8d6918c3b4a2..4bca0a7344cc 100644
--- a/tools/testing/selftests/bpf/test_verifier_log.c
+++ b/tools/testing/selftests/bpf/test_verifier_log.c
@@ -11,8 +11,6 @@
=20
 #include <bpf/bpf.h>
=20
-#include "bpf_rlimit.h"
-
 #define LOG_SIZE (1 << 20)
=20
 #define err(str...)	printf("ERROR: " str)
--=20
2.26.2

