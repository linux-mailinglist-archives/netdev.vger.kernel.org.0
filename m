Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9185695A5
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbiGFXNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbiGFXNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:13:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E388D2B254
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:13:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82CD361E59
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5BAC3411C;
        Wed,  6 Jul 2022 23:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149197;
        bh=WqWSc7P4vzFlcktIpaWfcKBvWonY+EYTvP4f0aFcShA=;
        h=From:To:Cc:Subject:Date:From;
        b=JQ5oyc/nqkBWOyyMOa+017H7CLS1svDJP8UValxuk4zNu98/Zd1+i/G9SxoOYOB75
         xM09SOZaRFAsXrkPvql7BIS5NVs2OU2lwa4/M1r2uztGbG4Yv7SVY00qk2OlDCvCcM
         huCoka8KDUSCfaXXCRwAFNZ/bvoQDDs99FOIPl8rfQ3qTu6obwyP8Sg8i5NRiuBuRW
         ZHkYf3R/jVP/YaMZ8w7RzqyzhG1B7bhqXgd37c5pmUm1r7DzNBwT8qhoewGxAJZ6Pw
         FlkjWohYaw8G4v5r/Wyq8Urs2xTfX63ufXi+wvOcEle5kjYgF7evwe8B3pXlGRdcQz
         k3/zIM9VykZlg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
Subject: [pull request][net 0/9] mlx5 fixes 2022-07-06
Date:   Wed,  6 Jul 2022 16:13:00 -0700
Message-Id: <20220706231309.38579-1-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


The following changes since commit a069a90554168ac4cc81af65f000557d2a8a0745:

  Revert "tls: rx: move counting TlsDecryptErrors for sync" (2022-07-06 13:10:59 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-07-06

for you to fetch changes up to 5b759bf2f9d73db05369aef2344502095c4e5e73:

  net/mlx5e: Ring the TX doorbell on DMA errors (2022-07-06 16:11:56 -0700)

----------------------------------------------------------------
mlx5-fixes-2022-07-06

----------------------------------------------------------------
Eli Cohen (1):
      net/mlx5: TC, allow offload from uplink to other PF's VF

Gal Pressman (1):
      net/mlx5e: Fix capability check for updating vnic env counters

Liu, Changcheng (1):
      net/mlx5: Lag, correct get the port select mode str

Mark Bloch (1):
      net/mlx5: Lag, decouple FDB selection and shared FDB

Maxim Mikityanskiy (1):
      net/mlx5e: Ring the TX doorbell on DMA errors

Paul Blakey (1):
      net/mlx5e: Fix enabling sriov while tc nic rules are offloaded

Roi Dayan (1):
      net/mlx5e: CT: Use own workqueue instead of mlx5e priv

Tariq Toukan (2):
      net/mlx5e: kTLS, Fix build time constant test in TX
      net/mlx5e: kTLS, Fix build time constant test in RX

 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 20 ++++++-----
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  3 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    | 39 +++++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |  5 +--
 .../net/ethernet/mellanox/mlx5/core/lag/debugfs.c  | 14 ++++++--
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  | 18 ++++++----
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  |  3 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |  5 ++-
 11 files changed, 76 insertions(+), 38 deletions(-)
