Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1122D59C977
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237780AbiHVT7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 15:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238081AbiHVT7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:59:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2961F4F670
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:59:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2C83B81257
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 19:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CF9C433C1;
        Mon, 22 Aug 2022 19:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661198368;
        bh=z3ntUsGV0/xamzSypUsn8NrMNzvYh05cGwM4cNeMkSI=;
        h=From:To:Cc:Subject:Date:From;
        b=isBsbcIcLi+nyuQhAHQAQfIr+zFgFM+88xdUEro3HKshsWf+0NJa4fdAklbxuAx6b
         bbkhIBRPzW4UuhRLAssS2AKzUejdGFMnabyRbIJZn79QYc9ECComCrC5UjX4uhlhWc
         96WWG3Q9Iv/xA3R4Tp/n999ejOCXVUFvyV9Ga8gBjdH3KUYxIuV92q7xBSmGvYFsUh
         R3abK53qFKkcL09+4MDuYj+KMDj/sLmNN7/e+d8OGalM1JWVOsjxvw4igCWn016JwN
         n+y+SYyTK5uLGZALKwO2+eJeIGY36l/mIlQv3kkLYHYYD7kqCtnYtPRZfRS9qT4Zxk
         PODG8mODmUpJQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
Subject: [pull request][net 00/13] mlx5 fixes 2022-08-22
Date:   Mon, 22 Aug 2022 12:59:04 -0700
Message-Id: <20220822195917.216025-1-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
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


The following changes since commit f1e941dbf80a9b8bab0bffbc4cbe41cc7f4c6fb6:

  nfc: pn533: Fix use-after-free bugs caused by pn532_cmd_timeout (2022-08-22 14:51:30 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-08-22

for you to fetch changes up to 35419025cb1ee40f8b4c10ab7dbe567ef70b8da4:

  net/mlx5: Unlock on error in mlx5_sriov_enable() (2022-08-22 12:57:10 -0700)

----------------------------------------------------------------
mlx5-fixes-2022-08-22

----------------------------------------------------------------
Aya Levin (1):
      net/mlx5e: Fix wrong application of the LRO state

Dan Carpenter (4):
      net/mlx5: unlock on error path in esw_vfs_changed_event_handler()
      net/mlx5e: kTLS, Use _safe() iterator in mlx5e_tls_priv_tx_list_cleanup()
      net/mlx5e: Fix use after free in mlx5e_fs_init()
      net/mlx5: Unlock on error in mlx5_sriov_enable()

Eli Cohen (2):
      net/mlx5: LAG, fix logic over MLX5_LAG_FLAG_NDEVS_READY
      net/mlx5: Eswitch, Fix forwarding decision to uplink

Maor Dickman (1):
      net/mlx5e: Fix wrong tc flag used when set hw-tc-offload off

Moshe Shemesh (1):
      net/mlx5: Avoid false positive lockdep warning by adding lock_class_key

Roi Dayan (1):
      net/mlx5e: TC, Add missing policer validation

Roy Novich (1):
      net/mlx5: Fix cmd error logging for manage pages cmd

Vlad Buslov (2):
      net/mlx5e: Properly disable vlan strip on non-UL reps
      net/mlx5: Disable irq when locking lag_lock

 .../ethernet/mellanox/mlx5/core/en/tc/act/police.c |  4 ++
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 12 ++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  2 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  7 ++-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  | 57 +++++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  4 ++
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  9 ++--
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |  2 +-
 include/linux/mlx5/driver.h                        |  1 +
 11 files changed, 65 insertions(+), 42 deletions(-)
