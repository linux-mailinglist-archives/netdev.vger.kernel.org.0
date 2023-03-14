Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB676B9D6A
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjCNRt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjCNRty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:49:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B1246AC
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:49:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73EC0B81AC7
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 17:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1117C433D2;
        Tue, 14 Mar 2023 17:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678816188;
        bh=/l9x2HKKVtD+G4PDecJQBAx59O7oynUsDoWUOIWMgjQ=;
        h=From:To:Cc:Subject:Date:From;
        b=c5Ae4fMNjuxR7xpb8Q5F+j70zZGwJjwVl04/eoGfDiU6IU7o57rAuA27StbAKeaWE
         frlY6IYQ5mNsIHFhHr2Z4v3wdVA/ua5IAMnqnsY2yaNo3fTrDJ3VDBz885aTRU+cnk
         8aZ7mXPd/zOyedbN+N9/ENy72ZmLfdFpsm3b0+D/4C70sD6oa+Y2F/zcTdPrEEILve
         YVi0B98FxV4caMJ3cCRREEWRA/ZRS5peSppa12yuFicBD08TP5X0X5q30Z1puxXsQd
         CrXMoEvqBegigAn7pEqCyMP6KHBK/ZisIjRkDtjtW7zm/I2ZgeXkhj8whpb8wqStXQ
         nwQ9MqZObBMpQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net 00/14] mlx5 fixes 2023-03-14
Date:   Tue, 14 Mar 2023 10:49:26 -0700
Message-Id: <20230314174940.62221-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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


The following changes since commit 28e8cabe80f3e6e3c98121576eda898eeb20f1b1:

  net: hsr: Don't log netdev_err message on unknown prp dst node (2023-03-14 15:26:10 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2023-03-14

for you to fetch changes up to af3f0700d50c5d275139eec158d495efdf642c0f:

  net/mlx5e: TC, Remove error message log print (2023-03-14 10:45:04 -0700)

----------------------------------------------------------------
mlx5-fixes-2023-03-14

----------------------------------------------------------------
Adham Faris (1):
      net/mlx5e: Lower maximum allowed MTU in XSK to match XDP prerequisites

Daniel Jurgens (1):
      net/mlx5: Disable eswitch before waiting for VF pages

Emeel Hakim (1):
      net/mlx5e: Fix macsec ASO context alignment

Gal Pressman (1):
      net/mlx5e: kTLS, Fix missing error unwind on unsupported cipher type

Maor Dickman (2):
      net/mlx5: E-switch, Fix wrong usage of source port rewrite in split rules
      net/mlx5: E-switch, Fix missing set of split_count when forward to ovs internal port

Oz Shlomo (4):
      net/sched: TC, fix raw counter initialization
      net/mlx5e: TC, fix missing error code
      net/mlx5e: TC, fix cloned flow attribute
      net/mlx5e: TC, Remove error message log print

Parav Pandit (2):
      net/mlx5e: Don't cache tunnel offloads capability
      net/mlx5: Fix setting ec_function bit in MANAGE_PAGES

Paul Blakey (1):
      net/mlx5e: Fix cleanup null-ptr deref on encap lock

Shay Drory (1):
      net/mlx5: Set BREAK_FW_WAIT flag first when removing driver

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  1 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/police.c |  1 -
 .../ethernet/mellanox/mlx5/core/en/tc/act_stats.c  |  5 +++++
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 24 ++++++++++++----------
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 22 +++++++++++---------
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 14 +++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 21 ++++++++++++++++---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 10 ++++-----
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 18 ++++++++++++----
 13 files changed, 78 insertions(+), 46 deletions(-)
