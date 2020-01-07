Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F6E13228F
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgAGJet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:34:49 -0500
Received: from www62.your-server.de ([213.133.104.62]:52526 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbgAGJes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 04:34:48 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iolG3-0005pp-LS; Tue, 07 Jan 2020 10:34:39 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     jakub.kicinski@netronome.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2020-01-07
Date:   Tue,  7 Jan 2020 10:34:38 +0100
Message-Id: <20200107093438.10089-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25686/Mon Jan  6 10:55:07 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 2 non-merge commits during the last 1 day(s) which contain
a total of 2 files changed, 16 insertions(+), 4 deletions(-).

The main changes are:

1) Fix a use-after-free in cgroup BPF due to auto-detachment, from Roman Gushchin.

2) Fix skb out-of-bounds access in ld_abs/ind instruction, from Daniel Borkmann.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Anatoly Trosinenko, Josef Bacik, Song Liu

----------------------------------------------------------------

The following changes since commit 4012a6f2fa562b4b2884ea96db263caa4c6057a8:

  firmware: tee_bnxt: Fix multiple call to tee_client_close_context (2020-01-06 13:51:37 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 6d4f151acf9a4f6fab09b615f246c717ddedcf0c:

  bpf: Fix passing modified ctx to ld/abs/ind instruction (2020-01-06 14:19:47 -0800)

----------------------------------------------------------------
Daniel Borkmann (1):
      bpf: Fix passing modified ctx to ld/abs/ind instruction

Roman Gushchin (1):
      bpf: cgroup: prevent out-of-order release of cgroup bpf

 kernel/bpf/cgroup.c   | 11 +++++++++--
 kernel/bpf/verifier.c |  9 +++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)
