Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47A7AFF5CE
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 22:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfKPVdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 16:33:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54076 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbfKPVdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 16:33:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26199151AE754;
        Sat, 16 Nov 2019 13:33:22 -0800 (PST)
Date:   Sat, 16 Nov 2019 13:33:21 -0800 (PST)
Message-Id: <20191116.133321.709008936600873428.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 13:33:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix memory leak in xfrm_state code, from Steffen Klassert.

2) Fix races between devlink reload operations and device
   setup/cleanup, from Jiri Pirko.

3) Null deref in NFC code, from Stephan Gerhold.

4) Refcount fixes in SMC, from Ursula Braun.

5) Memory leak in slcan open error paths, from Jouni Hogander.

6) Fix ETS bandwidth validation in hns3, from Yonglong Liu.

7) Info leak on short USB request answers in ax88172a driver, from
   Oliver Neukum.

8) Release mem region properly in ep93xx_eth, from Chuhong Yuan.

9) PTP config timestamp flags validation, from Richard Cochran.

10) Dangling pointers after SKB data realloc in seg6, from Andrea
    Mayer.

11) Missing free_netdev() in gemini driver, from Chuhong Yuan.

Please pull, thanks a lot!

The following changes since commit 0058b0a506e40d9a2c62015fe92eb64a44d78cd9:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2019-11-08 18:21:05 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net 

for you to fetch changes up to 7901cd97963d6cbde88fa25a4a446db3554c16c6:

  ipmr: Fix skb headroom in ipmr_get_route(). (2019-11-16 13:06:54 -0800)

----------------------------------------------------------------
Aleksander Morgado (1):
      net: usb: qmi_wwan: add support for Foxconn T77W968 LTE modules

Andrea Mayer (2):
      seg6: fix srh pointer in get_srh()
      seg6: fix skb transport_header after decap_and_validate()

Aya Levin (1):
      devlink: Add method for time-stamp on reporter's dump

Chuhong Yuan (2):
      net: ep93xx_eth: fix mismatch of request_mem_region in remove
      net: gemini: add missed free_netdev

Corentin Labbe (1):
      net: ethernet: dwmac-sun8i: Use the correct function in exit path

Dag Moxnes (1):
      rds: ib: update WR sizes when bringing up connection

Dan Carpenter (1):
      net: cdc_ncm: Signedness bug in cdc_ncm_set_dgram_size()

David S. Miller (7):
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec
      Merge tag 'linux-can-fixes-for-5.4-20191113' of git://git.kernel.org/.../mkl/linux-can
      Merge tag 'wireless-drivers-2019-11-14' of git://git.kernel.org/.../kvalo/wireless-drivers
      Merge tag 'linux-can-fixes-for-5.4-20191114' of git://git.kernel.org/.../mkl/linux-can
      Merge branch 'hns3-fixes'
      Merge branch 'ptp-Validate-the-ancillary-ioctl-flags-more-carefully'
      Merge branch 'seg6-fixes-to-Segment-Routing-in-IPv6'

Guangbin Huang (1):
      net: hns3: add compatible handling for MAC VLAN switch parameter configuration

Guillaume Nault (1):
      ipmr: Fix skb headroom in ipmr_get_route().

Ido Schimmel (1):
      selftests: mlxsw: Adjust test to recent changes

Ioana Ciornei (1):
      dpaa2-eth: free already allocated channels on probe defer

Jacob Keller (6):
      net: reject PTP periodic output requests with unsupported flags
      mv88e6xxx: reject unsupported external timestamp flags
      dp83640: reject unsupported external timestamp flags
      igb: reject unsupported external timestamp flags
      mlx5: reject unsupported external timestamp flags
      renesas: reject unsupported external timestamp flags

Jiri Pirko (2):
      devlink: disallow reload operation during device cleanup
      mlxsw: core: Enable devlink reload only on probe

Jouni Hogander (2):
      slip: Fix memory leak in slip_open error path
      slcan: Fix memory leak in error path

Matt Bennett (1):
      tipc: add back tipc prefix to log messages

Mordechay Goodstein (1):
      iwlwifi: pcie: don't consider IV len in A-MSDU

Nishad Kamdar (2):
      octeontx2-af: Use the correct style for SPDX License Identifier
      net: stmmac: Use the correct style for SPDX License Identifier

Oleksij Rempel (9):
      can: af_can: export can_sock_destruct()
      can: j1939: move j1939_priv_put() into sk_destruct callback
      can: j1939: main: j1939_ndev_to_priv(): avoid crash if can_ml_priv is NULL
      can: j1939: socket: rework socket locking for j1939_sk_release() and j1939_sk_sendmsg()
      can: j1939: transport: make sure the aborted session will be deactivated only once
      can: j1939: make sure socket is held as long as session exists
      can: j1939: transport: j1939_cancel_active_session(): use hrtimer_try_to_cancel() instead of hrtimer_cancel()
      can: j1939: j1939_can_recv(): add priv refcounting
      can: j1939: warn if resources are still linked on destroy

Oliver Neukum (1):
      ax88172a: fix information leak on short answers

Richard Cochran (7):
      ptp: Validate requests to enable time stamping of external signals.
      ptp: Introduce strict checking of external time stamp options.
      mv88e6xxx: Reject requests to enable time stamping on both edges.
      dp83640: Reject requests to enable time stamping on both edges.
      igb: Reject requests that fail to enable time stamping on both edges.
      mlx5: Reject requests to enable time stamping on both edges.
      ptp: Extend the test program to check the external time stamp flags.

Salil Mehta (1):
      net: hns3: cleanup of stray struct hns3_link_mode_mapping

Steffen Klassert (1):
      xfrm: Fix memleak on xfrm state destroy

Stephan Gerhold (1):
      NFC: nxp-nci: Fix NULL pointer dereference after I2C communication error

Tony Lu (1):
      tcp: remove redundant new line from tcp_event_sk_skb

Ulrich Hecht (1):
      ravb: implement MTU change while device is up

Ursula Braun (2):
      net/smc: fix refcount non-blocking connect() -part 2
      net/smc: fix fastopen for non-blocking connect()

Vladimir Oltean (1):
      net: dsa: tag_8021q: Fix dsa_8021q_restore_pvid for an absent pvid

Xiaodong Xu (1):
      xfrm: release device reference for invalid state

Yonglong Liu (1):
      net: hns3: fix ETS bandwidth validation bug

YueHaibing (1):
      mdio_bus: Fix PTR_ERR applied after initialization to constant

Yunsheng Lin (1):
      net: hns3: reallocate SSU' buffer size when pfc_en changes

 drivers/net/can/slcan.c                                 |  1 +
 drivers/net/dsa/mv88e6xxx/ptp.c                         | 13 +++++++++++++
 drivers/net/ethernet/broadcom/tg3.c                     |  4 ++++
 drivers/net/ethernet/cirrus/ep93xx_eth.c                |  5 +++--
 drivers/net/ethernet/cortina/gemini.c                   |  1 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c        | 10 +++++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c      |  5 -----
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c  | 19 +++++++++++++++++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 16 ++++++++++++++--
 drivers/net/ethernet/intel/igb/igb_ptp.c                | 17 +++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h         |  4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h   |  4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/common.h      |  4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h        |  4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/npc.h         |  4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h |  4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h         |  4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h     |  4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h  |  4 ++--
 drivers/net/ethernet/mellanox/mlx4/main.c               |  3 +++
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c     | 17 +++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.c              |  5 +++++
 drivers/net/ethernet/microchip/lan743x_ptp.c            |  4 ++++
 drivers/net/ethernet/renesas/ravb.h                     |  3 ++-
 drivers/net/ethernet/renesas/ravb_main.c                | 26 +++++++++++++------------
 drivers/net/ethernet/renesas/ravb_ptp.c                 | 11 +++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c       |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h            |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h          |  2 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h              |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c        |  4 ++++
 drivers/net/netdevsim/dev.c                             |  2 ++
 drivers/net/phy/dp83640.c                               | 16 ++++++++++++++++
 drivers/net/phy/mdio_bus.c                              | 11 ++++++-----
 drivers/net/slip/slip.c                                 |  1 +
 drivers/net/usb/ax88172a.c                              |  2 +-
 drivers/net/usb/cdc_ncm.c                               |  2 +-
 drivers/net/usb/qmi_wwan.c                              |  2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c       | 20 +++++++-------------
 drivers/nfc/nxp-nci/i2c.c                               |  6 ++++--
 drivers/ptp/ptp_chardev.c                               | 20 +++++++++++++++-----
 include/linux/can/core.h                                |  1 +
 include/net/devlink.h                                   |  5 ++++-
 include/trace/events/tcp.h                              |  2 +-
 include/uapi/linux/devlink.h                            |  1 +
 include/uapi/linux/ptp_clock.h                          |  5 ++++-
 net/can/af_can.c                                        |  3 ++-
 net/can/j1939/main.c                                    |  9 +++++++++
 net/can/j1939/socket.c                                  | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------
 net/can/j1939/transport.c                               | 36 ++++++++++++++++++++++++++---------
 net/core/devlink.c                                      | 45 +++++++++++++++++++++++++++++++++++++++++++-
 net/dsa/tag_8021q.c                                     |  2 +-
 net/ipv4/ipmr.c                                         |  3 ++-
 net/ipv6/seg6_local.c                                   | 11 +++++++++++
 net/rds/ib_cm.c                                         | 23 +++++++++++++++--------
 net/smc/af_smc.c                                        |  3 ++-
 net/tipc/core.c                                         |  2 --
 net/tipc/core.h                                         |  6 ++++++
 net/xfrm/xfrm_input.c                                   |  3 +++
 net/xfrm/xfrm_state.c                                   |  2 ++
 tools/testing/selftests/drivers/net/mlxsw/vxlan.sh      |  8 ++++++--
 tools/testing/selftests/ptp/testptp.c                   | 53 +++++++++++++++++++++++++++++++++++++++++++++++++--
 62 files changed, 482 insertions(+), 125 deletions(-)
