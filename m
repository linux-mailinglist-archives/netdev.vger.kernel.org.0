Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8388019FD02
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 20:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgDFSXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 14:23:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57942 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgDFSXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 14:23:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7F49215DADD19;
        Mon,  6 Apr 2020 11:23:01 -0700 (PDT)
Date:   Mon, 06 Apr 2020 11:22:58 -0700 (PDT)
Message-Id: <20200406.112258.20998915860758260.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Apr 2020 11:23:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Slave bond and team devices should not be assigned ipv6 link local
   addresses, from Jarod Wilson.

2) Fix clock sink config on some at803x PHY devices, from Oleksij
   Rempel.

3) Uninitialized stack space transmitted in slcan frames, fix from
   Richard Palethorpe.

4) Guard HW VLAN ops properly in stmmac driver, from Jose Abreu.

5) "=" --> "|=" fix in aquantia driver, from Colin Ian King.

6) Fix TCP fallback in mptcp, from Florian Westphal.  (accessing
   a plain tcp_sk as if it were an mptcp socket).

7) Fix cavium driver in some configurations wrt. PTP, from Yue
   Haibing.

8) Make ipv6 and ipv4 consistent in the lower bound allowed for
   neighbour entry retrans_time, from Hangbin Liu.

9) Don't use private workqueue in pegasus usb driver, from Petko
   Manolov.

10) Fix integer overflow in mlxsw, from Colin Ian King.

11) Missing refcnt init in cls_tcindex, from Cong Wang.

12) One too many loop iterations when processing cmpri entries in
    ipv6 rpl code, from Alexander Aring.

13) Disable SG and TSO by default in r8169, from Heiner Kallweit.

14) NULL deref in macsec, from Davide Caratti.

Please pull, thanks a lot!

The following changes since commit 1a323ea5356edbb3073dc59d51b9e6b86908857d:

  x86: get rid of 'errret' argument to __get_user_xyz() macross (2020-03-31 18:23:47 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to aa81700cf2326e288c9ca1fe7b544039617f1fc2:

  macsec: fix NULL dereference in macsec_upd_offload() (2020-04-06 10:26:08 -0700)

----------------------------------------------------------------
Alexander Aring (1):
      ipv6: rpl: fix loop iteration

Chuanhong Guo (1):
      net: dsa: mt7530: fix null pointer dereferencing in port5 setup

Colin Ian King (5):
      net: atlantic: fix missing | operator when assigning rec->llc
      net: ipv6: rpl_iptunnel: remove redundant assignments to variable err
      mlxsw: spectrum_trap: fix unintention integer overflow on left shift
      wimax: remove some redundant assignments to variable result
      qed: remove redundant assignment to variable 'rc'

Cong Wang (2):
      net_sched: add a temporary refcnt for struct tcindex_data
      net_sched: fix a missing refcnt in tcindex_init()

David S. Miller (2):
      Merge branch 'mptcp-various-bugfixes-and-improvements'
      Merge branch 'mlxsw-fixes'

Davide Caratti (1):
      macsec: fix NULL dereference in macsec_upd_offload()

Dexuan Cui (1):
      skbuff.h: Improve the checksum related comments

Florian Fainelli (2):
      net: dsa: bcm_sf2: Do not register slave MDIO bus with OF
      net: dsa: bcm_sf2: Ensure correct sub-node is parsed

Florian Westphal (3):
      mptcp: fix tcp fallback crash
      mptcp: subflow: check parent mptcp socket on subflow state change
      mptcp: re-check dsn before reading from subflow

Geliang Tang (1):
      mptcp: add some missing pr_fmt defines

Hangbin Liu (1):
      neigh: support smaller retrans_time settting

Heiner Kallweit (1):
      r8169: change back SG and TSO to be disabled by default

Herat Ramani (1):
      cxgb4: fix MPS index overwrite when setting MAC address

Hu Haowen (2):
      net/faraday: fix grammar in function ftgmac100_setup_clk() in ftgmac100.c
      bnx2x: correct a comment mistake in grammar

Jarod Wilson (1):
      ipv6: don't auto-add link-local address to lag ports

Jisheng Zhang (1):
      net: stmmac: dwmac1000: fix out-of-bounds mac address reg setting

Jose Abreu (2):
      net: stmmac: Fix VLAN filtering when HW does not support it
      net: stmmac: xgmac: Fix VLAN register handling

Matthieu Baerts (1):
      mptcp: fix "fn parameter not described" warnings

Oleksij Rempel (2):
      net: phy: at803x: fix clock sink configuration on ATH8030 and ATH8035
      net: phy: micrel: kszphy_resume(): add delay after genphy_resume() before accessing PHY registers

Petko Manolov (1):
      pegasus: Remove pegasus' own workqueue

Petr Machata (2):
      mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_PRIORITY
      mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_VLAN_MANGLE

Rahul Lakkireddy (1):
      cxgb4: free MQPRIO resources in shutdown path

Richard Palethorpe (1):
      slcan: Don't transmit uninitialized stack data in padding

Rob Herring (1):
      dt-bindings: net: mvusb: Fix example errors

Subash Abhinov Kasiviswanathan (1):
      net: qualcomm: rmnet: Allow configuration updates to existing devices

Tonghao Zhang (1):
      net: openvswitch: use hlist_for_each_entry_rcu instead of hlist_for_each_entry

Vincent Bernat (1):
      net: core: enable SO_BINDTODEVICE for non-root users

Will Deacon (1):
      tun: Don't put_page() for all negative return values from XDP program

YueHaibing (2):
      crypto/chcr: Add missing include file <linux/highmem.h>
      net: cavium: Fix build errors due to 'imply CAVIUM_PTP'

kbuild test robot (1):
      net: dsa: dsa_bridge_mtu_normalization() can be static

 Documentation/devicetree/bindings/net/marvell,mvusb.yaml   |  29 ++++++++++----------
 drivers/crypto/chelsio/chcr_ktls.c                         |   1 +
 drivers/net/can/slcan.c                                    |   4 +--
 drivers/net/dsa/bcm_sf2.c                                  |   9 +++++--
 drivers/net/dsa/mt7530.c                                   |   3 +++
 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c           |   3 ++-
 drivers/net/ethernet/cavium/common/cavium_ptp.h            |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c            |   5 +++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c       |  23 ++++++++++++++++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h       |   1 +
 drivers/net/ethernet/faraday/ftgmac100.c                   |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c      |  18 ++++++++-----
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c        |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.c                   |   2 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c         |  31 ++++++++++++---------
 drivers/net/ethernet/realtek/r8169_main.c                  |  29 ++++++++++----------
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c       |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c        |  11 ++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c          |  17 ++++++++----
 drivers/net/macsec.c                                       |   3 +++
 drivers/net/phy/at803x.c                                   |   4 +--
 drivers/net/phy/micrel.c                                   |   7 +++++
 drivers/net/tun.c                                          |  10 ++++---
 drivers/net/usb/pegasus.c                                  |  38 +++++---------------------
 drivers/net/wimax/i2400m/driver.c                          |   7 ++---
 include/linux/skbuff.h                                     |  38 +++++++++++++-------------
 net/core/neighbour.c                                       |  10 ++++---
 net/core/sock.c                                            |   2 +-
 net/dsa/slave.c                                            |   2 +-
 net/ipv6/addrconf.c                                        |  11 +++++---
 net/ipv6/ndisc.c                                           |   4 +--
 net/ipv6/rpl.c                                             |   6 ++---
 net/ipv6/rpl_iptunnel.c                                    |   2 +-
 net/mptcp/options.c                                        |   2 ++
 net/mptcp/pm.c                                             |   2 ++
 net/mptcp/pm_netlink.c                                     |   2 ++
 net/mptcp/protocol.c                                       | 109 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 net/mptcp/protocol.h                                       |   2 ++
 net/mptcp/subflow.c                                        |   3 +--
 net/mptcp/token.c                                          |   9 ++++---
 net/openvswitch/flow_table.c                               |  10 ++++---
 net/sched/cls_tcindex.c                                    |  45 ++++++++++++++++++++++++++-----
 43 files changed, 361 insertions(+), 163 deletions(-)
