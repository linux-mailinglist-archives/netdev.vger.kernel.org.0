Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367854143C2
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 10:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhIVIa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 04:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233349AbhIVIa0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 04:30:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D606461100;
        Wed, 22 Sep 2021 08:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632299336;
        bh=eniBOaVikcYR0yncdShWM0iESsHAaLW49bxHbWlKMmU=;
        h=From:To:Cc:Subject:Date:From;
        b=A/hwgpGjVJV4n0kSuX840O/p+IGzCekgSTuOpR5XHXjjiaJPAogwBSuYFy4Atvf21
         JeXPyuy4iDr3fKxak8SNOsuPY3ij0FmwoRqGYxjAe48QrnmwBxrtCfVvy/tXiIkmE+
         XOv3rD2MP/FWTlscLZXhcqQpATbIuTzXkLRML9z4fcnusZss+Mk2mWUQFwI3WoqgaL
         ue0lkqUg0CKcZWaovAy+fFo7RRvSP53ueXp+HAwrepw3xi2Lubv3engBEWVzlSwTSS
         12e6ywfSlFIlUAoAPHV1AICWS2b+VdXAz1Il8emkQrxVgHGZ3nXs13ey6LbDGisWTr
         VeodOgl7erARw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Meir Lichtinger <meirl@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH rdma-next v1 0/2] Extend UAR to have DevX UID
Date:   Wed, 22 Sep 2021 11:28:49 +0300
Message-Id: <cover.1632299184.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v1:
 * Renamed functions and unexport mlx5_core uar calls.
v0: https://lore.kernel.org/all/cover.1631660943.git.leonro@nvidia.com
----------------------------------------------------------------------

Hi,

This is short series from Meir that adds DevX UID to the UAR.

Thanks

Meir Lichtinger (2):
  net/mlx5: Add uid field to UAR allocation structures
  IB/mlx5: Enable UAR to have DevX UID

 drivers/infiniband/hw/mlx5/cmd.c              | 26 +++++++++
 drivers/infiniband/hw/mlx5/cmd.h              |  2 +
 drivers/infiniband/hw/mlx5/main.c             | 55 +++++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/uar.c | 14 ++---
 include/linux/mlx5/driver.h                   |  2 -
 include/linux/mlx5/mlx5_ifc.h                 |  4 +-
 6 files changed, 68 insertions(+), 35 deletions(-)

-- 
2.31.1

