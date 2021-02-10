Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16BF315BB4
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbhBJAzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:55:12 -0500
Received: from www62.your-server.de ([213.133.104.62]:34760 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234863AbhBJAwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 19:52:54 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l9djl-000FD4-U8; Wed, 10 Feb 2021 01:52:10 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-02-10
Date:   Wed, 10 Feb 2021 01:52:09 +0100
Message-Id: <20210210005209.29265-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26075/Tue Feb  9 13:22:47 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 5 non-merge commits during the last 8 day(s) which contain
a total of 3 files changed, 22 insertions(+), 21 deletions(-).

The main changes are:

1) Fix missed execution of kprobes BPF progs when kprobe is firing via
   int3, from Alexei Starovoitov.

2) Fix potential integer overflow in map max_entries for stackmap on
   32 bit archs, from Bui Quang Minh.

3) Fix a verifier pruning and a insn rewrite issue related to 32 bit ops,
   from Daniel Borkmann.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Anatoly Trosinenko, John Fastabend, Masami 
Hiramatsu, Nikolay Borisov

----------------------------------------------------------------

The following changes since commit 3aaf0a27ffc29b19a62314edd684b9bc6346f9a8:

  Merge tag 'clang-format-for-linux-v5.11-rc7' of git://github.com/ojeda/linux (2021-02-02 10:46:59 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to e88b2c6e5a4d9ce30d75391e4d950da74bb2bd90:

  bpf: Fix 32 bit src register truncation on div/mod (2021-02-10 01:32:40 +0100)

----------------------------------------------------------------
Alexei Starovoitov (1):
      bpf: Unbreak BPF_PROG_TYPE_KPROBE when kprobe is called via do_int3

Bui Quang Minh (1):
      bpf: Check for integer overflow when using roundup_pow_of_two()

Daniel Borkmann (3):
      bpf: Fix verifier jsgt branch analysis on max bound
      bpf: Fix verifier jmp32 pruning decision logic
      bpf: Fix 32 bit src register truncation on div/mod

 kernel/bpf/stackmap.c    |  2 ++
 kernel/bpf/verifier.c    | 38 ++++++++++++++++++++------------------
 kernel/trace/bpf_trace.c |  3 ---
 3 files changed, 22 insertions(+), 21 deletions(-)
