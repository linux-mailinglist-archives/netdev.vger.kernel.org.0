Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7978609A3E
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 08:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiJXGNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 02:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiJXGM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 02:12:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259975E329
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 23:12:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62F47CE0F77
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 06:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A73C433D6;
        Mon, 24 Oct 2022 06:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666591974;
        bh=C9PqTM+BRGI9rBk/qXcXGg9DHejAuYxZPqCQmxxF3SQ=;
        h=From:To:Cc:Subject:Date:From;
        b=kr+WsoKUu3zumSAS4N52iTXFxEW1RZI3liuB/O+JElccGzrT10uYjW9GvEXRiDLaq
         GXaJy3Ue8NbEtjzFb6zcAv3CJqvDfEOpyUrpj/LLErMkjLif1dM4HLL64pIFxVvvhs
         bee5DzXnjRMZis7uvhTovAix7qqyP+2m9pDL/kLKXQApqY9iFm80HPFxZjHUA8QwfA
         tznw/aMLqZfB+VU8rRsRL+YXH6l04MhHpUhtb6jH1cfs4Aj91Mryub9jHiMzqqUZTC
         ThCZbHjtiLbD/h+GkWJUwH3zG94gQTQdZBD8KEpe1q5LurFu84OoOotUFToxX5ybF7
         4bGmBIR30FzYA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][V2 net 00/16] mlx5 fixes 2022-10-14
Date:   Mon, 24 Oct 2022 07:12:04 +0100
Message-Id: <20221024061220.81662-1-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

v1->v2:
  add missing sign-off.

The following changes since commit 8df3db21919104a0589f8920e2ac70f4c2a67263:

  net/mlx5e: Fix macsec sci endianness at rx sa update (2022-10-24 06:45:39 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-10-14

for you to fetch changes up to 8df3db21919104a0589f8920e2ac70f4c2a67263:

  net/mlx5e: Fix macsec sci endianness at rx sa update (2022-10-24 06:45:39 +0100)


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
  net/mlx5e: Fix wrong bitwise comparison usage in macsec_fs_rx_add_rule
    function
  net/mlx5e: Fix macsec sci endianness at rx sa update

Roi Dayan (1):
  net/mlx5e: TC, Fix cloned flow attr instance dests are not zeroed

Rongwei Liu (1):
  net/mlx5: DR, Fix matcher disconnect error flow

Roy Novich (1):
  net/mlx5: Update fw fatal reporter state on PCI handlers successful
    recover

Saeed Mahameed (1):
  net/mlx5: ASO, Create the ASO SQ with the correct timestamp format

Shay Drory (1):
  net/mlx5: SF: Fix probing active SFs during driver probe phase

Suresh Devarakonda (1):
  net/mlx5: Fix crash during sync firmware reset

Tariq Toukan (1):
  net/mlx5: Fix possible use-after-free in async command interface

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 10 +--
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  |  9 ++
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  2 +
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  6 ++
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  3 -
 .../mellanox/mlx5/core/en_accel/macsec.c      | 16 ++--
 .../mellanox/mlx5/core/en_accel/macsec_fs.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 78 ++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  6 ++
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 17 ++++
 .../net/ethernet/mellanox/mlx5/core/lib/aso.c |  7 ++
 .../ethernet/mellanox/mlx5/core/lib/mpfs.c    |  6 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  4 +
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.c  | 86 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/sf/sf.h   | 10 +++
 .../mellanox/mlx5/core/steering/dr_rule.c     |  3 +-
 include/linux/mlx5/driver.h                   |  2 +-
 17 files changed, 242 insertions(+), 25 deletions(-)

-- 
2.37.3

