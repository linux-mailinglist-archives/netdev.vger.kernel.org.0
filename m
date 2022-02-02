Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4204A6B2C
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiBBFGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:06:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48988 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiBBFGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:06:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F5F76170E
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A83C004E1;
        Wed,  2 Feb 2022 05:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778391;
        bh=9+hK9ER1UVykFXo7AcOf0BUquIMrMMhjwylUdczT6jg=;
        h=From:To:Cc:Subject:Date:From;
        b=fysjcJ5uPNUAfSfMpSBIob1Rd1jQFhZJNklsHheO8oDwYPFOKlW4iWWUqO+W3tVEt
         yd4PTx3LZ8FP94zyAh7Erv16rx8qUNtPZ92vrF091/lk8j72sOXsCFxjs1mhNjzzSb
         Oq3m9dnYTWhitj4U5NfRnJOMWvdtkLM0VwrE2szgstkE5DtIINEKPsbL7NY+Her4Lk
         0dWfm65s5iA55Ut6dh/WqtpulKQH8kqMvj8m3yMwFXQkCGEJl3WGspaPoXTH+siREa
         Ex0Hq+DXPeknxsN4e4URBGj7yGmpsGaxvjSU1lxIIMKHZRQzdoL54ZzDAE41aFZCwp
         dwolY3W0RLBTg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/18] mlx5 fixes 2022-02-01
Date:   Tue,  1 Feb 2022 21:03:46 -0800
Message-Id: <20220202050404.100122-1-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Sorry about the long series, but I had to move the top two patches from
net-next to net to help avoiding a build break when kspp branch is merged
into linus-next on next merge window.

Thanks,
Saeed.


The following changes since commit c7108979a010f693d9f3b0adc7aa770b33d1b77d:

  Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue (2022-02-01 20:39:47 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-02-01

for you to fetch changes up to ad5185735f7dab342fdd0dd41044da4c9ccfef67:

  net/mlx5e: Avoid field-overflowing memcpy() (2022-02-01 20:59:43 -0800)

----------------------------------------------------------------
mlx5-fixes-2022-02-01

----------------------------------------------------------------
Dima Chumak (1):
      net/mlx5: Fix offloading with ESWITCH_IPV4_TTL_MODIFY_ENABLE

Gal Pressman (1):
      net/mlx5e: Fix module EEPROM query

Kees Cook (2):
      net/mlx5e: Use struct_group() for memcpy() region
      net/mlx5e: Avoid field-overflowing memcpy()

Khalid Manaa (2):
      net/mlx5e: Fix wrong calculation of header index in HW_GRO
      net/mlx5e: Fix broken SKB allocation in HW-GRO

Maher Sanalla (1):
      net/mlx5: Use del_timer_sync in fw reset flow of halting poll

Maor Dickman (2):
      net/mlx5e: Fix handling of wrong devices during bond netevent
      net/mlx5: E-Switch, Fix uninitialized variable modact

Maxim Mikityanskiy (1):
      net/mlx5e: Don't treat small ceil values as unlimited in HTB offload

Raed Salem (2):
      net/mlx5e: IPsec: Fix crypto offload for non TCP/UDP encapsulated traffic
      net/mlx5e: IPsec: Fix tunnel mode crypto offload for non TCP/UDP traffic

Roi Dayan (4):
      net/mlx5e: TC, Reject rules with drop and modify hdr action
      net/mlx5e: TC, Reject rules with forward and drop actions
      net/mlx5: Bridge, Fix devlink deadlock on net namespace deletion
      net/mlx5e: Avoid implicit modify hdr for decap drop rule

Vlad Buslov (2):
      net/mlx5: Bridge, take rtnl lock in init error handler
      net/mlx5: Bridge, ensure dev_name is null-terminated

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  6 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/bond.c  | 32 ++++++++++------------
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |  6 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  5 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  4 ++-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       | 13 +++++++--
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |  9 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 30 ++++++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 15 +++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |  4 +++
 .../mlx5/core/esw/diag/bridge_tracepoint.h         |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  2 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |  9 +++---
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |  9 +++---
 include/linux/if_vlan.h                            |  6 ++--
 17 files changed, 102 insertions(+), 55 deletions(-)
