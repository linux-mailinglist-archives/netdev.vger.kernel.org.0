Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7A03E3235
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 01:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhHFXvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 19:51:15 -0400
Received: from www62.your-server.de ([213.133.104.62]:60630 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbhHFXvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 19:51:14 -0400
Received: from 65.47.5.85.dynamic.wline.res.cust.swisscom.ch ([85.5.47.65] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mC9c5-0005bv-JB; Sat, 07 Aug 2021 01:50:53 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf 2021-08-07
Date:   Sat,  7 Aug 2021 01:50:52 +0200
Message-Id: <20210806235052.16379-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26255/Fri Aug  6 10:24:06 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 4 non-merge commits during the last 9 day(s) which contain
a total of 4 files changed, 8 insertions(+), 7 deletions(-).

The main changes are:

1) Fix integer overflow in htab's lookup + delete batch op, from Tatsuhiko Yasumatsu.

2) Fix invalid fd 0 close in libbpf if BTF parsing failed, from Daniel Xu.

3) Fix libbpf feature probe for BPF_PROG_TYPE_CGROUP_SOCKOPT, from Robin Gögge.

4) Fix minor libbpf doc warning regarding code-block language, from Randy Dunlap.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Quentin Monnet, Yonghong Song

----------------------------------------------------------------

The following changes since commit fc16a5322ee6c30ea848818722eee5d352f8d127:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2021-07-29 00:53:32 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to c4eb1f403243fc7bbb7de644db8587c03de36da6:

  bpf: Fix integer overflow involving bucket_size (2021-08-07 01:39:22 +0200)

----------------------------------------------------------------
Daniel Xu (1):
      libbpf: Do not close un-owned FD 0 on errors

Randy Dunlap (1):
      libbpf, doc: Eliminate warnings in libbpf_naming_convention

Robin Gögge (1):
      libbpf: Fix probe for BPF_PROG_TYPE_CGROUP_SOCKOPT

Tatsuhiko Yasumatsu (1):
      bpf: Fix integer overflow involving bucket_size

 Documentation/bpf/libbpf/libbpf_naming_convention.rst | 4 ++--
 kernel/bpf/hashtab.c                                  | 4 ++--
 tools/lib/bpf/btf.c                                   | 3 +--
 tools/lib/bpf/libbpf_probes.c                         | 4 +++-
 4 files changed, 8 insertions(+), 7 deletions(-)
