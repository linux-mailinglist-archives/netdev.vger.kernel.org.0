Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A863E976D
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhHKSSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:18:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229703AbhHKSSf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 14:18:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A5CA60E78;
        Wed, 11 Aug 2021 18:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628705891;
        bh=3xXGwjBJ6ulV3QyYak5gODw0UvFmWyFgsQ56VQL2Urs=;
        h=From:To:Cc:Subject:Date:From;
        b=WIdffP3akJpPttpQlRRPZ7IjyCtyp7fImcpa+ClTIaJqI9jPaLI/Ruh2f22FkB+6X
         A+WVfAArCT9Da6wIYiOrnbSZH8+DxIPLH8TUAQqO+5XD6xmia4lo46P5GwPOmN5Lmt
         1njEIHwEm5gJFm/Y+hUGQTSCC9iqZLjOcncdSAY3O32YqOzFzDeubZzZiHCPDjYJtB
         UduZH6pc0n10z9f05OeYkPxOfhTBaqm+RERe6LT/2IB5lh2eCnM4jlP+hJh+ZE1lUJ
         FOjN3cYvmYFRRbhIK76JSxTCR+Q0MMqRB+xjSSGoJ++ISw/EB1rG6+g5kmdILBUTBz
         b/pM9YCrm4JIg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/12] mlx5 updates 2021-08-11
Date:   Wed, 11 Aug 2021 11:16:46 -0700
Message-Id: <20210811181658.492548-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series provides misc updates to mlx5.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 88be3263490514854a1445ae95560585601ff160:

  Merge branch 'dsa-tagger-helpers' (2021-08-11 14:44:59 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-08-11

for you to fetch changes up to 61b6a6c395d6a5d15a85c7c6613d4bd6ffc547ff:

  net/mlx5e: Make use of netdev_warn() (2021-08-11 11:14:34 -0700)

----------------------------------------------------------------
mlx5-updates-2021-08-11

Misc. cleanup for mlx5.

1) Typos and use of netdev_warn()
2) smatch cleanup
3) Minor fix to inner TTC table creation
4) Dynamic capability cache allocation

----------------------------------------------------------------
Cai Huoqing (2):
      net/mlx5: Fix typo in comments
      net/mlx5e: Make use of netdev_warn()

Eran Ben Elisha (1):
      net/mlx5: Fix variable type to match 64bit

Leon Romanovsky (1):
      net/mlx5: Delete impossible dev->state checks

Maor Gottlieb (1):
      net/mlx5: Fix inner TTC table creation

Parav Pandit (4):
      net/mlx5: SF, use recent sysfs api
      net/mlx5: Reorganize current and maximal capabilities to be per-type
      net/mlx5: Allocate individual capability
      net/mlx5: Initialize numa node for all core devices

Shay Drory (3):
      net/mlx5: Align mlx5_irq structure
      net/mlx5: Change SF missing dedicated MSI-X err message to dbg
      net/mlx5: Refcount mlx5_irq with integer

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  8 +--
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 13 ++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/events.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |  6 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 80 ++++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  | 75 +++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   |  2 +-
 include/linux/mlx5/device.h                        | 71 ++++++++++---------
 include/linux/mlx5/driver.h                        | 15 ++--
 20 files changed, 190 insertions(+), 107 deletions(-)
