Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C1A3E5E22
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241119AbhHJOk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:40:58 -0400
Received: from www62.your-server.de ([213.133.104.62]:54738 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241056AbhHJOk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 10:40:57 -0400
Received: from 65.47.5.85.dynamic.wline.res.cust.swisscom.ch ([85.5.47.65] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mDSvZ-0000o8-Ty; Tue, 10 Aug 2021 16:40:26 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-08-10
Date:   Tue, 10 Aug 2021 16:40:25 +0200
Message-Id: <20210810144025.22814-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26259/Tue Aug 10 10:19:56 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 5 non-merge commits during the last 2 day(s) which contain
a total of 7 files changed, 27 insertions(+), 15 deletions(-).

The main changes are:

1) Fix missing bpf_read_lock_trace() context for BPF loader progs, from Yonghong Song.

2) Fix corner case where BPF prog retrieves wrong local storage, also from Yonghong Song.

3) Restrict availability of BPF write_user helper behind lockdown, from Daniel Borkmann.

4) Fix multiple kernel-doc warnings in BPF core, from Randy Dunlap.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko

----------------------------------------------------------------

The following changes since commit d09c548dbf3b31cb07bba562e0f452edfa01efe3:

  net: sched: act_mirred: Reset ct info when mirror/redirect skb (2021-08-09 10:58:47 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 019d0454c61707879cf9853c894e0a191f6b9774:

  bpf, core: Fix kernel-doc notation (2021-08-10 13:09:28 +0200)

----------------------------------------------------------------
Daniel Borkmann (2):
      bpf: Add _kernel suffix to internal lockdown_bpf_read
      bpf: Add lockdown check for probe_write_user helper

Randy Dunlap (1):
      bpf, core: Fix kernel-doc notation

Yonghong Song (2):
      bpf: Add missing bpf_read_[un]lock_trace() for syscall program
      bpf: Fix potentially incorrect results with bpf_get_local_storage()

 include/linux/bpf-cgroup.h |  4 ++--
 include/linux/security.h   |  3 ++-
 kernel/bpf/core.c          |  7 ++++++-
 kernel/bpf/helpers.c       |  8 ++++----
 kernel/trace/bpf_trace.c   | 13 +++++++------
 net/bpf/test_run.c         |  4 ++++
 security/security.c        |  3 ++-
 7 files changed, 27 insertions(+), 15 deletions(-)
