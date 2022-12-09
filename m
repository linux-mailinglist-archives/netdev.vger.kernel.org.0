Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18CB64802B
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 10:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiLIJdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 04:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiLIJd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 04:33:29 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0319820192
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 01:33:26 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 526B8204A4;
        Fri,  9 Dec 2022 10:33:25 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ONLyvgBudYou; Fri,  9 Dec 2022 10:33:24 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A5DAB2035C;
        Fri,  9 Dec 2022 10:33:24 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id A0AB480004A;
        Fri,  9 Dec 2022 10:33:24 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 9 Dec 2022 10:33:24 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 9 Dec
 2022 10:33:24 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C61893182989; Fri,  9 Dec 2022 10:33:23 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net-next): ipsec-next 2022-12-09
Date:   Fri, 9 Dec 2022 10:33:10 +0100
Message-ID: <20221209093310.4018731-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Add xfrm packet offload core API.
   From Leon Romanovsky.

2) Add xfrm packet offload support for mlx5.
   From Leon Romanovsky and Raed Salem.

3) Fix a typto in a error message.
   From Colin Ian King.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 65e6af6cebefbf7d8d8ac52b71cd251c2071ad00:

  net: ethernet: mtk_wed: fix sleep while atomic in mtk_wed_wo_queue_refill (2022-12-02 21:23:02 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git tags/ipsec-next-2022-12-09

for you to fetch changes up to abe2343d37c2b4361547d5d31e17340ff9ec7356:

  xfrm: Fix spelling mistake "oflload" -> "offload" (2022-12-09 09:09:40 +0100)

----------------------------------------------------------------
ipsec-next-2022-12-09

----------------------------------------------------------------
Colin Ian King (1):
      xfrm: Fix spelling mistake "oflload" -> "offload"

Leon Romanovsky (36):
      xfrm: add new packet offload flag
      xfrm: allow state packet offload mode
      xfrm: add an interface to offload policy
      xfrm: add TX datapath support for IPsec packet offload mode
      xfrm: add RX datapath protection for IPsec packet offload mode
      xfrm: speed-up lookup of HW policies
      xfrm: add support to HW update soft and hard limits
      xfrm: document IPsec packet offload mode
      net/mlx5: Return ready to use ASO WQE
      net/mlx5: Add HW definitions for IPsec packet offload
      net/mlx5e: Advertise IPsec packet offload support
      net/mlx5e: Store replay window in XFRM attributes
      net/mlx5e: Remove extra layers of defines
      net/mlx5e: Create symmetric IPsec RX and TX flow steering structs
      net/mlx5e: Use mlx5 print routines for low level IPsec code
      net/mlx5e: Remove accesses to priv for low level IPsec FS code
      net/mlx5e: Create Advanced Steering Operation object for IPsec
      net/mlx5e: Create hardware IPsec packet offload objects
      net/mlx5e: Move IPsec flow table creation to separate function
      net/mlx5e: Refactor FTE setup code to be more clear
      net/mlx5e: Flatten the IPsec RX add rule path
      net/mlx5e: Make clear what IPsec rx_err does
      net/mlx5e: Group IPsec miss handles into separate struct
      net/mlx5e: Generalize creation of default IPsec miss group and rule
      net/mlx5e: Create IPsec policy offload tables
      net/mlx5e: Add XFRM policy offload logic
      net/mlx5e: Use same coding pattern for Rx and Tx flows
      net/mlx5e: Configure IPsec packet offload flow steering
      net/mlx5e: Improve IPsec flow steering autogroup
      net/mlx5e: Skip IPsec encryption for TX path without matching policy
      net/mlx5e: Provide intermediate pointer to access IPsec struct
      net/mlx5e: Store all XFRM SAs in Xarray
      net/mlx5e: Update IPsec soft and hard limits
      net/mlx5e: Handle hardware IPsec limits events
      net/mlx5e: Handle ESN update events
      net/mlx5e: Open mlx5 driver to accept IPsec packet offload

Raed Salem (1):
      net/mlx5e: Add statistics for Rx/Tx IPsec offloaded flows

Steffen Klassert (3):
      Merge branch 'Extend XFRM core to allow packet offload configuration'
      Merge branch 'mlx5 IPsec packet offload support (Part I)'
      Merge branch 'mlx5 IPsec packet offload support (Part II)'

 Documentation/networking/xfrm_device.rst           |   62 +-
 .../chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c    |    4 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c     |    5 +
 drivers/net/ethernet/intel/ixgbevf/ipsec.c         |    5 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |    3 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.c  |    1 -
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |  356 +++++--
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |  132 ++-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         | 1069 ++++++++++++++------
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    |  303 +++++-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |   22 +-
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c      |   52 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |    5 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |    6 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c  |    7 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h  |    4 +-
 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c  |    5 +
 drivers/net/netdevsim/ipsec.c                      |    5 +
 include/linux/mlx5/mlx5_ifc.h                      |   53 +-
 include/linux/netdevice.h                          |    4 +
 include/net/xfrm.h                                 |  124 ++-
 include/uapi/linux/xfrm.h                          |    6 +
 net/xfrm/xfrm_device.c                             |  109 +-
 net/xfrm/xfrm_output.c                             |   12 +-
 net/xfrm/xfrm_policy.c                             |   85 +-
 net/xfrm/xfrm_state.c                              |  191 +++-
 net/xfrm/xfrm_user.c                               |   20 +
 30 files changed, 2141 insertions(+), 512 deletions(-)
