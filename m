Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2632562659E
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 00:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbiKKXhq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Nov 2022 18:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiKKXho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 18:37:44 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C85E026
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 15:37:43 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABJOFod029111
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 15:37:42 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ks3nwm3a9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 15:37:42 -0800
Received: from twshared15216.17.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 15:37:39 -0800
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id 3B1C9218F2885; Fri, 11 Nov 2022 15:37:33 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <davem@davemloft.net>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <daniel@iogearbox.net>, <ast@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <andrii@kernel.org>
Subject: pull-request: bpf-next 2022-11-11
Date:   Fri, 11 Nov 2022 15:37:33 -0800
Message-ID: <20221111233733.1088228-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset="UTF-8"
X-FB-Internal: Safe
X-Proofpoint-GUID: J4Ed5Mq5IKDHg5tmT-P7w4INpHRAi56_
X-Proofpoint-ORIG-GUID: J4Ed5Mq5IKDHg5tmT-P7w4INpHRAi56_
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_11,2022-11-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 49 non-merge commits during the last 9 day(s) which contain
a total of 68 files changed, 3592 insertions(+), 1371 deletions(-).

The main changes are:

1) Veristat tool improvements to support custom filtering, sorting, and replay
   of results, from Andrii Nakryiko.

2) BPF verifier precision tracking fixes and improvements, from Andrii Nakryiko.

3) Lots of new BPF documentation for various BPF maps, from Dave Tucker,
   Donald Hunter, Maryam Tahhan, Bagas Sanjaya.

4) BTF dedup improvements and libbpf's hashmap interface clean ups, from
   Eduard Zingerman.

5) Fix veth driver panic if XDP program is attached before veth_open, from
   John Fastabend.

6) BPF verifier clean ups and fixes in preparation for follow up features,
   from Kumar Kartikeya Dwivedi.

7) Add access to hwtstamp field from BPF sockops programs, from Martin KaFai Lau.

8) Various fixes for BPF selftests and samples, from Artem Savkov,
   Domenico Cerasuolo, Kang Minchul, Rong Tao, Yang Jihong.

9) Fix redirection to tunneling device logic, preventing skb->len == 0, from
   Stanislav Fomichev.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alan Maguire, Andrii Nakryiko, Bagas Sanjaya, Björn Töpel, Dave 
Marchevsky, David Vernet, Jakub Kicinski, kernel test robot, KP Singh, 
Maryam Tahhan, Randy Dunlap, Stanislav Fomichev, Wang Yufen, Yonghong 
Song

----------------------------------------------------------------

The following changes since commit fbeb229a6622523c092a13c02bd0e15f69240dde:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-11-03 13:21:54 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

for you to fetch changes up to eb6af4ceda2d885416d8382f096030d39896aafc:

  selftests/bpf: fix veristat's singular file-or-prog filter (2022-11-11 14:06:20 -0800)

----------------------------------------------------------------
bpf-next-for-netdev

----------------------------------------------------------------
Alexei Starovoitov (2):
      Merge branch 'veristat: replay, filtering, sorting'
      Merge branch 'BPF verifier precision tracking improvements'

Andrii Nakryiko (19):
      selftests/bpf: add veristat replay mode
      selftests/bpf: shorten "Total insns/states" column names in veristat
      selftests/bpf: consolidate and improve file/prog filtering in veristat
      selftests/bpf: ensure we always have non-ambiguous sorting in veristat
      selftests/bpf: allow to define asc/desc ordering for sort specs in veristat
      selftests/bpf: support simple filtering of stats in veristat
      selftests/bpf: make veristat emit all stats in CSV mode by default
      selftests/bpf: handle missing records in comparison mode better in veristat
      selftests/bpf: support stats ordering in comparison mode in veristat
      selftests/bpf: support stat filtering in comparison mode in veristat
      bpf: propagate precision in ALU/ALU64 operations
      bpf: propagate precision across all frames, not just the last one
      bpf: allow precision tracking for programs with subprogs
      bpf: stop setting precise in current state
      bpf: aggressively forget precise markings during state checkpointing
      selftests/bpf: make test_align selftest more robust
      Merge branch 'libbpf: Resolve unambigous forward declarations'
      Merge branch 'bpf: Add hwtstamp field for the sockops prog'
      selftests/bpf: fix veristat's singular file-or-prog filter

Artem Savkov (1):
      selftests/bpf: Use consistent build-id type for liburandom_read.so

Bagas Sanjaya (1):
      Documentation: bpf: Escape underscore in BPF type name prefix

Dave Tucker (1):
      bpf, docs: Document BPF_MAP_TYPE_ARRAY

Domenico Cerasuolo (1):
      selftests: Fix test group SKIPPED result

Donald Hunter (3):
      docs/bpf: Document BPF_MAP_TYPE_LPM_TRIE map
      docs/bpf: Document BPF ARRAY_OF_MAPS and HASH_OF_MAPS
      docs/bpf: Document BPF map types QUEUE and STACK

Eduard Zingerman (6):
      libbpf: Resolve enum fwd as full enum64 and vice versa
      selftests/bpf: Tests for enum fwd resolved as full enum64
      libbpf: Hashmap interface update to allow both long and void* keys/values
      libbpf: Resolve unambigous forward declarations
      selftests/bpf: Tests for btf_dedup_resolve_fwds
      libbpf: Hashmap.h update to fix build issues using LLVM14

John Fastabend (1):
      bpf: veth driver panics when xdp prog attached before veth_open

Kang Minchul (1):
      selftests/bpf: Fix u32 variable compared with less than zero

Kumar Kartikeya Dwivedi (8):
      bpf: Document UAPI details for special BPF types
      bpf: Allow specifying volatile type modifier for kptrs
      bpf: Clobber stack slot when writing over spilled PTR_TO_BTF_ID
      bpf: Fix slot type check in check_stack_write_var_off
      bpf: Drop reg_type_may_be_refcounted_or_null
      bpf: Refactor kptr_off_tab into btf_record
      bpf: Consolidate spin_lock, timer management into btf_record
      bpf: Refactor map->off_arr handling

Martin KaFai Lau (4):
      Merge branch 'fix panic bringing up veth with xdp progs'
      bpf: Add hwtstamp field for the sockops prog
      selftests/bpf: Fix incorrect ASSERT in the tcp_hdr_options test
      selftests/bpf: Test skops->skb_hwtstamp

Maryam Tahhan (1):
      docs/bpf: Document BPF_MAP_TYPE_CPUMAP map

Rong Tao (3):
      samples/bpf: Fix tracex2 error: No such file or directory
      selftests/bpf: cgroup_helpers.c: Fix strncpy() fortify warning
      samples/bpf: Fix sockex3 error: Missing BPF prog type

Stanislav Fomichev (1):
      bpf: make sure skb->len != 0 when redirecting to a tunneling device

Yang Jihong (1):
      selftests/bpf: Fix xdp_synproxy compilation failure in 32-bit arch

 Documentation/bpf/bpf_design_QA.rst                |  44 +
 Documentation/bpf/map_array.rst                    | 250 ++++++
 Documentation/bpf/map_cpumap.rst                   | 166 ++++
 Documentation/bpf/map_lpm_trie.rst                 | 181 +++++
 Documentation/bpf/map_of_maps.rst                  | 126 +++
 Documentation/bpf/map_queue_stack.rst              | 122 +++
 drivers/net/veth.c                                 |   2 +-
 include/linux/bpf.h                                | 179 +++--
 include/linux/btf.h                                |  10 +-
 include/uapi/linux/bpf.h                           |   1 +
 kernel/bpf/arraymap.c                              |  30 +-
 kernel/bpf/bpf_local_storage.c                     |   2 +-
 kernel/bpf/btf.c                                   | 420 ++++++----
 kernel/bpf/cpumap.c                                |   9 +-
 kernel/bpf/hashtab.c                               |  38 +-
 kernel/bpf/helpers.c                               |   6 +-
 kernel/bpf/local_storage.c                         |   2 +-
 kernel/bpf/map_in_map.c                            |  19 +-
 kernel/bpf/syscall.c                               | 373 ++++-----
 kernel/bpf/verifier.c                              | 485 +++++++----
 net/core/bpf_sk_storage.c                          |   4 +-
 net/core/filter.c                                  |  43 +-
 samples/bpf/sockex3_kern.c                         |  95 ++-
 samples/bpf/sockex3_user.c                         |  23 +-
 samples/bpf/tracex2_kern.c                         |   4 +-
 samples/bpf/tracex2_user.c                         |   3 +-
 tools/bpf/bpftool/btf.c                            |  25 +-
 tools/bpf/bpftool/common.c                         |  10 +-
 tools/bpf/bpftool/gen.c                            |  19 +-
 tools/bpf/bpftool/link.c                           |  10 +-
 tools/bpf/bpftool/main.h                           |  14 +-
 tools/bpf/bpftool/map.c                            |  10 +-
 tools/bpf/bpftool/pids.c                           |  16 +-
 tools/bpf/bpftool/prog.c                           |  10 +-
 tools/include/uapi/linux/bpf.h                     |   1 +
 tools/lib/bpf/btf.c                                | 259 ++++--
 tools/lib/bpf/btf_dump.c                           |  15 +-
 tools/lib/bpf/hashmap.c                            |  18 +-
 tools/lib/bpf/hashmap.h                            |  91 ++-
 tools/lib/bpf/libbpf.c                             |  18 +-
 tools/lib/bpf/strset.c                             |  18 +-
 tools/lib/bpf/usdt.c                               |  28 +-
 tools/perf/tests/expr.c                            |  28 +-
 tools/perf/tests/pmu-events.c                      |   6 +-
 tools/perf/util/bpf-loader.c                       |  11 +-
 tools/perf/util/evsel.c                            |   2 +-
 tools/perf/util/expr.c                             |  36 +-
 tools/perf/util/hashmap.c                          |  18 +-
 tools/perf/util/hashmap.h                          |  91 ++-
 tools/perf/util/metricgroup.c                      |  10 +-
 tools/perf/util/stat-shadow.c                      |   2 +-
 tools/perf/util/stat.c                             |   9 +-
 tools/testing/selftests/bpf/Makefile               |   7 +-
 tools/testing/selftests/bpf/bpf_util.h             |  19 +
 tools/testing/selftests/bpf/cgroup_helpers.c       |   3 +-
 tools/testing/selftests/bpf/prog_tests/align.c     |  38 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       | 264 +++++-
 .../selftests/bpf/prog_tests/btf_dedup_split.c     |  45 +-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |   4 +-
 tools/testing/selftests/bpf/prog_tests/hashmap.c   | 190 +++--
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |   6 +-
 .../selftests/bpf/prog_tests/tcp_hdr_options.c     |   6 +-
 .../bpf/progs/test_misc_tcp_hdr_options.c          |   4 +
 tools/testing/selftests/bpf/test_progs.c           |  38 +-
 tools/testing/selftests/bpf/veristat.c             | 893 +++++++++++++++++----
 tools/testing/selftests/bpf/xdp_synproxy.c         |   5 +-
 tools/testing/selftests/bpf/xsk.c                  |  26 +-
 tools/testing/selftests/bpf/xskxceiver.c           |   3 +-
 68 files changed, 3592 insertions(+), 1371 deletions(-)
 create mode 100644 Documentation/bpf/map_array.rst
 create mode 100644 Documentation/bpf/map_cpumap.rst
 create mode 100644 Documentation/bpf/map_lpm_trie.rst
 create mode 100644 Documentation/bpf/map_of_maps.rst
 create mode 100644 Documentation/bpf/map_queue_stack.rst
