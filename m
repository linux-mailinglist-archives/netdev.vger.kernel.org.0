Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A46FED5173
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 19:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbfJLRpj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 12 Oct 2019 13:45:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16978 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727884AbfJLRpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 13:45:39 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9CHgIap005998
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 10:45:37 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2vkagn98t2-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 10:45:37 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 12 Oct 2019 10:45:35 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 366EA760E3D; Sat, 12 Oct 2019 10:45:34 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: pull-request: bpf 2019-10-12
Date:   Sat, 12 Oct 2019 10:45:34 -0700
Message-ID: <20191012174534.931615-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-12_09:2019-10-10,2019-10-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 spamscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 suspectscore=1 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910120157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

The main changes are:

1) a bunch of small fixes. Nothing critical.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 02dc96ef6c25f990452c114c59d75c368a1f4c8f:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2019-09-28 17:47:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 106c35dda32f8b63f88cad7433f1b8bb0056958a:

  selftests/bpf: More compatible nc options in test_lwt_ip_encap (2019-10-08 23:59:22 +0200)

----------------------------------------------------------------
Björn Töpel (1):
      samples/bpf: Fix build for task_fd_query_user.c

Brian Vazquez (2):
      selftests/bpf: test_progs: Don't leak server_fd in tcp_rtt
      selftests/bpf: test_progs: Don't leak server_fd in test_sockopt_inherit

Jiri Benc (2):
      selftests/bpf: Set rp_filter in test_flow_dissector
      selftests/bpf: More compatible nc options in test_lwt_ip_encap

KP Singh (1):
      samples/bpf: Add a workaround for asm_inline

Magnus Karlsson (1):
      xsk: Fix crash in poll when device does not support ndo_xsk_wakeup

Shuah Khan (1):
      tools: bpf: Use !building_out_of_srctree to determine srctree

Yonghong Song (1):
      libbpf: handle symbol versioning properly for libbpf.a

 net/xdp/xsk.c                                      | 42 ++++++++++++++--------
 samples/bpf/asm_goto_workaround.h                  | 13 ++++++-
 samples/bpf/task_fd_query_user.c                   |  1 +
 tools/bpf/Makefile                                 |  6 +++-
 tools/lib/bpf/Makefile                             | 33 +++++++++++------
 tools/lib/bpf/libbpf_internal.h                    | 16 +++++++++
 tools/lib/bpf/xsk.c                                |  4 +--
 .../selftests/bpf/prog_tests/sockopt_inherit.c     |  2 +-
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c   |  3 +-
 tools/testing/selftests/bpf/test_flow_dissector.sh |  3 ++
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh   |  6 ++--
 11 files changed, 95 insertions(+), 34 deletions(-)
