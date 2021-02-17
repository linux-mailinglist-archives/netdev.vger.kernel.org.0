Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B62631D3B0
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhBQBNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbhBQBJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:09:55 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D149DC0617AB;
        Tue, 16 Feb 2021 17:08:59 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id cl8so471430pjb.0;
        Tue, 16 Feb 2021 17:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C6HlPPfLSW8B0FR1o4nfrvuLVT84DuSdSXqFu2lS9ys=;
        b=Ue/A2zISy74IPfcHxCddBc19QJp0r6Y1nUTzx5pdJMt/SXHkcXAC9IdpI6OYCVjKCX
         PaK/8J/7cZWml6YDlQ2Whb8VkcnTNu9eYLoFRMODKpcDq/z29iGOnuh7gHFp+fimMmI7
         Q1psz9mcev9kTmIrd02QVuX9FqN5HaFV0EHyIR9nonbW0icbLk1/eVqmSgnAoJRdLb5j
         KGqUKh/BLfBEsXW6wIpn4hGLEUqlA4hmH0DS6xXRlbnKR1GV87SCo+aMImTP2BMdvg6U
         K55E7ulzY/4abrSsQra4E6pt+5oAubI4YzbIWMFDxt9pS37w8UiwHpzQ2xajp4Z0h3cD
         RzTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=C6HlPPfLSW8B0FR1o4nfrvuLVT84DuSdSXqFu2lS9ys=;
        b=Waaow0Y9opW05K+SMuWjCToCvJ5JztLjsWlVa1qOhwJYdCkhtGvQtDMtsKsbPACzG+
         G+rYrkKDRt/dSWcdgZHHpKXIFJY55ovr94lLXzDJTk/zWtrgAmVMpbzE74Ts3jalPt2y
         PT1vwFslS1e2LbE2tbMUg3wqput9Y/+iKdpaQw0fzP9JMpgd3Ol9ANU5FmTyf+C94xQE
         3zwQYM/nQUvYh52mE4OlzNOtEPIvRjtJ8e3Uok/gYw2zhaHg1N//kH4e2Hoeu2bTQKfO
         RIZQJJmZ8BedcZEuuYjPbohvdn6Zy4XkARJHKZ9hfrPXRJyHunnNUm6oBbP+6G7NGhxx
         vRhA==
X-Gm-Message-State: AOAM531lDqN9F4oTXoob80ODdZvzZU/o7qb7JobdWXaEMfxhkXOGVTZt
        0+pGzkA7hVvNWmweOmsJF6ct6MZMW1kQlw==
X-Google-Smtp-Source: ABdhPJzzaC8WUWfKmlD2Kw05sS4PXZHfAvexPlWCrXwPx2JnAClh3FgCdftadH5PP40cS56xDiVpIw==
X-Received: by 2002:a17:903:181:b029:df:c7e5:8e39 with SMTP id z1-20020a1709030181b02900dfc7e58e39mr22525292plg.25.1613524139051;
        Tue, 16 Feb 2021 17:08:59 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:08:58 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, mtk.manpages@gmail.com,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 15/17] selftests/bpf: Add docs target
Date:   Tue, 16 Feb 2021 17:08:19 -0800
Message-Id: <20210217010821.1810741-16-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

This docs target will run the scripts/bpf_doc.py against the BPF UAPI
headers to ensure that the parser used for generating manual pages from
the headers doesn't trip on any newly added API documentation.

While we're at it, remove the bpftool-specific docs check target since
that would just be duplicated with the new target anyhow.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Joe Stringer <joe@cilium.io>
---
 tools/testing/selftests/bpf/Makefile          | 20 +++++++++++++-----
 .../selftests/bpf/test_bpftool_build.sh       | 21 -------------------
 tools/testing/selftests/bpf/test_doc_build.sh | 13 ++++++++++++
 3 files changed, 28 insertions(+), 26 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_doc_build.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 044bfdcf5b74..e1a76444670c 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -68,6 +68,7 @@ TEST_PROGS := test_kmod.sh \
 	test_bpftool_build.sh \
 	test_bpftool.sh \
 	test_bpftool_metadata.sh \
+	test_docs_build.sh \
 	test_xsk.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
@@ -103,6 +104,7 @@ override define CLEAN
 	$(call msg,CLEAN)
 	$(Q)$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
 	$(Q)$(MAKE) -C bpf_testmod clean
+	$(Q)$(MAKE) docs-clean
 endef
 
 include ../lib.mk
@@ -180,6 +182,7 @@ $(OUTPUT)/runqslower: $(BPFOBJ) | $(DEFAULT_BPFTOOL)
 		    cp $(SCRATCH_DIR)/runqslower $@
 
 $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(BPFOBJ)
+$(TEST_GEN_FILES): docs
 
 $(OUTPUT)/test_dev_cgroup: cgroup_helpers.c
 $(OUTPUT)/test_skb_cgroup_id_user: cgroup_helpers.c
@@ -200,11 +203,16 @@ $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
 		    CC=$(HOSTCC) LD=$(HOSTLD)				       \
 		    OUTPUT=$(HOST_BUILD_DIR)/bpftool/			       \
 		    prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install
-	$(Q)mkdir -p $(BUILD_DIR)/bpftool/Documentation
-	$(Q)RST2MAN_OPTS="--exit-status=1" $(MAKE) $(submake_extras)	       \
-		    -C $(BPFTOOLDIR)/Documentation			       \
-		    OUTPUT=$(BUILD_DIR)/bpftool/Documentation/		       \
-		    prefix= DESTDIR=$(SCRATCH_DIR)/ install
+
+docs:
+	$(Q)RST2MAN_OPTS="--exit-status=1" $(MAKE) $(submake_extras)	\
+	            -C $(TOOLSDIR)/bpf -f Makefile.docs			\
+	            prefix= OUTPUT=$(OUTPUT)/ DESTDIR=$(OUTPUT)/ $@
+
+docs-clean:
+	$(Q)$(MAKE) $(submake_extras)	\
+	            -C $(TOOLSDIR)/bpf -f Makefile.docs			\
+	            prefix= OUTPUT=$(OUTPUT)/ DESTDIR=$(OUTPUT)/ $@
 
 $(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
 	   ../../../include/uapi/linux/bpf.h                                   \
@@ -476,3 +484,5 @@ EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR) $(HOST_SCRATCH_DIR)	\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
 	feature								\
 	$(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32 bpf_gcc bpf_testmod.ko)
+
+.PHONY: docs docs-clean
diff --git a/tools/testing/selftests/bpf/test_bpftool_build.sh b/tools/testing/selftests/bpf/test_bpftool_build.sh
index 2db3c60e1e61..ac349a5cea7e 100755
--- a/tools/testing/selftests/bpf/test_bpftool_build.sh
+++ b/tools/testing/selftests/bpf/test_bpftool_build.sh
@@ -85,23 +85,6 @@ make_with_tmpdir() {
 	echo
 }
 
-make_doc_and_clean() {
-	echo -e "\$PWD:    $PWD"
-	echo -e "command: make -s $* doc >/dev/null"
-	RST2MAN_OPTS="--exit-status=1" make $J -s $* doc
-	if [ $? -ne 0 ] ; then
-		ERROR=1
-		printf "FAILURE: Errors or warnings when building documentation\n"
-	fi
-	(
-		if [ $# -ge 1 ] ; then
-			cd ${@: -1}
-		fi
-		make -s doc-clean
-	)
-	echo
-}
-
 echo "Trying to build bpftool"
 echo -e "... through kbuild\n"
 
@@ -162,7 +145,3 @@ make_and_clean
 make_with_tmpdir OUTPUT
 
 make_with_tmpdir O
-
-echo -e "Checking documentation build\n"
-# From tools/bpf/bpftool
-make_doc_and_clean
diff --git a/tools/testing/selftests/bpf/test_doc_build.sh b/tools/testing/selftests/bpf/test_doc_build.sh
new file mode 100755
index 000000000000..7eb940a7b2eb
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_doc_build.sh
@@ -0,0 +1,13 @@
+#!/bin/bash
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+# Assume script is located under tools/testing/selftests/bpf/. We want to start
+# build attempts from the top of kernel repository.
+SCRIPT_REL_PATH=$(realpath --relative-to=$PWD $0)
+SCRIPT_REL_DIR=$(dirname $SCRIPT_REL_PATH)
+KDIR_ROOT_DIR=$(realpath $PWD/$SCRIPT_REL_DIR/../../../../)
+cd $KDIR_ROOT_DIR
+
+for tgt in docs docs-clean; do
+	make -s -C $PWD/$SCRIPT_REL_DIR $tgt;
+done
-- 
2.27.0

