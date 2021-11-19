Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6766457774
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 20:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235275AbhKSUBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:01:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:49804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234500AbhKSUBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 15:01:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6958661B27;
        Fri, 19 Nov 2021 19:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637351898;
        bh=d/OrXAwCT0sXA/KObxFeEo8HVTg14heB83sLx5/GHuE=;
        h=From:To:Cc:Subject:Date:From;
        b=hUYsscSIzUCDaFNZJe1iNUMl05rQGZp0VVDfBiBZmRXIgg8TjC5mGTcx69bPmVtOz
         BdLc3XT3ALRNHKTUuZ0/xAY0fY7u2F8jTDzoJHkM19FyBKH4qyh9Ck7U3xLK7qmJCN
         e5RYgV9h4JYnPJ0dWY2yvGRkl1zyee1c19ci9txXNo7e5cbvyd2zU0zwZTELK3aypK
         zoBhXpEl7EkAg6GnngG0qXIqUScj947GCdlGc9mOCdKmrRkbGOSypKRG/RtT12TVR0
         qs8fGDuSfNGYnTy9m4U6im8+w5GPlEe5YAJZd3oNZvUCSp3kIGZ0t2mpI4akKy7DRE
         UU4fV8zVGspSQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/10] mlx5 fixes 2021-11-19
Date:   Fri, 19 Nov 2021 11:58:03 -0800
Message-Id: <20211119195813.739586-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series provides fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 0f296e782f21dc1c55475a3c107ac68ab09cc1cf:

  stmmac_pci: Fix underflow size in stmmac_rx (2021-11-19 11:54:34 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-11-19

for you to fetch changes up to 1534b2c9592a0858eaa20f351560b4764f630204:

  net/mlx5e: Do synchronize_net only once when deactivating channels (2021-11-19 11:57:07 -0800)

----------------------------------------------------------------
mlx5-fixes-2021-11-19

----------------------------------------------------------------
Aya Levin (1):
      net/mlx5: Fix access to a non-supported register

Ben Ben-Ishay (1):
      net/mlx5e: SHAMPO, Fix constant expression result

Dmytro Linkin (1):
      net/mlx5: E-switch, Respect BW share of the new group

Gal Pressman (1):
      net/mlx5: Fix too early queueing of log timestamp work

Lama Kayal (1):
      net/mlx5e: Do synchronize_net only once when deactivating channels

Mark Bloch (1):
      net/mlx5: E-Switch, fix single FDB creation on BlueField

Maxim Mikityanskiy (1):
      net/mlx5e: Add activate/deactivate stage to XDPSQ

Raed Salem (2):
      net/mlx5e: IPsec: Fix Software parser inner l3 type setting in case of encapsulation
      net/mlx5e: Fix missing IPsec statistics on uplink representor

Saeed Mahameed (1):
      net/mlx5e: Call synchronize_net outside of deactivating a queue

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   | 30 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |  6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   | 30 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h   |  2 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |  3 +
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.c  |  2 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  4 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 98 ++++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  4 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  8 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |  2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  8 +-
 include/linux/mlx5/mlx5_ifc.h                      |  5 +-
 18 files changed, 151 insertions(+), 70 deletions(-)
