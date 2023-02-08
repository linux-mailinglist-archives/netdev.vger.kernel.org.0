Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E6568E506
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjBHAhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjBHAhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:37:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F5A3D089
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:37:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 512CF61460
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2ACBC433D2;
        Wed,  8 Feb 2023 00:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675816637;
        bh=Xvr8LUcnzevZVmjl1AKeS9fauzdQbHEUjX81QjqmAKM=;
        h=From:To:Cc:Subject:Date:From;
        b=Rwmo7GhDLM9dz2IPqX4UTdK+tEvVzkoyj90h5X5aBcdyqqey+Yd415flvthblvGqm
         SB5XJWJIu/AUUSnUXBvmcZBeEkFiActW7QVdvq1N+qCR7rqk2jQ7QohPromom++/QV
         gJp7zpDOCAZtOVK0KDGz8xdLkM3JfQWwPcs4K1l1sJcJl7nhpikoJSRmnSbydzReIs
         ceaUpcDjUXa0haFluls/4VGAL6P04WB+mb4qsoW4huuYLVsRPRX9V3ecAQ9uBqQlmx
         2nS52Q3XkkCmFQ1y5l79TOW3L9tAQcxrFc0DhmCvKCy1cOUncXL/5hCXq2RWI3bKIn
         42gWDq+ceacNA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2023-02-07
Date:   Tue,  7 Feb 2023 16:36:57 -0800
Message-Id: <20230208003712.68386-1-saeed@kernel.org>
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

This series adds minor misc updates to mlx5.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 383d9f87a06dd923c4fd0fdcb65b58258851f545:

  Merge branch 'net-core-use-a-dedicated-kmem_cache-for-skb-head-allocs' (2023-02-07 11:00:03 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-02-07

for you to fetch changes up to f7133135235dbd11e7cb5fe62fe5d05ce5e82eeb:

  net/mlx5: fw_tracer, Add support for unrecognized string (2023-02-07 16:29:56 -0800)

----------------------------------------------------------------
mlx5-updates-2023-02-07

Minor updates to mlx5 driver:

1) Minor and trivial code Cleanups

2) Minor fixes for net-next

3) From Shay: dynamic FW trace strings update.

----------------------------------------------------------------
Arnd Bergmann (1):
      mlx5: reduce stack usage in mlx5_setup_tc

Gal Pressman (2):
      net/mlx5e: Remove incorrect debugfs_create_dir NULL check in hairpin
      net/mlx5e: Remove incorrect debugfs_create_dir NULL check in TLS

Leon Romanovsky (1):
      net/mlx5e: Don't listen to remove flows event

Maher Sanalla (1):
      net/mlx5: Fix memory leak in error flow of port set buffer

Maor Dickman (1):
      net/mlx5: fs_core, Remove redundant variable err

Moshe Shemesh (1):
      net/mlx5: fw reset: Skip device ID check if PCI link up failed

Roi Dayan (3):
      net/mlx5e: Remove redundant code for handling vlan actions
      net/mlx5: fs, Remove redundant vport_number assignment
      net/mlx5: fs, Remove redundant assignment of size

Shay Drory (5):
      net/mlx5: Remove redundant health work lock
      net/mlx5: fw_tracer: Fix debug print
      net/mlx5: fw_tracer, allow 0 size string DBs
      net/mlx5: fw_tracer, Add support for strings DB update event
      net/mlx5: fw_tracer, Add support for unrecognized string

 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  79 +++++++-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.h   |   9 +
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |   4 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/vlan.c   |  35 +---
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    |   4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   2 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  11 --
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   5 -
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 208 +--------------------
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   7 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |  28 +--
 include/linux/mlx5/device.h                        |   1 +
 include/linux/mlx5/driver.h                        |   2 -
 16 files changed, 117 insertions(+), 299 deletions(-)
