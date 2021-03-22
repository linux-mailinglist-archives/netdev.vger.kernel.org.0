Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EC33450AF
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbhCVUZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230404AbhCVUZd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:25:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F176361990;
        Mon, 22 Mar 2021 20:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616444733;
        bh=wwg0czpeNEOWYdkh5k3QGJ3f6qBVplC4QNvluSrwMj0=;
        h=From:To:Cc:Subject:Date:From;
        b=i3NjVU1JkonLcAQEVwZraZyZ74hO3hZDFBCRLTmXnHTrrxkMagAwFLQxke+VNfHd9
         J1H+E9xZRwFntdLq+j12Vd3IMWnB/8rotz/Tvt8oIx05WicH+zp3iQKmUNiEcoxbkg
         W2fExAimUpoXjP7ZV3CG4nJO40zLLzDlAIA+o9fxYPYYfs0B4OQi4CgQzYTZ97Lumq
         aipAAQXjzFZGsdTk8yuF4KtIJZ2izzmqS5/DkM65t9yFHHyXWD1F8G5Y4wmgywNAtU
         3fQ7I927i0uGe/++k35G8a1an88LdWc6xv2VQlVrLR+9CUPOv0flfFPb2PPTzeZ8qt
         XlSY1vRLrKc9A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 0/6] mlx5 fixes 2021-03-22
Date:   Mon, 22 Mar 2021 13:25:18 -0700
Message-Id: <20210322202524.68886-1-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub

This series introduces some fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 87d77e59d1ebc31850697341ab15ca013004b81b:

  docs: networking: Fix a typo (2021-03-20 19:02:42 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-03-22

for you to fetch changes up to 7c1ef1959b6fefe616ef3e7df832bf63dfbab9cf:

  net/mlx5: SF, do not use ecpu bit for vhca state processing (2021-03-22 13:16:41 -0700)

----------------------------------------------------------------
mlx5-fixes-2021-03-22

----------------------------------------------------------------
Alaa Hleihel (1):
      net/mlx5e: Allow to match on MPLS parameters only for MPLS over UDP

Aya Levin (1):
      net/mlx5e: Fix error path for ethtool set-priv-flag

Dima Chumak (1):
      net/mlx5e: Offload tuple rewrite for non-CT flows

Huy Nguyen (1):
      net/mlx5: Add back multicast stats for uplink representor

Maxim Mikityanskiy (1):
      net/mlx5e: Fix division by 0 in mlx5e_select_queue

Parav Pandit (1):
      net/mlx5: SF, do not use ecpu bit for vhca state processing

 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  6 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 12 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 54 +++++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.c   |  4 +-
 .../net/ethernet/mellanox/mlx5/core/sf/hw_table.c  |  8 ++--
 .../ethernet/mellanox/mlx5/core/sf/vhca_event.c    | 22 ++++-----
 .../ethernet/mellanox/mlx5/core/sf/vhca_event.h    |  7 ++-
 8 files changed, 79 insertions(+), 37 deletions(-)
