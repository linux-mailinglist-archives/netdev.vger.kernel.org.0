Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9354769891A
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 01:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjBPAJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 19:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBPAJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 19:09:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF1238B40
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 16:09:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43992B8231A
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E938CC433A7;
        Thu, 16 Feb 2023 00:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676506160;
        bh=Nr1Xvjs+n71A5x0sKgIdRQYiAGgfwZB3t5p0l+mTeGY=;
        h=From:To:Cc:Subject:Date:From;
        b=c8Dw4hiO34gRkvpOGhvvW9PfJ+oOq8hCGwysXjOWo1U+VdKoyGZRJdAopSHW92Ec+
         Oe2GKg9hu5VDMyprw3YmqOWWkURxKkttjS35l2ZNb56vOrVL76cOP8U/A5h7xr+nMW
         K5snEvBVa3tvNqUBUgTZ5D6ijylIVp0YVrwZBAiSTO/f0rfKOLgyrpnEnbbd4/okYZ
         USBv1doj25NzxiGjMp1gzYvXaku/rvok1R6oh32045FELOlWpKUiCLKciXJlfx8d6t
         gzFdpd5uATuNSIn+l++JC1Q/jEcL2lki8xBXrd1XCpx/T/uNEKq+bxwah6rEhF7r8v
         TPDU8Xay96EHg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 0/9] mlx5 updates 2023-02-15
Date:   Wed, 15 Feb 2023 16:09:09 -0800
Message-Id: <20230216000918.235103-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series adds misc updates to mlx5 driver.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 894341ad3ad7dfbced8556efe92a9ebfd5924bd6:

  net: phylink: support validated pause and autoneg in fixed-link (2023-02-15 10:35:27 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-02-15

for you to fetch changes up to b38e55f4eb69d826b3bc862eacb82246125a5c0b:

  net/mlx5e: RX, Remove doubtful unlikely call (2023-02-15 16:07:35 -0800)

----------------------------------------------------------------
mlx5-updates-2023-02-15

1) From Gal Tariq and Parav, Few cleanups for mlx5 driver.

2) From Vlad: Allow offloading of ct 'new' match based on [1]

[1] https://lore.kernel.org/netdev/20230201163100.1001180-1-vladbu@nvidia.com/

----------------------------------------------------------------
Gal Pressman (1):
      net/mlx5e: RX, Remove doubtful unlikely call

Parav Pandit (1):
      net/mlx5: Simplify eq list traversal

Tariq Toukan (5):
      net/mlx5e: Switch to using napi_build_skb()
      net/mlx5e: Remove redundant page argument in mlx5e_xmit_xdp_buff()
      net/mlx5e: Remove redundant page argument in mlx5e_xdp_handle()
      net/mlx5e: Remove unused function mlx5e_sq_xmit_simple
      net/mlx5e: Fix outdated TLS comment

Vlad Buslov (2):
      net/mlx5e: Implement CT entry update
      net/mlx5e: Allow offloading of ct 'new' match

 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 139 +++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |   4 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  14 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  15 ---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   8 +-
 9 files changed, 145 insertions(+), 49 deletions(-)
