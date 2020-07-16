Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A27C2220F4
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 12:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgGPKwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 06:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbgGPKwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 06:52:54 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 890C7206C1;
        Thu, 16 Jul 2020 10:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594896774;
        bh=i8x0d0qFhwM0yrlYZM3d9qIGgmWtCCc2Z4JJVituq7w=;
        h=From:To:Cc:Subject:Date:From;
        b=XbLHcR8tHCSBPZsAyPpVPIrJ71wRlQfH7x9TLi79qNwXM3KhGyAZ/IsWxSwL1yvir
         RJsiTRt20tRTafShQPIrH50epMN31auE3LAWSAWiNS8u86qcp+OFE8fJ7tnpWVlcYe
         /caGpNqIZ08yOX9kGnCyEYqRhZSed3BAQY944UGM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Meir Lichtinger <meirl@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH rdma-next 0/3] Create UMR with relaxed ordering
Date:   Thu, 16 Jul 2020 13:52:45 +0300
Message-Id: <20200716105248.1423452-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

ConnectX-7 supports setting relaxed ordering read/write mkey attribute by UMR,
indicated by new HCA capabilities, so extend mlx5_ib driver to configure
UMR control segment based on those capabilities.

Thanks

Meir Lichtinger (3):
  RDMA/mlx5: ConnectX-7 new capabilities to set relaxed ordering by UMR
  RDMA/mlx5: Use MLX5_SET macro instead of local structure
  RDMA/mlx5: Set mkey relaxed ordering by UMR with ConnectX-7

 drivers/infiniband/hw/mlx5/mlx5_ib.h | 18 +++-----
 drivers/infiniband/hw/mlx5/wr.c      | 68 ++++++++++++++++++++--------
 include/linux/mlx5/device.h          |  5 +-
 include/linux/mlx5/mlx5_ifc.h        |  4 +-
 4 files changed, 63 insertions(+), 32 deletions(-)

--
2.26.2

