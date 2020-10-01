Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4D627F8AF
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 06:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgJAEdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 00:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbgJAEdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 00:33:15 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8EF821531;
        Thu,  1 Oct 2020 04:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601526794;
        bh=PrcAnbRfqcmVMjDuI3QIAc2B43lqun1H5zfPncpvACA=;
        h=From:To:Cc:Subject:Date:From;
        b=wAD4bLaGO17sPacXRxTFCdGtOmQskODjwtWRbH/gN1/8vjBM7cvXBkROT0EC30dw6
         8mnnuo4kROV8PSdNdoNODRtqq/YYXyB4vBHWd67VkWIK55fbuB1y9cinwphPe6wBIl
         RdXouOSODbavQ73K35WuUwl5bnDWDgdDOTj8mYR0=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2020-09-30
Date:   Wed, 30 Sep 2020 21:32:47 -0700
Message-Id: <20201001043302.48113-1-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

While the other Software steering buddy allocator series is being
debated, I thought it is fine to submit this series which provides
misc and small updates to mlx5 driver.

For more information please see tag log below.

This series doesn't conflict with the other ongoing mlx5 net and
net-next submissions.
Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit f2e834694b0d92187d889172da842e27829df371:

  Merge branch 'drop_monitor-Convert-to-use-devlink-tracepoint' (2020-09-30 18:01:27 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-09-30

for you to fetch changes up to ff7ea04ad579c1f5f5aed73d2d5dc13314d25c75:

  net/mlx5e: Fix potential null pointer dereference (2020-09-30 21:26:31 -0700)

----------------------------------------------------------------
mlx5-updates-2020-09-30

Updates and cleanups for mlx5 driver:

1) From Ariel, Dan Carpenter and Gostavo, Fixes to the previous
   mlx5 Connection track series.

2) From Yevgeny, trivial cleanups for Software steering

3) From Hamdan, Support for Flow source hint in software steering and
   E-Switch

4) From Parav and Sunil, Small and trivial E-Switch updates and
   cleanups in preparation for mlx5 Sub-functions support

----------------------------------------------------------------
Ariel Levkovich (1):
      net/mlx5: Fix dereference on pointer attr after null check

Dan Carpenter (1):
      net/mlx5e: Fix a use after free on error in mlx5_tc_ct_shared_counter_get()

Gustavo A. R. Silva (1):
      net/mlx5e: Fix potential null pointer dereference

Hamdan Igbaria (2):
      net/mlx5: DR, Add support for rule creation with flow source hint
      net/mlx5: E-Switch, Support flow source for local vport

Parav Pandit (4):
      net/mlx5: E-switch, Add helper to check egress ACL need
      net/mlx5: E-switch, Use helper function to load unload representor
      net/mlx5: E-switch, Move devlink eswitch ports closer to eswitch
      net/mlx5: Use dma device access helper

Yevgeny Kliteynik (5):
      net/mlx5: DR, Replace the check for valid STE entry
      net/mlx5: DR, Remove unneeded check from source port builder
      net/mlx5: DR, Remove unneeded vlan check from L2 builder
      net/mlx5: DR, Remove unneeded local variable
      net/mlx5: DR, Call ste_builder directly with tag pointer

sunils (1):
      net/mlx5: E-switch, Use PF num in metadata reg c0

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/alloc.c    |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  14 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   6 +-
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 103 ++----------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  16 +-
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c       |   8 +
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c | 124 ++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   4 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  91 ++++++----
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   2 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   5 +
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   4 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  22 +--
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  47 +++---
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   8 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  | 183 ++++++---------------
 .../mellanox/mlx5/core/steering/dr_types.h         |  24 +--
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   3 +-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   3 +-
 include/linux/mlx5/eswitch.h                       |  15 +-
 28 files changed, 371 insertions(+), 355 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
