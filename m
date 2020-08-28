Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E08E256263
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 23:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgH1VPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 17:15:05 -0400
Received: from www62.your-server.de ([213.133.104.62]:48582 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgH1VPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 17:15:04 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kBli1-0000ji-6f; Fri, 28 Aug 2020 23:14:53 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2020-08-28
Date:   Fri, 28 Aug 2020 23:14:52 +0200
Message-Id: <20200828211452.31342-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25913/Fri Aug 28 15:19:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 4 non-merge commits during the last 4 day(s) which contain
a total of 4 files changed, 7 insertions(+), 4 deletions(-).

The main changes are:

1) Fix out of bounds access for BPF_OBJ_GET_INFO_BY_FD retrieval, from Yonghong Song.

2) Fix wrong __user annotation in bpf_stats sysctl handler, from Tobias Klauser.

3) Few fixes for BPF selftest scripting in test_{progs,maps}, from Jesper Dangaard Brouer.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko

----------------------------------------------------------------

The following changes since commit 99408c422d336db32bfab5cbebc10038a70cf7d2:

  Merge tag 'batadv-net-for-davem-20200824' of git://git.open-mesh.org/linux-merge (2020-08-24 18:16:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to fa4505675e093e895b7ec49a76d44f6b5ad9602e:

  selftests/bpf: Fix massive output from test_maps (2020-08-28 13:58:19 +0200)

----------------------------------------------------------------
Jesper Dangaard Brouer (2):
      selftests/bpf: Fix test_progs-flavor run getting number of tests
      selftests/bpf: Fix massive output from test_maps

Tobias Klauser (1):
      bpf, sysctl: Let bpf_stats_handler take a kernel pointer buffer

Yonghong Song (1):
      bpf: Fix a buffer out-of-bound access when filling raw_tp link_info

 kernel/bpf/syscall.c                     | 2 +-
 kernel/sysctl.c                          | 3 +--
 tools/testing/selftests/bpf/test_maps.c  | 2 ++
 tools/testing/selftests/bpf/test_progs.c | 4 +++-
 4 files changed, 7 insertions(+), 4 deletions(-)
