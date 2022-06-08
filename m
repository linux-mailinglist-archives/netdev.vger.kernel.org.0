Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACDD543BDB
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 20:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiFHS7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 14:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbiFHS7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 14:59:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5EA3AA5A
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 11:59:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39CE461C43
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 18:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E5DC34116;
        Wed,  8 Jun 2022 18:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654714753;
        bh=tJfaw0A5NGakxDgBNWDrvt3ZFNc0E1NHaVYYnh42+HQ=;
        h=From:To:Cc:Subject:Date:From;
        b=URJGhUzLGw2PJuXF8beONdgMzxWoADdFUyBnz+AH+fVfxr/FgEtCjkmUPvrzI0uGd
         EmFBf3X7wWmo7UtX0Zxc0i3Qr0mdi9VR0HixDGTlnnIbetKqeJZW66kHmDEE+9FGo+
         EkzuUNpXQaGIH3kmUMo5gcbJ7G1vsY0j+5XpjGJUIyvz7bC0AUs9FyLITU313QBK8Y
         5/Vpjy7aMLrHGcdeF6UnGx3oUkSQ2ZuSjKIBe8akb04LcHNpqGg8uRfXssMg+O1/9r
         uDe7rXV18Zu5+xZXQcU7/Ncmi+GDbR+9gSQeoWkgjM74GDhX9toaPL7rM22V2Et/bs
         CIzO/vCuF5p8Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 0/6] mlx5 fixes 2022-06-08
Date:   Wed,  8 Jun 2022 11:58:49 -0700
Message-Id: <20220608185855.19818-1-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


The following changes since commit a6958951ebe7db60e84b2437ee53aa4843028726:

  au1000_eth: stop using virt_to_bus() (2022-06-08 11:32:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-06-08

for you to fetch changes up to 8fa5e7b20e01042b14f8cd684d2da9b638460c74:

  net/mlx5: fs, fail conflicting actions (2022-06-08 11:39:44 -0700)

----------------------------------------------------------------
mlx5-fixes-2022-06-08

----------------------------------------------------------------
Feras Daoud (1):
      net/mlx5: Rearm the FW tracer after each tracer event

Lukas Bulwahn (1):
      MAINTAINERS: adjust MELLANOX ETHERNET INNOVA DRIVERS to TLS support removal

Mark Bloch (2):
      net/mlx5: E-Switch, pair only capable devices
      net/mlx5: fs, fail conflicting actions

Paul Blakey (1):
      net/mlx5e: CT: Fix cleanup of CT before cleanup of TC ct rules

Saeed Mahameed (1):
      Revert "net/mlx5e: Allow relaxed ordering over VFs"

 MAINTAINERS                                        |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      | 18 -----------
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  7 +++--
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |  5 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 31 +++++++++----------
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  9 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 35 ++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  | 10 +++++++
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  1 -
 10 files changed, 74 insertions(+), 46 deletions(-)
