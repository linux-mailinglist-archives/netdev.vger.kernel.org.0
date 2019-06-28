Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C610259B42
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 14:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfF1Mb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 08:31:57 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39502 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbfF1Mao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 08:30:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DNLoG7neN+K/BNpM3wsMYyCbLDzACqr3cPuaa3CIK9k=; b=kg0xcgoGSgFP7E9v3ecxTzLaP7
        OgKEkvi5hMGNCk16Qpm+36scSS5VvLJlk1loSzgo1iJzblgg6f3zmtenkLk7oeNSCz3bzD+Dwn7Pf
        dbZE4MTuf8Gywcua5Rq5B7zsqj3TN16MAIPlfKDbl97ex2zmzLlwrZj5xQ8qOpq2j+TimgTrvM9+L
        mGHJmS+7FBHsNqXxT8RBSIYqtFYL5JN/PQgEVb3IRRL+rPJU7BYfiy2cq6nI1fHGRPKPzorx4a2sK
        OsAsDV9cj+zWd7CwqfL/Y0DiiZ8gfaawgRAJJsJ051+F3ZOQim4fh4chdHtSs0LEKZKDP1DaGPvln
        IJ0bjJoQ==;
Received: from [186.213.242.156] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hgq1U-00055c-M6; Fri, 28 Jun 2019 12:30:37 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hgq1S-0005T5-L2; Fri, 28 Jun 2019 09:30:34 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, cgroups@vger.kernel.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH 27/39] docs: cgroup-v1: add it to the admin-guide book
Date:   Fri, 28 Jun 2019 09:30:20 -0300
Message-Id: <0e66ad9f8d17578c7bbd7cf9cb2b22bd4e2c9d5f.1561724493.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1561724493.git.mchehab+samsung@kernel.org>
References: <cover.1561724493.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Those files belong to the admin guide, so add them.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 .../{ => admin-guide}/cgroup-v1/blkio-controller.rst          | 0
 Documentation/{ => admin-guide}/cgroup-v1/cgroups.rst         | 4 ++--
 Documentation/{ => admin-guide}/cgroup-v1/cpuacct.rst         | 0
 Documentation/{ => admin-guide}/cgroup-v1/cpusets.rst         | 2 +-
 Documentation/{ => admin-guide}/cgroup-v1/devices.rst         | 0
 .../{ => admin-guide}/cgroup-v1/freezer-subsystem.rst         | 0
 Documentation/{ => admin-guide}/cgroup-v1/hugetlb.rst         | 0
 Documentation/{ => admin-guide}/cgroup-v1/index.rst           | 2 --
 Documentation/{ => admin-guide}/cgroup-v1/memcg_test.rst      | 4 ++--
 Documentation/{ => admin-guide}/cgroup-v1/memory.rst          | 0
 Documentation/{ => admin-guide}/cgroup-v1/net_cls.rst         | 0
 Documentation/{ => admin-guide}/cgroup-v1/net_prio.rst        | 0
 Documentation/{ => admin-guide}/cgroup-v1/pids.rst            | 0
 Documentation/{ => admin-guide}/cgroup-v1/rdma.rst            | 0
 Documentation/admin-guide/cgroup-v2.rst                       | 2 +-
 Documentation/admin-guide/index.rst                           | 1 +
 Documentation/admin-guide/kernel-parameters.txt               | 4 ++--
 Documentation/admin-guide/mm/numa_memory_policy.rst           | 2 +-
 Documentation/block/bfq-iosched.rst                           | 2 +-
 Documentation/filesystems/tmpfs.txt                           | 2 +-
 Documentation/kernel-per-CPU-kthreads.txt                     | 2 +-
 Documentation/scheduler/sched-deadline.rst                    | 2 +-
 Documentation/scheduler/sched-design-CFS.rst                  | 2 +-
 Documentation/scheduler/sched-rt-group.rst                    | 2 +-
 Documentation/vm/numa.rst                                     | 4 ++--
 Documentation/vm/page_migration.rst                           | 2 +-
 Documentation/vm/unevictable-lru.rst                          | 2 +-
 Documentation/x86/x86_64/fake-numa-for-cpusets.rst            | 4 ++--
 MAINTAINERS                                                   | 4 ++--
 block/Kconfig                                                 | 2 +-
 include/linux/cgroup-defs.h                                   | 2 +-
 include/uapi/linux/bpf.h                                      | 2 +-
 init/Kconfig                                                  | 4 ++--
 kernel/cgroup/cpuset.c                                        | 2 +-
 security/device_cgroup.c                                      | 2 +-
 tools/include/uapi/linux/bpf.h                                | 2 +-
 36 files changed, 32 insertions(+), 33 deletions(-)
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
 
diff --git a/Documentation/admin-guide/index.rst b/Documentation/admin-guide/index.rst
index be3b86db8171..d5064f1802c1 100644
--- a/Documentation/admin-guide/index.rst
+++ b/Documentation/admin-guide/index.rst
@@ -59,6 +59,7 @@ configure specific aspects of kernel behavior to your liking.
 
    initrd
    cgroup-v2
+   cgroup-v1/index
    serial-console
    braille-console
    parport
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 49ad034c4675..e833133c8897 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4115,7 +4115,7 @@
 
 	relax_domain_level=
 			[KNL, SMP] Set scheduler's default relax_domain_level.
-			See Documentation/cgroup-v1/cpusets.rst.
+			See Documentation/admin-guide/cgroup-v1/cpusets.rst.
 
 	reserve=	[KNL,BUGS] Force kernel to ignore I/O ports or memory
 			Format: <base1>,<size1>[,<base2>,<size2>,...]
@@ -4625,7 +4625,7 @@
 	swapaccount=[0|1]
 			[KNL] Enable accounting of swap in memory resource
 			controller if no parameter or 1 is given or disable
-			it if 0 is given (See Documentation/cgroup-v1/memory.rst)
+			it if 0 is given (See Documentation/admin-guide/cgroup-v1/memory.rst)
 
 	swiotlb=	[ARM,IA-64,PPC,MIPS,X86]
 			Format: { <int> | force | noforce }
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
diff --git a/Documentation/block/bfq-iosched.rst b/Documentation/block/bfq-iosched.rst
index 2c13b2fc1888..0d237d402860 100644
--- a/Documentation/block/bfq-iosched.rst
+++ b/Documentation/block/bfq-iosched.rst
@@ -547,7 +547,7 @@ As for cgroups-v1 (blkio controller), the exact set of stat files
 created, and kept up-to-date by bfq, depends on whether
 CONFIG_BFQ_CGROUP_DEBUG is set. If it is set, then bfq creates all
 the stat files documented in
-Documentation/cgroup-v1/blkio-controller.rst. If, instead,
+Documentation/admin-guide/cgroup-v1/blkio-controller.rst. If, instead,
 CONFIG_BFQ_CGROUP_DEBUG is not set, then bfq creates only the files::
 
   blkio.bfq.io_service_bytes
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
 
diff --git a/Documentation/kernel-per-CPU-kthreads.txt b/Documentation/kernel-per-CPU-kthreads.txt
index 5623b9916411..4f18456dd3b1 100644
--- a/Documentation/kernel-per-CPU-kthreads.txt
+++ b/Documentation/kernel-per-CPU-kthreads.txt
@@ -12,7 +12,7 @@ References
 
 -	Documentation/IRQ-affinity.txt:  Binding interrupts to sets of CPUs.
 
--	Documentation/cgroup-v1:  Using cgroups to bind tasks to sets of CPUs.
+-	Documentation/admin-guide/cgroup-v1:  Using cgroups to bind tasks to sets of CPUs.
 
 -	man taskset:  Using the taskset command to bind tasks to sets
 	of CPUs.
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
index 109052215bce..17d0861b0f1d 100644
--- a/Documentation/vm/unevictable-lru.rst
+++ b/Documentation/vm/unevictable-lru.rst
@@ -98,7 +98,7 @@ Memory Control Group Interaction
 --------------------------------
 
 The unevictable LRU facility interacts with the memory control group [aka
-memory controller; see Documentation/cgroup-v1/memory.rst] by extending the
+memory controller; see Documentation/admin-guide/cgroup-v1/memory.rst] by extending the
 lru_list enum.
 
 The memory controller data structure automatically gets a per-zone unevictable
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
index 2791b443ab8e..82222aa618c5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4119,7 +4119,7 @@ L:	cgroups@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 S:	Maintained
 F:	Documentation/admin-guide/cgroup-v2.rst
-F:	Documentation/cgroup-v1/
+F:	Documentation/admin-guide/cgroup-v1/
 F:	include/linux/cgroup*
 F:	kernel/cgroup/
 
@@ -4130,7 +4130,7 @@ W:	http://www.bullopensource.org/cpuset/
 W:	http://oss.sgi.com/projects/cpusets/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 S:	Maintained
-F:	Documentation/cgroup-v1/cpusets.rst
+F:	Documentation/admin-guide/cgroup-v1/cpusets.rst
 F:	include/linux/cpuset.h
 F:	kernel/cgroup/cpuset.c
 
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
index 95ec166e2c2e..4b6235ed24ec 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -797,7 +797,7 @@ menuconfig CGROUPS
 	  controls or device isolation.
 	  See
 		- Documentation/scheduler/sched-design-CFS.rst	(CFS)
-		- Documentation/cgroup-v1/ (features for grouping, isolation
+		- Documentation/admin-guide/cgroup-v1/ (features for grouping, isolation
 					  and resource control)
 
 	  Say N if unsure.
@@ -859,7 +859,7 @@ config BLK_CGROUP
 	CONFIG_CFQ_GROUP_IOSCHED=y; for enabling throttling policy, set
 	CONFIG_BLK_DEV_THROTTLING=y.
 
-	See Documentation/cgroup-v1/blkio-controller.rst for more information.
+	See Documentation/admin-guide/cgroup-v1/blkio-controller.rst for more information.
 
 config CGROUP_WRITEBACK
 	bool
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

