Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5422A4FE3
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbgKCTTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:19:00 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7003 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729248AbgKCTS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:18:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1ad260001>; Tue, 03 Nov 2020 11:19:02 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:18:58 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [pull request][net 0/9] mlx5 fixes 2020-11-03
Date:   Tue, 3 Nov 2020 11:18:21 -0800
Message-ID: <20201103191830.60151-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604431142; bh=OvCqNQOkmg4cfeanuVOkAdExhKuu0b7RNt5OAvFaDYw=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=WTzWWvwBuef4JhEpkid8EBXl8hPqdbJbslrM5rL9745PFgCn1yxgBuwr2FA+LGLW3
         5ANyatiW9/aBsAtZvUxRWiOMmYTJ1VzEa0yOZGz3Pclny5HKWQsxq0dR2dE6JKHmyE
         cGjaNUZBcYl8Fhepp+fzRfo/gsoTOJnGDfSrIL9mwEYK6RzTNertHvU0nz6fUm9I20
         iaazDV/rWhbbyqiy6dT5TWpUw4eSnaubOBGZikPKgjTLGelMf8QrRpbsWRg71OhOMD
         GjCKv1IQyLqDis/laSEU5rboOpu8jRA9IDJ63nD6lVIWk1wkxOAMpDxBRwu3A3vo7t
         2RW8PLcFvpKYA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

This series introduces some fixes to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

For -stable v5.1
 ('net/mlx5: Fix deletion of duplicate rules')

For -stable v5.4
 ('net/mlx5e: Fix modify header actions memory leak')

For -stable v5.8
 ('net/mlx5e: Protect encap route dev from concurrent release')

For -stable v5.9
 ('net/mlx5e: Fix VXLAN synchronization after function reload')
 ('net/mlx5e: Fix refcount leak on kTLS RX resync')
 ('net/mlx5e: Use spin_lock_bh for async_icosq_lock')
 ('net/mlx5e: Fix incorrect access of RCU-protected xdp_prog')
 ('net/mlx5: E-switch, Avoid extack error log for disabled vport')

Thanks,
Saeed.

---
The following changes since commit 9621618130bf7e83635367c13b9a6ee53935bb37=
:

  sfp: Fix error handing in sfp_probe() (2020-11-02 17:19:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2020-11-03

for you to fetch changes up to 9166a02a7b1c21de2155c91e3b69c805e2448267:

  net/mlx5e: Fix incorrect access of RCU-protected xdp_prog (2020-11-03 11:=
11:53 -0800)

----------------------------------------------------------------
mlx5-fixes-2020-11-03

----------------------------------------------------------------
Aya Levin (1):
      net/mlx5e: Fix VXLAN synchronization after function reload

Jianbo Liu (1):
      net/mlx5e: E-Switch, Offload all chain 0 priorities when modify heade=
r and forward action is not supported

Maor Dickman (1):
      net/mlx5e: Fix modify header actions memory leak

Maor Gottlieb (1):
      net/mlx5: Fix deletion of duplicate rules

Maxim Mikityanskiy (3):
      net/mlx5e: Use spin_lock_bh for async_icosq_lock
      net/mlx5e: Fix refcount leak on kTLS RX resync
      net/mlx5e: Fix incorrect access of RCU-protected xdp_prog

Parav Pandit (1):
      net/mlx5: E-switch, Avoid extack error log for disabled vport

Vlad Buslov (1):
      net/mlx5e: Protect encap route dev from concurrent release

 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  6 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    | 72 ++++++++++++++----=
----
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |  4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 27 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  8 +--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  2 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  7 ++-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |  3 -
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.c    | 23 +++++--
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.h    |  2 +
 14 files changed, 98 insertions(+), 65 deletions(-)
