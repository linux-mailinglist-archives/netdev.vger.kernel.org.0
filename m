Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8BD3635B5
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 15:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbhDRNuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 09:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229986AbhDRNuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Apr 2021 09:50:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97DF961057;
        Sun, 18 Apr 2021 13:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618753787;
        bh=08CIHSCnPTg7cBN2e2AJ3/qsOgJuRrTNIcI0vWUr04g=;
        h=From:To:Cc:Subject:Date:From;
        b=dN6rfgkluLgtKcPByNvfsygEYa/V0oPL+yv4bfCaxSCU3UnMHRMikV+/WJ84S+wQD
         nbiwBYMUDeIhy+lwwSedpmafH0sz0WGFwv0ElcGO5/TZUbmJvj42D+c8B/xPZwFSPy
         STSc+IvbUt6Aql3HjiUwcCMvWfvnd37+10uvrR0OddRADd6TgP4LfZhlMDx5WNtbkP
         23fPCx7kozrKM4UBsGkxC6z3+SPa2iLqNAlRdLyUQwckv0Z9TueQd9aCQY+1dPJkRk
         iw3IcjfBv/1aFKmNuU2mHPk5Vhvp09EzfEbK8XcBlE+WgFFoyedyz3U6RO/Y/ZOb/7
         pOwu5qevp914w==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next 0/2] Two fixes to -next
Date:   Sun, 18 Apr 2021 16:49:38 +0300
Message-Id: <cover.1618753425.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The two fixes are targeted to the -next. Maor's change fixes DM code
that was accepted in this cycle and Parav's change doesn't qualify
urgency of -rc8.

Thanks

Maor Gottlieb (1):
  RDMA/mlx5: Fix type assignment for ICM DM

Parav Pandit (1):
  IB/mlx5: Set right RoCE l3 type and roce version while deleting GID

 drivers/infiniband/hw/mlx5/dm.c               | 23 +++++++++++--------
 drivers/infiniband/hw/mlx5/main.c             |  8 +++----
 .../net/ethernet/mellanox/mlx5/core/lib/gid.c |  4 ++--
 3 files changed, 19 insertions(+), 16 deletions(-)

-- 
2.30.2

