Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC57748108C
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 07:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239041AbhL2Gx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 01:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbhL2Gx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 01:53:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EF4C061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 22:53:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89B6C61445
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB524C36AE9;
        Wed, 29 Dec 2021 06:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640760836;
        bh=3RK3el5xKh6lSszS8NZdWmeWpXl2Rmr4FaDgD3EOtpg=;
        h=From:To:Cc:Subject:Date:From;
        b=d+r9aYOuynFeFD8HHG18ptxUd2aL/ktqzr/QdW8Is/dbrDmCXyLdvFg9sjOl0gvIl
         EbVmFRHchpBE+B9oLvloejGKfjis9/UhJ46iVIQ4P0sYGDhZNKvLaVxHRvCQ6Senvn
         HRbtWrkgjuXMaDsP6zctkld/8BS9Sh1wcsShlZPSj/eOtrtsS9U8/Gdio/h1wsITZY
         S0aBbYpAA0Hw4FLS2xaEVPdi9QF8ScK8y9/tqZH+gb6OmPDH21wDPyYZhVMXGd49WD
         qLnho8RYJro9cOV57zhURhxSgR4kS7AMk7NcJ6D6MXsRK15a0Sbp2N+vLv04TyWG0i
         6ueCDdM8KHv1A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 0/2] mlx5 fixes 2021-12-28
Date:   Tue, 28 Dec 2021 22:53:50 -0800
Message-Id: <20211229065352.30178-1-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.
There will be a very small trivial conflict when net merged with
net-next,

++<<<<<<< HEAD
++                              goto err_out;
++||||||| 391e5975c020
++                              return err;
++=======
                                goto err_out;
+ 
+                       attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
++>>>>>>> this pr

To solve just take the hunk from net (this pr)

Thanks,
Saeed.


The following changes since commit 9665e03a8de5df719904611e03f908cd5b9f52f6:

  Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue (2021-12-28 16:19:10 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-12-28

for you to fetch changes up to 992d8a4e38f0527f24e273ce3a9cd6dea1a6a436:

  net/mlx5e: Fix wrong features assignment in case of error (2021-12-28 22:42:50 -0800)

----------------------------------------------------------------
mlx5-fixes-2021-12-28

----------------------------------------------------------------
Gal Pressman (1):
      net/mlx5e: Fix wrong features assignment in case of error

Roi Dayan (1):
      net/mlx5e: TC, Fix memory leak with rules with internal port

 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 11 +++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c   |  2 ++
 2 files changed, 7 insertions(+), 6 deletions(-)
