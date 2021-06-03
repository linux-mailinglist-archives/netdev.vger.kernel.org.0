Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D431239AB9E
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhFCUNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:13:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229925AbhFCUNp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 16:13:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C753C610A2;
        Thu,  3 Jun 2021 20:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622751120;
        bh=QWUJTnRaUIP9ftTCwW7QO2yUo0ur2jD+m8fIfSCYh/I=;
        h=From:To:Cc:Subject:Date:From;
        b=Swk+SAU/ISq4oBI5akNKpFXrkXsaYrgGtKPxtaUGELtAPqGV3QmZ+/HqRdwYxs8WO
         YC/yZuDi0UWUVjMPnyleHykGscg/s7EmKwLYhh6SF50LqzLxuPqcpIWBPtrNOKPVjx
         Q1fHomNXIQTs0MfLWxKSg1C12lp+veY2FpfPdLSM/bbTTC0bbtfFZc9s1H4U5n2L4U
         KJknyISRQze6aAgXo84yqoXU6eW7PCqrkABHqPp4d+aQ94ai3tGwZXQ9hObxCus2xT
         11rUN23UyNG33qUPtShRZo/tomHqorOuZ7FblIVWerVCWLbJKnR+em3ldxe1q2X/y3
         pQtHLg76Rfnmw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/10] mlx5 updates 2021-06-03
Date:   Thu,  3 Jun 2021 13:11:45 -0700
Message-Id: <20210603201155.109184-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series provides misc updates for mlx5 drivers.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 270d47dc1fc4756a0158778084a236bc83c156d2:

  Merge branch 'devlink-rate-objects' (2021-06-02 14:08:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-06-03

for you to fetch changes up to f68406ca3b77c90d249e7f50e8f3015408d9ad4a:

  net/mlx5e: Remove unreachable code in mlx5e_xmit() (2021-06-03 13:10:21 -0700)

----------------------------------------------------------------
mlx5-updates-2021-06-03

This series contains misc updates for mlx5 driver

1) Alaa disables advanced features when kdump mode to save on memory
2) Jakub counts all link flap events
3) Meir adds support for IPoIB NDR speed
4) Various misc cleanup

----------------------------------------------------------------
Alaa Hleihel (2):
      net/mlx5e: Disable TX MPWQE in kdump mode
      net/mlx5e: Disable TLS device offload in kdump mode

Dan Carpenter (1):
      net/mlx5: check for allocation failure in mlx5_ft_pool_init()

Jakub Kicinski (1):
      mlx5: count all link events

Jiapeng Chong (1):
      net/mlx5: Fix duplicate included vhca_event.h

Lama Kayal (1):
      net/mlx5e: Zero-init DIM structures

Meir Lichtinger (1):
      net/mlx5e: IPoIB, Add support for NDR speed

Shaokun Zhang (1):
      net/mlx5e: Remove the repeated declaration

Tariq Toukan (1):
      net/mlx5e: RX, Re-place page pool numa node change logic

Vladyslav Tarasiuk (1):
      net/mlx5e: Remove unreachable code in mlx5e_xmit()

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  8 +++++++-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  8 ++++----
 .../mellanox/mlx5/core/en_accel/en_accel.h         |  4 +---
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    | 11 ++++++----
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    | 24 ++++++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  5 ++++-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h        |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.c |  6 +++---
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.h | 10 ++++++++-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |  8 ++++----
 .../mellanox/mlx5/core/en_accel/tls_stats.c        |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 14 +++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  9 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    | 17 ++++-----------
 .../net/ethernet/mellanox/mlx5/core/fs_ft_pool.c   |  2 ++
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |  2 ++
 .../net/ethernet/mellanox/mlx5/core/sf/hw_table.c  |  1 -
 include/linux/netdevice.h                          |  2 +-
 net/sched/sch_generic.c                            | 18 ++++++++++++++++
 20 files changed, 108 insertions(+), 49 deletions(-)
