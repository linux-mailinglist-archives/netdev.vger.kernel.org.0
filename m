Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0B7453AE0
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhKPU0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:26:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:46352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229700AbhKPU0c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:26:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D343E61ABD;
        Tue, 16 Nov 2021 20:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637094215;
        bh=s075hH81Sf5mtGtRIqAmPtRIWRgk6Ys1TO7rHUM1e4Y=;
        h=From:To:Cc:Subject:Date:From;
        b=A6nR6MF+FCW75Dxjx/au4SZNpLy/ZDh5+LdR0Q4oDJmxrX86Yin789KXyWy22V8VX
         WZVQKZYe240SODfOAU+khbQ8+Zy9tCL9kdYbqv5q1eolxNF1JyXQb403XYIyHom16Y
         p1mBZBX5Ym3WB8sjp0fALTThOW4i98w4EgO+2XaycRhl63iNvvdKZd+Ce3mPmBJq5C
         kgx3geahQS9uz+iN57fi+ZSQ7lqrHFU2l6y+ENDXPmzxBnukG4I7gwpJqdxrPkUx26
         DXBt195LUaEjyGZ7H2WE18H9ahHFxyoq7lc/dXscu5x9d6F051kNlMZW0SO5jek/DR
         SwNdcAom0JtBw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/12] mlx5 fixes 2021-11-16
Date:   Tue, 16 Nov 2021 12:23:09 -0800
Message-Id: <20211116202321.283874-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

Please pull this mlx5 fixes series, or let me know in case of any problem.

Thanks,
Saeed.

The following changes since commit 848e5d66fa3105b4136c95ddbc5654e9c43ba7d7:

  Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue (2021-11-16 13:27:32 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-11-16

for you to fetch changes up to c4c3176739dfa6efcc5b1d1de4b3fd2b51b048c7:

  net/mlx5: E-Switch, return error if encap isn't supported (2021-11-16 12:20:23 -0800)

----------------------------------------------------------------
mlx5-fixes-2021-11-16

----------------------------------------------------------------
Avihai Horon (1):
      net/mlx5: Fix flow counters SF bulk query len

Maher Sanalla (1):
      net/mlx5: Lag, update tracker when state change event received

Mark Bloch (1):
      net/mlx5: E-Switch, rebuild lag only when needed

Neta Ostrovsky (1):
      net/mlx5: Update error handler for UCTX and UMEM

Paul Blakey (1):
      net/mlx5: E-Switch, Fix resetting of encap mode when entering switchdev

Raed Salem (1):
      net/mlx5: E-Switch, return error if encap isn't supported

Roi Dayan (1):
      net/mlx5e: CT, Fix multiple allocations and memleak of mod acts

Tariq Toukan (1):
      net/mlx5e: kTLS, Fix crash in RX resync flow

Valentine Fatiev (1):
      net/mlx5e: nullify cq->dbg pointer in mlx5_debug_cq_remove()

Vlad Buslov (1):
      net/mlx5e: Wait for concurrent flow deletion during neigh/fib events

Yevgeny Kliteynik (2):
      net/mlx5: DR, Handle eswitch manager and uplink vports separately
      net/mlx5: DR, Fix check for unsupported fields in match param

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 26 ++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |  2 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |  1 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |  8 +++-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 23 ++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 10 +++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 21 ++++++--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  9 +---
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  | 28 +++++------
 .../mellanox/mlx5/core/steering/dr_domain.c        | 56 +++++++++-------------
 .../mellanox/mlx5/core/steering/dr_matcher.c       | 11 +++--
 .../mellanox/mlx5/core/steering/dr_types.h         |  1 +
 include/linux/mlx5/eswitch.h                       |  4 +-
 17 files changed, 124 insertions(+), 91 deletions(-)
