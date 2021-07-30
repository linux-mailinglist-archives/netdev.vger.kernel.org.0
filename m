Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A2C3DC157
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 00:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbhG3W4V convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 30 Jul 2021 18:56:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29208 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233881AbhG3W4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 18:56:20 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16UMsJDl015363
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 15:56:14 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a4gxmujx6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 15:56:14 -0700
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 30 Jul 2021 15:56:12 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6A82B3D405AD; Fri, 30 Jul 2021 15:56:06 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <davem@davemloft.net>
CC:     <kuba@kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <andrii@kernel.org>, <kernel-team@fb.com>
Subject: pull-request: bpf-next 2021-07-30
Date:   Fri, 30 Jul 2021 15:56:06 -0700
Message-ID: <20210730225606.1897330-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: brNx6p6CbS272ZxSINIOlYssWoIRF6fx
X-Proofpoint-GUID: brNx6p6CbS272ZxSINIOlYssWoIRF6fx
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-30_11:2021-07-30,2021-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107300155
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 64 non-merge commits during the last 15 day(s) which contain
a total of 83 files changed, 5027 insertions(+), 1808 deletions(-).

The main changes are:

1) BTF-guided binary data dumping libbpf API, from Alan.

2) Internal factoring out of libbpf CO-RE relocation logic, from Alexei.

3) Ambient BPF run context and cgroup storage cleanup, from Andrii.

4) Few small API additions for libbpf 1.0 effort, from Evgeniy and Hengqi.

5) bpf_program__attach_kprobe_opts() fixes in libbpf, from Jiri.

6) bpf_{get,set}sockopt() support in BPF iterators, from Martin.

7) BPF map pinning improvements in libbpf, from Martynas.

8) Improved module BTF support in libbpf and bpftool, from Quentin.

9) Bpftool cleanups and documentation improvements, from Quentin.

10) Libbpf improvements for supporting CO-RE on old kernels, from Shuyi.

11) Increased maximum cgroup storage size, from Stanislav.

12) Small fixes and improvements to BPF tests and samples, from various folks.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alan Maguire, Andrii Nakryiko, Eric Dumazet, Jakub Sitnicki, John 
Fastabend, Kuniyuki Iwashima, Linux Kernel Functional Testing, Martin 
KaFai Lau, Naresh Kamboju, Song Liu, Yonghong Song

----------------------------------------------------------------

The following changes since commit d4861fc6be581561d6964700110a4dede54da6a6:

  netdevsim: Add multi-queue support (2021-07-16 11:17:56 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to ab0720ce227cc54a2b841dc3c926ed83a819e4fb:

  Merge branch 'tools: bpftool: update, synchronise and validate types and options' (2021-07-30 15:40:28 -0700)

----------------------------------------------------------------
Alan Maguire (9):
      libbpf: BTF dumper support for typed data
      selftests/bpf: Add ASSERT_STRNEQ() variant for test_progs
      selftests/bpf: Add dump type data tests to btf dump tests
      libbpf: Clarify/fix unaligned data issues for btf typed dump
      libbpf: Fix compilation errors on ppc64le for btf dump typed data
      libbpf: Btf typed dump does not need to allocate dump data
      libbpf: Avoid use of __int128 in typed dump display
      selftests/bpf: Add __int128-specific tests for typed data dump
      libbpf: Propagate errors when retrieving enum value for typed data display

Alexei Starovoitov (4):
      libbpf: Cleanup the layering between CORE and bpf_program.
      libbpf: Split bpf_core_apply_relo() into bpf_program independent helper.
      libbpf: Move CO-RE types into relo_core.h.
      libbpf: Split CO-RE logic into relo_core.c.

Andrii Nakryiko (9):
      bpf: Add ambient BPF runtime context stored in current
      Merge branch 'Add btf_custom_path in bpf_obj_open_opts'
      Merge branch 'libbpf: BTF dumper support for typed data'
      Merge branch 'libbpf: BTF typed dump cleanups'
      Merge branch 'libbpf: btf typed data dumping fixes (__int128 usage, error propagation)'
      Merge branch 'bpf: Allow bpf tcp iter to do bpf_(get|set)sockopt'
      Merge branch 'libbpf: Move CO-RE logic into separate file.'
      Merge branch 'libbpf: rename btf__get_from_id() and btf__load() APIs, support split BTF'
      Merge branch 'tools: bpftool: update, synchronise and validate types and options'

Arnd Bergmann (1):
      bpf: Fix pointer cast warning

Colin Ian King (1):
      bpf: Remove redundant intiialization of variable stype

Cong Wang (1):
      unix_bpf: Fix a potential deadlock in unix_dgram_bpf_recvmsg()

Evgeniy Litvinenko (2):
      libbpf: Add bpf_map__pin_path function
      selftests/bpf: Document vmtest.sh dependencies

Hengqi Chen (2):
      tools/resolve_btfids: Emit warnings and patch zero id for missing symbols
      libbpf: Add btf__load_vmlinux_btf/btf__load_module_btf

Jason Wang (1):
      libbpf: Fix comment typo

Jiri Olsa (3):
      libbpf: Fix func leak in attach_kprobe
      libbpf: Allow decimal offset for kprobes
      libbpf: Export bpf_program__attach_kprobe_opts function

Johan Almbladh (2):
      bpf/tests: Fix copy-and-paste error in double word test
      bpf/tests: Do not PASS tests without actually testing the result

John Fastabend (1):
      bpf, selftests: Fix test_maps now that sockmap supports UDP

Juhee Kang (2):
      samples: bpf: Fix tracex7 error raised on the missing argument
      samples: bpf: Add the omitted xdp samples to .gitignore

Jussi Maki (1):
      selftests/bpf: Use ping6 only if available in tc_redirect

Martin KaFai Lau (8):
      tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos
      tcp: seq_file: Refactor net and family matching
      bpf: tcp: seq_file: Remove bpf_seq_afinfo from tcp_iter_state
      tcp: seq_file: Add listening_get_first()
      tcp: seq_file: Replace listening_hash with lhash2
      bpf: tcp: Bpf iter batching and lock_sock
      bpf: tcp: Support bpf_(get|set)sockopt in bpf tcp iter
      bpf: selftest: Test batching and bpf_(get|set)sockopt in bpf tcp iter

Martynas Pumputis (4):
      libbpf: Fix removal of inner map in bpf_object__create_map
      selftests/bpf: Check inner map deletion
      selftests/bpf: Mute expected invalid map creation error msg
      libbpf: Fix race when pinning maps in parallel

Quentin Monnet (14):
      libbpf: Return non-null error on failures in libbpf_find_prog_btf_id()
      libbpf: Rename btf__load() as btf__load_into_kernel()
      libbpf: Rename btf__get_from_id() as btf__load_from_kernel_by_id()
      tools: Free BTF objects at various locations
      tools: Replace btf__get_from_id() with btf__load_from_kernel_by_id()
      libbpf: Add split BTF support for btf__load_from_kernel_by_id()
      tools: bpftool: Support dumping split BTF by id
      tools: bpftool: Slightly ease bash completion updates
      selftests/bpf: Check consistency between bpftool source, doc, completion
      tools: bpftool: Complete and synchronise attach or map types
      tools: bpftool: Update and synchronise option list in doc and help msg
      selftests/bpf: Update bpftool's consistency script for checking options
      tools: bpftool: Document and add bash completion for -L, -B options
      tools: bpftool: Complete metrics list in "bpftool prog profile" doc

Roy, UjjaL (1):
      bpf, doc: Add heading and example for extensions in cbpf

Shuyi Cheng (3):
      libbpf: Introduce 'btf_custom_path' to 'bpf_obj_open_opts'
      libbpf: Fix the possible memory leak on error
      selftests/bpf: Switch existing selftests to using open_opts for custom BTF

Stanislav Fomichev (1):
      bpf: Increase supported cgroup storage value size

Vincent Li (1):
      selftests, bpf: test_tc_tunnel.sh nc: Cannot use -p and -l

Yonghong Song (1):
      bpf: Emit better log message if bpf_iter ctx arg btf_id == 0

 Documentation/networking/filter.rst                |   23 +-
 include/linux/bpf-cgroup.h                         |   54 -
 include/linux/bpf.h                                |   62 +-
 include/linux/sched.h                              |    3 +
 include/net/inet_hashtables.h                      |    6 +
 include/net/tcp.h                                  |    1 -
 kernel/bpf/bpf_iter.c                              |   22 +
 kernel/bpf/btf.c                                   |    5 +
 kernel/bpf/helpers.c                               |   16 +-
 kernel/bpf/local_storage.c                         |   16 +-
 kernel/fork.c                                      |    1 +
 kernel/trace/bpf_trace.c                           |    9 +-
 lib/test_bpf.c                                     |   13 +-
 net/bpf/test_run.c                                 |   23 +-
 net/core/filter.c                                  |   34 +
 net/ipv4/tcp_ipv4.c                                |  410 ++++--
 net/unix/unix_bpf.c                                |   16 +-
 samples/bpf/.gitignore                             |    2 +
 samples/bpf/test_override_return.sh                |    1 +
 samples/bpf/tracex7_user.c                         |    5 +
 tools/bpf/bpftool/Documentation/bpftool-btf.rst    |   48 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |    3 +-
 .../bpf/bpftool/Documentation/bpftool-feature.rst  |    2 +-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst    |    9 +-
 tools/bpf/bpftool/Documentation/bpftool-iter.rst   |    2 +
 tools/bpf/bpftool/Documentation/bpftool-link.rst   |    3 +-
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |    3 +-
 tools/bpf/bpftool/Documentation/bpftool-net.rst    |    2 +-
 tools/bpf/bpftool/Documentation/bpftool-perf.rst   |    2 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   36 +-
 .../bpftool/Documentation/bpftool-struct_ops.rst   |    2 +-
 tools/bpf/bpftool/Documentation/bpftool.rst        |   12 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   66 +-
 tools/bpf/bpftool/btf.c                            |   11 +-
 tools/bpf/bpftool/btf_dumper.c                     |    6 +-
 tools/bpf/bpftool/cgroup.c                         |    3 +-
 tools/bpf/bpftool/common.c                         |    6 +
 tools/bpf/bpftool/feature.c                        |    1 +
 tools/bpf/bpftool/gen.c                            |    3 +-
 tools/bpf/bpftool/iter.c                           |    2 +
 tools/bpf/bpftool/link.c                           |    3 +-
 tools/bpf/bpftool/main.c                           |    3 +-
 tools/bpf/bpftool/main.h                           |    3 +-
 tools/bpf/bpftool/map.c                            |   19 +-
 tools/bpf/bpftool/net.c                            |    1 +
 tools/bpf/bpftool/perf.c                           |    5 +-
 tools/bpf/bpftool/prog.c                           |   37 +-
 tools/bpf/bpftool/struct_ops.c                     |    2 +-
 tools/bpf/resolve_btfids/main.c                    |   13 +-
 tools/lib/bpf/Build                                |    2 +-
 tools/lib/bpf/btf.c                                |   47 +-
 tools/lib/bpf/btf.h                                |   31 +-
 tools/lib/bpf/btf_dump.c                           |  871 +++++++++++-
 tools/lib/bpf/libbpf.c                             | 1463 ++------------------
 tools/lib/bpf/libbpf.h                             |   25 +-
 tools/lib/bpf/libbpf.map                           |    8 +
 tools/lib/bpf/libbpf_internal.h                    |   81 +-
 tools/lib/bpf/relo_core.c                          | 1295 +++++++++++++++++
 tools/lib/bpf/relo_core.h                          |  100 ++
 tools/perf/util/bpf-event.c                        |   11 +-
 tools/perf/util/bpf_counter.c                      |   12 +-
 tools/testing/selftests/bpf/README.rst             |    7 +
 tools/testing/selftests/bpf/netcnt_common.h        |   38 +-
 tools/testing/selftests/bpf/network_helpers.c      |   85 +-
 tools/testing/selftests/bpf/network_helpers.h      |    4 +
 .../selftests/bpf/prog_tests/bpf_iter_setsockopt.c |  226 +++
 tools/testing/selftests/bpf/prog_tests/btf.c       |    4 +-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |  615 ++++++++
 .../selftests/bpf/prog_tests/core_autosize.c       |   22 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |   25 +-
 .../selftests/bpf/prog_tests/get_func_ip_test.c    |    2 +
 tools/testing/selftests/bpf/prog_tests/pinning.c   |    9 +
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |   23 +-
 .../selftests/bpf/progs/bpf_iter_setsockopt.c      |   72 +
 .../testing/selftests/bpf/progs/bpf_tracing_net.h  |    6 +
 .../testing/selftests/bpf/progs/get_func_ip_test.c |   11 +
 tools/testing/selftests/bpf/progs/netcnt_prog.c    |    8 +-
 .../selftests/bpf/progs/test_map_in_map_invalid.c  |   26 +
 .../selftests/bpf/test_bpftool_synctypes.py        |  586 ++++++++
 tools/testing/selftests/bpf/test_maps.c            |   72 +-
 tools/testing/selftests/bpf/test_netcnt.c          |    4 +-
 tools/testing/selftests/bpf/test_progs.h           |   12 +
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |    2 +-
 83 files changed, 5027 insertions(+), 1808 deletions(-)
 create mode 100644 tools/lib/bpf/relo_core.c
 create mode 100644 tools/lib/bpf/relo_core.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_setsockopt.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_map_in_map_invalid.c
 create mode 100755 tools/testing/selftests/bpf/test_bpftool_synctypes.py
