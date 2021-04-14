Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2899435FA3A
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352010AbhDNSGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351962AbhDNSGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 14:06:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACAC861177;
        Wed, 14 Apr 2021 18:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618423572;
        bh=QEkLV+VNRCMCVMX2mC84rTRe49UfNTzBMHDvT6N3m8w=;
        h=From:To:Cc:Subject:Date:From;
        b=JP2SbxCINPtLnbOaLsps5cCLemkTnmkb9sycuv43JJZmgUYTlEka1Hcn5i/W4xNxZ
         Bv+D6dolNdNXxLBTAHXIj+rU0HXvoZcoOf9UNJNifvwvhxrhNpRHAzq0QE4c+JUHCx
         YA73yqP6KlOq7JawqZHMNtUlrKiWR1NDYlJaOhyuCE9wLXasPRKI4YQ09hIjLLmiGy
         ZPTuZ37qj3etb7S+MBMF10AHQXTG3TJx6hgH9+AmF08fF7UOWh11+GDmV/T+nAdo+I
         edSnw6W152qvhn90lq5J/onlHGiQEqG75gmI0HnLU+FQkmjQXuLeCt4S4xfp+T8VlQ
         Gl+hy5lveRz5g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next V2 00/16] mlx5 updates 2021-04-13
Date:   Wed, 14 Apr 2021 11:05:49 -0700
Message-Id: <20210414180605.111070-1-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This patchset includes some updates and cleanup to mlx5 driver.
For more information please see tag log below.

v1->v2: update 1st patch commit message and mlx5 documentation to
include performance numbers and applicability of the metadata settings.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 8ef7adc6beb2ef0bce83513dc9e4505e7b21e8c2:

  net: ethernet: ravb: Enable optional refclk (2021-04-12 14:09:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-04-13

for you to fetch changes up to 5b232ea94c90aa6196321820740e2969ae64e9cb:

  net/mlx5e: Fix RQ creation flow for queues which doesn't support XDP (2021-04-14 11:03:10 -0700)

----------------------------------------------------------------
mlx5-updates-2021-04-13

mlx5 core and netdev driver updates

1) E-Switch updates from Parav,
  1.1) Devlink parameter to control mlx5 metadata enablement for E-Switch
  1.2) Trivial cleanups for E-Switch code
  1.3) Dynamically allocate vport steering namespaces only when required

2) From Jianbo, Use variably sized data structures for Software steering

3) Several minor cleanups

----------------------------------------------------------------
Aya Levin (1):
      net/mlx5e: Fix RQ creation flow for queues which doesn't support XDP

Colin Ian King (1):
      net/mlx5: Fix bit-wise and with zero

Jianbo Liu (1):
      net/mlx5: DR, Use variably sized data structures for different actions

Parav Pandit (9):
      net/mlx5: E-Switch, let user to enable disable metadata
      net/mlx5: E-Switch, Skip querying SF enabled bits
      net/mlx5: E-Switch, Make vport number u16
      net/mlx5: E-Switch Make cleanup sequence mirror of init
      net/mlx5: E-Switch, Convert a macro to a helper routine
      net/mlx5: E-Switch, Move legacy code to a individual file
      net/mlx5: E-Switch, Initialize eswitch acls ns when eswitch is enabled
      net/mlx5: SF, Use device pointer directly
      net/mlx5: SF, Reuse stored hardware function id

Roi Dayan (1):
      net/mlx5: DR, Alloc cmd buffer with kvzalloc() instead of kzalloc()

Wenpeng Liang (3):
      net/mlx5: Add a blank line after declarations
      net/mlx5: Remove return statement exist at the end of void function
      net/mlx5: Replace spaces with tab at the start of a line

 .../device_drivers/ethernet/mellanox/mlx5.rst      |  34 ++
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  62 +++
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   | 509 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.h   |  22 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 595 +++------------------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  11 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  33 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  88 ++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   7 +
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |   2 -
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |   1 -
 .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   |   5 +-
 .../net/ethernet/mellanox/mlx5/core/sf/hw_table.c  |  16 +-
 .../mellanox/mlx5/core/steering/dr_action.c        | 242 +++++----
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |   4 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |  14 +-
 .../mellanox/mlx5/core/steering/dr_table.c         |   4 +-
 .../mellanox/mlx5/core/steering/dr_types.h         | 104 ++--
 include/linux/mlx5/eswitch.h                       |   3 +-
 26 files changed, 996 insertions(+), 778 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.h
