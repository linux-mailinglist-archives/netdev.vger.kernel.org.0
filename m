Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352D8577853
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 23:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiGQVfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 17:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiGQVfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 17:35:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D96B10556
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 14:35:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F485B80EB9
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 21:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16438C3411E;
        Sun, 17 Jul 2022 21:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658093741;
        bh=FuHNgjD9tuytvXaHiNTBXr6RtE7rzRvpoX8yOiBTRd0=;
        h=From:To:Cc:Subject:Date:From;
        b=ld1Xf3oIDFE9S9TWLNEGYEkhOyt66TByYDWP7Oe/mageZyDxzRokX2GzQ9WX5U3kC
         /GNIbZ8mewQBsF7C2SxRbmTPVLoMivCKgP6DpCXLmg6gJ5E1c4czsBjSULiEs7TOA8
         5Edlu8n3JamulcN/bVRGYXXrl58b791GdOTVH51Ot7CzX94aKlyXrwGb0whtEB+gR6
         cSIqEVnof7Nwi4AigurHtVJXqbQhZBZOIID5APOmsdyTjLfO/ui/gR6E41/XNeXgrb
         UMs+cELHComexSzNNd3oCkyl3MoveoCyeCr3E28h89r+t8OgKFdzI/TTx8VVeHE+pL
         caqM8MtDBU/SA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/14] mlx5 updates 2022-07-17
Date:   Sun, 17 Jul 2022 14:33:38 -0700
Message-Id: <20220717213352.89838-1-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Misc updates for mlx5 driver.

For more information please see tag log below.

Please pull and let me know if there is any problem.

This Conflicts with mlx5 TLS pool series from Tariq [1]
TLS pool is currently in changes-requested status, and I believe Tariq
will need to rebase it anyways after back merge with net.

[1] https://lore.kernel.org/netdev/20220713051603.14014-3-tariqt@nvidia.com/T/

Thanks,
Saeed.


The following changes since commit 2acd1022549e210edc4cfc9fc65b07b88751f0d9:

  Merge branch 'net-ipv4-ipv6-new-option-to-accept-garp-untracked-na-only-if-in-network' (2022-07-15 18:55:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-07-17

for you to fetch changes up to 485b5e2f84bf76939ba4716c78f2b69fcf43b7d8:

  net/mlx5: CT: Remove warning of ignore_flow_level support for non PF (2022-07-17 14:25:23 -0700)

----------------------------------------------------------------
mlx5-updates-2022-07-17

1) Add resiliency for lost completions for PTP TX port timestamp

2) Report Header-data split state via ethtool

3) Decouple HTB code from main regular TX code

----------------------------------------------------------------
Aya Levin (2):
      net/mlx5: Expose ts_cqe_metadata_size2wqe_counter
      net/mlx5e: Add resiliency for PTP TX port timestamp

Gal Pressman (2):
      net/mlx5e: Report header-data split state through ethtool
      net/mlx5e: Expose rx_oversize_pkts_buffer counter

Moshe Tal (7):
      net/mlx5e: Fix mqprio_rl handling on devlink reload
      net/mlx5e: HTB, move ids to selq_params struct
      net/mlx5e: HTB, move section comment to the right place
      net/mlx5e: HTB, move stats and max_sqs to priv
      net/mlx5e: HTB, remove priv from htb function calls
      net/mlx5e: HTB, change functions name to follow convention
      net/mlx5e: HTB, move htb functions to a new file

Roi Dayan (1):
      net/mlx5: CT: Remove warning of ignore_flow_level support for non PF

Saeed Mahameed (2):
      net/mlx5e: HTB, reduce visibility of htb functions
      net/mlx5e: HTB, hide and dynamically allocate mlx5e_htb structure

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  20 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/htb.c   | 722 ++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/htb.h   |  46 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |  37 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   | 813 +++------------------
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h   |  37 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/selq.c  |  51 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/selq.h  |   4 +-
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 228 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  35 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  10 +
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |   2 +-
 include/linux/mlx5/mlx5_ifc.h                      |  14 +-
 20 files changed, 1183 insertions(+), 864 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/htb.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/htb.h
