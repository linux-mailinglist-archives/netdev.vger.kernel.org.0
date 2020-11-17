Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01B02B6F9E
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbgKQUHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:07:39 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5771 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgKQUHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:07:38 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb42d810000>; Tue, 17 Nov 2020 12:07:29 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 20:07:38 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [pull request][net 0/9] mlx5 fixes 2020-11-17
Date:   Tue, 17 Nov 2020 11:56:53 -0800
Message-ID: <20201117195702.386113-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605643649; bh=vBg/K2QQmMM5ItT8+tIZDLIxg6jUlzSxUbMaoN+VPM8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Type:Content-Transfer-Encoding:X-Originating-IP:
         X-ClientProxiedBy;
        b=MIg6jJSv4W7G2T+oa9ot4ooeK9ywl/qTgGx9psyMHWJwwvGj9j5jRsEp3gfXvm5zg
         EA73tc7sOcRMivx2q7W6jjpic6na5X58D/tsrHBXXdVvZrqJW3sbFTaL/bDLX4wWnT
         Bg5x9k7IB6345wTViCMMcGGfrL//HZzHLFnDf02MYbE/bJuD6hbxHNIxr/vF/cs+pI
         Tmgucma6y1bO76kkloN5Nr8GvqTqyV0MJxkA5WxN4zK3iEQx+ntkCvtr1U/wQazGbQ
         VLRb0boDgVDgdhyDQEvNuJ4SsEejl8a0R0fz8EuipZcyc8aw5ll/FuYAqE68ezrRiD
         2lX7r54WE/Wzw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

This series introduces some fixes to mlx5 driver.
Please pull and let me know if there is any problem.

For -stable v4.14
 ('net/mlx5: Disable QoS when min_rates on all VFs are zero')

For -stable v4.20
 ('net/mlx5: Add handling of port type in rule deletion')

For -stable v5.5
 ('net/mlx5: Clear bw_share upon VF disable')

For -stable v5.7
 ('net/mlx5: E-Switch, Fail mlx5_esw_modify_vport_rate if qos disabled')

For -stable v5.8
 ('net/mlx5e: Fix check if netdev is bond slave')

For -stable v5.9
 ('net/mlx5e: Fix refcount leak on kTLS RX resync')

Thanks,
Saeed.

---
The following changes since commit 1b9e2a8c99a5c021041bfb2d512dc3ed92a94ffd=
:

  tcp: only postpone PROBE_RTT if RTT is < current min_rtt estimate (2020-1=
1-17 11:03:22 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2020-11-17

for you to fetch changes up to 68ec32daf7d50a9f7425f8607a7402c13aa0c587:

  net/mlx5: fix error return code in mlx5e_tc_nic_init() (2020-11-17 11:50:=
54 -0800)

----------------------------------------------------------------
mlx5-fixes-2020-11-17

----------------------------------------------------------------
Eli Cohen (1):
      net/mlx5: E-Switch, Fail mlx5_esw_modify_vport_rate if qos disabled

Huy Nguyen (2):
      net/mlx5e: Set IPsec WAs only in IP's non checksum partial case.
      net/mlx5e: Fix IPsec packet drop by mlx5e_tc_update_skb

Maor Dickman (1):
      net/mlx5e: Fix check if netdev is bond slave

Maxim Mikityanskiy (1):
      net/mlx5e: Fix refcount leak on kTLS RX resync

Michael Guralnik (1):
      net/mlx5: Add handling of port type in rule deletion

Vladyslav Tarasiuk (2):
      net/mlx5: Clear bw_share upon VF disable
      net/mlx5: Disable QoS when min_rates on all VFs are zero

Wang Hai (1):
      net/mlx5: fix error return code in mlx5e_tc_nic_init()

 .../net/ethernet/mellanox/mlx5/core/en/rep/bond.c    |  2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c  | 14 +++++++-------
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c         |  3 +--
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h         |  9 +++++----
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c   | 13 ++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      |  4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h      |  3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c      | 13 ++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c    | 20 +++++++++++++---=
----
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c    |  7 +++++++
 10 files changed, 54 insertions(+), 34 deletions(-)
