Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4F26E872B
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjDTBKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDTBKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:10:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92079A1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 18:10:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CB3960C6E
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043BCC433D2;
        Thu, 20 Apr 2023 01:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681953006;
        bh=old52JLZIfMJYcnuzf9G+ElaNsubBjwZ+vM9V0Ee6UA=;
        h=From:To:Cc:Subject:Date:From;
        b=ES4GJCDG8y0h96cQVuIqfTXam4pi0KMXLHIqxwtPoUn/ebcleIIy7VwpbLj1rcK23
         zSLdhCecG++UmgULfocfD//C6hn1BQKOlgmkN+jD8JsHLBDW4JRIps5mAHoItn1Doi
         93Gn9/aROq73yZbXzmBtEhyR4wCeL6yWJ1CYTYop6LbCjbW0xJ67Py4BJxmEUlldMK
         WVm6eaQgLlhBqRubqPnMz+UH4CQod1c+nGD+kRKhKcR15IYKUOkMqiNpEFNDBD7uFi
         AXHcUpwh6YopcJJST19D+wTYD1xpiLNbcLg4LPUJtw66DxXT9kXIUVZQp/RumeItCN
         Iho50iw9pjdcw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net 00/10] mlx5 fixes 2023-04-19
Date:   Wed, 19 Apr 2023 18:09:49 -0700
Message-Id: <20230420010959.276760-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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


The following changes since commit 7b97174d0ef798ba7f802c07527ae378923e5ebc:

  Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue (2023-04-19 18:00:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2023-04-19

for you to fetch changes up to 5fd33ec419b73c32c45663f32b73c9700b96bec4:

  Revert "net/mlx5e: Don't use termination table when redundant" (2023-04-19 18:05:51 -0700)

----------------------------------------------------------------
mlx5-fixes-2023-04-19

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
