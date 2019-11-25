Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE581096E3
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 00:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfKYXY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 18:24:26 -0500
Received: from www62.your-server.de ([213.133.104.62]:42048 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfKYXY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 18:24:26 -0500
Received: from 11.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.11] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iZNiL-0000Z2-7M; Tue, 26 Nov 2019 00:24:17 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     jakub.kicinski@netronome.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2019-11-26
Date:   Tue, 26 Nov 2019 00:24:16 +0100
Message-Id: <20191125232416.4287-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25644/Mon Nov 25 10:54:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 2 non-merge commits during the last 1 day(s) which contain
a total of 2 files changed, 14 insertions(+), 3 deletions(-).

The main changes, 2 small fixes are:

1) Fix libbpf out of tree compilation which complained about unknown u32
   type used in libbpf_find_vmlinux_btf_id() which needs to be __u32 instead,
   from Andrii Nakryiko.

2) Follow-up fix for the prior BPF mmap series where kbuild bot complained
   about missing vmalloc_user_node_flags() for no-MMU, also from Andrii Nakryiko.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Johannes Weiner, John Fastabend, kbuild test robot

----------------------------------------------------------------

The following changes since commit c431047c4efe7903fb1c5a23e0f3f8eb1efc89f9:

  enetc: add support Credit Based Shaper(CBS) for hardware offload (2019-11-25 10:53:15 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to b615e5a1e067dcb327482d1af7463268b89b1629:

  libbpf: Fix usage of u32 in userspace code (2019-11-25 13:52:01 -0800)

----------------------------------------------------------------
Andrii Nakryiko (2):
      mm: Implement no-MMU variant of vmalloc_user_node_flags
      libbpf: Fix usage of u32 in userspace code

 mm/nommu.c             | 15 +++++++++++++--
 tools/lib/bpf/libbpf.c |  2 +-
 2 files changed, 14 insertions(+), 3 deletions(-)
