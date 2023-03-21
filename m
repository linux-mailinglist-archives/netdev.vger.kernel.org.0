Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC0A6C3C72
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjCUVLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjCUVLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:11:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1FC57D29
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 14:11:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C76CC61E64
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 21:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260DEC433EF;
        Tue, 21 Mar 2023 21:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679433097;
        bh=L0ksUMFkmq7nFfeEydBYK1poi0AOulhN2z6BGpUHFdg=;
        h=From:To:Cc:Subject:Date:From;
        b=F31GXQyDW06uae6RxnQ2d6cQW1iugA72iJkCDRGVZ6Bd/dztQaG240N0ruNYFAhxo
         FfYzVC6++j+7gbaikjvQCpcTpiKh7EcF6GuoGkgYN8BJy1hRCWN+m/ud9RMVDJmbXp
         zqpXNufDKxzwTbjfJx7vcoSCv25yDU3wLvVO7R1EL7FXqaAeLx4NwEpwqlnYgTyMc9
         4RxBEEySXptUsuhZBA55akM5pw+RqpbHkzkGApwIURgoVvnT1Tg5LdWUHN/E47IsdG
         Kqo+TqdRfOFooWAVdud8OwrE4N3SWfXNrxbqCLVZbRXFeRDYWOYc1rs2EHeMqCCfrn
         b5uEpCQ+YxlvQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net 0/7] mlx5 fixes 2023-03-21
Date:   Tue, 21 Mar 2023 14:11:28 -0700
Message-Id: <20230321211135.47711-1-saeed@kernel.org>
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

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Conflict notice:
when merged into net-next, this series will cause a conflict in file:
drivers/net/ethernet/mellanox/mlx5/core/en_tc.

to resolve just to DON'T take any changes to the missing function 
mlx5e_hairpin_params_init() inside that file, that function doesn't
exist there anymore, we will submit a separate patch to fix net-next.

Thanks,
Saeed.


The following changes since commit f038f3917baf04835ba2b7bcf2a04ac93fbf8a9c:

  octeontx2-vf: Add missing free for alloc_percpu (2023-03-20 22:00:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2023-03-21

for you to fetch changes up to 640fcdbcf27fc62de9223f958ceb4e897a00e791:

  net/mlx5: E-Switch, Fix an Oops in error handling code (2023-03-21 14:06:32 -0700)

----------------------------------------------------------------
mlx5-fixes-2023-03-21

----------------------------------------------------------------
Dan Carpenter (1):
      net/mlx5: E-Switch, Fix an Oops in error handling code

Emeel Hakim (1):
      net/mlx5e: Overcome slow response for first macsec ASO WQE

Gavin Li (2):
      net/mlx5e: Set uplink rep as NETNS_LOCAL
      net/mlx5e: Block entering switchdev mode with ns inconsistency

Lama Kayal (1):
      net/mlx5: Fix steering rules cleanup

Maher Sanalla (1):
      net/mlx5: Read the TC mapping of all priorities on ETS query

Roy Novich (1):
      net/mlx5e: Initialize link speed to zero

 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c |  9 ++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c    |  6 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c     |  6 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c       |  2 +-
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c         |  3 +--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c     |  1 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 19 +++++++++++++++++++
 7 files changed, 39 insertions(+), 7 deletions(-)
