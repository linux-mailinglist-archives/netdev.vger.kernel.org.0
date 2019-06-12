Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 121F642DFC
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 19:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403804AbfFLRzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 13:55:24 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40552 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388145AbfFLRxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 13:53:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=w1AS1+Iwm02H8W2qW8NqsfYTfcGuYp+sbFrImOkbcXo=; b=B4NLjzALuPAB6v2eWnOsROdxMP
        biwbZuVZqeBS+yOxDTto0lH6k1w3ZqWNgAZyDEJmCVVYMmkSKdpalawhAeW5xslWSxYqFxP5JZlFV
        lT7xMypvu4gDmVuRwONyOVj1ExxE6OuP1mUfdPRSpda1dQ49OprOvR3+csuBxlvVWEvouslKhZsw/
        YXylmg9VrBqnCC+6BE6MS8p9gNDLqY2AWv+hqdQtM4s/6g1NO2j5jVT/4mKojTbFM8MStCWCu+2Rz
        8khoKTlI0ziu2fj0iOEUrhR2Tj+Jbbr6aveqx+Y6EsbzR3rSFJaqdznoo73Xl91EFklNd6XDtsiJ6
        5542z5SQ==;
Received: from 201.86.169.251.dynamic.adsl.gvt.net.br ([201.86.169.251] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hb7Qt-0002Df-37; Wed, 12 Jun 2019 17:53:13 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hb7Qq-0001fx-2Y; Wed, 12 Jun 2019 14:53:08 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-block@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH v4 05/28] docs: cgroup-v1: convert docs to ReST and rename to *.rst
Date:   Wed, 12 Jun 2019 14:52:41 -0300
Message-Id: <c1dd623359f44f05863456b8bceba0d8f3e42f38.1560361364.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1560361364.git.mchehab+samsung@kernel.org>
References: <cover.1560361364.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the cgroup-v1 files to ReST format, in order to
allow a later addition to the admin-guide.

The conversion is actually:
  - add blank lines and identation in order to identify paragraphs;
  - fix tables markups;
  - add some lists markups;
  - mark literal blocks;
  - adjust title markups.

At its new index.rst, let's add a :orphan: while this is not linked to
the main index.rst file, in order to avoid build warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
---
 Documentation/admin-guide/hw-vuln/l1tf.rst    |   2 +-
 .../admin-guide/kernel-parameters.txt         |   4 +-
 .../admin-guide/mm/numa_memory_policy.rst     |   2 +-
 Documentation/block/bfq-iosched.txt           |   2 +-
 ...io-controller.txt => blkio-controller.rst} |  96 ++--
 .../cgroup-v1/{cgroups.txt => cgroups.rst}    | 184 +++----
 .../cgroup-v1/{cpuacct.txt => cpuacct.rst}    |  15 +-
 .../cgroup-v1/{cpusets.txt => cpusets.rst}    | 205 ++++----
 .../cgroup-v1/{devices.txt => devices.rst}    |  40 +-
 ...er-subsystem.txt => freezer-subsystem.rst} |  14 +-
 .../cgroup-v1/{hugetlb.txt => hugetlb.rst}    |  39 +-
 Documentation/cgroup-v1/index.rst             |  30 ++
 .../{memcg_test.txt => memcg_test.rst}        | 263 ++++++----
 .../cgroup-v1/{memory.txt => memory.rst}      | 449 +++++++++++-------
 .../cgroup-v1/{net_cls.txt => net_cls.rst}    |  37 +-
 .../cgroup-v1/{net_prio.txt => net_prio.rst}  |  24 +-
 .../cgroup-v1/{pids.txt => pids.rst}          |  78 +--
 .../cgroup-v1/{rdma.txt => rdma.rst}          |  66 +--
 Documentation/filesystems/tmpfs.txt           |   2 +-
 Documentation/scheduler/sched-deadline.txt    |   2 +-
 Documentation/scheduler/sched-design-CFS.txt  |   2 +-
 Documentation/scheduler/sched-rt-group.txt    |   2 +-
 Documentation/vm/numa.rst                     |   4 +-
 Documentation/vm/page_migration.rst           |   2 +-
 Documentation/vm/unevictable-lru.rst          |   2 +-
 .../x86/x86_64/fake-numa-for-cpusets.rst      |   4 +-
 MAINTAINERS                                   |   2 +-
 block/Kconfig                                 |   2 +-
 include/linux/cgroup-defs.h                   |   2 +-
 include/uapi/linux/bpf.h                      |   2 +-
 init/Kconfig                                  |   2 +-
 kernel/cgroup/cpuset.c                        |   2 +-
 security/device_cgroup.c                      |   2 +-
 tools/include/uapi/linux/bpf.h                |   2 +-
 34 files changed, 952 insertions(+), 634 deletions(-)
 rename Documentation/cgroup-v1/{blkio-controller.txt => blkio-controller.rst} (90%)
 rename Documentation/cgroup-v1/{cgroups.txt => cgroups.rst} (88%)
 rename Documentation/cgroup-v1/{cpuacct.txt => cpuacct.rst} (90%)
 rename Documentation/cgroup-v1/{cpusets.txt => cpusets.rst} (90%)
 rename Documentation/cgroup-v1/{devices.txt => devices.rst} (88%)
 rename Documentation/cgroup-v1/{freezer-subsystem.txt => freezer-subsystem.rst} (95%)
 rename Documentation/cgroup-v1/{hugetlb.txt => hugetlb.rst} (70%)
 create mode 100644 Documentation/cgroup-v1/index.rst
 rename Documentation/cgroup-v1/{memcg_test.txt => memcg_test.rst} (62%)
 rename Documentation/cgroup-v1/{memory.txt => memory.rst} (71%)
 rename Documentation/cgroup-v1/{net_cls.txt => net_cls.rst} (50%)
 rename Documentation/cgroup-v1/{net_prio.txt => net_prio.rst} (71%)
 rename Documentation/cgroup-v1/{pids.txt => pids.rst} (62%)
 rename Documentation/cgroup-v1/{rdma.txt => rdma.rst} (79%)

diff --git a/Documentation/admin-guide/hw-vuln/l1tf.rst b/Documentation/admin-guide/hw-vuln/l1tf.rst
index 31653a9f0e1b..656aee262e23 100644
--- a/Documentation/admin-guide/hw-vuln/l1tf.rst
+++ b/Documentation/admin-guide/hw-vuln/l1tf.rst
@@ -241,7 +241,7 @@ Guest mitigation mechanisms
    For further information about confining guests to a single or to a group
    of cores consult the cpusets documentation:
 
-   https://www.kernel.org/doc/Documentation/cgroup-v1/cpusets.txt
+   https://www.kernel.org/doc/Documentation/cgroup-v1/cpusets.rst
 
 .. _interrupt_isolation:
 
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 15adc097d510..83e64d779887 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4098,7 +4098,7 @@
 
 	relax_domain_level=
 			[KNL, SMP] Set scheduler's default relax_domain_level.
-			See Documentation/cgroup-v1/cpusets.txt.
+			See Documentation/cgroup-v1/cpusets.rst.
 
 	reserve=	[KNL,BUGS] Force kernel to ignore I/O ports or memory
 			Format: <base1>,<size1>[,<base2>,<size2>,...]
@@ -4608,7 +4608,7 @@
 	swapaccount=[0|1]
 			[KNL] Enable accounting of swap in memory resource
 			controller if no parameter or 1 is given or disable
-			it if 0 is given (See Documentation/cgroup-v1/memory.txt)
+			it if 0 is given (See Documentation/cgroup-v1/memory.rst)
 
 	swiotlb=	[ARM,IA-64,PPC,MIPS,X86]
 			Format: { <int> | force | noforce }
diff --git a/Documentation/admin-guide/mm/numa_memory_policy.rst b/Documentation/admin-guide/mm/numa_memory_policy.rst
index d78c5b315f72..546f174e5d6a 100644
--- a/Documentation/admin-guide/mm/numa_memory_policy.rst
+++ b/Documentation/admin-guide/mm/numa_memory_policy.rst
@@ -15,7 +15,7 @@ document attempts to describe the concepts and APIs of the 2.6 memory policy
 support.
 
 Memory policies should not be confused with cpusets
-(``Documentation/cgroup-v1/cpusets.txt``)
+(``Documentation/cgroup-v1/cpusets.rst``)
 which is an administrative mechanism for restricting the nodes from which
 memory may be allocated by a set of processes. Memory policies are a
 programming interface that a NUMA-aware application can take advantage of.  When
diff --git a/Documentation/block/bfq-iosched.txt b/Documentation/block/bfq-iosched.txt
index 1a0f2ac02eb6..b2265cf6c9c3 100644
--- a/Documentation/block/bfq-iosched.txt
+++ b/Documentation/block/bfq-iosched.txt
@@ -539,7 +539,7 @@ As for cgroups-v1 (blkio controller), the exact set of stat files
 created, and kept up-to-date by bfq, depends on whether
 CONFIG_DEBUG_BLK_CGROUP is set. If it is set, then bfq creates all
 the stat files documented in
-Documentation/cgroup-v1/blkio-controller.txt. If, instead,
+Documentation/cgroup-v1/blkio-controller.rst. If, instead,
 CONFIG_DEBUG_BLK_CGROUP is not set, then bfq creates only the files
 blkio.bfq.io_service_bytes
 blkio.bfq.io_service_bytes_recursive
diff --git a/Documentation/cgroup-v1/blkio-controller.txt b/Documentation/cgroup-v1/blkio-controller.rst
similarity index 90%
rename from Documentation/cgroup-v1/blkio-controller.txt
rename to Documentation/cgroup-v1/blkio-controller.rst
index 673dc34d3f78..2c1b907afc14 100644
--- a/Documentation/cgroup-v1/blkio-controller.txt
+++ b/Documentation/cgroup-v1/blkio-controller.rst
@@ -1,5 +1,7 @@
-				Block IO Controller
-				===================
+===================
+Block IO Controller
+===================
+
 Overview
 ========
 cgroup subsys "blkio" implements the block io controller. There seems to be
@@ -22,28 +24,35 @@ Proportional Weight division of bandwidth
 You can do a very simple testing of running two dd threads in two different
 cgroups. Here is what you can do.
 
-- Enable Block IO controller
+- Enable Block IO controller::
+
 	CONFIG_BLK_CGROUP=y
 
-- Enable group scheduling in CFQ
+- Enable group scheduling in CFQ:
+
+
 	CONFIG_CFQ_GROUP_IOSCHED=y
 
 - Compile and boot into kernel and mount IO controller (blkio); see
   cgroups.txt, Why are cgroups needed?.
 
+  ::
+
 	mount -t tmpfs cgroup_root /sys/fs/cgroup
 	mkdir /sys/fs/cgroup/blkio
 	mount -t cgroup -o blkio none /sys/fs/cgroup/blkio
 
-- Create two cgroups
+- Create two cgroups::
+
 	mkdir -p /sys/fs/cgroup/blkio/test1/ /sys/fs/cgroup/blkio/test2
 
-- Set weights of group test1 and test2
+- Set weights of group test1 and test2::
+
 	echo 1000 > /sys/fs/cgroup/blkio/test1/blkio.weight
 	echo 500 > /sys/fs/cgroup/blkio/test2/blkio.weight
 
 - Create two same size files (say 512MB each) on same disk (file1, file2) and
-  launch two dd threads in different cgroup to read those files.
+  launch two dd threads in different cgroup to read those files::
 
 	sync
 	echo 3 > /proc/sys/vm/drop_caches
@@ -65,24 +74,27 @@ cgroups. Here is what you can do.
 
 Throttling/Upper Limit policy
 -----------------------------
-- Enable Block IO controller
+- Enable Block IO controller::
+
 	CONFIG_BLK_CGROUP=y
 
-- Enable throttling in block layer
+- Enable throttling in block layer::
+
 	CONFIG_BLK_DEV_THROTTLING=y
 
-- Mount blkio controller (see cgroups.txt, Why are cgroups needed?)
+- Mount blkio controller (see cgroups.txt, Why are cgroups needed?)::
+
         mount -t cgroup -o blkio none /sys/fs/cgroup/blkio
 
 - Specify a bandwidth rate on particular device for root group. The format
-  for policy is "<major>:<minor>  <bytes_per_second>".
+  for policy is "<major>:<minor>  <bytes_per_second>"::
 
         echo "8:16  1048576" > /sys/fs/cgroup/blkio/blkio.throttle.read_bps_device
 
   Above will put a limit of 1MB/second on reads happening for root group
   on device having major/minor number 8:16.
 
-- Run dd to read a file and see if rate is throttled to 1MB/s or not.
+- Run dd to read a file and see if rate is throttled to 1MB/s or not::
 
         # dd iflag=direct if=/mnt/common/zerofile of=/dev/null bs=4K count=1024
         1024+0 records in
@@ -99,7 +111,7 @@ throttling's hierarchy support is enabled iff "sane_behavior" is
 enabled from cgroup side, which currently is a development option and
 not publicly available.
 
-If somebody created a hierarchy like as follows.
+If somebody created a hierarchy like as follows::
 
 			root
 			/  \
@@ -115,7 +127,7 @@ directly generated by tasks in that cgroup.
 
 Throttling without "sane_behavior" enabled from cgroup side will
 practically treat all groups at same level as if it looks like the
-following.
+following::
 
 				pivot
 			     /  /   \  \
@@ -152,27 +164,31 @@ Proportional weight policy files
 	  These rules override the default value of group weight as specified
 	  by blkio.weight.
 
-	  Following is the format.
+	  Following is the format::
 
-	  # echo dev_maj:dev_minor weight > blkio.weight_device
-	  Configure weight=300 on /dev/sdb (8:16) in this cgroup
-	  # echo 8:16 300 > blkio.weight_device
-	  # cat blkio.weight_device
-	  dev     weight
-	  8:16    300
+	    # echo dev_maj:dev_minor weight > blkio.weight_device
 
-	  Configure weight=500 on /dev/sda (8:0) in this cgroup
-	  # echo 8:0 500 > blkio.weight_device
-	  # cat blkio.weight_device
-	  dev     weight
-	  8:0     500
-	  8:16    300
+	  Configure weight=300 on /dev/sdb (8:16) in this cgroup::
 
-	  Remove specific weight for /dev/sda in this cgroup
-	  # echo 8:0 0 > blkio.weight_device
-	  # cat blkio.weight_device
-	  dev     weight
-	  8:16    300
+	    # echo 8:16 300 > blkio.weight_device
+	    # cat blkio.weight_device
+	    dev     weight
+	    8:16    300
+
+	  Configure weight=500 on /dev/sda (8:0) in this cgroup::
+
+	    # echo 8:0 500 > blkio.weight_device
+	    # cat blkio.weight_device
+	    dev     weight
+	    8:0     500
+	    8:16    300
+
+	  Remove specific weight for /dev/sda in this cgroup::
+
+	    # echo 8:0 0 > blkio.weight_device
+	    # cat blkio.weight_device
+	    dev     weight
+	    8:16    300
 
 - blkio.leaf_weight[_device]
 	- Equivalents of blkio.weight[_device] for the purpose of
@@ -297,30 +313,30 @@ Throttling/Upper limit policy files
 - blkio.throttle.read_bps_device
 	- Specifies upper limit on READ rate from the device. IO rate is
 	  specified in bytes per second. Rules are per device. Following is
-	  the format.
+	  the format::
 
-  echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.throttle.read_bps_device
+	    echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.throttle.read_bps_device
 
 - blkio.throttle.write_bps_device
 	- Specifies upper limit on WRITE rate to the device. IO rate is
 	  specified in bytes per second. Rules are per device. Following is
-	  the format.
+	  the format::
 
-  echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.throttle.write_bps_device
+	    echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.throttle.write_bps_device
 
 - blkio.throttle.read_iops_device
 	- Specifies upper limit on READ rate from the device. IO rate is
 	  specified in IO per second. Rules are per device. Following is
-	  the format.
+	  the format::
 
-  echo "<major>:<minor>  <rate_io_per_second>" > /cgrp/blkio.throttle.read_iops_device
+	   echo "<major>:<minor>  <rate_io_per_second>" > /cgrp/blkio.throttle.read_iops_device
 
 - blkio.throttle.write_iops_device
 	- Specifies upper limit on WRITE rate to the device. IO rate is
 	  specified in io per second. Rules are per device. Following is
-	  the format.
+	  the format::
 
-  echo "<major>:<minor>  <rate_io_per_second>" > /cgrp/blkio.throttle.write_iops_device
+	    echo "<major>:<minor>  <rate_io_per_second>" > /cgrp/blkio.throttle.write_iops_device
 
 Note: If both BW and IOPS rules are specified for a device, then IO is
       subjected to both the constraints.
diff --git a/Documentation/cgroup-v1/cgroups.txt b/Documentation/cgroup-v1/cgroups.rst
similarity index 88%
rename from Documentation/cgroup-v1/cgroups.txt
rename to Documentation/cgroup-v1/cgroups.rst
index 059f7063eea6..46bbe7e022d4 100644
--- a/Documentation/cgroup-v1/cgroups.txt
+++ b/Documentation/cgroup-v1/cgroups.rst
@@ -1,35 +1,39 @@
-				CGROUPS
-				-------
+==============
+Control Groups
+==============
 
 Written by Paul Menage <menage@google.com> based on
-Documentation/cgroup-v1/cpusets.txt
+Documentation/cgroup-v1/cpusets.rst
 
 Original copyright statements from cpusets.txt:
+
 Portions Copyright (C) 2004 BULL SA.
+
 Portions Copyright (c) 2004-2006 Silicon Graphics, Inc.
+
 Modified by Paul Jackson <pj@sgi.com>
+
 Modified by Christoph Lameter <cl@linux.com>
 
-CONTENTS:
-=========
+.. CONTENTS:
 
-1. Control Groups
-  1.1 What are cgroups ?
-  1.2 Why are cgroups needed ?
-  1.3 How are cgroups implemented ?
-  1.4 What does notify_on_release do ?
-  1.5 What does clone_children do ?
-  1.6 How do I use cgroups ?
-2. Usage Examples and Syntax
-  2.1 Basic Usage
-  2.2 Attaching processes
-  2.3 Mounting hierarchies by name
-3. Kernel API
-  3.1 Overview
-  3.2 Synchronization
-  3.3 Subsystem API
-4. Extended attributes usage
-5. Questions
+	1. Control Groups
+	1.1 What are cgroups ?
+	1.2 Why are cgroups needed ?
+	1.3 How are cgroups implemented ?
+	1.4 What does notify_on_release do ?
+	1.5 What does clone_children do ?
+	1.6 How do I use cgroups ?
+	2. Usage Examples and Syntax
+	2.1 Basic Usage
+	2.2 Attaching processes
+	2.3 Mounting hierarchies by name
+	3. Kernel API
+	3.1 Overview
+	3.2 Synchronization
+	3.3 Subsystem API
+	4. Extended attributes usage
+	5. Questions
 
 1. Control Groups
 =================
@@ -72,7 +76,7 @@ On their own, the only use for cgroups is for simple job
 tracking. The intention is that other subsystems hook into the generic
 cgroup support to provide new attributes for cgroups, such as
 accounting/limiting the resources which processes in a cgroup can
-access. For example, cpusets (see Documentation/cgroup-v1/cpusets.txt) allow
+access. For example, cpusets (see Documentation/cgroup-v1/cpusets.rst) allow
 you to associate a set of CPUs and a set of memory nodes with the
 tasks in each cgroup.
 
@@ -108,7 +112,7 @@ As an example of a scenario (originally proposed by vatsa@in.ibm.com)
 that can benefit from multiple hierarchies, consider a large
 university server with various users - students, professors, system
 tasks etc. The resource planning for this server could be along the
-following lines:
+following lines::
 
        CPU :          "Top cpuset"
                        /       \
@@ -136,7 +140,7 @@ depending on who launched it (prof/student).
 With the ability to classify tasks differently for different resources
 (by putting those resource subsystems in different hierarchies),
 the admin can easily set up a script which receives exec notifications
-and depending on who is launching the browser he can
+and depending on who is launching the browser he can::
 
     # echo browser_pid > /sys/fs/cgroup/<restype>/<userclass>/tasks
 
@@ -151,7 +155,7 @@ wants to do online gaming :))  OR give one of the student's simulation
 apps enhanced CPU power.
 
 With ability to write PIDs directly to resource classes, it's just a
-matter of:
+matter of::
 
        # echo pid > /sys/fs/cgroup/network/<new_class>/tasks
        (after some time)
@@ -306,7 +310,7 @@ configuration from the parent during initialization.
 --------------------------
 
 To start a new job that is to be contained within a cgroup, using
-the "cpuset" cgroup subsystem, the steps are something like:
+the "cpuset" cgroup subsystem, the steps are something like::
 
  1) mount -t tmpfs cgroup_root /sys/fs/cgroup
  2) mkdir /sys/fs/cgroup/cpuset
@@ -320,7 +324,7 @@ the "cpuset" cgroup subsystem, the steps are something like:
 
 For example, the following sequence of commands will setup a cgroup
 named "Charlie", containing just CPUs 2 and 3, and Memory Node 1,
-and then start a subshell 'sh' in that cgroup:
+and then start a subshell 'sh' in that cgroup::
 
   mount -t tmpfs cgroup_root /sys/fs/cgroup
   mkdir /sys/fs/cgroup/cpuset
@@ -345,8 +349,9 @@ and then start a subshell 'sh' in that cgroup:
 Creating, modifying, using cgroups can be done through the cgroup
 virtual filesystem.
 
-To mount a cgroup hierarchy with all available subsystems, type:
-# mount -t cgroup xxx /sys/fs/cgroup
+To mount a cgroup hierarchy with all available subsystems, type::
+
+  # mount -t cgroup xxx /sys/fs/cgroup
 
 The "xxx" is not interpreted by the cgroup code, but will appear in
 /proc/mounts so may be any useful identifying string that you like.
@@ -355,18 +360,19 @@ Note: Some subsystems do not work without some user input first.  For instance,
 if cpusets are enabled the user will have to populate the cpus and mems files
 for each new cgroup created before that group can be used.
 
-As explained in section `1.2 Why are cgroups needed?' you should create
+As explained in section `1.2 Why are cgroups needed?` you should create
 different hierarchies of cgroups for each single resource or group of
 resources you want to control. Therefore, you should mount a tmpfs on
 /sys/fs/cgroup and create directories for each cgroup resource or resource
-group.
+group::
 
-# mount -t tmpfs cgroup_root /sys/fs/cgroup
-# mkdir /sys/fs/cgroup/rg1
+  # mount -t tmpfs cgroup_root /sys/fs/cgroup
+  # mkdir /sys/fs/cgroup/rg1
 
 To mount a cgroup hierarchy with just the cpuset and memory
-subsystems, type:
-# mount -t cgroup -o cpuset,memory hier1 /sys/fs/cgroup/rg1
+subsystems, type::
+
+  # mount -t cgroup -o cpuset,memory hier1 /sys/fs/cgroup/rg1
 
 While remounting cgroups is currently supported, it is not recommend
 to use it. Remounting allows changing bound subsystems and
@@ -375,9 +381,10 @@ hierarchy is empty and release_agent itself should be replaced with
 conventional fsnotify. The support for remounting will be removed in
 the future.
 
-To Specify a hierarchy's release_agent:
-# mount -t cgroup -o cpuset,release_agent="/sbin/cpuset_release_agent" \
-  xxx /sys/fs/cgroup/rg1
+To Specify a hierarchy's release_agent::
+
+  # mount -t cgroup -o cpuset,release_agent="/sbin/cpuset_release_agent" \
+    xxx /sys/fs/cgroup/rg1
 
 Note that specifying 'release_agent' more than once will return failure.
 
@@ -390,32 +397,39 @@ Then under /sys/fs/cgroup/rg1 you can find a tree that corresponds to the
 tree of the cgroups in the system. For instance, /sys/fs/cgroup/rg1
 is the cgroup that holds the whole system.
 
-If you want to change the value of release_agent:
-# echo "/sbin/new_release_agent" > /sys/fs/cgroup/rg1/release_agent
+If you want to change the value of release_agent::
+
+  # echo "/sbin/new_release_agent" > /sys/fs/cgroup/rg1/release_agent
 
 It can also be changed via remount.
 
-If you want to create a new cgroup under /sys/fs/cgroup/rg1:
-# cd /sys/fs/cgroup/rg1
-# mkdir my_cgroup
+If you want to create a new cgroup under /sys/fs/cgroup/rg1::
 
-Now you want to do something with this cgroup.
-# cd my_cgroup
+  # cd /sys/fs/cgroup/rg1
+  # mkdir my_cgroup
 
-In this directory you can find several files:
-# ls
-cgroup.procs notify_on_release tasks
-(plus whatever files added by the attached subsystems)
+Now you want to do something with this cgroup:
 
-Now attach your shell to this cgroup:
-# /bin/echo $$ > tasks
+  # cd my_cgroup
+
+In this directory you can find several files::
+
+  # ls
+  cgroup.procs notify_on_release tasks
+  (plus whatever files added by the attached subsystems)
+
+Now attach your shell to this cgroup::
+
+  # /bin/echo $$ > tasks
 
 You can also create cgroups inside your cgroup by using mkdir in this
-directory.
-# mkdir my_sub_cs
+directory::
 
-To remove a cgroup, just use rmdir:
-# rmdir my_sub_cs
+  # mkdir my_sub_cs
+
+To remove a cgroup, just use rmdir::
+
+  # rmdir my_sub_cs
 
 This will fail if the cgroup is in use (has cgroups inside, or
 has processes attached, or is held alive by other subsystem-specific
@@ -424,19 +438,21 @@ reference).
 2.2 Attaching processes
 -----------------------
 
-# /bin/echo PID > tasks
+::
+
+  # /bin/echo PID > tasks
 
 Note that it is PID, not PIDs. You can only attach ONE task at a time.
-If you have several tasks to attach, you have to do it one after another:
+If you have several tasks to attach, you have to do it one after another::
 
-# /bin/echo PID1 > tasks
-# /bin/echo PID2 > tasks
-	...
-# /bin/echo PIDn > tasks
+  # /bin/echo PID1 > tasks
+  # /bin/echo PID2 > tasks
+	  ...
+  # /bin/echo PIDn > tasks
 
-You can attach the current shell task by echoing 0:
+You can attach the current shell task by echoing 0::
 
-# echo 0 > tasks
+  # echo 0 > tasks
 
 You can use the cgroup.procs file instead of the tasks file to move all
 threads in a threadgroup at once. Echoing the PID of any task in a
@@ -529,7 +545,7 @@ Each subsystem may export the following methods. The only mandatory
 methods are css_alloc/free. Any others that are null are presumed to
 be successful no-ops.
 
-struct cgroup_subsys_state *css_alloc(struct cgroup *cgrp)
+``struct cgroup_subsys_state *css_alloc(struct cgroup *cgrp)``
 (cgroup_mutex held by caller)
 
 Called to allocate a subsystem state object for a cgroup. The
@@ -544,7 +560,7 @@ identified by the passed cgroup object having a NULL parent (since
 it's the root of the hierarchy) and may be an appropriate place for
 initialization code.
 
-int css_online(struct cgroup *cgrp)
+``int css_online(struct cgroup *cgrp)``
 (cgroup_mutex held by caller)
 
 Called after @cgrp successfully completed all allocations and made
@@ -554,7 +570,7 @@ callback can be used to implement reliable state sharing and
 propagation along the hierarchy. See the comment on
 cgroup_for_each_descendant_pre() for details.
 
-void css_offline(struct cgroup *cgrp);
+``void css_offline(struct cgroup *cgrp);``
 (cgroup_mutex held by caller)
 
 This is the counterpart of css_online() and called iff css_online()
@@ -564,7 +580,7 @@ all references it's holding on @cgrp. When all references are dropped,
 cgroup removal will proceed to the next step - css_free(). After this
 callback, @cgrp should be considered dead to the subsystem.
 
-void css_free(struct cgroup *cgrp)
+``void css_free(struct cgroup *cgrp)``
 (cgroup_mutex held by caller)
 
 The cgroup system is about to free @cgrp; the subsystem should free
@@ -573,7 +589,7 @@ is completely unused; @cgrp->parent is still valid. (Note - can also
 be called for a newly-created cgroup if an error occurs after this
 subsystem's create() method has been called for the new cgroup).
 
-int can_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
+``int can_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)``
 (cgroup_mutex held by caller)
 
 Called prior to moving one or more tasks into a cgroup; if the
@@ -594,7 +610,7 @@ fork. If this method returns 0 (success) then this should remain valid
 while the caller holds cgroup_mutex and it is ensured that either
 attach() or cancel_attach() will be called in future.
 
-void css_reset(struct cgroup_subsys_state *css)
+``void css_reset(struct cgroup_subsys_state *css)``
 (cgroup_mutex held by caller)
 
 An optional operation which should restore @css's configuration to the
@@ -608,7 +624,7 @@ This prevents unexpected resource control from a hidden css and
 ensures that the configuration is in the initial state when it is made
 visible again later.
 
-void cancel_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
+``void cancel_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)``
 (cgroup_mutex held by caller)
 
 Called when a task attach operation has failed after can_attach() has succeeded.
@@ -617,26 +633,26 @@ function, so that the subsystem can implement a rollback. If not, not necessary.
 This will be called only about subsystems whose can_attach() operation have
 succeeded. The parameters are identical to can_attach().
 
-void attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
+``void attach(struct cgroup *cgrp, struct cgroup_taskset *tset)``
 (cgroup_mutex held by caller)
 
 Called after the task has been attached to the cgroup, to allow any
 post-attachment activity that requires memory allocations or blocking.
 The parameters are identical to can_attach().
 
-void fork(struct task_struct *task)
+``void fork(struct task_struct *task)``
 
 Called when a task is forked into a cgroup.
 
-void exit(struct task_struct *task)
+``void exit(struct task_struct *task)``
 
 Called during task exit.
 
-void free(struct task_struct *task)
+``void free(struct task_struct *task)``
 
 Called when the task_struct is freed.
 
-void bind(struct cgroup *root)
+``void bind(struct cgroup *root)``
 (cgroup_mutex held by caller)
 
 Called when a cgroup subsystem is rebound to a different hierarchy
@@ -649,6 +665,7 @@ that is being created/destroyed (and hence has no sub-cgroups).
 
 cgroup filesystem supports certain types of extended attributes in its
 directories and files.  The current supported types are:
+
 	- Trusted (XATTR_TRUSTED)
 	- Security (XATTR_SECURITY)
 
@@ -666,12 +683,13 @@ in containers and systemd for assorted meta data like main PID in a cgroup
 5. Questions
 ============
 
-Q: what's up with this '/bin/echo' ?
-A: bash's builtin 'echo' command does not check calls to write() against
-   errors. If you use it in the cgroup file system, you won't be
-   able to tell whether a command succeeded or failed.
+::
 
-Q: When I attach processes, only the first of the line gets really attached !
-A: We can only return one error code per call to write(). So you should also
-   put only ONE PID.
+  Q: what's up with this '/bin/echo' ?
+  A: bash's builtin 'echo' command does not check calls to write() against
+     errors. If you use it in the cgroup file system, you won't be
+     able to tell whether a command succeeded or failed.
 
+  Q: When I attach processes, only the first of the line gets really attached !
+  A: We can only return one error code per call to write(). So you should also
+     put only ONE PID.
diff --git a/Documentation/cgroup-v1/cpuacct.txt b/Documentation/cgroup-v1/cpuacct.rst
similarity index 90%
rename from Documentation/cgroup-v1/cpuacct.txt
rename to Documentation/cgroup-v1/cpuacct.rst
index 9d73cc0cadb9..d30ed81d2ad7 100644
--- a/Documentation/cgroup-v1/cpuacct.txt
+++ b/Documentation/cgroup-v1/cpuacct.rst
@@ -1,5 +1,6 @@
+=========================
 CPU Accounting Controller
--------------------------
+=========================
 
 The CPU accounting controller is used to group tasks using cgroups and
 account the CPU usage of these groups of tasks.
@@ -8,9 +9,9 @@ The CPU accounting controller supports multi-hierarchy groups. An accounting
 group accumulates the CPU usage of all of its child groups and the tasks
 directly present in its group.
 
-Accounting groups can be created by first mounting the cgroup filesystem.
+Accounting groups can be created by first mounting the cgroup filesystem::
 
-# mount -t cgroup -ocpuacct none /sys/fs/cgroup
+  # mount -t cgroup -ocpuacct none /sys/fs/cgroup
 
 With the above step, the initial or the parent accounting group becomes
 visible at /sys/fs/cgroup. At bootup, this group includes all the tasks in
@@ -19,11 +20,11 @@ the system. /sys/fs/cgroup/tasks lists the tasks in this cgroup.
 by this group which is essentially the CPU time obtained by all the tasks
 in the system.
 
-New accounting groups can be created under the parent group /sys/fs/cgroup.
+New accounting groups can be created under the parent group /sys/fs/cgroup::
 
-# cd /sys/fs/cgroup
-# mkdir g1
-# echo $$ > g1/tasks
+  # cd /sys/fs/cgroup
+  # mkdir g1
+  # echo $$ > g1/tasks
 
 The above steps create a new group g1 and move the current shell
 process (bash) into it. CPU time consumed by this bash and its children
diff --git a/Documentation/cgroup-v1/cpusets.txt b/Documentation/cgroup-v1/cpusets.rst
similarity index 90%
rename from Documentation/cgroup-v1/cpusets.txt
rename to Documentation/cgroup-v1/cpusets.rst
index 8402dd6de8df..b6a42cdea72b 100644
--- a/Documentation/cgroup-v1/cpusets.txt
+++ b/Documentation/cgroup-v1/cpusets.rst
@@ -1,35 +1,36 @@
-				CPUSETS
-				-------
+=======
+CPUSETS
+=======
 
 Copyright (C) 2004 BULL SA.
+
 Written by Simon.Derr@bull.net
 
-Portions Copyright (c) 2004-2006 Silicon Graphics, Inc.
-Modified by Paul Jackson <pj@sgi.com>
-Modified by Christoph Lameter <cl@linux.com>
-Modified by Paul Menage <menage@google.com>
-Modified by Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
+- Portions Copyright (c) 2004-2006 Silicon Graphics, Inc.
+- Modified by Paul Jackson <pj@sgi.com>
+- Modified by Christoph Lameter <cl@linux.com>
+- Modified by Paul Menage <menage@google.com>
+- Modified by Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
 
-CONTENTS:
-=========
+.. CONTENTS:
 
-1. Cpusets
-  1.1 What are cpusets ?
-  1.2 Why are cpusets needed ?
-  1.3 How are cpusets implemented ?
-  1.4 What are exclusive cpusets ?
-  1.5 What is memory_pressure ?
-  1.6 What is memory spread ?
-  1.7 What is sched_load_balance ?
-  1.8 What is sched_relax_domain_level ?
-  1.9 How do I use cpusets ?
-2. Usage Examples and Syntax
-  2.1 Basic Usage
-  2.2 Adding/removing cpus
-  2.3 Setting flags
-  2.4 Attaching processes
-3. Questions
-4. Contact
+   1. Cpusets
+     1.1 What are cpusets ?
+     1.2 Why are cpusets needed ?
+     1.3 How are cpusets implemented ?
+     1.4 What are exclusive cpusets ?
+     1.5 What is memory_pressure ?
+     1.6 What is memory spread ?
+     1.7 What is sched_load_balance ?
+     1.8 What is sched_relax_domain_level ?
+     1.9 How do I use cpusets ?
+   2. Usage Examples and Syntax
+     2.1 Basic Usage
+     2.2 Adding/removing cpus
+     2.3 Setting flags
+     2.4 Attaching processes
+   3. Questions
+   4. Contact
 
 1. Cpusets
 ==========
@@ -48,7 +49,7 @@ hooks, beyond what is already present, required to manage dynamic
 job placement on large systems.
 
 Cpusets use the generic cgroup subsystem described in
-Documentation/cgroup-v1/cgroups.txt.
+Documentation/cgroup-v1/cgroups.rst.
 
 Requests by a task, using the sched_setaffinity(2) system call to
 include CPUs in its CPU affinity mask, and using the mbind(2) and
@@ -157,7 +158,7 @@ modifying cpusets is via this cpuset file system.
 The /proc/<pid>/status file for each task has four added lines,
 displaying the task's cpus_allowed (on which CPUs it may be scheduled)
 and mems_allowed (on which Memory Nodes it may obtain memory),
-in the two formats seen in the following example:
+in the two formats seen in the following example::
 
   Cpus_allowed:   ffffffff,ffffffff,ffffffff,ffffffff
   Cpus_allowed_list:      0-127
@@ -181,6 +182,7 @@ files describing that cpuset:
  - cpuset.sched_relax_domain_level: the searching range when migrating tasks
 
 In addition, only the root cpuset has the following file:
+
  - cpuset.memory_pressure_enabled flag: compute memory_pressure?
 
 New cpusets are created using the mkdir system call or shell
@@ -266,7 +268,8 @@ to monitor a cpuset for signs of memory pressure.  It's up to the
 batch manager or other user code to decide what to do about it and
 take action.
 
-==> Unless this feature is enabled by writing "1" to the special file
+==>
+    Unless this feature is enabled by writing "1" to the special file
     /dev/cpuset/memory_pressure_enabled, the hook in the rebalance
     code of __alloc_pages() for this metric reduces to simply noticing
     that the cpuset_memory_pressure_enabled flag is zero.  So only
@@ -399,6 +402,7 @@ have tasks running on them unless explicitly assigned.
 
 This default load balancing across all CPUs is not well suited for
 the following two situations:
+
  1) On large systems, load balancing across many CPUs is expensive.
     If the system is managed using cpusets to place independent jobs
     on separate sets of CPUs, full load balancing is unnecessary.
@@ -501,6 +505,7 @@ all the CPUs that must be load balanced.
 The cpuset code builds a new such partition and passes it to the
 scheduler sched domain setup code, to have the sched domains rebuilt
 as necessary, whenever:
+
  - the 'cpuset.sched_load_balance' flag of a cpuset with non-empty CPUs changes,
  - or CPUs come or go from a cpuset with this flag enabled,
  - or 'cpuset.sched_relax_domain_level' value of a cpuset with non-empty CPUs
@@ -553,13 +558,15 @@ this searching range as you like.  This file takes int value which
 indicates size of searching range in levels ideally as follows,
 otherwise initial value -1 that indicates the cpuset has no request.
 
-  -1  : no request. use system default or follow request of others.
-   0  : no search.
-   1  : search siblings (hyperthreads in a core).
-   2  : search cores in a package.
-   3  : search cpus in a node [= system wide on non-NUMA system]
-   4  : search nodes in a chunk of node [on NUMA system]
-   5  : search system wide [on NUMA system]
+====== ===========================================================
+  -1   no request. use system default or follow request of others.
+   0   no search.
+   1   search siblings (hyperthreads in a core).
+   2   search cores in a package.
+   3   search cpus in a node [= system wide on non-NUMA system]
+   4   search nodes in a chunk of node [on NUMA system]
+   5   search system wide [on NUMA system]
+====== ===========================================================
 
 The system default is architecture dependent.  The system default
 can be changed using the relax_domain_level= boot parameter.
@@ -578,13 +585,14 @@ and whether it is acceptable or not depends on your situation.
 Don't modify this file if you are not sure.
 
 If your situation is:
+
  - The migration costs between each cpu can be assumed considerably
    small(for you) due to your special application's behavior or
    special hardware support for CPU cache etc.
  - The searching cost doesn't have impact(for you) or you can make
    the searching cost enough small by managing cpuset to compact etc.
  - The latency is required even it sacrifices cache hit rate etc.
-then increasing 'sched_relax_domain_level' would benefit you.
+   then increasing 'sched_relax_domain_level' would benefit you.
 
 
 1.9 How do I use cpusets ?
@@ -678,7 +686,7 @@ To start a new job that is to be contained within a cpuset, the steps are:
 
 For example, the following sequence of commands will setup a cpuset
 named "Charlie", containing just CPUs 2 and 3, and Memory Node 1,
-and then start a subshell 'sh' in that cpuset:
+and then start a subshell 'sh' in that cpuset::
 
   mount -t cgroup -ocpuset cpuset /sys/fs/cgroup/cpuset
   cd /sys/fs/cgroup/cpuset
@@ -693,6 +701,7 @@ and then start a subshell 'sh' in that cpuset:
   cat /proc/self/cpuset
 
 There are ways to query or modify cpusets:
+
  - via the cpuset file system directly, using the various cd, mkdir, echo,
    cat, rmdir commands from the shell, or their equivalent from C.
  - via the C library libcpuset.
@@ -722,115 +731,133 @@ Then under /sys/fs/cgroup/cpuset you can find a tree that corresponds to the
 tree of the cpusets in the system. For instance, /sys/fs/cgroup/cpuset
 is the cpuset that holds the whole system.
 
-If you want to create a new cpuset under /sys/fs/cgroup/cpuset:
-# cd /sys/fs/cgroup/cpuset
-# mkdir my_cpuset
+If you want to create a new cpuset under /sys/fs/cgroup/cpuset::
 
-Now you want to do something with this cpuset.
-# cd my_cpuset
+  # cd /sys/fs/cgroup/cpuset
+  # mkdir my_cpuset
 
-In this directory you can find several files:
-# ls
-cgroup.clone_children  cpuset.memory_pressure
-cgroup.event_control   cpuset.memory_spread_page
-cgroup.procs           cpuset.memory_spread_slab
-cpuset.cpu_exclusive   cpuset.mems
-cpuset.cpus            cpuset.sched_load_balance
-cpuset.mem_exclusive   cpuset.sched_relax_domain_level
-cpuset.mem_hardwall    notify_on_release
-cpuset.memory_migrate  tasks
+Now you want to do something with this cpuset::
+
+  # cd my_cpuset
+
+In this directory you can find several files::
+
+  # ls
+  cgroup.clone_children  cpuset.memory_pressure
+  cgroup.event_control   cpuset.memory_spread_page
+  cgroup.procs           cpuset.memory_spread_slab
+  cpuset.cpu_exclusive   cpuset.mems
+  cpuset.cpus            cpuset.sched_load_balance
+  cpuset.mem_exclusive   cpuset.sched_relax_domain_level
+  cpuset.mem_hardwall    notify_on_release
+  cpuset.memory_migrate  tasks
 
 Reading them will give you information about the state of this cpuset:
 the CPUs and Memory Nodes it can use, the processes that are using
 it, its properties.  By writing to these files you can manipulate
 the cpuset.
 
-Set some flags:
-# /bin/echo 1 > cpuset.cpu_exclusive
+Set some flags::
 
-Add some cpus:
-# /bin/echo 0-7 > cpuset.cpus
+  # /bin/echo 1 > cpuset.cpu_exclusive
 
-Add some mems:
-# /bin/echo 0-7 > cpuset.mems
+Add some cpus::
 
-Now attach your shell to this cpuset:
-# /bin/echo $$ > tasks
+  # /bin/echo 0-7 > cpuset.cpus
+
+Add some mems::
+
+  # /bin/echo 0-7 > cpuset.mems
+
+Now attach your shell to this cpuset::
+
+  # /bin/echo $$ > tasks
 
 You can also create cpusets inside your cpuset by using mkdir in this
-directory.
-# mkdir my_sub_cs
+directory::
+
+  # mkdir my_sub_cs
+
+To remove a cpuset, just use rmdir::
+
+  # rmdir my_sub_cs
 
-To remove a cpuset, just use rmdir:
-# rmdir my_sub_cs
 This will fail if the cpuset is in use (has cpusets inside, or has
 processes attached).
 
 Note that for legacy reasons, the "cpuset" filesystem exists as a
 wrapper around the cgroup filesystem.
 
-The command
+The command::
 
-mount -t cpuset X /sys/fs/cgroup/cpuset
+  mount -t cpuset X /sys/fs/cgroup/cpuset
 
-is equivalent to
+is equivalent to::
 
-mount -t cgroup -ocpuset,noprefix X /sys/fs/cgroup/cpuset
-echo "/sbin/cpuset_release_agent" > /sys/fs/cgroup/cpuset/release_agent
+  mount -t cgroup -ocpuset,noprefix X /sys/fs/cgroup/cpuset
+  echo "/sbin/cpuset_release_agent" > /sys/fs/cgroup/cpuset/release_agent
 
 2.2 Adding/removing cpus
 ------------------------
 
 This is the syntax to use when writing in the cpus or mems files
-in cpuset directories:
+in cpuset directories::
 
-# /bin/echo 1-4 > cpuset.cpus		-> set cpus list to cpus 1,2,3,4
-# /bin/echo 1,2,3,4 > cpuset.cpus	-> set cpus list to cpus 1,2,3,4
+  # /bin/echo 1-4 > cpuset.cpus		-> set cpus list to cpus 1,2,3,4
+  # /bin/echo 1,2,3,4 > cpuset.cpus	-> set cpus list to cpus 1,2,3,4
 
 To add a CPU to a cpuset, write the new list of CPUs including the
-CPU to be added. To add 6 to the above cpuset:
+CPU to be added. To add 6 to the above cpuset::
 
-# /bin/echo 1-4,6 > cpuset.cpus	-> set cpus list to cpus 1,2,3,4,6
+  # /bin/echo 1-4,6 > cpuset.cpus	-> set cpus list to cpus 1,2,3,4,6
 
 Similarly to remove a CPU from a cpuset, write the new list of CPUs
 without the CPU to be removed.
 
-To remove all the CPUs:
+To remove all the CPUs::
 
-# /bin/echo "" > cpuset.cpus		-> clear cpus list
+  # /bin/echo "" > cpuset.cpus		-> clear cpus list
 
 2.3 Setting flags
 -----------------
 
-The syntax is very simple:
+The syntax is very simple::
 
-# /bin/echo 1 > cpuset.cpu_exclusive 	-> set flag 'cpuset.cpu_exclusive'
-# /bin/echo 0 > cpuset.cpu_exclusive 	-> unset flag 'cpuset.cpu_exclusive'
+  # /bin/echo 1 > cpuset.cpu_exclusive 	-> set flag 'cpuset.cpu_exclusive'
+  # /bin/echo 0 > cpuset.cpu_exclusive 	-> unset flag 'cpuset.cpu_exclusive'
 
 2.4 Attaching processes
 -----------------------
 
-# /bin/echo PID > tasks
+::
+
+  # /bin/echo PID > tasks
 
 Note that it is PID, not PIDs. You can only attach ONE task at a time.
-If you have several tasks to attach, you have to do it one after another:
+If you have several tasks to attach, you have to do it one after another::
 
-# /bin/echo PID1 > tasks
-# /bin/echo PID2 > tasks
+  # /bin/echo PID1 > tasks
+  # /bin/echo PID2 > tasks
 	...
-# /bin/echo PIDn > tasks
+  # /bin/echo PIDn > tasks
 
 
 3. Questions
 ============
 
-Q: what's up with this '/bin/echo' ?
-A: bash's builtin 'echo' command does not check calls to write() against
+Q:
+   what's up with this '/bin/echo' ?
+
+A:
+   bash's builtin 'echo' command does not check calls to write() against
    errors. If you use it in the cpuset file system, you won't be
    able to tell whether a command succeeded or failed.
 
-Q: When I attach processes, only the first of the line gets really attached !
-A: We can only return one error code per call to write(). So you should also
+Q:
+   When I attach processes, only the first of the line gets really attached !
+
+A:
+   We can only return one error code per call to write(). So you should also
    put only ONE pid.
 
 4. Contact
diff --git a/Documentation/cgroup-v1/devices.txt b/Documentation/cgroup-v1/devices.rst
similarity index 88%
rename from Documentation/cgroup-v1/devices.txt
rename to Documentation/cgroup-v1/devices.rst
index 3c1095ca02ea..e1886783961e 100644
--- a/Documentation/cgroup-v1/devices.txt
+++ b/Documentation/cgroup-v1/devices.rst
@@ -1,6 +1,9 @@
+===========================
 Device Whitelist Controller
+===========================
 
-1. Description:
+1. Description
+==============
 
 Implement a cgroup to track and enforce open and mknod restrictions
 on device files.  A device cgroup associates a device access
@@ -16,24 +19,26 @@ devices from the whitelist or add new entries.  A child cgroup can
 never receive a device access which is denied by its parent.
 
 2. User Interface
+=================
 
 An entry is added using devices.allow, and removed using
-devices.deny.  For instance
+devices.deny.  For instance::
 
 	echo 'c 1:3 mr' > /sys/fs/cgroup/1/devices.allow
 
 allows cgroup 1 to read and mknod the device usually known as
-/dev/null.  Doing
+/dev/null.  Doing::
 
 	echo a > /sys/fs/cgroup/1/devices.deny
 
-will remove the default 'a *:* rwm' entry. Doing
+will remove the default 'a *:* rwm' entry. Doing::
 
 	echo a > /sys/fs/cgroup/1/devices.allow
 
 will add the 'a *:* rwm' entry to the whitelist.
 
 3. Security
+===========
 
 Any task can move itself between cgroups.  This clearly won't
 suffice, but we can decide the best way to adequately restrict
@@ -50,6 +55,7 @@ A cgroup may not be granted more permissions than the cgroup's
 parent has.
 
 4. Hierarchy
+============
 
 device cgroups maintain hierarchy by making sure a cgroup never has more
 access permissions than its parent.  Every time an entry is written to
@@ -58,7 +64,8 @@ from their whitelist and all the locally set whitelist entries will be
 re-evaluated.  In case one of the locally set whitelist entries would provide
 more access than the cgroup's parent, it'll be removed from the whitelist.
 
-Example:
+Example::
+
       A
      / \
         B
@@ -67,10 +74,12 @@ Example:
     A            allow		"b 8:* rwm", "c 116:1 rw"
     B            deny		"c 1:3 rwm", "c 116:2 rwm", "b 3:* rwm"
 
-If a device is denied in group A:
+If a device is denied in group A::
+
 	# echo "c 116:* r" > A/devices.deny
+
 it'll propagate down and after revalidating B's entries, the whitelist entry
-"c 116:2 rwm" will be removed:
+"c 116:2 rwm" will be removed::
 
     group        whitelist entries                        denied devices
     A            all                                      "b 8:* rwm", "c 116:* rw"
@@ -79,7 +88,8 @@ it'll propagate down and after revalidating B's entries, the whitelist entry
 In case parent's exceptions change and local exceptions are not allowed
 anymore, they'll be deleted.
 
-Notice that new whitelist entries will not be propagated:
+Notice that new whitelist entries will not be propagated::
+
       A
      / \
         B
@@ -88,24 +98,30 @@ Notice that new whitelist entries will not be propagated:
     A            "c 1:3 rwm", "c 1:5 r"                   all the rest
     B            "c 1:3 rwm", "c 1:5 r"                   all the rest
 
-when adding "c *:3 rwm":
+when adding ``c *:3 rwm``::
+
 	# echo "c *:3 rwm" >A/devices.allow
 
-the result:
+the result::
+
     group        whitelist entries                        denied devices
     A            "c *:3 rwm", "c 1:5 r"                   all the rest
     B            "c 1:3 rwm", "c 1:5 r"                   all the rest
 
-but now it'll be possible to add new entries to B:
+but now it'll be possible to add new entries to B::
+
 	# echo "c 2:3 rwm" >B/devices.allow
 	# echo "c 50:3 r" >B/devices.allow
-or even
+
+or even::
+
 	# echo "c *:3 rwm" >B/devices.allow
 
 Allowing or denying all by writing 'a' to devices.allow or devices.deny will
 not be possible once the device cgroups has children.
 
 4.1 Hierarchy (internal implementation)
+---------------------------------------
 
 device cgroups is implemented internally using a behavior (ALLOW, DENY) and a
 list of exceptions.  The internal state is controlled using the same user
diff --git a/Documentation/cgroup-v1/freezer-subsystem.txt b/Documentation/cgroup-v1/freezer-subsystem.rst
similarity index 95%
rename from Documentation/cgroup-v1/freezer-subsystem.txt
rename to Documentation/cgroup-v1/freezer-subsystem.rst
index e831cb2b8394..582d3427de3f 100644
--- a/Documentation/cgroup-v1/freezer-subsystem.txt
+++ b/Documentation/cgroup-v1/freezer-subsystem.rst
@@ -1,3 +1,7 @@
+==============
+Cgroup Freezer
+==============
+
 The cgroup freezer is useful to batch job management system which start
 and stop sets of tasks in order to schedule the resources of a machine
 according to the desires of a system administrator. This sort of program
@@ -23,7 +27,7 @@ blocked, or ignored it can be seen by waiting or ptracing parent tasks.
 SIGCONT is especially unsuitable since it can be caught by the task. Any
 programs designed to watch for SIGSTOP and SIGCONT could be broken by
 attempting to use SIGSTOP and SIGCONT to stop and resume tasks. We can
-demonstrate this problem using nested bash shells:
+demonstrate this problem using nested bash shells::
 
 	$ echo $$
 	16644
@@ -93,19 +97,19 @@ The following cgroupfs files are created by cgroup freezer.
 The root cgroup is non-freezable and the above interface files don't
 exist.
 
-* Examples of usage :
+* Examples of usage::
 
    # mkdir /sys/fs/cgroup/freezer
    # mount -t cgroup -ofreezer freezer /sys/fs/cgroup/freezer
    # mkdir /sys/fs/cgroup/freezer/0
    # echo $some_pid > /sys/fs/cgroup/freezer/0/tasks
 
-to get status of the freezer subsystem :
+to get status of the freezer subsystem::
 
    # cat /sys/fs/cgroup/freezer/0/freezer.state
    THAWED
 
-to freeze all tasks in the container :
+to freeze all tasks in the container::
 
    # echo FROZEN > /sys/fs/cgroup/freezer/0/freezer.state
    # cat /sys/fs/cgroup/freezer/0/freezer.state
@@ -113,7 +117,7 @@ to freeze all tasks in the container :
    # cat /sys/fs/cgroup/freezer/0/freezer.state
    FROZEN
 
-to unfreeze all tasks in the container :
+to unfreeze all tasks in the container::
 
    # echo THAWED > /sys/fs/cgroup/freezer/0/freezer.state
    # cat /sys/fs/cgroup/freezer/0/freezer.state
diff --git a/Documentation/cgroup-v1/hugetlb.txt b/Documentation/cgroup-v1/hugetlb.rst
similarity index 70%
rename from Documentation/cgroup-v1/hugetlb.txt
rename to Documentation/cgroup-v1/hugetlb.rst
index 1260e5369b9b..a3902aa253a9 100644
--- a/Documentation/cgroup-v1/hugetlb.txt
+++ b/Documentation/cgroup-v1/hugetlb.rst
@@ -1,5 +1,6 @@
+==================
 HugeTLB Controller
--------------------
+==================
 
 The HugeTLB controller allows to limit the HugeTLB usage per control group and
 enforces the controller limit during page fault. Since HugeTLB doesn't
@@ -16,16 +17,16 @@ With the above step, the initial or the parent HugeTLB group becomes
 visible at /sys/fs/cgroup. At bootup, this group includes all the tasks in
 the system. /sys/fs/cgroup/tasks lists the tasks in this cgroup.
 
-New groups can be created under the parent group /sys/fs/cgroup.
+New groups can be created under the parent group /sys/fs/cgroup::
 
-# cd /sys/fs/cgroup
-# mkdir g1
-# echo $$ > g1/tasks
+  # cd /sys/fs/cgroup
+  # mkdir g1
+  # echo $$ > g1/tasks
 
 The above steps create a new group g1 and move the current shell
 process (bash) into it.
 
-Brief summary of control files
+Brief summary of control files::
 
  hugetlb.<hugepagesize>.limit_in_bytes     # set/show limit of "hugepagesize" hugetlb usage
  hugetlb.<hugepagesize>.max_usage_in_bytes # show max "hugepagesize" hugetlb  usage recorded
@@ -33,17 +34,17 @@ Brief summary of control files
  hugetlb.<hugepagesize>.failcnt		   # show the number of allocation failure due to HugeTLB limit
 
 For a system supporting three hugepage sizes (64k, 32M and 1G), the control
-files include:
+files include::
 
-hugetlb.1GB.limit_in_bytes
-hugetlb.1GB.max_usage_in_bytes
-hugetlb.1GB.usage_in_bytes
-hugetlb.1GB.failcnt
-hugetlb.64KB.limit_in_bytes
-hugetlb.64KB.max_usage_in_bytes
-hugetlb.64KB.usage_in_bytes
-hugetlb.64KB.failcnt
-hugetlb.32MB.limit_in_bytes
-hugetlb.32MB.max_usage_in_bytes
-hugetlb.32MB.usage_in_bytes
-hugetlb.32MB.failcnt
+  hugetlb.1GB.limit_in_bytes
+  hugetlb.1GB.max_usage_in_bytes
+  hugetlb.1GB.usage_in_bytes
+  hugetlb.1GB.failcnt
+  hugetlb.64KB.limit_in_bytes
+  hugetlb.64KB.max_usage_in_bytes
+  hugetlb.64KB.usage_in_bytes
+  hugetlb.64KB.failcnt
+  hugetlb.32MB.limit_in_bytes
+  hugetlb.32MB.max_usage_in_bytes
+  hugetlb.32MB.usage_in_bytes
+  hugetlb.32MB.failcnt
diff --git a/Documentation/cgroup-v1/index.rst b/Documentation/cgroup-v1/index.rst
new file mode 100644
index 000000000000..fe76d42edc11
--- /dev/null
+++ b/Documentation/cgroup-v1/index.rst
@@ -0,0 +1,30 @@
+:orphan:
+
+========================
+Control Groups version 1
+========================
+
+.. toctree::
+    :maxdepth: 1
+
+    cgroups
+
+    blkio-controller
+    cpuacct
+    cpusets
+    devices
+    freezer-subsystem
+    hugetlb
+    memcg_test
+    memory
+    net_cls
+    net_prio
+    pids
+    rdma
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/cgroup-v1/memcg_test.txt b/Documentation/cgroup-v1/memcg_test.rst
similarity index 62%
rename from Documentation/cgroup-v1/memcg_test.txt
rename to Documentation/cgroup-v1/memcg_test.rst
index 621e29ffb358..91bd18c6a514 100644
--- a/Documentation/cgroup-v1/memcg_test.txt
+++ b/Documentation/cgroup-v1/memcg_test.rst
@@ -1,32 +1,43 @@
-Memory Resource Controller(Memcg)  Implementation Memo.
+=====================================================
+Memory Resource Controller(Memcg) Implementation Memo
+=====================================================
+
 Last Updated: 2010/2
+
 Base Kernel Version: based on 2.6.33-rc7-mm(candidate for 34).
 
 Because VM is getting complex (one of reasons is memcg...), memcg's behavior
 is complex. This is a document for memcg's internal behavior.
 Please note that implementation details can be changed.
 
-(*) Topics on API should be in Documentation/cgroup-v1/memory.txt)
+(*) Topics on API should be in Documentation/cgroup-v1/memory.rst)
 
 0. How to record usage ?
+========================
+
    2 objects are used.
 
    page_cgroup ....an object per page.
+
 	Allocated at boot or memory hotplug. Freed at memory hot removal.
 
    swap_cgroup ... an entry per swp_entry.
+
 	Allocated at swapon(). Freed at swapoff().
 
    The page_cgroup has USED bit and double count against a page_cgroup never
    occurs. swap_cgroup is used only when a charged page is swapped-out.
 
 1. Charge
+=========
 
    a page/swp_entry may be charged (usage += PAGE_SIZE) at
 
 	mem_cgroup_try_charge()
 
 2. Uncharge
+===========
+
   a page/swp_entry may be uncharged (usage -= PAGE_SIZE) by
 
 	mem_cgroup_uncharge()
@@ -37,9 +48,12 @@ Please note that implementation details can be changed.
 	  disappears.
 
 3. charge-commit-cancel
+=======================
+
 	Memcg pages are charged in two steps:
-		mem_cgroup_try_charge()
-		mem_cgroup_commit_charge() or mem_cgroup_cancel_charge()
+
+		- mem_cgroup_try_charge()
+		- mem_cgroup_commit_charge() or mem_cgroup_cancel_charge()
 
 	At try_charge(), there are no flags to say "this page is charged".
 	at this point, usage += PAGE_SIZE.
@@ -51,6 +65,8 @@ Please note that implementation details can be changed.
 Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
 
 4. Anonymous
+============
+
 	Anonymous page is newly allocated at
 		  - page fault into MAP_ANONYMOUS mapping.
 		  - Copy-On-Write.
@@ -78,34 +94,45 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
 	(e) zap_pte() is called and swp_entry's refcnt -=1 -> 0.
 
 5. Page Cache
-   	Page Cache is charged at
+=============
+
+	Page Cache is charged at
 	- add_to_page_cache_locked().
 
 	The logic is very clear. (About migration, see below)
-	Note: __remove_from_page_cache() is called by remove_from_page_cache()
-	and __remove_mapping().
+
+	Note:
+	  __remove_from_page_cache() is called by remove_from_page_cache()
+	  and __remove_mapping().
 
 6. Shmem(tmpfs) Page Cache
+===========================
+
 	The best way to understand shmem's page state transition is to read
 	mm/shmem.c.
+
 	But brief explanation of the behavior of memcg around shmem will be
 	helpful to understand the logic.
 
 	Shmem's page (just leaf page, not direct/indirect block) can be on
+
 		- radix-tree of shmem's inode.
 		- SwapCache.
 		- Both on radix-tree and SwapCache. This happens at swap-in
 		  and swap-out,
 
 	It's charged when...
+
 	- A new page is added to shmem's radix-tree.
 	- A swp page is read. (move a charge from swap_cgroup to page_cgroup)
 
 7. Page Migration
+=================
 
 	mem_cgroup_migrate()
 
 8. LRU
+======
         Each memcg has its own private LRU. Now, its handling is under global
 	VM's control (means that it's handled under global pgdat->lru_lock).
 	Almost all routines around memcg's LRU is called by global LRU's
@@ -114,163 +141,211 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
 	A special function is mem_cgroup_isolate_pages(). This scans
 	memcg's private LRU and call __isolate_lru_page() to extract a page
 	from LRU.
+
 	(By __isolate_lru_page(), the page is removed from both of global and
-	 private LRU.)
+	private LRU.)
 
 
 9. Typical Tests.
+=================
 
  Tests for racy cases.
 
- 9.1 Small limit to memcg.
+9.1 Small limit to memcg.
+-------------------------
+
 	When you do test to do racy case, it's good test to set memcg's limit
 	to be very small rather than GB. Many races found in the test under
 	xKB or xxMB limits.
+
 	(Memory behavior under GB and Memory behavior under MB shows very
-	 different situation.)
+	different situation.)
+
+9.2 Shmem
+---------
 
- 9.2 Shmem
 	Historically, memcg's shmem handling was poor and we saw some amount
 	of troubles here. This is because shmem is page-cache but can be
 	SwapCache. Test with shmem/tmpfs is always good test.
 
- 9.3 Migration
+9.3 Migration
+-------------
+
 	For NUMA, migration is an another special case. To do easy test, cpuset
-	is useful. Following is a sample script to do migration.
+	is useful. Following is a sample script to do migration::
 
-	mount -t cgroup -o cpuset none /opt/cpuset
+		mount -t cgroup -o cpuset none /opt/cpuset
 
-	mkdir /opt/cpuset/01
-	echo 1 > /opt/cpuset/01/cpuset.cpus
-	echo 0 > /opt/cpuset/01/cpuset.mems
-	echo 1 > /opt/cpuset/01/cpuset.memory_migrate
-	mkdir /opt/cpuset/02
-	echo 1 > /opt/cpuset/02/cpuset.cpus
-	echo 1 > /opt/cpuset/02/cpuset.mems
-	echo 1 > /opt/cpuset/02/cpuset.memory_migrate
+		mkdir /opt/cpuset/01
+		echo 1 > /opt/cpuset/01/cpuset.cpus
+		echo 0 > /opt/cpuset/01/cpuset.mems
+		echo 1 > /opt/cpuset/01/cpuset.memory_migrate
+		mkdir /opt/cpuset/02
+		echo 1 > /opt/cpuset/02/cpuset.cpus
+		echo 1 > /opt/cpuset/02/cpuset.mems
+		echo 1 > /opt/cpuset/02/cpuset.memory_migrate
 
 	In above set, when you moves a task from 01 to 02, page migration to
 	node 0 to node 1 will occur. Following is a script to migrate all
-	under cpuset.
-	--
-	move_task()
-	{
-	for pid in $1
-        do
-                /bin/echo $pid >$2/tasks 2>/dev/null
-		echo -n $pid
-		echo -n " "
-        done
-	echo END
-	}
+	under cpuset.::
+
+		--
+		move_task()
+		{
+		for pid in $1
+		do
+			/bin/echo $pid >$2/tasks 2>/dev/null
+			echo -n $pid
+			echo -n " "
+		done
+		echo END
+		}
+
+		G1_TASK=`cat ${G1}/tasks`
+		G2_TASK=`cat ${G2}/tasks`
+		move_task "${G1_TASK}" ${G2} &
+		--
+
+9.4 Memory hotplug
+------------------
 
-	G1_TASK=`cat ${G1}/tasks`
-	G2_TASK=`cat ${G2}/tasks`
-	move_task "${G1_TASK}" ${G2} &
-	--
- 9.4 Memory hotplug.
 	memory hotplug test is one of good test.
-	to offline memory, do following.
-	# echo offline > /sys/devices/system/memory/memoryXXX/state
+
+	to offline memory, do following::
+
+		# echo offline > /sys/devices/system/memory/memoryXXX/state
+
 	(XXX is the place of memory)
+
 	This is an easy way to test page migration, too.
 
- 9.5 mkdir/rmdir
+9.5 mkdir/rmdir
+---------------
+
 	When using hierarchy, mkdir/rmdir test should be done.
-	Use tests like the following.
+	Use tests like the following::
 
-	echo 1 >/opt/cgroup/01/memory/use_hierarchy
-	mkdir /opt/cgroup/01/child_a
-	mkdir /opt/cgroup/01/child_b
+		echo 1 >/opt/cgroup/01/memory/use_hierarchy
+		mkdir /opt/cgroup/01/child_a
+		mkdir /opt/cgroup/01/child_b
 
-	set limit to 01.
-	add limit to 01/child_b
-	run jobs under child_a and child_b
+		set limit to 01.
+		add limit to 01/child_b
+		run jobs under child_a and child_b
 
-	create/delete following groups at random while jobs are running.
-	/opt/cgroup/01/child_a/child_aa
-	/opt/cgroup/01/child_b/child_bb
-	/opt/cgroup/01/child_c
+	create/delete following groups at random while jobs are running::
+
+		/opt/cgroup/01/child_a/child_aa
+		/opt/cgroup/01/child_b/child_bb
+		/opt/cgroup/01/child_c
 
 	running new jobs in new group is also good.
 
- 9.6 Mount with other subsystems.
+9.6 Mount with other subsystems
+-------------------------------
+
 	Mounting with other subsystems is a good test because there is a
 	race and lock dependency with other cgroup subsystems.
 
-	example)
-	# mount -t cgroup none /cgroup -o cpuset,memory,cpu,devices
+	example::
+
+		# mount -t cgroup none /cgroup -o cpuset,memory,cpu,devices
 
 	and do task move, mkdir, rmdir etc...under this.
 
- 9.7 swapoff.
+9.7 swapoff
+-----------
+
 	Besides management of swap is one of complicated parts of memcg,
 	call path of swap-in at swapoff is not same as usual swap-in path..
 	It's worth to be tested explicitly.
 
-	For example, test like following is good.
-	(Shell-A)
-	# mount -t cgroup none /cgroup -o memory
-	# mkdir /cgroup/test
-	# echo 40M > /cgroup/test/memory.limit_in_bytes
-	# echo 0 > /cgroup/test/tasks
+	For example, test like following is good:
+
+	(Shell-A)::
+
+		# mount -t cgroup none /cgroup -o memory
+		# mkdir /cgroup/test
+		# echo 40M > /cgroup/test/memory.limit_in_bytes
+		# echo 0 > /cgroup/test/tasks
+
 	Run malloc(100M) program under this. You'll see 60M of swaps.
-	(Shell-B)
-	# move all tasks in /cgroup/test to /cgroup
-	# /sbin/swapoff -a
-	# rmdir /cgroup/test
-	# kill malloc task.
+
+	(Shell-B)::
+
+		# move all tasks in /cgroup/test to /cgroup
+		# /sbin/swapoff -a
+		# rmdir /cgroup/test
+		# kill malloc task.
 
 	Of course, tmpfs v.s. swapoff test should be tested, too.
 
- 9.8 OOM-Killer
+9.8 OOM-Killer
+--------------
+
 	Out-of-memory caused by memcg's limit will kill tasks under
 	the memcg. When hierarchy is used, a task under hierarchy
 	will be killed by the kernel.
+
 	In this case, panic_on_oom shouldn't be invoked and tasks
 	in other groups shouldn't be killed.
 
 	It's not difficult to cause OOM under memcg as following.
-	Case A) when you can swapoff
-	#swapoff -a
-	#echo 50M > /memory.limit_in_bytes
+
+	Case A) when you can swapoff::
+
+		#swapoff -a
+		#echo 50M > /memory.limit_in_bytes
+
 	run 51M of malloc
 
-	Case B) when you use mem+swap limitation.
-	#echo 50M > memory.limit_in_bytes
-	#echo 50M > memory.memsw.limit_in_bytes
+	Case B) when you use mem+swap limitation::
+
+		#echo 50M > memory.limit_in_bytes
+		#echo 50M > memory.memsw.limit_in_bytes
+
 	run 51M of malloc
 
- 9.9 Move charges at task migration
+9.9 Move charges at task migration
+----------------------------------
+
 	Charges associated with a task can be moved along with task migration.
 
-	(Shell-A)
-	#mkdir /cgroup/A
-	#echo $$ >/cgroup/A/tasks
+	(Shell-A)::
+
+		#mkdir /cgroup/A
+		#echo $$ >/cgroup/A/tasks
+
 	run some programs which uses some amount of memory in /cgroup/A.
 
-	(Shell-B)
-	#mkdir /cgroup/B
-	#echo 1 >/cgroup/B/memory.move_charge_at_immigrate
-	#echo "pid of the program running in group A" >/cgroup/B/tasks
+	(Shell-B)::
 
-	You can see charges have been moved by reading *.usage_in_bytes or
+		#mkdir /cgroup/B
+		#echo 1 >/cgroup/B/memory.move_charge_at_immigrate
+		#echo "pid of the program running in group A" >/cgroup/B/tasks
+
+	You can see charges have been moved by reading ``*.usage_in_bytes`` or
 	memory.stat of both A and B.
-	See 8.2 of Documentation/cgroup-v1/memory.txt to see what value should be
-	written to move_charge_at_immigrate.
 
- 9.10 Memory thresholds
+	See 8.2 of Documentation/cgroup-v1/memory.rst to see what value should
+	be written to move_charge_at_immigrate.
+
+9.10 Memory thresholds
+----------------------
+
 	Memory controller implements memory thresholds using cgroups notification
 	API. You can use tools/cgroup/cgroup_event_listener.c to test it.
 
-	(Shell-A) Create cgroup and run event listener
-	# mkdir /cgroup/A
-	# ./cgroup_event_listener /cgroup/A/memory.usage_in_bytes 5M
+	(Shell-A) Create cgroup and run event listener::
 
-	(Shell-B) Add task to cgroup and try to allocate and free memory
-	# echo $$ >/cgroup/A/tasks
-	# a="$(dd if=/dev/zero bs=1M count=10)"
-	# a=
+		# mkdir /cgroup/A
+		# ./cgroup_event_listener /cgroup/A/memory.usage_in_bytes 5M
+
+	(Shell-B) Add task to cgroup and try to allocate and free memory::
+
+		# echo $$ >/cgroup/A/tasks
+		# a="$(dd if=/dev/zero bs=1M count=10)"
+		# a=
 
 	You will see message from cgroup_event_listener every time you cross
 	the thresholds.
diff --git a/Documentation/cgroup-v1/memory.txt b/Documentation/cgroup-v1/memory.rst
similarity index 71%
rename from Documentation/cgroup-v1/memory.txt
rename to Documentation/cgroup-v1/memory.rst
index a33cedf85427..41bdc038dad9 100644
--- a/Documentation/cgroup-v1/memory.txt
+++ b/Documentation/cgroup-v1/memory.rst
@@ -1,22 +1,26 @@
+==========================
 Memory Resource Controller
+==========================
 
-NOTE: This document is hopelessly outdated and it asks for a complete
+NOTE:
+      This document is hopelessly outdated and it asks for a complete
       rewrite. It still contains a useful information so we are keeping it
       here but make sure to check the current code if you need a deeper
       understanding.
 
-NOTE: The Memory Resource Controller has generically been referred to as the
+NOTE:
+      The Memory Resource Controller has generically been referred to as the
       memory controller in this document. Do not confuse memory controller
       used here with the memory controller that is used in hardware.
 
-(For editors)
-In this document:
+(For editors) In this document:
       When we mention a cgroup (cgroupfs's directory) with memory controller,
       we call it "memory cgroup". When you see git-log and source code, you'll
       see patch's title and function names tend to use "memcg".
       In this document, we avoid using it.
 
 Benefits and Purpose of the memory controller
+=============================================
 
 The memory controller isolates the memory behaviour of a group of tasks
 from the rest of the system. The article on LWN [12] mentions some probable
@@ -38,6 +42,7 @@ e. There are several other use cases; find one or use the controller just
 Current Status: linux-2.6.34-mmotm(development version of 2010/April)
 
 Features:
+
  - accounting anonymous pages, file caches, swap caches usage and limiting them.
  - pages are linked to per-memcg LRU exclusively, and there is no global LRU.
  - optionally, memory+swap usage can be accounted and limited.
@@ -54,41 +59,48 @@ Features:
 
 Brief summary of control files.
 
- tasks				 # attach a task(thread) and show list of threads
- cgroup.procs			 # show list of processes
- cgroup.event_control		 # an interface for event_fd()
- memory.usage_in_bytes		 # show current usage for memory
-				 (See 5.5 for details)
- memory.memsw.usage_in_bytes	 # show current usage for memory+Swap
-				 (See 5.5 for details)
- memory.limit_in_bytes		 # set/show limit of memory usage
- memory.memsw.limit_in_bytes	 # set/show limit of memory+Swap usage
- memory.failcnt			 # show the number of memory usage hits limits
- memory.memsw.failcnt		 # show the number of memory+Swap hits limits
- memory.max_usage_in_bytes	 # show max memory usage recorded
- memory.memsw.max_usage_in_bytes # show max memory+Swap usage recorded
- memory.soft_limit_in_bytes	 # set/show soft limit of memory usage
- memory.stat			 # show various statistics
- memory.use_hierarchy		 # set/show hierarchical account enabled
- memory.force_empty		 # trigger forced page reclaim
- memory.pressure_level		 # set memory pressure notifications
- memory.swappiness		 # set/show swappiness parameter of vmscan
-				 (See sysctl's vm.swappiness)
- memory.move_charge_at_immigrate # set/show controls of moving charges
- memory.oom_control		 # set/show oom controls.
- memory.numa_stat		 # show the number of memory usage per numa node
+==================================== ==========================================
+ tasks				     attach a task(thread) and show list of
+				     threads
+ cgroup.procs			     show list of processes
+ cgroup.event_control		     an interface for event_fd()
+ memory.usage_in_bytes		     show current usage for memory
+				     (See 5.5 for details)
+ memory.memsw.usage_in_bytes	     show current usage for memory+Swap
+				     (See 5.5 for details)
+ memory.limit_in_bytes		     set/show limit of memory usage
+ memory.memsw.limit_in_bytes	     set/show limit of memory+Swap usage
+ memory.failcnt			     show the number of memory usage hits limits
+ memory.memsw.failcnt		     show the number of memory+Swap hits limits
+ memory.max_usage_in_bytes	     show max memory usage recorded
+ memory.memsw.max_usage_in_bytes     show max memory+Swap usage recorded
+ memory.soft_limit_in_bytes	     set/show soft limit of memory usage
+ memory.stat			     show various statistics
+ memory.use_hierarchy		     set/show hierarchical account enabled
+ memory.force_empty		     trigger forced page reclaim
+ memory.pressure_level		     set memory pressure notifications
+ memory.swappiness		     set/show swappiness parameter of vmscan
+				     (See sysctl's vm.swappiness)
+ memory.move_charge_at_immigrate     set/show controls of moving charges
+ memory.oom_control		     set/show oom controls.
+ memory.numa_stat		     show the number of memory usage per numa
+				     node
 
- memory.kmem.limit_in_bytes      # set/show hard limit for kernel memory
- memory.kmem.usage_in_bytes      # show current kernel memory allocation
- memory.kmem.failcnt             # show the number of kernel memory usage hits limits
- memory.kmem.max_usage_in_bytes  # show max kernel memory usage recorded
+ memory.kmem.limit_in_bytes          set/show hard limit for kernel memory
+ memory.kmem.usage_in_bytes          show current kernel memory allocation
+ memory.kmem.failcnt                 show the number of kernel memory usage
+				     hits limits
+ memory.kmem.max_usage_in_bytes      show max kernel memory usage recorded
 
- memory.kmem.tcp.limit_in_bytes  # set/show hard limit for tcp buf memory
- memory.kmem.tcp.usage_in_bytes  # show current tcp buf memory allocation
- memory.kmem.tcp.failcnt            # show the number of tcp buf memory usage hits limits
- memory.kmem.tcp.max_usage_in_bytes # show max tcp buf memory usage recorded
+ memory.kmem.tcp.limit_in_bytes      set/show hard limit for tcp buf memory
+ memory.kmem.tcp.usage_in_bytes      show current tcp buf memory allocation
+ memory.kmem.tcp.failcnt             show the number of tcp buf memory usage
+				     hits limits
+ memory.kmem.tcp.max_usage_in_bytes  show max tcp buf memory usage recorded
+==================================== ==========================================
 
 1. History
+==========
 
 The memory controller has a long history. A request for comments for the memory
 controller was posted by Balbir Singh [1]. At the time the RFC was posted
@@ -103,6 +115,7 @@ at version 6; it combines both mapped (RSS) and unmapped Page
 Cache Control [11].
 
 2. Memory Control
+=================
 
 Memory is a unique resource in the sense that it is present in a limited
 amount. If a task requires a lot of CPU processing, the task can spread
@@ -120,6 +133,7 @@ are:
 The memory controller is the first controller developed.
 
 2.1. Design
+-----------
 
 The core of the design is a counter called the page_counter. The
 page_counter tracks the current memory usage and limit of the group of
@@ -127,6 +141,9 @@ processes associated with the controller. Each cgroup has a memory controller
 specific data structure (mem_cgroup) associated with it.
 
 2.2. Accounting
+---------------
+
+::
 
 		+--------------------+
 		|  mem_cgroup        |
@@ -165,6 +182,7 @@ updated. page_cgroup has its own LRU on cgroup.
 (*) page_cgroup structure is allocated at boot/memory-hotplug time.
 
 2.2.1 Accounting details
+------------------------
 
 All mapped anon pages (RSS) and cache pages (Page Cache) are accounted.
 Some pages which are never reclaimable and will not be on the LRU
@@ -191,6 +209,7 @@ Note: we just account pages-on-LRU because our purpose is to control amount
 of used pages; not-on-LRU pages tend to be out-of-control from VM view.
 
 2.3 Shared Page Accounting
+--------------------------
 
 Shared pages are accounted on the basis of the first touch approach. The
 cgroup that first touches a page is accounted for the page. The principle
@@ -207,11 +226,13 @@ be backed into memory in force, charges for pages are accounted against the
 caller of swapoff rather than the users of shmem.
 
 2.4 Swap Extension (CONFIG_MEMCG_SWAP)
+--------------------------------------
 
 Swap Extension allows you to record charge for swap. A swapped-in page is
 charged back to original page allocator if possible.
 
 When swap is accounted, following files are added.
+
  - memory.memsw.usage_in_bytes.
  - memory.memsw.limit_in_bytes.
 
@@ -224,14 +245,16 @@ In this case, setting memsw.limit_in_bytes=3G will prevent bad use of swap.
 By using the memsw limit, you can avoid system OOM which can be caused by swap
 shortage.
 
-* why 'memory+swap' rather than swap.
+**why 'memory+swap' rather than swap**
+
 The global LRU(kswapd) can swap out arbitrary pages. Swap-out means
 to move account from memory to swap...there is no change in usage of
 memory+swap. In other words, when we want to limit the usage of swap without
 affecting global LRU, memory+swap limit is better than just limiting swap from
 an OS point of view.
 
-* What happens when a cgroup hits memory.memsw.limit_in_bytes
+**What happens when a cgroup hits memory.memsw.limit_in_bytes**
+
 When a cgroup hits memory.memsw.limit_in_bytes, it's useless to do swap-out
 in this cgroup. Then, swap-out will not be done by cgroup routine and file
 caches are dropped. But as mentioned above, global LRU can do swapout memory
@@ -239,6 +262,7 @@ from it for sanity of the system's memory management state. You can't forbid
 it by cgroup.
 
 2.5 Reclaim
+-----------
 
 Each cgroup maintains a per cgroup LRU which has the same structure as
 global VM. When a cgroup goes over its limit, we first try
@@ -251,29 +275,36 @@ The reclaim algorithm has not been modified for cgroups, except that
 pages that are selected for reclaiming come from the per-cgroup LRU
 list.
 
-NOTE: Reclaim does not work for the root cgroup, since we cannot set any
-limits on the root cgroup.
+NOTE:
+  Reclaim does not work for the root cgroup, since we cannot set any
+  limits on the root cgroup.
 
-Note2: When panic_on_oom is set to "2", the whole system will panic.
+Note2:
+  When panic_on_oom is set to "2", the whole system will panic.
 
 When oom event notifier is registered, event will be delivered.
 (See oom_control section)
 
 2.6 Locking
+-----------
 
    lock_page_cgroup()/unlock_page_cgroup() should not be called under
    the i_pages lock.
 
    Other lock order is following:
+
    PG_locked.
-   mm->page_table_lock
-       pgdat->lru_lock
-	  lock_page_cgroup.
+     mm->page_table_lock
+         pgdat->lru_lock
+	   lock_page_cgroup.
+
   In many cases, just lock_page_cgroup() is called.
+
   per-zone-per-cgroup LRU (cgroup's private LRU) is just guarded by
   pgdat->lru_lock, it has no lock of its own.
 
 2.7 Kernel Memory Extension (CONFIG_MEMCG_KMEM)
+-----------------------------------------------
 
 With the Kernel memory extension, the Memory Controller is able to limit
 the amount of kernel memory used by the system. Kernel memory is fundamentally
@@ -288,6 +319,7 @@ Kernel memory limits are not imposed for the root cgroup. Usage for the root
 cgroup may or may not be accounted. The memory used is accumulated into
 memory.kmem.usage_in_bytes, or in a separate counter when it makes sense.
 (currently only for tcp).
+
 The main "kmem" counter is fed into the main counter, so kmem charges will
 also be visible from the user counter.
 
@@ -295,36 +327,42 @@ Currently no soft limit is implemented for kernel memory. It is future work
 to trigger slab reclaim when those limits are reached.
 
 2.7.1 Current Kernel Memory resources accounted
+-----------------------------------------------
 
-* stack pages: every process consumes some stack pages. By accounting into
-kernel memory, we prevent new processes from being created when the kernel
-memory usage is too high.
+stack pages:
+  every process consumes some stack pages. By accounting into
+  kernel memory, we prevent new processes from being created when the kernel
+  memory usage is too high.
 
-* slab pages: pages allocated by the SLAB or SLUB allocator are tracked. A copy
-of each kmem_cache is created every time the cache is touched by the first time
-from inside the memcg. The creation is done lazily, so some objects can still be
-skipped while the cache is being created. All objects in a slab page should
-belong to the same memcg. This only fails to hold when a task is migrated to a
-different memcg during the page allocation by the cache.
+slab pages:
+  pages allocated by the SLAB or SLUB allocator are tracked. A copy
+  of each kmem_cache is created every time the cache is touched by the first time
+  from inside the memcg. The creation is done lazily, so some objects can still be
+  skipped while the cache is being created. All objects in a slab page should
+  belong to the same memcg. This only fails to hold when a task is migrated to a
+  different memcg during the page allocation by the cache.
 
-* sockets memory pressure: some sockets protocols have memory pressure
-thresholds. The Memory Controller allows them to be controlled individually
-per cgroup, instead of globally.
+sockets memory pressure:
+  some sockets protocols have memory pressure
+  thresholds. The Memory Controller allows them to be controlled individually
+  per cgroup, instead of globally.
 
-* tcp memory pressure: sockets memory pressure for the tcp protocol.
+tcp memory pressure:
+  sockets memory pressure for the tcp protocol.
 
 2.7.2 Common use cases
+----------------------
 
 Because the "kmem" counter is fed to the main user counter, kernel memory can
 never be limited completely independently of user memory. Say "U" is the user
 limit, and "K" the kernel limit. There are three possible ways limits can be
 set:
 
-    U != 0, K = unlimited:
+U != 0, K = unlimited:
     This is the standard memcg limitation mechanism already present before kmem
     accounting. Kernel memory is completely ignored.
 
-    U != 0, K < U:
+U != 0, K < U:
     Kernel memory is a subset of the user memory. This setup is useful in
     deployments where the total amount of memory per-cgroup is overcommited.
     Overcommiting kernel memory limits is definitely not recommended, since the
@@ -332,19 +370,23 @@ set:
     In this case, the admin could set up K so that the sum of all groups is
     never greater than the total memory, and freely set U at the cost of his
     QoS.
-    WARNING: In the current implementation, memory reclaim will NOT be
+
+WARNING:
+    In the current implementation, memory reclaim will NOT be
     triggered for a cgroup when it hits K while staying below U, which makes
     this setup impractical.
 
-    U != 0, K >= U:
+U != 0, K >= U:
     Since kmem charges will also be fed to the user counter and reclaim will be
     triggered for the cgroup for both kinds of memory. This setup gives the
     admin a unified view of memory, and it is also useful for people who just
     want to track kernel memory usage.
 
 3. User Interface
+=================
 
 3.0. Configuration
+------------------
 
 a. Enable CONFIG_CGROUPS
 b. Enable CONFIG_MEMCG
@@ -352,39 +394,53 @@ c. Enable CONFIG_MEMCG_SWAP (to use swap extension)
 d. Enable CONFIG_MEMCG_KMEM (to use kmem extension)
 
 3.1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
-# mount -t tmpfs none /sys/fs/cgroup
-# mkdir /sys/fs/cgroup/memory
-# mount -t cgroup none /sys/fs/cgroup/memory -o memory
+-------------------------------------------------------------------
 
-3.2. Make the new group and move bash into it
-# mkdir /sys/fs/cgroup/memory/0
-# echo $$ > /sys/fs/cgroup/memory/0/tasks
+::
 
-Since now we're in the 0 cgroup, we can alter the memory limit:
-# echo 4M > /sys/fs/cgroup/memory/0/memory.limit_in_bytes
+	# mount -t tmpfs none /sys/fs/cgroup
+	# mkdir /sys/fs/cgroup/memory
+	# mount -t cgroup none /sys/fs/cgroup/memory -o memory
 
-NOTE: We can use a suffix (k, K, m, M, g or G) to indicate values in kilo,
-mega or gigabytes. (Here, Kilo, Mega, Giga are Kibibytes, Mebibytes, Gibibytes.)
+3.2. Make the new group and move bash into it::
 
-NOTE: We can write "-1" to reset the *.limit_in_bytes(unlimited).
-NOTE: We cannot set limits on the root cgroup any more.
+	# mkdir /sys/fs/cgroup/memory/0
+	# echo $$ > /sys/fs/cgroup/memory/0/tasks
 
-# cat /sys/fs/cgroup/memory/0/memory.limit_in_bytes
-4194304
+Since now we're in the 0 cgroup, we can alter the memory limit::
 
-We can check the usage:
-# cat /sys/fs/cgroup/memory/0/memory.usage_in_bytes
-1216512
+	# echo 4M > /sys/fs/cgroup/memory/0/memory.limit_in_bytes
+
+NOTE:
+  We can use a suffix (k, K, m, M, g or G) to indicate values in kilo,
+  mega or gigabytes. (Here, Kilo, Mega, Giga are Kibibytes, Mebibytes,
+  Gibibytes.)
+
+NOTE:
+  We can write "-1" to reset the ``*.limit_in_bytes(unlimited)``.
+
+NOTE:
+  We cannot set limits on the root cgroup any more.
+
+::
+
+  # cat /sys/fs/cgroup/memory/0/memory.limit_in_bytes
+  4194304
+
+We can check the usage::
+
+  # cat /sys/fs/cgroup/memory/0/memory.usage_in_bytes
+  1216512
 
 A successful write to this file does not guarantee a successful setting of
 this limit to the value written into the file. This can be due to a
 number of factors, such as rounding up to page boundaries or the total
 availability of memory on the system. The user is required to re-read
-this file after a write to guarantee the value committed by the kernel.
+this file after a write to guarantee the value committed by the kernel::
 
-# echo 1 > memory.limit_in_bytes
-# cat memory.limit_in_bytes
-4096
+  # echo 1 > memory.limit_in_bytes
+  # cat memory.limit_in_bytes
+  4096
 
 The memory.failcnt field gives the number of times that the cgroup limit was
 exceeded.
@@ -393,6 +449,7 @@ The memory.stat file gives accounting information. Now, the number of
 caches, RSS and Active pages/Inactive pages are shown.
 
 4. Testing
+==========
 
 For testing features and implementation, see memcg_test.txt.
 
@@ -408,6 +465,7 @@ But the above two are testing extreme situations.
 Trying usual test under memory controller is always helpful.
 
 4.1 Troubleshooting
+-------------------
 
 Sometimes a user might find that the application under a cgroup is
 terminated by the OOM killer. There are several causes for this:
@@ -422,6 +480,7 @@ To know what happens, disabling OOM_Kill as per "10. OOM Control" (below) and
 seeing what happens will be helpful.
 
 4.2 Task migration
+------------------
 
 When a task migrates from one cgroup to another, its charge is not
 carried forward by default. The pages allocated from the original cgroup still
@@ -432,6 +491,7 @@ You can move charges of a task along with task migration.
 See 8. "Move charges at task migration"
 
 4.3 Removing a cgroup
+---------------------
 
 A cgroup can be removed by rmdir, but as discussed in sections 4.1 and 4.2, a
 cgroup might have some charge associated with it, even though all
@@ -448,13 +508,15 @@ will be charged as a new owner of it.
 
 About use_hierarchy, see Section 6.
 
-5. Misc. interfaces.
+5. Misc. interfaces
+===================
 
 5.1 force_empty
+---------------
   memory.force_empty interface is provided to make cgroup's memory usage empty.
-  When writing anything to this
+  When writing anything to this::
 
-  # echo 0 > memory.force_empty
+    # echo 0 > memory.force_empty
 
   the cgroup will be reclaimed and as many pages reclaimed as possible.
 
@@ -471,50 +533,61 @@ About use_hierarchy, see Section 6.
   About use_hierarchy, see Section 6.
 
 5.2 stat file
+-------------
 
 memory.stat file includes following statistics
 
-# per-memory cgroup local status
-cache		- # of bytes of page cache memory.
-rss		- # of bytes of anonymous and swap cache memory (includes
+per-memory cgroup local status
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+=============== ===============================================================
+cache		# of bytes of page cache memory.
+rss		# of bytes of anonymous and swap cache memory (includes
 		transparent hugepages).
-rss_huge	- # of bytes of anonymous transparent hugepages.
-mapped_file	- # of bytes of mapped file (includes tmpfs/shmem)
-pgpgin		- # of charging events to the memory cgroup. The charging
+rss_huge	# of bytes of anonymous transparent hugepages.
+mapped_file	# of bytes of mapped file (includes tmpfs/shmem)
+pgpgin		# of charging events to the memory cgroup. The charging
 		event happens each time a page is accounted as either mapped
 		anon page(RSS) or cache page(Page Cache) to the cgroup.
-pgpgout		- # of uncharging events to the memory cgroup. The uncharging
+pgpgout		# of uncharging events to the memory cgroup. The uncharging
 		event happens each time a page is unaccounted from the cgroup.
-swap		- # of bytes of swap usage
-dirty		- # of bytes that are waiting to get written back to the disk.
-writeback	- # of bytes of file/anon cache that are queued for syncing to
+swap		# of bytes of swap usage
+dirty		# of bytes that are waiting to get written back to the disk.
+writeback	# of bytes of file/anon cache that are queued for syncing to
 		disk.
-inactive_anon	- # of bytes of anonymous and swap cache memory on inactive
+inactive_anon	# of bytes of anonymous and swap cache memory on inactive
 		LRU list.
-active_anon	- # of bytes of anonymous and swap cache memory on active
+active_anon	# of bytes of anonymous and swap cache memory on active
 		LRU list.
-inactive_file	- # of bytes of file-backed memory on inactive LRU list.
-active_file	- # of bytes of file-backed memory on active LRU list.
-unevictable	- # of bytes of memory that cannot be reclaimed (mlocked etc).
+inactive_file	# of bytes of file-backed memory on inactive LRU list.
+active_file	# of bytes of file-backed memory on active LRU list.
+unevictable	# of bytes of memory that cannot be reclaimed (mlocked etc).
+=============== ===============================================================
 
-# status considering hierarchy (see memory.use_hierarchy settings)
+status considering hierarchy (see memory.use_hierarchy settings)
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-hierarchical_memory_limit - # of bytes of memory limit with regard to hierarchy
-			under which the memory cgroup is
-hierarchical_memsw_limit - # of bytes of memory+swap limit with regard to
-			hierarchy under which memory cgroup is.
+========================= ===================================================
+hierarchical_memory_limit # of bytes of memory limit with regard to hierarchy
+			  under which the memory cgroup is
+hierarchical_memsw_limit  # of bytes of memory+swap limit with regard to
+			  hierarchy under which memory cgroup is.
 
-total_<counter>		- # hierarchical version of <counter>, which in
-			addition to the cgroup's own value includes the
-			sum of all hierarchical children's values of
-			<counter>, i.e. total_cache
+total_<counter>		  # hierarchical version of <counter>, which in
+			  addition to the cgroup's own value includes the
+			  sum of all hierarchical children's values of
+			  <counter>, i.e. total_cache
+========================= ===================================================
 
-# The following additional stats are dependent on CONFIG_DEBUG_VM.
+The following additional stats are dependent on CONFIG_DEBUG_VM
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-recent_rotated_anon	- VM internal parameter. (see mm/vmscan.c)
-recent_rotated_file	- VM internal parameter. (see mm/vmscan.c)
-recent_scanned_anon	- VM internal parameter. (see mm/vmscan.c)
-recent_scanned_file	- VM internal parameter. (see mm/vmscan.c)
+========================= ========================================
+recent_rotated_anon	  VM internal parameter. (see mm/vmscan.c)
+recent_rotated_file	  VM internal parameter. (see mm/vmscan.c)
+recent_scanned_anon	  VM internal parameter. (see mm/vmscan.c)
+recent_scanned_file	  VM internal parameter. (see mm/vmscan.c)
+========================= ========================================
 
 Memo:
 	recent_rotated means recent frequency of LRU rotation.
@@ -525,12 +598,15 @@ Note:
 	Only anonymous and swap cache memory is listed as part of 'rss' stat.
 	This should not be confused with the true 'resident set size' or the
 	amount of physical memory used by the cgroup.
+
 	'rss + mapped_file" will give you resident set size of cgroup.
+
 	(Note: file and shmem may be shared among other cgroups. In that case,
-	 mapped_file is accounted only when the memory cgroup is owner of page
-	 cache.)
+	mapped_file is accounted only when the memory cgroup is owner of page
+	cache.)
 
 5.3 swappiness
+--------------
 
 Overrides /proc/sys/vm/swappiness for the particular group. The tunable
 in the root cgroup corresponds to the global swappiness setting.
@@ -541,16 +617,19 @@ there is a swap storage available. This might lead to memcg OOM killer
 if there are no file pages to reclaim.
 
 5.4 failcnt
+-----------
 
 A memory cgroup provides memory.failcnt and memory.memsw.failcnt files.
 This failcnt(== failure count) shows the number of times that a usage counter
 hit its limit. When a memory cgroup hits a limit, failcnt increases and
 memory under it will be reclaimed.
 
-You can reset failcnt by writing 0 to failcnt file.
-# echo 0 > .../memory.failcnt
+You can reset failcnt by writing 0 to failcnt file::
+
+	# echo 0 > .../memory.failcnt
 
 5.5 usage_in_bytes
+------------------
 
 For efficiency, as other kernel components, memory cgroup uses some optimization
 to avoid unnecessary cacheline false sharing. usage_in_bytes is affected by the
@@ -560,6 +639,7 @@ If you want to know more exact memory usage, you should use RSS+CACHE(+SWAP)
 value in memory.stat(see 5.2).
 
 5.6 numa_stat
+-------------
 
 This is similar to numa_maps but operates on a per-memcg basis.  This is
 useful for providing visibility into the numa locality information within
@@ -571,22 +651,23 @@ Each memcg's numa_stat file includes "total", "file", "anon" and "unevictable"
 per-node page counts including "hierarchical_<counter>" which sums up all
 hierarchical children's values in addition to the memcg's own value.
 
-The output format of memory.numa_stat is:
+The output format of memory.numa_stat is::
 
-total=<total pages> N0=<node 0 pages> N1=<node 1 pages> ...
-file=<total file pages> N0=<node 0 pages> N1=<node 1 pages> ...
-anon=<total anon pages> N0=<node 0 pages> N1=<node 1 pages> ...
-unevictable=<total anon pages> N0=<node 0 pages> N1=<node 1 pages> ...
-hierarchical_<counter>=<counter pages> N0=<node 0 pages> N1=<node 1 pages> ...
+  total=<total pages> N0=<node 0 pages> N1=<node 1 pages> ...
+  file=<total file pages> N0=<node 0 pages> N1=<node 1 pages> ...
+  anon=<total anon pages> N0=<node 0 pages> N1=<node 1 pages> ...
+  unevictable=<total anon pages> N0=<node 0 pages> N1=<node 1 pages> ...
+  hierarchical_<counter>=<counter pages> N0=<node 0 pages> N1=<node 1 pages> ...
 
 The "total" count is sum of file + anon + unevictable.
 
 6. Hierarchy support
+====================
 
 The memory controller supports a deep hierarchy and hierarchical accounting.
 The hierarchy is created by creating the appropriate cgroups in the
 cgroup filesystem. Consider for example, the following cgroup filesystem
-hierarchy
+hierarchy::
 
 	       root
 	     /  |   \
@@ -603,24 +684,28 @@ limit, the reclaim algorithm reclaims from the tasks in the ancestor and the
 children of the ancestor.
 
 6.1 Enabling hierarchical accounting and reclaim
+------------------------------------------------
 
 A memory cgroup by default disables the hierarchy feature. Support
-can be enabled by writing 1 to memory.use_hierarchy file of the root cgroup
+can be enabled by writing 1 to memory.use_hierarchy file of the root cgroup::
 
-# echo 1 > memory.use_hierarchy
+	# echo 1 > memory.use_hierarchy
 
-The feature can be disabled by
+The feature can be disabled by::
 
-# echo 0 > memory.use_hierarchy
+	# echo 0 > memory.use_hierarchy
 
-NOTE1: Enabling/disabling will fail if either the cgroup already has other
+NOTE1:
+       Enabling/disabling will fail if either the cgroup already has other
        cgroups created below it, or if the parent cgroup has use_hierarchy
        enabled.
 
-NOTE2: When panic_on_oom is set to "2", the whole system will panic in
+NOTE2:
+       When panic_on_oom is set to "2", the whole system will panic in
        case of an OOM event in any cgroup.
 
 7. Soft limits
+==============
 
 Soft limits allow for greater sharing of memory. The idea behind soft limits
 is to allow control groups to use as much of the memory as needed, provided
@@ -640,22 +725,26 @@ hints/setup. Currently soft limit based reclaim is set up such that
 it gets invoked from balance_pgdat (kswapd).
 
 7.1 Interface
+-------------
 
 Soft limits can be setup by using the following commands (in this example we
-assume a soft limit of 256 MiB)
+assume a soft limit of 256 MiB)::
 
-# echo 256M > memory.soft_limit_in_bytes
+	# echo 256M > memory.soft_limit_in_bytes
 
-If we want to change this to 1G, we can at any time use
+If we want to change this to 1G, we can at any time use::
 
-# echo 1G > memory.soft_limit_in_bytes
+	# echo 1G > memory.soft_limit_in_bytes
 
-NOTE1: Soft limits take effect over a long period of time, since they involve
+NOTE1:
+       Soft limits take effect over a long period of time, since they involve
        reclaiming memory for balancing between memory cgroups
-NOTE2: It is recommended to set the soft limit always below the hard limit,
+NOTE2:
+       It is recommended to set the soft limit always below the hard limit,
        otherwise the hard limit will take precedence.
 
 8. Move charges at task migration
+=================================
 
 Users can move charges associated with a task along with task migration, that
 is, uncharge task's pages from the old cgroup and charge them to the new cgroup.
@@ -663,60 +752,71 @@ This feature is not supported in !CONFIG_MMU environments because of lack of
 page tables.
 
 8.1 Interface
+-------------
 
 This feature is disabled by default. It can be enabled (and disabled again) by
 writing to memory.move_charge_at_immigrate of the destination cgroup.
 
-If you want to enable it:
+If you want to enable it::
 
-# echo (some positive value) > memory.move_charge_at_immigrate
+	# echo (some positive value) > memory.move_charge_at_immigrate
 
-Note: Each bits of move_charge_at_immigrate has its own meaning about what type
+Note:
+      Each bits of move_charge_at_immigrate has its own meaning about what type
       of charges should be moved. See 8.2 for details.
-Note: Charges are moved only when you move mm->owner, in other words,
+Note:
+      Charges are moved only when you move mm->owner, in other words,
       a leader of a thread group.
-Note: If we cannot find enough space for the task in the destination cgroup, we
+Note:
+      If we cannot find enough space for the task in the destination cgroup, we
       try to make space by reclaiming memory. Task migration may fail if we
       cannot make enough space.
-Note: It can take several seconds if you move charges much.
+Note:
+      It can take several seconds if you move charges much.
 
-And if you want disable it again:
+And if you want disable it again::
 
-# echo 0 > memory.move_charge_at_immigrate
+	# echo 0 > memory.move_charge_at_immigrate
 
 8.2 Type of charges which can be moved
+--------------------------------------
 
 Each bit in move_charge_at_immigrate has its own meaning about what type of
 charges should be moved. But in any case, it must be noted that an account of
 a page or a swap can be moved only when it is charged to the task's current
 (old) memory cgroup.
 
-  bit | what type of charges would be moved ?
- -----+------------------------------------------------------------------------
-   0  | A charge of an anonymous page (or swap of it) used by the target task.
-      | You must enable Swap Extension (see 2.4) to enable move of swap charges.
- -----+------------------------------------------------------------------------
-   1  | A charge of file pages (normal file, tmpfs file (e.g. ipc shared memory)
-      | and swaps of tmpfs file) mmapped by the target task. Unlike the case of
-      | anonymous pages, file pages (and swaps) in the range mmapped by the task
-      | will be moved even if the task hasn't done page fault, i.e. they might
-      | not be the task's "RSS", but other task's "RSS" that maps the same file.
-      | And mapcount of the page is ignored (the page can be moved even if
-      | page_mapcount(page) > 1). You must enable Swap Extension (see 2.4) to
-      | enable move of swap charges.
++---+--------------------------------------------------------------------------+
+|bit| what type of charges would be moved ?                                    |
++===+==========================================================================+
+| 0 | A charge of an anonymous page (or swap of it) used by the target task.   |
+|   | You must enable Swap Extension (see 2.4) to enable move of swap charges. |
++---+--------------------------------------------------------------------------+
+| 1 | A charge of file pages (normal file, tmpfs file (e.g. ipc shared memory) |
+|   | and swaps of tmpfs file) mmapped by the target task. Unlike the case of  |
+|   | anonymous pages, file pages (and swaps) in the range mmapped by the task |
+|   | will be moved even if the task hasn't done page fault, i.e. they might   |
+|   | not be the task's "RSS", but other task's "RSS" that maps the same file. |
+|   | And mapcount of the page is ignored (the page can be moved even if       |
+|   | page_mapcount(page) > 1). You must enable Swap Extension (see 2.4) to    |
+|   | enable move of swap charges.                                             |
++---+--------------------------------------------------------------------------+
 
 8.3 TODO
+--------
 
 - All of moving charge operations are done under cgroup_mutex. It's not good
   behavior to hold the mutex too long, so we may need some trick.
 
 9. Memory thresholds
+====================
 
 Memory cgroup implements memory thresholds using the cgroups notification
 API (see cgroups.txt). It allows to register multiple memory and memsw
 thresholds and gets notifications when it crosses.
 
 To register a threshold, an application must:
+
 - create an eventfd using eventfd(2);
 - open memory.usage_in_bytes or memory.memsw.usage_in_bytes;
 - write string like "<event_fd> <fd of memory.usage_in_bytes> <threshold>" to
@@ -728,6 +828,7 @@ threshold in any direction.
 It's applicable for root and non-root cgroup.
 
 10. OOM Control
+===============
 
 memory.oom_control file is for OOM notification and other controls.
 
@@ -736,6 +837,7 @@ API (See cgroups.txt). It allows to register multiple OOM notification
 delivery and gets notification when OOM happens.
 
 To register a notifier, an application must:
+
  - create an eventfd using eventfd(2)
  - open memory.oom_control file
  - write string like "<event_fd> <fd of memory.oom_control>" to
@@ -752,8 +854,11 @@ If OOM-killer is disabled, tasks under cgroup will hang/sleep
 in memory cgroup's OOM-waitqueue when they request accountable memory.
 
 For running them, you have to relax the memory cgroup's OOM status by
+
 	* enlarge limit or reduce usage.
+
 To reduce usage,
+
 	* kill some tasks.
 	* move some tasks to other group with account migration.
 	* remove some files (on tmpfs?)
@@ -761,11 +866,14 @@ To reduce usage,
 Then, stopped tasks will work again.
 
 At reading, current status of OOM is shown.
-	oom_kill_disable 0 or 1 (if 1, oom-killer is disabled)
-	under_oom	 0 or 1 (if 1, the memory cgroup is under OOM, tasks may
-				 be stopped.)
+
+	- oom_kill_disable 0 or 1
+	  (if 1, oom-killer is disabled)
+	- under_oom	   0 or 1
+	  (if 1, the memory cgroup is under OOM, tasks may be stopped.)
 
 11. Memory Pressure
+===================
 
 The pressure level notifications can be used to monitor the memory
 allocation cost; based on the pressure, applications can implement
@@ -840,21 +948,22 @@ Test:
 
    Here is a small script example that makes a new cgroup, sets up a
    memory limit, sets up a notification in the cgroup and then makes child
-   cgroup experience a critical pressure:
+   cgroup experience a critical pressure::
 
-   # cd /sys/fs/cgroup/memory/
-   # mkdir foo
-   # cd foo
-   # cgroup_event_listener memory.pressure_level low,hierarchy &
-   # echo 8000000 > memory.limit_in_bytes
-   # echo 8000000 > memory.memsw.limit_in_bytes
-   # echo $$ > tasks
-   # dd if=/dev/zero | read x
+	# cd /sys/fs/cgroup/memory/
+	# mkdir foo
+	# cd foo
+	# cgroup_event_listener memory.pressure_level low,hierarchy &
+	# echo 8000000 > memory.limit_in_bytes
+	# echo 8000000 > memory.memsw.limit_in_bytes
+	# echo $$ > tasks
+	# dd if=/dev/zero | read x
 
    (Expect a bunch of notifications, and eventually, the oom-killer will
    trigger.)
 
 12. TODO
+========
 
 1. Make per-cgroup scanner reclaim not-shared pages first
 2. Teach controller to account for shared-pages
@@ -862,11 +971,13 @@ Test:
    not yet hit but the usage is getting closer
 
 Summary
+=======
 
 Overall, the memory controller has been a stable controller and has been
 commented and discussed quite extensively in the community.
 
 References
+==========
 
 1. Singh, Balbir. RFC: Memory Controller, http://lwn.net/Articles/206697/
 2. Singh, Balbir. Memory Controller (RSS Control),
diff --git a/Documentation/cgroup-v1/net_cls.txt b/Documentation/cgroup-v1/net_cls.rst
similarity index 50%
rename from Documentation/cgroup-v1/net_cls.txt
rename to Documentation/cgroup-v1/net_cls.rst
index ec182346dea2..a2cf272af7a0 100644
--- a/Documentation/cgroup-v1/net_cls.txt
+++ b/Documentation/cgroup-v1/net_cls.rst
@@ -1,5 +1,6 @@
+=========================
 Network classifier cgroup
--------------------------
+=========================
 
 The Network classifier cgroup provides an interface to
 tag network packets with a class identifier (classid).
@@ -17,23 +18,27 @@ values is 0xAAAABBBB; AAAA is the major handle number and BBBB
 is the minor handle number.
 Reading net_cls.classid yields a decimal result.
 
-Example:
-mkdir /sys/fs/cgroup/net_cls
-mount -t cgroup -onet_cls net_cls /sys/fs/cgroup/net_cls
-mkdir /sys/fs/cgroup/net_cls/0
-echo 0x100001 >  /sys/fs/cgroup/net_cls/0/net_cls.classid
-	- setting a 10:1 handle.
+Example::
 
-cat /sys/fs/cgroup/net_cls/0/net_cls.classid
-1048577
+	mkdir /sys/fs/cgroup/net_cls
+	mount -t cgroup -onet_cls net_cls /sys/fs/cgroup/net_cls
+	mkdir /sys/fs/cgroup/net_cls/0
+	echo 0x100001 >  /sys/fs/cgroup/net_cls/0/net_cls.classid
 
-configuring tc:
-tc qdisc add dev eth0 root handle 10: htb
+- setting a 10:1 handle::
 
-tc class add dev eth0 parent 10: classid 10:1 htb rate 40mbit
- - creating traffic class 10:1
+	cat /sys/fs/cgroup/net_cls/0/net_cls.classid
+	1048577
 
-tc filter add dev eth0 parent 10: protocol ip prio 10 handle 1: cgroup
+- configuring tc::
 
-configuring iptables, basic example:
-iptables -A OUTPUT -m cgroup ! --cgroup 0x100001 -j DROP
+	tc qdisc add dev eth0 root handle 10: htb
+	tc class add dev eth0 parent 10: classid 10:1 htb rate 40mbit
+
+- creating traffic class 10:1::
+
+	tc filter add dev eth0 parent 10: protocol ip prio 10 handle 1: cgroup
+
+configuring iptables, basic example::
+
+	iptables -A OUTPUT -m cgroup ! --cgroup 0x100001 -j DROP
diff --git a/Documentation/cgroup-v1/net_prio.txt b/Documentation/cgroup-v1/net_prio.rst
similarity index 71%
rename from Documentation/cgroup-v1/net_prio.txt
rename to Documentation/cgroup-v1/net_prio.rst
index a82cbd28ea8a..b40905871c64 100644
--- a/Documentation/cgroup-v1/net_prio.txt
+++ b/Documentation/cgroup-v1/net_prio.rst
@@ -1,5 +1,6 @@
+=======================
 Network priority cgroup
--------------------------
+=======================
 
 The Network priority cgroup provides an interface to allow an administrator to
 dynamically set the priority of network traffic generated by various
@@ -14,9 +15,9 @@ SO_PRIORITY socket option.  This however, is not always possible because:
 
 This cgroup allows an administrator to assign a process to a group which defines
 the priority of egress traffic on a given interface. Network priority groups can
-be created by first mounting the cgroup filesystem.
+be created by first mounting the cgroup filesystem::
 
-# mount -t cgroup -onet_prio none /sys/fs/cgroup/net_prio
+	# mount -t cgroup -onet_prio none /sys/fs/cgroup/net_prio
 
 With the above step, the initial group acting as the parent accounting group
 becomes visible at '/sys/fs/cgroup/net_prio'.  This group includes all tasks in
@@ -25,17 +26,18 @@ the system. '/sys/fs/cgroup/net_prio/tasks' lists the tasks in this cgroup.
 Each net_prio cgroup contains two files that are subsystem specific
 
 net_prio.prioidx
-This file is read-only, and is simply informative.  It contains a unique integer
-value that the kernel uses as an internal representation of this cgroup.
+  This file is read-only, and is simply informative.  It contains a unique
+  integer value that the kernel uses as an internal representation of this
+  cgroup.
 
 net_prio.ifpriomap
-This file contains a map of the priorities assigned to traffic originating from
-processes in this group and egressing the system on various interfaces. It
-contains a list of tuples in the form <ifname priority>.  Contents of this file
-can be modified by echoing a string into the file using the same tuple format.
-for example:
+  This file contains a map of the priorities assigned to traffic originating
+  from processes in this group and egressing the system on various interfaces.
+  It contains a list of tuples in the form <ifname priority>.  Contents of this
+  file can be modified by echoing a string into the file using the same tuple
+  format. For example::
 
-echo "eth0 5" > /sys/fs/cgroups/net_prio/iscsi/net_prio.ifpriomap
+	echo "eth0 5" > /sys/fs/cgroups/net_prio/iscsi/net_prio.ifpriomap
 
 This command would force any traffic originating from processes belonging to the
 iscsi net_prio cgroup and egressing on interface eth0 to have the priority of
diff --git a/Documentation/cgroup-v1/pids.txt b/Documentation/cgroup-v1/pids.rst
similarity index 62%
rename from Documentation/cgroup-v1/pids.txt
rename to Documentation/cgroup-v1/pids.rst
index e105d708ccde..6acebd9e72c8 100644
--- a/Documentation/cgroup-v1/pids.txt
+++ b/Documentation/cgroup-v1/pids.rst
@@ -1,5 +1,6 @@
-						   Process Number Controller
-						   =========================
+=========================
+Process Number Controller
+=========================
 
 Abstract
 --------
@@ -34,55 +35,58 @@ pids.current tracks all child cgroup hierarchies, so parent/pids.current is a
 superset of parent/child/pids.current.
 
 The pids.events file contains event counters:
+
   - max: Number of times fork failed because limit was hit.
 
 Example
 -------
 
-First, we mount the pids controller:
-# mkdir -p /sys/fs/cgroup/pids
-# mount -t cgroup -o pids none /sys/fs/cgroup/pids
+First, we mount the pids controller::
 
-Then we create a hierarchy, set limits and attach processes to it:
-# mkdir -p /sys/fs/cgroup/pids/parent/child
-# echo 2 > /sys/fs/cgroup/pids/parent/pids.max
-# echo $$ > /sys/fs/cgroup/pids/parent/cgroup.procs
-# cat /sys/fs/cgroup/pids/parent/pids.current
-2
-#
+	# mkdir -p /sys/fs/cgroup/pids
+	# mount -t cgroup -o pids none /sys/fs/cgroup/pids
+
+Then we create a hierarchy, set limits and attach processes to it::
+
+	# mkdir -p /sys/fs/cgroup/pids/parent/child
+	# echo 2 > /sys/fs/cgroup/pids/parent/pids.max
+	# echo $$ > /sys/fs/cgroup/pids/parent/cgroup.procs
+	# cat /sys/fs/cgroup/pids/parent/pids.current
+	2
+	#
 
 It should be noted that attempts to overcome the set limit (2 in this case) will
-fail:
+fail::
 
-# cat /sys/fs/cgroup/pids/parent/pids.current
-2
-# ( /bin/echo "Here's some processes for you." | cat )
-sh: fork: Resource temporary unavailable
-#
+	# cat /sys/fs/cgroup/pids/parent/pids.current
+	2
+	# ( /bin/echo "Here's some processes for you." | cat )
+	sh: fork: Resource temporary unavailable
+	#
 
 Even if we migrate to a child cgroup (which doesn't have a set limit), we will
 not be able to overcome the most stringent limit in the hierarchy (in this case,
-parent's):
+parent's)::
 
-# echo $$ > /sys/fs/cgroup/pids/parent/child/cgroup.procs
-# cat /sys/fs/cgroup/pids/parent/pids.current
-2
-# cat /sys/fs/cgroup/pids/parent/child/pids.current
-2
-# cat /sys/fs/cgroup/pids/parent/child/pids.max
-max
-# ( /bin/echo "Here's some processes for you." | cat )
-sh: fork: Resource temporary unavailable
-#
+	# echo $$ > /sys/fs/cgroup/pids/parent/child/cgroup.procs
+	# cat /sys/fs/cgroup/pids/parent/pids.current
+	2
+	# cat /sys/fs/cgroup/pids/parent/child/pids.current
+	2
+	# cat /sys/fs/cgroup/pids/parent/child/pids.max
+	max
+	# ( /bin/echo "Here's some processes for you." | cat )
+	sh: fork: Resource temporary unavailable
+	#
 
 We can set a limit that is smaller than pids.current, which will stop any new
 processes from being forked at all (note that the shell itself counts towards
-pids.current):
+pids.current)::
 
-# echo 1 > /sys/fs/cgroup/pids/parent/pids.max
-# /bin/echo "We can't even spawn a single process now."
-sh: fork: Resource temporary unavailable
-# echo 0 > /sys/fs/cgroup/pids/parent/pids.max
-# /bin/echo "We can't even spawn a single process now."
-sh: fork: Resource temporary unavailable
-#
+	# echo 1 > /sys/fs/cgroup/pids/parent/pids.max
+	# /bin/echo "We can't even spawn a single process now."
+	sh: fork: Resource temporary unavailable
+	# echo 0 > /sys/fs/cgroup/pids/parent/pids.max
+	# /bin/echo "We can't even spawn a single process now."
+	sh: fork: Resource temporary unavailable
+	#
diff --git a/Documentation/cgroup-v1/rdma.txt b/Documentation/cgroup-v1/rdma.rst
similarity index 79%
rename from Documentation/cgroup-v1/rdma.txt
rename to Documentation/cgroup-v1/rdma.rst
index 9bdb7fd03f83..2fcb0a9bf790 100644
--- a/Documentation/cgroup-v1/rdma.txt
+++ b/Documentation/cgroup-v1/rdma.rst
@@ -1,16 +1,17 @@
-				RDMA Controller
-				----------------
+===============
+RDMA Controller
+===============
 
-Contents
---------
+.. Contents
 
-1. Overview
-  1-1. What is RDMA controller?
-  1-2. Why RDMA controller needed?
-  1-3. How is RDMA controller implemented?
-2. Usage Examples
+   1. Overview
+     1-1. What is RDMA controller?
+     1-2. Why RDMA controller needed?
+     1-3. How is RDMA controller implemented?
+   2. Usage Examples
 
 1. Overview
+===========
 
 1-1. What is RDMA controller?
 -----------------------------
@@ -83,27 +84,34 @@ what is configured by user for a given cgroup and what is supported by
 IB device.
 
 Following resources can be accounted by rdma controller.
+
+  ==========    =============================
   hca_handle	Maximum number of HCA Handles
   hca_object 	Maximum number of HCA Objects
+  ==========    =============================
 
 2. Usage Examples
------------------
-
-(a) Configure resource limit:
-echo mlx4_0 hca_handle=2 hca_object=2000 > /sys/fs/cgroup/rdma/1/rdma.max
-echo ocrdma1 hca_handle=3 > /sys/fs/cgroup/rdma/2/rdma.max
-
-(b) Query resource limit:
-cat /sys/fs/cgroup/rdma/2/rdma.max
-#Output:
-mlx4_0 hca_handle=2 hca_object=2000
-ocrdma1 hca_handle=3 hca_object=max
-
-(c) Query current usage:
-cat /sys/fs/cgroup/rdma/2/rdma.current
-#Output:
-mlx4_0 hca_handle=1 hca_object=20
-ocrdma1 hca_handle=1 hca_object=23
-
-(d) Delete resource limit:
-echo echo mlx4_0 hca_handle=max hca_object=max > /sys/fs/cgroup/rdma/1/rdma.max
+=================
+
+(a) Configure resource limit::
+
+	echo mlx4_0 hca_handle=2 hca_object=2000 > /sys/fs/cgroup/rdma/1/rdma.max
+	echo ocrdma1 hca_handle=3 > /sys/fs/cgroup/rdma/2/rdma.max
+
+(b) Query resource limit::
+
+	cat /sys/fs/cgroup/rdma/2/rdma.max
+	#Output:
+	mlx4_0 hca_handle=2 hca_object=2000
+	ocrdma1 hca_handle=3 hca_object=max
+
+(c) Query current usage::
+
+	cat /sys/fs/cgroup/rdma/2/rdma.current
+	#Output:
+	mlx4_0 hca_handle=1 hca_object=20
+	ocrdma1 hca_handle=1 hca_object=23
+
+(d) Delete resource limit::
+
+	echo echo mlx4_0 hca_handle=max hca_object=max > /sys/fs/cgroup/rdma/1/rdma.max
diff --git a/Documentation/filesystems/tmpfs.txt b/Documentation/filesystems/tmpfs.txt
index d06e9a59a9f4..cad797a8a39e 100644
--- a/Documentation/filesystems/tmpfs.txt
+++ b/Documentation/filesystems/tmpfs.txt
@@ -98,7 +98,7 @@ A memory policy with a valid NodeList will be saved, as specified, for
 use at file creation time.  When a task allocates a file in the file
 system, the mount option memory policy will be applied with a NodeList,
 if any, modified by the calling task's cpuset constraints
-[See Documentation/cgroup-v1/cpusets.txt] and any optional flags, listed
+[See Documentation/cgroup-v1/cpusets.rst] and any optional flags, listed
 below.  If the resulting NodeLists is the empty set, the effective memory
 policy for the file will revert to "default" policy.
 
diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
index b14e03ff3528..a7514343b660 100644
--- a/Documentation/scheduler/sched-deadline.txt
+++ b/Documentation/scheduler/sched-deadline.txt
@@ -652,7 +652,7 @@ CONTENTS
 
  -deadline tasks cannot have an affinity mask smaller that the entire
  root_domain they are created on. However, affinities can be specified
- through the cpuset facility (Documentation/cgroup-v1/cpusets.txt).
+ through the cpuset facility (Documentation/cgroup-v1/cpusets.rst).
 
 5.1 SCHED_DEADLINE and cpusets HOWTO
 ------------------------------------
diff --git a/Documentation/scheduler/sched-design-CFS.txt b/Documentation/scheduler/sched-design-CFS.txt
index edd861c94c1b..d1328890ef28 100644
--- a/Documentation/scheduler/sched-design-CFS.txt
+++ b/Documentation/scheduler/sched-design-CFS.txt
@@ -215,7 +215,7 @@ SCHED_BATCH) tasks.
 
    These options need CONFIG_CGROUPS to be defined, and let the administrator
    create arbitrary groups of tasks, using the "cgroup" pseudo filesystem.  See
-   Documentation/cgroup-v1/cgroups.txt for more information about this filesystem.
+   Documentation/cgroup-v1/cgroups.rst for more information about this filesystem.
 
 When CONFIG_FAIR_GROUP_SCHED is defined, a "cpu.shares" file is created for each
 group created using the pseudo filesystem.  See example steps below to create
diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
index d8fce3e78457..c09f7a3fee66 100644
--- a/Documentation/scheduler/sched-rt-group.txt
+++ b/Documentation/scheduler/sched-rt-group.txt
@@ -133,7 +133,7 @@ This uses the cgroup virtual file system and "<cgroup>/cpu.rt_runtime_us"
 to control the CPU time reserved for each control group.
 
 For more information on working with control groups, you should read
-Documentation/cgroup-v1/cgroups.txt as well.
+Documentation/cgroup-v1/cgroups.rst as well.
 
 Group settings are checked against the following limits in order to keep the
 configuration schedulable:
diff --git a/Documentation/vm/numa.rst b/Documentation/vm/numa.rst
index 5cae13e9a08b..0d830edae8fe 100644
--- a/Documentation/vm/numa.rst
+++ b/Documentation/vm/numa.rst
@@ -67,7 +67,7 @@ nodes.  Each emulated node will manage a fraction of the underlying cells'
 physical memory.  NUMA emluation is useful for testing NUMA kernel and
 application features on non-NUMA platforms, and as a sort of memory resource
 management mechanism when used together with cpusets.
-[see Documentation/cgroup-v1/cpusets.txt]
+[see Documentation/cgroup-v1/cpusets.rst]
 
 For each node with memory, Linux constructs an independent memory management
 subsystem, complete with its own free page lists, in-use page lists, usage
@@ -114,7 +114,7 @@ allocation behavior using Linux NUMA memory policy. [see
 
 System administrators can restrict the CPUs and nodes' memories that a non-
 privileged user can specify in the scheduling or NUMA commands and functions
-using control groups and CPUsets.  [see Documentation/cgroup-v1/cpusets.txt]
+using control groups and CPUsets.  [see Documentation/cgroup-v1/cpusets.rst]
 
 On architectures that do not hide memoryless nodes, Linux will include only
 zones [nodes] with memory in the zonelists.  This means that for a memoryless
diff --git a/Documentation/vm/page_migration.rst b/Documentation/vm/page_migration.rst
index f68d61335abb..35bba27d5fff 100644
--- a/Documentation/vm/page_migration.rst
+++ b/Documentation/vm/page_migration.rst
@@ -41,7 +41,7 @@ locations.
 Larger installations usually partition the system using cpusets into
 sections of nodes. Paul Jackson has equipped cpusets with the ability to
 move pages when a task is moved to another cpuset (See
-Documentation/cgroup-v1/cpusets.txt).
+Documentation/cgroup-v1/cpusets.rst).
 Cpusets allows the automation of process locality. If a task is moved to
 a new cpuset then also all its pages are moved with it so that the
 performance of the process does not sink dramatically. Also the pages
diff --git a/Documentation/vm/unevictable-lru.rst b/Documentation/vm/unevictable-lru.rst
index b8e29f977f2d..c6d94118fbcc 100644
--- a/Documentation/vm/unevictable-lru.rst
+++ b/Documentation/vm/unevictable-lru.rst
@@ -98,7 +98,7 @@ Memory Control Group Interaction
 --------------------------------
 
 The unevictable LRU facility interacts with the memory control group [aka
-memory controller; see Documentation/cgroup-v1/memory.txt] by extending the
+memory controller; see Documentation/cgroup-v1/memory.rst] by extending the
 lru_list enum.
 
 The memory controller data structure automatically gets a per-zone unevictable
diff --git a/Documentation/x86/x86_64/fake-numa-for-cpusets.rst b/Documentation/x86/x86_64/fake-numa-for-cpusets.rst
index 04df57b9aa3f..30108684ae87 100644
--- a/Documentation/x86/x86_64/fake-numa-for-cpusets.rst
+++ b/Documentation/x86/x86_64/fake-numa-for-cpusets.rst
@@ -15,7 +15,7 @@ assign them to cpusets and their attached tasks.  This is a way of limiting the
 amount of system memory that are available to a certain class of tasks.
 
 For more information on the features of cpusets, see
-Documentation/cgroup-v1/cpusets.txt.
+Documentation/cgroup-v1/cpusets.rst.
 There are a number of different configurations you can use for your needs.  For
 more information on the numa=fake command line option and its various ways of
 configuring fake nodes, see Documentation/x86/x86_64/boot-options.rst.
@@ -40,7 +40,7 @@ A machine may be split as follows with "numa=fake=4*512," as reported by dmesg::
 	On node 3 totalpages: 131072
 
 Now following the instructions for mounting the cpusets filesystem from
-Documentation/cgroup-v1/cpusets.txt, you can assign fake nodes (i.e. contiguous memory
+Documentation/cgroup-v1/cpusets.rst, you can assign fake nodes (i.e. contiguous memory
 address spaces) to individual cpusets::
 
 	[root@xroads /]# mkdir exampleset
diff --git a/MAINTAINERS b/MAINTAINERS
index 1f73ef8c25f5..aa9a382d6da5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4116,7 +4116,7 @@ W:	http://www.bullopensource.org/cpuset/
 W:	http://oss.sgi.com/projects/cpusets/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 S:	Maintained
-F:	Documentation/cgroup-v1/cpusets.txt
+F:	Documentation/cgroup-v1/cpusets.rst
 F:	include/linux/cpuset.h
 F:	kernel/cgroup/cpuset.c
 
diff --git a/block/Kconfig b/block/Kconfig
index 1b220101a9cb..78374cb03114 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -88,7 +88,7 @@ config BLK_DEV_THROTTLING
 	one needs to mount and use blkio cgroup controller for creating
 	cgroups and specifying per device IO rate policies.
 
-	See Documentation/cgroup-v1/blkio-controller.txt for more information.
+	See Documentation/cgroup-v1/blkio-controller.rst for more information.
 
 config BLK_DEV_THROTTLING_LOW
 	bool "Block throttling .low limit interface support (EXPERIMENTAL)"
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index b4e766e93f6e..c5311935239d 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -624,7 +624,7 @@ struct cftype {
 
 /*
  * Control Group subsystem type.
- * See Documentation/cgroup-v1/cgroups.txt for details
+ * See Documentation/cgroup-v1/cgroups.rst for details
  */
 struct cgroup_subsys {
 	struct cgroup_subsys_state *(*css_alloc)(struct cgroup_subsys_state *parent_css);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f678ee1a556f..95859d5e7e7d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -803,7 +803,7 @@ union bpf_attr {
  * 		based on a user-provided identifier for all traffic coming from
  * 		the tasks belonging to the related cgroup. See also the related
  * 		kernel documentation, available from the Linux sources in file
- * 		*Documentation/cgroup-v1/net_cls.txt*.
+ * 		*Documentation/cgroup-v1/net_cls.rst*.
  *
  * 		The Linux kernel has two versions for cgroups: there are
  * 		cgroups v1 and cgroups v2. Both are available to users, who can
diff --git a/init/Kconfig b/init/Kconfig
index 2f7f52c5efb8..ab41ffa08d79 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -797,7 +797,7 @@ config BLK_CGROUP
 	CONFIG_CFQ_GROUP_IOSCHED=y; for enabling throttling policy, set
 	CONFIG_BLK_DEV_THROTTLING=y.
 
-	See Documentation/cgroup-v1/blkio-controller.txt for more information.
+	See Documentation/cgroup-v1/blkio-controller.rst for more information.
 
 config DEBUG_BLK_CGROUP
 	bool "IO controller debugging"
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index fe90fa1899e6..92c515885f93 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -729,7 +729,7 @@ static inline int nr_cpusets(void)
  * load balancing domains (sched domains) as specified by that partial
  * partition.
  *
- * See "What is sched_load_balance" in Documentation/cgroup-v1/cpusets.txt
+ * See "What is sched_load_balance" in Documentation/cgroup-v1/cpusets.rst
  * for a background explanation of this.
  *
  * Does not return errors, on the theory that the callers of this
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index dc28914fa72e..c07196502577 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -509,7 +509,7 @@ static inline int may_allow_all(struct dev_cgroup *parent)
  * This is one of the three key functions for hierarchy implementation.
  * This function is responsible for re-evaluating all the cgroup's active
  * exceptions due to a parent's exception change.
- * Refer to Documentation/cgroup-v1/devices.txt for more details.
+ * Refer to Documentation/cgroup-v1/devices.rst for more details.
  */
 static void revalidate_active_exceptions(struct dev_cgroup *devcg)
 {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f678ee1a556f..95859d5e7e7d 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -803,7 +803,7 @@ union bpf_attr {
  * 		based on a user-provided identifier for all traffic coming from
  * 		the tasks belonging to the related cgroup. See also the related
  * 		kernel documentation, available from the Linux sources in file
- * 		*Documentation/cgroup-v1/net_cls.txt*.
+ * 		*Documentation/cgroup-v1/net_cls.rst*.
  *
  * 		The Linux kernel has two versions for cgroups: there are
  * 		cgroups v1 and cgroups v2. Both are available to users, who can
-- 
2.21.0

