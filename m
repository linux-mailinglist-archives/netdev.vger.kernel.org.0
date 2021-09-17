Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF55D40FEC5
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 19:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241237AbhIQRqG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Sep 2021 13:46:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65232 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233991AbhIQRqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 13:46:05 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HGxlCV010699
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 10:44:43 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3b4m3svjwq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 10:44:42 -0700
Received: from intmgw002.46.prn1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 17 Sep 2021 10:44:42 -0700
Received: by devbig056.vll2.facebook.com (Postfix, from userid 572438)
        id E1F0F3591C1F; Fri, 17 Sep 2021 10:37:38 -0700 (PDT)
From:   Alexei Starovoitov <ast@kernel.org>
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: pull-request: bpf-next 2021-09-17
Date:   Fri, 17 Sep 2021 10:37:38 -0700
Message-ID: <20210917173738.3397064-1-ast@kernel.org>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset="UTF-8"
X-FB-Internal: Safe
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: F0duJlMY3onSo9A0mjlNx_ELI4yiEnrf
X-Proofpoint-GUID: F0duJlMY3onSo9A0mjlNx_ELI4yiEnrf
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_07,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 adultscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1011 mlxlogscore=999
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109170108
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 63 non-merge commits during the last 12 day(s) which contain
a total of 65 files changed, 2653 insertions(+), 751 deletions(-).

The main changes are:

1) Streamline internal BPF program sections handling and
   bpf_program__set_attach_target() in libbpf, from Andrii.

2) Add support for new btf kind BTF_KIND_TAG, from Yonghong.

3) Introduce bpf_get_branch_snapshot() to capture LBR, from Song.

4) IMUL optimization for x86-64 JIT, from Jie.

5) xsk selftest improvements, from Magnus.

6) Introduce legacy kprobe events support in libbpf, from Rafael.

7) Access hw timestamp through BPF's __sk_buff, from Vadim.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Johan Almbladh, John Fastabend, Maciej Fijalkowski, 
Martin KaFai Lau, Paul Chaignon, Peter Zijlstra (Intel), Tiezhu Yang, 
Yonghong Song

----------------------------------------------------------------

The following changes since commit 27151f177827d478508e756c7657273261aaf8a9:

  Merge tag 'perf-tools-for-v5.15-2021-09-04' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux (2021-09-05 11:56:18 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to ca21a3e5edfd47c90141724557f9d6f5000e46f3:

  selftests/bpf: Fix a few compiler warnings (2021-09-17 09:10:54 -0700)

----------------------------------------------------------------
Alexei Starovoitov (4):
      Merge branch 'bpf: introduce bpf_get_branch_snapshot'
      Merge branch 'libbpf: Streamline internal BPF program sections handling'
      Merge branch 'bpf: add support for new btf kind BTF_KIND_TAG'
      Merge branch 'Improve set_attach_target() and deprecate open_opts.attach_prog_fd'

Andrii Nakryiko (15):
      Merge branch 'Bpf skeleton helper method'
      libbpf: Fix build with latest gcc/binutils with LTO
      libbpf: Make libbpf_version.h non-auto-generated
      selftests/bpf: Update selftests to always provide "struct_ops" SEC
      libbpf: Ensure BPF prog types are set before relocations
      libbpf: Simplify BPF program auto-attach code
      libbpf: Minimize explicit iterator of section definition array
      selftests/bpf: Fix .gitignore to not ignore test_progs.c
      libbpf: Use pre-setup sec_def in libbpf_find_attach_btf_id()
      selftests/bpf: Stop using relaxed_core_relocs which has no effect
      libbpf: Deprecated bpf_object_open_opts.relaxed_core_relocs
      libbpf: Allow skipping attach_func_name in bpf_program__set_attach_target()
      selftests/bpf: Switch fexit_bpf2bpf selftest to set_attach_target() API
      libbpf: Schedule open_opts.attach_prog_fd deprecation since v0.7
      libbpf: Constify all high-level program attach APIs

Daniel Borkmann (2):
      Merge branch 'bpf-xsk-selftests'
      bpf, selftests: Replicate tailcall limit test for indirect call case

Grant Seltzer (1):
      libbpf: Add sphinx code documentation comments

Jie Meng (1):
      bpf,x64 Emit IMUL instead of MUL for x86-64

Magnus Karlsson (20):
      selftests: xsk: Simplify xsk and umem arrays
      selftests: xsk: Introduce type for thread function
      selftests: xsk: Introduce test specifications
      selftests: xsk: Move num_frames and frame_headroom to xsk_umem_info
      selftests: xsk: Move rxqsize into xsk_socket_info
      selftests: xsk: Make frame_size configurable
      selftests: xsx: Introduce test name in test spec
      selftests: xsk: Add use_poll to ifobject
      selftests: xsk: Introduce rx_on and tx_on in ifobject
      selftests: xsk: Replace second_step global variable
      selftests: xsk: Specify number of sockets to create
      selftests: xsk: Make xdp_flags and bind_flags local
      selftests: xsx: Make pthreads local scope
      selftests: xsk: Eliminate MAX_SOCKS define
      selftests: xsk: Allow for invalid packets
      selftests: xsk: Introduce replacing the default packet stream
      selftests: xsk: Add test for unaligned mode
      selftests: xsk: Eliminate test specific if-statement in test runner
      selftests: xsk: Add tests for invalid xsk descriptors
      selftests: xsk: Add tests for 2K frame size

Matt Smith (3):
      libbpf: Change bpf_object_skeleton data field to const pointer
      bpftool: Provide a helper method for accessing skeleton's embedded ELF data
      selftests/bpf: Add checks for X__elf_bytes() skeleton helper

Matteo Croce (1):
      bpf: Update bpf_get_smp_processor_id() documentation

Neil Spring (1):
      bpf: Permit ingress_ifindex in bpf_prog_test_run_xattr

Quentin Monnet (1):
      libbpf: Add LIBBPF_DEPRECATED_SINCE macro for scheduling API deprecations

Rafael David Tinoco (1):
      libbpf: Introduce legacy kprobe events support

Song Liu (3):
      perf: Enable branch record for software events
      bpf: Introduce helper bpf_get_branch_snapshot
      selftests/bpf: Add test for bpf_get_branch_snapshot

Toke Høiland-Jørgensen (1):
      libbpf: Don't crash on object files with no symbol tables

Vadim Fedorenko (2):
      bpf: Add hardware timestamp field to __sk_buff
      selftests/bpf: Test new __sk_buff field hwtstamp

Yonghong Song (13):
      btf: Change BTF_KIND_* macros to enums
      bpf: Support for new btf kind BTF_KIND_TAG
      libbpf: Rename btf_{hash,equal}_int to btf_{hash,equal}_int_tag
      libbpf: Add support for BTF_KIND_TAG
      bpftool: Add support for BTF_KIND_TAG
      selftests/bpf: Test libbpf API function btf__add_tag()
      selftests/bpf: Change NAME_NTH/IS_NAME_NTH for BTF_KIND_TAG format
      selftests/bpf: Add BTF_KIND_TAG unit tests
      selftests/bpf: Test BTF_KIND_TAG for deduplication
      selftests/bpf: Add a test with a bpf program with btf_tag attributes
      docs/bpf: Add documentation for BTF_KIND_TAG
      selftests/bpf: Skip btf_tag test if btf_tag attribute not supported
      selftests/bpf: Fix a few compiler warnings

 Documentation/bpf/btf.rst                          |  29 +-
 arch/x86/events/intel/core.c                       |  67 +-
 arch/x86/events/intel/ds.c                         |   2 +-
 arch/x86/events/intel/lbr.c                        |  20 +-
 arch/x86/events/perf_event.h                       |  19 +
 arch/x86/net/bpf_jit_comp.c                        |  53 +-
 include/linux/perf_event.h                         |  23 +
 include/uapi/linux/bpf.h                           |  26 +-
 include/uapi/linux/btf.h                           |  55 +-
 kernel/bpf/btf.c                                   | 128 +++
 kernel/bpf/trampoline.c                            |   3 +-
 kernel/events/core.c                               |   2 +
 kernel/trace/bpf_trace.c                           |  30 +
 lib/test_bpf.c                                     |   1 +
 net/bpf/test_run.c                                 |  16 +-
 net/core/filter.c                                  |  21 +
 tools/bpf/bpftool/Makefile                         |   3 +
 tools/bpf/bpftool/btf.c                            |  12 +
 tools/bpf/bpftool/gen.c                            |  31 +-
 tools/bpf/resolve_btfids/Makefile                  |   5 +-
 tools/include/uapi/linux/bpf.h                     |  26 +-
 tools/include/uapi/linux/btf.h                     |  55 +-
 tools/lib/bpf/.gitignore                           |   1 -
 tools/lib/bpf/Makefile                             |  39 +-
 tools/lib/bpf/btf.c                                |  84 +-
 tools/lib/bpf/btf.h                                |  87 ++
 tools/lib/bpf/btf_dump.c                           |   3 +
 tools/lib/bpf/libbpf.c                             | 431 ++++++----
 tools/lib/bpf/libbpf.h                             |  41 +-
 tools/lib/bpf/libbpf.map                           |   5 +
 tools/lib/bpf/libbpf_common.h                      |  24 +
 tools/lib/bpf/libbpf_internal.h                    |  27 +-
 tools/lib/bpf/libbpf_version.h                     |   9 +
 tools/lib/bpf/xsk.c                                |   4 +-
 tools/testing/selftests/bpf/.gitignore             |   5 +-
 tools/testing/selftests/bpf/Makefile               |   4 +-
 tools/testing/selftests/bpf/README.rst             |  14 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |  19 +-
 tools/testing/selftests/bpf/btf_helpers.c          |   7 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |   6 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       | 441 ++++++++++-
 tools/testing/selftests/bpf/prog_tests/btf_tag.c   |  20 +
 tools/testing/selftests/bpf/prog_tests/btf_write.c |  21 +
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |  17 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |  43 +-
 .../selftests/bpf/prog_tests/get_branch_snapshot.c | 100 +++
 .../selftests/bpf/prog_tests/module_attach.c       |  39 -
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |   6 +
 tools/testing/selftests/bpf/prog_tests/skeleton.c  |   6 +
 tools/testing/selftests/bpf/prog_tests/tailcalls.c |  25 +-
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |   2 +-
 tools/testing/selftests/bpf/progs/bpf_cubic.c      |  12 +-
 .../selftests/bpf/progs/get_branch_snapshot.c      |  40 +
 tools/testing/selftests/bpf/progs/tag.c            |  49 ++
 tools/testing/selftests/bpf/progs/tailcall6.c      |  34 +
 tools/testing/selftests/bpf/progs/test_skb_ctx.c   |   6 +
 tools/testing/selftests/bpf/test_btf.h             |   3 +
 tools/testing/selftests/bpf/test_progs.c           |  39 +
 tools/testing/selftests/bpf/test_progs.h           |   2 +
 tools/testing/selftests/bpf/trace_helpers.c        |  37 +
 tools/testing/selftests/bpf/trace_helpers.h        |   5 +
 tools/testing/selftests/bpf/verifier/ctx_skb.c     |  60 ++
 tools/testing/selftests/bpf/verifier/jit.c         |  22 +-
 tools/testing/selftests/bpf/xdpxceiver.c           | 872 ++++++++++++++-------
 tools/testing/selftests/bpf/xdpxceiver.h           |  66 +-
 65 files changed, 2653 insertions(+), 751 deletions(-)
 create mode 100644 tools/lib/bpf/libbpf_version.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_tag.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_branch_snapshot.c
 create mode 100644 tools/testing/selftests/bpf/progs/tag.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall6.c
