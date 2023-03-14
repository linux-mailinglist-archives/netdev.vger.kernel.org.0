Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060CD6B8AB5
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjCNFnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjCNFnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:43:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49ACC91B7F
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:42:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE18BB81185
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63532C433D2;
        Tue, 14 Mar 2023 05:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678772563;
        bh=bEzyzFRKMQW/CQrtvFTn1C6MYfWbLG5s1uzblUW1TFM=;
        h=From:To:Cc:Subject:Date:From;
        b=rRd3XYB7F6F/s7nbV1Mtp3kxO8+FJAPwB83MYhoLMlv38NYlTon8z5aj7C5Ld+Knv
         TCmBUANo5Pz5lOi535//isOZYwmNIqPDuA6nhQfQZEbw0ZzVQpCl3DNt2a+mhP7a52
         SGXfx1pXtkGySoflQEy1Vj3yqljWFkM6livwJetlMAXhnBHQYS4Lu5lc7ZBHKVNwEB
         aOOamvTlpvWzx6pfPEu7sHBTeJbEM2RXa4rk2nL69yWM2F21uv0LdmAEUiWy5PAAJS
         FU70PfLu6psm6VILzUsF43a1wfOhljsy9g0E5cTtjMkweszotFoDjbGBZAOGH0lrq7
         HWyf98/cjXK1Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2023-03-13
Date:   Mon, 13 Mar 2023 22:42:19 -0700
Message-Id: <20230314054234.267365-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series adds misc updates.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit bcc858689db5f2e5a8d4d6e8bc5bb9736cd80626:

  net: Use of_property_present() for testing DT property presence (2023-03-13 17:07:52 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-03-13

for you to fetch changes up to 1a8bcf10679345c624c656e113796f14473db1e9:

  net/mlx5e: Enable TC offload for egress MACVLAN over bond (2023-03-13 22:39:06 -0700)

----------------------------------------------------------------
mlx5-updates-2023-03-13

1) Trivial cleanup patches
2) By Sandipan Patra: Implement thermal zone to report NIC temperature
3) Adham Faris, Improves devlink health diagnostics for netdev objects
4) From Maor, Enable TC offload for egress and engress MACVLAN over bond
5) From Gal, add devlink hairpin queues parameters to replace debugfs
   as was discussed in [1]:
[1] https://lore.kernel.org/all/20230111194608.7f15b9a1@kernel.org/

----------------------------------------------------------------
Adham Faris (4):
      net/mlx5e: Rename RQ/SQ adaptive moderation state flag
      net/mlx5e: Stringify RQ SW state in RQ devlink health diagnostics
      net/mlx5e: Expose SQ SW state as part of SQ health diagnostics
      net/mlx5e: Add XSK RQ state flag for RQ devlink health diagnostics

Gal Pressman (3):
      net/mlx5: Move needed PTYS functions to core layer
      net/mlx5e: Add devlink hairpin queues parameters
      net/mlx5e: Add more information to hairpin table dump

Jiri Pirko (1):
      net/mlx5: Add comment to mlx5_devlink_params_register()

Maor Dickman (3):
      net/mlx5e: TC, Extract indr setup block checks to function
      net/mlx5e: Enable TC offload for ingress MACVLAN over bond
      net/mlx5e: Enable TC offload for egress MACVLAN over bond

Moshe Shemesh (2):
      net/mlx5: remove redundant clear_bit
      net/mlx5: Stop waiting for PCI up if teardown was triggered

Rahul Rameshbabu (1):
      net/mlx5e: Correct SKB room check to use all room in the fifo

Sandipan Patra (1):
      net/mlx5: Implement thermal zone

 .../ethernet/mellanox/mlx5/devlink.rst             |  35 +++++
 Documentation/networking/devlink/mlx5.rst          |  12 ++
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  71 ++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  17 ++-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  | 157 +--------------------
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h  |  14 --
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  63 ++++++---
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |  50 ++++++-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |  46 ++++++
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  10 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  58 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     | 151 ++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/thermal.c  | 108 ++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/thermal.h  |  20 +++
 include/linux/mlx5/driver.h                        |   3 +
 include/linux/mlx5/mlx5_ifc.h                      |  26 ++++
 include/linux/mlx5/port.h                          |  16 +++
 28 files changed, 654 insertions(+), 250 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/thermal.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/thermal.h
