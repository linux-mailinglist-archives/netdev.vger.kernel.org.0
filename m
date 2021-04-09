Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E67F35A796
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 22:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbhDIUHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 16:07:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233527AbhDIUHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 16:07:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D4F761108;
        Fri,  9 Apr 2021 20:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617998836;
        bh=uxMzNT1vhL2iwaA0zwbp8jMw72R+KTpZgO7i2hDjgZE=;
        h=From:To:Cc:Subject:Date:From;
        b=kAxg4ZjDhxgWOAvjV9FgphkMXaysISZeAz+xHtsWnboyKogSIhRbzB/JHvZRUlE+w
         aMCDYXc1ylCDJ+MMsSXjpWa+JPOWb+SBEKt9PShsmdNUGl3C1HpiIGSCfdX61zusnj
         sve1AbIWMvmaAnbiZkOTcCyfPuCmFP1DaYQk+k30Y5N2LMX9+EcldkIke7iw6YK5ce
         Z8CRtVQflmRdt5GBre4ONASPN14HN+L82bmH+8ApgLY1FJOsfIobnZA1db3yDcRtxM
         l8ZR+KzyCFyuoelas4gWdrmI2EM2BPnRUSI0o15TeeyW/qtgGdZ7Bx7gBqWh8FNW2a
         QxQoi0jvx2blA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [pull-request][net-next][rdma-next] mlx5-next 2021-04-09
Date:   Fri,  9 Apr 2021 13:07:04 -0700
Message-Id: <20210409200704.10886-1-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub, Jason,

This pr contains changes from  mlx5-next branch,
already reviewed on netdev and rdma mailing lists, links below.

1) From Leon, Dynamically assign MSI-X vectors count
Already Acked by Bjorn Helgaas.
https://patchwork.kernel.org/project/netdevbpf/cover/20210314124256.70253-1-leon@kernel.org/

2) Cleanup series:
https://patchwork.kernel.org/project/netdevbpf/cover/20210311070915.321814-1-saeed@kernel.org/

From Mark, E-Switch cleanups and refactoring, and the addition 
of single FDB mode needed HW bits.

From Mikhael, Remove unused struct field

From Saeed, Cleanup W=1 prototype warning 

From Zheng, Esw related cleanup

From Tariq, User order-0 page allocation for EQs

Please pull and let me if there's any issue.

Thanks,
Saeed.

---

The following changes since commit a38fd8748464831584a19438cbb3082b5a2dab15:

  Linux 5.12-rc2 (2021-03-05 17:33:41 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next

for you to fetch changes up to e71b75f73763d88665b3a19c5a4d52d559aa7732:

  net/mlx5: Implement sriov_get_vf_total_msix/count() callbacks (2021-04-04 10:30:38 +0300)

----------------------------------------------------------------
Leon Romanovsky (4):
      PCI/IOV: Add sysfs MSI-X vector assignment interface
      net/mlx5: Add dynamic MSI-X capabilities bits
      net/mlx5: Dynamically assign MSI-X vectors count
      net/mlx5: Implement sriov_get_vf_total_msix/count() callbacks

Mark Bloch (5):
      net/mlx5: E-Switch, Add match on vhca id to default send rules
      net/mlx5: E-Switch, Add eswitch pointer to each representor
      RDMA/mlx5: Use representor E-Switch when getting netdev and metadata
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

 Documentation/ABI/testing/sysfs-bus-pci            |  29 ++++++
 drivers/infiniband/hw/mlx5/fs.c                    |   2 +-
 drivers/infiniband/hw/mlx5/ib_rep.c                |   5 +-
 drivers/infiniband/hw/mlx5/main.c                  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en/health.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  27 +++---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  34 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h   |  15 ++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   6 ++
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  12 +++
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |  73 +++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |  48 +++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/wq.c       |   5 -
 drivers/pci/iov.c                                  | 102 +++++++++++++++++++--
 drivers/pci/pci-sysfs.c                            |   3 +-
 drivers/pci/pci.h                                  |   3 +-
 include/linux/mlx5/driver.h                        |   6 +-
 include/linux/mlx5/eswitch.h                       |   5 +-
 include/linux/mlx5/mlx5_ifc.h                      |  32 +++++--
 include/linux/pci.h                                |   8 ++
 22 files changed, 363 insertions(+), 62 deletions(-)
