Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E08B0CB116
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731277AbfJCV3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:29:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18838 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730037AbfJCV3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 17:29:12 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x93LRAYQ024047
        for <netdev@vger.kernel.org>; Thu, 3 Oct 2019 14:29:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=OUN85DEkm41L70ZkDVJktMMyo++fQlpfBqfIaHs9TAo=;
 b=LX8K7akiIUE9EcFrPXkJ5fPhryKddS/kPL+uovO+go06dk290HZhb6i5BB6vgchmMufC
 Px6EIlcguvTF2cYCpxKN9XLxbrsfiRTCD7IYbMhp2FPkgvShPzpa/GEWDtaY6fPFLEPi
 Pe10u6yT+cmNLURx2hY+cFjj6HSYZc9pAgs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vdjyyhvne-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 14:29:10 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 3 Oct 2019 14:29:09 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 114E58618DE; Thu,  3 Oct 2019 14:29:08 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 5/7] libbpf: move bpf_{helpers,endian,tracing}.h into libbpf
Date:   Thu, 3 Oct 2019 14:28:54 -0700
Message-ID: <20191003212856.1222735-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191003212856.1222735-1-andriin@fb.com>
References: <20191003212856.1222735-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-03_08:2019-10-03,2019-10-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=890
 impostorscore=0 mlxscore=0 phishscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 suspectscore=8
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910030172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move bpf_helpers.h, bpf_tracing.h, and bpf_endian.h into libbpf. Ensure
they are installed along the other libbpf headers. Also, adjust
selftests and samples include path to include libbpf now.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 samples/bpf/Makefile                               | 2 +-
 tools/lib/bpf/Makefile                             | 5 ++++-
 tools/{testing/selftests => lib}/bpf/bpf_endian.h  | 0
 tools/{testing/selftests => lib}/bpf/bpf_helpers.h | 0
 tools/{testing/selftests => lib}/bpf/bpf_tracing.h | 0
 tools/testing/selftests/bpf/Makefile               | 2 +-
 6 files changed, 6 insertions(+), 3 deletions(-)
 rename tools/{testing/selftests => lib}/bpf/bpf_endian.h (100%)
 rename tools/{testing/selftests => lib}/bpf/bpf_helpers.h (100%)
 rename tools/{testing/selftests => lib}/bpf/bpf_tracing.h (100%)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 42b571cde177..ecb3535d91e3 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -283,7 +283,7 @@ $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 $(obj)/%.o: $(src)/%.c
 	@echo "  CLANG-bpf " $@
 	$(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(EXTRA_CFLAGS) -I$(obj) \
-		-I$(srctree)/tools/testing/selftests/bpf/ \
+		-I$(srctree)/tools/testing/selftests/bpf/ -I$(srctree)/tools/lib/bpf/ \
 		-D__KERNEL__ -D__BPF_TRACING__ -Wno-unused-value -Wno-pointer-sign \
 		-D__TARGET_ARCH_$(SRCARCH) -Wno-compare-distinct-pointer-types \
 		-Wno-gnu-variable-sized-type-not-at-end \
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index c6f94cffe06e..20b5b0ff5c73 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -240,7 +240,10 @@ install_headers:
 		$(call do_install,libbpf.h,$(prefix)/include/bpf,644); \
 		$(call do_install,btf.h,$(prefix)/include/bpf,644); \
 		$(call do_install,libbpf_util.h,$(prefix)/include/bpf,644); \
-		$(call do_install,xsk.h,$(prefix)/include/bpf,644);
+		$(call do_install,xsk.h,$(prefix)/include/bpf,644); \
+		$(call do_install,bpf_helpers.h,$(prefix)/include/bpf,644); \
+		$(call do_install,bpf_tracing.h,$(prefix)/include/bpf,644); \
+		$(call do_install,bpf_endian.h,$(prefix)/include/bpf,644);
 
 install_pkgconfig: $(PC_FILE)
 	$(call QUIET_INSTALL, $(PC_FILE)) \
diff --git a/tools/testing/selftests/bpf/bpf_endian.h b/tools/lib/bpf/bpf_endian.h
similarity index 100%
rename from tools/testing/selftests/bpf/bpf_endian.h
rename to tools/lib/bpf/bpf_endian.h
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
similarity index 100%
rename from tools/testing/selftests/bpf/bpf_helpers.h
rename to tools/lib/bpf/bpf_helpers.h
diff --git a/tools/testing/selftests/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
similarity index 100%
rename from tools/testing/selftests/bpf/bpf_tracing.h
rename to tools/lib/bpf/bpf_tracing.h
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 6889c19a628c..b00a5d8046c7 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -148,7 +148,7 @@ $(shell $(1) -v -E - </dev/null 2>&1 \
 endef
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 BPF_CFLAGS = -I. -I./include/uapi -I../../../include/uapi \
-	     -I$(OUTPUT)/../usr/include -D__TARGET_ARCH_$(SRCARCH)
+	     -I$(BPFDIR) -I$(OUTPUT)/../usr/include -D__TARGET_ARCH_$(SRCARCH)
 
 CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
 	       -Wno-compare-distinct-pointer-types
-- 
2.17.1

