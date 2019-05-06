Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C54101484F
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 12:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfEFKXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 06:23:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:50320 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfEFKXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 06:23:45 -0400
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNamb-0004jP-NC; Mon, 06 May 2019 12:23:42 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf 2019-05-06
Date:   Mon,  6 May 2019 12:23:41 +0200
Message-Id: <20190506102341.12361-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25441/Mon May  6 10:04:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

The main changes are:

1) Two x32 JIT fixes: one which has buggy signed comparisons in 64
   bit conditional jumps and another one for 64 bit negation, both
   from Wang.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 886b7a50100a50f1cbd08a6f8ec5884dfbe082dc:

  ipv6: A few fixes on dereferencing rt->from (2019-05-01 17:17:54 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to b9aa0b35d878dff9ed19f94101fe353a4de00cc4:

  bpf, x32: Fix bug for BPF_ALU64 | BPF_NEG (2019-05-01 23:40:47 +0200)

----------------------------------------------------------------
Wang YanQing (2):
      bpf, x32: Fix bug for BPF_JMP | {BPF_JSGT, BPF_JSLE, BPF_JSLT, BPF_JSGE}
      bpf, x32: Fix bug for BPF_ALU64 | BPF_NEG

 arch/x86/net/bpf_jit_comp32.c              | 236 +++++++++++++++++++++--------
 tools/testing/selftests/bpf/verifier/jit.c |  19 +++
 2 files changed, 191 insertions(+), 64 deletions(-)
