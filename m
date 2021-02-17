Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0300F31D3AA
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhBQBML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbhBQBJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:09:48 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCDCC061793;
        Tue, 16 Feb 2021 17:08:42 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id t11so7427742pgu.8;
        Tue, 16 Feb 2021 17:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7wkeXWSDW0rtEFRyuqfLBNSzMUu0eSr9sZboZSQF8RY=;
        b=aeXSQ9PJOXq9sym28oVJn+RaIHoNhyBCkjU+7UwOHB3XT934WY9lbWHTNtGnrZACmr
         Tww0LVkh3TjZuTGLdykEVoXowHb7MhIvw3tTPyV9Fw6zZsaRtJSM8xBWmFZw7FEcZIry
         oFKZi5IdKV8Le0YVe0c9fJ36gaQefR0+03K0TE/CTBJWMUbtSr9HtQ8orFqKxOPiaJzO
         X3PK27BAarfulFzjhTVHr2YF/THv9PeRnke02mtMPL3Er9OqUTNozLwecwJzvOGkQRNG
         8ZZo8devZF4js9quyNyq68ep4ULAPraznKcsON+45y/WqCgDj6D3703N8bjIG8x1d//C
         vbdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=7wkeXWSDW0rtEFRyuqfLBNSzMUu0eSr9sZboZSQF8RY=;
        b=epZihdieGEPS4ItFmvNx+nC6e84me56CEnFLigzkdIen+c4dbbEW3lYNhdCg686xbB
         +KL6pb8S+y9iB6GrPcxhZ7r1rZS5jKM3Pv9uI/LSRAYPXQ/fNR8LEgjPas03nOarrsrZ
         Z5eNnxu+88WCi80Ajdur6h1Q1+EndoQKcPfKRRbtW60gqqz5TPVarXBQDOX8uPPrQpLL
         d6tcmKBHM/1mCFDav+WaGPjc9kglf8I4FhM1WtTtdX57O6J0wDgtCbyZVtE1yzamoqD2
         z0O1VXNLep+lyp2QN7P78+ogvAyhQcY9St/QIHAmmQEoljX/PRfFj5GG5MtqCM8SRnnh
         ZCeg==
X-Gm-Message-State: AOAM532So7SuGVi5/Li2VQDPVR+puaNnFoq6qHFD5PQAhkyiEfOEImnD
        0iKjqBOiYfxQ8H6LDyG2NjtHowgZDF+tlg==
X-Google-Smtp-Source: ABdhPJwSSoxiLvIsHwDztS6GqR93ph5OPEXKNIFEL8Ieid7iac8rr0hkMLuFBUDc9gx0bewfHb0hMw==
X-Received: by 2002:aa7:8c59:0:b029:1db:48a9:be70 with SMTP id e25-20020aa78c590000b02901db48a9be70mr380629pfd.68.1613524121827;
        Tue, 16 Feb 2021 17:08:41 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:08:41 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, mtk.manpages@gmail.com,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 09/17] scripts/bpf: Rename bpf_helpers_doc.py -> bpf_doc.py
Date:   Tue, 16 Feb 2021 17:08:13 -0800
Message-Id: <20210217010821.1810741-10-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

Rename this file in anticipation of it being used for generating more
than just helper man pages.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Joe Stringer <joe@cilium.io>
---
 include/uapi/linux/bpf.h                   | 2 +-
 scripts/{bpf_helpers_doc.py => bpf_doc.py} | 4 ++--
 tools/bpf/Makefile.helpers                 | 2 +-
 tools/include/uapi/linux/bpf.h             | 2 +-
 tools/lib/bpf/Makefile                     | 2 +-
 tools/perf/MANIFEST                        | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)
 rename scripts/{bpf_helpers_doc.py => bpf_doc.py} (99%)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 893803f69a64..4abf54327612 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1425,7 +1425,7 @@ union bpf_attr {
  * parsed and used to produce a manual page. The workflow is the following,
  * and requires the rst2man utility:
  *
- *     $ ./scripts/bpf_helpers_doc.py \
+ *     $ ./scripts/bpf_doc.py \
  *             --filename include/uapi/linux/bpf.h > /tmp/bpf-helpers.rst
  *     $ rst2man /tmp/bpf-helpers.rst > /tmp/bpf-helpers.7
  *     $ man /tmp/bpf-helpers.7
diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_doc.py
similarity index 99%
rename from scripts/bpf_helpers_doc.py
rename to scripts/bpf_doc.py
index 867ada23281c..ca6e7559d696 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_doc.py
@@ -221,7 +221,7 @@ class PrinterRST(Printer):
 .. 
 .. Please do not edit this file. It was generated from the documentation
 .. located in file include/uapi/linux/bpf.h of the Linux kernel sources
-.. (helpers description), and from scripts/bpf_helpers_doc.py in the same
+.. (helpers description), and from scripts/bpf_doc.py in the same
 .. repository (header and footer).
 
 ===========
@@ -511,7 +511,7 @@ class PrinterHelpers(Printer):
 
     def print_header(self):
         header = '''\
-/* This is auto-generated file. See bpf_helpers_doc.py for details. */
+/* This is auto-generated file. See bpf_doc.py for details. */
 
 /* Forward declarations of BPF structs */'''
 
diff --git a/tools/bpf/Makefile.helpers b/tools/bpf/Makefile.helpers
index 854d084026dd..a26599022fd6 100644
--- a/tools/bpf/Makefile.helpers
+++ b/tools/bpf/Makefile.helpers
@@ -35,7 +35,7 @@ man7: $(DOC_MAN7)
 RST2MAN_DEP := $(shell command -v rst2man 2>/dev/null)
 
 $(OUTPUT)$(HELPERS_RST): $(UP2DIR)../../include/uapi/linux/bpf.h
-	$(QUIET_GEN)$(UP2DIR)../../scripts/bpf_helpers_doc.py --filename $< > $@
+	$(QUIET_GEN)$(UP2DIR)../../scripts/bpf_doc.py --filename $< > $@
 
 $(OUTPUT)%.7: $(OUTPUT)%.rst
 ifndef RST2MAN_DEP
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4c24daa43bac..16f2f0d2338a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -720,7 +720,7 @@ union bpf_attr {
  * parsed and used to produce a manual page. The workflow is the following,
  * and requires the rst2man utility:
  *
- *     $ ./scripts/bpf_helpers_doc.py \
+ *     $ ./scripts/bpf_doc.py \
  *             --filename include/uapi/linux/bpf.h > /tmp/bpf-helpers.rst
  *     $ rst2man /tmp/bpf-helpers.rst > /tmp/bpf-helpers.7
  *     $ man /tmp/bpf-helpers.7
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 887a494ad5fc..8170f88e8ea6 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -158,7 +158,7 @@ $(BPF_IN_STATIC): force $(BPF_HELPER_DEFS)
 	$(Q)$(MAKE) $(build)=libbpf OUTPUT=$(STATIC_OBJDIR)
 
 $(BPF_HELPER_DEFS): $(srctree)/tools/include/uapi/linux/bpf.h
-	$(QUIET_GEN)$(srctree)/scripts/bpf_helpers_doc.py --header \
+	$(QUIET_GEN)$(srctree)/scripts/bpf_doc.py --header \
 		--file $(srctree)/tools/include/uapi/linux/bpf.h > $(BPF_HELPER_DEFS)
 
 $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 5d7b947320fb..f05c4d48fd7e 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -20,4 +20,4 @@ tools/lib/bitmap.c
 tools/lib/str_error_r.c
 tools/lib/vsprintf.c
 tools/lib/zalloc.c
-scripts/bpf_helpers_doc.py
+scripts/bpf_doc.py
-- 
2.27.0

