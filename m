Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4318447610E
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 19:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343993AbhLOSty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 13:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239049AbhLOSty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 13:49:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A8EC061574;
        Wed, 15 Dec 2021 10:49:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB84CB820E0;
        Wed, 15 Dec 2021 18:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3B3C36AE2;
        Wed, 15 Dec 2021 18:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639594191;
        bh=6Un467KeQkKW+BO4ptVLniQHArMmndAWZ0Jb/gb0EVg=;
        h=From:To:Cc:Subject:Date:From;
        b=eXIde3VCErkqRQnCK0sp3gfaza+/k+chSuBwVsqCEaFqKKyQg9F1KHFgaYQUxVzKL
         bPpKD0SndzEiANoZk8h0tmobp2dxyRSb4qOWl6EF/QgjWkC5OVDeD8yScGpzqIWQ6O
         XbNpmPEmM1yWNLC3iVRK+wHqu+fg9xpujMBeKP/b8Rp+hDp/JHghABwKFV368OKDt/
         ijqKGGFr5Y1hT4rNKdeMpY9U/njmODE5skfy9XengqeCfBC4Z7PeZ8aUe84vSr+kLk
         vhLtQFSc9uOov+BPqtUfOqkOsWTUQGIiq9EuYv7bmWqHwbVn52eMO7M3Fyc3jAb9rs
         P24MOhc6mnpfA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull-request] mlx5-next branch 2021-12-15
Date:   Wed, 15 Dec 2021 10:49:45 -0800
Message-Id: <20211215184945.185708-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub, Jason

This pulls mlx5-next branch into net-next and rdma branches.
All patches already reviewed on both rdma and netdev mailing lists.

Please pull and let me know if there's any problem.

1) Add multiple FDB steering priorities [1]
2) Introduce HW bits needed to configure MAC list size of VF/SF.
   Required for ("net/mlx5: Memory optimizations") upcoming series [2].

[1] https://lore.kernel.org/netdev/20211201193621.9129-1-saeed@kernel.org/
[2] https://lore.kernel.org/lkml/20211208141722.13646-1-shayd@nvidia.com/

Thanks,
Saeed.

The following changes since commit fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf:

  Linux 5.16-rc1 (2021-11-14 13:56:52 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next

for you to fetch changes up to 685b1afd7911676691c4167f420e16a957f5a38e:

  net/mlx5: Introduce log_max_current_uc_list_wr_supported bit (2021-12-15 10:21:50 -0800)

----------------------------------------------------------------
Maor Gottlieb (4):
      net/mlx5: Separate FDB namespace
      net/mlx5: Refactor mlx5_get_flow_namespace
      net/mlx5: Create more priorities for FDB bypass namespace
      RDMA/mlx5: Add support to multiple priorities for FDB rules

Shay Drory (1):
      net/mlx5: Introduce log_max_current_uc_list_wr_supported bit

 drivers/infiniband/hw/mlx5/fs.c                   | 18 +++++++++---------
 drivers/infiniband/hw/mlx5/mlx5_ib.h              |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------
 include/linux/mlx5/fs.h                           |  1 +
 include/linux/mlx5/mlx5_ifc.h                     |  2 +-
 6 files changed, 76 insertions(+), 28 deletions(-)

