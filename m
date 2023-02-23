Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC26C6A130E
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 23:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjBWWw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 17:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBWWw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 17:52:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF529038
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 14:52:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 802AEB81A93
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 22:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5F3C433D2;
        Thu, 23 Feb 2023 22:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677192775;
        bh=qT4MrhaK5M9vMRQ/2zb4mpmDXzro2HjHJlW2ob9t0Jo=;
        h=From:To:Cc:Subject:Date:From;
        b=RrxF7utYSmZ0Yek94IjRFnzHNmj5uFq0AhLSFMdy62GSgv5cF816JShlzJKoIRRz3
         hN0BYP9B7XRYhWMtpGnDz1KGecm5fhhoSfKzfPjuq0ZNNyU8tJMgxDMZtDmvooriPc
         jTzmRycAX0XectuB89AkSuKDNorRPrHGqJkd4DERae19z64TohMedQrgxw6LtBu24H
         IQOXz2Ls3+3RA1WheBtI6+wo/jghoJ2Dv96OYfQi/yqDSRE3K/2feHMyRl8NHA0nqr
         YW/j+Vrb3l3Rnqzj2fUzz/ZDRDKCiFEgM03rUtjaPWcTRzhizt663q99EbUCpTFpnQ
         i1y2kQCCIeimg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net 00/10] mlx5 fixes 2023-02-23
Date:   Thu, 23 Feb 2023 14:52:37 -0800
Message-Id: <20230223225247.586552-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series provides bug fixes for mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 68ba44639537de6f91fe32783766322d41848127:

  sctp: add a refcnt in sctp_stream_priorities to avoid a nested loop (2023-02-23 12:59:40 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2023-02-23

for you to fetch changes up to 290a9c352e2a7c422af059d585352e3a7a44c0d1:

  net/mlx5: Geneve, Fix handling of Geneve object id as error code (2023-02-23 14:50:39 -0800)

----------------------------------------------------------------
mlx5-fixes-2023-02-23

----------------------------------------------------------------
Maher Sanalla (1):
      net/mlx5: ECPF, wait for VF pages only after disabling host PFs

Maor Dickman (1):
      net/mlx5: Geneve, Fix handling of Geneve object id as error code

Maxim Mikityanskiy (2):
      net/mlx5e: XDP, Allow growing tail for XDP multi buffer
      net/mlx5e: xsk: Set napi_id to support busy polling on XSK RQ

Rahul Rameshbabu (1):
      net/mlx5e: Correct SKB room check to use all room in the fifo

Roi Dayan (1):
      net/mlx5e: Verify flow_source cap before using it

Vadim Fedorenko (2):
      mlx5: fix skb leak while fifo resync and push
      mlx5: fix possible ptp queue fifo use-after-free

Yang Li (1):
      net/mlx5: Remove NULL check before dev_{put, hold}

Yang Yingliang (1):
      net/mlx5e: TC, fix return value check in mlx5e_tc_act_stats_create()

 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c     |  4 ++++
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  8 +++++--
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   | 25 +++++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  3 +--
 .../ethernet/mellanox/mlx5/core/en/tc/act_stats.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  4 +++-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  7 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  1 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/lib/geneve.c   |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |  4 ++++
 14 files changed, 52 insertions(+), 14 deletions(-)
