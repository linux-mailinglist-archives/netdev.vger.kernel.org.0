Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DD4287666
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 16:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbgJHOwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 10:52:08 -0400
Received: from www62.your-server.de ([213.133.104.62]:33768 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729833AbgJHOwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 10:52:07 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQXGt-00074Z-9E; Thu, 08 Oct 2020 16:51:55 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2020-10-08
Date:   Thu,  8 Oct 2020 16:51:54 +0200
Message-Id: <20201008145154.18801-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25951/Thu Oct  8 15:53:03 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 2 non-merge commits during the last 8 day(s) which contain
a total of 2 files changed, 10 insertions(+), 4 deletions(-).

The main changes are:

1) Fix "unresolved symbol" build error under CONFIG_NET w/o CONFIG_INET due
   to missing tcp_timewait_sock and inet_timewait_sock BTF, from Yonghong Song.

2) Fix 32 bit sub-register bounds tracking for OR case, from Daniel Borkmann.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, John Fastabend, Martin KaFai Lau, Michal Kubecek, 
Simon Scannell

----------------------------------------------------------------

The following changes since commit a59cf619787e628b31c310367f869fde26c8ede1:

  Merge branch 'Fix-bugs-in-Octeontx2-netdev-driver' (2020-09-30 15:07:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 5b9fbeb75b6a98955f628e205ac26689bcb1383e:

  bpf: Fix scalar32_min_max_or bounds tracking (2020-10-08 11:02:53 +0200)

----------------------------------------------------------------
Daniel Borkmann (1):
      bpf: Fix scalar32_min_max_or bounds tracking

Yonghong Song (1):
      bpf: Fix "unresolved symbol" build error with resolve_btfids

 kernel/bpf/verifier.c | 8 ++++----
 net/core/filter.c     | 6 ++++++
 2 files changed, 10 insertions(+), 4 deletions(-)
