Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50115336CE1
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhCKHJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:09:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:52322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231950AbhCKHJj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 02:09:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8173065015;
        Thu, 11 Mar 2021 07:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615446578;
        bh=hZc9q+zX7hfMZamiCC3QUWg/+TU7MMqJeenUVV+SIgg=;
        h=From:To:Subject:Date:From;
        b=j3fVTrxY53MVAt6Rq9HB8CKDnSM5IPtMcWxlVXzhCgUrZgsI1sZyBxi+G7sjp26IF
         nJZYr2j4ZcjUHb0mEKLhpyvzUVddTi6CR7RspKsyItvBsl7p76kbH32XoLqzeqeRhE
         HnfpoXy5od38cXrnVewy5vaxi2bsgJNn65LGTL+QySO32AnQ1T0/2NANj6zPgLddif
         4rZrKq0uQyyf110yS6l1D+5lbDvfo6pUYOROCiy65/Re63yc9d60tcx6H2uL/z9ufU
         lHXGm/dQF+1T/y5YIrpgVGRkneFSZpchibqLe2IKxs4eqwPADvQSpZwTiNwDzj3VWI
         ZVxokF5dPg1sw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH mlx5-next 0/9] mlx5 next updates 2021-03-10
Date:   Wed, 10 Mar 2021 23:09:06 -0800
Message-Id: <20210311070915.321814-1-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series is targeting mlx5-next shared tree for mlx5
netdev and rdma shared updates.

From Mark, E-Switch cleanups and refactoring, and the addition 
of single FDB mode needed HW bits.

From Mikhael, Remove unused struct field

From Saeed, Cleanup W=1 prototype warning 

From Zheng, Esw related cleanup

From Tariq, User order-0 page allocation for EQs

In case of no objections, this series will be applied to mlx5-next first
and then sent in one pull request to both netdev and rdma next trees.

Thanks,
Saeed

Mark Bloch (5):
  net/mlx5: E-Switch, Add match on vhca id to default send rules
  net/mlx5: E-Switch, Add eswitch pointer to each representor
  RDMA/mlx5: Use represntor E-Switch when getting netdev and metadata
  net/mlx5: E-Switch, Refactor send to vport to be more generic
  net/mlx5: Add IFC bits needed for single FDB mode

Mikhael Goikhman (1):
  net/mlx5: Remove unused mlx5_core_health member recover_work

Saeed Mahameed (1):
  net/mlx5: Cleanup prototype warning

Tariq Toukan (1):
  net/mlx5: Use order-0 allocations for EQs

Zheng Yongjun (1):
  net/mlx5: simplify the return expression of mlx5_esw_offloads_pair()

 drivers/infiniband/hw/mlx5/fs.c               |  2 +-
 drivers/infiniband/hw/mlx5/ib_rep.c           |  5 ++-
 drivers/infiniband/hw/mlx5/main.c             |  3 +-
 .../ethernet/mellanox/mlx5/core/en/health.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 27 +++++++++------
 .../mellanox/mlx5/core/eswitch_offloads.c     | 34 +++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/lag_mp.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  | 15 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/wq.c  |  5 ---
 include/linux/mlx5/driver.h                   |  6 +++-
 include/linux/mlx5/eswitch.h                  |  5 +--
 include/linux/mlx5/mlx5_ifc.h                 | 21 ++++++++----
 13 files changed, 79 insertions(+), 51 deletions(-)

-- 
2.29.2

