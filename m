Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829BD305179
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238809AbhA0E3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:29:12 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11316 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389816AbhA0AJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 19:09:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a97e0000>; Tue, 26 Jan 2021 15:45:02 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:45:01 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/12] mlx5 fixes 2021-01-26
Date:   Tue, 26 Jan 2021 15:43:33 -0800
Message-ID: <20210126234345.202096-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611704702; bh=Q/3alJq5DeLHVYdMUVs00/4jhEMlDgcIHR/8g+/pQSI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=YvfPIqX2NatCxQXrdwjVhd5fRXnkminHWO2nfLMPp6UjnJKOmfEibd5CvFsXUryB5
         XMwPwcUWkKnkYTbEY5kIdIaroHS1QIUM6Sa3FGXVFjuRN4SykY8tEjP1PfkMUzesUx
         PhrQKxTcHPxAmm7MEUHGJDhQ/tPdUtBPbM8ayZNOSWfBljXbdnYeqI6w2Vb7CZN/Fd
         qbig1SssiE0J3Av0YVqjKhj+5d6IiNAGLZGnclsgMoY4XcZfoZXVXODA3WsUorDL3M
         pRyfmRguMGZAkde7B1c7WEXIU+/EZL1/tiulkb24SmSnxJBJazzKgXea1dnLgDM/gE
         w32/d0G6agRHA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, Dave

This series introduces some fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit c5e9e8d48acdf3b863282af7f6f6931d39526245=
:

  Merge tag 'mac80211-for-net-2021-01-26' of git://git.kernel.org/pub/scm/l=
inux/kernel/git/jberg/mac80211 (2021-01-26 15:23:18 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2021-01-26

for you to fetch changes up to e2194a1744e8594e82a861687808c1adca419b85:

  net/mlx5: CT: Fix incorrect removal of tuple_nat_node from nat rhashtable=
 (2021-01-26 15:39:04 -0800)

----------------------------------------------------------------
mlx5-fixes-2021-01-26

----------------------------------------------------------------
Daniel Jurgens (1):
      net/mlx5: Maintain separate page trees for ECPF and PF functions

Maor Dickman (2):
      net/mlx5e: Reduce tc unsupported key print level
      net/mlx5e: Disable hw-tc-offload when MLX5_CLS_ACT config is disabled

Maxim Mikityanskiy (4):
      net/mlx5e: Fix IPSEC stats
      net/mlx5e: Correctly handle changing the number of queues when the in=
terface is down
      net/mlx5e: Revert parameters on errors when changing trust state with=
out reset
      net/mlx5e: Revert parameters on errors when changing MTU and LRO stat=
e without reset

Pan Bian (1):
      net/mlx5e: free page before return

Parav Pandit (1):
      net/mlx5e: E-switch, Fix rate calculation for overflow

Paul Blakey (2):
      net/mlx5e: Fix CT rule + encap slow path offload and deletion
      net/mlx5: CT: Fix incorrect removal of tuple_nat_node from nat rhasht=
able

Roi Dayan (1):
      net/mlx5: Fix memory leak on flow table creation error flow

 .../net/ethernet/mellanox/mlx5/core/en/health.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 20 +++++---
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c      |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 13 +++--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  8 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 39 +++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 22 ++++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  1 +
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 58 +++++++++++++-----=
----
 10 files changed, 114 insertions(+), 55 deletions(-)
