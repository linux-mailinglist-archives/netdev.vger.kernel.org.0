Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE66078E5A
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 16:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387586AbfG2OsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 10:48:08 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:48869 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfG2OsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 10:48:08 -0400
Received: from orion.localdomain ([77.4.29.213]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MbRbr-1iOymx226T-00boKg; Mon, 29 Jul 2019 16:48:02 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH] init: Kconfig: consistent indentions
Date:   Mon, 29 Jul 2019 16:48:01 +0200
Message-Id: <1564411681-28013-1-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K1:dW4jkDPZBxuRMIXPJtCRf30d71VoDDYo7pJonzBRhds3XJ3NQ0/
 MdKDkaU7Cb3UKfQvVQb+GrdO8G2227MyJ/hxfLUVoBBn+oljMAf3P+z4SJvy5/tYIb81HP6
 T3IY4/soZHeeP3NuiPoeObx8S3Ua5+lCjfqCdEgR7P1hdHcjweVX/kmcv7ki8fqqgH2B7nh
 p8hqtdGj2GrFflSMRI+5A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:dEwgoYK4RAk=:hU3b8BNd54os3Dqti7kG53
 gdOmeypCBkqVc2/6sVBYX8zVIXtPVyWZzaHvwn6vcb/zDxxuTxTB9sTHhWfmnTqyVR2MLacBY
 W48c8Axh99S7YVgklvkMddulPFdZ4nZ6UG03cNZLjxcjOtuulWx1X/s6rW/aEvZsCVYiuQU3W
 5sp0Io4MEFdq+rGoUXJcbvhi/o3hdokHLOfijA30syNoomUZnjZSMVrnXFaW4LQ6pjwJp9vda
 it7AQ2eRI+5wD+npitNjdD2aw0loTwPJx/6TltpcC3E4xL4m9GKfBnlU401Kq6N2nFkWa/1xt
 EdsQyvNiUMl5uDvfiUZZWpf6z8dKkvWey9DlXW6jAk/SPZroLzbJm7m4KLvvrANC0PX7lNeCO
 +QhoBz/j0dT3Y5sNrvf8s7DTsqgrbJ+Db026XJNqFuIXp7wM0RnzpBMt7GykoiN6jcQi4cHux
 gmgXBp/PaqBEZn+LpLBjQjplM9JJl/MAcsUbBV3zopNoIco1q+WVH3AuHWGsI0ZuZa0uewhGf
 nkC+WiZv91W9CNIJTHtTHrouB1Jvo0fUenDx/V98TC0W82usJalGKDH5zWK91FRDplaGIG8mg
 l0Ypy7lqnzJzT/l+6hg2Jik3EtxtiR1eQCGNF4+FxJZ3xxS+TsKuoo1pwVeIT/El+19Izow33
 Xy0YsPwK5ZHKk0NzUYSh9GIfqfgMlD9emvTR3ky9u79KA3Zx9aofaiz76XlsTidX1WSme6ovw
 +vLrF6iqOMV1EUUg9CuruA1jM9hsWQYccy27ZA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enrico Weigelt <info@metux.net>

Just make the indentions consistent with the rest of the file,
as well as most other Kconfig files.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 init/Kconfig | 54 +++++++++++++++++++++++++++---------------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index bd7d650..1a589c6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -161,13 +161,13 @@ config LOCALVERSION_AUTO
 	  which is done within the script "scripts/setlocalversion".)
 
 config BUILD_SALT
-       string "Build ID Salt"
-       default ""
-       help
-          The build ID is used to link binaries and their debug info. Setting
-          this option will use the value in the calculation of the build id.
-          This is mostly useful for distributions which want to ensure the
-          build is unique between builds. It's safe to leave the default.
+	string "Build ID Salt"
+	default ""
+	help
+	  The build ID is used to link binaries and their debug info. Setting
+	  this option will use the value in the calculation of the build id.
+	  This is mostly useful for distributions which want to ensure the
+	  build is unique between builds. It's safe to leave the default.
 
 config HAVE_KERNEL_GZIP
 	bool
@@ -1294,9 +1294,9 @@ menuconfig EXPERT
 	select DEBUG_KERNEL
 	help
 	  This option allows certain base kernel options and settings
-          to be disabled or tweaked. This is for specialized
-          environments which can tolerate a "non-standard" kernel.
-          Only use this if you really know what you are doing.
+	  to be disabled or tweaked. This is for specialized
+	  environments which can tolerate a "non-standard" kernel.
+	  Only use this if you really know what you are doing.
 
 config UID16
 	bool "Enable 16-bit UID system calls" if EXPERT
@@ -1406,11 +1406,11 @@ config BUG
 	bool "BUG() support" if EXPERT
 	default y
 	help
-          Disabling this option eliminates support for BUG and WARN, reducing
-          the size of your kernel image and potentially quietly ignoring
-          numerous fatal conditions. You should only consider disabling this
-          option for embedded systems with no facilities for reporting errors.
-          Just say Y.
+	  Disabling this option eliminates support for BUG and WARN, reducing
+	  the size of your kernel image and potentially quietly ignoring
+	  numerous fatal conditions. You should only consider disabling this
+	  option for embedded systems with no facilities for reporting errors.
+	  Just say Y.
 
 config ELF_CORE
 	depends on COREDUMP
@@ -1426,8 +1426,8 @@ config PCSPKR_PLATFORM
 	select I8253_LOCK
 	default y
 	help
-          This option allows to disable the internal PC-Speaker
-          support, saving some memory.
+	  This option allows to disable the internal PC-Speaker
+	  support, saving some memory.
 
 config BASE_FULL
 	default y
@@ -1555,18 +1555,18 @@ config KALLSYMS_ALL
 	bool "Include all symbols in kallsyms"
 	depends on DEBUG_KERNEL && KALLSYMS
 	help
-	   Normally kallsyms only contains the symbols of functions for nicer
-	   OOPS messages and backtraces (i.e., symbols from the text and inittext
-	   sections). This is sufficient for most cases. And only in very rare
-	   cases (e.g., when a debugger is used) all symbols are required (e.g.,
-	   names of variables from the data sections, etc).
+	  Normally kallsyms only contains the symbols of functions for nicer
+	  OOPS messages and backtraces (i.e., symbols from the text and inittext
+	  sections). This is sufficient for most cases. And only in very rare
+	  cases (e.g., when a debugger is used) all symbols are required (e.g.,
+	  names of variables from the data sections, etc).
 
-	   This option makes sure that all symbols are loaded into the kernel
-	   image (i.e., symbols from all sections) in cost of increased kernel
-	   size (depending on the kernel configuration, it may be 300KiB or
-	   something like this).
+	  This option makes sure that all symbols are loaded into the kernel
+	  image (i.e., symbols from all sections) in cost of increased kernel
+	  size (depending on the kernel configuration, it may be 300KiB or
+	  something like this).
 
-	   Say N unless you really need all symbols.
+	  Say N unless you really need all symbols.
 
 config KALLSYMS_ABSOLUTE_PERCPU
 	bool
-- 
1.9.1

