Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB1856A2153
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjBXSTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjBXSTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:19:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4168A16882
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:19:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1EC661967
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 18:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C39EC4339B;
        Fri, 24 Feb 2023 18:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677262751;
        bh=JK4vecOZZAh9eVoDEqwzOajRuaR4Kd7mXQQxfvBelk4=;
        h=From:To:Cc:Subject:Date:From;
        b=lCPUpIql24aKbF1ebmCIChpL/ZoXyLQqwn1tDh9ZYbqlQjkK/QqS/Nlt/uoqDJQrf
         YMz2XQbAyO5It0FgJ3kTkVCgFbm2P2SSyfDuJ/scAtuBMJ8h+08cN02Op27nG2RYIn
         DbENnFFOmfOtQFakSiXe1Od2LlToKmGtjJUkmQuF5SsYdYOEWT37uO2L/BdA8EXxJJ
         cMPTjl1H9lJwSEW2zYxnP4i+BdgehQPiIJRQvE8gskeVpoiwMGPuxPAFAuNMTW2UR5
         KWDm5A30q9yxY2+gMrj4uJyOJkxXBmTNIlchFoXtw43h3fgMS5eogpYVrDQNegw+v0
         IULNYGJ8fteoA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net V2 0/7] mlx5 fixes 2023-02-24
Date:   Fri, 24 Feb 2023 10:18:57 -0800
Message-Id: <20230224181904.671473-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

V1->V2:
 - Toss away arguably non-fixes patches

This series provides bug fixes for mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit ac3ad19584b26fae9ac86e4faebe790becc74491:

  net: fix __dev_kfree_skb_any() vs drop monitor (2023-02-24 11:02:07 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2023-02-24

for you to fetch changes up to d28a06d7dbedc598a06bd1e53a28125f87ca5d0c:

  net/mlx5: Geneve, Fix handling of Geneve object id as error code (2023-02-24 10:13:19 -0800)

----------------------------------------------------------------
mlx5-fixes-2023-02-24

----------------------------------------------------------------
Maher Sanalla (1):
      net/mlx5: ECPF, wait for VF pages only after disabling host PFs

Maor Dickman (1):
      net/mlx5: Geneve, Fix handling of Geneve object id as error code

Roi Dayan (1):
      net/mlx5e: Verify flow_source cap before using it

Vadim Fedorenko (2):
      mlx5: fix skb leak while fifo resync and push
      mlx5: fix possible ptp queue fifo use-after-free

Yang Li (1):
      net/mlx5: Remove NULL check before dev_{put, hold}

Yang Yingliang (1):
      net/mlx5e: TC, fix return value check in mlx5e_tc_act_stats_create()

 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c     |  4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   | 25 +++++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  3 +--
 .../ethernet/mellanox/mlx5/core/en/tc/act_stats.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  1 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/lib/geneve.c   |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |  4 ++++
 10 files changed, 40 insertions(+), 8 deletions(-)
