Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BD32CCE05
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgLCElM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:41:12 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18712 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbgLCElL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 23:41:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc86c3f0000>; Wed, 02 Dec 2020 20:40:31 -0800
Received: from sx1.vdiclient.nvidia.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 04:40:31 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [pull request][net 0/4] mlx5 fixes 2020-12-01
Date:   Wed, 2 Dec 2020 20:39:42 -0800
Message-ID: <20201203043946.235385-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606970431; bh=1/eroiqB/x+MqmRzqfs1xNK2lTOikLpd3qPHq0gtrrg=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=WyVMlYhbG6SSpR0XZB8lsd/SKkGA0JoW3FcFSv8N5uBItAYDeL9Hfj0YKf2ztSAf2
         4rAxdiEBFfco/plMB1sIiRnDID6kFjZVV5mzvO3+qJqDBPhqOdiiXZIrzSnR3kbBKN
         /PGsCDXfZRo4bzRafeHNVIgBCEQZKaRwaWmQRMML1sG3fIoKe1naHa5c/vXEzrogHD
         waokNlv1YzQzQkQTjDFGwu9TAH3UD0rPSkao38Zb8gglu+yVmtrUGFDEnXxeXKZ5Cj
         6QnM5j8ZNJXeix5L8lTXRsuaKr7xBDauYHK8fYpvLUV/dTbmqpZ28YCganlCs0CUIP
         UnJUMZbp+kGGg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

This series introduces some fixes to mlx5 driver.
Please pull and let me know if there is any problem.

For the DR steering patch I will need it in net-next as well, I would
appreciate it if you will take this small series before your pr to linus.

For -stable v5.4:
 ('net/mlx5: DR, Proper handling of unsupported Connect-X6DX SW steering')

For -stable v5.8
 ('net/mlx5: Fix wrong address reclaim when command interface is down')

For -stable v5.9
 ('net: mlx5e: fix fs_tcp.c build when IPV6 is not enabled')

Thanks,
Saeed.

---
The following changes since commit 14483cbf040fcb38113497161088a1ce8ce5d713=
:

  net: broadcom CNIC: requires MMU (2020-12-01 11:44:02 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2020-12-01

for you to fetch changes up to c20289e64bfc0fc4bca0242d60839b9ca2e28e64:

  net/mlx5: DR, Proper handling of unsupported Connect-X6DX SW steering (20=
20-12-01 15:02:59 -0800)

----------------------------------------------------------------
mlx5-fixes-2020-12-01

----------------------------------------------------------------
Eran Ben Elisha (1):
      net/mlx5: Fix wrong address reclaim when command interface is down

Randy Dunlap (1):
      net: mlx5e: fix fs_tcp.c build when IPV6 is not enabled

Tariq Toukan (1):
      net/mlx5e: kTLS, Enforce HW TX csum offload with kTLS

Yevgeny Kliteynik (1):
      net/mlx5: DR, Proper handling of unsupported Connect-X6DX SW steering

 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  |  2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    | 22 +++++++++++++++---=
----
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 21 ++++++++++++++++++=
+--
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |  1 +
 .../mellanox/mlx5/core/steering/dr_domain.c        |  5 +++++
 .../mellanox/mlx5/core/steering/dr_types.h         |  1 +
 include/linux/mlx5/mlx5_ifc.h                      |  9 ++++++++-
 7 files changed, 51 insertions(+), 10 deletions(-)
