Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E28067168F
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 09:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjARIwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 03:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjARIwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 03:52:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693A853FBE
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 00:04:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 180B1B81B3E
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FC5C433D2;
        Wed, 18 Jan 2023 08:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674029063;
        bh=uO4OgFD3i4GyqIg8AYi04qdkoc7n8UqLiTwISd3Ry0s=;
        h=From:To:Cc:Subject:Date:From;
        b=aTStC6ykJ9tiF0BmcnAqZvEAM36jE5UtACdVvv3BHYbl9tcUzkyOT0v+VEwx39fiM
         hNuIu3tKFx2fG6OEK+DehS49/oZuMgcLK0xqVRDREh9y9FBIFocBDqIWZcZaqdCFhC
         q4bUX2hdBMsS9jF7XF2J5M+JnIbjeuLOQSO1qOCe+X/8BEPeALbz+HWSfQuXhpqbr3
         4bX4+0dZ3NC/dBxsXHzkjhUWHnOZgbeXQMEbOgp2xK3x/M8UQihZ6EOJWjbdHK4sQC
         +vJmrPJDUBlG9qU4GOT4FqSmmOXl5qMDbf1wZk+NxVeK7Cy1Lb/XsoLcsa2P0ZbCcb
         W1FpsL5qrlQCA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net 00/10] mlx5 fixes 2023-01-18
Date:   Wed, 18 Jan 2023 00:04:04 -0800
Message-Id: <20230118080414.77902-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
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


The following changes since commit 010a74f52203eae037dd6aa111ba371f6a2dedc5:

  Merge tag 'for-net-2023-01-17' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth (2023-01-17 19:19:00 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2023-01-18

for you to fetch changes up to 2c1e1b949024989e20907b84e11a731a50778416:

  net: mlx5: eliminate anonymous module_init & module_exit (2023-01-18 00:01:39 -0800)

----------------------------------------------------------------
mlx5-fixes-2023-01-18

----------------------------------------------------------------
Adham Faris (1):
      net/mlx5e: Remove redundant xsk pointer check in mlx5e_mpwrq_validate_xsk

Chris Mi (2):
      net/mlx5e: Set decap action based on attr for sample
      net/mlx5: E-switch, Fix switchdev mode after devlink reload

Leon Romanovsky (2):
      net/mlx5e: Remove optimization which prevented update of ESN state
      net/mlx5e: Protect global IPsec ASO

Maor Dickman (2):
      net/mlx5: E-switch, Fix setting of reserved fields on MODIFY_SCHEDULING_ELEMENT
      net/mlx5e: QoS, Fix wrongfully setting parent_element_id on MODIFY_SCHEDULING_ELEMENT

Randy Dunlap (1):
      net: mlx5: eliminate anonymous module_init & module_exit

Vlad Buslov (1):
      net/mlx5e: Avoid false lock dependency warning on tc_ht even more

Yang Yingliang (1):
      net/mlx5: fix missing mutex_unlock in mlx5_fw_fatal_reporter_err_work()

 drivers/net/ethernet/mellanox/mlx5/core/en/htb.c       |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c    |  3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c |  5 ++---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |  7 ++-----
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c        | 12 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c        |  3 +++
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c      | 18 +++---------------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c      |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c       |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c         |  8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/qos.c          |  3 +--
 drivers/net/ethernet/mellanox/mlx5/core/qos.h          |  2 +-
 12 files changed, 27 insertions(+), 40 deletions(-)
