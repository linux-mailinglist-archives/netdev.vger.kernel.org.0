Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4461B60E29D
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbiJZNwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiJZNwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:52:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B378103246
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:52:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 06EDCCE2293
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 13:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F77CC433D6;
        Wed, 26 Oct 2022 13:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666792319;
        bh=gQt3jehBkYCk1Hx8bT/jre0CQX1RcKv2D02N0VTH4Vw=;
        h=From:To:Cc:Subject:Date:From;
        b=T6Agz7lFjO/3SYxBEBsD/X+Sv/bgBTab6Ezl+xspHrQTxqImruSwlvDvn+v3U1gtH
         tctNnIYAfiaeUXwWEJbFaw998hH3ZpjL2t01t9n2jgudtroF+/6p5vqoHnAEfxS2kc
         N1tpRSRc+iLUwCFMKBrHW7QDBaPjZlFA3/4GGIclhlpUbeWwPu3Iv+hg5/X0bFciKu
         H7RIOTebQnOxZFZfTGxJWa6wSCaGw3jzsawzkdWl1cKdT8z4kzHD+MED+Vyq2GfQpA
         KUGQwaV3yUmv6rx799ZDlFSGBQeNL0FnkUwlYPBgxrP4aHSjoR7mYw2Hdbpg7rmvL/
         btENWn8BIN+GQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][V4 net 00/15] mlx5 fixes 2022-10-14
Date:   Wed, 26 Oct 2022 14:51:38 +0100
Message-Id: <20221026135153.154807-1-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
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

v3->v4:
  Drop the SF commit to comply with 15 patch limit and avoid build break

v2->v3:
  Initialize sf_dev->sf_table mutex at correct location

v1->v2:
  add missing sign-off.

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit c5f0a17288740573f4de72965c5294a60244c5fc:

  rhashtable: make test actually random (2022-10-26 13:39:09 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-10-26

for you to fetch changes up to efe8b237ea42d8e57f030136cd5c9b99318b9885:

  net/mlx5e: Fix macsec sci endianness at rx sa update (2022-10-26 14:44:29 +0100)

----------------------------------------------------------------
mlx5-fixes-2022-10-26

----------------------------------------------------------------
Ariel Levkovich (1):
      net/mlx5e: TC, Reject forwarding from internal port to internal port

Aya Levin (1):
      net/mlx5e: Extend SKB room check to include PTP-SQ

Hyong Youb Kim (1):
      net/mlx5e: Do not increment ESN when updating IPsec ESN state

Moshe Shemesh (1):
      net/mlx5: Wait for firmware to enable CRS before pci_restore_state

Paul Blakey (1):
      net/mlx5e: Update restore chain id for slow path packets

Raed Salem (4):
      net/mlx5e: Fix macsec coverity issue at rx sa update
      net/mlx5e: Fix macsec rx security association (SA) update/delete
      net/mlx5e: Fix wrong bitwise comparison usage in macsec_fs_rx_add_rule function
      net/mlx5e: Fix macsec sci endianness at rx sa update

Roi Dayan (1):
      net/mlx5e: TC, Fix cloned flow attr instance dests are not zeroed

Rongwei Liu (1):
      net/mlx5: DR, Fix matcher disconnect error flow

Roy Novich (1):
      net/mlx5: Update fw fatal reporter state on PCI handlers successful recover

Saeed Mahameed (1):
      net/mlx5: ASO, Create the ASO SQ with the correct timestamp format

Suresh Devarakonda (1):
      net/mlx5: Fix crash during sync firmware reset

Tariq Toukan (1):
      net/mlx5: Fix possible use-after-free in async command interface

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 10 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |  9 +++
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  6 ++
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |  3 -
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  | 16 ++---
 .../mellanox/mlx5/core/en_accel/macsec_fs.c        |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 78 +++++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  6 ++
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 17 +++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c  |  7 ++
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c |  6 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  4 ++
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  3 +-
 include/linux/mlx5/driver.h                        |  2 +-
 15 files changed, 146 insertions(+), 25 deletions(-)
