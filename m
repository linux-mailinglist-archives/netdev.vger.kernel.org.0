Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C16159A9C
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 14:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfF1MV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 08:21:57 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58952 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfF1MUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 08:20:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6o6fXEYlR1jiA8HbNJ2w7XjNfev4ko3TxhPzWGy+zLg=; b=A7bNNPpgneE5Oxg18j4PJsnwqV
        NTH44hHUNtLwlngKw1Em3+b1C6A8UbLQLgB/bEq3RwAIkqkqd7vRmcRkMJSDK/kE+aaJLVuhxhTUY
        VWEDAnIM0r+NnDO+mOWS7QQEfjJPwc1Zpt5OnscU5vML+nIyAeJGMAHGk2sGdpGTT2XIvtavSsdDV
        2uWjRFZYRiq7b+QJNoo2OcFcb+arrAR47m3aA8f6ZPwhxQGWTqnEJelYCI6wg1HZITtH46ILV1sbN
        cZoSBLuvU8EweJpJWqoW865OXSJPPUxb4Kyfimis9mD1ni4f40Hiv9CtWMcSaEZANINCMln5bCzHl
        rpl7O3CA==;
Received: from [186.213.242.156] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hgprx-0000A4-75; Fri, 28 Jun 2019 12:20:46 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hgpru-00059x-53; Fri, 28 Jun 2019 09:20:42 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 39/43] docs: sysctl: convert to ReST
Date:   Fri, 28 Jun 2019 09:20:35 -0300
Message-Id: <24b969641a02e9318d7695122d2c0b8a822f1d6f.1561723980.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1561723979.git.mchehab+samsung@kernel.org>
References: <cover.1561723979.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the /proc/sys/ documentation files to ReST, using the
README file as a template for an index.rst, adding the other
files there via TOC markup.

Despite being written on different times with different
styles, try to make them somewhat coherent with a similar
look and feel, ensuring that they'll look nice as both
raw text file and as via the html output produced by the
Sphinx build system.

At its new index.rst, let's add a :orphan: while this is not linked to
the main index.rst file, in order to avoid build warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |   2 +-
 Documentation/admin-guide/mm/index.rst        |   2 +-
 Documentation/admin-guide/mm/ksm.rst          |   2 +-
 Documentation/core-api/printk-formats.rst     |   2 +-
 Documentation/networking/ip-sysctl.txt        |   2 +-
 Documentation/sysctl/abi.rst                  |  67 ++++
 Documentation/sysctl/abi.txt                  |  54 ---
 Documentation/sysctl/{fs.txt => fs.rst}       | 142 +++----
 Documentation/sysctl/{README => index.rst}    |  36 +-
 .../sysctl/{kernel.txt => kernel.rst}         | 372 ++++++++++--------
 Documentation/sysctl/{net.txt => net.rst}     | 141 ++++---
 .../sysctl/{sunrpc.txt => sunrpc.rst}         |  13 +-
 Documentation/sysctl/{user.txt => user.rst}   |  32 +-
 Documentation/sysctl/{vm.txt => vm.rst}       | 258 ++++++------
 Documentation/vm/unevictable-lru.rst          |   2 +-
 kernel/panic.c                                |   2 +-
 mm/swap.c                                     |   2 +-
 17 files changed, 650 insertions(+), 481 deletions(-)
 create mode 100644 Documentation/sysctl/abi.rst
 delete mode 100644 Documentation/sysctl/abi.txt
 rename Documentation/sysctl/{fs.txt => fs.rst} (77%)
 rename Documentation/sysctl/{README => index.rst} (78%)
 rename Documentation/sysctl/{kernel.txt => kernel.rst} (79%)
 rename Documentation/sysctl/{net.txt => net.rst} (85%)
 rename Documentation/sysctl/{sunrpc.txt => sunrpc.rst} (62%)
 rename Documentation/sysctl/{user.txt => user.rst} (77%)
 rename Documentation/sysctl/{vm.txt => vm.rst} (85%)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 7ed94527a4a0..61abadd70a86 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3170,7 +3170,7 @@
 	numa_zonelist_order= [KNL, BOOT] Select zonelist order for NUMA.
 			'node', 'default' can be specified
 			This can be set from sysctl after boot.
-			See Documentation/sysctl/vm.txt for details.
+			See Documentation/sysctl/vm.rst for details.
 
 	ohci1394_dma=early	[HW] enable debugging via the ohci1394 driver.
 			See Documentation/debugging-via-ohci1394.txt for more
diff --git a/Documentation/admin-guide/mm/index.rst b/Documentation/admin-guide/mm/index.rst
index ddf8d8d33377..f5e92f33f96e 100644
--- a/Documentation/admin-guide/mm/index.rst
+++ b/Documentation/admin-guide/mm/index.rst
@@ -11,7 +11,7 @@ processes address space and many other cool things.
 Linux memory management is a complex system with many configurable
 settings. Most of these settings are available via ``/proc``
 filesystem and can be quired and adjusted using ``sysctl``. These APIs
-are described in Documentation/sysctl/vm.txt and in `man 5 proc`_.
+are described in Documentation/sysctl/vm.rst and in `man 5 proc`_.
 
 .. _man 5 proc: http://man7.org/linux/man-pages/man5/proc.5.html
 
diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
index 9303786632d1..7b2b8767c0b4 100644
--- a/Documentation/admin-guide/mm/ksm.rst
+++ b/Documentation/admin-guide/mm/ksm.rst
@@ -59,7 +59,7 @@ MADV_UNMERGEABLE is applied to a range which was never MADV_MERGEABLE.
 
 If a region of memory must be split into at least one new MADV_MERGEABLE
 or MADV_UNMERGEABLE region, the madvise may return ENOMEM if the process
-will exceed ``vm.max_map_count`` (see Documentation/sysctl/vm.txt).
+will exceed ``vm.max_map_count`` (see Documentation/sysctl/vm.rst).
 
 Like other madvise calls, they are intended for use on mapped areas of
 the user address space: they will report ENOMEM if the specified range
diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
index 75d2bbe9813f..1d8e748f909f 100644
--- a/Documentation/core-api/printk-formats.rst
+++ b/Documentation/core-api/printk-formats.rst
@@ -119,7 +119,7 @@ Kernel Pointers
 
 For printing kernel pointers which should be hidden from unprivileged
 users. The behaviour of %pK depends on the kptr_restrict sysctl - see
-Documentation/sysctl/kernel.txt for more details.
+Documentation/sysctl/kernel.rst for more details.
 
 Unmodified Addresses
 --------------------
diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index e0d8a96e2c67..0f8e1c544e1e 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -2284,7 +2284,7 @@ addr_scope_policy - INTEGER
 
 
 /proc/sys/net/core/*
-	Please see: Documentation/sysctl/net.txt for descriptions of these entries.
+	Please see: Documentation/sysctl/net.rst for descriptions of these entries.
 
 
 /proc/sys/net/unix/*
diff --git a/Documentation/sysctl/abi.rst b/Documentation/sysctl/abi.rst
new file mode 100644
index 000000000000..599bcde7f0b7
--- /dev/null
+++ b/Documentation/sysctl/abi.rst
@@ -0,0 +1,67 @@
+================================
+Documentation for /proc/sys/abi/
+================================
+
+kernel version 2.6.0.test2
+
+Copyright (c) 2003,  Fabian Frederick <ffrederick@users.sourceforge.net>
+
+For general info: index.rst.
+
+------------------------------------------------------------------------------
+
+This path is binary emulation relevant aka personality types aka abi.
+When a process is executed, it's linked to an exec_domain whose
+personality is defined using values available from /proc/sys/abi.
+You can find further details about abi in include/linux/personality.h.
+
+Here are the files featuring in 2.6 kernel:
+
+- defhandler_coff
+- defhandler_elf
+- defhandler_lcall7
+- defhandler_libcso
+- fake_utsname
+- trace
+
+defhandler_coff
+---------------
+
+defined value:
+	PER_SCOSVR3::
+
+		0x0003 | STICKY_TIMEOUTS | WHOLE_SECONDS | SHORT_INODE
+
+defhandler_elf
+--------------
+
+defined value:
+	PER_LINUX::
+
+		0
+
+defhandler_lcall7
+-----------------
+
+defined value :
+	PER_SVR4::
+
+		0x0001 | STICKY_TIMEOUTS | MMAP_PAGE_ZERO,
+
+defhandler_libsco
+-----------------
+
+defined value:
+	PER_SVR4::
+
+		0x0001 | STICKY_TIMEOUTS | MMAP_PAGE_ZERO,
+
+fake_utsname
+------------
+
+Unused
+
+trace
+-----
+
+Unused
diff --git a/Documentation/sysctl/abi.txt b/Documentation/sysctl/abi.txt
deleted file mode 100644
index 63f4ebcf652c..000000000000
--- a/Documentation/sysctl/abi.txt
+++ /dev/null
@@ -1,54 +0,0 @@
-Documentation for /proc/sys/abi/* kernel version 2.6.0.test2
-	(c) 2003,  Fabian Frederick <ffrederick@users.sourceforge.net>
-
-For general info : README.
-
-==============================================================
-
-This path is binary emulation relevant aka personality types aka abi.
-When a process is executed, it's linked to an exec_domain whose
-personality is defined using values available from /proc/sys/abi.
-You can find further details about abi in include/linux/personality.h.
-
-Here are the files featuring in 2.6 kernel :
-
-- defhandler_coff
-- defhandler_elf
-- defhandler_lcall7
-- defhandler_libcso
-- fake_utsname
-- trace
-
-===========================================================
-defhandler_coff:
-defined value :
-PER_SCOSVR3
-0x0003 | STICKY_TIMEOUTS | WHOLE_SECONDS | SHORT_INODE
-
-===========================================================
-defhandler_elf:
-defined value :
-PER_LINUX
-0
-
-===========================================================
-defhandler_lcall7:
-defined value :
-PER_SVR4
-0x0001 | STICKY_TIMEOUTS | MMAP_PAGE_ZERO,
-
-===========================================================
-defhandler_libsco:
-defined value:
-PER_SVR4
-0x0001 | STICKY_TIMEOUTS | MMAP_PAGE_ZERO,
-
-===========================================================
-fake_utsname:
-Unused
-
-===========================================================
-trace:
-Unused
-
-===========================================================
diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.rst
similarity index 77%
rename from Documentation/sysctl/fs.txt
rename to Documentation/sysctl/fs.rst
index ebc679bcb2dc..2a45119e3331 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.rst
@@ -1,10 +1,16 @@
-Documentation for /proc/sys/fs/*	kernel version 2.2.10
-	(c) 1998, 1999,  Rik van Riel <riel@nl.linux.org>
-	(c) 2009,        Shen Feng<shen@cn.fujitsu.com>
+===============================
+Documentation for /proc/sys/fs/
+===============================
 
-For general info and legal blurb, please look in README.
+kernel version 2.2.10
 
-==============================================================
+Copyright (c) 1998, 1999,  Rik van Riel <riel@nl.linux.org>
+
+Copyright (c) 2009,        Shen Feng<shen@cn.fujitsu.com>
+
+For general info and legal blurb, please look in intro.rst.
+
+------------------------------------------------------------------------------
 
 This file contains documentation for the sysctl files in
 /proc/sys/fs/ and is valid for Linux kernel version 2.2.
@@ -16,9 +22,10 @@ system, it is advisable to read both documentation and source
 before actually making adjustments.
 
 1. /proc/sys/fs
-----------------------------------------------------------
+===============
 
 Currently, these files are in /proc/sys/fs:
+
 - aio-max-nr
 - aio-nr
 - dentry-state
@@ -42,9 +49,9 @@ Currently, these files are in /proc/sys/fs:
 - super-max
 - super-nr
 
-==============================================================
 
-aio-nr & aio-max-nr:
+aio-nr & aio-max-nr
+-------------------
 
 aio-nr is the running total of the number of events specified on the
 io_setup system call for all currently active aio contexts.  If aio-nr
@@ -52,21 +59,20 @@ reaches aio-max-nr then io_setup will fail with EAGAIN.  Note that
 raising aio-max-nr does not result in the pre-allocation or re-sizing
 of any kernel data structures.
 
-==============================================================
 
-dentry-state:
+dentry-state
+------------
 
-From linux/include/linux/dcache.h:
---------------------------------------------------------------
-struct dentry_stat_t dentry_stat {
+From linux/include/linux/dcache.h::
+
+  struct dentry_stat_t dentry_stat {
         int nr_dentry;
         int nr_unused;
         int age_limit;         /* age in seconds */
         int want_pages;        /* pages requested by system */
         int nr_negative;       /* # of unused negative dentries */
         int dummy;             /* Reserved for future use */
-};
---------------------------------------------------------------
+  };
 
 Dentries are dynamically allocated and deallocated.
 
@@ -84,9 +90,9 @@ negative dentries which do not map to any files. Instead,
 they help speeding up rejection of non-existing files provided
 by the users.
 
-==============================================================
 
-dquot-max & dquot-nr:
+dquot-max & dquot-nr
+--------------------
 
 The file dquot-max shows the maximum number of cached disk
 quota entries.
@@ -98,9 +104,9 @@ If the number of free cached disk quotas is very low and
 you have some awesome number of simultaneous system users,
 you might want to raise the limit.
 
-==============================================================
 
-file-max & file-nr:
+file-max & file-nr
+------------------
 
 The value in file-max denotes the maximum number of file-
 handles that the Linux kernel will allocate. When you get lots
@@ -119,18 +125,19 @@ used file handles.
 Attempts to allocate more file descriptors than file-max are
 reported with printk, look for "VFS: file-max limit <number>
 reached".
-==============================================================
 
-nr_open:
+
+nr_open
+-------
 
 This denotes the maximum number of file-handles a process can
 allocate. Default value is 1024*1024 (1048576) which should be
 enough for most machines. Actual limit depends on RLIMIT_NOFILE
 resource limit.
 
-==============================================================
 
-inode-max, inode-nr & inode-state:
+inode-max, inode-nr & inode-state
+---------------------------------
 
 As with file handles, the kernel allocates the inode structures
 dynamically, but can't free them yet.
@@ -157,9 +164,9 @@ preshrink is nonzero when the nr_inodes > inode-max and the
 system needs to prune the inode list instead of allocating
 more.
 
-==============================================================
 
-overflowgid & overflowuid:
+overflowgid & overflowuid
+-------------------------
 
 Some filesystems only support 16-bit UIDs and GIDs, although in Linux
 UIDs and GIDs are 32 bits. When one of these filesystems is mounted
@@ -169,18 +176,18 @@ to a fixed value before being written to disk.
 These sysctls allow you to change the value of the fixed UID and GID.
 The default is 65534.
 
-==============================================================
 
-pipe-user-pages-hard:
+pipe-user-pages-hard
+--------------------
 
 Maximum total number of pages a non-privileged user may allocate for pipes.
 Once this limit is reached, no new pipes may be allocated until usage goes
 below the limit again. When set to 0, no limit is applied, which is the default
 setting.
 
-==============================================================
 
-pipe-user-pages-soft:
+pipe-user-pages-soft
+--------------------
 
 Maximum total number of pages a non-privileged user may allocate for pipes
 before the pipe size gets limited to a single page. Once this limit is reached,
@@ -190,9 +197,9 @@ denied until usage goes below the limit again. The default value allows to
 allocate up to 1024 pipes at their default size. When set to 0, no limit is
 applied.
 
-==============================================================
 
-protected_fifos:
+protected_fifos
+---------------
 
 The intent of this protection is to avoid unintentional writes to
 an attacker-controlled FIFO, where a program expected to create a regular
@@ -208,9 +215,9 @@ When set to "2" it also applies to group writable sticky directories.
 
 This protection is based on the restrictions in Openwall.
 
-==============================================================
 
-protected_hardlinks:
+protected_hardlinks
+--------------------
 
 A long-standing class of security issues is the hardlink-based
 time-of-check-time-of-use race, most commonly seen in world-writable
@@ -228,9 +235,9 @@ already own the source file, or do not have read/write access to it.
 
 This protection is based on the restrictions in Openwall and grsecurity.
 
-==============================================================
 
-protected_regular:
+protected_regular
+-----------------
 
 This protection is similar to protected_fifos, but it
 avoids writes to an attacker-controlled regular file, where a program
@@ -244,9 +251,9 @@ owned by the owner of the directory.
 
 When set to "2" it also applies to group writable sticky directories.
 
-==============================================================
 
-protected_symlinks:
+protected_symlinks
+------------------
 
 A long-standing class of security issues is the symlink-based
 time-of-check-time-of-use race, most commonly seen in world-writable
@@ -264,34 +271,38 @@ follower match, or when the directory owner matches the symlink's owner.
 
 This protection is based on the restrictions in Openwall and grsecurity.
 
-==============================================================
 
 suid_dumpable:
+--------------
 
 This value can be used to query and set the core dump mode for setuid
 or otherwise protected/tainted binaries. The modes are
 
-0 - (default) - traditional behaviour. Any process which has changed
-	privilege levels or is execute only will not be dumped.
-1 - (debug) - all processes dump core when possible. The core dump is
-	owned by the current user and no security is applied. This is
-	intended for system debugging situations only. Ptrace is unchecked.
-	This is insecure as it allows regular users to examine the memory
-	contents of privileged processes.
-2 - (suidsafe) - any binary which normally would not be dumped is dumped
-	anyway, but only if the "core_pattern" kernel sysctl is set to
-	either a pipe handler or a fully qualified path. (For more details
-	on this limitation, see CVE-2006-2451.) This mode is appropriate
-	when administrators are attempting to debug problems in a normal
-	environment, and either have a core dump pipe handler that knows
-	to treat privileged core dumps with care, or specific directory
-	defined for catching core dumps. If a core dump happens without
-	a pipe handler or fully qualifid path, a message will be emitted
-	to syslog warning about the lack of a correct setting.
+=   ==========  ===============================================================
+0   (default)	traditional behaviour. Any process which has changed
+		privilege levels or is execute only will not be dumped.
+1   (debug)	all processes dump core when possible. The core dump is
+		owned by the current user and no security is applied. This is
+		intended for system debugging situations only.
+		Ptrace is unchecked.
+		This is insecure as it allows regular users to examine the
+		memory contents of privileged processes.
+2   (suidsafe)	any binary which normally would not be dumped is dumped
+		anyway, but only if the "core_pattern" kernel sysctl is set to
+		either a pipe handler or a fully qualified path. (For more
+		details on this limitation, see CVE-2006-2451.) This mode is
+		appropriate when administrators are attempting to debug
+		problems in a normal environment, and either have a core dump
+		pipe handler that knows to treat privileged core dumps with
+		care, or specific directory defined for catching core dumps.
+		If a core dump happens without a pipe handler or fully
+		qualified path, a message will be emitted to syslog warning
+		about the lack of a correct setting.
+=   ==========  ===============================================================
 
-==============================================================
 
-super-max & super-nr:
+super-max & super-nr
+--------------------
 
 These numbers control the maximum number of superblocks, and
 thus the maximum number of mounted filesystems the kernel
@@ -299,33 +310,33 @@ can have. You only need to increase super-max if you need to
 mount more filesystems than the current value in super-max
 allows you to.
 
-==============================================================
 
-aio-nr & aio-max-nr:
+aio-nr & aio-max-nr
+-------------------
 
 aio-nr shows the current system-wide number of asynchronous io
 requests.  aio-max-nr allows you to change the maximum value
 aio-nr can grow to.
 
-==============================================================
 
-mount-max:
+mount-max
+---------
 
 This denotes the maximum number of mounts that may exist
 in a mount namespace.
 
-==============================================================
 
 
 2. /proc/sys/fs/binfmt_misc
-----------------------------------------------------------
+===========================
 
 Documentation for the files in /proc/sys/fs/binfmt_misc is
 in Documentation/admin-guide/binfmt-misc.rst.
 
 
 3. /proc/sys/fs/mqueue - POSIX message queues filesystem
-----------------------------------------------------------
+========================================================
+
 
 The "mqueue"  filesystem provides  the necessary kernel features to enable the
 creation of a  user space  library that  implements  the  POSIX message queues
@@ -356,7 +367,7 @@ the default message size value if attr parameter of mq_open(2) is NULL. If it
 exceed msgsize_max, the default value is initialized msgsize_max.
 
 4. /proc/sys/fs/epoll - Configuration options for the epoll interface
---------------------------------------------------------
+=====================================================================
 
 This directory contains configuration options for the epoll(7) interface.
 
@@ -371,4 +382,3 @@ Each "watch" costs roughly 90 bytes on a 32bit kernel, and roughly 160 bytes
 on a 64bit one.
 The current default value for  max_user_watches  is the 1/32 of the available
 low memory, divided for the "watch" cost in bytes.
-
diff --git a/Documentation/sysctl/README b/Documentation/sysctl/index.rst
similarity index 78%
rename from Documentation/sysctl/README
rename to Documentation/sysctl/index.rst
index d5f24ab0ecc3..efbcde8c1c9c 100644
--- a/Documentation/sysctl/README
+++ b/Documentation/sysctl/index.rst
@@ -1,5 +1,12 @@
-Documentation for /proc/sys/		kernel version 2.2.10
-	(c) 1998, 1999,  Rik van Riel <riel@nl.linux.org>
+:orphan:
+
+===========================
+Documentation for /proc/sys
+===========================
+
+Copyright (c) 1998, 1999,  Rik van Riel <riel@nl.linux.org>
+
+------------------------------------------------------------------------------
 
 'Why', I hear you ask, 'would anyone even _want_ documentation
 for them sysctl files? If anybody really needs it, it's all in
@@ -12,11 +19,12 @@ have the time or knowledge to read the source code.
 Furthermore, the programmers who built sysctl have built it to
 be actually used, not just for the fun of programming it :-)
 
-==============================================================
+------------------------------------------------------------------------------
 
 Legal blurb:
 
 As usual, there are two main things to consider:
+
 1. you get what you pay for
 2. it's free
 
@@ -35,15 +43,17 @@ stories to: <riel@nl.linux.org>
 
 Rik van Riel.
 
-==============================================================
+--------------------------------------------------------------
 
-Introduction:
+Introduction
+============
 
 Sysctl is a means of configuring certain aspects of the kernel
 at run-time, and the /proc/sys/ directory is there so that you
 don't even need special tools to do it!
 In fact, there are only four things needed to use these config
 facilities:
+
 - a running Linux system
 - root access
 - common sense (this is especially hard to come by these days)
@@ -54,7 +64,9 @@ several (arch-dependent?) subdirs. Each subdir is mainly about
 one part of the kernel, so you can do configuration on a piece
 by piece basis, or just some 'thematic frobbing'.
 
-The subdirs are about:
+This documentation is about:
+
+=============== ===============================================================
 abi/		execution domains & personalities
 debug/		<empty>
 dev/		device specific information (eg dev/cdrom/info)
@@ -70,7 +82,19 @@ sunrpc/		SUN Remote Procedure Call (NFS)
 vm/		memory management tuning
 		buffer and cache management
 user/		Per user per user namespace limits
+=============== ===============================================================
 
 These are the subdirs I have on my system. There might be more
 or other subdirs in another setup. If you see another dir, I'd
 really like to hear about it :-)
+
+.. toctree::
+   :maxdepth: 1
+
+   abi
+   fs
+   kernel
+   net
+   sunrpc
+   user
+   vm
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.rst
similarity index 79%
rename from Documentation/sysctl/kernel.txt
rename to Documentation/sysctl/kernel.rst
index 1b2fe17cd2fa..a0c1d4ce403a 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.rst
@@ -1,10 +1,16 @@
-Documentation for /proc/sys/kernel/*	kernel version 2.2.10
-	(c) 1998, 1999,  Rik van Riel <riel@nl.linux.org>
-	(c) 2009,        Shen Feng<shen@cn.fujitsu.com>
+===================================
+Documentation for /proc/sys/kernel/
+===================================
 
-For general info and legal blurb, please look in README.
+kernel version 2.2.10
 
-==============================================================
+Copyright (c) 1998, 1999,  Rik van Riel <riel@nl.linux.org>
+
+Copyright (c) 2009,        Shen Feng<shen@cn.fujitsu.com>
+
+For general info and legal blurb, please look in index.rst.
+
+------------------------------------------------------------------------------
 
 This file contains documentation for the sysctl files in
 /proc/sys/kernel/ and is valid for Linux kernel version 2.2.
@@ -101,9 +107,9 @@ show up in /proc/sys/kernel:
 - watchdog_thresh
 - version
 
-==============================================================
 
 acct:
+=====
 
 highwater lowwater frequency
 
@@ -118,18 +124,18 @@ That is, suspend accounting if there left <= 2% free; resume it
 if we got >=4%; consider information about amount of free space
 valid for 30 seconds.
 
-==============================================================
 
 acpi_video_flags:
+=================
 
 flags
 
 See Doc*/kernel/power/video.txt, it allows mode of video boot to be
 set during run time.
 
-==============================================================
 
 auto_msgmni:
+============
 
 This variable has no effect and may be removed in future kernel
 releases. Reading it always returns 0.
@@ -139,9 +145,8 @@ Echoing "1" into this file enabled msgmni automatic recomputing.
 Echoing "0" turned it off. auto_msgmni default value was 1.
 
 
-==============================================================
-
 bootloader_type:
+================
 
 x86 bootloader identification
 
@@ -156,9 +161,9 @@ the value 340 = 0x154.
 See the type_of_loader and ext_loader_type fields in
 Documentation/x86/boot.rst for additional information.
 
-==============================================================
 
 bootloader_version:
+===================
 
 x86 bootloader version
 
@@ -168,27 +173,31 @@ file will contain the value 564 = 0x234.
 See the type_of_loader and ext_loader_ver fields in
 Documentation/x86/boot.rst for additional information.
 
-==============================================================
 
-cap_last_cap
+cap_last_cap:
+=============
 
 Highest valid capability of the running kernel.  Exports
 CAP_LAST_CAP from the kernel.
 
-==============================================================
 
 core_pattern:
+=============
 
 core_pattern is used to specify a core dumpfile pattern name.
-. max length 127 characters; default value is "core"
-. core_pattern is used as a pattern template for the output filename;
+
+* max length 127 characters; default value is "core"
+* core_pattern is used as a pattern template for the output filename;
   certain string patterns (beginning with '%') are substituted with
   their actual values.
-. backward compatibility with core_uses_pid:
+* backward compatibility with core_uses_pid:
+
 	If core_pattern does not include "%p" (default does not)
 	and core_uses_pid is set, then .PID will be appended to
 	the filename.
-. corename format specifiers:
+
+* corename format specifiers::
+
 	%<NUL>	'%' is dropped
 	%%	output one '%'
 	%p	pid
@@ -205,13 +214,14 @@ core_pattern is used to specify a core dumpfile pattern name.
 	%e	executable filename (may be shortened)
 	%E	executable path
 	%<OTHER> both are dropped
-. If the first character of the pattern is a '|', the kernel will treat
+
+* If the first character of the pattern is a '|', the kernel will treat
   the rest of the pattern as a command to run.  The core dump will be
   written to the standard input of that program instead of to a file.
 
-==============================================================
 
 core_pipe_limit:
+================
 
 This sysctl is only applicable when core_pattern is configured to pipe
 core files to a user space helper (when the first character of
@@ -232,9 +242,9 @@ parallel, but that no waiting will take place (i.e. the collecting
 process is not guaranteed access to /proc/<crashing pid>/).  This
 value defaults to 0.
 
-==============================================================
 
 core_uses_pid:
+==============
 
 The default coredump filename is "core".  By setting
 core_uses_pid to 1, the coredump filename becomes core.PID.
@@ -242,9 +252,9 @@ If core_pattern does not include "%p" (default does not)
 and core_uses_pid is set, then .PID will be appended to
 the filename.
 
-==============================================================
 
 ctrl-alt-del:
+=============
 
 When the value in this file is 0, ctrl-alt-del is trapped and
 sent to the init(1) program to handle a graceful restart.
@@ -252,14 +262,15 @@ When, however, the value is > 0, Linux's reaction to a Vulcan
 Nerve Pinch (tm) will be an immediate reboot, without even
 syncing its dirty buffers.
 
-Note: when a program (like dosemu) has the keyboard in 'raw'
-mode, the ctrl-alt-del is intercepted by the program before it
-ever reaches the kernel tty layer, and it's up to the program
-to decide what to do with it.
+Note:
+  when a program (like dosemu) has the keyboard in 'raw'
+  mode, the ctrl-alt-del is intercepted by the program before it
+  ever reaches the kernel tty layer, and it's up to the program
+  to decide what to do with it.
 
-==============================================================
 
 dmesg_restrict:
+===============
 
 This toggle indicates whether unprivileged users are prevented
 from using dmesg(8) to view messages from the kernel's log buffer.
@@ -270,18 +281,21 @@ dmesg(8).
 The kernel config option CONFIG_SECURITY_DMESG_RESTRICT sets the
 default value of dmesg_restrict.
 
-==============================================================
 
 domainname & hostname:
+======================
 
 These files can be used to set the NIS/YP domainname and the
 hostname of your box in exactly the same way as the commands
-domainname and hostname, i.e.:
-# echo "darkstar" > /proc/sys/kernel/hostname
-# echo "mydomain" > /proc/sys/kernel/domainname
-has the same effect as
-# hostname "darkstar"
-# domainname "mydomain"
+domainname and hostname, i.e.::
+
+	# echo "darkstar" > /proc/sys/kernel/hostname
+	# echo "mydomain" > /proc/sys/kernel/domainname
+
+has the same effect as::
+
+	# hostname "darkstar"
+	# domainname "mydomain"
 
 Note, however, that the classic darkstar.frop.org has the
 hostname "darkstar" and DNS (Internet Domain Name Server)
@@ -290,8 +304,9 @@ Information Service) or YP (Yellow Pages) domainname. These two
 domain names are in general different. For a detailed discussion
 see the hostname(1) man page.
 
-==============================================================
+
 hardlockup_all_cpu_backtrace:
+=============================
 
 This value controls the hard lockup detector behavior when a hard
 lockup condition is detected as to whether or not to gather further
@@ -301,9 +316,10 @@ will be initiated.
 0: do nothing. This is the default behavior.
 
 1: on detection capture more debug information.
-==============================================================
+
 
 hardlockup_panic:
+=================
 
 This parameter can be used to control whether the kernel panics
 when a hard lockup is detected.
@@ -314,16 +330,16 @@ when a hard lockup is detected.
 See Documentation/lockup-watchdogs.txt for more information.  This can
 also be set using the nmi_watchdog kernel parameter.
 
-==============================================================
 
 hotplug:
+========
 
 Path for the hotplug policy agent.
 Default value is "/sbin/hotplug".
 
-==============================================================
 
 hung_task_panic:
+================
 
 Controls the kernel's behavior when a hung task is detected.
 This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
@@ -332,27 +348,28 @@ This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
 
 1: panic immediately.
 
-==============================================================
 
 hung_task_check_count:
+======================
 
 The upper bound on the number of tasks that are checked.
 This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
 
-==============================================================
 
 hung_task_timeout_secs:
+=======================
 
 When a task in D state did not get scheduled
 for more than this value report a warning.
 This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
 
 0: means infinite timeout - no checking done.
+
 Possible values to set are in range {0..LONG_MAX/HZ}.
 
-==============================================================
 
 hung_task_check_interval_secs:
+==============================
 
 Hung task check interval. If hung task checking is enabled
 (see hung_task_timeout_secs), the check is done every
@@ -362,9 +379,9 @@ This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
 0 (default): means use hung_task_timeout_secs as checking interval.
 Possible values to set are in range {0..LONG_MAX/HZ}.
 
-==============================================================
 
 hung_task_warnings:
+===================
 
 The maximum number of warnings to report. During a check interval
 if a hung task is detected, this value is decreased by 1.
@@ -373,9 +390,9 @@ This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
 
 -1: report an infinite number of warnings.
 
-==============================================================
 
 hyperv_record_panic_msg:
+========================
 
 Controls whether the panic kmsg data should be reported to Hyper-V.
 
@@ -383,9 +400,9 @@ Controls whether the panic kmsg data should be reported to Hyper-V.
 
 1: report the panic kmsg data. This is the default behavior.
 
-==============================================================
 
 kexec_load_disabled:
+====================
 
 A toggle indicating if the kexec_load syscall has been disabled. This
 value defaults to 0 (false: kexec_load enabled), but can be set to 1
@@ -395,9 +412,9 @@ loaded before disabling the syscall, allowing a system to set up (and
 later use) an image without it being altered. Generally used together
 with the "modules_disabled" sysctl.
 
-==============================================================
 
 kptr_restrict:
+==============
 
 This toggle indicates whether restrictions are placed on
 exposing kernel addresses via /proc and other interfaces.
@@ -420,16 +437,16 @@ values to unprivileged users is a concern.
 When kptr_restrict is set to (2), kernel pointers printed using
 %pK will be replaced with 0's regardless of privileges.
 
-==============================================================
 
 l2cr: (PPC only)
+================
 
 This flag controls the L2 cache of G3 processor boards. If
 0, the cache is disabled. Enabled if nonzero.
 
-==============================================================
 
 modules_disabled:
+=================
 
 A toggle value indicating if modules are allowed to be loaded
 in an otherwise modular kernel.  This toggle defaults to off
@@ -437,9 +454,9 @@ in an otherwise modular kernel.  This toggle defaults to off
 neither loaded nor unloaded, and the toggle cannot be set back
 to false.  Generally used with the "kexec_load_disabled" toggle.
 
-==============================================================
 
 msg_next_id, sem_next_id, and shm_next_id:
+==========================================
 
 These three toggles allows to specify desired id for next allocated IPC
 object: message, semaphore or shared memory respectively.
@@ -448,21 +465,22 @@ By default they are equal to -1, which means generic allocation logic.
 Possible values to set are in range {0..INT_MAX}.
 
 Notes:
-1) kernel doesn't guarantee, that new object will have desired id. So,
-it's up to userspace, how to handle an object with "wrong" id.
-2) Toggle with non-default value will be set back to -1 by kernel after
-successful IPC object allocation. If an IPC object allocation syscall
-fails, it is undefined if the value remains unmodified or is reset to -1.
+  1) kernel doesn't guarantee, that new object will have desired id. So,
+     it's up to userspace, how to handle an object with "wrong" id.
+  2) Toggle with non-default value will be set back to -1 by kernel after
+     successful IPC object allocation. If an IPC object allocation syscall
+     fails, it is undefined if the value remains unmodified or is reset to -1.
 
-==============================================================
 
 nmi_watchdog:
+=============
 
 This parameter can be used to control the NMI watchdog
 (i.e. the hard lockup detector) on x86 systems.
 
-   0 - disable the hard lockup detector
-   1 - enable the hard lockup detector
+0 - disable the hard lockup detector
+
+1 - enable the hard lockup detector
 
 The hard lockup detector monitors each CPU for its ability to respond to
 timer interrupts. The mechanism utilizes CPU performance counter registers
@@ -470,15 +488,15 @@ that are programmed to generate Non-Maskable Interrupts (NMIs) periodically
 while a CPU is busy. Hence, the alternative name 'NMI watchdog'.
 
 The NMI watchdog is disabled by default if the kernel is running as a guest
-in a KVM virtual machine. This default can be overridden by adding
+in a KVM virtual machine. This default can be overridden by adding::
 
    nmi_watchdog=1
 
 to the guest kernel command line (see Documentation/admin-guide/kernel-parameters.rst).
 
-==============================================================
 
-numa_balancing
+numa_balancing:
+===============
 
 Enables/disables automatic page fault based NUMA memory
 balancing. Memory is moved automatically to nodes
@@ -500,10 +518,9 @@ faults may be controlled by the numa_balancing_scan_period_min_ms,
 numa_balancing_scan_delay_ms, numa_balancing_scan_period_max_ms,
 numa_balancing_scan_size_mb, and numa_balancing_settle_count sysctls.
 
-==============================================================
+numa_balancing_scan_period_min_ms, numa_balancing_scan_delay_ms, numa_balancing_scan_period_max_ms, numa_balancing_scan_size_mb
+===============================================================================================================================
 
-numa_balancing_scan_period_min_ms, numa_balancing_scan_delay_ms,
-numa_balancing_scan_period_max_ms, numa_balancing_scan_size_mb
 
 Automatic NUMA balancing scans tasks address space and unmaps pages to
 detect if pages are properly placed or if the data should be migrated to a
@@ -539,16 +556,18 @@ rate for each task.
 numa_balancing_scan_size_mb is how many megabytes worth of pages are
 scanned for a given scan.
 
-==============================================================
 
 osrelease, ostype & version:
+============================
 
-# cat osrelease
-2.1.88
-# cat ostype
-Linux
-# cat version
-#5 Wed Feb 25 21:49:24 MET 1998
+::
+
+  # cat osrelease
+  2.1.88
+  # cat ostype
+  Linux
+  # cat version
+  #5 Wed Feb 25 21:49:24 MET 1998
 
 The files osrelease and ostype should be clear enough. Version
 needs a little more clarification however. The '#5' means that
@@ -556,9 +575,9 @@ this is the fifth kernel built from this source base and the
 date behind it indicates the time the kernel was built.
 The only way to tune these values is to rebuild the kernel :-)
 
-==============================================================
 
 overflowgid & overflowuid:
+==========================
 
 if your architecture did not always support 32-bit UIDs (i.e. arm,
 i386, m68k, sh, and sparc32), a fixed UID and GID will be returned to
@@ -568,17 +587,17 @@ actual UID or GID would exceed 65535.
 These sysctls allow you to change the value of the fixed UID and GID.
 The default is 65534.
 
-==============================================================
 
 panic:
+======
 
 The value in this file represents the number of seconds the kernel
 waits before rebooting on a panic. When you use the software watchdog,
 the recommended setting is 60.
 
-==============================================================
 
 panic_on_io_nmi:
+================
 
 Controls the kernel's behavior when a CPU receives an NMI caused by
 an IO error.
@@ -591,20 +610,20 @@ an IO error.
    servers issue this sort of NMI when the dump button is pushed,
    and you can use this option to take a crash dump.
 
-==============================================================
 
 panic_on_oops:
+==============
 
 Controls the kernel's behaviour when an oops or BUG is encountered.
 
 0: try to continue operation
 
-1: panic immediately.  If the `panic' sysctl is also non-zero then the
+1: panic immediately.  If the `panic` sysctl is also non-zero then the
    machine will be rebooted.
 
-==============================================================
 
 panic_on_stackoverflow:
+=======================
 
 Controls the kernel's behavior when detecting the overflows of
 kernel, IRQ and exception stacks except a user stack.
@@ -614,9 +633,9 @@ This file shows up if CONFIG_DEBUG_STACKOVERFLOW is enabled.
 
 1: panic immediately.
 
-==============================================================
 
 panic_on_unrecovered_nmi:
+=========================
 
 The default Linux behaviour on an NMI of either memory or unknown is
 to continue operation. For many environments such as scientific
@@ -627,9 +646,9 @@ A small number of systems do generate NMI's for bizarre random reasons
 such as power management so the default is off. That sysctl works like
 the existing panic controls already in that directory.
 
-==============================================================
 
 panic_on_warn:
+==============
 
 Calls panic() in the WARN() path when set to 1.  This is useful to avoid
 a kernel rebuild when attempting to kdump at the location of a WARN().
@@ -638,25 +657,28 @@ a kernel rebuild when attempting to kdump at the location of a WARN().
 
 1: call panic() after printing out WARN() location.
 
-==============================================================
 
 panic_print:
+============
 
 Bitmask for printing system info when panic happens. User can chose
 combination of the following bits:
 
-bit 0: print all tasks info
-bit 1: print system memory info
-bit 2: print timer info
-bit 3: print locks info if CONFIG_LOCKDEP is on
-bit 4: print ftrace buffer
+=====  ========================================
+bit 0  print all tasks info
+bit 1  print system memory info
+bit 2  print timer info
+bit 3  print locks info if CONFIG_LOCKDEP is on
+bit 4  print ftrace buffer
+=====  ========================================
+
+So for example to print tasks and memory info on panic, user can::
 
-So for example to print tasks and memory info on panic, user can:
   echo 3 > /proc/sys/kernel/panic_print
 
-==============================================================
 
 panic_on_rcu_stall:
+===================
 
 When set to 1, calls panic() after RCU stall detection messages. This
 is useful to define the root cause of RCU stalls using a vmcore.
@@ -665,9 +687,9 @@ is useful to define the root cause of RCU stalls using a vmcore.
 
 1: panic() after printing RCU stall messages.
 
-==============================================================
 
 perf_cpu_time_max_percent:
+==========================
 
 Hints to the kernel how much CPU time it should be allowed to
 use to handle perf sampling events.  If the perf subsystem
@@ -680,10 +702,12 @@ unexpectedly take too long to execute, the NMIs can become
 stacked up next to each other so much that nothing else is
 allowed to execute.
 
-0: disable the mechanism.  Do not monitor or correct perf's
+0:
+   disable the mechanism.  Do not monitor or correct perf's
    sampling rate no matter how CPU time it takes.
 
-1-100: attempt to throttle perf's sample rate to this
+1-100:
+   attempt to throttle perf's sample rate to this
    percentage of CPU.  Note: the kernel calculates an
    "expected" length of each sample event.  100 here means
    100% of that expected length.  Even if this is set to
@@ -691,23 +715,30 @@ allowed to execute.
    length is exceeded.  Set to 0 if you truly do not care
    how much CPU is consumed.
 
-==============================================================
 
 perf_event_paranoid:
+====================
 
 Controls use of the performance events system by unprivileged
 users (without CAP_SYS_ADMIN).  The default value is 2.
 
- -1: Allow use of (almost) all events by all users
+===  ==================================================================
+ -1  Allow use of (almost) all events by all users
+
      Ignore mlock limit after perf_event_mlock_kb without CAP_IPC_LOCK
->=0: Disallow ftrace function tracepoint by users without CAP_SYS_ADMIN
+
+>=0  Disallow ftrace function tracepoint by users without CAP_SYS_ADMIN
+
      Disallow raw tracepoint access by users without CAP_SYS_ADMIN
->=1: Disallow CPU event access by users without CAP_SYS_ADMIN
->=2: Disallow kernel profiling by users without CAP_SYS_ADMIN
 
-==============================================================
+>=1  Disallow CPU event access by users without CAP_SYS_ADMIN
+
+>=2  Disallow kernel profiling by users without CAP_SYS_ADMIN
+===  ==================================================================
+
 
 perf_event_max_stack:
+=====================
 
 Controls maximum number of stack frames to copy for (attr.sample_type &
 PERF_SAMPLE_CALLCHAIN) configured events, for instance, when using
@@ -718,17 +749,17 @@ enabled, otherwise writing to this file will return -EBUSY.
 
 The default value is 127.
 
-==============================================================
 
 perf_event_mlock_kb:
+====================
 
 Control size of per-cpu ring buffer not counted agains mlock limit.
 
 The default value is 512 + 1 page
 
-==============================================================
 
 perf_event_max_contexts_per_stack:
+==================================
 
 Controls maximum number of stack frame context entries for
 (attr.sample_type & PERF_SAMPLE_CALLCHAIN) configured events, for
@@ -739,25 +770,25 @@ enabled, otherwise writing to this file will return -EBUSY.
 
 The default value is 8.
 
-==============================================================
 
 pid_max:
+========
 
 PID allocation wrap value.  When the kernel's next PID value
 reaches this value, it wraps back to a minimum PID value.
 PIDs of value pid_max or larger are not allocated.
 
-==============================================================
 
 ns_last_pid:
+============
 
 The last pid allocated in the current (the one task using this sysctl
 lives in) pid namespace. When selecting a pid for a next task on fork
 kernel tries to allocate a number starting from this one.
 
-==============================================================
 
 powersave-nap: (PPC only)
+=========================
 
 If set, Linux-PPC will use the 'nap' mode of powersaving,
 otherwise the 'doze' mode will be used.
@@ -765,6 +796,7 @@ otherwise the 'doze' mode will be used.
 ==============================================================
 
 printk:
+=======
 
 The four values in printk denote: console_loglevel,
 default_message_loglevel, minimum_console_loglevel and
@@ -774,25 +806,29 @@ These values influence printk() behavior when printing or
 logging error messages. See 'man 2 syslog' for more info on
 the different loglevels.
 
-- console_loglevel: messages with a higher priority than
-  this will be printed to the console
-- default_message_loglevel: messages without an explicit priority
-  will be printed with this priority
-- minimum_console_loglevel: minimum (highest) value to which
-  console_loglevel can be set
-- default_console_loglevel: default value for console_loglevel
+- console_loglevel:
+	messages with a higher priority than
+	this will be printed to the console
+- default_message_loglevel:
+	messages without an explicit priority
+	will be printed with this priority
+- minimum_console_loglevel:
+	minimum (highest) value to which
+	console_loglevel can be set
+- default_console_loglevel:
+	default value for console_loglevel
 
-==============================================================
 
 printk_delay:
+=============
 
 Delay each printk message in printk_delay milliseconds
 
 Value from 0 - 10000 is allowed.
 
-==============================================================
 
 printk_ratelimit:
+=================
 
 Some warning messages are rate limited. printk_ratelimit specifies
 the minimum length of time between these messages (in jiffies), by
@@ -800,48 +836,52 @@ default we allow one every 5 seconds.
 
 A value of 0 will disable rate limiting.
 
-==============================================================
 
 printk_ratelimit_burst:
+=======================
 
 While long term we enforce one message per printk_ratelimit
 seconds, we do allow a burst of messages to pass through.
 printk_ratelimit_burst specifies the number of messages we can
 send before ratelimiting kicks in.
 
-==============================================================
 
 printk_devkmsg:
+===============
 
 Control the logging to /dev/kmsg from userspace:
 
-ratelimit: default, ratelimited
+ratelimit:
+	default, ratelimited
+
 on: unlimited logging to /dev/kmsg from userspace
+
 off: logging to /dev/kmsg disabled
 
 The kernel command line parameter printk.devkmsg= overrides this and is
 a one-time setting until next reboot: once set, it cannot be changed by
 this sysctl interface anymore.
 
-==============================================================
 
 randomize_va_space:
+===================
 
 This option can be used to select the type of process address
 space randomization that is used in the system, for architectures
 that support this feature.
 
-0 - Turn the process address space randomization off.  This is the
+==  ===========================================================================
+0   Turn the process address space randomization off.  This is the
     default for architectures that do not support this feature anyways,
     and kernels that are booted with the "norandmaps" parameter.
 
-1 - Make the addresses of mmap base, stack and VDSO page randomized.
+1   Make the addresses of mmap base, stack and VDSO page randomized.
     This, among other things, implies that shared libraries will be
     loaded to random addresses.  Also for PIE-linked binaries, the
     location of code start is randomized.  This is the default if the
     CONFIG_COMPAT_BRK option is enabled.
 
-2 - Additionally enable heap randomization.  This is the default if
+2   Additionally enable heap randomization.  This is the default if
     CONFIG_COMPAT_BRK is disabled.
 
     There are a few legacy applications out there (such as some ancient
@@ -854,18 +894,19 @@ that support this feature.
     Systems with ancient and/or broken binaries should be configured
     with CONFIG_COMPAT_BRK enabled, which excludes the heap from process
     address space randomization.
+==  ===========================================================================
 
-==============================================================
 
 reboot-cmd: (Sparc only)
+========================
 
 ??? This seems to be a way to give an argument to the Sparc
 ROM/Flash boot loader. Maybe to tell it what to do after
 rebooting. ???
 
-==============================================================
 
 rtsig-max & rtsig-nr:
+=====================
 
 The file rtsig-max can be used to tune the maximum number
 of POSIX realtime (queued) signals that can be outstanding
@@ -873,9 +914,9 @@ in the system.
 
 rtsig-nr shows the number of RT signals currently queued.
 
-==============================================================
 
 sched_energy_aware:
+===================
 
 Enables/disables Energy Aware Scheduling (EAS). EAS starts
 automatically on platforms where it can run (that is,
@@ -884,17 +925,17 @@ Model available). If your platform happens to meet the
 requirements for EAS but you do not want to use it, change
 this value to 0.
 
-==============================================================
 
 sched_schedstats:
+=================
 
 Enables/disables scheduler statistics. Enabling this feature
 incurs a small amount of overhead in the scheduler but is
 useful for debugging and performance tuning.
 
-==============================================================
 
 sg-big-buff:
+============
 
 This file shows the size of the generic SCSI (sg) buffer.
 You can't tune it just yet, but you could change it on
@@ -905,9 +946,9 @@ There shouldn't be any reason to change this value. If
 you can come up with one, you probably know what you
 are doing anyway :)
 
-==============================================================
 
 shmall:
+=======
 
 This parameter sets the total amount of shared memory pages that
 can be used system wide. Hence, SHMALL should always be at least
@@ -916,20 +957,20 @@ ceil(shmmax/PAGE_SIZE).
 If you are not sure what the default PAGE_SIZE is on your Linux
 system, you can run the following command:
 
-# getconf PAGE_SIZE
+	# getconf PAGE_SIZE
 
-==============================================================
 
 shmmax:
+=======
 
 This value can be used to query and set the run time limit
 on the maximum shared memory segment size that can be created.
 Shared memory segments up to 1Gb are now supported in the
 kernel.  This value defaults to SHMMAX.
 
-==============================================================
 
 shm_rmid_forced:
+================
 
 Linux lets you set resource limits, including how much memory one
 process can consume, via setrlimit(2).  Unfortunately, shared memory
@@ -948,28 +989,30 @@ need this.
 Note that if you change this from 0 to 1, already created segments
 without users and with a dead originative process will be destroyed.
 
-==============================================================
 
 sysctl_writes_strict:
+=====================
 
 Control how file position affects the behavior of updating sysctl values
 via the /proc/sys interface:
 
-  -1 - Legacy per-write sysctl value handling, with no printk warnings.
+  ==   ======================================================================
+  -1   Legacy per-write sysctl value handling, with no printk warnings.
        Each write syscall must fully contain the sysctl value to be
        written, and multiple writes on the same sysctl file descriptor
        will rewrite the sysctl value, regardless of file position.
-   0 - Same behavior as above, but warn about processes that perform writes
+   0   Same behavior as above, but warn about processes that perform writes
        to a sysctl file descriptor when the file position is not 0.
-   1 - (default) Respect file position when writing sysctl strings. Multiple
+   1   (default) Respect file position when writing sysctl strings. Multiple
        writes will append to the sysctl value buffer. Anything past the max
        length of the sysctl value buffer will be ignored. Writes to numeric
        sysctl entries must always be at file position 0 and the value must
        be fully contained in the buffer sent in the write syscall.
+  ==   ======================================================================
 
-==============================================================
 
 softlockup_all_cpu_backtrace:
+=============================
 
 This value controls the soft lockup detector thread's behavior
 when a soft lockup condition is detected as to whether or not
@@ -983,13 +1026,14 @@ NMI.
 
 1: on detection capture more debug information.
 
-==============================================================
 
-soft_watchdog
+soft_watchdog:
+==============
 
 This parameter can be used to control the soft lockup detector.
 
    0 - disable the soft lockup detector
+
    1 - enable the soft lockup detector
 
 The soft lockup detector monitors CPUs for threads that are hogging the CPUs
@@ -999,9 +1043,9 @@ interrupts which are needed for the 'watchdog/N' threads to be woken up by
 the watchdog timer function, otherwise the NMI watchdog - if enabled - can
 detect a hard lockup condition.
 
-==============================================================
 
-stack_erasing
+stack_erasing:
+==============
 
 This parameter can be used to control kernel stack erasing at the end
 of syscalls for kernels built with CONFIG_GCC_PLUGIN_STACKLEAK.
@@ -1015,37 +1059,40 @@ compilation sees a 1% slowdown, other systems and workloads may vary.
 
   1: kernel stack erasing is enabled (default), it is performed before
      returning to the userspace at the end of syscalls.
-==============================================================
+
 
 tainted
+=======
 
 Non-zero if the kernel has been tainted. Numeric values, which can be
 ORed together. The letters are seen in "Tainted" line of Oops reports.
 
-     1 (P): proprietary module was loaded
-     2 (F): module was force loaded
-     4 (S): SMP kernel oops on an officially SMP incapable processor
-     8 (R): module was force unloaded
-    16 (M): processor reported a Machine Check Exception (MCE)
-    32 (B): bad page referenced or some unexpected page flags
-    64 (U): taint requested by userspace application
-   128 (D): kernel died recently, i.e. there was an OOPS or BUG
-   256 (A): an ACPI table was overridden by user
-   512 (W): kernel issued warning
-  1024 (C): staging driver was loaded
-  2048 (I): workaround for bug in platform firmware applied
-  4096 (O): externally-built ("out-of-tree") module was loaded
-  8192 (E): unsigned module was loaded
- 16384 (L): soft lockup occurred
- 32768 (K): kernel has been live patched
- 65536 (X): Auxiliary taint, defined and used by for distros
-131072 (T): The kernel was built with the struct randomization plugin
+======  =====  ==============================================================
+     1  `(P)`  proprietary module was loaded
+     2  `(F)`  module was force loaded
+     4  `(S)`  SMP kernel oops on an officially SMP incapable processor
+     8  `(R)`  module was force unloaded
+    16  `(M)`  processor reported a Machine Check Exception (MCE)
+    32  `(B)`  bad page referenced or some unexpected page flags
+    64  `(U)`  taint requested by userspace application
+   128  `(D)`  kernel died recently, i.e. there was an OOPS or BUG
+   256  `(A)`  an ACPI table was overridden by user
+   512  `(W)`  kernel issued warning
+  1024  `(C)`  staging driver was loaded
+  2048  `(I)`  workaround for bug in platform firmware applied
+  4096  `(O)`  externally-built ("out-of-tree") module was loaded
+  8192  `(E)`  unsigned module was loaded
+ 16384  `(L)`  soft lockup occurred
+ 32768  `(K)`  kernel has been live patched
+ 65536  `(X)`  Auxiliary taint, defined and used by for distros
+131072  `(T)`  The kernel was built with the struct randomization plugin
+======  =====  ==============================================================
 
 See Documentation/admin-guide/tainted-kernels.rst for more information.
 
-==============================================================
 
-threads-max
+threads-max:
+============
 
 This value controls the maximum number of threads that can be created
 using fork().
@@ -1055,8 +1102,10 @@ maximum number of threads is created, the thread structures occupy only
 a part (1/8th) of the available RAM pages.
 
 The minimum value that can be written to threads-max is 20.
+
 The maximum value that can be written to threads-max is given by the
 constant FUTEX_TID_MASK (0x3fffffff).
+
 If a value outside of this range is written to threads-max an error
 EINVAL occurs.
 
@@ -1064,9 +1113,9 @@ The value written is checked against the available RAM pages. If the
 thread structures would occupy too much (more than 1/8th) of the
 available RAM pages threads-max is reduced accordingly.
 
-==============================================================
 
 unknown_nmi_panic:
+==================
 
 The value in this file affects behavior of handling NMI. When the
 value is non-zero, unknown NMI is trapped and then panic occurs. At
@@ -1075,28 +1124,29 @@ that time, kernel debugging information is displayed on console.
 NMI switch that most IA32 servers have fires unknown NMI up, for
 example.  If a system hangs up, try pressing the NMI switch.
 
-==============================================================
 
 watchdog:
+=========
 
 This parameter can be used to disable or enable the soft lockup detector
 _and_ the NMI watchdog (i.e. the hard lockup detector) at the same time.
 
    0 - disable both lockup detectors
+
    1 - enable both lockup detectors
 
 The soft lockup detector and the NMI watchdog can also be disabled or
 enabled individually, using the soft_watchdog and nmi_watchdog parameters.
-If the watchdog parameter is read, for example by executing
+If the watchdog parameter is read, for example by executing::
 
    cat /proc/sys/kernel/watchdog
 
 the output of this command (0 or 1) shows the logical OR of soft_watchdog
 and nmi_watchdog.
 
-==============================================================
 
 watchdog_cpumask:
+=================
 
 This value can be used to control on which cpus the watchdog may run.
 The default cpumask is all possible cores, but if NO_HZ_FULL is
@@ -1111,13 +1161,13 @@ if a kernel lockup was suspected on those cores.
 
 The argument value is the standard cpulist format for cpumasks,
 so for example to enable the watchdog on cores 0, 2, 3, and 4 you
-might say:
+might say::
 
   echo 0,2-4 > /proc/sys/kernel/watchdog_cpumask
 
-==============================================================
 
 watchdog_thresh:
+================
 
 This value can be used to control the frequency of hrtimer and NMI
 events and the soft and hard lockup thresholds. The default threshold
@@ -1125,5 +1175,3 @@ is 10 seconds.
 
 The softlockup threshold is (2 * watchdog_thresh). Setting this
 tunable to zero will disable lockup detection altogether.
-
-==============================================================
diff --git a/Documentation/sysctl/net.txt b/Documentation/sysctl/net.rst
similarity index 85%
rename from Documentation/sysctl/net.txt
rename to Documentation/sysctl/net.rst
index 2ae91d3873bb..a7d44e71019d 100644
--- a/Documentation/sysctl/net.txt
+++ b/Documentation/sysctl/net.rst
@@ -1,12 +1,25 @@
-Documentation for /proc/sys/net/*
-	(c) 1999		Terrehon Bowden <terrehon@pacbell.net>
-				Bodo Bauer <bb@ricochet.net>
-	(c) 2000		Jorge Nerin <comandante@zaralinux.com>
-	(c) 2009		Shen Feng <shen@cn.fujitsu.com>
+================================
+Documentation for /proc/sys/net/
+================================
 
-For general info and legal blurb, please look in README.
+Copyright
 
-==============================================================
+Copyright (c) 1999
+
+	- Terrehon Bowden <terrehon@pacbell.net>
+	- Bodo Bauer <bb@ricochet.net>
+
+Copyright (c) 2000
+
+	- Jorge Nerin <comandante@zaralinux.com>
+
+Copyright (c) 2009
+
+	- Shen Feng <shen@cn.fujitsu.com>
+
+For general info and legal blurb, please look in index.rst.
+
+------------------------------------------------------------------------------
 
 This file contains the documentation for the sysctl files in
 /proc/sys/net
@@ -17,20 +30,22 @@ see only some of them, depending on your kernel's configuration.
 
 
 Table : Subdirectories in /proc/sys/net
-..............................................................................
- Directory Content             Directory  Content
- core      General parameter   appletalk  Appletalk protocol
- unix      Unix domain sockets netrom     NET/ROM
- 802       E802 protocol       ax25       AX25
- ethernet  Ethernet protocol   rose       X.25 PLP layer
- ipv4      IP version 4        x25        X.25 protocol
- ipx       IPX                 token-ring IBM token ring
- bridge    Bridging            decnet     DEC net
- ipv6      IP version 6        tipc       TIPC
-..............................................................................
+
+ ========= =================== = ========== ==================
+ Directory Content               Directory  Content
+ ========= =================== = ========== ==================
+ core      General parameter     appletalk  Appletalk protocol
+ unix      Unix domain sockets   netrom     NET/ROM
+ 802       E802 protocol         ax25       AX25
+ ethernet  Ethernet protocol     rose       X.25 PLP layer
+ ipv4      IP version 4          x25        X.25 protocol
+ ipx       IPX                   token-ring IBM token ring
+ bridge    Bridging              decnet     DEC net
+ ipv6      IP version 6          tipc       TIPC
+ ========= =================== = ========== ==================
 
 1. /proc/sys/net/core - Network core options
--------------------------------------------------------
+============================================
 
 bpf_jit_enable
 --------------
@@ -44,6 +59,7 @@ restricted C into a sequence of BPF instructions. After program load
 through bpf(2) and passing a verifier in the kernel, a JIT will then
 translate these BPF proglets into native CPU instructions. There are
 two flavors of JITs, the newer eBPF JIT currently supported on:
+
   - x86_64
   - x86_32
   - arm64
@@ -55,6 +71,7 @@ two flavors of JITs, the newer eBPF JIT currently supported on:
   - riscv
 
 And the older cBPF JIT supported on the following archs:
+
   - mips
   - ppc
   - sparc
@@ -65,10 +82,11 @@ compile them transparently. Older cBPF JITs can only translate
 tcpdump filters, seccomp rules, etc, but not mentioned eBPF
 programs loaded through bpf(2).
 
-Values :
-	0 - disable the JIT (default value)
-	1 - enable the JIT
-	2 - enable the JIT and ask the compiler to emit traces on kernel log.
+Values:
+
+	- 0 - disable the JIT (default value)
+	- 1 - enable the JIT
+	- 2 - enable the JIT and ask the compiler to emit traces on kernel log.
 
 bpf_jit_harden
 --------------
@@ -76,10 +94,12 @@ bpf_jit_harden
 This enables hardening for the BPF JIT compiler. Supported are eBPF
 JIT backends. Enabling hardening trades off performance, but can
 mitigate JIT spraying.
-Values :
-	0 - disable JIT hardening (default value)
-	1 - enable JIT hardening for unprivileged users only
-	2 - enable JIT hardening for all users
+
+Values:
+
+	- 0 - disable JIT hardening (default value)
+	- 1 - enable JIT hardening for unprivileged users only
+	- 2 - enable JIT hardening for all users
 
 bpf_jit_kallsyms
 ----------------
@@ -89,9 +109,11 @@ addresses to the kernel, meaning they neither show up in traces nor
 in /proc/kallsyms. This enables export of these addresses, which can
 be used for debugging/tracing. If bpf_jit_harden is enabled, this
 feature is disabled.
+
 Values :
-	0 - disable JIT kallsyms export (default value)
-	1 - enable JIT kallsyms export for privileged users only
+
+	- 0 - disable JIT kallsyms export (default value)
+	- 1 - enable JIT kallsyms export for privileged users only
 
 bpf_jit_limit
 -------------
@@ -102,7 +124,7 @@ been surpassed. bpf_jit_limit contains the value of the global limit
 in bytes.
 
 dev_weight
---------------
+----------
 
 The maximum number of packets that kernel can handle on a NAPI interrupt,
 it's a Per-CPU variable. For drivers that support LRO or GRO_HW, a hardware
@@ -111,7 +133,7 @@ aggregated packet is counted as one packet in this context.
 Default: 64
 
 dev_weight_rx_bias
---------------
+------------------
 
 RPS (e.g. RFS, aRFS) processing is competing with the registered NAPI poll function
 of the driver for the per softirq cycle netdev_budget. This parameter influences
@@ -120,19 +142,22 @@ processing during RX softirq cycles. It is further meant for making current
 dev_weight adaptable for asymmetric CPU needs on RX/TX side of the network stack.
 (see dev_weight_tx_bias) It is effective on a per CPU basis. Determination is based
 on dev_weight and is calculated multiplicative (dev_weight * dev_weight_rx_bias).
+
 Default: 1
 
 dev_weight_tx_bias
---------------
+------------------
 
 Scales the maximum number of packets that can be processed during a TX softirq cycle.
 Effective on a per CPU basis. Allows scaling of current dev_weight for asymmetric
 net stack processing needs. Be careful to avoid making TX softirq processing a CPU hog.
+
 Calculation is based on dev_weight (dev_weight * dev_weight_tx_bias).
+
 Default: 1
 
 default_qdisc
---------------
+-------------
 
 The default queuing discipline to use for network devices. This allows
 overriding the default of pfifo_fast with an alternative. Since the default
@@ -144,17 +169,21 @@ which require setting up classes and bandwidths. Note that physical multiqueue
 interfaces still use mq as root qdisc, which in turn uses this default for its
 leaves. Virtual devices (like e.g. lo or veth) ignore this setting and instead
 default to noqueue.
+
 Default: pfifo_fast
 
 busy_read
-----------------
+---------
+
 Low latency busy poll timeout for socket reads. (needs CONFIG_NET_RX_BUSY_POLL)
 Approximate time in us to busy loop waiting for packets on the device queue.
 This sets the default value of the SO_BUSY_POLL socket option.
 Can be set or overridden per socket by setting socket option SO_BUSY_POLL,
 which is the preferred method of enabling. If you need to enable the feature
 globally via sysctl, a value of 50 is recommended.
+
 Will increase power usage.
+
 Default: 0 (off)
 
 busy_poll
@@ -167,7 +196,9 @@ For more than that you probably want to use epoll.
 Note that only sockets with SO_BUSY_POLL set will be busy polled,
 so you want to either selectively set SO_BUSY_POLL on those sockets or set
 sysctl.net.busy_read globally.
+
 Will increase power usage.
+
 Default: 0 (off)
 
 rmem_default
@@ -185,6 +216,7 @@ tstamp_allow_data
 Allow processes to receive tx timestamps looped together with the original
 packet contents. If disabled, transmit timestamp requests from unprivileged
 processes are dropped unless socket option SOF_TIMESTAMPING_OPT_TSONLY is set.
+
 Default: 1 (on)
 
 
@@ -250,19 +282,24 @@ randomly generated.
 Some user space might need to gather its content even if drivers do not
 provide ethtool -x support yet.
 
-myhost:~# cat /proc/sys/net/core/netdev_rss_key
-84:50:f4:00:a8:15:d1:a7:e9:7f:1d:60:35:c7:47:25:42:97:74:ca:56:bb:b6:a1:d8: ... (52 bytes total)
+::
+
+  myhost:~# cat /proc/sys/net/core/netdev_rss_key
+  84:50:f4:00:a8:15:d1:a7:e9:7f:1d:60:35:c7:47:25:42:97:74:ca:56:bb:b6:a1:d8: ... (52 bytes total)
 
 File contains nul bytes if no driver ever called netdev_rss_key_fill() function.
+
 Note:
-/proc/sys/net/core/netdev_rss_key contains 52 bytes of key,
-but most drivers only use 40 bytes of it.
+  /proc/sys/net/core/netdev_rss_key contains 52 bytes of key,
+  but most drivers only use 40 bytes of it.
 
-myhost:~# ethtool -x eth0
-RX flow hash indirection table for eth0 with 8 RX ring(s):
-    0:    0     1     2     3     4     5     6     7
-RSS hash key:
-84:50:f4:00:a8:15:d1:a7:e9:7f:1d:60:35:c7:47:25:42:97:74:ca:56:bb:b6:a1:d8:43:e3:c9:0c:fd:17:55:c2:3a:4d:69:ed:f1:42:89
+::
+
+  myhost:~# ethtool -x eth0
+  RX flow hash indirection table for eth0 with 8 RX ring(s):
+      0:    0     1     2     3     4     5     6     7
+  RSS hash key:
+  84:50:f4:00:a8:15:d1:a7:e9:7f:1d:60:35:c7:47:25:42:97:74:ca:56:bb:b6:a1:d8:43:e3:c9:0c:fd:17:55:c2:3a:4d:69:ed:f1:42:89
 
 netdev_tstamp_prequeue
 ----------------------
@@ -293,7 +330,7 @@ user space is responsible for creating them if needed.
 Default : 0  (for compatibility reasons)
 
 devconf_inherit_init_net
-----------------------------
+------------------------
 
 Controls if a new network namespace should inherit all current
 settings under /proc/sys/net/{ipv4,ipv6}/conf/{all,default}/. By
@@ -307,7 +344,7 @@ forced to reset to their default values.
 Default : 0  (for compatibility reasons)
 
 2. /proc/sys/net/unix - Parameters for Unix domain sockets
--------------------------------------------------------
+----------------------------------------------------------
 
 There is only one file in this directory.
 unix_dgram_qlen limits the max number of datagrams queued in Unix domain
@@ -315,13 +352,13 @@ socket's buffer. It will not take effect unless PF_UNIX flag is specified.
 
 
 3. /proc/sys/net/ipv4 - IPV4 settings
--------------------------------------------------------
+-------------------------------------
 Please see: Documentation/networking/ip-sysctl.txt and ipvs-sysctl.txt for
 descriptions of these entries.
 
 
 4. Appletalk
--------------------------------------------------------
+------------
 
 The /proc/sys/net/appletalk  directory  holds the Appletalk configuration data
 when Appletalk is loaded. The configurable parameters are:
@@ -366,7 +403,7 @@ route flags, and the device the route is using.
 
 
 5. IPX
--------------------------------------------------------
+------
 
 The IPX protocol has no tunable values in proc/sys/net.
 
@@ -391,14 +428,16 @@ gives the  destination  network, the router node (or Directly) and the network
 address of the router (or Connected) for internal networks.
 
 6. TIPC
--------------------------------------------------------
+-------
 
 tipc_rmem
-----------
+---------
 
 The TIPC protocol now has a tunable for the receive memory, similar to the
 tcp_rmem - i.e. a vector of 3 INTEGERs: (min, default, max)
 
+::
+
     # cat /proc/sys/net/tipc/tipc_rmem
     4252725 34021800        68043600
     #
@@ -409,7 +448,7 @@ is not at this point in time used in any meaningful way, but the triplet is
 preserved in order to be consistent with things like tcp_rmem.
 
 named_timeout
---------------
+-------------
 
 TIPC name table updates are distributed asynchronously in a cluster, without
 any form of transaction handling. This means that different race scenarios are
diff --git a/Documentation/sysctl/sunrpc.txt b/Documentation/sysctl/sunrpc.rst
similarity index 62%
rename from Documentation/sysctl/sunrpc.txt
rename to Documentation/sysctl/sunrpc.rst
index ae1ecac6f85a..09780a682afd 100644
--- a/Documentation/sysctl/sunrpc.txt
+++ b/Documentation/sysctl/sunrpc.rst
@@ -1,9 +1,14 @@
-Documentation for /proc/sys/sunrpc/*	kernel version 2.2.10
-	(c) 1998, 1999,  Rik van Riel <riel@nl.linux.org>
+===================================
+Documentation for /proc/sys/sunrpc/
+===================================
 
-For general info and legal blurb, please look in README.
+kernel version 2.2.10
 
-==============================================================
+Copyright (c) 1998, 1999,  Rik van Riel <riel@nl.linux.org>
+
+For general info and legal blurb, please look in index.rst.
+
+------------------------------------------------------------------------------
 
 This file contains the documentation for the sysctl files in
 /proc/sys/sunrpc and is valid for Linux kernel version 2.2.
diff --git a/Documentation/sysctl/user.txt b/Documentation/sysctl/user.rst
similarity index 77%
rename from Documentation/sysctl/user.txt
rename to Documentation/sysctl/user.rst
index a5882865836e..650eaa03f15e 100644
--- a/Documentation/sysctl/user.txt
+++ b/Documentation/sysctl/user.rst
@@ -1,7 +1,12 @@
-Documentation for /proc/sys/user/*	kernel version 4.9.0
-	(c) 2016		Eric Biederman <ebiederm@xmission.com>
+=================================
+Documentation for /proc/sys/user/
+=================================
 
-==============================================================
+kernel version 4.9.0
+
+Copyright (c) 2016		Eric Biederman <ebiederm@xmission.com>
+
+------------------------------------------------------------------------------
 
 This file contains the documentation for the sysctl files in
 /proc/sys/user.
@@ -30,37 +35,44 @@ user namespace does not allow a user to escape their current limits.
 
 Currently, these files are in /proc/sys/user:
 
-- max_cgroup_namespaces
+max_cgroup_namespaces
+=====================
 
   The maximum number of cgroup namespaces that any user in the current
   user namespace may create.
 
-- max_ipc_namespaces
+max_ipc_namespaces
+==================
 
   The maximum number of ipc namespaces that any user in the current
   user namespace may create.
 
-- max_mnt_namespaces
+max_mnt_namespaces
+==================
 
   The maximum number of mount namespaces that any user in the current
   user namespace may create.
 
-- max_net_namespaces
+max_net_namespaces
+==================
 
   The maximum number of network namespaces that any user in the
   current user namespace may create.
 
-- max_pid_namespaces
+max_pid_namespaces
+==================
 
   The maximum number of pid namespaces that any user in the current
   user namespace may create.
 
-- max_user_namespaces
+max_user_namespaces
+===================
 
   The maximum number of user namespaces that any user in the current
   user namespace may create.
 
-- max_uts_namespaces
+max_uts_namespaces
+==================
 
   The maximum number of user namespaces that any user in the current
   user namespace may create.
diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.rst
similarity index 85%
rename from Documentation/sysctl/vm.txt
rename to Documentation/sysctl/vm.rst
index c5f0d44433a2..5aceb5cd5ce7 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.rst
@@ -1,10 +1,16 @@
-Documentation for /proc/sys/vm/*	kernel version 2.6.29
-	(c) 1998, 1999,  Rik van Riel <riel@nl.linux.org>
-	(c) 2008         Peter W. Morreale <pmorreale@novell.com>
+===============================
+Documentation for /proc/sys/vm/
+===============================
 
-For general info and legal blurb, please look in README.
+kernel version 2.6.29
 
-==============================================================
+Copyright (c) 1998, 1999,  Rik van Riel <riel@nl.linux.org>
+
+Copyright (c) 2008         Peter W. Morreale <pmorreale@novell.com>
+
+For general info and legal blurb, please look in index.rst.
+
+------------------------------------------------------------------------------
 
 This file contains the documentation for the sysctl files in
 /proc/sys/vm and is valid for Linux kernel version 2.6.29.
@@ -68,9 +74,9 @@ Currently, these files are in /proc/sys/vm:
 - watermark_scale_factor
 - zone_reclaim_mode
 
-==============================================================
 
 admin_reserve_kbytes
+====================
 
 The amount of free memory in the system that should be reserved for users
 with the capability cap_sys_admin.
@@ -97,25 +103,25 @@ On x86_64 this is about 128MB.
 
 Changing this takes effect whenever an application requests memory.
 
-==============================================================
 
 block_dump
+==========
 
 block_dump enables block I/O debugging when set to a nonzero value. More
 information on block I/O debugging is in Documentation/laptops/laptop-mode.rst.
 
-==============================================================
 
 compact_memory
+==============
 
 Available only when CONFIG_COMPACTION is set. When 1 is written to the file,
 all zones are compacted such that free memory is available in contiguous
 blocks where possible. This can be important for example in the allocation of
 huge pages although processes will also directly compact memory as required.
 
-==============================================================
 
 compact_unevictable_allowed
+===========================
 
 Available only when CONFIG_COMPACTION is set. When set to 1, compaction is
 allowed to examine the unevictable lru (mlocked pages) for pages to compact.
@@ -123,21 +129,22 @@ This should be used on systems where stalls for minor page faults are an
 acceptable trade for large contiguous free memory.  Set to 0 to prevent
 compaction from moving pages that are unevictable.  Default value is 1.
 
-==============================================================
 
 dirty_background_bytes
+======================
 
 Contains the amount of dirty memory at which the background kernel
 flusher threads will start writeback.
 
-Note: dirty_background_bytes is the counterpart of dirty_background_ratio. Only
-one of them may be specified at a time. When one sysctl is written it is
-immediately taken into account to evaluate the dirty memory limits and the
-other appears as 0 when read.
+Note:
+  dirty_background_bytes is the counterpart of dirty_background_ratio. Only
+  one of them may be specified at a time. When one sysctl is written it is
+  immediately taken into account to evaluate the dirty memory limits and the
+  other appears as 0 when read.
 
-==============================================================
 
 dirty_background_ratio
+======================
 
 Contains, as a percentage of total available memory that contains free pages
 and reclaimable pages, the number of pages at which the background kernel
@@ -145,9 +152,9 @@ flusher threads will start writing out dirty data.
 
 The total available memory is not equal to total system memory.
 
-==============================================================
 
 dirty_bytes
+===========
 
 Contains the amount of dirty memory at which a process generating disk writes
 will itself start writeback.
@@ -161,18 +168,18 @@ Note: the minimum value allowed for dirty_bytes is two pages (in bytes); any
 value lower than this limit will be ignored and the old configuration will be
 retained.
 
-==============================================================
 
 dirty_expire_centisecs
+======================
 
 This tunable is used to define when dirty data is old enough to be eligible
 for writeout by the kernel flusher threads.  It is expressed in 100'ths
 of a second.  Data which has been dirty in-memory for longer than this
 interval will be written out next time a flusher thread wakes up.
 
-==============================================================
 
 dirty_ratio
+===========
 
 Contains, as a percentage of total available memory that contains free pages
 and reclaimable pages, the number of pages at which a process which is
@@ -180,9 +187,9 @@ generating disk writes will itself start writing out dirty data.
 
 The total available memory is not equal to total system memory.
 
-==============================================================
 
 dirtytime_expire_seconds
+========================
 
 When a lazytime inode is constantly having its pages dirtied, the inode with
 an updated timestamp will never get chance to be written out.  And, if the
@@ -192,34 +199,39 @@ eventually gets pushed out to disk.  This tunable is used to define when dirty
 inode is old enough to be eligible for writeback by the kernel flusher threads.
 And, it is also used as the interval to wakeup dirtytime_writeback thread.
 
-==============================================================
 
 dirty_writeback_centisecs
+=========================
 
-The kernel flusher threads will periodically wake up and write `old' data
+The kernel flusher threads will periodically wake up and write `old` data
 out to disk.  This tunable expresses the interval between those wakeups, in
 100'ths of a second.
 
 Setting this to zero disables periodic writeback altogether.
 
-==============================================================
 
 drop_caches
+===========
 
 Writing to this will cause the kernel to drop clean caches, as well as
 reclaimable slab objects like dentries and inodes.  Once dropped, their
 memory becomes free.
 
-To free pagecache:
+To free pagecache::
+
 	echo 1 > /proc/sys/vm/drop_caches
-To free reclaimable slab objects (includes dentries and inodes):
+
+To free reclaimable slab objects (includes dentries and inodes)::
+
 	echo 2 > /proc/sys/vm/drop_caches
-To free slab objects and pagecache:
+
+To free slab objects and pagecache::
+
 	echo 3 > /proc/sys/vm/drop_caches
 
 This is a non-destructive operation and will not free any dirty objects.
 To increase the number of objects freed by this operation, the user may run
-`sync' prior to writing to /proc/sys/vm/drop_caches.  This will minimize the
+`sync` prior to writing to /proc/sys/vm/drop_caches.  This will minimize the
 number of dirty objects on the system and create more candidates to be
 dropped.
 
@@ -233,16 +245,16 @@ dropped objects, especially if they were under heavy use.  Because of this,
 use outside of a testing or debugging environment is not recommended.
 
 You may see informational messages in your kernel log when this file is
-used:
+used::
 
 	cat (1234): drop_caches: 3
 
 These are informational only.  They do not mean that anything is wrong
 with your system.  To disable them, echo 4 (bit 2) into drop_caches.
 
-==============================================================
 
 extfrag_threshold
+=================
 
 This parameter affects whether the kernel will compact memory or direct
 reclaim to satisfy a high-order allocation. The extfrag/extfrag_index file in
@@ -254,9 +266,9 @@ implies that the allocation will succeed as long as watermarks are met.
 The kernel will not compact memory in a zone if the
 fragmentation index is <= extfrag_threshold. The default value is 500.
 
-==============================================================
 
 highmem_is_dirtyable
+====================
 
 Available only for systems with CONFIG_HIGHMEM enabled (32b systems).
 
@@ -274,30 +286,30 @@ OOM killer because some writers (e.g. direct block device writes) can
 only use the low memory and they can fill it up with dirty data without
 any throttling.
 
-==============================================================
 
 hugetlb_shm_group
+=================
 
 hugetlb_shm_group contains group id that is allowed to create SysV
 shared memory segment using hugetlb page.
 
-==============================================================
 
 laptop_mode
+===========
 
 laptop_mode is a knob that controls "laptop mode". All the things that are
 controlled by this knob are discussed in Documentation/laptops/laptop-mode.rst.
 
-==============================================================
 
 legacy_va_layout
+================
 
 If non-zero, this sysctl disables the new 32-bit mmap layout - the kernel
 will use the legacy (2.4) layout for all processes.
 
-==============================================================
 
 lowmem_reserve_ratio
+====================
 
 For some specialised workloads on highmem machines it is dangerous for
 the kernel to allow process memory to be allocated from the "lowmem"
@@ -308,7 +320,7 @@ And on large highmem machines this lack of reclaimable lowmem memory
 can be fatal.
 
 So the Linux page allocator has a mechanism which prevents allocations
-which _could_ use highmem from using too much lowmem.  This means that
+which *could* use highmem from using too much lowmem.  This means that
 a certain amount of lowmem is defended from the possibility of being
 captured into pinned user memory.
 
@@ -316,39 +328,37 @@ captured into pinned user memory.
 mechanism will also defend that region from allocations which could use
 highmem or lowmem).
 
-The `lowmem_reserve_ratio' tunable determines how aggressive the kernel is
+The `lowmem_reserve_ratio` tunable determines how aggressive the kernel is
 in defending these lower zones.
 
 If you have a machine which uses highmem or ISA DMA and your
 applications are using mlock(), or if you are running with no swap then
 you probably should change the lowmem_reserve_ratio setting.
 
-The lowmem_reserve_ratio is an array. You can see them by reading this file.
--
-% cat /proc/sys/vm/lowmem_reserve_ratio
-256     256     32
--
+The lowmem_reserve_ratio is an array. You can see them by reading this file::
+
+	% cat /proc/sys/vm/lowmem_reserve_ratio
+	256     256     32
 
 But, these values are not used directly. The kernel calculates # of protection
 pages for each zones from them. These are shown as array of protection pages
 in /proc/zoneinfo like followings. (This is an example of x86-64 box).
-Each zone has an array of protection pages like this.
+Each zone has an array of protection pages like this::
 
--
-Node 0, zone      DMA
-  pages free     1355
-        min      3
-        low      3
-        high     4
+  Node 0, zone      DMA
+    pages free     1355
+          min      3
+          low      3
+          high     4
 	:
 	:
-    numa_other   0
-        protection: (0, 2004, 2004, 2004)
+      numa_other   0
+          protection: (0, 2004, 2004, 2004)
 	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-  pagesets
-    cpu: 0 pcp: 0
-        :
--
+    pagesets
+      cpu: 0 pcp: 0
+          :
+
 These protections are added to score to judge whether this zone should be used
 for page allocation or should be reclaimed.
 
@@ -359,20 +369,24 @@ not be used because pages_free(1355) is smaller than watermark + protection[2]
 normal page requirement. If requirement is DMA zone(index=0), protection[0]
 (=0) is used.
 
-zone[i]'s protection[j] is calculated by following expression.
+zone[i]'s protection[j] is calculated by following expression::
 
-(i < j):
-  zone[i]->protection[j]
-  = (total sums of managed_pages from zone[i+1] to zone[j] on the node)
-    / lowmem_reserve_ratio[i];
-(i = j):
-   (should not be protected. = 0;
-(i > j):
-   (not necessary, but looks 0)
+  (i < j):
+    zone[i]->protection[j]
+    = (total sums of managed_pages from zone[i+1] to zone[j] on the node)
+      / lowmem_reserve_ratio[i];
+  (i = j):
+     (should not be protected. = 0;
+  (i > j):
+     (not necessary, but looks 0)
 
 The default values of lowmem_reserve_ratio[i] are
+
+    === ====================================
     256 (if zone[i] means DMA or DMA32 zone)
-    32  (others).
+    32  (others)
+    === ====================================
+
 As above expression, they are reciprocal number of ratio.
 256 means 1/256. # of protection pages becomes about "0.39%" of total managed
 pages of higher zones on the node.
@@ -381,9 +395,9 @@ If you would like to protect more pages, smaller values are effective.
 The minimum value is 1 (1/1 -> 100%). The value less than 1 completely
 disables protection of the pages.
 
-==============================================================
 
 max_map_count:
+==============
 
 This file contains the maximum number of memory map areas a process
 may have. Memory map areas are used as a side-effect of calling
@@ -396,9 +410,9 @@ e.g., up to one or two maps per allocation.
 
 The default value is 65536.
 
-=============================================================
 
 memory_failure_early_kill:
+==========================
 
 Control how to kill processes when uncorrected memory error (typically
 a 2bit error in a memory module) is detected in the background by hardware
@@ -424,9 +438,9 @@ check handling and depends on the hardware capabilities.
 
 Applications can override this setting individually with the PR_MCE_KILL prctl
 
-==============================================================
 
 memory_failure_recovery
+=======================
 
 Enable memory failure recovery (when supported by the platform)
 
@@ -434,9 +448,9 @@ Enable memory failure recovery (when supported by the platform)
 
 0: Always panic on a memory failure.
 
-==============================================================
 
-min_free_kbytes:
+min_free_kbytes
+===============
 
 This is used to force the Linux VM to keep a minimum number
 of kilobytes free.  The VM uses this number to compute a
@@ -450,9 +464,9 @@ become subtly broken, and prone to deadlock under high loads.
 
 Setting this too high will OOM your machine instantly.
 
-=============================================================
 
-min_slab_ratio:
+min_slab_ratio
+==============
 
 This is available only on NUMA kernels.
 
@@ -468,9 +482,9 @@ Note that slab reclaim is triggered in a per zone / node fashion.
 The process of reclaiming slab memory is currently not node specific
 and may not be fast.
 
-=============================================================
 
-min_unmapped_ratio:
+min_unmapped_ratio
+==================
 
 This is available only on NUMA kernels.
 
@@ -485,9 +499,9 @@ files and similar are considered.
 
 The default is 1 percent.
 
-==============================================================
 
 mmap_min_addr
+=============
 
 This file indicates the amount of address space  which a user process will
 be restricted from mmapping.  Since kernel null dereference bugs could
@@ -498,9 +512,9 @@ security module.  Setting this value to something like 64k will allow the
 vast majority of applications to work correctly and provide defense in depth
 against future potential kernel bugs.
 
-==============================================================
 
-mmap_rnd_bits:
+mmap_rnd_bits
+=============
 
 This value can be used to select the number of bits to use to
 determine the random offset to the base address of vma regions
@@ -511,9 +525,9 @@ by the architecture's minimum and maximum supported values.
 This value can be changed after boot using the
 /proc/sys/vm/mmap_rnd_bits tunable
 
-==============================================================
 
-mmap_rnd_compat_bits:
+mmap_rnd_compat_bits
+====================
 
 This value can be used to select the number of bits to use to
 determine the random offset to the base address of vma regions
@@ -525,35 +539,35 @@ architecture's minimum and maximum supported values.
 This value can be changed after boot using the
 /proc/sys/vm/mmap_rnd_compat_bits tunable
 
-==============================================================
 
 nr_hugepages
+============
 
 Change the minimum size of the hugepage pool.
 
 See Documentation/admin-guide/mm/hugetlbpage.rst
 
-==============================================================
 
 nr_hugepages_mempolicy
+======================
 
 Change the size of the hugepage pool at run-time on a specific
 set of NUMA nodes.
 
 See Documentation/admin-guide/mm/hugetlbpage.rst
 
-==============================================================
 
 nr_overcommit_hugepages
+=======================
 
 Change the maximum size of the hugepage pool. The maximum is
 nr_hugepages + nr_overcommit_hugepages.
 
 See Documentation/admin-guide/mm/hugetlbpage.rst
 
-==============================================================
 
 nr_trim_pages
+=============
 
 This is available only on NOMMU kernels.
 
@@ -568,16 +582,17 @@ The default value is 1.
 
 See Documentation/nommu-mmap.txt for more information.
 
-==============================================================
 
 numa_zonelist_order
+===================
 
 This sysctl is only for NUMA and it is deprecated. Anything but
 Node order will fail!
 
 'where the memory is allocated from' is controlled by zonelists.
+
 (This documentation ignores ZONE_HIGHMEM/ZONE_DMA32 for simple explanation.
- you may be able to read ZONE_DMA as ZONE_DMA32...)
+you may be able to read ZONE_DMA as ZONE_DMA32...)
 
 In non-NUMA case, a zonelist for GFP_KERNEL is ordered as following.
 ZONE_NORMAL -> ZONE_DMA
@@ -585,10 +600,10 @@ This means that a memory allocation request for GFP_KERNEL will
 get memory from ZONE_DMA only when ZONE_NORMAL is not available.
 
 In NUMA case, you can think of following 2 types of order.
-Assume 2 node NUMA and below is zonelist of Node(0)'s GFP_KERNEL
+Assume 2 node NUMA and below is zonelist of Node(0)'s GFP_KERNEL::
 
-(A) Node(0) ZONE_NORMAL -> Node(0) ZONE_DMA -> Node(1) ZONE_NORMAL
-(B) Node(0) ZONE_NORMAL -> Node(1) ZONE_NORMAL -> Node(0) ZONE_DMA.
+  (A) Node(0) ZONE_NORMAL -> Node(0) ZONE_DMA -> Node(1) ZONE_NORMAL
+  (B) Node(0) ZONE_NORMAL -> Node(1) ZONE_NORMAL -> Node(0) ZONE_DMA.
 
 Type(A) offers the best locality for processes on Node(0), but ZONE_DMA
 will be used before ZONE_NORMAL exhaustion. This increases possibility of
@@ -616,9 +631,9 @@ order will be selected.
 Default order is recommended unless this is causing problems for your
 system/application.
 
-==============================================================
 
 oom_dump_tasks
+==============
 
 Enables a system-wide task dump (excluding kernel threads) to be produced
 when the kernel performs an OOM-killing and includes such information as
@@ -638,9 +653,9 @@ OOM killer actually kills a memory-hogging task.
 
 The default value is 1 (enabled).
 
-==============================================================
 
 oom_kill_allocating_task
+========================
 
 This enables or disables killing the OOM-triggering task in
 out-of-memory situations.
@@ -659,9 +674,9 @@ is used in oom_kill_allocating_task.
 
 The default value is 0.
 
-==============================================================
 
-overcommit_kbytes:
+overcommit_kbytes
+=================
 
 When overcommit_memory is set to 2, the committed address space is not
 permitted to exceed swap plus this amount of physical RAM. See below.
@@ -670,9 +685,9 @@ Note: overcommit_kbytes is the counterpart of overcommit_ratio. Only one
 of them may be specified at a time. Setting one disables the other (which
 then appears as 0 when read).
 
-==============================================================
 
-overcommit_memory:
+overcommit_memory
+=================
 
 This value contains a flag that enables memory overcommitment.
 
@@ -695,17 +710,17 @@ The default value is 0.
 See Documentation/vm/overcommit-accounting.rst and
 mm/util.c::__vm_enough_memory() for more information.
 
-==============================================================
 
-overcommit_ratio:
+overcommit_ratio
+================
 
 When overcommit_memory is set to 2, the committed address
 space is not permitted to exceed swap plus this percentage
 of physical RAM.  See above.
 
-==============================================================
 
 page-cluster
+============
 
 page-cluster controls the number of pages up to which consecutive pages
 are read in from swap in a single attempt. This is the swap counterpart
@@ -725,9 +740,9 @@ Lower values mean lower latencies for initial faults, but at the same time
 extra faults and I/O delays for following faults if they would have been part of
 that consecutive pages readahead would have brought in.
 
-=============================================================
 
 panic_on_oom
+============
 
 This enables or disables panic on out-of-memory feature.
 
@@ -747,14 +762,16 @@ above-mentioned. Even oom happens under memory cgroup, the whole
 system panics.
 
 The default value is 0.
+
 1 and 2 are for failover of clustering. Please select either
 according to your policy of failover.
+
 panic_on_oom=2+kdump gives you very strong tool to investigate
 why oom happens. You can get snapshot.
 
-=============================================================
 
 percpu_pagelist_fraction
+========================
 
 This is the fraction of pages at most (high mark pcp->high) in each zone that
 are allocated for each per cpu page list.  The min value for this is 8.  It
@@ -770,16 +787,16 @@ The initial value is zero.  Kernel does not use this value at boot time to set
 the high water marks for each per cpu page list.  If the user writes '0' to this
 sysctl, it will revert to this default behavior.
 
-==============================================================
 
 stat_interval
+=============
 
 The time interval between which vm statistics are updated.  The default
 is 1 second.
 
-==============================================================
 
 stat_refresh
+============
 
 Any read or write (by root only) flushes all the per-cpu vm statistics
 into their global totals, for more accurate reports when testing
@@ -790,24 +807,26 @@ as 0) and "fails" with EINVAL if any are found, with a warning in dmesg.
 (At time of writing, a few stats are known sometimes to be found negative,
 with no ill effects: errors and warnings on these stats are suppressed.)
 
-==============================================================
 
 numa_stat
+=========
 
 This interface allows runtime configuration of numa statistics.
 
 When page allocation performance becomes a bottleneck and you can tolerate
 some possible tool breakage and decreased numa counter precision, you can
-do:
+do::
+
 	echo 0 > /proc/sys/vm/numa_stat
 
 When page allocation performance is not a bottleneck and you want all
-tooling to work, you can do:
+tooling to work, you can do::
+
 	echo 1 > /proc/sys/vm/numa_stat
 
-==============================================================
 
 swappiness
+==========
 
 This control is used to define how aggressive the kernel will swap
 memory pages.  Higher values will increase aggressiveness, lower values
@@ -817,9 +836,9 @@ than the high water mark in a zone.
 
 The default value is 60.
 
-==============================================================
 
 unprivileged_userfaultfd
+========================
 
 This flag controls whether unprivileged users can use the userfaultfd
 system calls.  Set this to 1 to allow unprivileged users to use the
@@ -828,9 +847,9 @@ privileged users (with SYS_CAP_PTRACE capability).
 
 The default value is 1.
 
-==============================================================
 
-- user_reserve_kbytes
+user_reserve_kbytes
+===================
 
 When overcommit_memory is set to 2, "never overcommit" mode, reserve
 min(3% of current process size, user_reserve_kbytes) of free memory.
@@ -846,10 +865,9 @@ Any subsequent attempts to execute a command will result in
 
 Changing this takes effect whenever an application requests memory.
 
-==============================================================
 
 vfs_cache_pressure
-------------------
+==================
 
 This percentage value controls the tendency of the kernel to reclaim
 the memory which is used for caching of directory and inode objects.
@@ -867,9 +885,9 @@ performance impact. Reclaim code needs to take various locks to find freeable
 directory and inode objects. With vfs_cache_pressure=1000, it will look for
 ten times more freeable objects than there are.
 
-=============================================================
 
-watermark_boost_factor:
+watermark_boost_factor
+======================
 
 This factor controls the level of reclaim when memory is being fragmented.
 It defines the percentage of the high watermark of a zone that will be
@@ -887,9 +905,9 @@ fragmentation events that occurred in the recent past. If this value is
 smaller than a pageblock then a pageblocks worth of pages will be reclaimed
 (e.g.  2MB on 64-bit x86). A boost factor of 0 will disable the feature.
 
-=============================================================
 
-watermark_scale_factor:
+watermark_scale_factor
+======================
 
 This factor controls the aggressiveness of kswapd. It defines the
 amount of memory left in a node/system before kswapd is woken up and
@@ -905,20 +923,22 @@ that the number of free pages kswapd maintains for latency reasons is
 too small for the allocation bursts occurring in the system. This knob
 can then be used to tune kswapd aggressiveness accordingly.
 
-==============================================================
 
-zone_reclaim_mode:
+zone_reclaim_mode
+=================
 
 Zone_reclaim_mode allows someone to set more or less aggressive approaches to
 reclaim memory when a zone runs out of memory. If it is set to zero then no
 zone reclaim occurs. Allocations will be satisfied from other zones / nodes
 in the system.
 
-This is value ORed together of
+This is value OR'ed together of
 
-1	= Zone reclaim on
-2	= Zone reclaim writes dirty pages out
-4	= Zone reclaim swaps pages
+=	===================================
+1	Zone reclaim on
+2	Zone reclaim writes dirty pages out
+4	Zone reclaim swaps pages
+=	===================================
 
 zone_reclaim_mode is disabled by default.  For file servers or workloads
 that benefit from having their data cached, zone_reclaim_mode should be
@@ -942,5 +962,3 @@ of other processes running on other nodes will not be affected.
 Allowing regular swap effectively restricts allocations to the local
 node unless explicitly overridden by memory policies or cpuset
 configurations.
-
-============ End of Document =================================
diff --git a/Documentation/vm/unevictable-lru.rst b/Documentation/vm/unevictable-lru.rst
index c6d94118fbcc..8ba656f37cd8 100644
--- a/Documentation/vm/unevictable-lru.rst
+++ b/Documentation/vm/unevictable-lru.rst
@@ -439,7 +439,7 @@ Compacting MLOCKED Pages
 
 The unevictable LRU can be scanned for compactable regions and the default
 behavior is to do so.  /proc/sys/vm/compact_unevictable_allowed controls
-this behavior (see Documentation/sysctl/vm.txt).  Once scanning of the
+this behavior (see Documentation/sysctl/vm.rst).  Once scanning of the
 unevictable LRU is enabled, the work of compaction is mostly handled by
 the page migration code and the same work flow as described in MIGRATING
 MLOCKED PAGES will apply.
diff --git a/kernel/panic.c b/kernel/panic.c
index 4d9f55bf7d38..e0ea74bbb41d 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -372,7 +372,7 @@ const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
 /**
  * print_tainted - return a string to represent the kernel taint state.
  *
- * For individual taint flag meanings, see Documentation/sysctl/kernel.txt
+ * For individual taint flag meanings, see Documentation/sysctl/kernel.rst
  *
  * The string is overwritten by the next call to print_tainted(),
  * but is always NULL terminated.
diff --git a/mm/swap.c b/mm/swap.c
index 607c48229a1d..83a2a15f4836 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -8,7 +8,7 @@
 /*
  * This file contains the default values for the operation of the
  * Linux VM subsystem. Fine-tuning documentation can be found in
- * Documentation/sysctl/vm.txt.
+ * Documentation/sysctl/vm.rst.
  * Started 18.12.91
  * Swap aging added 23.2.95, Stephen Tweedie.
  * Buffermem limits added 12.3.98, Rik van Riel.
-- 
2.21.0

