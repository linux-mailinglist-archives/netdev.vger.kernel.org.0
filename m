Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8D3403039
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 23:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348361AbhIGVZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 17:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347975AbhIGVZe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 17:25:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB41E61090;
        Tue,  7 Sep 2021 21:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631049868;
        bh=WhpVSmwS7axE6DJDBNgzL8Rin1xnZapanqu4IDE5w4c=;
        h=From:To:Cc:Subject:Date:From;
        b=Nmz8xZc6JCLr1WiBU0b1QO2n7H39ga/u3JdoQSkwovFikxfDR6Qoi9zOI7M1bmqht
         CORnIPkTxF6jXXLdxm/are67bK/NRe0PeqWY0GZRAMyr60X85TS/IB4e7q6LikmSRQ
         C2/EtFkxPiVnOPA3V6ThEOj8XH63od0+p1JzCQtVjBdZF44maQ1G779L5oIusdl9x1
         wIUMkk6n3hL7mlN2maPW85GA4LOoo/xGHsJjXO4Cwwai460jGMchOkUJ5T7Mb8X4I8
         2Q02DAiRm6o63Dc67N8jbiFjQ9zUCKVfz6w7lo9y3we9dZwPPIRMFVB5McBV1V5sR+
         0zNKm1sUGmFhQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 0/7] mlx5 fixes 2021-09-07
Date:   Tue,  7 Sep 2021 14:24:13 -0700
Message-Id: <20210907212420.28529-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub, 

This series introduces some fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Included here, a patch which solves a build warning reported on
linux-kernel mailing list [1]:
Fix commit ("net/mlx5: Bridge, fix uninitialized variable usage")

I hope this series can make it to rc1.

[1] https://www.spinics.net/lists/netdev/msg765481.html

Thanks,
Saeed.

---
The following changes since commit 0f77f2defaf682eb7e7ef623168e49c74ae529e3:

  ieee802154: Remove redundant initialization of variable ret (2021-09-07 14:06:08 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-09-07

for you to fetch changes up to 8db6a54f3cae6a803b2cbf5390662bca641f7da8:

  net/mlx5e: Fix condition when retrieving PTP-rqn (2021-09-07 14:17:02 -0700)

----------------------------------------------------------------
mlx5-fixes-2021-09-07

----------------------------------------------------------------
Aya Levin (2):
      net/mlx5e: Fix mutual exclusion between CQE compression and HW TS
      net/mlx5e: Fix condition when retrieving PTP-rqn

Maor Gottlieb (1):
      net/mlx5: Fix potential sleeping in atomic context

Mark Bloch (1):
      net/mlx5: Lag, don't update lag if lag isn't supported

Parav Pandit (1):
      net/mlx5: Fix rdma aux device on devlink reload

Saeed Mahameed (1):
      net/mlx5: FWTrace, cancel work on alloc pd error flow

Vlad Buslov (1):
      net/mlx5: Bridge, fix uninitialized variable usage

 drivers/net/ethernet/mellanox/mlx5/core/devlink.c        |  7 ++-----
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en.h             |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c  |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c      |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c     | 11 ++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c        |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c        |  5 ++---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c            | 10 ++++++++--
 9 files changed, 26 insertions(+), 22 deletions(-)
