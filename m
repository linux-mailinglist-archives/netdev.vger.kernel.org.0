Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59824633346
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiKVC23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbiKVC20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:28:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F83178A1
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:28:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C49BB8190B
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA626C433C1;
        Tue, 22 Nov 2022 02:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669084102;
        bh=mZxYpQcyNJ6BtCaIkuNtcH3PVNlLpkkhMVWk7mv7sSM=;
        h=From:To:Cc:Subject:Date:From;
        b=cFIwCjup4G++wiop+X7C6ZmPSbHzuKi3L4HRtM8PpqFVjGNg4F802rAOf8I29YNcV
         F2gAvZxr8ARtAiOE/OIYT8amfCSlCeKA2KhI2m/thrCD9wL9Q3Cb0QvmPEINYyjAVS
         fkBE/Gr4AvAVQTKfzM0icU4+8V7617IDMlNKDAdNIPu8lf5SVPWqHTnjq8MxcOEwNY
         IsMvpKwRPBXhVdaCqbNEu+EppqkWR4Y7iEZ/+4Q0SAjai0LC5E/5d0npaiiKHe/8dd
         Jj+b72qGFY3KQ/veSw0tN3X+ar5YkrFvJ+S+I/l+fxj1uXDve6eMRXlwNpmQJBu+WX
         JG/9TIWorV0KQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net 00/14] mlx5 fixes 2022-11-21
Date:   Mon, 21 Nov 2022 18:25:45 -0800
Message-Id: <20221122022559.89459-1-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
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


The following changes since commit badbda1a01860c80c6ab60f329ef46c713653a27:

  octeontx2-af: cn10k: mcs: Fix copy and paste bug in mcs_bbe_intr_handler() (2022-11-21 13:04:28 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-11-21

for you to fetch changes up to 8514e325ef016e3fdabaa015ed1adaa6e6d8722a:

  net/mlx5e: Fix possible race condition in macsec extended packet number update routine (2022-11-21 18:14:35 -0800)

----------------------------------------------------------------
mlx5-fixes-2022-11-21

----------------------------------------------------------------
Chris Mi (1):
      net/mlx5e: Offload rule only when all encaps are valid

Eli Cohen (1):
      net/mlx5: Lag, avoid lockdep warnings

Emeel Hakim (3):
      net/mlx5e: Fix MACsec SA initialization routine
      net/mlx5e: Fix MACsec update SecY
      net/mlx5e: Fix possible race condition in macsec extended packet number update routine

Moshe Shemesh (4):
      net/mlx5: Fix FW tracer timestamp calculation
      net/mlx5: cmdif, Print info on any firmware cmd failure to tracepoint
      net/mlx5: Fix handling of entry refcount when command is not issued to FW
      net/mlx5: Fix sync reset event handler error flow

Roi Dayan (1):
      net/mlx5: E-Switch, Set correctly vport destination

Roy Novich (1):
      net/mlx5: Do not query pci info while pci disabled

Shay Drory (1):
      net/mlx5: SF: Fix probing active SFs during driver probe phase

Tariq Toukan (2):
      net/mlx5e: Fix missing alignment in size of MTT/KLM entries
      net/mlx5e: Remove leftovers from old XSK queues enumeration

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  47 +++++-----
 .../mellanox/mlx5/core/diag/cmd_tracepoint.h       |  45 ++++++++++
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |  16 ++--
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.h  |   3 +-
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |  19 ++--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  18 ----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  17 ++--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  |  14 ++-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    | 100 +++++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.h    |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   9 +-
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.c   |  88 ++++++++++++++++++
 include/linux/mlx5/driver.h                        |   1 +
 18 files changed, 281 insertions(+), 118 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/cmd_tracepoint.h
