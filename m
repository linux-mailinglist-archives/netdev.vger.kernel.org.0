Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D2F2BB98E
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgKTXEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:04:07 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12657 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgKTXEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:04:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b690000>; Fri, 20 Nov 2020 15:04:09 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:03:55 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Subject: [PATCH mlx5-next 00/16] mlx5 next updates 2020-11-20
Date:   Fri, 20 Nov 2020 15:03:23 -0800
Message-ID: <20201120230339.651609-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605913449; bh=QxGRq9NZHuKs8nUtKjXeDD29HIQlu20aNKFp8YeH+H0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=UH3I+cp2oasLap9VmRNM47S0EE9CEUe/7DjYtZTQ+BoCp4lz2pmpKMJUKdt6CjWWX
         zy7DSfMesUqZprp9XMLHIsxhUE7/TwUlrDmDFpDTxhHzIVfl6kUec70T0l4fmwWf83
         i08VIa30nVyJrNgjD7p+rWYxEf2wsHhTjztYUv8/Yt3xZCGZe64FVzERFjzU/TrPMa
         x6Q9/+dTIGW+smyEGf3o6kSPEp7JeuwM6bsC+T+Tc7TnKsko2JnJAjMa+Ly5TQEP/J
         b34oo6YlmjGUVOYXFhl+wBNOiTm7xGmY9gXrhk6soc9zDAJdpN3TCVga36+tdKoYxz
         Dt0EvOcwaNgOw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series includes trivial updates to mlx5 next branch
1) HW definition for upcoming features
2) Include files and general Cleanups
3) Add the upcoming BlueField-3 device ID
4) Define flow steering priority for VDPA
5) Export missing steering API for ULPs,
   will be used later in VDPA driver, to create flow steering domain for
   VDPA queues.
6) ECPF (Embedded CPU Physical function) minor improvements for BlueField.

In case of no objection this series will be applied to mlx5-next, and sent
as a pull request to both net-next and rdma-next trees.

Thanks,
Saeed.

---

Aya Levin (1):
  net/mlx5: Expose IP-in-IP TX and RX capability bits

Chris Mi (2):
  net/mlx5: Add sample offload hardware bits and structures
  net/mlx5: Add sampler destination type

Eli Cohen (2):
  net/mlx5: Add VDPA priority to NIC RX namespace
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

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  3 -
 .../mellanox/mlx5/core/diag/fs_tracepoint.c   |  3 +
 .../net/ethernet/mellanox/mlx5/core/ecpf.c    | 76 ++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/ecpf.h    |  3 +
 .../mellanox/mlx5/core/esw/acl/helper.c       |  5 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 29 +++++-
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  | 57 ++++++-----
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 27 +++---
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 19 ++--
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  4 +
 .../ethernet/mellanox/mlx5/core/pagealloc.c   | 12 +--
 .../mellanox/mlx5/core/steering/dr_matcher.c  |  2 +-
 .../mellanox/mlx5/core/steering/dr_rule.c     |  3 +-
 .../mellanox/mlx5/core/steering/dr_types.h    |  1 +
 include/linux/mlx5/device.h                   |  8 ++
 include/linux/mlx5/driver.h                   |  8 +-
 include/linux/mlx5/fs.h                       |  7 +-
 include/linux/mlx5/mlx5_ifc.h                 | 94 +++++++++++++++++--
 include/uapi/rdma/mlx5_user_ioctl_cmds.h      |  2 +-
 20 files changed, 260 insertions(+), 105 deletions(-)

--=20
2.26.2

