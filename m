Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580FE5FF701
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 01:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiJNXqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 19:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJNXqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 19:46:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360A4F07DA
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 16:46:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEA6AB821B5
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 23:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4383AC433D6;
        Fri, 14 Oct 2022 23:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665791206;
        bh=q8tbp4za6wx4ZvMlIw+qr+RqMSOPXeq4YF4h1wvJ4FQ=;
        h=From:To:Cc:Subject:Date:From;
        b=HTlzdJ7QMpwMXuj6N2CV0sVcI+KH/YsCN3nsrF4XdoeZ199srr8rVdsPh4LpgUGiC
         4kS3bcEz5Twv5cT4TIPdBYhdDm8Y8WbmQc7uYOXh38P4xbKijlSA8rROf5hysH46H/
         Ln1hQZknd6j+bCsPJYSxSqhaFWXeACQRjdl2lsNczZ7wQb6znl17ZJ1vrzDj2IQdK0
         ghlvEBSHK0NCnXEi82BGG0UsrWE+5qlWO4DxHR+kiDdmEdlCucwFDvnxpb7Qa6gL2j
         BF2RX86m/PRmYC0K3CFQzjGK9xlnok1MDrbY3E7pFMVuhUhSanOb853qrgnIo8uJZ+
         V/9L/SA7UhjJw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net 00/16] mlx5 fixes 2022-10-14
Date:   Fri, 14 Oct 2022 16:46:21 -0700
Message-Id: <20221014234621.304330-1-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
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
