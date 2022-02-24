Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687AD4C206C
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 01:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245164AbiBXAMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 19:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245158AbiBXAMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 19:12:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028165F4D0
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:12:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C10FB80E9F
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7968C340E7;
        Thu, 24 Feb 2022 00:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645661537;
        bh=1/FPIxdLPcfVqjFVZEBKK3rY1afw9kK7gvX/YT9hMHE=;
        h=From:To:Cc:Subject:Date:From;
        b=hKfjzPc/TEcBPjQIzuj3z2PUzZxcJJOcJCe9/Bay+FRu2LjaZXOhAqi9/9PQlpP/H
         fY/52NwjBT+Mst6rONiTgrUbZdJ8hphHIndpumjG+R3vy/Woeh/Vx3YcAf5MeemoWM
         w67xNkMAe7MpR7jilIu4sp8FNBbNJNyMG+pbHeCDTahNMG94bMd/SWAL638sKQbHfG
         EdhaTGvCDNozZhu7AKpHRu1Kl0sJInChWlYI+HrI8p1HdMEdSh7axrijyCl7vpp6xF
         I/TZ0sVCnV9DyBaqj/0s7UvMWvFeNCQz04rJxWOGM2izl8MjOAKiNK/Z2uhHV5yRzN
         BvijKkf0SlGBQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][v2 net 00/19] mlx5 fixes 2022-02-22
Date:   Wed, 23 Feb 2022 16:11:04 -0800
Message-Id: <20220224001123.365265-1-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Hi Dave, Hi Jakub,

v1->v2:
 - Fix warning: no previous prototype for ‘mlx5dr_ste_build_pre_check_spec’

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 0228d37bd1a4fa552916e696f70490225272d58a:

  Merge branch 'ftgmac100-fixes' (2022-02-23 12:50:19 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-02-23

for you to fetch changes up to ca49df96f9f5efd4f0f1e64f7c4c0c63a3329cb9:

  net/mlx5e: Fix VF min/max rate parameters interchange mistake (2022-02-23 16:08:19 -0800)

----------------------------------------------------------------
mlx5-fixes-2022-02-23

----------------------------------------------------------------
Ariel Levkovich (1):
      net/mlx5: Fix wrong limitation of metadata match on ecpf

Chris Mi (1):
      net/mlx5: Fix tc max supported prio for nic mode

Gal Pressman (2):
      net/mlx5e: Fix wrong return value on ioctl EEPROM query failure
      net/mlx5e: Fix VF min/max rate parameters interchange mistake

Lama Kayal (2):
      net/mlx5e: Add feature check for set fec counters
      net/mlx5e: Add missing increment of count

Maher Sanalla (1):
      net/mlx5: Update log_max_qp value to be 17 at most

Maor Dickman (2):
      net/mlx5e: Fix MPLSoUDP encap to use MPLS action information
      net/mlx5e: MPLSoUDP decap, fix check for unsupported matches

Maor Gottlieb (1):
      net/mlx5: Fix possible deadlock on rule deletion

Meir Lichtinger (1):
      net/mlx5: Update the list of the PCI supported devices

Roi Dayan (3):
      net/mlx5e: TC, Reject rules with drop and modify hdr action
      net/mlx5e: TC, Reject rules with forward and drop actions
      net/mlx5e: TC, Skip redundant ct clear actions

Tariq Toukan (1):
      net/mlx5e: kTLS, Use CHECKSUM_UNNECESSARY for device-offloaded packets

Yevgeny Kliteynik (4):
      net/mlx5: DR, Cache STE shadow memory
      net/mlx5: DR, Fix slab-out-of-bounds in mlx5_cmd_dr_create_fte
      net/mlx5: DR, Don't allow match on IP w/o matching on full ethertype/ip_version
      net/mlx5: DR, Fix the threshold that defines when pool sync is initiated

 .../ethernet/mellanox/mlx5/core/en/tc/act/act.h    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c |   7 ++
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c |   6 ++
 .../ethernet/mellanox/mlx5/core/en/tc/act/mpls.c   |  11 ++
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   1 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   3 +
 .../mellanox/mlx5/core/en/tc_tun_mplsoudp.c        |  33 +++---
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   8 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  12 +++
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   4 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   2 +
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   4 +-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      | 120 ++++++++++++++-------
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  20 +---
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  32 +++++-
 .../mellanox/mlx5/core/steering/dr_types.h         |  10 ++
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  33 ++++--
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   5 +
 24 files changed, 236 insertions(+), 94 deletions(-)
