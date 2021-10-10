Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022B2427E29
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 02:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhJJA0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 20:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhJJA0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 20:26:03 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEBCC061762
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 17:24:05 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id o20so42234653wro.3
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 17:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xKKhkzmy8qWVk+hYtwkZjhg13q8YviMKxNPEZCBOe3Q=;
        b=jH0EG4Wwjm1aMn4E3US93D39cr7AxH0VxhHuEktEIl83jDorRdcN5ZrLqc/k5mtfhM
         uSa/fzEVD5pLFvDwAVlsH0nVayVuLoEiVtDXCu10uiyWIbzabGNiPsnrIBUYSsg8PjLr
         J9hAXLKAwVVx3Oi2KV114UE7w0l9rfpdT70s0/rbMv/PrLzngp/27ziPZ1/rMbJo+NHZ
         kbzbMzP9UbJ6famutm0uUIAyPN/5D6OBgLAF448s14RiiesQdp/DdicdGPOCVpcPkCPS
         vh9qTu1+ipYrRxXjj5vSq8LRYDq6L9oQozZWpwWfDWwaa4+SuchgzoUCNiu4+9Wv6GTw
         ikjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xKKhkzmy8qWVk+hYtwkZjhg13q8YviMKxNPEZCBOe3Q=;
        b=GE9L0lionWW/8lt6qYKCxf/D3miZ73oXjVcbOSrdbc25f2uBFCX3VODdwiMNTlXEDe
         ZlDjCwNDhoTAsASHqaJSUUS0X8eWgwZqIftq38z/nyba0mcP3i4Sm64W63eoqfW/AKoR
         QyYjA7N+IoHn7GiKng+QRc/+tz3DQ17priramaiFhMt5EOWkofz9GZ6D76SacGx2rvtH
         G8/k4/4ZydNAOwnM85+BAInBUno7eEdw/nYZwSFHUpMCcOxH656SEzIGDJBly1PBBg6C
         wK6tDpvmhntzUNkS7p51pQL7d1/zF0MEmUcSl+1Q2oFpAI1pb6NqptUrqdxozH6cxHPY
         9KKA==
X-Gm-Message-State: AOAM531LTfA1ht+d4B7UHpZuuUIuu7QJiObInQWceqh2LJSIQhhvtfMj
        I3Jb6d6kUcdapL8JOn/u7jxdzffcE9BaD+Pm
X-Google-Smtp-Source: ABdhPJzdeglm410nthhxUVb2TWDuYMZtf3LlI5jNxFoQcyJUqycYpbelX9i5e1YAQzGloWnhsjVr9Q==
X-Received: by 2002:a05:600c:1987:: with SMTP id t7mr2502968wmq.102.1633825444333;
        Sat, 09 Oct 2021 17:24:04 -0700 (PDT)
Received: from localhost.localdomain ([149.86.86.59])
        by smtp.gmail.com with ESMTPSA id c132sm16479487wma.22.2021.10.09.17.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 17:24:03 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next] bpf/preload: Clean up .gitignore and "clean-files" target
Date:   Sun, 10 Oct 2021 01:24:00 +0100
Message-Id: <20211010002400.9339-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel/bpf/preload/Makefile was recently updated to have it install
libbpf's headers locally instead of pulling them from tools/lib/bpf. But
two items still need to be addressed.

First, the local .gitignore file was not adjusted to ignore the files
generated in the new kernel/bpf/preload/libbpf output directory.

Second, the "clean-files" target is now incorrect. The old artefacts
names were not removed from the target, while the new ones were added
incorrectly. This is because "clean-files" expects names relative to
$(obj), but we passed the absolute path instead. This results in the
output and header-destination directories for libbpf (and their
contents) not being removed from kernel/bpf/preload on "make clean" from
the root of the repository.

This commit fixes both issues. Note that $(userprogs) needs not be added
to "clean-files", because the cleaning infrastructure already accounts
for it.

Cleaning the files properly also prevents make from printing the
following message, for builds coming after a "make clean":
"make[4]: Nothing to be done for 'install_headers'."

Fixes: bf60791741d4 ("bpf: preload: Install libbpf headers when building")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 kernel/bpf/preload/.gitignore | 4 +---
 kernel/bpf/preload/Makefile   | 3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/preload/.gitignore b/kernel/bpf/preload/.gitignore
index 856a4c5ad0dd..9452322902a5 100644
--- a/kernel/bpf/preload/.gitignore
+++ b/kernel/bpf/preload/.gitignore
@@ -1,4 +1,2 @@
-/FEATURE-DUMP.libbpf
-/bpf_helper_defs.h
-/feature
+/libbpf
 /bpf_preload_umd
diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
index 469d35e890eb..d8379af88161 100644
--- a/kernel/bpf/preload/Makefile
+++ b/kernel/bpf/preload/Makefile
@@ -27,8 +27,7 @@ userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi \
 
 userprogs := bpf_preload_umd
 
-clean-files := $(userprogs) bpf_helper_defs.h FEATURE-DUMP.libbpf staticobjs/ feature/
-clean-files += $(LIBBPF_OUT) $(LIBBPF_DESTDIR)
+clean-files := $(subst $(abspath $(obj))/,,$(LIBBPF_OUT) $(LIBBPF_DESTDIR))
 
 $(obj)/iterators/iterators.o: | libbpf_hdrs
 
-- 
2.30.2

