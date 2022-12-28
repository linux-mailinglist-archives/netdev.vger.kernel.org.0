Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D92658682
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 20:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbiL1Tnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 14:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiL1Tnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 14:43:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B908D261C
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 11:43:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D361615B3
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 19:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A925BC433F1;
        Wed, 28 Dec 2022 19:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672256618;
        bh=mYZ43z4KEuzt++vPr83E5EE7a2u0dXTDF9bO6uikNE4=;
        h=From:To:Cc:Subject:Date:From;
        b=m76NO3smq+Poz5x2oXoWg4UbWi6D/uT9jT8L6Aj5xiXB0gPqk35xWkbkSdlKwHrwb
         /DdVHQZR+TDuno33zmy5Tu/SHpFxwipiRAtARdP45NAuUko+IVFEatbY5qLK9WuwhW
         xeVJYWDGMgYGcd0rN9WiTh9KdOeNlL6W7Z+YVFChW/bC3svIgCVKR4y7C+iqz7z+yQ
         rBJTHpayQ9ETHabrdNYDzML0jYQYoB5OHgQrCOnQdtpvAcdWpd569cCFD3owx5w0L/
         pr/oa2HVTZCZhrez9InE6KblNMw+TFwainQ7bFjqAbFolEww3vWGLjWDfTsE+CM+67
         Am7K+7twQWykw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net 00/12] mlx5 fixes 2022-12-28
Date:   Wed, 28 Dec 2022 11:43:19 -0800
Message-Id: <20221228194331.70419-1-saeed@kernel.org>
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


The following changes since commit 40cab44b9089a41f71bbd0eff753eb91d5dafd68:

  net/sched: fix retpoline wrapper compilation on configs without tc filters (2022-12-28 12:11:32 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-12-28

for you to fetch changes up to 4d1c1379d71777ddeda3e54f8fc26e9ecbfd1009:

  net/mlx5: Lag, fix failure to cancel delayed bond work (2022-12-28 11:38:51 -0800)

----------------------------------------------------------------
mlx5-fixes-2022-12-28

----------------------------------------------------------------
Adham Faris (1):
      net/mlx5e: Fix hw mtu initializing at XDP SQ allocation

Chris Mi (2):
      net/mlx5e: CT: Fix ct debugfs folder name
      net/mlx5e: Always clear dest encap in neigh-update-del

Dragos Tatulea (1):
      net/mlx5e: IPoIB, Don't allow CQE compression to be turned on by default

Eli Cohen (1):
      net/mlx5: Lag, fix failure to cancel delayed bond work

Jiri Pirko (1):
      net/mlx5: Add forgotten cleanup calls into mlx5_init_once() error path

Maor Dickman (1):
      net/mlx5e: Set geneve_tlv_option_0_exist when matching on geneve option

Moshe Shemesh (1):
      net/mlx5: E-Switch, properly handle ingress tagged packets on VST

Shay Drory (3):
      net/mlx5: Fix io_eq_size and event_eq_size params validation
      net/mlx5: Avoid recovery in probe flows
      net/mlx5: Fix RoCE setting at HCA level

Tariq Toukan (1):
      net/mlx5e: Fix RX reporter for XSK RQs

 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  4 +--
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |  6 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  7 +----
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |  9 +++++-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c |  5 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  2 +-
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       |  7 ++++-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      | 33 ++++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 30 ++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  6 ++++
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |  6 ++++
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  4 +++
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  4 ++-
 include/linux/mlx5/device.h                        |  5 ++++
 include/linux/mlx5/mlx5_ifc.h                      |  3 +-
 16 files changed, 104 insertions(+), 28 deletions(-)
