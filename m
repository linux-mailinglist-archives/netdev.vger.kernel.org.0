Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F71D399556
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 23:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhFBVYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 17:24:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:47782 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbhFBVYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 17:24:02 -0400
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1loYJc-00031R-53; Wed, 02 Jun 2021 23:22:16 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-06-02
Date:   Wed,  2 Jun 2021 23:22:15 +0200
Message-Id: <20210602212215.5195-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26189/Wed Jun  2 13:10:34 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 2 non-merge commits during the last 7 day(s) which contain
a total of 4 files changed, 19 insertions(+), 24 deletions(-).

The main changes are:

1) Fix pahole BTF generation when ccache is used, from Javier Martinez Canillas.

2) Fix BPF lockdown hooks in bpf_probe_read_kernel{,_str}() helpers which caused
   a deadlock from bcc programs, triggered OOM killer from audit side and didn't
   work generally with SELinux policy rules due to pointing to wrong task struct,
   from Daniel Borkmann.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Arnaldo Carvalho de Melo, Jakub 
Hrozek, Jiri Olsa, Ondrej Mosnacek, Serhei Makarov

----------------------------------------------------------------

The following changes since commit d7c5303fbc8ac874ae3e597a5a0d3707dc0230b4:

  Merge tag 'net-5.13-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-05-26 17:44:49 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to ff40e51043af63715ab413995ff46996ecf9583f:

  bpf, lockdown, audit: Fix buggy SELinux lockdown permission checks (2021-06-02 21:59:22 +0200)

----------------------------------------------------------------
Daniel Borkmann (1):
      bpf, lockdown, audit: Fix buggy SELinux lockdown permission checks

Javier Martinez Canillas (1):
      kbuild: Quote OBJCOPY var to avoid a pahole call break the build

 kernel/bpf/helpers.c      |  7 +++++--
 kernel/trace/bpf_trace.c  | 32 ++++++++++++--------------------
 scripts/Makefile.modfinal |  2 +-
 scripts/link-vmlinux.sh   |  2 +-
 4 files changed, 19 insertions(+), 24 deletions(-)
