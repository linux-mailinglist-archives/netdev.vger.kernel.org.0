Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4531A69B8E4
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 10:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBRJF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 04:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBRJFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 04:05:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F6A442E7
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 01:05:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31F26B81E9B
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 09:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A30C433D2;
        Sat, 18 Feb 2023 09:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676711121;
        bh=INgEe7Dd7ifr2r5atOUQHjbvHAYCPvkh+rt7NlDYf28=;
        h=From:To:Cc:Subject:Date:From;
        b=dDD9ZHOYIQS3p7qtzhOG0qkJpMk1FZR2eKnbOPII4Z3OMeRTtRtjbNf4yISbQvYhf
         5RkwxJoqpj29yhdX3g6q2+nYP9cibH9ePV7uX2TNPSLAr/uuQRBOB95ww9xYQLldgU
         B22xcp8ckCLcsoE3iaqH71HZdtUy+AEr4w8nZonvQLUMlFPF8o+JrPJhXbozIQDMfY
         ekGLiA1Qrnqvxa40MbggyMF/j3q2FFhU4t7UYSw/dz+OHgtrMrYT19osiWUgjR2CBB
         0/dxdezin3RKujZt38ZhCZyxoXcKFTU18PttWb62BwDaqwcPAUTkOioUaOhYa1iyYu
         DhEzW8noY42jg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next V2 0/9] mlx5 updates 2023-02-15
Date:   Sat, 18 Feb 2023 01:05:04 -0800
Message-Id: <20230218090513.284718-1-saeed@kernel.org>
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

This series adds misc updates.

V1->V2:
 - Handled comment from Maciej.
 - Added Reviewed-by tags for Maciej and Olek.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 675f176b4dcc2b75adbcea7ba0e9a649527f53bd:

  Merge ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net (2023-02-17 11:06:39 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-02-15

for you to fetch changes up to 993fd9bd656a082c9b713171622c70f72f0af59f:

  net/mlx5e: RX, Remove doubtful unlikely call (2023-02-18 01:01:34 -0800)

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
