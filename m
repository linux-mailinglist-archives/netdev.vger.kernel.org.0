Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B63028C4DB
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 00:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390391AbgJLWmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 18:42:12 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9850 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbgJLWmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 18:42:12 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f84db510001>; Mon, 12 Oct 2020 15:40:17 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Oct
 2020 22:42:11 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [pull request][net-next 0/4] mlx5 updates 2020-10-12
Date:   Mon, 12 Oct 2020 15:41:48 -0700
Message-ID: <20201012224152.191479-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602542417; bh=7L8/zApy8QlNyP78AWLhFi9tuwByYEEa38jSgsRqWtY=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=UwhE4oMBv0WDNEe6bBTwEIKs0BkCJxT4jqTEl/cGAoUoxuKJJpv8g/YIDRNQ6tx6R
         gkKdYj7a+Mc6QC1fDNzIMTn8rX0L6vCxfYJtcr8o9aXMY9f9XQvZrTrp1Dn2M2w25g
         /KTTQE7x/+zptCo1KWcGoVbdFL3FUztmOxOmLmJB+HVsd9CiBPzq9sIs+4SjdPN/BN
         skL0y1IQtJKxSwb51xA+7DvLs+Nt45yypj0KdTaNIhMMPnPjgLHAUhal0J/w0WsxFG
         jai8B9Ozmt8pwGfZIqFEonaq7o464hjW9OtiWqmV1ka/BAU5H4lO7V0Kz4GV03FOn7
         dejlyzOai/KtQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

This small series add xfrm IPSec TX offload support to mlx5 driver.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 547848af58e3eb5a0d8b0a5e6433042f111788e2=
:

  Merge branch 'bnxt_en-Updates-for-net-next' (2020-10-12 14:42:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2020-10-12

for you to fetch changes up to 5be019040cb7bab4caf152cacadffee91a78b506:

  net/mlx5e: IPsec: Add Connect-X IPsec Tx data path offload (2020-10-12 15=
:37:45 -0700)

----------------------------------------------------------------
mlx5-updates-2020-10-12

Updates to mlx5 driver:
- Cleanup fix of uininitialized pointer read
- xfrm IPSec TX offload

----------------------------------------------------------------
Colin Ian King (1):
      net/mlx5: Fix uininitialized pointer read on pointer attr

Huy Nguyen (2):
      net/mlx5: Add NIC TX domain namespace
      net/mlx5e: IPsec: Add TX steering rule per IPsec state

Raed Salem (1):
      net/mlx5e: IPsec: Add Connect-X IPsec Tx data path offload

 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   1 +
 .../mellanox/mlx5/core/en_accel/en_accel.h         |  46 +++++-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   3 +
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |   2 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         | 178 +++++++++++++++++=
+++-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       | 110 +++++++++++--
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |  29 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  43 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  19 ++-
 include/linux/mlx5/fs.h                            |   1 +
 include/linux/mlx5/qp.h                            |   6 +-
 13 files changed, 406 insertions(+), 36 deletions(-)
