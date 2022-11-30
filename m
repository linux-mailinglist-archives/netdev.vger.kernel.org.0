Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6C963CE90
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbiK3FMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiK3FMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:12:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B336037F
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:11:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8277561A0D
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F2CC433D6;
        Wed, 30 Nov 2022 05:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785117;
        bh=DAFk/pA2gTM45Py7Psvqm93OwVCnYmhgSi5BJ5W5UAI=;
        h=From:To:Cc:Subject:Date:From;
        b=WYOnlC/i3SmAhhvx1CLejqdb8hsOF3hCDZ7ciRXuo/1wxxF0W8KGOYPSBB5f8we4D
         jNZqhTORj1tFCgCrHstd4tMUx9F4kfGlpKz1RSHkKTdJeF37pjYsIDB+aUFIeK4/0N
         MzVH4BmWoJBvZrjUpyEyZJp/lmvy+ubqAOLXi/dvRHt5s6Hg9/BzSfWxgZU97PC19s
         kahY5brMV9iES9Y7ML3h/R6aQK7IaBBYhU1FjVl61gFCFP9DppMkltCyGiFQc6tHn4
         f7GJTEq1dncC0gT8CXKvyfl7DnYdwB4ErlxfoZC8fj9mWmzj/irT2GsM3cLKEcWwQ5
         llh81QY4BRURA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2022-11-29
Date:   Tue, 29 Nov 2022 21:11:37 -0800
Message-Id: <20221130051152.479480-1-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This PR provides misc updates to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 5cb0c51fe366cf96b7911d25db3e678401732246:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next (2022-11-29 20:50:51 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-11-29

for you to fetch changes up to 953d771587e232e537665d34086a94ed29b89e5f:

  net/mlx5e: Support devlink reload of IPsec core (2022-11-29 21:09:49 -0800)

----------------------------------------------------------------
mlx5-updates-2022-11-29

Misc update for mlx5 driver

1) Various trivial cleanups

2) Maor Dickman, Adds support for trap offload with additional actions

3) From Tariq, UMR (device memory registrations) cleanups,
   UMR WQE must be aligned to 64B per device spec, (not a bug fix).

----------------------------------------------------------------
Christophe JAILLET (1):
      net/mlx5e: Remove unneeded io-mapping.h #include

Gustavo A. R. Silva (1):
      net/mlx5e: Replace zero-length arrays with DECLARE_FLEX_ARRAY() helper

Leon Romanovsky (4):
      net/mlx5e: Don't access directly DMA device pointer
      net/mlx5e: Delete always true DMA check
      net/mlx5: Remove redundant check
      net/mlx5e: Support devlink reload of IPsec core

Maor Dickman (1):
      net/mlx5e: TC, Add offload support for trap with additional actions

Petr Pavlu (1):
      net/mlx5: Remove unused ctx variables

Rahul Rameshbabu (1):
      net/mlx5: Fix orthography errors in documentation

Roi Dayan (2):
      net/mlx5e: Don't use termination table when redundant
      net/mlx5e: Do early return when setup vports dests for slow path flow

Tariq Toukan (4):
      net/mlx5e: Add padding when needed in UMR WQEs
      net/mlx5: Remove unused UMR MTT definitions
      net/mlx5: Generalize name of UMR alignment definition
      net/mlx5: Use generic definition for UMR KLM alignment

 .../device_drivers/ethernet/mellanox/mlx5.rst      | 82 +++++++++++-----------
 drivers/infiniband/hw/mlx5/odp.c                   |  3 +-
 drivers/infiniband/hw/mlx5/umr.c                   | 14 ++--
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  8 +--
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  4 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/trap.c   | 10 +--
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   | 17 +++--
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |  5 +-
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  | 12 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  9 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 10 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 21 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  5 ++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 35 ++++-----
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  | 32 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c  |  3 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  3 -
 drivers/net/ethernet/mellanox/mlx5/core/uar.c      |  1 -
 include/linux/mlx5/device.h                        |  7 +-
 include/linux/mlx5/driver.h                        |  2 -
 22 files changed, 153 insertions(+), 135 deletions(-)
