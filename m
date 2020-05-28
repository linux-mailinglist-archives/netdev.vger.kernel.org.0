Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F951E6CCA
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 22:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407347AbgE1Uro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 16:47:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407240AbgE1Urn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 16:47:43 -0400
Received: from lore-desk.lan (unknown [151.48.140.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 296C72074B;
        Thu, 28 May 2020 20:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590698862;
        bh=wX6hpx96dtyHkIEprPgNqQcW0SPTEvVl/tfu04hiw9A=;
        h=From:To:Cc:Subject:Date:From;
        b=V+NMYmUQjrwKHJKgGWQGsjvSfu9EoApWZ7VpWiz7GB3OQ13+WL8SVSh7rmz6Cp6pJ
         oD9fWfRVcmepBDQTebohDkkA8zMBH5z+fVCGn0k7FJRRTTx8dGkkkROQU0Nq1V8oeL
         CLUHbcQ7ktUf4azyeuIjPfmtm1gVZYxIPXK1TFco=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     ast@kernel.org, davem@davemloft.net, brouer@redhat.com,
        daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [PATCH v3 bpf-next 0/2] introduce xdp_convert_frame_to_buff routine
Date:   Thu, 28 May 2020 22:47:27 +0200
Message-Id: <cover.1590698295.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename convert_to_xdp_frame in xdp_convert_buff_to_frame in order to use
standard 'xdp' prefix

Changes since v2:
- rename convert_to_xdp_buff in xdp_convert_frame_to_buff
- rename convert_to_xdp_frame in xdp_convert_buff_to_frame adding patch 2/2

Changes since v1:
- rely on frame->data pointer to compute xdp->data_hard_start one

Lorenzo Bianconi (2):
  xdp: introduce xdp_convert_frame_to_buff utility routine
  xdp: rename convert_to_xdp_frame in xdp_convert_buff_to_frame

 drivers/net/ethernet/amazon/ena/ena_netdev.c     |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c      |  2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c    |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c     |  2 +-
 drivers/net/ethernet/marvell/mvneta.c            |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 10 +++++-----
 drivers/net/ethernet/sfc/rx.c                    |  2 +-
 drivers/net/ethernet/socionext/netsec.c          |  2 +-
 drivers/net/ethernet/ti/cpsw_priv.c              |  2 +-
 drivers/net/tun.c                                |  2 +-
 drivers/net/veth.c                               |  8 ++------
 drivers/net/virtio_net.c                         |  4 ++--
 include/net/xdp.h                                | 12 +++++++++++-
 kernel/bpf/cpumap.c                              |  2 +-
 kernel/bpf/devmap.c                              |  2 +-
 16 files changed, 32 insertions(+), 26 deletions(-)

-- 
2.26.2

