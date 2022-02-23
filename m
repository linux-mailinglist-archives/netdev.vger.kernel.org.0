Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B734C1945
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243098AbiBWRFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243122AbiBWRFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:05:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0920D4B413
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:04:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9101D60FCE
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 17:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF77FC340E7;
        Wed, 23 Feb 2022 17:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645635877;
        bh=rAg+pU/T0U9OIsJ8FWuz2ngh6vh6JV2kLoFEfIwyC5U=;
        h=From:To:Cc:Subject:Date:From;
        b=HEbbAwZj4ILGqVk6ttcb7w45ONOGVdLMJccQKoKfsme25Hkgbs5XJha/emnR0R7NG
         +aoCQmqXoaZnb/M7wiAHbE8O3+c59u1BfXrY87BvlX/X+GfnAhoOvTFb+3rFhvC32Y
         1+/lxWYhLP2LicIUjeW+sJfo14naX5yc3vEX3kT0R2uRBpjif2z3737nty0gQuFE2T
         K92Gjc2CxeMzNUSrKoVcbmHZ75NHrcTz67/bBpzyESAHPKQSBzZWNgo+qmLJiIIDs8
         5sf4hvKZ/NMPZxOEordNTCY4SO+9EBgN60jOoJnfljoGVEvpOtiuwSy7vKpUKqZ3Gq
         KTcWu5gXsPglA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/19] mlx5 fixes 2022-02-23
Date:   Wed, 23 Feb 2022 09:04:11 -0800
Message-Id: <20220223170430.295595-1-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
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

Hi Dave, Hi Jakub,

This series provides bug fixes to mlx5 driver.
Sorry for the long list, we haven't sent bug fixes for a while.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 0228d37bd1a4fa552916e696f70490225272d58a:

  Merge branch 'ftgmac100-fixes' (2022-02-23 12:50:19 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-02-23

for you to fetch changes up to 6788c34444d5a6cddfbc855ef90298ccc04b2447:

  net/mlx5e: Fix VF min/max rate parameters interchange mistake (2022-02-23 09:01:05 -0800)

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
