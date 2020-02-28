Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5D651742D3
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 00:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgB1XOj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Feb 2020 18:14:39 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32064 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726947AbgB1XOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 18:14:36 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01SN95jK011765
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 15:14:35 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yepvp63ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 15:14:35 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 28 Feb 2020 15:13:59 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 17734760FD8; Fri, 28 Feb 2020 15:13:54 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: pull-request: bpf-next 2020-02-28
Date:   Fri, 28 Feb 2020 15:13:54 -0800
Message-ID: <20200228231354.3226583-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_08:2020-02-28,2020-02-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 phishscore=0 bulkscore=0 suspectscore=4 spamscore=0 mlxlogscore=776
 mlxscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002280166
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 41 non-merge commits during the last 7 day(s) which contain
a total of 49 files changed, 1383 insertions(+), 499 deletions(-).

The main changes are:

1) BPF and Real-Time nicely co-exist.

2) bpftool feature improvements.

3) retrieve bpf_sk_storage via INET_DIAG.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Jason Wang, Martin KaFai Lau, Michael S. Tsirkin, 
Quentin Monnet, Song Liu, Thomas Gleixner

----------------------------------------------------------------

The following changes since commit 732a0dee501f9a693c9a711730838129f4587041:

  Merge branch 'mlxfw-Improve-error-reporting-and-FW-reactivate-support' (2020-02-21 15:41:10 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 812285fa5ab129e3a55682314bf235f701564310:

  Merge branch 'bpf_sk_storage_via_inet_diag' (2020-02-27 18:53:37 -0800)

----------------------------------------------------------------
Alexei Starovoitov (4):
      Merge tag 'sched-for-bpf-2020-02-20' of git://git.kernel.org/.../tip/tip into bpf-next
      bpf: disable preemption for bpf progs attached to uprobe
      Merge branch 'BPF_and_RT'
      Merge branch 'bpf_sk_storage_via_inet_diag'

Andrey Ignatov (1):
      bpftool: Support struct_ops, tracing, ext prog types

Andrii Nakryiko (1):
      selftests/bpf: Print backtrace on SIGSEGV in test_progs

Daniel Borkmann (1):
      Merge branch 'bpf-bpftool-probes'

David Miller (5):
      bpf: Use bpf_prog_run_pin_on_cpu() at simple call sites.
      bpf/tests: Use migrate disable instead of preempt disable
      bpf: Use migrate_disable/enabe() in trampoline code.
      bpf: Use migrate_disable/enable in array macros and cgroup/lirc code.
      bpf/stackmap: Dont trylock mmap_sem with PREEMPT_RT and interrupts disabled

Gustavo A. R. Silva (1):
      bpf: Replace zero-length array with flexible-array member

Jakub Sitnicki (2):
      selftests/bpf: Run reuseport tests only with supported socket types
      selftests/bpf: Run SYN cookies with reuseport BPF test only for TCP

Martin KaFai Lau (4):
      inet_diag: Refactor inet_sk_diag_fill(), dump(), and dump_one()
      inet_diag: Move the INET_DIAG_REQ_BYTECODE nlattr to cb->data
      bpf: INET_DIAG support in bpf_sk_storage
      bpf: inet_diag: Dump bpf_sk_storages in inet_diag_dump()

Michal Rostecki (5):
      bpftool: Move out sections to separate functions
      bpftool: Make probes which emit dmesg warnings optional
      bpftool: Update documentation of "bpftool feature" command
      bpftool: Update bash completion for "bpftool feature" command
      selftests/bpf: Add test for "bpftool feature" command

Scott Branden (1):
      scripts/bpf: Switch to more portable python3 shebang

Thomas Gleixner (18):
      sched: Provide cant_migrate()
      bpf: Tighten the requirements for preallocated hash maps
      bpf: Enforce preallocation for instrumentation programs on RT
      bpf: Update locking comment in hashtab code
      bpf/tracing: Remove redundant preempt_disable() in __bpf_trace_run()
      bpf/trace: Remove EXPORT from trace_call_bpf()
      bpf/trace: Remove redundant preempt_disable from trace_call_bpf()
      perf/bpf: Remove preempt disable around BPF invocation
      bpf: Remove recursion prevention from rcu free callback
      bpf: Dont iterate over possible CPUs with interrupts disabled
      bpf: Provide bpf_prog_run_pin_on_cpu() helper
      bpf: Replace cant_sleep() with cant_migrate()
      bpf: Provide recursion prevention helpers
      bpf: Use recursion prevention helpers in hashtab code
      bpf: Replace open coded recursion prevention in sys_bpf()
      bpf: Factor out hashtab bucket lock operations
      bpf: Prepare hashtab locking for PREEMPT_RT
      bpf, lpm: Make locking RT friendly

Yuya Kusakabe (2):
      virtio_net: Keep vnet header zeroed if XDP is loaded for small buffer
      virtio_net: Add XDP meta data support

 drivers/net/virtio_net.c                           |  56 ++--
 include/linux/bpf-cgroup.h                         |   2 +-
 include/linux/bpf.h                                |  41 ++-
 include/linux/filter.h                             |  37 ++-
 include/linux/inet_diag.h                          |  27 +-
 include/linux/kernel.h                             |   7 +
 include/linux/netlink.h                            |   4 +-
 include/linux/preempt.h                            |  30 ++
 include/net/bpf_sk_storage.h                       |  27 ++
 include/uapi/linux/bpf.h                           |   2 +-
 include/uapi/linux/inet_diag.h                     |   5 +-
 include/uapi/linux/sock_diag.h                     |  26 ++
 kernel/bpf/bpf_struct_ops.c                        |   2 +-
 kernel/bpf/hashtab.c                               | 174 ++++++++----
 kernel/bpf/lpm_trie.c                              |  14 +-
 kernel/bpf/percpu_freelist.c                       |  20 +-
 kernel/bpf/stackmap.c                              |  18 +-
 kernel/bpf/syscall.c                               |  42 +--
 kernel/bpf/trampoline.c                            |   9 +-
 kernel/bpf/verifier.c                              |  40 ++-
 kernel/events/core.c                               |   2 -
 kernel/seccomp.c                                   |   4 +-
 kernel/trace/bpf_trace.c                           |   7 +-
 kernel/trace/trace_uprobe.c                        |  11 +-
 lib/test_bpf.c                                     |   4 +-
 net/bpf/test_run.c                                 |   8 +-
 net/core/bpf_sk_storage.c                          | 283 ++++++++++++++++++-
 net/core/flow_dissector.c                          |   4 +-
 net/core/skmsg.c                                   |   8 +-
 net/dccp/diag.c                                    |   9 +-
 net/ipv4/inet_diag.c                               | 307 +++++++++++++--------
 net/ipv4/raw_diag.c                                |  24 +-
 net/ipv4/tcp_diag.c                                |   8 +-
 net/ipv4/udp_diag.c                                |  41 ++-
 net/kcm/kcmsock.c                                  |   4 +-
 net/sctp/diag.c                                    |   7 +-
 scripts/bpf_helpers_doc.py                         |   2 +-
 .../bpf/bpftool/Documentation/bpftool-feature.rst  |  19 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   3 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   6 +-
 tools/bpf/bpftool/feature.c                        | 283 +++++++++++--------
 tools/bpf/bpftool/main.h                           |   3 +
 tools/bpf/bpftool/prog.c                           |   4 +-
 tools/testing/selftests/.gitignore                 |   5 +-
 tools/testing/selftests/bpf/Makefile               |   5 +-
 .../selftests/bpf/prog_tests/select_reuseport.c    |  30 +-
 tools/testing/selftests/bpf/test_bpftool.py        | 178 ++++++++++++
 tools/testing/selftests/bpf/test_bpftool.sh        |   5 +
 tools/testing/selftests/bpf/test_progs.c           |  25 ++
 49 files changed, 1383 insertions(+), 499 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/test_bpftool.py
 create mode 100755 tools/testing/selftests/bpf/test_bpftool.sh
