Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F15E6ACED3
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 21:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjCFUFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 15:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbjCFUFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 15:05:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2016A42C
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 12:05:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD03F61147
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 20:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31A8C433EF;
        Mon,  6 Mar 2023 20:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678133100;
        bh=pQfKzfuB5e+RmakuVbb6WR7bHiRaCztu08po00Zv++s=;
        h=From:To:Cc:Subject:Date:From;
        b=e/bPZtqIXY1TlhvdNaIzRFrWezYRcOD+UTTsutex7+dh2FQ9c8Q1GatN21VXyNUFQ
         ybQRhh9JePnnsGn+H8KBD2gTR0o6jtLx+gX3fVxPkbXS5bItKIcgOuO1QYhH1ZF8ip
         0wZp5O9o6ZcGh/h787UNKJlDndtXgcqGhNCxIXh4bBpzDyQ3WAXzbLFhz2O7xZSHPv
         o7yEInhQyJagykac4xYIH6V62d8XxPBTZvyppZg2XaXM8zzni+G4X1BrSM+GcBd7rW
         esy2XJumZF9cC54pxPaE9zTPy1YSicv1d8riPXfAkgEpZVOucybeNOS6G+HNY2XtKC
         LN7tGlHGHfW4A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH net] ynl: re-license uniformly under GPL-2.0 OR BSD-3-Clause
Date:   Mon,  6 Mar 2023 12:04:57 -0800
Message-Id: <20230306200457.3903854-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was intending to make all the Netlink Spec code BSD-3-Clause
to ease the adoption but it appears that:
 - I fumbled the uAPI and used "GPL WITH uAPI note" there
 - it gives people pause as they expect GPL in the kernel
As suggested by Chuck re-license under dual. This gives us benefit
of full BSD freedom while fulfilling the broad "kernel is under GPL"
expectations.

Link: https://lore.kernel.org/all/20230304120108.05dd44c5@kernel.org/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: Tariq Toukan <tariqt@nvidia.com>
CC: Lorenzo Bianconi <lorenzo@kernel.org>

Tariq, Lorenzo, can I have your acks?
---
 Documentation/netlink/genetlink-c.yaml        | 2 +-
 Documentation/netlink/genetlink-legacy.yaml   | 2 +-
 Documentation/netlink/genetlink.yaml          | 2 +-
 Documentation/netlink/specs/ethtool.yaml      | 2 ++
 Documentation/netlink/specs/fou.yaml          | 2 ++
 Documentation/netlink/specs/netdev.yaml       | 2 ++
 Documentation/userspace-api/netlink/specs.rst | 3 +++
 include/uapi/linux/fou.h                      | 2 +-
 include/uapi/linux/netdev.h                   | 2 +-
 net/core/netdev-genl-gen.c                    | 2 +-
 net/core/netdev-genl-gen.h                    | 2 +-
 net/ipv4/fou_nl.c                             | 2 +-
 net/ipv4/fou_nl.h                             | 2 +-
 tools/include/uapi/linux/netdev.h             | 2 +-
 tools/net/ynl/cli.py                          | 2 +-
 tools/net/ynl/lib/__init__.py                 | 2 +-
 tools/net/ynl/lib/nlspec.py                   | 2 +-
 tools/net/ynl/lib/ynl.py                      | 2 +-
 tools/net/ynl/ynl-gen-c.py                    | 7 ++++---
 tools/net/ynl/ynl-regen.sh                    | 2 +-
 20 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/Documentation/netlink/genetlink-c.yaml b/Documentation/netlink/genetlink-c.yaml
index bbcfa2472b04..f082a5ad7cf1 100644
--- a/Documentation/netlink/genetlink-c.yaml
+++ b/Documentation/netlink/genetlink-c.yaml
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 %YAML 1.2
 ---
 $id: http://kernel.org/schemas/netlink/genetlink-c.yaml#
diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index 5642925c4ceb..c6b8c77f7d12 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 %YAML 1.2
 ---
 $id: http://kernel.org/schemas/netlink/genetlink-legacy.yaml#
diff --git a/Documentation/netlink/genetlink.yaml b/Documentation/netlink/genetlink.yaml
index 62a922755ce2..b2d56ab9e615 100644
--- a/Documentation/netlink/genetlink.yaml
+++ b/Documentation/netlink/genetlink.yaml
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 %YAML 1.2
 ---
 $id: http://kernel.org/schemas/netlink/genetlink-legacy.yaml#
diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 35c462bce56f..18ecb7d90cbe 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+
 name: ethtool
 
 protocol: genetlink-legacy
diff --git a/Documentation/netlink/specs/fou.yaml b/Documentation/netlink/specs/fou.yaml
index cca4cf98f03a..cff104288723 100644
--- a/Documentation/netlink/specs/fou.yaml
+++ b/Documentation/netlink/specs/fou.yaml
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+
 name: fou
 
 protocol: genetlink-legacy
diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netlink/specs/netdev.yaml
index ba9ee13cf729..24de747b5344 100644
--- a/Documentation/netlink/specs/netdev.yaml
+++ b/Documentation/netlink/specs/netdev.yaml
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+
 name: netdev
 
 doc:
diff --git a/Documentation/userspace-api/netlink/specs.rst b/Documentation/userspace-api/netlink/specs.rst
index 32e53328d113..2122e0c4a399 100644
--- a/Documentation/userspace-api/netlink/specs.rst
+++ b/Documentation/userspace-api/netlink/specs.rst
@@ -24,6 +24,9 @@ YAML specifications can be found under ``Documentation/netlink/specs/``
 This document describes details of the schema.
 See :doc:`intro-specs` for a practical starting guide.
 
+All specs must be licensed under ``GPL-2.0-only OR BSD-3-Clause``
+to allow for easy adoption in user space code.
+
 Compatibility levels
 ====================
 
diff --git a/include/uapi/linux/fou.h b/include/uapi/linux/fou.h
index 19ebbef41a63..5041c3598493 100644
--- a/include/uapi/linux/fou.h
+++ b/include/uapi/linux/fou.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause */
 /* Do not edit directly, auto-generated from: */
 /*	Documentation/netlink/specs/fou.yaml */
 /* YNL-GEN uapi header */
diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
index 588391447bfb..8c4e3e536c04 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause */
 /* Do not edit directly, auto-generated from: */
 /*	Documentation/netlink/specs/netdev.yaml */
 /* YNL-GEN uapi header */
diff --git a/net/core/netdev-genl-gen.c b/net/core/netdev-genl-gen.c
index 48812ec843f5..9e10802587fc 100644
--- a/net/core/netdev-genl-gen.c
+++ b/net/core/netdev-genl-gen.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: BSD-3-Clause
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /* Do not edit directly, auto-generated from: */
 /*	Documentation/netlink/specs/netdev.yaml */
 /* YNL-GEN kernel source */
diff --git a/net/core/netdev-genl-gen.h b/net/core/netdev-genl-gen.h
index b16dc7e026bb..2c5fc7d1e8a7 100644
--- a/net/core/netdev-genl-gen.h
+++ b/net/core/netdev-genl-gen.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: BSD-3-Clause */
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /* Do not edit directly, auto-generated from: */
 /*	Documentation/netlink/specs/netdev.yaml */
 /* YNL-GEN kernel header */
diff --git a/net/ipv4/fou_nl.c b/net/ipv4/fou_nl.c
index 6c3820f41dd5..5c14fe030eda 100644
--- a/net/ipv4/fou_nl.c
+++ b/net/ipv4/fou_nl.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: BSD-3-Clause
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /* Do not edit directly, auto-generated from: */
 /*	Documentation/netlink/specs/fou.yaml */
 /* YNL-GEN kernel source */
diff --git a/net/ipv4/fou_nl.h b/net/ipv4/fou_nl.h
index b7a68121ce6f..58b1e1ed4b3b 100644
--- a/net/ipv4/fou_nl.h
+++ b/net/ipv4/fou_nl.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: BSD-3-Clause */
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /* Do not edit directly, auto-generated from: */
 /*	Documentation/netlink/specs/fou.yaml */
 /* YNL-GEN kernel header */
diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux/netdev.h
index 588391447bfb..8c4e3e536c04 100644
--- a/tools/include/uapi/linux/netdev.h
+++ b/tools/include/uapi/linux/netdev.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause */
 /* Do not edit directly, auto-generated from: */
 /*	Documentation/netlink/specs/netdev.yaml */
 /* YNL-GEN uapi header */
diff --git a/tools/net/ynl/cli.py b/tools/net/ynl/cli.py
index db410b74d539..ffaa8038aa8c 100755
--- a/tools/net/ynl/cli.py
+++ b/tools/net/ynl/cli.py
@@ -1,5 +1,5 @@
 #!/usr/bin/env python3
-# SPDX-License-Identifier: BSD-3-Clause
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 
 import argparse
 import json
diff --git a/tools/net/ynl/lib/__init__.py b/tools/net/ynl/lib/__init__.py
index 3c73f59eabab..a2cb8b16d6f1 100644
--- a/tools/net/ynl/lib/__init__.py
+++ b/tools/net/ynl/lib/__init__.py
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: BSD-3-Clause
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 
 from .nlspec import SpecAttr, SpecAttrSet, SpecFamily, SpecOperation
 from .ynl import YnlFamily
diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index 9d394e50de23..0a2cfb5862aa 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: BSD-3-Clause
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 
 import collections
 import importlib
diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 1c7411ee04dc..a842adc8e87e 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: BSD-3-Clause
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 
 import functools
 import os
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 62f8f2c3c56c..c940ca834d3f 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -1,4 +1,5 @@
 #!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 
 import argparse
 import collections
@@ -2127,12 +2128,12 @@ _C_KW = {
 
     _, spec_kernel = find_kernel_root(args.spec)
     if args.mode == 'uapi':
-        cw.p('/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */')
+        cw.p('/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause */')
     else:
         if args.header:
-            cw.p('/* SPDX-License-Identifier: BSD-3-Clause */')
+            cw.p('/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */')
         else:
-            cw.p('// SPDX-License-Identifier: BSD-3-Clause')
+            cw.p('// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause')
     cw.p("/* Do not edit directly, auto-generated from: */")
     cw.p(f"/*\t{spec_kernel} */")
     cw.p(f"/* YNL-GEN {args.mode} {'header' if args.header else 'source'} */")
diff --git a/tools/net/ynl/ynl-regen.sh b/tools/net/ynl/ynl-regen.sh
index 43989ae48ed0..74f5de1c2399 100755
--- a/tools/net/ynl/ynl-regen.sh
+++ b/tools/net/ynl/ynl-regen.sh
@@ -1,5 +1,5 @@
 #!/bin/bash
-# SPDX-License-Identifier: BSD-3-Clause
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 
 TOOL=$(dirname $(realpath $0))/ynl-gen-c.py
 
-- 
2.39.2

