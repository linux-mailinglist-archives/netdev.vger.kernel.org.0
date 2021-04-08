Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F625358768
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 16:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhDHOra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 10:47:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:49972 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbhDHOr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 10:47:29 -0400
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lUVw4-0002Nd-UJ; Thu, 08 Apr 2021 16:47:15 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-04-08
Date:   Thu,  8 Apr 2021 16:46:42 +0200
Message-Id: <20210408144642.29822-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26134/Thu Apr  8 13:08:38 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 4 non-merge commits during the last 2 day(s) which contain
a total of 4 files changed, 31 insertions(+), 10 deletions(-).

The main changes are:

1) Validate and reject invalid JIT branch displacements, from Piotr Krysiuk.

2) Fix incorrect unhash restore as well as fwd_alloc memory accounting in
   sock map, from John Fastabend.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Cong Wang, Daniel Borkmann, Lorenz Bauer

----------------------------------------------------------------

The following changes since commit 2a2403ca3add03f542f6b34bef9f74649969b06d:

  tipc: increment the tmp aead refcnt before attaching it (2021-04-06 16:25:34 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 26f55a59dc65ff77cd1c4b37991e26497fc68049:

  bpf, x86: Validate computation of branch displacements for x86-32 (2021-04-08 16:24:53 +0200)

----------------------------------------------------------------
John Fastabend (2):
      bpf, sockmap: Fix sk->prot unhash op reset
      bpf, sockmap: Fix incorrect fwd_alloc accounting

Piotr Krysiuk (2):
      bpf, x86: Validate computation of branch displacements for x86-64
      bpf, x86: Validate computation of branch displacements for x86-32

 arch/x86/net/bpf_jit_comp.c   | 11 ++++++++++-
 arch/x86/net/bpf_jit_comp32.c | 11 ++++++++++-
 include/linux/skmsg.h         |  7 ++++++-
 net/core/skmsg.c              | 12 +++++-------
 4 files changed, 31 insertions(+), 10 deletions(-)
