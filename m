Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C175E319866
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhBLC6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:58:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhBLC6B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:58:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86CCA64E57;
        Fri, 12 Feb 2021 02:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613098640;
        bh=mEz5dOfvalKu1z4p24zekQKrfg5dDognASMbyIIIgSM=;
        h=From:To:Cc:Subject:Date:From;
        b=faTrrbyzzgcHHsS/cbQPvk07qThlPhGwZRDiGcrXXjnQHhZ4WO2R83ct6MMkidZQf
         lYx4T2XZBp77078yxIetf4NMQmgRuH0B8o85H7D/UyB5Ypca2kVkfkeE4yzWbQibNb
         qdd2t3OQB9IEQulTAtdpk1MdBCXL3oRwRWV1+t8/DqwOfPWf/wqRhD2uGrOPV3fd3B
         wQ2+wYK+tknpkW9bM2n/zYG8BDA6rqcIomRoWQLymWoWfAj4PIr+PECzzfEqx+NiZr
         HpenVU6RhNM1c7OCb463NecK5T78JfIiT0JLgy4N2EIYlcXZbutEkrvOyI8EyGrLV/
         i8khP1SZjvU7w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/15] mlx5 fixes 2021-02-11
Date:   Thu, 11 Feb 2021 18:56:26 -0800
Message-Id: <20210212025641.323844-1-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series introduces some fixes to mlx5 driver.
Please pull and let me know if there is any problem.

For -stable v5.4
 ('net/mlx5e: E-switch, Fix rate calculation for overflow')i

For -stable v5.10
 ('net/mlx5: Disallow RoCE on multi port slave device')
 ('net/mlx5: Disable devlink reload for multi port slave device')
 ('net/mlx5e: Don't change interrupt moderation params when DIM is enabled')
 ('net/mlx5e: Replace synchronize_rcu with synchronize_net')
 ('net/mlx5e: Enable XDP for Connect-X IPsec capable devices')
 ('net/mlx5e: kTLS, Use refcounts to free kTLS RX priv context')
 ('net/mlx5e: Check tunnel offload is required before setting SWP')
 ('net/mlx5: Fix health error state handling')
 ('net/mlx5: Disable devlink reload for lag devices')
 ('net/mlx5e: CT: manage the lifetime of the ct entry object')

Thanks,
Saeed.

---
The following changes since commit 9c899aa6ac6ba1e28feac82871d44af0b0e7e05c:

  Merge branch 'mptcp-Miscellaneous-fixes' (2021-02-11 18:30:55 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-02-11

for you to fetch changes up to e1c3940c6003d820c787473c65711b49c2d1bc42:

  net/mlx5e: Check tunnel offload is required before setting SWP (2021-02-11 18:50:16 -0800)

----------------------------------------------------------------
mlx5-fixes-2021-02-11

----------------------------------------------------------------
Maxim Mikityanskiy (5):
      net/mlx5e: Don't change interrupt moderation params when DIM is enabled
      net/mlx5e: Change interrupt moderation channel params also when channels are closed
      net/mlx5e: Replace synchronize_rcu with synchronize_net
      net/mlx5e: Fix CQ params of ICOSQ and async ICOSQ
      net/mlx5e: kTLS, Use refcounts to free kTLS RX priv context

Moshe Shemesh (1):
      net/mlx5e: Check tunnel offload is required before setting SWP

Oz Shlomo (1):
      net/mlx5e: CT: manage the lifetime of the ct entry object

Parav Pandit (1):
      net/mlx5e: E-switch, Fix rate calculation for overflow

Raed Salem (2):
      net/mlx5e: Enable striding RQ for Connect-X IPsec capable devices
      net/mlx5e: Enable XDP for Connect-X IPsec capable devices

Shay Drory (5):
      net/mlx5: Fix health error state handling
      net/mlx5: Disable devlink reload for multi port slave device
      net/mlx5: Disallow RoCE on multi port slave device
      net/mlx5: Disallow RoCE on lag device
      net/mlx5: Disable devlink reload for lag devices

 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   9 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 259 +++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   2 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  66 +++---
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  39 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  22 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.h   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |  22 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   3 +-
 14 files changed, 295 insertions(+), 141 deletions(-)
