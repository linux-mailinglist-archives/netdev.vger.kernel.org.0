Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492F36D8D27
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234149AbjDFCCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234704AbjDFCCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:02:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1237AA4
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:02:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2135B621A1
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768DEC433D2;
        Thu,  6 Apr 2023 02:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746562;
        bh=ncwyDJORjNYKnCNL50TzXseOdGA/APM7FWNBcVd/a4Y=;
        h=From:To:Cc:Subject:Date:From;
        b=ZqoLOWU5A0HesZ2kQrN5Y+xpkdqDE604ttTis9iq3amZHq8OR0Htd8w6pCVZF03jm
         Z+7xXDiIswwx2NE/mSj71C9m2nR6f73z589c3AWx4+wvGoeWBljXM/HAmq28cvM+OP
         tvjEr9dN6aECQRvgIeTrFWc8waBcDJIIzzSMhhAur00YeJSavFJqR/054CS8UlpN9M
         yoWBdAkJgvW5sBtf7f3UH9dYQS+EeB/pwJwBIeTY37NX1E23sXWJogYJOl+B9ihlVs
         caQXn1MfyCHkss2EPxeTRM08mW0MH4wB2ZBGBD6GFlYZ79HhpyLTZte/3+xV7Qtomc
         HEBjqh9nv1PyQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2023-04-05
Date:   Wed,  5 Apr 2023 19:02:17 -0700
Message-Id: <20230406020232.83844-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series provides misc updates to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 8b0f256530d97f2a2310c4f8336ea2c477c8e6c4:

  net/sched: sch_mqprio: use netlink payload helpers (2023-04-05 18:12:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-04-05

for you to fetch changes up to b0d87ed27be7853af8f897c3cfcb9ddc5179a2a3:

  net/mlx5e: Fix SQ SW state layout in SQ devlink health diagnostics (2023-04-05 18:57:34 -0700)

----------------------------------------------------------------
mlx5-updates-2023-04-05

From Paul:
 - TC action parsing cleanups
 - Correctly report stats for missed packets
 - Many CT actions limitations removed due to hw misses will now
   continue from the relevant tc ct action in software.

From Adham:
 - RQ/SQ devlink health diagnostics layout fixes

From Gal And Rahul:
 - PTP code cleanup and cyclecounter shift value improvement

----------------------------------------------------------------
Adham Faris (2):
      net/mlx5e: Fix RQ SW state layout in RQ devlink health diagnostics
      net/mlx5e: Fix SQ SW state layout in SQ devlink health diagnostics

Emeel Hakim (1):
      net/mlx5e: Remove redundant macsec code

Gal Pressman (1):
      net/mlx5e: Rename misleading skb_pc/cc references in ptp code

Paul Blakey (10):
      net/mlx5e: Set default can_offload action
      net/mlx5e: TC, Remove unused vf_tun variable
      net/mlx5e: TC, Move main flow attribute cleanup to helper func
      net/mlx5e: CT: Use per action stats
      net/mlx5e: TC, Remove CT action reordering
      net/mlx5e: TC, Remove special handling of CT action
      net/mlx5e: TC, Remove multiple ct actions limitation
      net/mlx5e: TC, Remove tuple rewrite and ct limitation
      net/mlx5e: TC, Remove mirror and ct limitation
      net/mlx5e: TC, Remove sample and ct limitation

Rahul Rameshbabu (1):
      net/mlx5: Update cyclecounter shift value to improve ptp free running mode precision

 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |  22 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |  10 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |  10 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/accept.c |  10 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    |  20 --
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.h    |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c |  66 +----
 .../ethernet/mellanox/mlx5/core/en/tc/act/drop.c   |  10 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/pedit.c  |  10 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/ptype.c  |  10 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/sample.c |  20 --
 .../ethernet/mellanox/mlx5/core/en/tc/act/trap.c   |  10 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/tun.c    |  10 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/vlan.c   |  10 -
 .../mellanox/mlx5/core/en/tc/act/vlan_mangle.c     |  10 -
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 169 +++----------
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |  31 +--
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |  11 +-
 .../mellanox/mlx5/core/en_accel/macsec_fs.c        |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 279 ++++++---------------
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |   2 +-
 21 files changed, 159 insertions(+), 574 deletions(-)
