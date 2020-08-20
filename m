Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E90924C84E
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgHTXNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:13:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21776 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728782AbgHTXNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:13:34 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KNAxTc017463
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:13:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8KOABgKxDkAoto+UcDpKTGt7jXSInxscyWv4gdzXTaE=;
 b=h+Xjq3WN+C55q6h38OK6ddI27CQfNJkAPn1E/DbP+2wRtSQ0jsiPXhe8FgU00RdsQSYD
 ydEjYWHfgM8Uyz4hMpxHz28TH3WUY1uLgZSTkaYPTIeT3enZ3TjLXnbgGuF3UQU6Xhxm
 1wubc833pZVSQ8Ngd7rsdgFqZ/yFuOm+qqI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p3s80q-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:13:34 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 16:13:33 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id EF4D12EC5F42; Thu, 20 Aug 2020 16:13:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 16/16] selftests/bpf: turn fexit_bpf2bpf into test with subtests
Date:   Thu, 20 Aug 2020 16:12:50 -0700
Message-ID: <20200820231250.1293069-17-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200820231250.1293069-1-andriin@fb.com>
References: <20200820231250.1293069-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_07:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=785
 spamscore=0 mlxscore=0 clxscore=1015 suspectscore=8 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200189
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are clearly 4 subtests, so make it official.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/too=
ls/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index 197d0d217b56..12fe8b94cc04 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -143,8 +143,12 @@ static void test_func_replace_verify(void)
=20
 void test_fexit_bpf2bpf(void)
 {
-	test_target_no_callees();
-	test_target_yes_callees();
-	test_func_replace();
-	test_func_replace_verify();
+	if (test__start_subtest("target_no_callees"))
+		test_target_no_callees();
+	if (test__start_subtest("target_yes_callees"))
+		test_target_yes_callees();
+	if (test__start_subtest("func_replace"))
+		test_func_replace();
+	if (test__start_subtest("func_replace_verify"))
+		test_func_replace_verify();
 }
--=20
2.24.1

