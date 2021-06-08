Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3121839F704
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 14:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbhFHMqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 08:46:32 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39011 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232299AbhFHMqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 08:46:32 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CD7645C012E;
        Tue,  8 Jun 2021 08:44:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 08 Jun 2021 08:44:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=c5+JhEJZG+3PijFtH
        cC9eKMi01NAdLC6kDyZzB3zbaM=; b=ZOCwAoN4GwUXcd9Tbfqs7SPQ0HGx/2gT4
        cF3KU7+86xNJ1AvXFmdiHxmd7xdbsPchUWr86CH6X86MgiAHmBwITnDaAH0rcBxU
        RHJb9+LMXvIgNNTAsVLZxICj+hM+CqjEG3kmkRsqz4RgX6zuPk4EgRZEAvRiPS+q
        EOh6yaRKIpT9e/RTkAIwBNsV5iowhXRIBT2LkR0aV3i920vLwe8UsASSUd9N/xAS
        xfbfn8cBRiwl7c9zW49LrYjyaciyUywSm1dlTME/Ai064PJ7gxVekEny+cJdPidw
        yOviZ3tT23DviVuXW99izfYOlB6UhFLrR0/lyVsQ8IA9wrVOCNUgA==
X-ME-Sender: <xms:Nma_YHRTqModsJIDtNQrOBH1t6zOlKFOBhxMCWGeOKrVYXQ8dx3QSw>
    <xme:Nma_YIzci1MPTYDcixPZ15polm0Cgj5OZY7zcohbrLh0Lfc5K7I2TuyRM6UF4XTjJ
    K5rXOTIDwLIUg4>
X-ME-Received: <xmr:Nma_YM0HI-tlPGb_el0UoN4j-PL3OXtYsdbBxesYBGH3D6f1UapualwnzmtKmFhyhpu8De33aeg5YekKxP96AvAcAzzTFiV-heOY3Wlu6UtfGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Nma_YHDsy9Ij4whGccpvwqG0RSx1M530I2kWkPCXvqiKJYX2iq4XOA>
    <xmx:Nma_YAgQxErM1BW-OJuvsbTV6p8S3YGnXbwZ129pjxxAOBoSEYg4nA>
    <xmx:Nma_YLqfKDQ6P2d1M5wZi8KUR17srQjP9dtAiitaPp3bEWQjOJ5emA>
    <xmx:Nma_YMihFbCC_5T-E0m3P3P5k_J-Dq9yNfWUdKgB_XvLxsW98SwCDg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:44:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, vadimp@nvidia.com,
        c_mykolak@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/8] mlxsw: Various updates
Date:   Tue,  8 Jun 2021 15:44:06 +0300
Message-Id: <20210608124414.1664294-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset contains various updates for mlxsw. The most significant
change is the long overdue removal of the abort mechanism in the first
two patches.

Patches #1-#2 remove the route abort mechanism. This change is long
overdue and explained in detail in the commit message.

Patch #3 sets ports down in a few selftests that forgot to do so.
Discovered using a BPF tool (WIP) that monitors ASIC resources.

Patch #4 fixes an issue introduced by commit 557c4d2f780c ("selftests:
devlink_lib: add check for devlink device existence").

Patches #5-#8 modify the driver to read transceiver module's temperature
thresholds using MTMP register (when supported) instead of directly from
the module's EEPROM using MCIA register. This is both more reliable and
more efficient as now the module's temperature and thresholds are read
using one transaction instead of three.

Amit Cohen (3):
  mlxsw: spectrum_router: Remove abort mechanism
  selftests: router_scale: Do not count failed routes
  selftests: Clean forgotten resources as part of cleanup()

Mykola Kostenok (4):
  mlxsw: reg: Extend MTMP register with new threshold field
  mlxsw: core_env: Read module temperature thresholds using MTMP
    register
  mlxsw: thermal: Add function for reading module temperature and
    thresholds
  mlxsw: thermal: Read module temperature thresholds using MTMP register

Petr Machata (1):
  selftests: devlink_lib: Fix bouncing of netdevsim DEVLINK_DEV

 .../net/ethernet/mellanox/mlxsw/core_env.c    |  13 +-
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  |   6 +-
 .../ethernet/mellanox/mlxsw/core_thermal.c    |  97 ++++++++-----
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  20 ++-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 129 +-----------------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   1 -
 .../net/mlxsw/devlink_trap_l3_drops.sh        |   3 +
 .../net/mlxsw/devlink_trap_l3_exceptions.sh   |   3 +
 .../drivers/net/mlxsw/qos_dscp_bridge.sh      |   2 +
 .../drivers/net/mlxsw/router_scale.sh         |   2 +-
 .../drivers/net/netdevsim/devlink_trap.sh     |   4 +-
 .../selftests/drivers/net/netdevsim/fib.sh    |   6 +-
 .../drivers/net/netdevsim/nexthop.sh          |   4 +-
 .../drivers/net/netdevsim/psample.sh          |   4 +-
 .../selftests/net/forwarding/devlink_lib.sh   |   2 +-
 .../selftests/net/forwarding/pedit_dsfield.sh |   2 +
 .../selftests/net/forwarding/pedit_l4port.sh  |   2 +
 .../net/forwarding/skbedit_priority.sh        |   2 +
 18 files changed, 132 insertions(+), 170 deletions(-)

-- 
2.31.1

