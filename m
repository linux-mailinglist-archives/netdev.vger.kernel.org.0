Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94DE152B281
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiERGer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiERGeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:34:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5C8E2765
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:34:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D5A5617B8
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7C3C34100;
        Wed, 18 May 2022 06:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652855680;
        bh=KXa3wB9l8EYSjXBHd5HLL+HUtAM86wFS3dO+9vnWIiw=;
        h=From:To:Cc:Subject:Date:From;
        b=EfwqAidDqG/yAhE8bl8MuqLHL6FlrN3rz6nIfr99qthQRYrnaUnS8tm2GoDze2yPR
         OpBXibQ2NdHZ0gmFp3Fp9EaIRZDd4KwvhJ8uouDLvfUYxwBgo/XMy/8lm8GqrtIHJr
         Znwg4L5KggySACB5a6iDEvvWZrdvsAGWrzO0te1fJEuXEOOKDdSf9z525foHrag7Bx
         lMY2bXJPNAN68cDVy38oAR6Va16kZ+p8ip0VEx52CqrArv94SD8n3+p72OvX1RFXHE
         38kUiD9z7R494e0Jai3wJlIgHo0xnYIO75dZ4oFG/S2Jsj9P7xMMKktc/YnuO49ST9
         kXjMiLFqoPC/w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/11] mlx5 fixes 2022-05-17
Date:   Tue, 17 May 2022 23:34:16 -0700
Message-Id: <20220518063427.123758-1-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


The following changes since commit 23dd4581350d4ffa23d58976ec46408f8f4c1e16:

  NFC: nci: fix sleep in atomic context bugs caused by nci_skb_alloc (2022-05-17 17:55:53 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-05-17

for you to fetch changes up to 16d42d313350946f4b9a8b74a13c99f0461a6572:

  net/mlx5: Drain fw_reset when removing device (2022-05-17 23:03:57 -0700)

----------------------------------------------------------------
mlx5-fixes-2022-05-17

----------------------------------------------------------------
Aya Levin (1):
      net/mlx5e: Block rx-gro-hw feature in switchdev mode

Gal Pressman (1):
      net/mlx5e: Remove HW-GRO from reported features

Maor Dickman (1):
      net/mlx5: DR, Fix missing flow_source when creating multi-destination FW table

Maxim Mikityanskiy (3):
      net/mlx5e: Wrap mlx5e_trap_napi_poll into rcu_read_lock
      net/mlx5e: Properly block LRO when XDP is enabled
      net/mlx5e: Properly block HW GRO when XDP is enabled

Paul Blakey (2):
      net/mlx5e: CT: Fix support for GRE tuples
      net/mlx5e: CT: Fix setting flow_source for smfs ct tuples

Shay Drory (2):
      net/mlx5: Initialize flow steering during driver probe
      net/mlx5: Drain fw_reset when removing device

Yevgeny Kliteynik (1):
      net/mlx5: DR, Ignore modify TTL on RX if device doesn't support it

 .../ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c |  58 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  27 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 131 ++++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  25 +++-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  19 ++-
 .../mellanox/mlx5/core/steering/dr_action.c        |  71 +++++++----
 .../ethernet/mellanox/mlx5/core/steering/dr_fw.c   |   4 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |   4 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |   3 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   4 +-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   3 +-
 14 files changed, 246 insertions(+), 123 deletions(-)
