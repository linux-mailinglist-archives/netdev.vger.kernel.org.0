Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F07851847C4
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 14:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgCMNP4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 13 Mar 2020 09:15:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10230 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726669AbgCMNP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 09:15:56 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 02DD7jgw022436
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 06:15:55 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2yqt89c0j9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 06:15:55 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 06:15:53 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id BE8D57600DE; Thu, 12 Mar 2020 19:06:50 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: pull-request: bpf 2020-03-12
Date:   Thu, 12 Mar 2020 19:06:49 -0700
Message-ID: <20200313020649.1133477-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_04:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 impostorscore=0 mlxscore=0
 suspectscore=4 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130070
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 12 non-merge commits during the last 8 day(s) which contain
a total of 12 files changed, 161 insertions(+), 15 deletions(-).

The main changes are:

1) Andrii fixed two bugs in cgroup-bpf.

2) John fixed sockmap.

3) Luke fixed x32 jit.

4) Martin fixed two issues in struct_ops.

5) Yonghong fixed bpf_send_signal.

6) Yoshiki fixed BTF enum.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Jakub Sitnicki, Roman Gushchin

----------------------------------------------------------------

The following changes since commit 209c65b61d94344522c41a83cd6ce51aac5fd0a4:

  drivers/of/of_mdio.c:fix of_mdiobus_register() (2020-03-03 19:01:51 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 90db6d772f749e38171d04619a5e3cd8804a6d02:

  bpf, sockmap: Remove bucket->lock from sock_{hash|map}_free (2020-03-11 14:08:52 +0100)

----------------------------------------------------------------
Alexei Starovoitov (2):
      Merge branch 'fix_bpf_send_signal'
      Merge branch 'fix-BTF-enum'

Andrii Nakryiko (2):
      bpf: Initialize storage pointers to NULL to prevent freeing garbage pointer
      bpf: Fix cgroup ref leak in cgroup_bpf_inherit on out-of-memory

John Fastabend (1):
      bpf, sockmap: Remove bucket->lock from sock_{hash|map}_free

Luke Nelson (2):
      bpf, x32: Fix bug with JMP32 JSET BPF_X checking upper bits
      selftests: bpf: Add test for JMP32 JSET BPF_X with upper bits set

Martin KaFai Lau (2):
      bpf: Return better error value in delete_elem for struct_ops map
      bpf: Do not allow map_freeze in struct_ops map

Quentin Monnet (1):
      mailmap: Update email address

Yonghong Song (2):
      bpf: Fix deadlock with rq_lock in bpf_send_signal()
      selftests/bpf: Add send_signal_sched_switch test

Yoshiki Komachi (2):
      bpf/btf: Fix BTF verification of enum members in struct/union
      selftests/bpf: Add test for the packed enum member in struct/union

 .mailmap                                           |  1 +
 arch/x86/net/bpf_jit_comp32.c                      | 10 ++--
 kernel/bpf/bpf_struct_ops.c                        | 14 +++--
 kernel/bpf/btf.c                                   |  2 +-
 kernel/bpf/cgroup.c                                |  7 ++-
 kernel/bpf/syscall.c                               |  5 ++
 kernel/trace/bpf_trace.c                           |  2 +-
 net/core/sock_map.c                                | 12 +++--
 .../bpf/prog_tests/send_signal_sched_switch.c      | 60 ++++++++++++++++++++++
 .../selftests/bpf/progs/test_send_signal_kern.c    |  6 +++
 tools/testing/selftests/bpf/test_btf.c             | 42 +++++++++++++++
 tools/testing/selftests/bpf/verifier/jmp32.c       | 15 ++++++
 12 files changed, 161 insertions(+), 15 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/send_signal_sched_switch.c
