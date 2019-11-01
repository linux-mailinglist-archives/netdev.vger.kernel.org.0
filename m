Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6081EC8BE
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 19:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfKAS7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 14:59:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4304 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727498AbfKAS7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 14:59:22 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1IupRL016929
        for <netdev@vger.kernel.org>; Fri, 1 Nov 2019 11:59:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=yK2cmWYJ1CdCYpODyR/wBov+QPYl43w3BfpV+4stoUU=;
 b=XSxIOkA8olOwF6W/QIiVALK19zYzhd8PSY/55DsXJ/VHJifKCPHmSkfoewyZ9oTk7Hxa
 s5DmWLg6TWxkOUUjw6lnBS5wgTdaHcj+6EhwFcRKWZ6rawG0ZJ7QbphsDf3ZtCRvjkk2
 cf9B6eOGFt9rd3zcgjx3ChyBi7NCnc9hRzM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w01c4yams-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 11:59:20 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 1 Nov 2019 11:59:18 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AE6A12EC1A58; Fri,  1 Nov 2019 11:59:16 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/5] selftests/bpf: remove too strict field offset relo test cases
Date:   Fri, 1 Nov 2019 11:59:07 -0700
Message-ID: <20191101185912.594925-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191101185912.594925-1-andriin@fb.com>
References: <20191101185912.594925-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_07:2019-11-01,2019-11-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 adultscore=0 suspectscore=8 phishscore=0 spamscore=0
 mlxscore=0 priorityscore=1501 mlxlogscore=768 bulkscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1911010172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As libbpf is going to gain support for more field relocations, including field
size, some restrictions about exact size match are going to be lifted. Remove
test cases that explicitly test such failures.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 ...__core_reloc_arrays___err_wrong_val_type.c |  3 +
 ..._core_reloc_arrays___err_wrong_val_type1.c |  3 -
 ..._core_reloc_arrays___err_wrong_val_type2.c |  3 -
 .../btf__core_reloc_ints___err_bitfield.c     |  3 -
 .../btf__core_reloc_ints___err_wrong_sz_16.c  |  3 -
 .../btf__core_reloc_ints___err_wrong_sz_32.c  |  3 -
 .../btf__core_reloc_ints___err_wrong_sz_64.c  |  3 -
 .../btf__core_reloc_ints___err_wrong_sz_8.c   |  3 -
 .../selftests/bpf/progs/core_reloc_types.h    | 70 +------------------
 9 files changed, 4 insertions(+), 90 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type1.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type2.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_bitfield.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_16.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_32.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_64.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_8.c

diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type.c
new file mode 100644
index 000000000000..f5a7c832d0f2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_arrays___err_wrong_val_type x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type1.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type1.c
deleted file mode 100644
index 795a5b729176..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type1.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_arrays___err_wrong_val_type1 x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type2.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type2.c
deleted file mode 100644
index 3af74b837c4d..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type2.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_arrays___err_wrong_val_type2 x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_bitfield.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_bitfield.c
deleted file mode 100644
index 50369e8320a0..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_bitfield.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_ints___err_bitfield x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_16.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_16.c
deleted file mode 100644
index 823bac13d641..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_16.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_ints___err_wrong_sz_16 x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_32.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_32.c
deleted file mode 100644
index b44f3be18535..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_32.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_ints___err_wrong_sz_32 x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_64.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_64.c
deleted file mode 100644
index 9a3dd2099c0f..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_64.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_ints___err_wrong_sz_64 x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_8.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_8.c
deleted file mode 100644
index 9f11ef5f6e88..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_8.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_ints___err_wrong_sz_8 x) {}
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index f5939d9d5c61..3fe54f6f82cf 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -386,14 +386,7 @@ struct core_reloc_arrays___err_non_array {
 	struct core_reloc_arrays_substruct d[1][2];
 };
 
-struct core_reloc_arrays___err_wrong_val_type1 {
-	char a[5]; /* char instead of int */
-	char b[2][3][4];
-	struct core_reloc_arrays_substruct c[3];
-	struct core_reloc_arrays_substruct d[1][2];
-};
-
-struct core_reloc_arrays___err_wrong_val_type2 {
+struct core_reloc_arrays___err_wrong_val_type {
 	int a[5];
 	char b[2][3][4];
 	int c[3]; /* value is not a struct */
@@ -589,67 +582,6 @@ struct core_reloc_ints___bool {
 	int64_t		s64_field;
 };
 
-struct core_reloc_ints___err_bitfield {
-	uint8_t		u8_field;
-	int8_t		s8_field;
-	uint16_t	u16_field;
-	int16_t		s16_field;
-	uint32_t	u32_field: 32; /* bitfields are not supported */
-	int32_t		s32_field;
-	uint64_t	u64_field;
-	int64_t		s64_field;
-};
-
-struct core_reloc_ints___err_wrong_sz_8 {
-	uint16_t	u8_field; /* not 8-bit anymore */
-	int16_t		s8_field; /* not 8-bit anymore */
-
-	uint16_t	u16_field;
-	int16_t		s16_field;
-	uint32_t	u32_field;
-	int32_t		s32_field;
-	uint64_t	u64_field;
-	int64_t		s64_field;
-};
-
-struct core_reloc_ints___err_wrong_sz_16 {
-	uint8_t		u8_field;
-	int8_t		s8_field;
-
-	uint32_t	u16_field; /* not 16-bit anymore */
-	int32_t		s16_field; /* not 16-bit anymore */
-
-	uint32_t	u32_field;
-	int32_t		s32_field;
-	uint64_t	u64_field;
-	int64_t		s64_field;
-};
-
-struct core_reloc_ints___err_wrong_sz_32 {
-	uint8_t		u8_field;
-	int8_t		s8_field;
-	uint16_t	u16_field;
-	int16_t		s16_field;
-
-	uint64_t	u32_field; /* not 32-bit anymore */
-	int64_t		s32_field; /* not 32-bit anymore */
-
-	uint64_t	u64_field;
-	int64_t		s64_field;
-};
-
-struct core_reloc_ints___err_wrong_sz_64 {
-	uint8_t		u8_field;
-	int8_t		s8_field;
-	uint16_t	u16_field;
-	int16_t		s16_field;
-	uint32_t	u32_field;
-	int32_t		s32_field;
-
-	uint32_t	u64_field; /* not 64-bit anymore */
-	int32_t		s64_field; /* not 64-bit anymore */
-};
-
 /*
  * MISC
  */
-- 
2.17.1

