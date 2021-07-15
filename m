Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207373CAE58
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 23:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhGOVJM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 15 Jul 2021 17:09:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31106 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229606AbhGOVJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 17:09:03 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FL0KTh001732
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 14:06:09 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39srasm8dt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 14:06:09 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Jul 2021 14:06:08 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8B7AC3D405AC; Thu, 15 Jul 2021 14:06:03 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <davem@davemloft.net>
CC:     <kuba@kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <andrii@kernel.org>
Subject: pull-request: bpf 2021-07-15
Date:   Thu, 15 Jul 2021 14:06:03 -0700
Message-ID: <20210715210603.276717-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Rpj-1zVeGjS__1yvWOxIE9t3A1AG9II0
X-Proofpoint-ORIG-GUID: Rpj-1zVeGjS__1yvWOxIE9t3A1AG9II0
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-15_15:2021-07-14,2021-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 clxscore=1015
 mlxscore=0 suspectscore=0 malwarescore=0 impostorscore=0 mlxlogscore=911
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107150138
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 9 non-merge commits during the last 5 day(s) which contain
a total of 9 files changed, 37 insertions(+), 15 deletions(-).

The main changes are:

1) Fix NULL pointer dereference in BPF_TEST_RUN for BPF_XDP_DEVMAP and
   BPF_XDP_CPUMAP programs, from Xuan Zhuo.

2) Fix use-after-free of net_device in XDP bpf_link, from Xuan Zhuo.

3) Follow-up fix to subprog poke descriptor use-after-free problem, from
   Daniel Borkmann and John Fastabend.

4) Fix out-of-range array access in s390 BPF JIT backend, from Colin Ian King.

5) Fix memory leak in BPF sockmap, from John Fastabend.

6) Fix for sockmap to prevent proc stats reporting bug, from John Fastabend
   and Jakub Sitnicki.

7) Fix NULL pointer dereference in bpftool, from Tobias Klauser.

8) AF_XDP documentation fixes, from Baruch Siach.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Abaci, Andrii Nakryiko, Cong Wang, David Ahern, Dust Li, Ilya 
Leoshkevich, Jesper Dangaard Brouer, John Fastabend, Maciej Fijalkowski, 
Magnus Karlsson, Quentin Monnet, Roman Gushchin, Song Liu

----------------------------------------------------------------

The following changes since commit a5de4be0aaaa66a2fa98e8a33bdbed3bd0682804:

  net: phy: marvell10g: fix differentiation of 88X3310 from 88X3340 (2021-07-11 10:02:33 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to d444b06e40855219ef38b5e9286db16d435f06dc:

  bpftool: Check malloc return value in mount_bpffs_for_pin (2021-07-15 20:01:36 +0200)

----------------------------------------------------------------
Baruch Siach (1):
      doc, af_xdp: Fix bind flags option typo

Colin Ian King (1):
      s390/bpf: Perform r1 range checking before accessing jit->seen_reg[r1]

Daniel Borkmann (1):
      bpf: Fix tail_call_reachable rejection for interpreter when jit failed

Jakub Sitnicki (1):
      bpf, sockmap, udp: sk_prot needs inuse_idx set for proc stats

John Fastabend (2):
      bpf, sockmap: Fix potential memory leak on unlikely error case
      bpf, sockmap, tcp: sk_prot needs inuse_idx set for proc stats

Tobias Klauser (1):
      bpftool: Check malloc return value in mount_bpffs_for_pin

Xuan Zhuo (2):
      bpf, test: fix NULL pointer dereference on invalid expected_attach_type
      xdp, net: Fix use-after-free in bpf_xdp_link_release

 Documentation/networking/af_xdp.rst |  6 +++---
 arch/s390/net/bpf_jit_comp.c        |  2 +-
 kernel/bpf/verifier.c               |  2 ++
 net/bpf/test_run.c                  |  3 +++
 net/core/dev.c                      | 14 ++++++++++----
 net/core/skmsg.c                    | 16 +++++++++++-----
 net/ipv4/tcp_bpf.c                  |  2 +-
 net/ipv4/udp_bpf.c                  |  2 +-
 tools/bpf/bpftool/common.c          |  5 +++++
 9 files changed, 37 insertions(+), 15 deletions(-)
