Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC0B4824AF
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 17:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhLaQAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 11:00:53 -0500
Received: from www62.your-server.de ([213.133.104.62]:48488 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbhLaQAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 11:00:53 -0500
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1n3KKo-000A5p-UF; Fri, 31 Dec 2021 17:00:51 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2021-12-31
Date:   Fri, 31 Dec 2021 17:00:50 +0100
Message-Id: <20211231160050.16105-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26408/Fri Dec 31 10:22:11 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

First of all, we wish you both a happy new year! :-)

The following pull-request contains BPF updates for your *net* tree.

We've added 2 non-merge commits during the last 14 day(s) which contain
a total of 2 files changed, 3 insertions(+), 3 deletions(-).

The main changes are:

1) Revert of an earlier attempt to fix xsk's poll() behavior where it
   turned out that the fix for a rare problem made it much worse in
   general, from Magnus Karlsson. (Fyi, Magnus mentioned that a proper
   fix is coming early next year, so the revert is mainly to avoid
   slipping the behavior into 5.16.)

2) Minor misc spell fix in BPF selftests, from Colin Ian King.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 8ca4090fec0217bcb89531c8be80fcfa66a397a1:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf (2021-12-17 10:52:04 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 819d11507f6637731947836e6308f5966d64cf9d:

  bpf, selftests: Fix spelling mistake "tained" -> "tainted" (2021-12-17 23:15:16 +0100)

----------------------------------------------------------------
Colin Ian King (1):
      bpf, selftests: Fix spelling mistake "tained" -> "tainted"

Magnus Karlsson (1):
      Revert "xsk: Do not sleep in poll() when need_wakeup set"

 net/xdp/xsk.c                                          | 4 ++--
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)
