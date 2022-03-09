Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BDE4D3AE1
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 21:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237977AbiCIUQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 15:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237522AbiCIUQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 15:16:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C997150065
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 12:15:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58D8F618C8
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 20:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDE0C340EC;
        Wed,  9 Mar 2022 20:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646856923;
        bh=uVA99UsMWfyLrtuNs/k05ySYHyLbfUg/cGilMiyocP8=;
        h=From:To:Cc:Subject:Date:From;
        b=f68x9fQOwjcgv+b+KBDGnI0Kf6QmWBko1NizHuZ+IQl5ByGQ4iouEcDCZ2LBbyApw
         JFNFCafcYrATmz/r+4XX3mVeEjWqqWutOO75hJ/hmSrX/FBys6pXPV7TWDQaPh6o/L
         LDc/KAQfFbc5eELDOU2vRCUE8GGWJitHwErX94pB57hifyGDYZ6EXGZCvF0WouJbd2
         KaGNt4Ye0T+NsvdyAswNhpBEAylL8wWV3oIj9q0qyrVnh3iGxCM3v2U8E01fYWtTtJ
         OVIE3/4yEHAn/DxAAuETJjPdL6WQxnE7dqE6XadEYALaP3zDM0ZMb9GsWs6WUwjVxi
         VZvswTevGbmQA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 0/5] mlx5 fixes 2022-03-09
Date:   Wed,  9 Mar 2022 12:15:12 -0800
Message-Id: <20220309201517.589132-1-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit cc7e2f596e64783ded1feebc55445199c9bd929e:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec (2022-03-09 14:48:11 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-03-09

for you to fetch changes up to 99a2b9be077ae3a5d97fbf5f7782e0f2e9812978:

  net/mlx5e: SHAMPO, reduce TIR indication (2022-03-09 11:39:35 -0800)

----------------------------------------------------------------
mlx5-fixes-2022-03-09

----------------------------------------------------------------
Ben Ben-Ishay (1):
      net/mlx5e: SHAMPO, reduce TIR indication

Dima Chumak (1):
      net/mlx5: Fix offloading with ESWITCH_IPV4_TTL_MODIFY_ENABLE

Mohammad Kabat (1):
      net/mlx5: Fix size field in bufferx_reg struct

Moshe Shemesh (1):
      net/mlx5: Fix a race on command flush flow

Roi Dayan (1):
      net/mlx5e: Lag, Only handle events from highest priority multipath entry

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c           | 15 ++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c        |  3 ---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c       |  3 +--
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c        | 11 ++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c |  3 ---
 include/linux/mlx5/mlx5_ifc.h                           |  5 ++---
 6 files changed, 19 insertions(+), 21 deletions(-)
