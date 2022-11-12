Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CAB6268C8
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 11:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbiKLKVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 05:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiKLKVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 05:21:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55112BC32
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 02:21:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D886860B91
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 10:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B3FC433D6;
        Sat, 12 Nov 2022 10:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668248512;
        bh=FrV5TqgHHvWpuu+ZoOtGK3UrDECkvNAYLhj0bsuT224=;
        h=From:To:Cc:Subject:Date:From;
        b=LV4DdJBAYSzP1OYrlwjHNmzrXBuPKJW83o0Ar4zyj1vB5hh1NSgTU7hiXzldA04bI
         QM6eBCcQjByreNZ4Ypok0+LtCQ/iyhRe3NKhK8s4m9aLys9cJ4UtY4oSM68WdQWFXk
         NETt+01G7dwenPbZ5/od+TAOKQaTeqtvbbQZV3ajzukdDDO1/fGFP+O6BojVS4VDV4
         v5OaGodUtCBtxaYIVEh/Ad9YClmaizSi0nknSbLQMgVifQLpsRZKA8++di7LP8Lmkw
         P+chnM4OIttPgm/wF2Qp+kw1crPpcpNMsZk1+vrkN2sioH3ODyvnYZ671Ig9fMUWhd
         eXzTlv68YJT5w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2022-11-12
Date:   Sat, 12 Nov 2022 02:21:32 -0800
Message-Id: <20221112102147.496378-1-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
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

This series provides misc updates to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit b548b17a93fd18357a5a6f535c10c1e68719ad32:

  tcp: tcp_wfree() refactoring (2022-11-11 21:38:03 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-11-12

for you to fetch changes up to e07c4924a77dbf21bf1973411149784cfa5d3b27:

  net/mlx5e: ethtool: get_link_ext_stats for PHY down events (2022-11-12 02:20:20 -0800)

----------------------------------------------------------------
mlx5-updates-2022-11-12

Misc updates to mlx5 driver

1) Support enhanced CQE compression, on ConnectX6-Dx
   Reduce irq rate, cpu utilization and latency.

2) Connection tracking: Optimize the pre_ct table lookup for rules
   installed on chain 0.

3) implement ethtool get_link_ext_stats for PHY down events

4) Expose device vhca_id to debugfs

5) misc cleanups and trivial changes

----------------------------------------------------------------
Anisse Astier (1):
      net/mlx5e: remove unused list in arfs

Colin Ian King (1):
      net/mlx5: Fix spelling mistake "destoy" -> "destroy"

Eli Cohen (1):
      net/mlx5: Expose vhca_id to debugfs

Gal Pressman (1):
      net/mlx5e: Use clamp operation instead of open coding it

Guy Truzman (1):
      net/mlx5e: Add error flow when failing update_rx

Moshe Shemesh (1):
      net/mlx5: Unregister traps on driver unload flow

Ofer Levi (1):
      net/mlx5e: Support enhanced CQE compression

Oz Shlomo (1):
      net/mlx5e: CT, optimize pre_ct table lookup

Roi Dayan (2):
      net/mlx5: Bridge, Use debug instead of warn if entry doesn't exists
      net/mlx5e: TC, Remove redundant WARN_ON()

Saeed Mahameed (1):
      net/mlx5e: ethtool: get_link_ext_stats for PHY down events

Tariq Toukan (4):
      net/mlx5e: Move params kernel log print to probe function
      net/mlx5e: kTLS, Remove unused work field
      net/mlx5e: kTLS, Remove unnecessary per-callback completion
      net/mlx5e: kTLS, Use a single async context object per a callback bulk

 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |  14 ++
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  89 +++++++-----
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  65 ++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |   2 -
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  16 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 150 ++++++++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  17 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   9 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |   8 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   7 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  19 +++
 .../mellanox/mlx5/core/steering/dr_table.c         |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/wq.h       |  17 +++
 include/linux/mlx5/device.h                        |   6 +
 22 files changed, 331 insertions(+), 127 deletions(-)
