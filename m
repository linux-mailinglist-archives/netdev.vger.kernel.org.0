Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41F261D817
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 08:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiKEHKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 03:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKEHKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 03:10:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C799A2D1F1
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 00:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 723D9B8163F
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 07:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE30C433D7;
        Sat,  5 Nov 2022 07:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667632234;
        bh=WolYxVWfu0Sz6uSq/SRd+aCXh1hZgyT+gsUBk0IPzTs=;
        h=From:To:Cc:Subject:Date:From;
        b=j+P7iD8xQQQXd6n2rxDfdtTXopJrlFrSIVKv4MVyRSluGS0Ch1ITtgIQW1WRSJKL2
         DxpV1WJc1v67t/aWmHTrVnO5gW15CqERIYBmwduTzwBPKFwn75lI5ucyVQ++BH913G
         W4IeYX6utxCNEacENzO+cP55HEMjnyFKlo4q2V4UQNMZKbxrPmWPHVbJ7mqWhHfEXi
         zrC+BJ8X7bUF8QWOnfZ+3ZnB+pYaTRKJA6WIfKST+CuCY4jS/winNa32ZVfB38vPBJ
         1NSOwwW+vP9RRjfgG0X9WBq14etVGbEY4F3PKjowXv+EqJ7xUpxS+LRBwbwpOKQjWp
         93MzUbHXjOgOw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][V2 net 00/11] mlx5 fixes 2022-11-02
Date:   Sat,  5 Nov 2022 00:10:17 -0700
Message-Id: <20221105071028.578594-1-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

v1->v2:
 - Fix 32bit build issue.

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit b7cbc6740bd6ad5d43345a2504f7e4beff0d709f:

  net: fman: Unregister ethernet device on removal (2022-11-04 19:33:38 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-11-02

for you to fetch changes up to 4a1ed426f330a544f8b56c2e4fae6a8c4fa77ccd:

  net/mlx5e: TC, Fix slab-out-of-bounds in parse_tc_actions (2022-11-05 00:04:34 -0700)

----------------------------------------------------------------
mlx5-fixes-2022-11-02

----------------------------------------------------------------
Chris Mi (1):
      net/mlx5: E-switch, Set to legacy mode if failed to change switchdev mode

Jianbo Liu (1):
      net/mlx5e: TC, Fix wrong rejection of packet-per-second policing

Maxim Mikityanskiy (2):
      net/mlx5e: Add missing sanity checks for max TX WQE size
      net/mlx5e: Fix usage of DMA sync API

Moshe Shemesh (1):
      net/mlx5: Fix possible deadlock on mlx5e_tx_timeout_work

Roi Dayan (3):
      net/mlx5e: Fix tc acts array not to be dependent on enum order
      net/mlx5e: E-Switch, Fix comparing termination table instance
      net/mlx5e: TC, Fix slab-out-of-bounds in parse_tc_actions

Roy Novich (1):
      net/mlx5: Allow async trigger completion execution on single CPU systems

Shay Drory (1):
      net/mlx5: fw_reset: Don't try to load device in case PCI isn't working

Vlad Buslov (1):
      net/mlx5: Bridge, verify LAG state when adding bond to bridge

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 11 ++-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    | 31 ++++++++
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    | 92 ++++++++--------------
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  | 24 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 13 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 27 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 14 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  5 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 14 ++--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 18 +----
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  | 14 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  3 +-
 13 files changed, 153 insertions(+), 117 deletions(-)
