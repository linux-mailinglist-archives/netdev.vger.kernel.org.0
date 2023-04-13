Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9506E1531
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 21:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjDMT3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 15:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjDMT3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 15:29:46 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39A3E3;
        Thu, 13 Apr 2023 12:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References;
        bh=4G9g7ajhpst3RbSxuflkQ9QbILGvYhGzAQgyEQ3AEh0=; b=oFiXKm3oVD4A7OHxMI1LfiSq0H
        TgjLMzO+emqGaAVtW6AgZIWAMxJnFMB22yBk+G5Nf84Rk7sPX2smbREGnIDB60c//lvnDKBTTuN+1
        NGnElH78tVc1Rf6xV4GPggt1Q3IZKma01JUvOQZja89+35B9vrWBEckhKefrkvCxlg+jYv1Cr84oH
        0+9hXTV1WxNWAts2Kyai9yfc8XUSnPTWI2Z/MgeZmYnl3x5xGrkUwlx6i/DI7/fSX68ctL3qFMVIe
        IyugRKWPfwRWh95u6AmyYXFCxiFz67SEQw3AqR0hydh1wYy0oJxPG67JxkJOoMcGKX9GgdwPdNAcc
        TF/6L2UQ==;
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pn2dY-000IMA-4i; Thu, 13 Apr 2023 21:29:40 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2023-04-13
Date:   Thu, 13 Apr 2023 21:29:39 +0200
Message-Id: <20230413192939.10202-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26874/Thu Apr 13 09:30:39 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 6 non-merge commits during the last 1 day(s) which contain
a total of 14 files changed, 205 insertions(+), 38 deletions(-).

The main changes are:

1) One late straggler fix on the XDP hints side which fixes bpf_xdp_metadata_rx_hash
   kfunc API before the release goes out in order to provide information on the RSS
   hash type, from Jesper Dangaard Brouer.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Stanislav Fomichev, Toke Høiland-Jørgensen

----------------------------------------------------------------

The following changes since commit 0646dc31ca886693274df5749cd0c8c1eaaeb5ca:

  skbuff: Fix a race between coalescing and releasing SKBs (2023-04-13 10:08:42 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

for you to fetch changes up to b65ef48c95b95960e91f9f3c45e6d079be00f0f3:

  Merge branch 'XDP-hints: change RX-hash kfunc bpf_xdp_metadata_rx_hash' (2023-04-13 11:15:11 -0700)

----------------------------------------------------------------
bpf-for-netdev

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'XDP-hints: change RX-hash kfunc bpf_xdp_metadata_rx_hash'

Jesper Dangaard Brouer (6):
      selftests/bpf: xdp_hw_metadata remove bpf_printk and add counters
      xdp: rss hash types representation
      mlx5: bpf_xdp_metadata_rx_hash add xdp rss hash type
      veth: bpf_xdp_metadata_rx_hash add xdp rss hash type
      mlx4: bpf_xdp_metadata_rx_hash add xdp rss hash type
      selftests/bpf: Adjust bpf_xdp_metadata_rx_hash for new arg

 drivers/net/ethernet/mellanox/mlx4/en_rx.c         | 22 +++++++-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   | 63 +++++++++++++++++++++-
 drivers/net/veth.c                                 | 10 ++--
 include/linux/mlx5/device.h                        | 14 ++++-
 include/linux/netdevice.h                          |  3 +-
 include/net/xdp.h                                  | 47 ++++++++++++++++
 net/core/xdp.c                                     | 10 +++-
 .../selftests/bpf/prog_tests/xdp_metadata.c        |  2 +
 .../testing/selftests/bpf/progs/xdp_hw_metadata.c  | 42 ++++++++-------
 tools/testing/selftests/bpf/progs/xdp_metadata.c   |  6 +--
 tools/testing/selftests/bpf/progs/xdp_metadata2.c  |  7 +--
 tools/testing/selftests/bpf/xdp_hw_metadata.c      | 10 +++-
 tools/testing/selftests/bpf/xdp_metadata.h         |  4 ++
 14 files changed, 205 insertions(+), 38 deletions(-)
