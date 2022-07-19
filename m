Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AA857A846
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbiGSUfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbiGSUfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:35:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D49422D5
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 13:35:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3945B81D3D
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 20:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CABCC341C6;
        Tue, 19 Jul 2022 20:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658262934;
        bh=2ijefnf70k3VB0zY+/8sGz3XNRLeivWovwjf/M3ftY8=;
        h=From:To:Cc:Subject:Date:From;
        b=GtC6CX+cJJuSDGHLe2HhfnOQiM/DxSctMwYWAJ9hrX3mLGmu6xqueJJggZ3nDAP++
         NvE3BooxuiF6MJ9G9ZYWh/uN0nEAB9rfJnfDFVWEM4xR6HS+0DV3LQRvLhGGIfUPMH
         ZGw6sbJQbxrJAThO0u669P4U9vNgVVizp8YMDUG5YLuEZNS4F64YC3axp7gnDTEukL
         49dsdqRmqkO+f2N3ACTI5Bid5wrkJqIYW0EmAW2teKyGvw26+x0zNsOx9ZEmY6VHJC
         AT+SohrCyr5PiaADvN0c4UVwo5giJNxCFzadcqj4arjSvfnWRIaRAMTN+740T2LxK5
         YSUbpnhbJ4AJg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next V2 00/13] mlx5 updates 2022-07-17
Date:   Tue, 19 Jul 2022 13:35:16 -0700
Message-Id: <20220719203529.51151-1-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

v1->v2:
 1) toss, "net/mlx5e: Expose rx_oversize_pkts_buffer counter", it might
    need some extra work

Misc updates for mlx5 driver.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 769e2695be4132fe0be4c964c9d8ea97c74d9a6a:

  net: dsa: microchip: fix the missing ksz8_r_mib_cnt (2022-07-19 15:33:51 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-07-17

for you to fetch changes up to 22df2e93622fdb1672c2ba8ff1d2fc90980b3358:

  net/mlx5: CT: Remove warning of ignore_flow_level support for non PF (2022-07-19 13:32:54 -0700)

----------------------------------------------------------------
mlx5-updates-2022-07-17

1) Add resiliency for lost completions for PTP TX port timestamp

2) Report Header-data split state via ethtool

3) Decouple HTB code from main regular TX code

----------------------------------------------------------------
Aya Levin (2):
      net/mlx5: Expose ts_cqe_metadata_size2wqe_counter
      net/mlx5e: Add resiliency for PTP TX port timestamp

Gal Pressman (1):
      net/mlx5e: Report header-data split state through ethtool

Moshe Tal (7):
      net/mlx5e: Fix mqprio_rl handling on devlink reload
      net/mlx5e: HTB, move ids to selq_params struct
      net/mlx5e: HTB, move section comment to the right place
      net/mlx5e: HTB, move stats and max_sqs to priv
      net/mlx5e: HTB, remove priv from htb function calls
      net/mlx5e: HTB, change functions name to follow convention
      net/mlx5e: HTB, move htb functions to a new file

Roi Dayan (1):
      net/mlx5: CT: Remove warning of ignore_flow_level support for non PF

Saeed Mahameed (2):
      net/mlx5e: HTB, reduce visibility of htb functions
      net/mlx5e: HTB, hide and dynamically allocate mlx5e_htb structure

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  20 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/htb.c   | 722 ++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/htb.h   |  46 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |  37 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   | 813 +++------------------
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h   |  37 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/selq.c  |  51 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/selq.h  |   4 +-
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 228 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  10 +
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |   2 +-
 include/linux/mlx5/mlx5_ifc.h                      |   6 +-
 20 files changed, 1157 insertions(+), 861 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/htb.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/htb.h
