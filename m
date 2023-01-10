Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4ED663910
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjAJGLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjAJGLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:11:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B9D1D0FC
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:11:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0CB8614DB
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62E5C433D2;
        Tue, 10 Jan 2023 06:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673331096;
        bh=BL4mz/PNaIbpVLRS5ndd7lP9VASE3765X5Y9CY465EY=;
        h=From:To:Cc:Subject:Date:From;
        b=WG2VlQlV2w7xJ+6kvRwaAmjojywhrZITKquCyTEKbrQFUb8Buc4cTGNiyC0Y+sJTW
         Bhic9Mg1OdZF1AVLVG1B8s7KF+JAt+0FKB2TOBKSFT488rMrSrV4xfIjkW5xFbir7y
         gxfpC/JxsJE16kTCBt+Ze5clrIPL+BlV63HUztWDYdx4ZE+FvlfuhCZA6p7uymuoqi
         xb0bvFcsaUBiHS9QrJYHaCRdUaelFZdpmpYClITHJlVH4M8omv4tsZYfB48F4LpG1q
         J4CDhxDkfhvKkVP0F24qJTPr04E/8jwPUa7xUt7N8zwIz1tPaHxQUvUao0rkBJLeVD
         0wobIurpCR2bg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net 00/16] mlx5 fixes 2023-01-09
Date:   Mon,  9 Jan 2023 22:11:07 -0800
Message-Id: <20230110061123.338427-1-saeed@kernel.org>
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

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 2ea26b4de6f42b74a5f1701de41efa6bc9f12666:

  Revert "r8169: disable detection of chip version 36" (2023-01-09 20:40:28 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2023-01-09

for you to fetch changes up to 9828994ac492e8e7de47fe66097b7e665328f348:

  net/mlx5e: Fix macsec possible null dereference when updating MAC security entity (SecY) (2023-01-09 22:08:37 -0800)

----------------------------------------------------------------
mlx5-fixes-2023-01-09

----------------------------------------------------------------
Ariel Levkovich (2):
      net/mlx5: check attr pointer validity before dereferencing it
      net/mlx5e: TC, Keep mod hdr actions after mod hdr alloc

Aya Levin (1):
      net/mlx5e: Fix memory leak on updating vport counters

Dragos Tatulea (3):
      net/mlx5e: IPoIB, Block queue count configuration when sub interfaces are present
      net/mlx5e: IPoIB, Block PKEY interfaces with less rx queues than parent
      net/mlx5e: IPoIB, Fix child PKEY interface stats on rx path

Emeel Hakim (2):
      net/mlx5e: Fix macsec ssci attribute handling in offload path
      net/mlx5e: Fix macsec possible null dereference when updating MAC security entity (SecY)

Gavin Li (1):
      net/mlx5e: Don't support encap rules with gbp option

Moshe Shemesh (1):
      net/mlx5: Fix command stats access after free

Oz Shlomo (2):
      net/mlx5e: TC, ignore match level for post meter rules
      net/mlx5e: TC, Restore pkt rate policing support

Rahul Rameshbabu (1):
      net/mlx5: Fix ptp max frequency adjustment range

Roy Novich (1):
      net/mlx5e: Verify dev is present for fix features ndo

Shay Drory (1):
      net/mlx5: E-switch, Coverity: overlapping copy

Yevgeny Kliteynik (1):
      net/mlx5: DR, Fix 'stack frame size exceeds limit' error in dr_rule

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 13 ++------
 .../ethernet/mellanox/mlx5/core/en/tc/act/police.c |  6 ----
 .../ethernet/mellanox/mlx5/core/en/tc/post_meter.c |  1 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  |  2 ++
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  | 19 +++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  3 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  5 +--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  6 +---
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    | 16 +++++++--
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  | 38 ++++++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h  |  6 ++++
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c | 18 +++++++---
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |  2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c | 11 ++++---
 include/linux/mlx5/driver.h                        |  2 +-
 17 files changed, 104 insertions(+), 49 deletions(-)
