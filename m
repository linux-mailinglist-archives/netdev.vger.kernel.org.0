Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42AA6232AB
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiKISlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiKISlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:41:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22A315FD3
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:40:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2FB4B81F90
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 18:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D049C433C1;
        Wed,  9 Nov 2022 18:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668019256;
        bh=3dypfJ1CWr/phVoQr76CyZuBgVoHuxnNcbqTzxvCSwk=;
        h=From:To:Cc:Subject:Date:From;
        b=IWvenZm7wsWGt/S3LZHgmpXnOzMsRJrzcXaCgovPBiS9Ds2CxUnDt6nImlpsaVPlN
         WCIkcdE5rUCmhFfAgu82FlGDo3utDDqTQah5JF/ogb0XiFzEoFWe4dvT2zMfyjUra3
         ctfhttw3x2B/ITzPj+iqOoGBuJhZdQgJgky7N5Q2J0jCuzZu2kBI4UH/r59+aX9dae
         rgxIEZMs5xTyUqzofaShbQKGDMun8Bb0zS0axXdzzdykKU6SDkxsdkJRbS73lvTzuu
         DP9Oqud7ddUFNVTfNWS2EuCtNXr9b1KkTkYL1YiLGBjJ38s/cMrYucO7vLFualMqoj
         SBTFXd0+mNHNA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][V3 net 00/10] mlx5 fixes 2022-11-02
Date:   Wed,  9 Nov 2022 10:40:40 -0800
Message-Id: <20221109184050.108379-1-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

v2->v3:
 - toss: net/mlx5: Fix possible deadlock on mlx5e_tx_timeout_work

v1->v2:
 - Fix 32bit build issue.

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.

The following changes since commit 27c064ae14d1a80c790ce019759500c95a2a9551:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf (2022-11-09 14:57:42 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-11-09

for you to fetch changes up to 7f1a6d4b9e820b08479a07f6e14c36ccfa641751:

  net/mlx5e: TC, Fix slab-out-of-bounds in parse_tc_actions (2022-11-09 10:30:43 -0800)

----------------------------------------------------------------
mlx5-fixes-2022-11-09

----------------------------------------------------------------
Chris Mi (1):
      net/mlx5: E-switch, Set to legacy mode if failed to change switchdev mode

Jianbo Liu (1):
      net/mlx5e: TC, Fix wrong rejection of packet-per-second policing

Maxim Mikityanskiy (2):
      net/mlx5e: Add missing sanity checks for max TX WQE size
      net/mlx5e: Fix usage of DMA sync API

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
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  7 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 27 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 14 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  5 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 14 ++--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 18 +----
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  | 14 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  3 +-
 13 files changed, 149 insertions(+), 115 deletions(-)
