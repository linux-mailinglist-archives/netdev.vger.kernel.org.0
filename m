Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91DF417B42
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 20:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236541AbhIXStv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 14:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229954AbhIXStu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 14:49:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC8C261241;
        Fri, 24 Sep 2021 18:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632509297;
        bh=hc5LdhTO9CQ0DYhiw2a+S+kO2lXvd5l9iwfAI1ExTbU=;
        h=From:To:Cc:Subject:Date:From;
        b=NeIoBUdpqgWiHelwydUUv0GJOp1KxemuzRuBvDFZKkOgdzJSqDm4b14kL5IC6ak1Y
         cRp1GNE1eeHd7qjdOCv2om26+4e5qGvdoHy6zss+GUi4G7TbuR1BjfB0SlL1Vkyrk4
         vEWfCISiPwM74LG7XENL289vctsuLV4RBjOWTw6zT+cOZXBAvyuagt/GiiR5b2n+FJ
         Kj1pRHGO3SFjkFk8UmPZMF8G8gf3ROY3AuIL+kZqtLJc7pmfbopFu6o8lczK4L+dH9
         NFoAXpdPNJyPL+iYU4u5aXWkYgE7+TQ2Kx1iWIozB2ca+VHbxPSOaP0awqwdlrMsIu
         +zWvFkcXQ/WeA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/12] mlx5 updates 2021-09-24
Date:   Fri, 24 Sep 2021 11:47:56 -0700
Message-Id: <20210924184808.796968-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave and Jakub,

This series provides misc updates to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit acde891c243c1ed85b19d4d5042bdf00914f5739:

  rxrpc: Fix _usecs_to_jiffies() by using usecs_to_jiffies() (2021-09-24 14:18:34 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-09-24

for you to fetch changes up to 05000bbba1e93d9915a5ea8c7faf4086f58a5fb9:

  net/mlx5e: Enable TC offload for ingress MACVLAN (2021-09-24 11:46:57 -0700)

----------------------------------------------------------------
mlx5-updates-2021-09-24

mlx5 misc updates and fixes to net-next branch:

1) Roi Dayan provided some cleanups in mlx5e TC module, and some
   code improvements to fwd/drop actions handling.

2) Tariq, Add TX max rate support for MQPRIO channel mode

3) Dima adds the support for TC egress/ingress offload of macvlan
   interfaces

4) misc cleanup

----------------------------------------------------------------
Aya Levin (1):
      net/mlx5e: Add error flow for ethtool -X command

Dima Chumak (2):
      net/mlx5e: Enable TC offload for egress MACVLAN
      net/mlx5e: Enable TC offload for ingress MACVLAN

Roi Dayan (8):
      net/mlx5e: Use correct return type
      net/mlx5e: Remove incorrect addition of action fwd flag
      net/mlx5e: Set action fwd flag when parsing tc action goto
      net/mlx5e: Check action fwd/drop flag exists also for nic flows
      net/mlx5e: Remove redundant priv arg from parse_pedit_to_reformat()
      net/mlx5e: Use tc sample stubs instead of ifdefs in source file
      net/mlx5e: Use NL_SET_ERR_MSG_MOD() for errors parsing tunnel attributes
      net/mlx5e: loopback test is not supported in switchdev mode

Yevgeny Kliteynik (1):
      net/mlx5: DR, Fix code indentation in dr_ste_v1

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  20 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en/rss.c   |  27 ++++-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.h |  27 +++++
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |  92 ++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 113 +++++++++------------
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |   2 +-
 8 files changed, 168 insertions(+), 120 deletions(-)
