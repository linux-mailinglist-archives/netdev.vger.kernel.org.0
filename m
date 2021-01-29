Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA2230824C
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhA2AQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:16:53 -0500
Received: from www62.your-server.de ([213.133.104.62]:35242 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhA2AQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 19:16:49 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l5HSG-00049F-5w; Fri, 29 Jan 2021 01:16:04 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-01-29
Date:   Fri, 29 Jan 2021 01:15:56 +0100
Message-Id: <20210129001556.6648-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26063/Thu Jan 28 13:28:06 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 5 non-merge commits during the last 6 day(s) which contain
a total of 4 files changed, 27 insertions(+), 3 deletions(-).

The main changes are:

1) Fix two copy_{from,to}_user() warn_on_once splats for BPF cgroup getsockopt
   infra when user space is trying to race against optlen, from Loris Reiff.

2) Fix a missing fput() in BPF inode storage map update helper, from Pan Bian.

3) Fix a build error on unresolved symbols on disabled networking / keys LSM
   hooks, from Mikko Ylinen.

4) Fix preload BPF prog build when the output directory from make points to a
   relative path, from Quentin Monnet.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, David Gow, KP Singh, Stanislav Fomichev

----------------------------------------------------------------

The following changes since commit 35c715c30b95205e64311c3bb3525094cd3d7236:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec (2021-01-21 11:05:10 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 150a27328b681425c8cab239894a48f2aeb870e9:

  bpf, preload: Fix build when $(O) points to a relative path (2021-01-26 23:13:25 +0100)

----------------------------------------------------------------
Loris Reiff (2):
      bpf, cgroup: Fix optlen WARN_ON_ONCE toctou
      bpf, cgroup: Fix problematic bounds check

Mikko Ylinen (1):
      bpf: Drop disabled LSM hooks from the sleepable set

Pan Bian (1):
      bpf, inode_storage: Put file handler if no storage was found

Quentin Monnet (1):
      bpf, preload: Fix build when $(O) points to a relative path

 kernel/bpf/bpf_inode_storage.c |  6 +++++-
 kernel/bpf/bpf_lsm.c           | 12 ++++++++++++
 kernel/bpf/cgroup.c            |  7 ++++++-
 kernel/bpf/preload/Makefile    |  5 ++++-
 4 files changed, 27 insertions(+), 3 deletions(-)
