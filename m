Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FA5536939
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 01:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355192AbiE0Xur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 19:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbiE0Xuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 19:50:46 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB45140DD;
        Fri, 27 May 2022 16:50:45 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nujj8-000F2R-F0; Sat, 28 May 2022 01:50:42 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2022-05-28
Date:   Sat, 28 May 2022 01:50:42 +0200
Message-Id: <20220527235042.8526-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26554/Fri May 27 10:04:35 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 2 non-merge commits during the last 1 day(s) which contain
a total of 2 files changed, 6 insertions(+), 10 deletions(-).

The main changes are:

1) Fix ldx_probe_mem instruction in interpreter by properly zero-extending
   the bpf_probe_read_kernel() read content, from Menglong Dong.

2) Fix stacktrace_build_id BPF selftest given urandom_read has been renamed
   into urandom_read_iter in random driver, from Song Liu.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

David Vernet, Hao Peng, Jiang Biao, Mykola Lysenko

----------------------------------------------------------------

The following changes since commit 2c262b21de6dc93ac4d8c7a4cea0da4226b451fb:

  net: usb: qmi_wwan: add Telit 0x1250 composition (2022-05-27 12:12:40 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to caff1fa4118cec4dfd4336521ebd22a6408a1e3e:

  bpf: Fix probe read error in ___bpf_prog_run() (2022-05-28 01:09:18 +0200)

----------------------------------------------------------------
Menglong Dong (1):
      bpf: Fix probe read error in ___bpf_prog_run()

Song Liu (1):
      selftests/bpf: fix stacktrace_build_id with missing kprobe/urandom_read

 kernel/bpf/core.c                                          | 14 +++++---------
 .../testing/selftests/bpf/progs/test_stacktrace_build_id.c |  2 +-
 2 files changed, 6 insertions(+), 10 deletions(-)
