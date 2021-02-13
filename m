Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8225831A88D
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhBMADp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:03:45 -0500
Received: from www62.your-server.de ([213.133.104.62]:51490 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbhBMADi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:03:38 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lAiOj-0005lt-Rv; Sat, 13 Feb 2021 01:02:54 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-02-13
Date:   Sat, 13 Feb 2021 01:02:53 +0100
Message-Id: <20210213000253.28706-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26078/Fri Feb 12 13:15:26 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 2 non-merge commits during the last 3 day(s) which contain
a total of 2 files changed, 9 insertions(+), 11 deletions(-).

The main changes are:

1) Fix mod32 truncation handling in verifier, from Daniel Borkmann.

2) Fix XDP redirect tests to explicitly use bash, from Björn Töpel.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, John Fastabend

----------------------------------------------------------------

The following changes since commit 291009f656e8eaebbdfd3a8d99f6b190a9ce9deb:

  Merge tag 'pm-5.11-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2021-02-10 12:03:35 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 9b00f1b78809309163dda2d044d9e94a3c0248a3:

  bpf: Fix truncation handling for mod32 dst reg wrt zero (2021-02-13 00:53:12 +0100)

----------------------------------------------------------------
Björn Töpel (1):
      selftests/bpf: Convert test_xdp_redirect.sh to bash

Daniel Borkmann (1):
      bpf: Fix truncation handling for mod32 dst reg wrt zero

 kernel/bpf/verifier.c                            | 10 ++++++----
 tools/testing/selftests/bpf/test_xdp_redirect.sh | 10 +++-------
 2 files changed, 9 insertions(+), 11 deletions(-)
