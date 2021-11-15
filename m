Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206D3451FDB
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354970AbhKPApi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355466AbhKPAl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 19:41:58 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26299C073AE5
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 14:59:01 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id d27so33749571wrb.6
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 14:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MgNgZa/B9gbbQJkFhSDhOixcZt0zjFXwu7Dm3LL/ENw=;
        b=CK5ayWgne4kD2OrKtiYGetoZHTTRh4uveC2qvye5cH5Hwh2J3U8mp12F5m2TIxjZG+
         P7XxMojrRVGyAN9goOr901ufOBBHH/5Dgh8GRXK1E3Nl+6FlcyhVbyrb6cP3WMy+Wr/P
         uZUL9Xmjp5gI9jVF2tb/PXEx34eA08lZ/xxgzndZ7IiT28qR+Nq+AEbRdxTeJuacd/Lp
         Swj5z8x3It8pzYsvgyJg0IYKFRA3d3vsFo3H8+X6qIUqd6vQJVnTBYdINZDvEFzf9MI/
         SyyMK43e4b1nCt2j9Va66yx/NRggL9gq4wrJR/JCkELyb6VVJPuvtgAynXlzj3Erc4EZ
         8l3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MgNgZa/B9gbbQJkFhSDhOixcZt0zjFXwu7Dm3LL/ENw=;
        b=tGI56/n6lqQwAlFcLaecP9/rQKgR2zcuT4X8PKt14Tb+fgMV+ApjAGYluUU1cDwV2p
         IfpmQlLk0sC/9RqX3qkB75DimHI91jcUvRGKIYnTfkQmSxqgbnOmheAMloq44y5j3hVI
         VRL9WCtYIZOz572mHgmS1tDGJNJPSGPhhZsCBuLukr+dFrxr/zLusCSMau4Bfj3cp4BH
         G9/vVDdo+VD18qoxquW14rl3cwZ4SYk9p4WI1J0wn+0N5WfDz6EdMNlr42gbDyE4XfJC
         uPO7eXdvjYftzb6IR999Yf2YOciB2W7ccvX0u0EL/sBZ7K7YZNxxjUCcKSwJBUotFkiq
         08Ag==
X-Gm-Message-State: AOAM531q7R7TDFLu8oID5TbuHpVAqdVjSNTMfy8NN2I7u6uYMoUa5T4c
        W328Htj6j42P4/WwW6X24pYl2A==
X-Google-Smtp-Source: ABdhPJwZZ42hJ7VhW2ZBr9bqZ/Gmxc2uh3puUPA7/WAlaY0yGbv8zXgBn/y30h+CD4rO58rjtaVylw==
X-Received: by 2002:a5d:6d41:: with SMTP id k1mr3362233wri.134.1637017139733;
        Mon, 15 Nov 2021 14:58:59 -0800 (PST)
Received: from localhost.localdomain ([149.86.89.157])
        by smtp.gmail.com with ESMTPSA id y12sm15467619wrn.73.2021.11.15.14.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 14:58:59 -0800 (PST)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 1/3] bpftool: Add SPDX tags to RST documentation files
Date:   Mon, 15 Nov 2021 22:58:42 +0000
Message-Id: <20211115225844.33943-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211115225844.33943-1-quentin@isovalent.com>
References: <20211115225844.33943-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most files in the kernel repository have a SPDX tags. The files that
don't have such a tag (or another license boilerplate) tend to fall
under the GPL-2.0 license. In the past, bpftool's Makefile (for example)
has been marked as GPL-2.0 for that reason, when in fact all bpftool is
dual-licensed.

To prevent a similar confusion from happening with the RST documentation
files for bpftool, let's explicitly mark all files as dual-licensed.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Documentation/Makefile               | 2 +-
 tools/bpf/bpftool/Documentation/bpftool-btf.rst        | 2 ++
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst     | 2 ++
 tools/bpf/bpftool/Documentation/bpftool-feature.rst    | 2 ++
 tools/bpf/bpftool/Documentation/bpftool-gen.rst        | 2 ++
 tools/bpf/bpftool/Documentation/bpftool-iter.rst       | 2 ++
 tools/bpf/bpftool/Documentation/bpftool-link.rst       | 2 ++
 tools/bpf/bpftool/Documentation/bpftool-map.rst        | 2 ++
 tools/bpf/bpftool/Documentation/bpftool-net.rst        | 2 ++
 tools/bpf/bpftool/Documentation/bpftool-perf.rst       | 2 ++
 tools/bpf/bpftool/Documentation/bpftool-prog.rst       | 2 ++
 tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst | 2 ++
 tools/bpf/bpftool/Documentation/bpftool.rst            | 2 ++
 tools/bpf/bpftool/Documentation/common_options.rst     | 2 ++
 14 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Documentation/Makefile b/tools/bpf/bpftool/Documentation/Makefile
index 692e1b947490..ac8487dcff1d 100644
--- a/tools/bpf/bpftool/Documentation/Makefile
+++ b/tools/bpf/bpftool/Documentation/Makefile
@@ -24,7 +24,7 @@ man: man8
 man8: $(DOC_MAN8)
 
 RST2MAN_DEP := $(shell command -v rst2man 2>/dev/null)
-RST2MAN_OPTS += --verbose
+RST2MAN_OPTS += --verbose --strip-comments
 
 list_pages = $(sort $(basename $(filter-out $(1),$(MAN8_RST))))
 see_also = $(subst " ",, \
diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index 4425d942dd39..2d2ceb7163f6 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
 ================
 bpftool-btf
 ================
diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index 8069d37dd991..b954faeb0f07 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
 ================
 bpftool-cgroup
 ================
diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
index ab9f57ee4c3a..b1471788a15f 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
 ===============
 bpftool-feature
 ===============
diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
index 2a137f8a4cea..51e2e8de5208 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
 ================
 bpftool-gen
 ================
diff --git a/tools/bpf/bpftool/Documentation/bpftool-iter.rst b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
index 471f363a725a..51914c9e8a54 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-iter.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
 ============
 bpftool-iter
 ============
diff --git a/tools/bpf/bpftool/Documentation/bpftool-link.rst b/tools/bpf/bpftool/Documentation/bpftool-link.rst
index 9434349636a5..31371bcf605a 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-link.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-link.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
 ================
 bpftool-link
 ================
diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index 991d18fd84f2..e22c918c069c 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
 ================
 bpftool-map
 ================
diff --git a/tools/bpf/bpftool/Documentation/bpftool-net.rst b/tools/bpf/bpftool/Documentation/bpftool-net.rst
index 7ec57535a7c1..6d1aa374529f 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-net.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-net.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
 ================
 bpftool-net
 ================
diff --git a/tools/bpf/bpftool/Documentation/bpftool-perf.rst b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
index ce52798a917d..ad554806faa2 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-perf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
 ================
 bpftool-perf
 ================
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index f27265bd589b..d31148571403 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
 ================
 bpftool-prog
 ================
diff --git a/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst b/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
index 02afc0fc14cb..77b845b5ac61 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
 ==================
 bpftool-struct_ops
 ==================
diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
index 8ac86565c501..1248b35e67ae 100644
--- a/tools/bpf/bpftool/Documentation/bpftool.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
 ================
 BPFTOOL
 ================
diff --git a/tools/bpf/bpftool/Documentation/common_options.rst b/tools/bpf/bpftool/Documentation/common_options.rst
index 75adf23202d8..908487b9c2ad 100644
--- a/tools/bpf/bpftool/Documentation/common_options.rst
+++ b/tools/bpf/bpftool/Documentation/common_options.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
 -h, --help
 	  Print short help message (similar to **bpftool help**).
 
-- 
2.32.0

