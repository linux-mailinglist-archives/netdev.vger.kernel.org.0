Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936593B4D76
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 09:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhFZHqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 03:46:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229573AbhFZHqx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Jun 2021 03:46:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28FA86186A;
        Sat, 26 Jun 2021 07:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624693470;
        bh=c/yMC6oVIJErHw1pVBg2nr2iJhdsV0sL437pPFygCYM=;
        h=From:To:Cc:Subject:Date:From;
        b=g9WvcYqW1Uh1QOgLZZJgU5RvO37P/RZQ/9T2ciusE3mHvs9f0KIqeTRMT9sL6dNzT
         S7I/zPFLM3SyLryXbWDdXnsKnEs+P5k5/WIpH/22Ryyi3GL9n7/CGBODMKfOZUJT7Q
         N9EH9WD81qbjGuQrd1OO5xAMkbS9BmS7GV2W38P75zRb6zN1CAsN8a8DnYal95DDp7
         9UMzC1t7oZ99theKg0DkxjwRWsGzYnMAfY6z9S8xIY+0CefMyYzCLvyfZe/OU18ZV9
         ionIEE6byyICHT50x48Ux2c0VY8L3CZiwfBdgx7akBLg2A1rosyCmL6WMkkCmqiQ09
         6UNRDE2k2MSKQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 0/6] mlx5 updates 2021-06-26
Date:   Sat, 26 Jun 2021 00:44:11 -0700
Message-Id: <20210626074417.714833-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series provides misc updates to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Sorry about the weekend submission but I have an important submission
coming up "XDP/AF_XDP support for switchdev representors", so I thought
maybe I should clean up my queue of all this clutter, before submitting
the XDP for reps.

Thanks,
Saeed.

---

---
The following changes since commit ff8744b5eb116fdf9b80a6ff774393afac7325bd:

  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2021-06-25 11:59:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-06-26

for you to fetch changes up to 5589b8f1a2c74670cbca9ea98756dbb8f92569b8:

  net/mlx5e: Add IPsec support to uplink representor (2021-06-26 00:31:25 -0700)

----------------------------------------------------------------
mlx5-updates-2021-06-26

This series provides small updates to mlx5 driver.

1) Increase hairpin buffer size

2) Improve performance in SF allocation

3) Add IPsec support to uplink representor

4) Add stats for number of deleted kTLS TX offloaded connections

5) Add support for flow sampler in SW steering

----------------------------------------------------------------
Ariel Levkovich (1):
      net/mlx5: Increase hairpin buffer size

Eli Cohen (1):
      net/mlx5: SF, Improve performance in SF allocation

Raed Salem (1):
      net/mlx5e: Add IPsec support to uplink representor

Tariq Toukan (1):
      net/mlx5e: kTLS, Add stats for number of deleted kTLS TX offloaded connections

Yevgeny Kliteynik (2):
      net/mlx5: Compare sampler flow destination ID in fs_core
      net/mlx5: DR, Add support for flow sampler offload

 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |  2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.h |  1 +
 .../mellanox/mlx5/core/en_accel/tls_stats.c        |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  7 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  4 +-
 .../net/ethernet/mellanox/mlx5/core/sf/hw_table.c  | 23 +++++----
 .../mellanox/mlx5/core/steering/dr_action.c        | 55 ++++++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  | 33 +++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h         | 14 ++++++
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   | 17 +++++--
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |  3 ++
 include/linux/mlx5/mlx5_ifc.h                      |  5 ++
 14 files changed, 152 insertions(+), 16 deletions(-)
