Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFDB3B1034
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 00:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhFVWpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 18:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229800AbhFVWpX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 18:45:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BD92611CE;
        Tue, 22 Jun 2021 22:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624401786;
        bh=0sBL38LOD78Ga6PwBVUaqEcY4iz4AlSYLWltkdSAiww=;
        h=From:To:Cc:Subject:Date:From;
        b=IyzO9g81bAStx/ueju/e4edZHwpujMPLj9tMe7O84OXLnWjRFEw//eBM6A5MAiIce
         WrGuj7WbbBohyJue/VCpAbu8vWgqF/g9pO9FOMGJUhl+PRZdHM7YZD/Av6X/X4svV3
         O6PsCgzK2f+Wn1XpfAQ1vlRtt/75YpNJ/JggAlUu6pmSwL8hqke8yBI+9dxlrkAR24
         attYZzHqZmlm8Y/2VmlOgI/vvbgA/45lpHlsdN9V4NDhXdSLGYo50JNaKldQSVT7jt
         2s/37z7W9PAK0ECAMXxoR90X9gtk98TuOO0tAPIq50EcLtWfx+IO67f0mO6fhKSdrq
         xGXhTGlzFexlg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next] mlx5 net-next 2021-06-22
Date:   Tue, 22 Jun 2021 15:43:00 -0700
Message-Id: <20210622224300.498116-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series includes only commits that been already reviewed on netdev
ML, hence this pr is not followed by the patches to avoid noise.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit ef2c3ddaa4ed0b1d9de34378d08d3e24a3fec7ac:

  ibmvnic: Use strscpy() instead of strncpy() (2021-06-21 14:52:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-net-next-2021-06-22

for you to fetch changes up to f1267798c9809283ff45664bc2c4e465f1500a4b:

  net/mlx5: Fix checksum issue of VXLAN and IPsec crypto offload (2021-06-22 15:24:35 -0700)

----------------------------------------------------------------
mlx5-net-next-2021-06-22

1) Various minor cleanups and fixes from net-next branch
2) Optimize mlx5 feature check on tx and
   a fix to allow Vxlan with Ipsec offloads

----------------------------------------------------------------
Colin Ian King (1):
      net/mlx5: Fix spelling mistake "enught" -> "enough"

Huy Nguyen (3):
      net/mlx5: Optimize mlx5e_feature_checks for non IPsec packet
      net/xfrm: Add inner_ipproto into sec_path
      net/mlx5: Fix checksum issue of VXLAN and IPsec crypto offload

Jiapeng Chong (1):
      net/mlx5: Fix missing error code in mlx5_init_fs()

Nathan Chancellor (1):
      net/mlx5: Use cpumask_available() in mlx5_eq_create_generic()

caihuoqing (1):
      net/mlx5: remove "default n" from Kconfig

 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |  9 ---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       | 65 ++++++++++++++++------
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       | 37 +++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  8 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |  2 +-
 include/net/xfrm.h                                 |  1 +
 net/xfrm/xfrm_output.c                             | 41 +++++++++++++-
 9 files changed, 130 insertions(+), 40 deletions(-)
