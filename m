Return-Path: <netdev+bounces-3972-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBB40709E9B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:56:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE04E1C21266
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:56:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95C712B71;
	Fri, 19 May 2023 17:56:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B2D125CC
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9422FC433EF;
	Fri, 19 May 2023 17:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684518969;
	bh=QloEFSCgTpoXrcEOYgTqfiD0q6CO5KehJR71Ns60+WQ=;
	h=From:To:Cc:Subject:Date:From;
	b=nbDWCIQ3YWZqjLmDcKy/jpiyVf3ZigYI5mCmSFH6LU/crX5u8GP6sJBICzgRUP0s2
	 sGioL2gsdhVvX+klQYB19GGQhFZd1D828qsVE5BO2LdUpjDTDAaRRAbXnrCrxdlAUX
	 aXVU1JR8pLVowLxsnZQbQA4J1mcRImMK4v1qL48SjVSz6X7NWs35gCfk+UO1ZRXuxH
	 jaRpMSxl60aoaQ66Tvg9pf0X/WReJfBXZXVBOlZZJvm5R5J9zzOLjn90zKkUH7ugGd
	 7e7bF8dygNeIOQt6Ez7jJuMw52TSu7F2CTW0ZjEyVtViKLGLJlXDkS3KdqNpTdSGd2
	 9Ybi2/p8fiWdg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2023-05-19
Date: Fri, 19 May 2023 10:55:42 -0700
Message-Id: <20230519175557.15683-1-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Saeed Mahameed <saeedm@nvidia.com>

This series provides misc updates to mlx5 driver.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 20d5e0ef252a151ea6585cfccf32def81a624666:

  net: arc: Make arc_emac_remove() return void (2023-05-19 13:33:28 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-05-19

for you to fetch changes up to f5d87b47a1d9dc14c048c84935397d97833ac706:

  net/mlx5e: E-Switch, Initialize E-Switch for eswitch manager (2023-05-19 10:50:31 -0700)

----------------------------------------------------------------
mlx5-updates-2023-05-19

mlx5 misc changes and code clean up:

The following series contains general changes for improving
E-Switch driver behavior.

1) improving condition checking
2) Code clean up
3) Using metadata matching on send-to-vport rules.
4) Using RoCE v2 instead of v1 for loopback rules.

----------------------------------------------------------------
Roi Dayan (15):
      net/mlx5: Remove redundant esw multiport validate function
      net/mlx5: E-Switch, Remove redundant check
      net/mlx5e: E-Switch, Remove flow_source check for metadata matching
      net/mlx5e: Remove redundant __func__ arg from fs_err() calls
      net/mlx5e: E-Switch, Update when to set other vport context
      net/mlx5e: E-Switch, Allow get vport api if esw exists
      net/mlx5e: E-Switch, Use metadata for vport matching in send-to-vport rules
      net/mlx5: Remove redundant vport_group_manager cap check
      net/mlx5e: E-Switch, Check device is PF when stopping esw offloads
      net/mlx5e: E-Switch: move debug print of adding mac to correct place
      net/mlx5e: E-Switch, Add a check that log_max_l2_table is valid
      net/mlx5: E-Switch, Use RoCE version 2 for loopback traffic
      net/mlx5: E-Switch, Use metadata matching for RoCE loopback rule
      net/mlx5: devlink, Only show PF related devlink warning when needed
      net/mlx5e: E-Switch, Initialize E-Switch for eswitch manager

 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  26 +-----
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  12 +--
 .../ethernet/mellanox/mlx5/core/esw/acl/helper.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  22 +++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   8 ++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 103 ++++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |  24 ++---
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |   4 -
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |   3 +-
 11 files changed, 108 insertions(+), 104 deletions(-)

