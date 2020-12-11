Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE08C2D7F62
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 20:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392323AbgLKT3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 14:29:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389882AbgLKT3E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 14:29:04 -0500
From:   Lorenzo Bianconi <lorenzo@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, alexander.duyck@gmail.com,
        maciej.fijalkowski@intel.com, saeed@kernel.org
Subject: [PATCH v2 bpf-next 0/2] introduce xdp_init_buff/xdp_prepare_buff
Date:   Fri, 11 Dec 2020 20:28:11 +0100
Message-Id: <cover.1607714335.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_init_buff and xdp_prepare_buff utility routines to initialize
xdp_buff data structure and remove duplicated code in all XDP capable
drivers.

Changes since v1:
- introduce xdp_prepare_buff utility routine

Lorenzo Bianconi (2):
  net: xdp: introduce xdp_init_buff utility routine
  net: xdp: introduce xdp_prepare_buff utility routine

 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  8 +++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  7 ++-----
 .../net/ethernet/cavium/thunder/nicvf_main.c  | 11 ++++++-----
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 10 ++++------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 13 +++++--------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 18 +++++++++---------
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 17 +++++++++--------
 drivers/net/ethernet/intel/igb/igb_main.c     | 18 +++++++++---------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 19 +++++++++----------
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 19 +++++++++----------
 drivers/net/ethernet/marvell/mvneta.c         |  9 +++------
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 13 +++++++------
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  8 +++-----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  7 ++-----
 .../ethernet/netronome/nfp/nfp_net_common.c   | 12 ++++++------
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |  7 ++-----
 drivers/net/ethernet/sfc/rx.c                 |  9 +++------
 drivers/net/ethernet/socionext/netsec.c       |  8 +++-----
 drivers/net/ethernet/ti/cpsw.c                | 17 ++++++-----------
 drivers/net/ethernet/ti/cpsw_new.c            | 17 ++++++-----------
 drivers/net/hyperv/netvsc_bpf.c               |  7 ++-----
 drivers/net/tun.c                             | 11 ++++-------
 drivers/net/veth.c                            | 14 +++++---------
 drivers/net/virtio_net.c                      | 18 ++++++------------
 drivers/net/xen-netfront.c                    |  8 +++-----
 include/net/xdp.h                             | 17 +++++++++++++++++
 net/bpf/test_run.c                            |  9 +++------
 net/core/dev.c                                | 18 ++++++++----------
 28 files changed, 154 insertions(+), 195 deletions(-)

-- 
2.29.2

