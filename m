Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F771584733
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbiG1UrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiG1Uqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:46:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693806566A
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:46:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B251B82590
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A80C433D6;
        Thu, 28 Jul 2022 20:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041211;
        bh=8QSaLcdimBDkLQ1p+4iHWM59R/bX7vEe9I/TzRD7xM8=;
        h=From:To:Cc:Subject:Date:From;
        b=sNZ/rhpGj6uXDpCB+6C27CxdE+0+whIVGRmbC7Q4YCMWNFn2AozBbG+xONV6mTBWm
         FwrZtU3XtPKstfKiRpNEjSJE5X4bEuRo1m5OM0Y5iKP4PxFEZi4TvFj4WpCkELl92h
         MeXqqe0r3h5o69eehWLaiL4Dh7SSLvqZxM1yCfY689WOPv8qtp/LQy4UEBR9BVnAdy
         9Hv1+3Rggam0ZAiS2/Ys6kCWJelU1af5BdixB9/B1Dy9VtwwsiCo2aQeoqanWTOg1m
         63VQa+GS3sX37ZU3IxO0ehcfxe/+SyDzsKpBKTrLAf4TAWnltkKAYe4YYkEv8gSSY8
         Mx3A8EP/jmChA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net 0/9] mlx5 fixes 2022-07-28
Date:   Thu, 28 Jul 2022 13:46:31 -0700
Message-Id: <20220728204640.139990-1-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 4d3d3a1b244fd54629a6b7047f39a7bbc8d11910:

  stmmac: dwmac-mediatek: fix resource leak in probe (2022-07-28 10:43:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-07-28

for you to fetch changes up to 42b4f7f66a43cdb9216e76e595c8a9af154806da:

  net/mlx5: Fix driver use of uninitialized timeout (2022-07-28 13:44:41 -0700)

----------------------------------------------------------------
mlx5-fixes-2022-07-28

----------------------------------------------------------------
Gal Pressman (1):
      net/mlx5e: Remove WARN_ON when trying to offload an unsupported TLS cipher/version

Maher Sanalla (1):
      net/mlx5: Adjust log_max_qp to be 18 at most

Maor Dickman (1):
      net/mlx5e: TC, Fix post_act to not match on in_port metadata

Maxim Mikityanskiy (3):
      net/mlx5e: Fix the value of MLX5E_MAX_RQ_NUM_MTTS
      net/mlx5e: xsk: Account for XSK RQ UMRs when calculating ICOSQ size
      net/mlx5e: Fix calculations related to max MPWQE size

Shay Drory (1):
      net/mlx5: Fix driver use of uninitialized timeout

Vlad Buslov (1):
      net/mlx5e: Modify slow path rules to go to slow fdb

Yevgeny Kliteynik (1):
      net/mlx5: DR, Fix SMFS steering info dump format

 drivers/net/ethernet/mellanox/mlx5/core/en.h       | 21 ++++++++++----------
 .../net/ethernet/mellanox/mlx5/core/en/params.c    | 12 +++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.c   |  1 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |  2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 23 ++++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c | 11 ++++-------
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  4 +---
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.c  | 13 +++++++-----
 9 files changed, 55 insertions(+), 33 deletions(-)
