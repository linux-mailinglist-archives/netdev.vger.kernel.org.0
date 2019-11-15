Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4EA7FE7AF
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 23:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfKOWS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 17:18:59 -0500
Received: from www62.your-server.de ([213.133.104.62]:49602 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727409AbfKOWS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 17:18:58 -0500
Received: from 45.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.45] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVjvb-0006al-H7; Fri, 15 Nov 2019 23:18:55 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     jakub.kicinski@netronome.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2019-11-15
Date:   Fri, 15 Nov 2019 23:18:55 +0100
Message-Id: <20191115221855.27728-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25634/Fri Nov 15 10:44:37 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 1 non-merge commits during the last 9 day(s) which contain
a total of 1 file changed, 3 insertions(+), 1 deletion(-).

The main changes are:

1) Fix a missing unlock of bpf_devs_lock in bpf_offload_dev_create()'s
   error path, from Dan.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Jakub Kicinski

----------------------------------------------------------------

The following changes since commit 2836654a2735d3bc0479edd3ca7457d909b007ed:

  Documentation: TLS: Add missing counter description (2019-11-05 18:34:06 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to d0fbb51dfaa612f960519b798387be436e8f83c5:

  bpf, offload: Unlock on error in bpf_offload_dev_create() (2019-11-07 00:20:27 +0100)

----------------------------------------------------------------
Dan Carpenter (1):
      bpf, offload: Unlock on error in bpf_offload_dev_create()

 kernel/bpf/offload.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
