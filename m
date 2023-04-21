Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A225F6EA13B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbjDUBvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjDUBvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:51:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC49444A0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:51:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6626564AC6
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE556C433D2;
        Fri, 21 Apr 2023 01:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041864;
        bh=fjKgR3N/VbLblLeDQHJlaJkHXkyUX4v4tGzRrO1Ow9c=;
        h=From:To:Cc:Subject:Date:From;
        b=AHjRYrEzxsNO12wStKbQNwmrkY80FEL3XpD1etUfomrRU9NHPu4BblIa/Ww+M3T2e
         dsmJDG7JPrWXzq94gt3ikZimPnZTJZgN1rK+ziXTuNKrwkKtrNriUArP+RYkhv/5gh
         WjlP+0fQYjKP4Jors0JkAe7lv/EcSazZz3hVcb1z+hFY1mdXIC7Qm2w05e8mJ3Q8UB
         Oer/S+Ja7LQG0NYT8FTwbpRoEm/zQNQRzM1OwSY0fRH/tEDf9wQiqk5Bs1hqi+W5sT
         3OiQqmNfxZP5PiDmaPPx2lf6QNB0p7sDtAnwHQs9n+JsXpY7klA8vE9ZcBhK7hSmS4
         laJRgI+QO4q7Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net V2 00/10] mlx5 fixes 2023-04-19
Date:   Thu, 20 Apr 2023 18:50:47 -0700
Message-Id: <20230421015057.355468-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

V1->v2:
  - #3, Remove "inline" keyword from a function declaration in c file.
  - #1, FYI Automation is reporting "author Signed-off-by missing" but
    it is not ! I manually checked, so nothing was changed in patch 1

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.

The following changes since commit 0f2a4af27b649c13ba76431552fe49c60120d0f6:

  wifi: ath9k: Don't mark channelmap stack variable read-only in ath9k_mci_update_wlan_channels() (2023-04-20 15:26:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2023-04-20

for you to fetch changes up to 081abcacaf0a9505c0d4cc9780b12e6ce5d33630:

  Revert "net/mlx5e: Don't use termination table when redundant" (2023-04-20 18:47:33 -0700)

----------------------------------------------------------------
mlx5-fixes-2023-04-20

----------------------------------------------------------------
Aya Levin (1):
      net/mlx5e: Nullify table pointer when failing to create

Chris Mi (3):
      net/mlx5: E-switch, Create per vport table based on devlink encap mode
      net/mlx5: E-switch, Don't destroy indirect table in split rule
      net/mlx5: Release tunnel device after tc update skb

Moshe Shemesh (2):
      Revert "net/mlx5: Remove "recovery" arg from mlx5_load_one() function"
      net/mlx5: Use recovery timeout on sync reset flow

Roi Dayan (1):
      net/mlx5e: Fix error flow in representor failing to add vport rx rule

Vlad Buslov (3):
      net/mlx5e: Don't clone flow post action attributes second time
      net/mlx5e: Release the label when replacing existing ct entry
      Revert "net/mlx5e: Don't use termination table when redundant"

 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  1 +
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.c   | 11 ++------
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.h   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |  4 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  5 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  2 ++
 .../net/ethernet/mellanox/mlx5/core/esw/vporttbl.c | 12 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  4 +--
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  | 32 +++-------------------
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  4 +--
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  9 +++---
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  2 +-
 16 files changed, 40 insertions(+), 54 deletions(-)
