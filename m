Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D57F2EE6D9
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbhAGU3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:29:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:55438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbhAGU3g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:29:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB1B323435;
        Thu,  7 Jan 2021 20:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610051335;
        bh=ASNyZ182XVIgoeUKOaYb/k266Im2fza0TtyXgIWPCvI=;
        h=From:To:Cc:Subject:Date:From;
        b=QvK7jawJnt6EDBgA8Oeox6JZQ8ZbvpRakdDgZ8cYICfLfzG4ueKZfpshGR8cs2LAp
         nGC6cVlkSX41gAYm60H/kghgjENKNnBd7f67Tfaqk+I6FkPBB8Py904LPBZMoKNAsV
         U/nElWXL3TeumJdKUKtMyA09M33OPO4TBJwj6PCsfm8xttqDTrnmA5Uq1j9XEswP9j
         QobvPHRc3YLpWOv8XUu7KKc9cBpxwToT7/PktApvUPFG59QiWfhm/+6YiY1wJxCdpE
         uKt2FAktSad2dIIBb07iQnRR4Fb3Zw7fKPpdZMknIGWoPV/vvu3x82LsDe3FJityiA
         vQlohssQFEm2Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/11] mlx5 fixes 2021-01-07
Date:   Thu,  7 Jan 2021 12:28:34 -0800
Message-Id: <20210107202845.470205-1-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series provides some fixes to mlx5 driver.
Please pull and let me know if there is any problem.


For -stable v5.2
 ('net/mlx5: Use port_num 1 instead of 0 when delete a RoCE address')

For -stable v5.5
 ('net/mlx5e: ethtool, Fix restriction of autoneg with 56G')

For -stable v5.8
 ('net/mlx5e: In skb build skip setting mark in switchdev mode')

For -stable v5.10
 ('net/mlx5: Check if lag is supported before creating one')
 ('net/mlx5e: Fix SWP offsets when vlan inserted by driver')

Thanks,
Saeed.

---
The following changes since commit 5316a7c0130acf09bfc8bb0092407006010fcccc:

  tools: selftests: add test for changing routes with PTMU exceptions (2021-01-07 12:03:36 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-01-07

for you to fetch changes up to 5b0bb12c58ac7d22e05b5bfdaa30a116c8c32e32:

  net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups (2021-01-07 12:22:51 -0800)

----------------------------------------------------------------
mlx5-fixes-2021-01-07

----------------------------------------------------------------
Alaa Hleihel (1):
      net/mlx5: E-Switch, fix changing vf VLANID

Aya Levin (2):
      net/mlx5e: Add missing capability check for uplink follow
      net/mlx5e: ethtool, Fix restriction of autoneg with 56G

Dinghao Liu (2):
      net/mlx5e: Fix two double free cases
      net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups

Leon Romanovsky (1):
      net/mlx5: Release devlink object if adev fails

Maor Dickman (1):
      net/mlx5e: In skb build skip setting mark in switchdev mode

Mark Zhang (2):
      net/mlx5: Check if lag is supported before creating one
      net/mlx5: Use port_num 1 instead of 0 when delete a RoCE address

Moshe Shemesh (1):
      net/mlx5e: Fix SWP offsets when vlan inserted by driver

Oz Shlomo (1):
      net/mlx5e: CT: Use per flow counter when CT flow accounting is enabled

 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  5 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 77 ++++++++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  9 +++
 .../mellanox/mlx5/core/en_accel/en_accel.h         |  8 ++-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   | 24 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  9 +--
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       | 27 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      | 11 ++--
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  7 +-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |  2 +-
 include/linux/mlx5/mlx5_ifc.h                      |  3 +-
 13 files changed, 122 insertions(+), 66 deletions(-)
