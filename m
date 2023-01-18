Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9388167271A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjARSgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjARSgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:36:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D572B0A7
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 10:36:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DCDDB81E9B
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B2EC433D2;
        Wed, 18 Jan 2023 18:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674066967;
        bh=7cwjsewON5B6dfHKrh9/MBG9s6Y8SmHn0+vIhBUJCPo=;
        h=From:To:Cc:Subject:Date:From;
        b=j97uJXmfgcq8vOyov7C80YL3X/AQxhvZKVKISWSTPeEvZPebPMSyp8Ff08404z30A
         F3VwpS3Mc6P6Xhy5EckKs3udJx4Hhn/GcDSU4aIJqYFvPEElNBA0c+KzSm54jym1wQ
         RzQrB2yFRkO3H+PqmiJ2uZYUgaPuyc200FIYD6/Yj3FrlUsI5RB8auQvzCBZclv/V0
         4X0MnMeUThy9ozXUY4DwM0kOH0uHukt/K1IezUxHw227cviAljNJX4+F4jCqHxkHaU
         eFBfor1oYUqu+zQR3skA876QqvWGlg35iGPyRHOKCfKfnRtsPUieXjjtv2wb5RfbTg
         kVjQ6RsneU8yQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2023-01-18
Date:   Wed, 18 Jan 2023 10:35:47 -0800
Message-Id: <20230118183602.124323-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
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

This series provides misc updates to mxl5.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 68e5b6aa2795fd05c6ff58616cb16f2f216e4123:

  xdp: document xdp_do_flush() before napi_complete_done() (2023-01-18 14:33:34 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-01-18

for you to fetch changes up to efb4879f76236f248bbe5b9e2bf408d9470d59f3:

  net/mlx5e: Use read lock for eswitch get callbacks (2023-01-18 10:34:09 -0800)

----------------------------------------------------------------
mlx5-updates-2023-01-18

1) From Rahul,
  1.1) extended range for PTP adjtime and adjphase
  1.2) adjphase function to support hardware-only offset control

2) From Roi, code cleanup to the TC module.

3) From Maor, TC support for Geneve and GRE with VF tunnel offload

4) Cleanups and minor updates.

----------------------------------------------------------------
Adham Faris (2):
      net/mlx5e: Fail with messages when params are not valid for XSK
      net/mlx5e: Add warning when log WQE size is smaller than log stride size

Leon Romanovsky (1):
      net/mlx5e: Use read lock for eswitch get callbacks

Maor Dickman (2):
      net/mlx5e: Support Geneve and GRE with VF tunnel offload
      net/mlx5e: Remove redundant allocation of spec in create indirect fwd group

Rahul Rameshbabu (3):
      net/mlx5e: Suppress Send WQEBB room warning for PAGE_SIZE >= 16KB
      net/mlx5: Add adjphase function to support hardware-only offset control
      net/mlx5: Add hardware extended range support for PTP adjtime and adjphase

Roi Dayan (6):
      net/mlx5: E-switch, Remove redundant comment about meta rules
      net/mlx5e: TC, Pass flow attr to attach/detach mod hdr functions
      net/mlx5e: TC, Add tc prefix to attach/detach hdr functions
      net/mlx5e: TC, Use common function allocating flow mod hdr or encap mod hdr
      net/mlx5e: Warn when destroying mod hdr hash table that is not empty
      net/mlx5: E-Switch, Fix typo for egress

Yishai Hadas (1):
      net/mlx5: Suppress error logging on UCTX creation

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en/mod_hdr.c   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  18 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   2 -
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |   2 -
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 101 ++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  14 +-
 .../ethernet/mellanox/mlx5/core/esw/indir_table.c  | 213 ++++-----------------
 .../ethernet/mellanox/mlx5/core/esw/indir_table.h  |   4 -
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   6 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  35 ++--
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |  41 +++-
 include/linux/mlx5/mlx5_ifc.h                      |   4 +-
 16 files changed, 177 insertions(+), 293 deletions(-)
