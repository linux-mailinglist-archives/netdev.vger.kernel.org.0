Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912111297B2
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 15:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfLWOs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 09:48:27 -0500
Received: from www62.your-server.de ([213.133.104.62]:42862 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbfLWOs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 09:48:27 -0500
Received: from [185.105.41.126] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ijP0R-0006jC-FF; Mon, 23 Dec 2019 15:48:23 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     jakub.kicinski@netronome.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2019-12-23
Date:   Mon, 23 Dec 2019 15:48:23 +0100
Message-Id: <20191223144823.3456-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25672/Mon Dec 23 10:53:10 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 2 non-merge commits during the last 1 day(s) which contain
a total of 4 files changed, 34 insertions(+), 31 deletions(-).

The main changes are:

1) Fix libbpf build when building on a read-only filesystem with O=dir
   option, from Namhyung Kim.

2) Fix a precision tracking bug for unknown scalars, from Daniel Borkmann.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot & Merry Xmas!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Anatoly Trosinenko, Andrii Nakryiko

----------------------------------------------------------------

The following changes since commit c60174717544aa8959683d7e19d568309c3a0c65:

  Merge tag 'xfs-5.5-fixes-2' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux (2019-12-22 10:59:06 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to fa633a0f89192379828103957874682d389eae83:

  libbpf: Fix build on read-only filesystems (2019-12-23 15:34:06 +0100)

----------------------------------------------------------------
Daniel Borkmann (1):
      bpf: Fix precision tracking for unbounded scalars

Namhyung Kim (1):
      libbpf: Fix build on read-only filesystems

 kernel/bpf/verifier.c                  | 43 +++++++++++++++++-----------------
 tools/lib/bpf/Makefile                 | 15 ++++++------
 tools/testing/selftests/bpf/.gitignore |  1 +
 tools/testing/selftests/bpf/Makefile   |  6 ++---
 4 files changed, 34 insertions(+), 31 deletions(-)
