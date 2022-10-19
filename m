Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C626D6039D7
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 08:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiJSGij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 02:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiJSGif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 02:38:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9FC6D55F
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:38:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68C886177E
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B376DC433C1;
        Wed, 19 Oct 2022 06:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666161513;
        bh=2WHJVlD8YQF1FlOYxDJnqihgCopbQqXoegSiJTzGzVE=;
        h=From:To:Cc:Subject:Date:From;
        b=eOdObgcba2iDSXmYixshZW1dwdcBVJXrfdA/u1X8EthPTwYU8AaY30qTHHCDHPzBm
         kl/YMyniba4j1t/h8rKOP8jC6voK+HrqfjJdulkFEawoZc4uuFOStbaNpaf8Z3HqWV
         5ONGTBkuu8o0EZTnoySWc2nlUN2+rK6SL4Q+tHRuQUdEXvNdLhVo2v7V5JM0N3ZKog
         jY53LgrM2RzohsNQ1Xa6Gku+vTX+eXzUTY1rtpYXedh8/7IOLKmU3BFRsrAhj/vvAE
         bWKuqbCUl6a9TVEVdbaikdMKmuDu2uX0qWqxmPFlOuHsQIOTGDz7/r+I5joaSghmQz
         cTgyq6OidNqOg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][RESEND net 00/16] mlx5 fixes 2022-10-14
Date:   Tue, 18 Oct 2022 23:37:57 -0700
Message-Id: <20221019063813.802772-1-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Sorry for the resend, apparently the patches themselves never made it in
the 1st posting.

Thanks,
Saeed.


The following changes since commit 0c93411795513a0e8dfcb5bcc7bab756b98bfc73:

  MAINTAINERS: nfc: s3fwrn5: Drop Krzysztof Opasiak (2022-10-14 09:14:49 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-10-14

for you to fetch changes up to 66c76edd8eae26bcf8cd376866c401cefaa1889b:

  net/mlx5e: Fix macsec sci endianness at rx sa update (2022-10-14 16:09:35 -0700)

----------------------------------------------------------------
mlx5-fixes-2022-10-14

----------------------------------------------------------------
Ariel Levkovich (1):
      net/mlx5e: TC, Reject forwarding from internal port to internal port

Aya Levin (1):
      net/mlx5e: Extend SKB room check to include PTP-SQ

Hyong Youb Kim (1):
      net/mlx5e: Do not increment ESN when updating IPsec ESN state

Moshe Shemesh (1):
      net/mlx5: Wait for firmware to enable CRS before pci_restore_state

Paul Blakey (1):
      net/mlx5e: Update restore chain id for slow path packets

Raed Salem (4):
      net/mlx5e: Fix macsec coverity issue at rx sa update
      net/mlx5e: Fix macsec rx security association (SA) update/delete
      net/mlx5e: Fix wrong bitwise comparison usage in macsec_fs_rx_add_rule function
      net/mlx5e: Fix macsec sci endianness at rx sa update

Roi Dayan (1):
      net/mlx5e: TC, Fix cloned flow attr instance dests are not zeroed

Rongwei Liu (1):
      net/mlx5: DR, Fix matcher disconnect error flow

Roy Novich (1):
      net/mlx5: Update fw fatal reporter state on PCI handlers successful recover

Saeed Mahameed (1):
      net/mlx5: ASO, Create the ASO SQ with the correct timestamp format

Shay Drory (1):
      net/mlx5: SF: Fix probing active SFs during driver probe phase

Suresh Devarakonda (1):
      net/mlx5: Fix crash during sync firmware reset

Tariq Toukan (1):
      net/mlx5: Fix possible use-after-free in async command interface

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 10 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |  9 +++
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  6 ++
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |  3 -
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  | 16 ++--
 .../mellanox/mlx5/core/en_accel/macsec_fs.c        |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 78 +++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  6 ++
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 17 +++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c  |  7 ++
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c |  6 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  4 +
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.c   | 86 ++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h    | 10 +++
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  3 +-
 include/linux/mlx5/driver.h                        |  2 +-
 17 files changed, 242 insertions(+), 25 deletions(-)
