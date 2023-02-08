Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B57068E660
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 04:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjBHDDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 22:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBHDDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 22:03:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF59A233CC
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 19:03:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97B57B81BA4
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F620C433EF;
        Wed,  8 Feb 2023 03:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675825389;
        bh=JGvDq5N3fhtxL1y/kkQjZ9lrIlN6WT+ZxSJZ57pHAA8=;
        h=From:To:Cc:Subject:Date:From;
        b=KNACbykhPslMM+TMnpPzWj7ErT7+GZXXMk1l6lNUQ0N/T3UpUXfHLC6QMi9uYxgMm
         wIs1g64kzg+oSivwW4XGPzbOunkoyotWChTo62B3ALyvnBWT6GJDYuO3M4nOJdQZlH
         1TB+LSj/BW7XkBFQdWvO4ZkK9cdVN93fiIBS8NeEBLN/K4fnBYqUD9vciHdzZRQy/K
         XW3vtsUl5oZ1mJbMuV06uh5YfSnJ5Czn77KYhNrSH7mZt7Yy0cpGAh4Mwwk0WTg5QL
         YGXVi2pQEe7kvxG07ezNt5Bqw/LE7Ne46GGG6sPYOxwFl6A3ivgRs5QDUO8ioIvjho
         j+lQLB6COuFNg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net 00/10] mlx5 fixes 2023-02-07
Date:   Tue,  7 Feb 2023 19:02:52 -0800
Message-Id: <20230208030302.95378-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 565b4824c39fa335cba2028a09d7beb7112f3c9a:

  devlink: change port event netdev notifier from per-net to global (2023-02-07 14:13:55 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2023-02-07

for you to fetch changes up to 8f0d1451ecf7b3bd5a06ffc866c753d0f3ab4683:

  net/mlx5: Serialize module cleanup with reload and remove (2023-02-07 19:01:07 -0800)

----------------------------------------------------------------
mlx5-fixes-2023-02-07

----------------------------------------------------------------
Adham Faris (1):
      net/mlx5e: Update rx ring hw mtu upon each rx-fcs flag change

Amir Tzin (1):
      net/mlx5e: Fix crash unsetting rx-vlan-filter in switchdev mode

Dragos Tatulea (1):
      net/mlx5e: IPoIB, Show unknown speed instead of error

Maher Sanalla (2):
      net/mlx5: Store page counters in a single array
      net/mlx5: Expose SF firmware pages counter

Shay Drory (3):
      net/mlx5: fw_tracer, Clear load bit when freeing string DBs buffers
      net/mlx5: fw_tracer, Zero consumer index when reloading the tracer
      net/mlx5: Serialize module cleanup with reload and remove

Vlad Buslov (1):
      net/mlx5: Bridge, fix ageing of peer FDB entries

Yevgeny Kliteynik (1):
      net/mlx5: DR, Fix potential race in dr_rule_create_rule_nic

 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |  5 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c     |  2 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |  4 -
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 90 +++++-----------------
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |  2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    | 13 ++--
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 14 ++--
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 37 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |  2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c | 25 +++---
 include/linux/mlx5/driver.h                        | 13 +++-
 13 files changed, 86 insertions(+), 126 deletions(-)
