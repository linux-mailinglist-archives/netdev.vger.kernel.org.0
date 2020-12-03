Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DA72CCB71
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 02:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbgLCBLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 20:11:02 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2983 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgLCBLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 20:11:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc83afd0003>; Wed, 02 Dec 2020 17:10:21 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 01:10:21 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [pull request][net-next V2] mlx5 next 2020-12-02
Date:   Wed, 2 Dec 2020 17:10:10 -0800
Message-ID: <20201203011010.213440-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606957821; bh=p7GdQdhuDheR6T5dsE5mTuNAoTbHDxuN2Urrq15jwzk=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=onEsqmWyUecZWBvyEe3/Pytw++enev+LHyTTUXo9IrY6ILhGYhhf5kIlu4uZq6Uhq
         9th9IH7X36zmn6x6e9/2xUp4o4FPggw4v1Wj+oCcp4g5suJbu6vNCUQjhWPowyCqpe
         Wj7NvCFyVbi+WxQsaY5554YXSJDCkdcGzoD6aYsmRb7nANr5Qns2DHIZJGKLlb70GC
         0QLvOd9iznUVTS8LkT8/BIZq/UYTbhDCpK01aY/rNQIizyauN45aRoo2eu1jl3Cc5U
         4wjTmMyadEaxED2RqxqqvcUsxQo+i0CSPBoJY5ReWaX8M+Lj/XCFRGPMx07FiCnqz3
         +c3QXcyX6zKow==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

v1->v2: Use a proper tag for the pull request

This pull request includes [1] low level mlx5 updates required by both netd=
ev
and rdma trees, needed for upcoming mlx5 netdev submission.

Please pull and let me know if there's any problem.

[1] https://patchwork.kernel.org/project/linux-rdma/cover/20201120230339.65=
1609-1-saeedm@nvidia.com/

Thanks,
Saeed.

The following changes since commit 3650b228f83adda7e5ee532e2b90429c03f7b9ec=
:

  Linux 5.10-rc1 (2020-10-25 15:14:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git tags/mlx=
5-next-2020-12-02

for you to fetch changes up to 617b860c1875842d9cc3338d7dabd2b3538038f1:

  net/mlx5: Treat host PF vport as other (non eswitch manager) vport (2020-=
11-26 18:45:03 -0800)

----------------------------------------------------------------
mlx5-next-2020-12-02

Low level mlx5 updates required by both netdev and rdma trees:

  net/mlx5: Treat host PF vport as other (non eswitch manager) vport
  net/mlx5: Enable host PF HCA after eswitch is initialized
  net/mlx5: Rename peer_pf to host_pf
  net/mlx5: Make API mlx5_core_is_ecpf accept const pointer
  net/mlx5: Export steering related functions
  net/mlx5: Expose other function ifc bits
  net/mlx5: Expose IP-in-IP TX and RX capability bits
  net/mlx5: Update the hardware interface definition for vhca state
  net/mlx5: Update the list of the PCI supported devices
  net/mlx5: Avoid exposing driver internal command helpers
  net/mlx5: Add ts_cqe_to_dest_cqn related bits
  net/mlx5: Add misc4 to mlx5_ifc_fte_match_param_bits
  net/mlx5: Check dr mask size against mlx5_match_param size
  net/mlx5: Add sampler destination type
  net/mlx5: Add sample offload hardware bits and structures

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

----------------------------------------------------------------
Aya Levin (1):
      net/mlx5: Expose IP-in-IP TX and RX capability bits

Chris Mi (2):
      net/mlx5: Add sample offload hardware bits and structures
      net/mlx5: Add sampler destination type

Eli Cohen (1):
      net/mlx5: Export steering related functions

Eran Ben Elisha (1):
      net/mlx5: Add ts_cqe_to_dest_cqn related bits

Meir Lichtinger (1):
      net/mlx5: Update the list of the PCI supported devices

Muhammad Sammar (2):
      net/mlx5: Check dr mask size against mlx5_match_param size
      net/mlx5: Add misc4 to mlx5_ifc_fte_match_param_bits

Parav Pandit (6):
      net/mlx5: Avoid exposing driver internal command helpers
      net/mlx5: Update the hardware interface definition for vhca state
      net/mlx5: Make API mlx5_core_is_ecpf accept const pointer
      net/mlx5: Rename peer_pf to host_pf
      net/mlx5: Enable host PF HCA after eswitch is initialized
      net/mlx5: Treat host PF vport as other (non eswitch manager) vport

Yishai Hadas (1):
      net/mlx5: Expose other function ifc bits

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  3 -
 .../mellanox/mlx5/core/diag/fs_tracepoint.c        |  3 +
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c     | 76 ++++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.h     |  3 +
 .../ethernet/mellanox/mlx5/core/esw/acl/helper.c   |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 29 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   | 57 +++++++------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 17 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 19 ++---
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  4 +
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 12 +--
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  3 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |  1 +
 include/linux/mlx5/device.h                        |  8 ++
 include/linux/mlx5/driver.h                        |  8 +-
 include/linux/mlx5/fs.h                            |  6 +-
 include/linux/mlx5/mlx5_ifc.h                      | 94 ++++++++++++++++++=
++--
 include/uapi/rdma/mlx5_user_ioctl_cmds.h           |  2 +-
 20 files changed, 250 insertions(+), 104 deletions(-)
