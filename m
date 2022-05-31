Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18D853984C
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 22:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244223AbiEaUzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 16:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiEaUzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 16:55:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458A79CF6E
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 13:55:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDDAEB80FAB
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 20:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930C9C385A9;
        Tue, 31 May 2022 20:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654030503;
        bh=0fEnTLDN7VFBcBE8Ql0DRpyNFqpTxPB7fWb6iXIPM+o=;
        h=From:To:Cc:Subject:Date:From;
        b=rewwHCFyCuHRSYj7oCGDyDUBL255pdSlOHbOHXGaBy2rgNd16hOvc1plMOIGTb+4N
         Xu+c2TSsrLY3/MD7TyO4V42eCItqvFkte1KoEvdW1CsyMN1Si9RYslXL0DbQL30jGb
         eF1p6mZtE2vRygJIpCQC1bxifv+dEA54Dw2XZHro/L+lDsSF9ByYyan7f3VPEMTNAW
         2CHekSjLy3Ny3BGKIJiIsgoCQ4hmIEylCv4kYK2WwMEppCsWZrKuLsFLK9f8tHQaTz
         1mSG59GdhhFcvWmJeK25tboZrl+9it80IJ1Y7lwFethzIXUkbq+3VQ2v/RqAJrTV+s
         sDGpbpb8+TXuQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 0/7] mlx5 fixes 2022-05-31
Date:   Tue, 31 May 2022 13:54:40 -0700
Message-Id: <20220531205447.99236-1-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


The following changes since commit 09e545f7381459c015b6fa0cd0ac6f010ef8cc25:

  xen/netback: fix incorrect usage of RING_HAS_UNCONSUMED_REQUESTS() (2022-05-31 12:22:22 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-05-31

for you to fetch changes up to 1c5de097bea31760c3f0467ac0c84ba0dc3525d5:

  net/mlx5: Fix mlx5_get_next_dev() peer device matching (2022-05-31 13:40:55 -0700)

----------------------------------------------------------------
mlx5-fixes-2022-05-31

----------------------------------------------------------------
Changcheng Liu (1):
      net/mlx5: correct ECE offset in query qp output

Leon Romanovsky (1):
      net/mlx5: Don't use already freed action pointer

Maor Dickman (1):
      net/mlx5e: TC NIC mode, fix tc chains miss table

Maxim Mikityanskiy (2):
      net/mlx5e: Disable softirq in mlx5e_activate_rq to avoid race condition
      net/mlx5e: Update netdev features after changing XDP state

Paul Blakey (1):
      net/mlx5: CT: Fix header-rewrite re-use for tupels

Saeed Mahameed (1):
      net/mlx5: Fix mlx5_get_next_dev() peer device matching

 drivers/net/ethernet/mellanox/mlx5/core/dev.c      | 34 ++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  4 +++
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |  2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |  1 +
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |  6 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 19 ++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.c  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  5 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 29 +++++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 38 ++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  2 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  9 +++--
 include/linux/mlx5/mlx5_ifc.h                      |  5 ++-
 14 files changed, 115 insertions(+), 41 deletions(-)
