Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E568352390
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbhDAXb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbhDAXbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 19:31:25 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E82AC0613E6;
        Thu,  1 Apr 2021 16:31:25 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so3835002pjq.5;
        Thu, 01 Apr 2021 16:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=roz3PEn7+bLIROLzB/ftzTMP1AzxenA92fYWMpRX3ac=;
        b=DdpahmoM7rcJpP9iTPFmWv8+EqqsCuDyMAs4XzCJh9NQH7hHss9h9wpaK9LSNWmIef
         ppPsmTAvezbxZ6jwiXUfiLyERR1w8urQf8gsEVSTIaef6FnXFRf66QYWbZctGtonfXdU
         WgLzrsGXS7bsXuVvyABB+yumrwiVP2DwvUuwxOzmRvJzN86zlHq9bLPInfMZWNcKu5ua
         Gr5/SiRupsxizRko1LK//5g0TmuUXgpq+Gc+64eXFZ0sffPpVLWO4NeZS86xxVFfkODC
         3mbBDsh97mM6uvFqCowql6q+nr7OpIcz+EM3sHADAgAvr+fjSjPBJU2kNm1OTAwlFA1k
         k6/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=roz3PEn7+bLIROLzB/ftzTMP1AzxenA92fYWMpRX3ac=;
        b=fY86a7w72bGSRAziSmXJ32lkVdx863azRCYMlZJCinKrKNugnhKpsODG/prklxpVw9
         uk6dpbqTUtUaakyGk13IfpUCqmS3P46yFNAXS2kYFyURLeCvyJSC0WTHrEVMjW5gFM96
         UsR1NnzzvxTGWe8z4lA2LTdCuCuXA3j9NUFBm+ZaYYXemimYE/AKqx2J7CEFqaQ8W2cC
         9EmyVHHaaF7z/dxQ9edNvA4qJBFiRYZ8fhVWOCeRlGZg8I+la2Bd3NL7gaqAF4RzrRxj
         TG++0Pm5qLNcswr8pH/GSNB4h6sJvKaeUhFAVC1A9nhxZBCDhzsfv3YnF72FNU3x+ouJ
         w5BQ==
X-Gm-Message-State: AOAM532NKAh8Ci8dqcGl3FdUAC+lMER9mLyJa6iIj5s06bXfWLSReqKC
        3+bgYzSrlfhfom4EBdPuyLY3vw8Ggls=
X-Google-Smtp-Source: ABdhPJxNNKuETwnvuj5FwSad3IUt9MpHWIm4h48J6hshKad4cbp6DzShqWa/YyTJBUn2l4UIk+2qRA==
X-Received: by 2002:a17:902:fe09:b029:e4:951e:2d2e with SMTP id g9-20020a170902fe09b02900e4951e2d2emr10228234plj.22.1617319884143;
        Thu, 01 Apr 2021 16:31:24 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id e3sm6391167pfm.43.2021.04.01.16.31.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Apr 2021 16:31:23 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf-next 2021-04-01
Date:   Thu,  1 Apr 2021 16:31:21 -0700
Message-Id: <20210401233121.65221-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 68 non-merge commits during the last 7 day(s) which contain
a total of 70 files changed, 2944 insertions(+), 1139 deletions(-).

The main changes are:

1) UDP support for sockmap, from Cong.

2) Verifier merge conflict resolution fix, from Daniel.

3) xsk selftests enhancements, from Maciej.

4) Unstable helpers aka kernel func calling, from Martin.

5) Batches ops for LPM map, from Pedro.

6) Fix race in bpf_get_local_storage, from Yonghong.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Cong Wang, Jakub Sitnicki, John 
Fastabend, Lorenz Bauer, Roman Gushchin, Song Liu, Yonghong Song

----------------------------------------------------------------

The following changes since commit 241949e488f38a192f2359dbb21d80e08173eb60:

  Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2021-03-25 16:30:46 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 89d69c5d0fbcabd8656459bc8b1a476d6f1efee4:

  Merge branch 'sockmap: introduce BPF_SK_SKB_VERDICT and support UDP' (2021-04-01 10:56:15 -0700)

----------------------------------------------------------------
Alexei Starovoitov (5):
      Merge branch 'add support for batched ops in LPM trie'
      Merge branch 'bpf: Support calling kernel function'
      Merge branch 'bpf: Update doc about calling kernel function'
      Merge branch 'AF_XDP selftests improvements & bpf_link'
      Merge branch 'sockmap: introduce BPF_SK_SKB_VERDICT and support UDP'

Andrii Nakryiko (3):
      libbpf: Constify few bpf_program getters
      libbpf: Preserve empty DATASEC BTFs during static linking
      libbpf: Fix memory leak when emitting final btf_ext

Atul Gopinathan (1):
      bpf: tcp: Remove comma which is causing build error

Björn Töpel (3):
      selftests: xsk: Remove thread attribute
      selftests: xsk: Remove mutex and condition variable
      selftests: xsk: Remove unused defines

Colin Ian King (1):
      bpf: Remove redundant assignment of variable id

Cong Wang (16):
      skmsg: Lock ingress_skb when purging
      skmsg: Introduce a spinlock to protect ingress_msg
      net: Introduce skb_send_sock() for sock_map
      skmsg: Avoid lock_sock() in sk_psock_backlog()
      skmsg: Use rcu work for destroying psock
      skmsg: Use GFP_KERNEL in sk_psock_create_ingress_msg()
      sock_map: Simplify sock_map_link() a bit
      sock_map: Kill sock_map_link_no_progs()
      sock_map: Introduce BPF_SK_SKB_VERDICT
      sock: Introduce sk->sk_prot->psock_update_sk_prot()
      udp: Implement ->read_sock() for sockmap
      skmsg: Extract __tcp_bpf_recvmsg() and tcp_bpf_wait_data()
      udp: Implement udp_bpf_recvmsg() for sockmap
      sock_map: Update sock type checks for UDP
      selftests/bpf: Add a test case for udp sockmap
      selftests/bpf: Add a test case for loading BPF_SK_SKB_VERDICT

Daniel Borkmann (1):
      bpf: Undo ptr_to_map_key alu sanitation for now

He Fengqing (1):
      bpf: Remove unused bpf_load_pointer

KP Singh (2):
      selftests/bpf: Better error messages for ima_setup.sh failures
      selftests/bpf: Add an option for a debug shell in vmtest.sh

Lu Wei (1):
      bpf: Remove unused headers

Maciej Fijalkowski (14):
      selftests: xsk: Don't call worker_pkt_dump() for stats test
      selftests: xsk: Remove struct ifaceconfigobj
      selftests: xsk: Remove unused function
      selftests: xsk: Remove inline keyword from source file
      selftests: xsk: Simplify frame traversal in dumping thread
      libbpf: xsk: Use bpf_link
      samples: bpf: Do not unload prog within xdpsock
      selftests: xsk: Remove thread for netns switch
      selftests: xsk: Split worker thread
      selftests: xsk: Remove Tx synchronization resources
      selftests: xsk: Refactor teardown/bidi test cases and testapp_validate
      selftests: xsk: Remove sync_mutex_tx and atomic var
      veth: Implement ethtool's get_channels() callback
      selftests: xsk: Implement bpf_link test

Martin KaFai Lau (18):
      bpf: Simplify freeing logic in linfo and jited_linfo
      bpf: Refactor btf_check_func_arg_match
      bpf: Support bpf program calling kernel function
      bpf: Support kernel function call in x86-32
      tcp: Rename bictcp function prefix to cubictcp
      bpf: tcp: Put some tcp cong functions in allowlist for bpf-tcp-cc
      libbpf: Refactor bpf_object__resolve_ksyms_btf_id
      libbpf: Refactor codes for finding btf id of a kernel symbol
      libbpf: Rename RELO_EXTERN to RELO_EXTERN_VAR
      libbpf: Record extern sym relocation first
      libbpf: Support extern kernel function
      bpf: selftests: Rename bictcp to bpf_cubic
      bpf: selftests: Bpf_cubic and bpf_dctcp calling kernel functions
      bpf: selftests: Add kfunc_call test
      bpf: tcp: Fix an error in the bpf_tcp_ca_kfunc_ids list
      bpf: tcp: Limit calling some tcp cc functions to CONFIG_DYNAMIC_FTRACE
      bpf: Update bpf_design_QA.rst to clarify the kfunc call is not ABI
      bpf: selftests: Update clang requirement in README.rst for testing kfunc call

Pedro Tammela (2):
      bpf: Add support for batched ops in LPM trie maps
      bpf: selftests: Add tests for batched ops in LPM trie maps

Rafael David Tinoco (1):
      libbpf: Add bpf object kern_version attribute setter

Ricardo Ribalda (1):
      bpf: Fix typo 'accesible' into 'accessible'

Stanislav Fomichev (1):
      tools/resolve_btfids: Fix warnings

Wan Jiabing (1):
      bpf: struct sock is declared twice in bpf_sk_storage header

Yonghong Song (1):
      bpf: Fix NULL pointer dereference in bpf_get_local_storage() helper

 Documentation/bpf/bpf_design_QA.rst                |  15 +
 arch/x86/net/bpf_jit_comp.c                        |   5 +
 arch/x86/net/bpf_jit_comp32.c                      | 198 ++++++
 drivers/net/veth.c                                 |  12 +
 include/linux/bpf-cgroup.h                         |  57 +-
 include/linux/bpf.h                                |  58 +-
 include/linux/btf.h                                |   6 +
 include/linux/filter.h                             |  13 +-
 include/linux/skbuff.h                             |   1 +
 include/linux/skmsg.h                              |  77 ++-
 include/net/bpf_sk_storage.h                       |   1 -
 include/net/sock.h                                 |   3 +
 include/net/tcp.h                                  |   3 +-
 include/net/udp.h                                  |   3 +
 include/uapi/linux/bpf.h                           |   5 +
 kernel/bpf/btf.c                                   | 219 ++++---
 kernel/bpf/core.c                                  |  47 +-
 kernel/bpf/disasm.c                                |  13 +-
 kernel/bpf/helpers.c                               |  15 +-
 kernel/bpf/local_storage.c                         |   5 +-
 kernel/bpf/lpm_trie.c                              |   3 +
 kernel/bpf/syscall.c                               |   5 +-
 kernel/bpf/verifier.c                              | 390 ++++++++++--
 net/bpf/test_run.c                                 |  34 +-
 net/core/filter.c                                  |   1 +
 net/core/skbuff.c                                  |  55 +-
 net/core/skmsg.c                                   | 177 +++++-
 net/core/sock_map.c                                | 118 ++--
 net/ipv4/af_inet.c                                 |   1 +
 net/ipv4/bpf_tcp_ca.c                              |  43 ++
 net/ipv4/tcp_bpf.c                                 | 130 +---
 net/ipv4/tcp_cubic.c                               |  24 +-
 net/ipv4/tcp_ipv4.c                                |   3 +
 net/ipv4/udp.c                                     |  32 +
 net/ipv4/udp_bpf.c                                 |  79 ++-
 net/ipv6/af_inet6.c                                |   1 +
 net/ipv6/tcp_ipv6.c                                |   3 +
 net/ipv6/udp.c                                     |   3 +
 net/tls/tls_sw.c                                   |   4 +-
 samples/bpf/sampleip_kern.c                        |   1 -
 samples/bpf/trace_event_kern.c                     |   1 -
 samples/bpf/xdpsock_user.c                         |  55 +-
 tools/bpf/bpftool/common.c                         |   1 +
 tools/bpf/bpftool/prog.c                           |   1 +
 tools/bpf/resolve_btfids/main.c                    |  11 +-
 tools/include/uapi/linux/bpf.h                     |   5 +
 tools/lib/bpf/libbpf.c                             | 403 +++++++++---
 tools/lib/bpf/libbpf.h                             |   5 +-
 tools/lib/bpf/libbpf.map                           |   1 +
 tools/lib/bpf/linker.c                             |  37 +-
 tools/lib/bpf/xsk.c                                | 258 ++++++--
 tools/testing/selftests/bpf/README.rst             |  14 +
 tools/testing/selftests/bpf/bpf_tcp_helpers.h      |  29 +-
 .../bpf/map_tests/lpm_trie_map_batch_ops.c         | 158 +++++
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |  59 ++
 .../selftests/bpf/prog_tests/sockmap_basic.c       |  40 ++
 .../selftests/bpf/prog_tests/sockmap_listen.c      | 136 ++++
 tools/testing/selftests/bpf/prog_tests/test_ima.c  |   6 +-
 tools/testing/selftests/bpf/progs/bpf_cubic.c      |  36 +-
 tools/testing/selftests/bpf/progs/bpf_dctcp.c      |  22 +-
 .../testing/selftests/bpf/progs/kfunc_call_test.c  |  47 ++
 .../selftests/bpf/progs/kfunc_call_test_subprog.c  |  42 ++
 .../selftests/bpf/progs/test_sockmap_listen.c      |  22 +
 .../bpf/progs/test_sockmap_skb_verdict_attach.c    |  18 +
 tools/testing/selftests/bpf/test_xsk.sh            |   3 +-
 tools/testing/selftests/bpf/verifier/calls.c       |  12 +-
 tools/testing/selftests/bpf/verifier/dead_code.c   |  10 +-
 tools/testing/selftests/bpf/vmtest.sh              |  39 +-
 tools/testing/selftests/bpf/xdpxceiver.c           | 700 ++++++++++-----------
 tools/testing/selftests/bpf/xdpxceiver.h           |  49 +-
 70 files changed, 2944 insertions(+), 1139 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/map_tests/lpm_trie_map_batch_ops.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kfunc_call.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_subprog.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_skb_verdict_attach.c
