Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E8C3E51A6
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 05:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236847AbhHJD74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 23:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236555AbhHJD7z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 23:59:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71191601FF;
        Tue, 10 Aug 2021 03:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628567974;
        bh=UluH++pa3ZCpvRBVsUNrfG/NygvWZDz5tgMC+VQ6If8=;
        h=From:To:Cc:Subject:Date:From;
        b=fE4jcFyAsR7TGlu/bc4hpnbtrV8D0j/OJsUQQBSTdZQ6I4Limq9VefrEJMGW8DIAt
         ixY1jV7vJWEU1vnlibIYZlyKRIHZ/oEfc+Q+IxcSgfKc+pCnkO9yj0KRkP3UephWWs
         GI36B9OwJr51uc998RvpME1h5mOX4uo2SWW8FElFyoNXmrKNNXi55P7Vr8I6Elt0sg
         p68In431FWOh+qNTnC/h77Z1dEcfGUZy7qmOm4r1+uwJUprgROTbchNVYZSj6UIR92
         AR5E8RLYmEU1iiJ7Gw2tnpnA99PcChF+RYDxBSS2MlfX/EWlQaj5tjOoQUksk5Fqzd
         1CfuZjAFdunWA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/12] mlx5 fixes 2021-08-09
Date:   Mon,  9 Aug 2021 20:59:11 -0700
Message-Id: <20210810035923.345745-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series introduces fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit d09c548dbf3b31cb07bba562e0f452edfa01efe3:

  net: sched: act_mirred: Reset ct info when mirror/redirect skb (2021-08-09 10:58:47 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-08-09

for you to fetch changes up to bd37c2888ccaa5ceb9895718f6909b247cc372e0:

  net/mlx5: Fix return value from tracer initialization (2021-08-09 20:57:03 -0700)

----------------------------------------------------------------
mlx5-fixes-2021-08-09

----------------------------------------------------------------
Alex Vesker (1):
      net/mlx5: DR, Add fail on error check on decap

Aya Levin (2):
      net/mlx5: Block switchdev mode while devlink traps are active
      net/mlx5: Fix return value from tracer initialization

Chris Mi (1):
      net/mlx5e: TC, Fix error handling memory leak

Leon Romanovsky (1):
      net/mlx5: Don't skip subfunction cleanup in case of error in module init

Maxim Mikityanskiy (1):
      net/mlx5e: Destroy page pool after XDP SQ to fix use-after-free

Roi Dayan (1):
      net/mlx5e: Avoid creating tunnel headers for local route

Shay Drory (4):
      net/mlx5: Fix order of functions in mlx5_irq_detach_nb()
      net/mlx5: Set all field of mlx5_irq before inserting it to the xarray
      net/mlx5: Destroy pool->mutex
      net/mlx5: Synchronize correct IRQ when destroying CQ

Vlad Buslov (1):
      net/mlx5: Bridge, fix ageing time

 drivers/infiniband/hw/mlx5/cq.c                    |  4 +--
 drivers/infiniband/hw/mlx5/devx.c                  |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |  1 +
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   | 11 ++++++--
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  5 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 33 ++++++++--------------
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       | 20 ++++++++++---
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |  4 +--
 .../net/ethernet/mellanox/mlx5/core/esw/sample.c   |  1 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 14 +++++++--
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |  4 +--
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h   |  2 ++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 12 +++-----
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  5 ++++
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  | 10 +++++--
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |  4 +--
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |  2 ++
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  3 +-
 include/linux/mlx5/driver.h                        |  3 +-
 19 files changed, 83 insertions(+), 58 deletions(-)
