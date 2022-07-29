Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F26585730
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 01:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbiG2XKC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 Jul 2022 19:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiG2XKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 19:10:01 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9920D88E38
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 16:09:59 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26TLPajC007253
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 16:09:58 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hmqeurfm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 16:09:58 -0700
Received: from twshared5413.23.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 29 Jul 2022 16:09:57 -0700
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id 496621CFD8B4E; Fri, 29 Jul 2022 16:09:48 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <davem@davemloft.net>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <daniel@iogearbox.net>, <ast@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <andrii@kernel.org>, <kernel-team@fb.com>
Subject: pull-request: bpf-next 2022-07-29
Date:   Fri, 29 Jul 2022 16:09:48 -0700
Message-ID: <20220729230948.1313527-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset="UTF-8"
X-FB-Internal: Safe
X-Proofpoint-GUID: u5ZQN-m8pWKnUrAXR8fKmtKuRpGZDEpy
X-Proofpoint-ORIG-GUID: u5ZQN-m8pWKnUrAXR8fKmtKuRpGZDEpy
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-29_21,2022-07-28_02,2022-06-22_01
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 22 non-merge commits during the last 4 day(s) which contain
a total of 27 files changed, 763 insertions(+), 120 deletions(-).

The main changes are:

1) Fixes to allow setting any source IP with bpf_skb_set_tunnel_key() helper,
   from Paul Chaignon.

2) Fix for bpf_xdp_pointer() helper when doing sanity checking, from Joanne Koong.

3) Fix for XDP frame length calculation, from Lorenzo Bianconi.

4) Libbpf BPF_KSYSCALL docs improvements and fixes to selftests to accommodate
   s390x quirks with socketcall(), from Ilya Leoshkevich.

5) Allow/denylist and CI configs additions to selftests/bpf to improve BPF CI,
   from Daniel Müller.

6) BPF trampoline + ftrace follow up fixes, from Song Liu and Xu Kuohai.

7) Fix allocation warnings in netdevsim, from Jakub Kicinski.

8) bpf_obj_get_opts() libbpf API allowing to provide file flags, from Joe Burton.

9) vsnprintf usage fix in bpf_snprintf_btf(), from Fedor Tokarev.

10) Various small fixes and clean ups, from Daniel Müller, Rongguang Wei,
    Jörn-Thorben Hinz, Yang Li.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Abaci Robot, Alan Maguire, Andrii Nakryiko, Bruno Goncalves, Jiri Olsa, 
Lorenzo Bianconi, Martin KaFai Lau, Mykola Lysenko, Nikolay Aleksandrov, 
Quentin Monnet, Song Liu, Yonghong Song

----------------------------------------------------------------

The following changes since commit 8e4372e617854a16d4ec549ba821aad78fd748a6:

  Merge branch 'add-mtu-change-with-stmmac-interface-running' (2022-07-25 19:39:36 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 14250fa4839b3a48c979e7faaf4cbcce619d02bd:

  bpf: Remove unneeded semicolon (2022-07-29 15:34:11 -0700)

----------------------------------------------------------------
Daniel Müller (5):
      selftests/bpf: Sort configuration
      selftests/bpf: Copy over libbpf configs
      selftests/bpf: Adjust vmtest.sh to use local kernel configuration
      libbpf: Support PPC in arch_specific_syscall_pfx
      selftests/bpf: Bump internal send_signal/send_signal_tracepoint timeout

Fedor Tokarev (1):
      bpf: btf: Fix vsnprintf return value check

Ilya Leoshkevich (2):
      libbpf: Extend BPF_KSYSCALL documentation
      selftests/bpf: Attach to socketcall() in test_probe_user

Jakub Kicinski (1):
      netdevsim: Avoid allocation warnings triggered from user space

Joanne Koong (1):
      bpf: Fix bpf_xdp_pointer return pointer

Joe Burton (1):
      libbpf: Add bpf_obj_get_opts()

Jörn-Thorben Hinz (1):
      bpftool: Don't try to return value from void function in skeleton

Lorenzo Bianconi (1):
      bpf, devmap: Compute proper xdp_frame len redirecting frames

Paul Chaignon (5):
      ip_tunnels: Add new flow flags field to ip_tunnel_key
      vxlan: Use ip_tunnel_key flow flags in route lookups
      geneve: Use ip_tunnel_key flow flags in route lookups
      bpf: Set flow flag to allow any source IP in bpf_tunnel_key
      selftests/bpf: Don't assign outer source IP to host

Rongguang Wei (1):
      bpftool: Replace sizeof(arr)/sizeof(arr[0]) with ARRAY_SIZE macro

Song Liu (1):
      bpf: Fix test_progs -j error with fentry/fexit tests

Xu Kuohai (1):
      bpf: Fix NULL pointer dereference when registering bpf trampoline

Yang Li (1):
      bpf: Remove unneeded semicolon

 drivers/net/geneve.c                               |   1 +
 drivers/net/netdevsim/bpf.c                        |   8 +-
 drivers/net/vxlan/vxlan_core.c                     |  11 +-
 include/net/ip_tunnels.h                           |   1 +
 kernel/bpf/btf.c                                   |   2 +-
 kernel/bpf/devmap.c                                |   4 +-
 kernel/bpf/trampoline.c                            |   9 +-
 net/core/filter.c                                  |   3 +-
 tools/bpf/bpftool/gen.c                            |   2 +-
 tools/bpf/bpftool/prog.c                           |   2 +-
 tools/lib/bpf/bpf.c                                |   9 +
 tools/lib/bpf/bpf.h                                |  11 +
 tools/lib/bpf/bpf_tracing.h                        |  15 +-
 tools/lib/bpf/libbpf.c                             |  11 +-
 tools/lib/bpf/libbpf.map                           |   1 +
 tools/testing/selftests/bpf/DENYLIST               |   6 +
 tools/testing/selftests/bpf/DENYLIST.s390x         |  67 ++++++
 tools/testing/selftests/bpf/config                 |  99 ++++----
 tools/testing/selftests/bpf/config.s390x           | 147 ++++++++++++
 tools/testing/selftests/bpf/config.x86_64          | 251 +++++++++++++++++++++
 .../testing/selftests/bpf/prog_tests/probe_user.c  |  35 ++-
 .../testing/selftests/bpf/prog_tests/send_signal.c |   2 +-
 .../testing/selftests/bpf/prog_tests/test_tunnel.c |  17 +-
 .../testing/selftests/bpf/progs/test_probe_user.c  |  29 ++-
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |  80 ++++++-
 tools/testing/selftests/bpf/test_progs.c           |   7 +-
 tools/testing/selftests/bpf/vmtest.sh              |  53 +++--
 27 files changed, 763 insertions(+), 120 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/DENYLIST
 create mode 100644 tools/testing/selftests/bpf/DENYLIST.s390x
 create mode 100644 tools/testing/selftests/bpf/config.s390x
 create mode 100644 tools/testing/selftests/bpf/config.x86_64
