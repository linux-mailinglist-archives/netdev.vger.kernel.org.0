Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7446176F5
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 07:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiKCG4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 02:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKCG4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 02:56:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5813FD2
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 23:56:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FFA4B82520
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 06:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F093AC433C1;
        Thu,  3 Nov 2022 06:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667458564;
        bh=mHm4OL3kx0lL+voYY4HeQDdxdbRTLPLGgZWYYwxXpDM=;
        h=From:To:Cc:Subject:Date:From;
        b=e2evmnhBPO+u8uCK77iqaOdOjC/BGGZzMLI7pHL4r/nG4y88Ebod86XfTZNgax5Ul
         d6ZlBVCsHgPJh9aoOMvnZxTkfalmyaeXU4bOjr13v5ygueJdl+1zj50h1yIeKkFY9e
         OIvIq8dBRzFZ0BGE8FcJut4OcFZcXGuUATLC5Hl0GpqrmyoWKOoJHNeRg+75CMb0g4
         bLGUybFJXb6FYv9mD1MOEk0uZdu9XfZ2Zh3JhT8ba+blAaqeOdN9V0+O83IX5Rk+Vd
         1nfiah7H2SCwbVFfs59Or0V+r6a7kbHHZJONYse4TTOw9MPacPaTr7xAVWmZ6H5eO/
         km75PlnIL7XBQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net 00/11] mlx5 fixes 2022-11-02
Date:   Wed,  2 Nov 2022 23:55:36 -0700
Message-Id: <20221103065547.181550-1-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


The following changes since commit 768b3c745fe5789f2430bdab02f35a9ad1148d97:

  ipv6: fix WARNING in ip6_route_net_exit_late() (2022-11-02 20:47:14 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-11-02

for you to fetch changes up to f1ec3df7835e6df6090f65ff682978281230f9e6:

  net/mlx5e: TC, Fix slab-out-of-bounds in parse_tc_actions (2022-11-02 23:53:51 -0700)

----------------------------------------------------------------
mlx5-fixes-2022-11-02

----------------------------------------------------------------
Chris Mi (1):
      net/mlx5: E-switch, Set to legacy mode if failed to change switchdev mode

Jianbo Liu (1):
      net/mlx5e: TC, Fix wrong rejection of packet-per-second policing

Maxim Mikityanskiy (2):
      net/mlx5e: Add missing sanity checks for max TX WQE size
      net/mlx5e: Fix usage of DMA sync API

Moshe Shemesh (1):
      net/mlx5: Fix possible deadlock on mlx5e_tx_timeout_work

Roi Dayan (3):
      net/mlx5e: Fix tc acts array not to be dependent on enum order
      net/mlx5e: E-Switch, Fix comparing termination table instance
      net/mlx5e: TC, Fix slab-out-of-bounds in parse_tc_actions

Roy Novich (1):
      net/mlx5: Allow async trigger completion execution on single CPU systems

Shay Drory (1):
      net/mlx5: fw_reset: Don't try to load device in case PCI isn't working

Vlad Buslov (1):
      net/mlx5: Bridge, verify LAG state when adding bond to bridge

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 11 ++-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    | 31 ++++++++
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    | 92 ++++++++--------------
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  | 24 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 13 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 27 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 14 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  6 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 14 ++--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 18 +----
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  | 14 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  3 +-
 13 files changed, 154 insertions(+), 117 deletions(-)
