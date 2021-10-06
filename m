Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1DE424A59
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 01:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbhJFXJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 19:09:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55846 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231597AbhJFXJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 19:09:27 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 196JvZWL024638
        for <netdev@vger.kernel.org>; Wed, 6 Oct 2021 16:07:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=zp1idubUTRum9FSHHvkx4YbZs9QHOAp0J8Zc0jBWTBw=;
 b=fYreh3YlUiUcWlf1CeuxX8fKuD8QSqZ/Pv9vfVlnIkyULn+kAojVL78YmAItN0qlbzyn
 OJvHoSiZCZq3oDDFmaooG1i5yOY+MF4X3B+4G1shrqGxB5J6XaAhljzbSmwKv+qBGxDT
 vmtxKkYATvqIf8vA2EDacMqzwFxnX3l8N8Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bhfhjaw0s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 16:07:34 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 6 Oct 2021 16:07:33 -0700
Received: by devbig612.frc2.facebook.com (Postfix, from userid 115148)
        id 8D2453457DB2; Wed,  6 Oct 2021 16:07:28 -0700 (PDT)
From:   Joanne Koong <joannekoong@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <kafai@fb.com>, <netdev@vger.kernel.org>, <Kernel-team@fb.com>,
        Joanne Koong <joannekoong@fb.com>
Subject: [PATCH bpf-next v2 2/3] bpf/selftests: Rename test_tcp_hdr_options to test_sockops_tcp_hdr_options
Date:   Wed, 6 Oct 2021 16:05:42 -0700
Message-ID: <20211006230543.3928580-3-joannekoong@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211006230543.3928580-1-joannekoong@fb.com>
References: <20211006230543.3928580-1-joannekoong@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: 4aYlrwFgjUZdo7PhXVxLdwJSQKi6XEvR
X-Proofpoint-GUID: 4aYlrwFgjUZdo7PhXVxLdwJSQKi6XEvR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-06_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=974 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110060142
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, tcp_hdr_options is only supported for sockops type programs.
This patchset adds xdp tcp_hdr_options support. To more easily
differentiate between these two tests, this patch does the following
renames (with  no functional changes):

test_tcp_hdr_options -> test_sockops_tcp_hdr_options
test_misc_tcp_hdr_options -> test_sockops_misc_tcp_hdr_options

The next patch will add xdp_test_tcp_hdr_options.

Signed-off-by: Joanne Koong <joannekoong@fb.com>
---
 ...hdr_options.c =3D> sockops_tcp_hdr_options.c} | 18 +++++++++---------
 ...s.c =3D> test_sockops_misc_tcp_hdr_options.c} |  0
 ...ptions.c =3D> test_sockops_tcp_hdr_options.c} |  0
 3 files changed, 9 insertions(+), 9 deletions(-)
 rename tools/testing/selftests/bpf/prog_tests/{tcp_hdr_options.c =3D> so=
ckops_tcp_hdr_options.c} (96%)
 rename tools/testing/selftests/bpf/progs/{test_misc_tcp_hdr_options.c =3D=
> test_sockops_misc_tcp_hdr_options.c} (100%)
 rename tools/testing/selftests/bpf/progs/{test_tcp_hdr_options.c =3D> te=
st_sockops_tcp_hdr_options.c} (100%)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c b/t=
ools/testing/selftests/bpf/prog_tests/sockops_tcp_hdr_options.c
similarity index 96%
rename from tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
rename to tools/testing/selftests/bpf/prog_tests/sockops_tcp_hdr_options.=
c
index 1fa772079967..f8fb12f4c1ed 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockops_tcp_hdr_options.c
@@ -12,8 +12,8 @@
 #include "cgroup_helpers.h"
 #include "network_helpers.h"
 #include "test_tcp_hdr_options.h"
-#include "test_tcp_hdr_options.skel.h"
-#include "test_misc_tcp_hdr_options.skel.h"
+#include "test_sockops_tcp_hdr_options.skel.h"
+#include "test_sockops_misc_tcp_hdr_options.skel.h"
=20
 #define LO_ADDR6 "::1"
 #define CG_NAME "/tcpbpf-hdr-opt-test"
@@ -25,8 +25,8 @@ static struct bpf_test_option exp_active_fin_in;
 static struct hdr_stg exp_passive_hdr_stg;
 static struct hdr_stg exp_active_hdr_stg =3D { .active =3D true, };
=20
-static struct test_misc_tcp_hdr_options *misc_skel;
-static struct test_tcp_hdr_options *skel;
+static struct test_sockops_misc_tcp_hdr_options *misc_skel;
+static struct test_sockops_tcp_hdr_options *skel;
 static int lport_linum_map_fd;
 static int hdr_stg_map_fd;
 static __u32 duration;
@@ -570,15 +570,15 @@ static struct test tests[] =3D {
 	DEF_TEST(misc),
 };
=20
-void test_tcp_hdr_options(void)
+void test_sockops_tcp_hdr_options(void)
 {
 	int i;
=20
-	skel =3D test_tcp_hdr_options__open_and_load();
+	skel =3D test_sockops_tcp_hdr_options__open_and_load();
 	if (CHECK(!skel, "open and load skel", "failed"))
 		return;
=20
-	misc_skel =3D test_misc_tcp_hdr_options__open_and_load();
+	misc_skel =3D test_sockops_misc_tcp_hdr_options__open_and_load();
 	if (CHECK(!misc_skel, "open and load misc test skel", "failed"))
 		goto skel_destroy;
=20
@@ -600,6 +600,6 @@ void test_tcp_hdr_options(void)
=20
 	close(cg_fd);
 skel_destroy:
-	test_misc_tcp_hdr_options__destroy(misc_skel);
-	test_tcp_hdr_options__destroy(skel);
+	test_sockops_misc_tcp_hdr_options__destroy(misc_skel);
+	test_sockops_tcp_hdr_options__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.=
c b/tools/testing/selftests/bpf/progs/test_sockops_misc_tcp_hdr_options.c
similarity index 100%
rename from tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c
rename to tools/testing/selftests/bpf/progs/test_sockops_misc_tcp_hdr_opt=
ions.c
diff --git a/tools/testing/selftests/bpf/progs/test_tcp_hdr_options.c b/t=
ools/testing/selftests/bpf/progs/test_sockops_tcp_hdr_options.c
similarity index 100%
rename from tools/testing/selftests/bpf/progs/test_tcp_hdr_options.c
rename to tools/testing/selftests/bpf/progs/test_sockops_tcp_hdr_options.=
c
--=20
2.30.2

