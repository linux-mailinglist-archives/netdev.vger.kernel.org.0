Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D72363735C
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiKXIKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKXIKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:10:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C98D288A
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:10:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B37362022
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7E6C433C1;
        Thu, 24 Nov 2022 08:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669277451;
        bh=OB4Tcde17LifWir4ibmctzH8QupA6Es9YNJ8YnIiW+E=;
        h=From:To:Cc:Subject:Date:From;
        b=ITn/XGXUWMqin2XTzXYw91c7aGO2NjE1AsFzit6FmWcSFlcbtsoeVjOS6uY0M1Ox3
         Yq2odPfaYrpYoX1sH/mmCS6nlRa1eymwt5EFl/ojK4EHVu+4uozwgABO5VnZsk+dYr
         Xdm3W2SypIakj2FS8GQuY2T5atTcpBk3KC09y11XvUyFJA/EeecNYuzqEEC4IQbKBz
         3AxCxk3SIIhHn3Y7+M4JRtqngQcwglIf/F1llJ4GCpwkXaejEwMNGTwwxqUIo5b6mU
         yTG2twBnEfQvcGkXL1sczNdwWFndDYspfmwHLn16W5pe4yPu5+yrv8tMSQCZpx93JI
         O6f8iSId8fYGA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net 00/15] mlx5 fixes 2022-11-24
Date:   Thu, 24 Nov 2022 00:10:25 -0800
Message-Id: <20221124081040.171790-1-saeed@kernel.org>
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

Focusing on error handling and proper memory management in mlx5, in
general and in the newly added macsec module.

I still have few fixes left in my queue and I hope those will be the
last ones for mlx5 for this cycle.

Please pull and let me know if there is any problem.

Happy thanksgiving.

Thanks,
Saeed.


The following changes since commit cd07eadd5147ffdae11b6fd28b77a3872f2a2484:

  octeontx2-pf: Add check for devm_kcalloc (2022-11-24 08:34:45 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-11-24

for you to fetch changes up to 9034b29251818ab7b4b38bf6ca860cee45d2726a:

  net/mlx5e: MACsec, block offload requests with encrypt off (2022-11-24 00:03:23 -0800)

----------------------------------------------------------------
mlx5-fixes-2022-11-24

----------------------------------------------------------------
Chris Mi (2):
      net/mlx5: E-switch, Destroy legacy fdb table when needed
      net/mlx5: E-switch, Fix duplicate lag creation

Dan Carpenter (1):
      net/mlx5e: Fix a couple error codes

Emeel Hakim (3):
      net/mlx5e: MACsec, fix add Rx security association (SA) rule memory leak
      net/mlx5e: MACsec, remove replay window size limitation in offload path
      net/mlx5e: MACsec, block offload requests with encrypt off

Raed Salem (5):
      net/mlx5e: MACsec, fix RX data path 16 RX security channel limit
      net/mlx5e: MACsec, fix memory leak when MACsec device is deleted
      net/mlx5e: MACsec, fix update Rx secure channel active field
      net/mlx5e: MACsec, fix mlx5e_macsec_update_rxsa bail condition and functionality
      net/mlx5e: MACsec, fix Tx SA active field update

Roi Dayan (1):
      net/mlx5e: Fix use-after-free when reverting termination table

YueHaibing (3):
      net/mlx5: DR, Fix uninitialized var warning
      net/mlx5: Fix uninitialized variable bug in outlen_write()
      net/mlx5e: Use kvfree() in mlx5e_accel_fs_tcp_create()

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  |   4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  | 138 +++++++++------------
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.h  |   6 +-
 .../mellanox/mlx5/core/en_accel/macsec_fs.c        |  17 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   8 ++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   7 ++
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   5 +-
 .../mellanox/mlx5/core/steering/dr_table.c         |   5 +-
 include/linux/mlx5/mlx5_ifc.h                      |   7 --
 12 files changed, 105 insertions(+), 101 deletions(-)
