Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0049D6BC0A1
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbjCOXEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbjCOXEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:04:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E405E763F3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:04:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93BBDB81F88
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 23:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1067AC4339C;
        Wed, 15 Mar 2023 23:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678921467;
        bh=3V4pqGPBpwLUcwiJh23Aa44VYBO9PJlcD0qqHnq8uYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QroS86d6llahZ555JOVq714LMbPhnzaz3PmHcqmgiyNEpCXwCe/q+X8L9zffC2Kzw
         4lF/oerEhjYx7FA3eu7dA8MMsg3YpvoFOVSnF0PqlUXMcqXOt+WY70RBru/t7zEk7v
         KIw+7/B0rmjhPKc8ZF6NQ3IcztGgYep3jub4KNLGI96ZD1awQGhiO9L55RdUIK8QvS
         rhO/6rqevuRZHXXS25CQMq+gZ9I6DDC3mcES9WbUvN16ALuRqTNjvZKN9T4RKD0KJg
         q4Ft8fRcRz5zDNNt56yyu+tosqgWUtwTSAOy4ABWNIOgoDs4WNRxOCtq5GSkBuj2CO
         cmU7UWR0Ra9ow==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        chuck.lever@oracle.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/3] ynl: broaden the license even more
Date:   Wed, 15 Mar 2023 16:03:50 -0700
Message-Id: <20230315230351.478320-3-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315230351.478320-1-kuba@kernel.org>
References: <20230315230351.478320-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I relicensed Netlink spec code to GPL-2.0 OR BSD-3-Clause but
we still put a slightly different license on the uAPI header
than the rest of the code. Use the Linux-syscall-note on all
the specs and all generated code. It's moot for kernel code,
but should not hurt. This way the licenses match everywhere.

Cc: Chuck Lever <chuck.lever@oracle.com>
Fixes: 37d9df224d1e ("ynl: re-license uniformly under GPL-2.0 OR BSD-3-Clause")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/genetlink-c.yaml        | 2 +-
 Documentation/netlink/genetlink-legacy.yaml   | 2 +-
 Documentation/netlink/genetlink.yaml          | 2 +-
 Documentation/netlink/specs/ethtool.yaml      | 2 +-
 Documentation/netlink/specs/fou.yaml          | 2 +-
 Documentation/netlink/specs/netdev.yaml       | 2 +-
 Documentation/userspace-api/netlink/specs.rst | 3 ++-
 include/uapi/linux/fou.h                      | 2 +-
 include/uapi/linux/netdev.h                   | 2 +-
 net/core/netdev-genl-gen.c                    | 2 +-
 net/core/netdev-genl-gen.h                    | 2 +-
 net/ipv4/fou_nl.c                             | 2 +-
 net/ipv4/fou_nl.h                             | 2 +-
 tools/include/uapi/linux/netdev.h             | 2 +-
 tools/net/ynl/ynl-gen-c.py                    | 8 ++++----
 15 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/Documentation/netlink/genetlink-c.yaml b/Documentation/netlink/genetlink-c.yaml
index f082a5ad7cf1..5c3642b3f802 100644
--- a/Documentation/netlink/genetlink-c.yaml
+++ b/Documentation/netlink/genetlink-c.yaml
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
 %YAML 1.2
 ---
 $id: http://kernel.org/schemas/netlink/genetlink-c.yaml#
diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index c6b8c77f7d12..5e98c6d2b9aa 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
 %YAML 1.2
 ---
 $id: http://kernel.org/schemas/netlink/genetlink-legacy.yaml#
diff --git a/Documentation/netlink/genetlink.yaml b/Documentation/netlink/genetlink.yaml
index b2d56ab9e615..d35dcd6f8d82 100644
--- a/Documentation/netlink/genetlink.yaml
+++ b/Documentation/netlink/genetlink.yaml
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
 %YAML 1.2
 ---
 $id: http://kernel.org/schemas/netlink/genetlink-legacy.yaml#
diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 18ecb7d90cbe..4727c067e2ba 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
 
 name: ethtool
 
diff --git a/Documentation/netlink/specs/fou.yaml b/Documentation/netlink/specs/fou.yaml
index cff104288723..3e13826a3fdf 100644
--- a/Documentation/netlink/specs/fou.yaml
+++ b/Documentation/netlink/specs/fou.yaml
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
 
 name: fou
 
diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netlink/specs/netdev.yaml
index 753e5914a8b7..b99e7ffef7a1 100644
--- a/Documentation/netlink/specs/netdev.yaml
+++ b/Documentation/netlink/specs/netdev.yaml
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
 
 name: netdev
 
diff --git a/Documentation/userspace-api/netlink/specs.rst b/Documentation/userspace-api/netlink/specs.rst
index 2122e0c4a399..a22442ba1d30 100644
--- a/Documentation/userspace-api/netlink/specs.rst
+++ b/Documentation/userspace-api/netlink/specs.rst
@@ -24,7 +24,8 @@ YAML specifications can be found under ``Documentation/netlink/specs/``
 This document describes details of the schema.
 See :doc:`intro-specs` for a practical starting guide.
 
-All specs must be licensed under ``GPL-2.0-only OR BSD-3-Clause``
+All specs must be licensed under
+``((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)``
 to allow for easy adoption in user space code.
 
 Compatibility levels
diff --git a/include/uapi/linux/fou.h b/include/uapi/linux/fou.h
index 5041c3598493..b5cd3e7b3775 100644
--- a/include/uapi/linux/fou.h
+++ b/include/uapi/linux/fou.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
 /* Do not edit directly, auto-generated from: */
 /*	Documentation/netlink/specs/fou.yaml */
 /* YNL-GEN uapi header */
diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
index ed134fbdfd32..639524b59930 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
 /* Do not edit directly, auto-generated from: */
 /*	Documentation/netlink/specs/netdev.yaml */
 /* YNL-GEN uapi header */
diff --git a/net/core/netdev-genl-gen.c b/net/core/netdev-genl-gen.c
index 9e10802587fc..3abab70d66dd 100644
--- a/net/core/netdev-genl-gen.c
+++ b/net/core/netdev-genl-gen.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
 /* Do not edit directly, auto-generated from: */
 /*	Documentation/netlink/specs/netdev.yaml */
 /* YNL-GEN kernel source */
diff --git a/net/core/netdev-genl-gen.h b/net/core/netdev-genl-gen.h
index 2c5fc7d1e8a7..74d74fc23167 100644
--- a/net/core/netdev-genl-gen.h
+++ b/net/core/netdev-genl-gen.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
 /* Do not edit directly, auto-generated from: */
 /*	Documentation/netlink/specs/netdev.yaml */
 /* YNL-GEN kernel header */
diff --git a/net/ipv4/fou_nl.c b/net/ipv4/fou_nl.c
index 5c14fe030eda..6c37c4f98cca 100644
--- a/net/ipv4/fou_nl.c
+++ b/net/ipv4/fou_nl.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
 /* Do not edit directly, auto-generated from: */
 /*	Documentation/netlink/specs/fou.yaml */
 /* YNL-GEN kernel source */
diff --git a/net/ipv4/fou_nl.h b/net/ipv4/fou_nl.h
index 58b1e1ed4b3b..dbd0780a5d34 100644
--- a/net/ipv4/fou_nl.h
+++ b/net/ipv4/fou_nl.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
 /* Do not edit directly, auto-generated from: */
 /*	Documentation/netlink/specs/fou.yaml */
 /* YNL-GEN kernel header */
diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux/netdev.h
index ed134fbdfd32..639524b59930 100644
--- a/tools/include/uapi/linux/netdev.h
+++ b/tools/include/uapi/linux/netdev.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
 /* Do not edit directly, auto-generated from: */
 /*	Documentation/netlink/specs/netdev.yaml */
 /* YNL-GEN uapi header */
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index d47376f19de7..3b4d03a50fc1 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -1,5 +1,5 @@
 #!/usr/bin/env python3
-# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
 
 import argparse
 import collections
@@ -2068,12 +2068,12 @@ _C_KW = {
 
     _, spec_kernel = find_kernel_root(args.spec)
     if args.mode == 'uapi':
-        cw.p('/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause */')
+        cw.p('/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */')
     else:
         if args.header:
-            cw.p('/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */')
+            cw.p('/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */')
         else:
-            cw.p('// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause')
+            cw.p('// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)')
     cw.p("/* Do not edit directly, auto-generated from: */")
     cw.p(f"/*\t{spec_kernel} */")
     cw.p(f"/* YNL-GEN {args.mode} {'header' if args.header else 'source'} */")
-- 
2.39.2

