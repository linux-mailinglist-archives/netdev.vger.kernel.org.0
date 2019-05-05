Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E868713EE0
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 12:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfEEKgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 06:36:33 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45852 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725873AbfEEKgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 06:36:33 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 May 2019 13:36:26 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x45AaQET029699;
        Sun, 5 May 2019 13:36:26 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 0/2] Introduce net_prefetch
Date:   Sun,  5 May 2019 13:36:05 +0300
Message-Id: <1557052567-31827-1-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

In this series, I first take the repeated code structure from
net device drivers into a function. Then, I call it from mlx5e driver.

Series generated against net-next commit:
ca96534630e2 openvswitch: check for null pointer return from nla_nest_start_noflag

Thanks,
Tariq


Tariq Toukan (2):
  net: Take common prefetch code structure into a function
  net/mlx5e: RX, Add a prefetch command for small L1_CACHE_BYTES

 drivers/net/ethernet/chelsio/cxgb3/sge.c              |  5 +----
 drivers/net/ethernet/hisilicon/hns/hns_enet.c         |  5 +----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c       |  5 +----
 drivers/net/ethernet/intel/fm10k/fm10k_main.c         |  5 +----
 drivers/net/ethernet/intel/i40e/i40e_txrx.c           | 12 ++++--------
 drivers/net/ethernet/intel/iavf/iavf_txrx.c           | 11 +++--------
 drivers/net/ethernet/intel/ice/ice_txrx.c             |  5 +----
 drivers/net/ethernet/intel/igb/igb_main.c             | 10 ++--------
 drivers/net/ethernet/intel/igc/igc_main.c             | 10 ++--------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c         | 11 +++--------
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c     | 11 +++--------
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c      |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c       | 13 ++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c |  3 +--
 include/linux/netdevice.h                             | 16 ++++++++++++++++
 15 files changed, 47 insertions(+), 79 deletions(-)

-- 
1.8.3.1

