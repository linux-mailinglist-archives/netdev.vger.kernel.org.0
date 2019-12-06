Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3D7114C53
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 07:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfLFGTC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 Dec 2019 01:19:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31322 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726104AbfLFGTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 01:19:02 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xB66EqN6016367
        for <netdev@vger.kernel.org>; Thu, 5 Dec 2019 22:19:00 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2wpywy4w82-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 22:19:00 -0800
Received: from intmgw005.05.ash5.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 5 Dec 2019 22:18:58 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 6286F760AFF; Thu,  5 Dec 2019 22:18:57 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: pull-request: bpf 2019-12-05
Date:   Thu, 5 Dec 2019 22:18:57 -0800
Message-ID: <20191206061857.3660737-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-06_01:2019-12-04,2019-12-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 suspectscore=1 priorityscore=1501 clxscore=1015 mlxlogscore=999
 phishscore=0 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912060054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 6 non-merge commits during the last 1 day(s) which contain
a total of 14 files changed, 116 insertions(+), 37 deletions(-).

The main changes are:

1) three selftests fixes, from Stanislav.

2) one samples fix, from Jesper.

3) one verifier fix, from Yonghong.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Eelco Chaudron, Toke Høiland-Jørgensen

----------------------------------------------------------------

The following changes since commit 099ffd7eddfe03b9b5b43e1f4ffece99121dd7ba:

  NFC: NCI: use new `delay` structure for SPI transfer delays (2019-12-04 17:00:58 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 8f9081c92523328aa569d09051add79a6c0ae9ff:

  selftests/bpf: Add a fexit/bpf2bpf test with target bpf prog no callees (2019-12-04 21:34:42 -0800)

----------------------------------------------------------------
Jesper Dangaard Brouer (1):
      samples/bpf: Fix broken xdp_rxq_info due to map order assumptions

Stanislav Fomichev (3):
      selftests/bpf: Don't hard-code root cgroup id
      selftests/bpf: Bring back c++ include/link test
      selftests/bpf: De-flake test_tcpbpf

Yonghong Song (2):
      bpf: Fix a bug when getting subprog 0 jited image in check_attach_btf_id
      selftests/bpf: Add a fexit/bpf2bpf test with target bpf prog no callees

 kernel/bpf/verifier.c                              |  5 +-
 samples/bpf/xdp_rxq_info_user.c                    |  6 +-
 tools/lib/bpf/.gitignore                           |  1 -
 tools/lib/bpf/Makefile                             |  5 +-
 tools/testing/selftests/bpf/.gitignore             |  1 +
 tools/testing/selftests/bpf/Makefile               |  6 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       | 70 ++++++++++++++++------
 .../selftests/bpf/progs/fexit_bpf2bpf_simple.c     | 26 ++++++++
 .../selftests/bpf/progs/test_pkt_md_access.c       |  4 +-
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |  1 +
 .../selftests/bpf/test_cpp.cpp}                    |  0
 .../selftests/bpf/test_skb_cgroup_id_user.c        |  2 +-
 tools/testing/selftests/bpf/test_tcpbpf.h          |  1 +
 tools/testing/selftests/bpf/test_tcpbpf_user.c     | 25 +++++---
 14 files changed, 116 insertions(+), 37 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/fexit_bpf2bpf_simple.c
 rename tools/{lib/bpf/test_libbpf.c => testing/selftests/bpf/test_cpp.cpp} (100%)
