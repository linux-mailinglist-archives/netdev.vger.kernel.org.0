Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7616B1218
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 20:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjCHTfp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Mar 2023 14:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjCHTfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 14:35:43 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955C060D62
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 11:35:41 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 328I1BAT025219
        for <netdev@vger.kernel.org>; Wed, 8 Mar 2023 11:35:40 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3p6ffue7nv-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 11:35:40 -0800
Received: from twshared52565.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 8 Mar 2023 11:35:38 -0800
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id 211E4299CAF01; Wed,  8 Mar 2023 11:35:33 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <davem@davemloft.net>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <daniel@iogearbox.net>, <ast@kernel.org>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: pull-request: bpf-next 2023-03-08
Date:   Wed, 8 Mar 2023 11:35:33 -0800
Message-ID: <20230308193533.1671597-1-andrii@kernel.org>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset="UTF-8"
X-FB-Internal: Safe
X-Proofpoint-GUID: 24D4LqoqwNScrCAnZ_0hsYayYVI5y-Uy
X-Proofpoint-ORIG-GUID: 24D4LqoqwNScrCAnZ_0hsYayYVI5y-Uy
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_14,2023-03-08_03,2023-02-09_01
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 23 non-merge commits during the last 2 day(s) which contain
a total of 28 files changed, 414 insertions(+), 104 deletions(-).

The main changes are:

1) Add more precise memory usage reporting for all BPF map types, from
   Yafang Shao.

2) Add ARM32 USDT support to libbpf, from Puranjay Mohan.

3) Fix BTF_ID_LIST size causing problems in !CONFIG_DEBUG_INFO_BTF, from
   Nathan Chancellor.

4) IMA selftests fix, from Roberto Sassu.

5) libbpf fix in APK support code, from Daniel Müller.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, David Vernet, Hou Tao, Matt Bobrowski, Tom Rix

----------------------------------------------------------------

The following changes since commit 36e5e391a25af28dc1f4586f95d577b38ff4ed72:

  Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2023-03-06 20:36:39 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 12fabae03ca6474fd571bf6ddb37d009533305d6:

  selftests/bpf: Fix IMA test (2023-03-08 11:15:39 -0800)

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'bpf: bpf memory usage'

Andrii Nakryiko (1):
      Merge branch 'libbpf: usdt arm arg parsing support'

Daniel Müller (1):
      libbpf: Fix theoretical u32 underflow in find_cd() function

Nathan Chancellor (1):
      bpf: Increase size of BTF_ID_LIST without CONFIG_DEBUG_INFO_BTF again

Puranjay Mohan (2):
      libbpf: Refactor parse_usdt_arg() to re-use code
      libbpf: USDT arm arg parsing support

Roberto Sassu (1):
      selftests/bpf: Fix IMA test

Yafang Shao (18):
      bpf: add new map ops ->map_mem_usage
      bpf: lpm_trie memory usage
      bpf: hashtab memory usage
      bpf: arraymap memory usage
      bpf: stackmap memory usage
      bpf: reuseport_array memory usage
      bpf: ringbuf memory usage
      bpf: bloom_filter memory usage
      bpf: cpumap memory usage
      bpf: devmap memory usage
      bpf: queue_stack_maps memory usage
      bpf: bpf_struct_ops memory usage
      bpf: local_storage memory usage
      bpf, net: bpf_local_storage memory usage
      bpf, net: sock_map memory usage
      bpf, net: xskmap memory usage
      bpf: offload map memory usage
      bpf: enforce all maps having memory usage callback

 include/linux/bpf.h                               |   8 +
 include/linux/bpf_local_storage.h                 |   1 +
 include/linux/btf_ids.h                           |   2 +-
 include/net/xdp_sock.h                            |   1 +
 kernel/bpf/arraymap.c                             |  28 ++++
 kernel/bpf/bloom_filter.c                         |  12 ++
 kernel/bpf/bpf_cgrp_storage.c                     |   1 +
 kernel/bpf/bpf_inode_storage.c                    |   1 +
 kernel/bpf/bpf_local_storage.c                    |  10 ++
 kernel/bpf/bpf_struct_ops.c                       |  16 ++
 kernel/bpf/bpf_task_storage.c                     |   1 +
 kernel/bpf/cpumap.c                               |  10 ++
 kernel/bpf/devmap.c                               |  26 ++-
 kernel/bpf/hashtab.c                              |  43 +++++
 kernel/bpf/local_storage.c                        |   7 +
 kernel/bpf/lpm_trie.c                             |  11 ++
 kernel/bpf/offload.c                              |   6 +
 kernel/bpf/queue_stack_maps.c                     |  10 ++
 kernel/bpf/reuseport_array.c                      |   8 +
 kernel/bpf/ringbuf.c                              |  20 ++-
 kernel/bpf/stackmap.c                             |  14 ++
 kernel/bpf/syscall.c                              |  20 +--
 net/core/bpf_sk_storage.c                         |   1 +
 net/core/sock_map.c                               |  20 +++
 net/xdp/xskmap.c                                  |  13 ++
 tools/lib/bpf/usdt.c                              | 196 +++++++++++++---------
 tools/lib/bpf/zip.c                               |   3 +-
 tools/testing/selftests/bpf/prog_tests/test_ima.c |  29 +++-
 28 files changed, 414 insertions(+), 104 deletions(-)
