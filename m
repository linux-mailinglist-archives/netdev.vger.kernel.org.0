Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6D44ACB8
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 23:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730971AbfFRVGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 17:06:20 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34792 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730858AbfFRVF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 17:05:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ILFlqgqUpjtOl6bcqmzPHPRjC3sELLB/zwafC8iLyLk=; b=sFLSnVYWtxVt4ZAGcxH4SZc0Cc
        1Mjsb8jkKewfm9IaPUGyI7IeHGkSXsUkrmxiWNdiQjq3wKDA+BAivvCr1pgLD2jJ7aC1YG9CAPGYi
        o5VgVlc6ZjvHzCgFG4eQ0ePf+EMnJnqZfg4N7YlJ/XY/e5FX9k7jrz/qWb/KWqw+EAf7Z2JvrRJto
        Xg2WenvHPBfhrRZnoFPNjXCYUiCanBlAGZSafWsWpAAyx1vM7r+yqZ/DrBt9A5YdJsLbqrogFaJ4f
        x9cHHrwzmC37H4jMUqv6pqm6KSz4lnEq9tWBxyu7P3YZM8asucLCMFjjnloMcwidWe77+M4+eG1Ax
        o4wAYPyw==;
Received: from 177.133.86.196.dynamic.adsl.gvt.net.br ([177.133.86.196] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hdLIc-0006yo-8m; Tue, 18 Jun 2019 21:05:51 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hdLIZ-0002CT-UD; Tue, 18 Jun 2019 18:05:47 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        x86@kernel.org, cgroups@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        linux-rtc@vger.kernel.org, linux-video@atrey.karlin.mff.cuni.cz,
        linux-block@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH v1 11/22] docs: admin-guide: add .rst files from the main dir
Date:   Tue, 18 Jun 2019 18:05:35 -0300
Message-Id: <eae5b48cab115c83be8dd59ee99b9e45f8142134.1560891322.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1560891322.git.mchehab+samsung@kernel.org>
References: <cover.1560891322.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Those files belong to the admin guide. Add them to the
admin-guide book.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---

I had to remove the long list of maintainers got by
getpatch.pl, as it was too long. I opted to keep only the
mailing lists.

 Documentation/ABI/stable/sysfs-devices-node   |  2 +-
 Documentation/ABI/testing/procfs-diskstats    |  2 +-
 Documentation/ABI/testing/sysfs-block         |  2 +-
 .../ABI/testing/sysfs-devices-system-cpu      |  4 ++--
 Documentation/{ => admin-guide}/aoe/aoe.rst   |  4 ++--
 .../{ => admin-guide}/aoe/autoload.sh         |  1 -
 .../{ => admin-guide}/aoe/examples.rst        |  0
 Documentation/{ => admin-guide}/aoe/index.rst |  2 --
 Documentation/{ => admin-guide}/aoe/status.sh |  0
 Documentation/{ => admin-guide}/aoe/todo.rst  |  0
 .../{ => admin-guide}/aoe/udev-install.sh     |  4 ++--
 Documentation/{ => admin-guide}/aoe/udev.txt  |  8 +++----
 Documentation/{ => admin-guide}/btmrvl.rst    |  2 --
 .../cgroup-v1/blkio-controller.rst            |  0
 .../{ => admin-guide}/cgroup-v1/cgroups.rst   |  4 ++--
 .../{ => admin-guide}/cgroup-v1/cpuacct.rst   |  0
 .../{ => admin-guide}/cgroup-v1/cpusets.rst   |  2 +-
 .../{ => admin-guide}/cgroup-v1/devices.rst   |  0
 .../cgroup-v1/freezer-subsystem.rst           |  0
 .../{ => admin-guide}/cgroup-v1/hugetlb.rst   |  0
 .../{ => admin-guide}/cgroup-v1/index.rst     |  2 --
 .../cgroup-v1/memcg_test.rst                  |  4 ++--
 .../{ => admin-guide}/cgroup-v1/memory.rst    |  0
 .../{ => admin-guide}/cgroup-v1/net_cls.rst   |  0
 .../{ => admin-guide}/cgroup-v1/net_prio.rst  |  0
 .../{ => admin-guide}/cgroup-v1/pids.rst      |  0
 .../{ => admin-guide}/cgroup-v1/rdma.rst      |  0
 Documentation/admin-guide/cgroup-v2.rst       |  2 +-
 .../{ => admin-guide}/clearing-warn-once.rst  |  2 --
 Documentation/{ => admin-guide}/cpu-load.rst  |  2 --
 .../{ => admin-guide}/cputopology.rst         |  2 --
 Documentation/{ => admin-guide}/efi-stub.rst  |  2 --
 Documentation/{ => admin-guide}/highuid.rst   |  2 --
 Documentation/admin-guide/hw-vuln/l1tf.rst    |  2 +-
 Documentation/{ => admin-guide}/hw_random.rst |  2 --
 Documentation/admin-guide/index.rst           | 23 +++++++++++++++++++
 Documentation/{ => admin-guide}/iostats.rst   |  2 --
 .../admin-guide/kernel-parameters.txt         |  6 ++---
 .../kernel-per-cpu-kthreads.rst}              |  4 +---
 .../lcd-panel-cgram.rst                       |  2 --
 Documentation/{ => admin-guide}/ldm.rst       |  2 --
 .../{ => admin-guide}/lockup-watchdogs.rst    |  2 --
 .../mm/cma_debugfs.rst}                       |  2 --
 .../admin-guide/mm/numa_memory_policy.rst     |  2 +-
 Documentation/{ => admin-guide}/numastat.rst  |  4 +---
 Documentation/{ => admin-guide}/pnp.rst       |  2 --
 Documentation/{ => admin-guide}/rtc.rst       |  2 --
 Documentation/{ => admin-guide}/svga.rst      |  2 --
 .../{ => admin-guide}/video-output.rst        |  2 --
 Documentation/block/bfq-iosched.rst           |  2 +-
 Documentation/device-mapper/statistics.rst    |  4 ++--
 Documentation/driver-api/index.rst            |  2 +-
 Documentation/fb/vesafb.rst                   |  2 +-
 Documentation/filesystems/tmpfs.txt           |  2 +-
 Documentation/scheduler/sched-deadline.rst    |  2 +-
 Documentation/scheduler/sched-design-CFS.rst  |  2 +-
 Documentation/scheduler/sched-rt-group.rst    |  2 +-
 Documentation/sysctl/kernel.rst               |  2 +-
 Documentation/vm/numa.rst                     |  4 ++--
 Documentation/vm/page_migration.rst           |  2 +-
 Documentation/vm/unevictable-lru.rst          |  2 +-
 Documentation/x86/topology.rst                |  2 +-
 .../x86/x86_64/fake-numa-for-cpusets.rst      |  4 ++--
 MAINTAINERS                                   | 18 +++++++--------
 arch/arm/Kconfig                              |  2 +-
 arch/parisc/Kconfig                           |  2 +-
 arch/sh/Kconfig                               |  2 +-
 arch/sparc/Kconfig                            |  2 +-
 arch/x86/Kconfig                              |  4 ++--
 block/Kconfig                                 |  2 +-
 block/partitions/Kconfig                      |  2 +-
 drivers/char/Kconfig                          |  4 ++--
 drivers/char/hw_random/core.c                 |  2 +-
 include/linux/cgroup-defs.h                   |  2 +-
 include/linux/hw_random.h                     |  2 +-
 include/uapi/linux/bpf.h                      |  2 +-
 init/Kconfig                                  |  4 ++--
 kernel/cgroup/cpuset.c                        |  2 +-
 security/device_cgroup.c                      |  2 +-
 tools/include/uapi/linux/bpf.h                |  2 +-
 80 files changed, 94 insertions(+), 112 deletions(-)
 rename Documentation/{ => admin-guide}/aoe/aoe.rst (97%)
 rename Documentation/{ => admin-guide}/aoe/autoload.sh (99%)
 rename Documentation/{ => admin-guide}/aoe/examples.rst (100%)
 rename Documentation/{ => admin-guide}/aoe/index.rst (95%)
 rename Documentation/{ => admin-guide}/aoe/status.sh (100%)
 rename Documentation/{ => admin-guide}/aoe/todo.rst (100%)
 rename Documentation/{ => admin-guide}/aoe/udev-install.sh (92%)
 rename Documentation/{ => admin-guide}/aoe/udev.txt (91%)
 rename Documentation/{ => admin-guide}/btmrvl.rst (99%)
 rename Documentation/{ => admin-guide}/cgroup-v1/blkio-controller.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/cgroups.rst (99%)
 rename Documentation/{ => admin-guide}/cgroup-v1/cpuacct.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/cpusets.rst (99%)
 rename Documentation/{ => admin-guide}/cgroup-v1/devices.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/freezer-subsystem.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/hugetlb.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/index.rst (97%)
 rename Documentation/{ => admin-guide}/cgroup-v1/memcg_test.rst (98%)
 rename Documentation/{ => admin-guide}/cgroup-v1/memory.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/net_cls.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/net_prio.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/pids.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/rdma.rst (100%)
 rename Documentation/{ => admin-guide}/clearing-warn-once.rst (96%)
 rename Documentation/{ => admin-guide}/cpu-load.rst (99%)
 rename Documentation/{ => admin-guide}/cputopology.rst (99%)
 rename Documentation/{ => admin-guide}/efi-stub.rst (99%)
 rename Documentation/{ => admin-guide}/highuid.rst (99%)
 rename Documentation/{ => admin-guide}/hw_random.rst (99%)
 rename Documentation/{ => admin-guide}/iostats.rst (99%)
 rename Documentation/{kernel-per-CPU-kthreads.rst => admin-guide/kernel-per-cpu-kthreads.rst} (99%)
 rename Documentation/{auxdisplay => admin-guide}/lcd-panel-cgram.rst (99%)
 rename Documentation/{ => admin-guide}/ldm.rst (99%)
 rename Documentation/{ => admin-guide}/lockup-watchdogs.rst (99%)
 rename Documentation/{cma/debugfs.rst => admin-guide/mm/cma_debugfs.rst} (98%)
 rename Documentation/{ => admin-guide}/numastat.rst (93%)
 rename Documentation/{ => admin-guide}/pnp.rst (99%)
 rename Documentation/{ => admin-guide}/rtc.rst (99%)
 rename Documentation/{ => admin-guide}/svga.rst (99%)
 rename Documentation/{ => admin-guide}/video-output.rst (99%)

diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
index de1d022c0864..df8413cf1468 100644
--- a/Documentation/ABI/stable/sysfs-devices-node
+++ b/Documentation/ABI/stable/sysfs-devices-node
@@ -61,7 +61,7 @@ Date:		October 2002
 Contact:	Linux Memory Management list <linux-mm@kvack.org>
 Description:
 		The node's hit/miss statistics, in units of pages.
-		See Documentation/numastat.rst
+		See Documentation/admin-guide/numastat.rst
 
 What:		/sys/devices/system/node/nodeX/distance
 Date:		October 2002
diff --git a/Documentation/ABI/testing/procfs-diskstats b/Documentation/ABI/testing/procfs-diskstats
index 26661dd5188b..2c44b4f1b060 100644
--- a/Documentation/ABI/testing/procfs-diskstats
+++ b/Documentation/ABI/testing/procfs-diskstats
@@ -29,4 +29,4 @@ Description:
 		17 - sectors discarded
 		18 - time spent discarding
 
-		For more details refer to Documentation/iostats.rst
+		For more details refer to Documentation/admin-guide/iostats.rst
diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index d300a6b9d17c..f8c7c7126bb1 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -15,7 +15,7 @@ Description:
 		 9 - I/Os currently in progress
 		10 - time spent doing I/Os (ms)
 		11 - weighted time spent doing I/Os (ms)
-		For more details refer Documentation/iostats.rst
+		For more details refer Documentation/admin-guide/iostats.rst
 
 
 What:		/sys/block/<disk>/<part>/stat
diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 1a2653f5261f..d1aad0ea0ab9 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -34,7 +34,7 @@ Description:	CPU topology files that describe kernel limits related to
 		present: cpus that have been identified as being present in
 		the system.
 
-		See Documentation/cputopology.rst for more information.
+		See Documentation/admin-guide/cputopology.rst for more information.
 
 
 What:		/sys/devices/system/cpu/probe
@@ -103,7 +103,7 @@ Description:	CPU topology files that describe a logical CPU's relationship
 		thread_siblings_list: human-readable list of cpu#'s hardware
 		threads within the same core as cpu#
 
-		See Documentation/cputopology.rst for more information.
+		See Documentation/admin-guide/cputopology.rst for more information.
 
 
 What:		/sys/devices/system/cpu/cpuidle/current_driver
diff --git a/Documentation/aoe/aoe.rst b/Documentation/admin-guide/aoe/aoe.rst
similarity index 97%
rename from Documentation/aoe/aoe.rst
rename to Documentation/admin-guide/aoe/aoe.rst
index 58747ecec71d..a05e751363a0 100644
--- a/Documentation/aoe/aoe.rst
+++ b/Documentation/admin-guide/aoe/aoe.rst
@@ -20,7 +20,7 @@ driver.  The aoetools are on sourceforge.
 
   http://aoetools.sourceforge.net/
 
-The scripts in this Documentation/aoe directory are intended to
+The scripts in this Documentation/admin-guide/aoe directory are intended to
 document the use of the driver and are not necessary if you install
 the aoetools.
 
@@ -86,7 +86,7 @@ Using sysfs
   a convenient way.  Users with aoetools should use the aoe-stat
   command::
 
-    root@makki root# sh Documentation/aoe/status.sh
+    root@makki root# sh Documentation/admin-guide/aoe/status.sh
        e10.0            eth3              up
        e10.1            eth3              up
        e10.2            eth3              up
diff --git a/Documentation/aoe/autoload.sh b/Documentation/admin-guide/aoe/autoload.sh
similarity index 99%
rename from Documentation/aoe/autoload.sh
rename to Documentation/admin-guide/aoe/autoload.sh
index 815dff4691c9..591a58d6c3c6 100644
--- a/Documentation/aoe/autoload.sh
+++ b/Documentation/admin-guide/aoe/autoload.sh
@@ -14,4 +14,3 @@ if [ $? = 1 ]; then
 	echo alias block-major-152 aoe >> $f
 	echo alias char-major-152 aoe >> $f
 fi
-
diff --git a/Documentation/aoe/examples.rst b/Documentation/admin-guide/aoe/examples.rst
similarity index 100%
rename from Documentation/aoe/examples.rst
rename to Documentation/admin-guide/aoe/examples.rst
diff --git a/Documentation/aoe/index.rst b/Documentation/admin-guide/aoe/index.rst
similarity index 95%
rename from Documentation/aoe/index.rst
rename to Documentation/admin-guide/aoe/index.rst
index 4394b9b7913c..d71c5df15922 100644
--- a/Documentation/aoe/index.rst
+++ b/Documentation/admin-guide/aoe/index.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =======================
 ATA over Ethernet (AoE)
 =======================
diff --git a/Documentation/aoe/status.sh b/Documentation/admin-guide/aoe/status.sh
similarity index 100%
rename from Documentation/aoe/status.sh
rename to Documentation/admin-guide/aoe/status.sh
diff --git a/Documentation/aoe/todo.rst b/Documentation/admin-guide/aoe/todo.rst
similarity index 100%
rename from Documentation/aoe/todo.rst
rename to Documentation/admin-guide/aoe/todo.rst
diff --git a/Documentation/aoe/udev-install.sh b/Documentation/admin-guide/aoe/udev-install.sh
similarity index 92%
rename from Documentation/aoe/udev-install.sh
rename to Documentation/admin-guide/aoe/udev-install.sh
index 15e86f58c036..1404d629a249 100644
--- a/Documentation/aoe/udev-install.sh
+++ b/Documentation/admin-guide/aoe/udev-install.sh
@@ -1,6 +1,6 @@
-# install the aoe-specific udev rules from udev.txt into 
+# install the aoe-specific udev rules from udev.txt into
 # the system's udev configuration
-# 
+#
 
 me="`basename $0`"
 
diff --git a/Documentation/aoe/udev.txt b/Documentation/admin-guide/aoe/udev.txt
similarity index 91%
rename from Documentation/aoe/udev.txt
rename to Documentation/admin-guide/aoe/udev.txt
index 54feda5a0772..d55ecb411c21 100644
--- a/Documentation/aoe/udev.txt
+++ b/Documentation/admin-guide/aoe/udev.txt
@@ -2,7 +2,7 @@
 # They may be installed along the following lines.  Check the section
 # 8 udev manpage to see whether your udev supports SUBSYSTEM, and
 # whether it uses one or two equal signs for SUBSYSTEM and KERNEL.
-# 
+#
 #   ecashin@makki ~$ su
 #   Password:
 #   bash# find /etc -type f -name udev.conf
@@ -11,9 +11,9 @@
 #   udev_rules="/etc/udev/rules.d/"
 #   bash# ls /etc/udev/rules.d/
 #   10-wacom.rules  50-udev.rules
-#   bash# cp /path/to/linux/Documentation/aoe/udev.txt \
+#   bash# cp /path/to/linux/Documentation/admin-guide/aoe/udev.txt \
 #           /etc/udev/rules.d/60-aoe.rules
-#  
+#
 
 # aoe char devices
 SUBSYSTEM=="aoe", KERNEL=="discover",	NAME="etherd/%k", GROUP="disk", MODE="0220"
@@ -22,5 +22,5 @@ SUBSYSTEM=="aoe", KERNEL=="interfaces",	NAME="etherd/%k", GROUP="disk", MODE="02
 SUBSYSTEM=="aoe", KERNEL=="revalidate",	NAME="etherd/%k", GROUP="disk", MODE="0220"
 SUBSYSTEM=="aoe", KERNEL=="flush",	NAME="etherd/%k", GROUP="disk", MODE="0220"
 
-# aoe block devices     
+# aoe block devices
 KERNEL=="etherd*",       GROUP="disk"
diff --git a/Documentation/btmrvl.rst b/Documentation/admin-guide/btmrvl.rst
similarity index 99%
rename from Documentation/btmrvl.rst
rename to Documentation/admin-guide/btmrvl.rst
index e6dd1c96e842..ec57740ead0c 100644
--- a/Documentation/btmrvl.rst
+++ b/Documentation/admin-guide/btmrvl.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =============
 btmrvl driver
 =============
diff --git a/Documentation/cgroup-v1/blkio-controller.rst b/Documentation/admin-guide/cgroup-v1/blkio-controller.rst
similarity index 100%
rename from Documentation/cgroup-v1/blkio-controller.rst
rename to Documentation/admin-guide/cgroup-v1/blkio-controller.rst
diff --git a/Documentation/cgroup-v1/cgroups.rst b/Documentation/admin-guide/cgroup-v1/cgroups.rst
similarity index 99%
rename from Documentation/cgroup-v1/cgroups.rst
rename to Documentation/admin-guide/cgroup-v1/cgroups.rst
index 46bbe7e022d4..b0688011ed06 100644
--- a/Documentation/cgroup-v1/cgroups.rst
+++ b/Documentation/admin-guide/cgroup-v1/cgroups.rst
@@ -3,7 +3,7 @@ Control Groups
 ==============
 
 Written by Paul Menage <menage@google.com> based on
-Documentation/cgroup-v1/cpusets.rst
+Documentation/admin-guide/cgroup-v1/cpusets.rst
 
 Original copyright statements from cpusets.txt:
 
@@ -76,7 +76,7 @@ On their own, the only use for cgroups is for simple job
 tracking. The intention is that other subsystems hook into the generic
 cgroup support to provide new attributes for cgroups, such as
 accounting/limiting the resources which processes in a cgroup can
-access. For example, cpusets (see Documentation/cgroup-v1/cpusets.rst) allow
+access. For example, cpusets (see Documentation/admin-guide/cgroup-v1/cpusets.rst) allow
 you to associate a set of CPUs and a set of memory nodes with the
 tasks in each cgroup.
 
diff --git a/Documentation/cgroup-v1/cpuacct.rst b/Documentation/admin-guide/cgroup-v1/cpuacct.rst
similarity index 100%
rename from Documentation/cgroup-v1/cpuacct.rst
rename to Documentation/admin-guide/cgroup-v1/cpuacct.rst
diff --git a/Documentation/cgroup-v1/cpusets.rst b/Documentation/admin-guide/cgroup-v1/cpusets.rst
similarity index 99%
rename from Documentation/cgroup-v1/cpusets.rst
rename to Documentation/admin-guide/cgroup-v1/cpusets.rst
index b6a42cdea72b..86a6ae995d54 100644
--- a/Documentation/cgroup-v1/cpusets.rst
+++ b/Documentation/admin-guide/cgroup-v1/cpusets.rst
@@ -49,7 +49,7 @@ hooks, beyond what is already present, required to manage dynamic
 job placement on large systems.
 
 Cpusets use the generic cgroup subsystem described in
-Documentation/cgroup-v1/cgroups.rst.
+Documentation/admin-guide/cgroup-v1/cgroups.rst.
 
 Requests by a task, using the sched_setaffinity(2) system call to
 include CPUs in its CPU affinity mask, and using the mbind(2) and
diff --git a/Documentation/cgroup-v1/devices.rst b/Documentation/admin-guide/cgroup-v1/devices.rst
similarity index 100%
rename from Documentation/cgroup-v1/devices.rst
rename to Documentation/admin-guide/cgroup-v1/devices.rst
diff --git a/Documentation/cgroup-v1/freezer-subsystem.rst b/Documentation/admin-guide/cgroup-v1/freezer-subsystem.rst
similarity index 100%
rename from Documentation/cgroup-v1/freezer-subsystem.rst
rename to Documentation/admin-guide/cgroup-v1/freezer-subsystem.rst
diff --git a/Documentation/cgroup-v1/hugetlb.rst b/Documentation/admin-guide/cgroup-v1/hugetlb.rst
similarity index 100%
rename from Documentation/cgroup-v1/hugetlb.rst
rename to Documentation/admin-guide/cgroup-v1/hugetlb.rst
diff --git a/Documentation/cgroup-v1/index.rst b/Documentation/admin-guide/cgroup-v1/index.rst
similarity index 97%
rename from Documentation/cgroup-v1/index.rst
rename to Documentation/admin-guide/cgroup-v1/index.rst
index fe76d42edc11..10bf48bae0b0 100644
--- a/Documentation/cgroup-v1/index.rst
+++ b/Documentation/admin-guide/cgroup-v1/index.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ========================
 Control Groups version 1
 ========================
diff --git a/Documentation/cgroup-v1/memcg_test.rst b/Documentation/admin-guide/cgroup-v1/memcg_test.rst
similarity index 98%
rename from Documentation/cgroup-v1/memcg_test.rst
rename to Documentation/admin-guide/cgroup-v1/memcg_test.rst
index 91bd18c6a514..3f7115e07b5d 100644
--- a/Documentation/cgroup-v1/memcg_test.rst
+++ b/Documentation/admin-guide/cgroup-v1/memcg_test.rst
@@ -10,7 +10,7 @@ Because VM is getting complex (one of reasons is memcg...), memcg's behavior
 is complex. This is a document for memcg's internal behavior.
 Please note that implementation details can be changed.
 
-(*) Topics on API should be in Documentation/cgroup-v1/memory.rst)
+(*) Topics on API should be in Documentation/admin-guide/cgroup-v1/memory.rst)
 
 0. How to record usage ?
 ========================
@@ -327,7 +327,7 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
 	You can see charges have been moved by reading ``*.usage_in_bytes`` or
 	memory.stat of both A and B.
 
-	See 8.2 of Documentation/cgroup-v1/memory.rst to see what value should
+	See 8.2 of Documentation/admin-guide/cgroup-v1/memory.rst to see what value should
 	be written to move_charge_at_immigrate.
 
 9.10 Memory thresholds
diff --git a/Documentation/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
similarity index 100%
rename from Documentation/cgroup-v1/memory.rst
rename to Documentation/admin-guide/cgroup-v1/memory.rst
diff --git a/Documentation/cgroup-v1/net_cls.rst b/Documentation/admin-guide/cgroup-v1/net_cls.rst
similarity index 100%
rename from Documentation/cgroup-v1/net_cls.rst
rename to Documentation/admin-guide/cgroup-v1/net_cls.rst
diff --git a/Documentation/cgroup-v1/net_prio.rst b/Documentation/admin-guide/cgroup-v1/net_prio.rst
similarity index 100%
rename from Documentation/cgroup-v1/net_prio.rst
rename to Documentation/admin-guide/cgroup-v1/net_prio.rst
diff --git a/Documentation/cgroup-v1/pids.rst b/Documentation/admin-guide/cgroup-v1/pids.rst
similarity index 100%
rename from Documentation/cgroup-v1/pids.rst
rename to Documentation/admin-guide/cgroup-v1/pids.rst
diff --git a/Documentation/cgroup-v1/rdma.rst b/Documentation/admin-guide/cgroup-v1/rdma.rst
similarity index 100%
rename from Documentation/cgroup-v1/rdma.rst
rename to Documentation/admin-guide/cgroup-v1/rdma.rst
diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 4b971a0bc99a..125c5cc15fe7 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -9,7 +9,7 @@ This is the authoritative documentation on the design, interface and
 conventions of cgroup v2.  It describes all userland-visible aspects
 of cgroup including core and specific controller behaviors.  All
 future changes must be reflected in this document.  Documentation for
-v1 is available under Documentation/cgroup-v1/.
+v1 is available under Documentation/admin-guide/cgroup-v1/.
 
 .. CONTENTS
 
diff --git a/Documentation/clearing-warn-once.rst b/Documentation/admin-guide/clearing-warn-once.rst
similarity index 96%
rename from Documentation/clearing-warn-once.rst
rename to Documentation/admin-guide/clearing-warn-once.rst
index cdfa892c7fdf..211fd926cf00 100644
--- a/Documentation/clearing-warn-once.rst
+++ b/Documentation/admin-guide/clearing-warn-once.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 Clearing WARN_ONCE
 ------------------
 
diff --git a/Documentation/cpu-load.rst b/Documentation/admin-guide/cpu-load.rst
similarity index 99%
rename from Documentation/cpu-load.rst
rename to Documentation/admin-guide/cpu-load.rst
index 6b2815b78683..2d01ce43d2a2 100644
--- a/Documentation/cpu-load.rst
+++ b/Documentation/admin-guide/cpu-load.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ========
 CPU load
 ========
diff --git a/Documentation/cputopology.rst b/Documentation/admin-guide/cputopology.rst
similarity index 99%
rename from Documentation/cputopology.rst
rename to Documentation/admin-guide/cputopology.rst
index ef1e6b105957..b90dafcc8237 100644
--- a/Documentation/cputopology.rst
+++ b/Documentation/admin-guide/cputopology.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===========================================
 How CPU topology info is exported via sysfs
 ===========================================
diff --git a/Documentation/efi-stub.rst b/Documentation/admin-guide/efi-stub.rst
similarity index 99%
rename from Documentation/efi-stub.rst
rename to Documentation/admin-guide/efi-stub.rst
index 29256cad8af3..833edb0d0bc4 100644
--- a/Documentation/efi-stub.rst
+++ b/Documentation/admin-guide/efi-stub.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =================
 The EFI Boot Stub
 =================
diff --git a/Documentation/highuid.rst b/Documentation/admin-guide/highuid.rst
similarity index 99%
rename from Documentation/highuid.rst
rename to Documentation/admin-guide/highuid.rst
index d1cbc71a59a2..1ab59d7807d1 100644
--- a/Documentation/highuid.rst
+++ b/Documentation/admin-guide/highuid.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===================================================
 Notes on the change from 16-bit UIDs to 32-bit UIDs
 ===================================================
diff --git a/Documentation/admin-guide/hw-vuln/l1tf.rst b/Documentation/admin-guide/hw-vuln/l1tf.rst
index 5668fc2013ce..9b1e6aafea1f 100644
--- a/Documentation/admin-guide/hw-vuln/l1tf.rst
+++ b/Documentation/admin-guide/hw-vuln/l1tf.rst
@@ -241,7 +241,7 @@ Guest mitigation mechanisms
    For further information about confining guests to a single or to a group
    of cores consult the cpusets documentation:
 
-   https://www.kernel.org/doc/Documentation/cgroup-v1/cpusets.rst
+   https://www.kernel.org/doc/Documentation/admin-guide/cgroup-v1/cpusets.rst
 
 .. _interrupt_isolation:
 
diff --git a/Documentation/hw_random.rst b/Documentation/admin-guide/hw_random.rst
similarity index 99%
rename from Documentation/hw_random.rst
rename to Documentation/admin-guide/hw_random.rst
index fb5e32fae384..121de96e395e 100644
--- a/Documentation/hw_random.rst
+++ b/Documentation/admin-guide/hw_random.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ==========================================================
 Linux support for random number generator in i8xx chipsets
 ==========================================================
diff --git a/Documentation/admin-guide/index.rst b/Documentation/admin-guide/index.rst
index 8001917ee012..ba9ff8e3b45a 100644
--- a/Documentation/admin-guide/index.rst
+++ b/Documentation/admin-guide/index.rst
@@ -56,6 +56,7 @@ configure specific aspects of kernel behavior to your liking.
 
    initrd
    cgroup-v2
+   cgroup-v1/index
    serial-console
    braille-console
    parport
@@ -74,9 +75,31 @@ configure specific aspects of kernel behavior to your liking.
    thunderbolt
    LSM/index
    mm/index
+   aoe/index
    perf-security
    acpi/index
 
+   btmrvl
+   clearing-warn-once
+   cpu-load
+   cputopology
+   highuid
+   hw_random
+   ldm
+   pnp
+   rtc
+   video-output
+   efi-stub
+   iostats
+   kernel-per-cpu-kthreads
+   lcd-panel-cgram
+   lockup-watchdogs
+   mm/cma_debugfs
+   numastat
+   svga
+
+
+
 .. only::  subproject and html
 
    Indices
diff --git a/Documentation/iostats.rst b/Documentation/admin-guide/iostats.rst
similarity index 99%
rename from Documentation/iostats.rst
rename to Documentation/admin-guide/iostats.rst
index f4d37d812c30..5d63b18bd6d1 100644
--- a/Documentation/iostats.rst
+++ b/Documentation/admin-guide/iostats.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =====================
 I/O statistics fields
 =====================
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index d11b8a745897..95885726778c 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4098,7 +4098,7 @@
 
 	relax_domain_level=
 			[KNL, SMP] Set scheduler's default relax_domain_level.
-			See Documentation/cgroup-v1/cpusets.rst.
+			See Documentation/admin-guide/cgroup-v1/cpusets.rst.
 
 	reserve=	[KNL,BUGS] Force kernel to ignore I/O ports or memory
 			Format: <base1>,<size1>[,<base2>,<size2>,...]
@@ -4608,7 +4608,7 @@
 	swapaccount=[0|1]
 			[KNL] Enable accounting of swap in memory resource
 			controller if no parameter or 1 is given or disable
-			it if 0 is given (See Documentation/cgroup-v1/memory.rst)
+			it if 0 is given (See Documentation/admin-guide/cgroup-v1/memory.rst)
 
 	swiotlb=	[ARM,IA-64,PPC,MIPS,X86]
 			Format: { <int> | force | noforce }
@@ -5075,7 +5075,7 @@
 
 	vga=		[BOOT,X86-32] Select a particular video mode
 			See Documentation/x86/boot.rst and
-			Documentation/svga.rst.
+			Documentation/admin-guide/svga.rst.
 			Use vga=ask for menu.
 			This is actually a boot loader parameter; the value is
 			passed to the kernel using a special protocol.
diff --git a/Documentation/kernel-per-CPU-kthreads.rst b/Documentation/admin-guide/kernel-per-cpu-kthreads.rst
similarity index 99%
rename from Documentation/kernel-per-CPU-kthreads.rst
rename to Documentation/admin-guide/kernel-per-cpu-kthreads.rst
index 765c7b9bd7fd..d430048a0307 100644
--- a/Documentation/kernel-per-CPU-kthreads.rst
+++ b/Documentation/admin-guide/kernel-per-cpu-kthreads.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ==========================================
 Reducing OS jitter due to per-cpu kthreads
 ==========================================
@@ -14,7 +12,7 @@ References
 
 -	Documentation/IRQ-affinity.rst:  Binding interrupts to sets of CPUs.
 
--	Documentation/cgroup-v1:  Using cgroups to bind tasks to sets of CPUs.
+-	Documentation/admin-guide/cgroup-v1:  Using cgroups to bind tasks to sets of CPUs.
 
 -	man taskset:  Using the taskset command to bind tasks to sets
 	of CPUs.
diff --git a/Documentation/auxdisplay/lcd-panel-cgram.rst b/Documentation/admin-guide/lcd-panel-cgram.rst
similarity index 99%
rename from Documentation/auxdisplay/lcd-panel-cgram.rst
rename to Documentation/admin-guide/lcd-panel-cgram.rst
index dfef50286018..a3eb00c62f53 100644
--- a/Documentation/auxdisplay/lcd-panel-cgram.rst
+++ b/Documentation/admin-guide/lcd-panel-cgram.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ======================================
 Parallel port LCD/Keypad Panel support
 ======================================
diff --git a/Documentation/ldm.rst b/Documentation/admin-guide/ldm.rst
similarity index 99%
rename from Documentation/ldm.rst
rename to Documentation/admin-guide/ldm.rst
index 1e8739669541..90ccf24ebfdd 100644
--- a/Documentation/ldm.rst
+++ b/Documentation/admin-guide/ldm.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ==========================================
 LDM - Logical Disk Manager (Dynamic Disks)
 ==========================================
diff --git a/Documentation/lockup-watchdogs.rst b/Documentation/admin-guide/lockup-watchdogs.rst
similarity index 99%
rename from Documentation/lockup-watchdogs.rst
rename to Documentation/admin-guide/lockup-watchdogs.rst
index a60598bfd50f..290840c160af 100644
--- a/Documentation/lockup-watchdogs.rst
+++ b/Documentation/admin-guide/lockup-watchdogs.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===============================================================
 Softlockup detector and hardlockup detector (aka nmi_watchdog)
 ===============================================================
diff --git a/Documentation/cma/debugfs.rst b/Documentation/admin-guide/mm/cma_debugfs.rst
similarity index 98%
rename from Documentation/cma/debugfs.rst
rename to Documentation/admin-guide/mm/cma_debugfs.rst
index 518fe401b5ee..4e06ffabd78a 100644
--- a/Documentation/cma/debugfs.rst
+++ b/Documentation/admin-guide/mm/cma_debugfs.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =====================
 CMA Debugfs Interface
 =====================
diff --git a/Documentation/admin-guide/mm/numa_memory_policy.rst b/Documentation/admin-guide/mm/numa_memory_policy.rst
index 546f174e5d6a..8463f5538fda 100644
--- a/Documentation/admin-guide/mm/numa_memory_policy.rst
+++ b/Documentation/admin-guide/mm/numa_memory_policy.rst
@@ -15,7 +15,7 @@ document attempts to describe the concepts and APIs of the 2.6 memory policy
 support.
 
 Memory policies should not be confused with cpusets
-(``Documentation/cgroup-v1/cpusets.rst``)
+(``Documentation/admin-guide/cgroup-v1/cpusets.rst``)
 which is an administrative mechanism for restricting the nodes from which
 memory may be allocated by a set of processes. Memory policies are a
 programming interface that a NUMA-aware application can take advantage of.  When
diff --git a/Documentation/numastat.rst b/Documentation/admin-guide/numastat.rst
similarity index 93%
rename from Documentation/numastat.rst
rename to Documentation/admin-guide/numastat.rst
index 762925cfe882..94b7f0477f97 100644
--- a/Documentation/numastat.rst
+++ b/Documentation/admin-guide/numastat.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===============================
 Numa policy hit/miss statistics
 ===============================
@@ -22,7 +20,7 @@ local_node	A process ran on this node and got memory from it.
 
 other_node	A process ran on this node and got memory from another node.
 
-interleave_hit 	Interleaving wanted to allocate from this node
+interleave_hit	Interleaving wanted to allocate from this node
 		and succeeded.
 =============== ============================================================
 
diff --git a/Documentation/pnp.rst b/Documentation/admin-guide/pnp.rst
similarity index 99%
rename from Documentation/pnp.rst
rename to Documentation/admin-guide/pnp.rst
index ef84f35a9b47..c103acb9ad99 100644
--- a/Documentation/pnp.rst
+++ b/Documentation/admin-guide/pnp.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =================================
 Linux Plug and Play Documentation
 =================================
diff --git a/Documentation/rtc.rst b/Documentation/admin-guide/rtc.rst
similarity index 99%
rename from Documentation/rtc.rst
rename to Documentation/admin-guide/rtc.rst
index 6893bb5cf0ef..c7647de33c69 100644
--- a/Documentation/rtc.rst
+++ b/Documentation/admin-guide/rtc.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =======================================
 Real Time Clock (RTC) Drivers for Linux
 =======================================
diff --git a/Documentation/svga.rst b/Documentation/admin-guide/svga.rst
similarity index 99%
rename from Documentation/svga.rst
rename to Documentation/admin-guide/svga.rst
index 1bfd54d9fb59..b6c2f9acca92 100644
--- a/Documentation/svga.rst
+++ b/Documentation/admin-guide/svga.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 .. include:: <isonum.txt>
 
 =================================
diff --git a/Documentation/video-output.rst b/Documentation/admin-guide/video-output.rst
similarity index 99%
rename from Documentation/video-output.rst
rename to Documentation/admin-guide/video-output.rst
index 9095c4be45e5..aab623cfb2f3 100644
--- a/Documentation/video-output.rst
+++ b/Documentation/admin-guide/video-output.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 Video Output Switcher Control
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
diff --git a/Documentation/block/bfq-iosched.rst b/Documentation/block/bfq-iosched.rst
index 3fd9e8029347..6636ad2dad3f 100644
--- a/Documentation/block/bfq-iosched.rst
+++ b/Documentation/block/bfq-iosched.rst
@@ -547,7 +547,7 @@ As for cgroups-v1 (blkio controller), the exact set of stat files
 created, and kept up-to-date by bfq, depends on whether
 CONFIG_DEBUG_BLK_CGROUP is set. If it is set, then bfq creates all
 the stat files documented in
-Documentation/cgroup-v1/blkio-controller.rst. If, instead,
+Documentation/admin-guide/cgroup-v1/blkio-controller.rst. If, instead,
 CONFIG_DEBUG_BLK_CGROUP is not set, then bfq creates only the files::
 
   blkio.bfq.io_service_bytes
diff --git a/Documentation/device-mapper/statistics.rst b/Documentation/device-mapper/statistics.rst
index 39f74af35abb..41ded0bc5933 100644
--- a/Documentation/device-mapper/statistics.rst
+++ b/Documentation/device-mapper/statistics.rst
@@ -13,7 +13,7 @@ the range specified.
 
 The I/O statistics counters for each step-sized area of a region are
 in the same format as `/sys/block/*/stat` or `/proc/diskstats` (see:
-Documentation/iostats.rst).  But two extra counters (12 and 13) are
+Documentation/admin-guide/iostats.rst).  But two extra counters (12 and 13) are
 provided: total time spent reading and writing.  When the histogram
 argument is used, the 14th parameter is reported that represents the
 histogram of latencies.  All these counters may be accessed by sending
@@ -151,7 +151,7 @@ Messages
 	  The first 11 counters have the same meaning as
 	  `/sys/block/*/stat or /proc/diskstats`.
 
-	  Please refer to Documentation/iostats.rst for details.
+	  Please refer to Documentation/admin-guide/iostats.rst for details.
 
 	  1. the number of reads completed
 	  2. the number of reads merged
diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
index 0dbaa987aa11..c76a101c2a6b 100644
--- a/Documentation/driver-api/index.rst
+++ b/Documentation/driver-api/index.rst
@@ -29,8 +29,8 @@ available subsections can be seen below.
    regulator
    iio/index
    input
-   usb/index
    firewire
+   usb/index
    pci/index
    spi
    i2c
diff --git a/Documentation/fb/vesafb.rst b/Documentation/fb/vesafb.rst
index a0b658091b07..6821c87b7893 100644
--- a/Documentation/fb/vesafb.rst
+++ b/Documentation/fb/vesafb.rst
@@ -30,7 +30,7 @@ How to use it?
 ==============
 
 Switching modes is done using the vga=... boot parameter.  Read
-Documentation/svga.rst for details.
+Documentation/admin-guide/svga.rst for details.
 
 You should compile in both vgacon (for text mode) and vesafb (for
 graphics mode). Which of them takes over the console depends on
diff --git a/Documentation/filesystems/tmpfs.txt b/Documentation/filesystems/tmpfs.txt
index cad797a8a39e..5ecbc03e6b2f 100644
--- a/Documentation/filesystems/tmpfs.txt
+++ b/Documentation/filesystems/tmpfs.txt
@@ -98,7 +98,7 @@ A memory policy with a valid NodeList will be saved, as specified, for
 use at file creation time.  When a task allocates a file in the file
 system, the mount option memory policy will be applied with a NodeList,
 if any, modified by the calling task's cpuset constraints
-[See Documentation/cgroup-v1/cpusets.rst] and any optional flags, listed
+[See Documentation/admin-guide/cgroup-v1/cpusets.rst] and any optional flags, listed
 below.  If the resulting NodeLists is the empty set, the effective memory
 policy for the file will revert to "default" policy.
 
diff --git a/Documentation/scheduler/sched-deadline.rst b/Documentation/scheduler/sched-deadline.rst
index 3391e86d810c..14a2f7bf63fe 100644
--- a/Documentation/scheduler/sched-deadline.rst
+++ b/Documentation/scheduler/sched-deadline.rst
@@ -669,7 +669,7 @@ Deadline Task Scheduling
 
  -deadline tasks cannot have an affinity mask smaller that the entire
  root_domain they are created on. However, affinities can be specified
- through the cpuset facility (Documentation/cgroup-v1/cpusets.rst).
+ through the cpuset facility (Documentation/admin-guide/cgroup-v1/cpusets.rst).
 
 5.1 SCHED_DEADLINE and cpusets HOWTO
 ------------------------------------
diff --git a/Documentation/scheduler/sched-design-CFS.rst b/Documentation/scheduler/sched-design-CFS.rst
index 53b30d1967cf..a96c72651877 100644
--- a/Documentation/scheduler/sched-design-CFS.rst
+++ b/Documentation/scheduler/sched-design-CFS.rst
@@ -222,7 +222,7 @@ SCHED_BATCH) tasks.
 
    These options need CONFIG_CGROUPS to be defined, and let the administrator
    create arbitrary groups of tasks, using the "cgroup" pseudo filesystem.  See
-   Documentation/cgroup-v1/cgroups.rst for more information about this filesystem.
+   Documentation/admin-guide/cgroup-v1/cgroups.rst for more information about this filesystem.
 
 When CONFIG_FAIR_GROUP_SCHED is defined, a "cpu.shares" file is created for each
 group created using the pseudo filesystem.  See example steps below to create
diff --git a/Documentation/scheduler/sched-rt-group.rst b/Documentation/scheduler/sched-rt-group.rst
index d27d3f3712fd..655a096ec8fb 100644
--- a/Documentation/scheduler/sched-rt-group.rst
+++ b/Documentation/scheduler/sched-rt-group.rst
@@ -133,7 +133,7 @@ This uses the cgroup virtual file system and "<cgroup>/cpu.rt_runtime_us"
 to control the CPU time reserved for each control group.
 
 For more information on working with control groups, you should read
-Documentation/cgroup-v1/cgroups.rst as well.
+Documentation/admin-guide/cgroup-v1/cgroups.rst as well.
 
 Group settings are checked against the following limits in order to keep the
 configuration schedulable:
diff --git a/Documentation/sysctl/kernel.rst b/Documentation/sysctl/kernel.rst
index 29a5bbca9bee..9324c3b1aa3e 100644
--- a/Documentation/sysctl/kernel.rst
+++ b/Documentation/sysctl/kernel.rst
@@ -343,7 +343,7 @@ when a hard lockup is detected.
    0 - don't panic on hard lockup
    1 - panic on hard lockup
 
-See Documentation/lockup-watchdogs.rst for more information.  This can
+See Documentation/admin-guide/lockup-watchdogs.rst for more information.  This can
 also be set using the nmi_watchdog kernel parameter.
 
 
diff --git a/Documentation/vm/numa.rst b/Documentation/vm/numa.rst
index 130f3cfa1c19..99fdeca917ca 100644
--- a/Documentation/vm/numa.rst
+++ b/Documentation/vm/numa.rst
@@ -67,7 +67,7 @@ nodes.  Each emulated node will manage a fraction of the underlying cells'
 physical memory.  NUMA emluation is useful for testing NUMA kernel and
 application features on non-NUMA platforms, and as a sort of memory resource
 management mechanism when used together with cpusets.
-[see Documentation/cgroup-v1/cpusets.rst]
+[see Documentation/admin-guide/cgroup-v1/cpusets.rst]
 
 For each node with memory, Linux constructs an independent memory management
 subsystem, complete with its own free page lists, in-use page lists, usage
@@ -114,7 +114,7 @@ allocation behavior using Linux NUMA memory policy. [see
 
 System administrators can restrict the CPUs and nodes' memories that a non-
 privileged user can specify in the scheduling or NUMA commands and functions
-using control groups and CPUsets.  [see Documentation/cgroup-v1/cpusets.rst]
+using control groups and CPUsets.  [see Documentation/admin-guide/cgroup-v1/cpusets.rst]
 
 On architectures that do not hide memoryless nodes, Linux will include only
 zones [nodes] with memory in the zonelists.  This means that for a memoryless
diff --git a/Documentation/vm/page_migration.rst b/Documentation/vm/page_migration.rst
index 35bba27d5fff..1d6cd7db4e43 100644
--- a/Documentation/vm/page_migration.rst
+++ b/Documentation/vm/page_migration.rst
@@ -41,7 +41,7 @@ locations.
 Larger installations usually partition the system using cpusets into
 sections of nodes. Paul Jackson has equipped cpusets with the ability to
 move pages when a task is moved to another cpuset (See
-Documentation/cgroup-v1/cpusets.rst).
+Documentation/admin-guide/cgroup-v1/cpusets.rst).
 Cpusets allows the automation of process locality. If a task is moved to
 a new cpuset then also all its pages are moved with it so that the
 performance of the process does not sink dramatically. Also the pages
diff --git a/Documentation/vm/unevictable-lru.rst b/Documentation/vm/unevictable-lru.rst
index 8ba656f37cd8..997dfbf13b99 100644
--- a/Documentation/vm/unevictable-lru.rst
+++ b/Documentation/vm/unevictable-lru.rst
@@ -98,7 +98,7 @@ Memory Control Group Interaction
 --------------------------------
 
 The unevictable LRU facility interacts with the memory control group [aka
-memory controller; see Documentation/cgroup-v1/memory.rst] by extending the
+memory controller; see Documentation/admin-guide/cgroup-v1/memory.rst] by extending the
 lru_list enum.
 
 The memory controller data structure automatically gets a per-zone unevictable
diff --git a/Documentation/x86/topology.rst b/Documentation/x86/topology.rst
index b06d895becce..e29739904e37 100644
--- a/Documentation/x86/topology.rst
+++ b/Documentation/x86/topology.rst
@@ -9,7 +9,7 @@ representation in the kernel. Update/change when doing changes to the
 respective code.
 
 The architecture-agnostic topology definitions are in
-Documentation/cputopology.rst. This file holds x86-specific
+Documentation/admin-guide/cputopology.rst. This file holds x86-specific
 differences/specialities which must not necessarily apply to the generic
 definitions. Thus, the way to read up on Linux topology on x86 is to start
 with the generic one and look at this one in parallel for the x86 specifics.
diff --git a/Documentation/x86/x86_64/fake-numa-for-cpusets.rst b/Documentation/x86/x86_64/fake-numa-for-cpusets.rst
index 30108684ae87..ff9bcfd2cc14 100644
--- a/Documentation/x86/x86_64/fake-numa-for-cpusets.rst
+++ b/Documentation/x86/x86_64/fake-numa-for-cpusets.rst
@@ -15,7 +15,7 @@ assign them to cpusets and their attached tasks.  This is a way of limiting the
 amount of system memory that are available to a certain class of tasks.
 
 For more information on the features of cpusets, see
-Documentation/cgroup-v1/cpusets.rst.
+Documentation/admin-guide/cgroup-v1/cpusets.rst.
 There are a number of different configurations you can use for your needs.  For
 more information on the numa=fake command line option and its various ways of
 configuring fake nodes, see Documentation/x86/x86_64/boot-options.rst.
@@ -40,7 +40,7 @@ A machine may be split as follows with "numa=fake=4*512," as reported by dmesg::
 	On node 3 totalpages: 131072
 
 Now following the instructions for mounting the cpusets filesystem from
-Documentation/cgroup-v1/cpusets.rst, you can assign fake nodes (i.e. contiguous memory
+Documentation/admin-guide/cgroup-v1/cpusets.rst, you can assign fake nodes (i.e. contiguous memory
 address spaces) to individual cpusets::
 
 	[root@xroads /]# mkdir exampleset
diff --git a/MAINTAINERS b/MAINTAINERS
index d850d7f15a38..98723afdbf0b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2651,7 +2651,7 @@ ATA OVER ETHERNET (AOE) DRIVER
 M:	"Justin Sanders" <justin@coraid.com>
 W:	http://www.openaoe.org/
 S:	Supported
-F:	Documentation/aoe/
+F:	Documentation/admin-guide/aoe/
 F:	drivers/block/aoe/
 
 ATHEROS 71XX/9XXX GPIO DRIVER
@@ -4105,7 +4105,7 @@ L:	cgroups@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 S:	Maintained
 F:	Documentation/admin-guide/cgroup-v2.rst
-F:	Documentation/cgroup-v1/
+F:	Documentation/admin-guide/cgroup-v1/
 F:	include/linux/cgroup*
 F:	kernel/cgroup/
 
@@ -4116,7 +4116,7 @@ W:	http://www.bullopensource.org/cpuset/
 W:	http://oss.sgi.com/projects/cpusets/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 S:	Maintained
-F:	Documentation/cgroup-v1/cpusets.rst
+F:	Documentation/admin-guide/cgroup-v1/cpusets.rst
 F:	include/linux/cpuset.h
 F:	kernel/cgroup/cpuset.c
 
@@ -6038,7 +6038,7 @@ M:	Ard Biesheuvel <ard.biesheuvel@linaro.org>
 L:	linux-efi@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git
 S:	Maintained
-F:	Documentation/efi-stub.rst
+F:	Documentation/admin-guide/efi-stub.rst
 F:	arch/*/kernel/efi.c
 F:	arch/x86/boot/compressed/eboot.[ch]
 F:	arch/*/include/asm/efi.h
@@ -7006,7 +7006,7 @@ M:	Herbert Xu <herbert@gondor.apana.org.au>
 L:	linux-crypto@vger.kernel.org
 S:	Odd fixes
 F:	Documentation/devicetree/bindings/rng/
-F:	Documentation/hw_random.rst
+F:	Documentation/admin-guide/hw_random.rst
 F:	drivers/char/hw_random/
 F:	include/linux/hw_random.h
 
@@ -9296,7 +9296,7 @@ M:	"Richard Russon (FlatCap)" <ldm@flatcap.org>
 L:	linux-ntfs-dev@lists.sourceforge.net
 W:	http://www.linux-ntfs.org/content/view/19/37/
 S:	Maintained
-F:	Documentation/ldm.rst
+F:	Documentation/admin-guide/ldm.rst
 F:	block/partitions/ldm.*
 
 LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
@@ -11935,7 +11935,7 @@ PARALLEL LCD/KEYPAD PANEL DRIVER
 M:	Willy Tarreau <willy@haproxy.com>
 M:	Ksenija Stanojevic <ksenija.stanojevic@gmail.com>
 S:	Odd Fixes
-F:	Documentation/auxdisplay/lcd-panel-cgram.rst
+F:	Documentation/admin-guide/lcd-panel-cgram.rst
 F:	drivers/auxdisplay/panel.c
 
 PARALLEL PORT SUBSYSTEM
@@ -13354,7 +13354,7 @@ Q:	http://patchwork.ozlabs.org/project/rtc-linux/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/abelloni/linux.git
 S:	Maintained
 F:	Documentation/devicetree/bindings/rtc/
-F:	Documentation/rtc.rst
+F:	Documentation/admin-guide/rtc.rst
 F:	drivers/rtc/
 F:	include/linux/rtc.h
 F:	include/uapi/linux/rtc.h
@@ -15174,7 +15174,7 @@ SVGA HANDLING
 M:	Martin Mares <mj@ucw.cz>
 L:	linux-video@atrey.karlin.mff.cuni.cz
 S:	Maintained
-F:	Documentation/svga.rst
+F:	Documentation/admin-guide/svga.rst
 F:	arch/x86/boot/video*
 
 SWIOTLB SUBSYSTEM
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2d0a14a4286c..ff0e247573d8 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1266,7 +1266,7 @@ config SMP
 	  will run faster if you say N here.
 
 	  See also <file:Documentation/x86/i386/IO-APIC.rst>,
-	  <file:Documentation/lockup-watchdogs.rst> and the SMP-HOWTO available at
+	  <file:Documentation/admin-guide/lockup-watchdogs.rst> and the SMP-HOWTO available at
 	  <http://tldp.org/HOWTO/SMP-HOWTO.html>.
 
 	  If you don't know what to do here, say N.
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 188fdf4f5080..071640ecafea 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -275,7 +275,7 @@ config SMP
 	  machines, but will use only one CPU of a multiprocessor machine.
 	  On a uniprocessor machine, the kernel will run faster if you say N.
 
-	  See also <file:Documentation/lockup-watchdogs.rst> and the SMP-HOWTO
+	  See also <file:Documentation/admin-guide/lockup-watchdogs.rst> and the SMP-HOWTO
 	  available at <http://www.tldp.org/docs.html#howto>.
 
 	  If you don't know what to do here, say N.
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 669adef94507..7440639510a0 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -677,7 +677,7 @@ config SMP
 	  People using multiprocessor machines who say Y here should also say
 	  Y to "Enhanced Real Time Clock Support", below.
 
-	  See also <file:Documentation/lockup-watchdogs.rst> and the SMP-HOWTO
+	  See also <file:Documentation/admin-guide/lockup-watchdogs.rst> and the SMP-HOWTO
 	  available at <http://www.tldp.org/docs.html#howto>.
 
 	  If you don't know what to do here, say N.
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 04a3b2246a2a..6a31f240840d 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -179,7 +179,7 @@ config SMP
 	  Y to "Enhanced Real Time Clock Support", below. The "Advanced Power
 	  Management" code will be disabled if you say Y here.
 
-	  See also <file:Documentation/lockup-watchdogs.rst> and the SMP-HOWTO
+	  See also <file:Documentation/admin-guide/lockup-watchdogs.rst> and the SMP-HOWTO
 	  available at <http://www.tldp.org/docs.html#howto>.
 
 	  If you don't know what to do here, say N.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0d5f0710347c..586dd3529d14 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -397,7 +397,7 @@ config SMP
 	  Management" code will be disabled if you say Y here.
 
 	  See also <file:Documentation/x86/i386/IO-APIC.rst>,
-	  <file:Documentation/lockup-watchdogs.rst> and the SMP-HOWTO available at
+	  <file:Documentation/admin-guide/lockup-watchdogs.rst> and the SMP-HOWTO available at
 	  <http://www.tldp.org/docs.html#howto>.
 
 	  If you don't know what to do here, say N.
@@ -1954,7 +1954,7 @@ config EFI_STUB
           This kernel feature allows a bzImage to be loaded directly
 	  by EFI firmware without the use of a bootloader.
 
-	  See Documentation/efi-stub.rst for more information.
+	  See Documentation/admin-guide/efi-stub.rst for more information.
 
 config EFI_MIXED
 	bool "EFI mixed-mode support"
diff --git a/block/Kconfig b/block/Kconfig
index b16b3e075d31..8b5f8e560eb4 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -89,7 +89,7 @@ config BLK_DEV_THROTTLING
 	one needs to mount and use blkio cgroup controller for creating
 	cgroups and specifying per device IO rate policies.
 
-	See Documentation/cgroup-v1/blkio-controller.rst for more information.
+	See Documentation/admin-guide/cgroup-v1/blkio-controller.rst for more information.
 
 config BLK_DEV_THROTTLING_LOW
 	bool "Block throttling .low limit interface support (EXPERIMENTAL)"
diff --git a/block/partitions/Kconfig b/block/partitions/Kconfig
index 51b28e1e225d..702689a628f0 100644
--- a/block/partitions/Kconfig
+++ b/block/partitions/Kconfig
@@ -194,7 +194,7 @@ config LDM_PARTITION
 	  Normal partitions are now called Basic Disks under Windows 2000, XP,
 	  and Vista.
 
-	  For a fuller description read <file:Documentation/ldm.rst>.
+	  For a fuller description read <file:Documentation/admin-guide/ldm.rst>.
 
 	  If unsure, say N.
 
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index ba90034f5b8f..3a0f94929814 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -291,7 +291,7 @@ config RTC
 	  and set the RTC in an SMP compatible fashion.
 
 	  If you think you have a use for such a device (such as periodic data
-	  sampling), then say Y here, and read <file:Documentation/rtc.rst>
+	  sampling), then say Y here, and read <file:Documentation/admin-guide/rtc.rst>
 	  for details.
 
 	  To compile this driver as a module, choose M here: the
@@ -313,7 +313,7 @@ config JS_RTC
 	  /dev/rtc.
 
 	  If you think you have a use for such a device (such as periodic data
-	  sampling), then say Y here, and read <file:Documentation/rtc.rst>
+	  sampling), then say Y here, and read <file:Documentation/admin-guide/rtc.rst>
 	  for details.
 
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 41acde92bedc..9044d31ab1a1 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -4,7 +4,7 @@
  * Copyright 2006 Michael Buesch <m@bues.ch>
  * Copyright 2005 (c) MontaVista Software, Inc.
  *
- * Please read Documentation/hw_random.rst for details on use.
+ * Please read Documentation/admin-guide/hw_random.rst for details on use.
  *
  * This software may be used and distributed according to the terms
  * of the GNU General Public License, incorporated herein by reference.
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index c5311935239d..430e219e3aba 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -624,7 +624,7 @@ struct cftype {
 
 /*
  * Control Group subsystem type.
- * See Documentation/cgroup-v1/cgroups.rst for details
+ * See Documentation/admin-guide/cgroup-v1/cgroups.rst for details
  */
 struct cgroup_subsys {
 	struct cgroup_subsys_state *(*css_alloc)(struct cgroup_subsys_state *parent_css);
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index e533eac9942b..8e6dd908da21 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -1,7 +1,7 @@
 /*
 	Hardware Random Number Generator
 
-	Please read Documentation/hw_random.rst for details on use.
+	Please read Documentation/admin-guide/hw_random.rst for details on use.
 
 	----------------------------------------------------------
 	This software may be used and distributed according to the terms
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 19d9ee7e0518..c2fa3dc1d167 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -803,7 +803,7 @@ union bpf_attr {
  * 		based on a user-provided identifier for all traffic coming from
  * 		the tasks belonging to the related cgroup. See also the related
  * 		kernel documentation, available from the Linux sources in file
- * 		*Documentation/cgroup-v1/net_cls.rst*.
+ * 		*Documentation/admin-guide/cgroup-v1/net_cls.rst*.
  *
  * 		The Linux kernel has two versions for cgroups: there are
  * 		cgroups v1 and cgroups v2. Both are available to users, who can
diff --git a/init/Kconfig b/init/Kconfig
index 501126df6336..e02cfae73ce5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -735,7 +735,7 @@ menuconfig CGROUPS
 	  controls or device isolation.
 	  See
 		- Documentation/scheduler/sched-design-CFS.rst	(CFS)
-		- Documentation/cgroup-v1/ (features for grouping, isolation
+		- Documentation/admin-guide/cgroup-v1/ (features for grouping, isolation
 					  and resource control)
 
 	  Say N if unsure.
@@ -797,7 +797,7 @@ config BLK_CGROUP
 	CONFIG_CFQ_GROUP_IOSCHED=y; for enabling throttling policy, set
 	CONFIG_BLK_DEV_THROTTLING=y.
 
-	See Documentation/cgroup-v1/blkio-controller.rst for more information.
+	See Documentation/admin-guide/cgroup-v1/blkio-controller.rst for more information.
 
 config DEBUG_BLK_CGROUP
 	bool "IO controller debugging"
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b3b02b9c4405..863e434a6020 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -729,7 +729,7 @@ static inline int nr_cpusets(void)
  * load balancing domains (sched domains) as specified by that partial
  * partition.
  *
- * See "What is sched_load_balance" in Documentation/cgroup-v1/cpusets.rst
+ * See "What is sched_load_balance" in Documentation/admin-guide/cgroup-v1/cpusets.rst
  * for a background explanation of this.
  *
  * Does not return errors, on the theory that the callers of this
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index c07196502577..725674f3276d 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -509,7 +509,7 @@ static inline int may_allow_all(struct dev_cgroup *parent)
  * This is one of the three key functions for hierarchy implementation.
  * This function is responsible for re-evaluating all the cgroup's active
  * exceptions due to a parent's exception change.
- * Refer to Documentation/cgroup-v1/devices.rst for more details.
+ * Refer to Documentation/admin-guide/cgroup-v1/devices.rst for more details.
  */
 static void revalidate_active_exceptions(struct dev_cgroup *devcg)
 {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 19d9ee7e0518..c2fa3dc1d167 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -803,7 +803,7 @@ union bpf_attr {
  * 		based on a user-provided identifier for all traffic coming from
  * 		the tasks belonging to the related cgroup. See also the related
  * 		kernel documentation, available from the Linux sources in file
- * 		*Documentation/cgroup-v1/net_cls.rst*.
+ * 		*Documentation/admin-guide/cgroup-v1/net_cls.rst*.
  *
  * 		The Linux kernel has two versions for cgroups: there are
  * 		cgroups v1 and cgroups v2. Both are available to users, who can
-- 
2.21.0

