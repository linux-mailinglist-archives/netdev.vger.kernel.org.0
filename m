Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F402743DAB4
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 07:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhJ1FXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 01:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhJ1FXm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 01:23:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B219A6103B;
        Thu, 28 Oct 2021 05:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635398476;
        bh=hc213OuNxOdTxaDBszcVdV9G1A8ZlJWyR/+4K+KWtEw=;
        h=From:To:Cc:Subject:Date:From;
        b=hNsOayPcgPAa2piTkOp8TQtBPsV9ZW5FQO+hY5Wyfn2lEVzTck/X8F6tUQDC/oiqR
         xiCjEnxFFrqAr46tc1VUIsNj8pscdOYM5DCInohXhzDfGBdNo5DcmrMvlH8EqR3ldr
         +cIuU9xNlulbZBRMvnZdUInlHdhgY6+sTrIiYqjHPMTmHQZY5NAvnNQ5JguXszNxB3
         0GExBsUjsUKa3v9lqx/6urOqABlOiu2xsJMkK6JqbbZOIHYoRccJmIBHXUqUXNMcwT
         6V3UkLhqZ9CgdQKi3cwCMIAtoAsoTfPViqNKoZA/QeNlq0eBifwi2cw6i9y6R3nu37
         sMJDivwvVIFfg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull-request][net-next] Merge mlx5-next into net-next
Date:   Wed, 27 Oct 2021 22:21:04 -0700
Message-Id: <20211028052104.1071670-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This pull request provides a single merge commit of mlx5-next into net-next
which handles a non-trivial conflict.

The commits from mlx5-next provide MR (Memory Region) Memory Key
management cleanup in mlx5 IB driver and mlx5 core driver [1].

Please pull and let me know if there's any problem.

[1] https://patchwork.kernel.org/project/netdevbpf/cover/cover.1634033956.git.leonro@nvidia.com/

Thanks,
Saeed.

-- 

The following changes since commit f25c0515c521375154c62c72447869f40218c861:

  net: sched: gred: dynamically allocate tc_gred_qopt_offload (2021-10-27 12:06:52 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-net-next-5.15-rc7

for you to fetch changes up to 573bce9e675b0654e18a338ca9a64187fc19806f:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux into net-next (2021-10-27 21:33:28 -0700)

----------------------------------------------------------------
Merge mlx5-next into net-next

----------------------------------------------------------------
Aharon Landau (8):
      net/mlx5: Add ifc bits to support optional counters
      net/mlx5: Add priorities for counters in RDMA namespaces
      RDMA/mlx5: Remove iova from struct mlx5_core_mkey
      RDMA/mlx5: Remove size from struct mlx5_core_mkey
      RDMA/mlx5: Remove pd from struct mlx5_core_mkey
      RDMA/mlx5: Replace struct mlx5_core_mkey by u32 key
      RDMA/mlx5: Move struct mlx5_core_mkey to mlx5_ib
      RDMA/mlx5: Attach ndescs to mlx5_ib_mkey

Leon Romanovsky (1):
      Merge brank 'mlx5_mkey' into rdma.git for-next

Meir Lichtinger (2):
      net/mlx5: Add uid field to UAR allocation structures
      IB/mlx5: Enable UAR to have DevX UID

Saeed Mahameed (1):
      Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux into net-next

 drivers/infiniband/hw/mlx5/cmd.c                   | 26 +++++++
 drivers/infiniband/hw/mlx5/cmd.h                   |  2 +
 drivers/infiniband/hw/mlx5/devx.c                  | 13 ++--
 drivers/infiniband/hw/mlx5/devx.h                  |  2 +-
 drivers/infiniband/hw/mlx5/main.c                  | 55 +++++++-------
 drivers/infiniband/hw/mlx5/mlx5_ib.h               | 31 ++++----
 drivers/infiniband/hw/mlx5/mr.c                    | 83 +++++++++++-----------
 drivers/infiniband/hw/mlx5/odp.c                   | 38 +++-------
 drivers/infiniband/hw/mlx5/wr.c                    | 10 +--
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  6 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.h   |  2 +-
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.c    | 10 +--
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |  6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 23 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    | 10 +--
 .../net/ethernet/mellanox/mlx5/core/fpga/core.h    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 54 +++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/mr.c       | 27 +++----
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      | 10 +--
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c | 11 ++-
 .../mellanox/mlx5/core/steering/dr_types.h         |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/uar.c      | 14 ++--
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |  8 +--
 drivers/vdpa/mlx5/core/mr.c                        |  8 +--
 drivers/vdpa/mlx5/core/resources.c                 | 13 ++--
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  2 +-
 include/linux/mlx5/device.h                        |  2 +
 include/linux/mlx5/driver.h                        | 32 ++-------
 include/linux/mlx5/fs.h                            |  2 +
 include/linux/mlx5/mlx5_ifc.h                      | 26 +++++--
 34 files changed, 292 insertions(+), 248 deletions(-)
