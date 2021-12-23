Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BAE47E7B5
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 19:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349869AbhLWSnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 13:43:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54996 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244754AbhLWSnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 13:43:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6993B81094;
        Thu, 23 Dec 2021 18:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB60C36AE9;
        Thu, 23 Dec 2021 18:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640284997;
        bh=C31ZIEfBdG0jwSBwBBaHDjlPdBYPENbeZQHFIjtNgLo=;
        h=From:To:Cc:Subject:Date:From;
        b=rWdWrcVx69LyvyMBacclq+Zw5NR8b5l9BffnIO1NTKtNXOD7IELYGbTAik8wSNVjd
         RIIrZA+jE9/ugVbtmxlsa5DoHHGTkGMuEzDUDJqDM16GZCaZj32jQMw5h9NlLH7V5J
         HpA2VT2QIVMxYhDcQ4WJ/aHBUUGhmQJLTOipH8pptm/7nr+MMelPhNmbonOnbm8CPR
         xgYRvvya/Zl7KKctAw/fMQ1KwOPTRSYgsOZ8v+iLMGx3Akob8fTGXMjr+MlSm6Dzv8
         XECboLHQ726SERTJnZOzpsxGRKpn1d8PitFAMOFAqBiaxkwsRDD4YW184o6TjanLel
         Ow2upMUsCMYfg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pablo@netfilter.org
Subject: [GIT PULL] Networking for 5.16-rc7
Date:   Thu, 23 Dec 2021 10:43:16 -0800
Message-Id: <20211223184316.3916057-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 6441998e2e37131b0a4c310af9156d79d3351c16:

  Merge tag 'audit-pr-20211216' of git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/audit (2021-12-16 15:24:46 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc7

for you to fetch changes up to 391e5975c0208ce3739587b33eba08be3e473d79:

  net: stmmac: dwmac-visconti: Fix value of ETHER_CLK_SEL_FREQ_SEL_2P5M (2021-12-23 09:58:13 -0800)

----------------------------------------------------------------
Networking fixes for 5.16-rc7, including fixes from netfilter.

Current release - regressions:

 - revert "tipc: use consistent GFP flags"

Previous releases - regressions:

 - igb: fix deadlock caused by taking RTNL in runtime resume path

 - accept UFOv6 packages in virtio_net_hdr_to_skb

 - netfilter: fix regression in looped (broad|multi)cast's MAC handling

 - bridge: fix ioctl old_deviceless bridge argument

 - ice: xsk: do not clear status_error0 for ntu + nb_buffs descriptor,
	avoid stalls when multiple sockets use an interface

Previous releases - always broken:

 - inet: fully convert sk->sk_rx_dst to RCU rules

 - veth: ensure skb entering GRO are not cloned

 - sched: fix zone matching for invalid conntrack state

 - bonding: fix ad_actor_system option setting to default

 - nf_tables: fix use-after-free in nft_set_catchall_destroy()

 - lantiq_xrx200: increase buffer reservation to avoid mem corruption

 - ice: xsk: avoid leaking app buffers during clean up

 - tun: avoid double free in tun_free_netdev

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aleksander Jan Bajkowski (1):
      net: lantiq_xrx200: increase buffer reservation

Alexander Lobakin (1):
      ice: remove dead store on XSK hotpath

David S. Miller (2):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Eric Dumazet (2):
      netfilter: nf_tables: fix use-after-free in nft_set_catchall_destroy()
      inet: fully convert sk->sk_rx_dst to RCU rules

Fernando Fernandez Mancera (1):
      bonding: fix ad_actor_system option setting to default

Florian Westphal (1):
      netfilter: ctnetlink: remove expired entries first

George Kennedy (1):
      tun: avoid double free in tun_free_netdev

Hayes Wang (2):
      r8152: fix the force speed doesn't work for RTL8156
      r8152: sync ocp base

Heiner Kallweit (1):
      igb: fix deadlock caused by taking RTNL in RPM resume path

Hoang Le (1):
      Revert "tipc: use consistent GFP flags"

Ignacy Gawędzki (1):
      netfilter: fix regression in looped (broad|multi)cast's MAC handling

Jakub Kicinski (2):
      Merge branch 'net-sched-fix-ct-zone-matching-for-invalid-conntrack-state'
      Merge branch 'r8152-fix-bugs'

Jeroen de Borst (1):
      gve: Correct order of processing device options

Jiasheng Jiang (6):
      qlcnic: potential dereference null pointer of rx_queue->page_ring
      fjes: Check for error irq
      drivers: net: smc911x: Check for error irq
      net: ks8851: Check for error irq
      sfc: Check null pointer of rx_queue->page_ring
      sfc: falcon: Check null pointer of rx_queue->page_ring

Johannes Berg (1):
      mac80211: fix locking in ieee80211_start_ap error path

Lin Ma (2):
      hamradio: improve the incomplete fix to avoid NPD
      ax25: NPD bug when detaching AX25 device

Maciej Fijalkowski (5):
      ice: xsk: return xsk buffers back to pool when cleaning the ring
      ice: xsk: allocate separate memory for XDP SW ring
      ice: xsk: do not clear status_error0 for ntu + nb_buffs descriptor
      ice: xsk: allow empty Rx descriptors on XSK ZC data path
      ice: xsk: fix cleaned_count setting

Nobuhiro Iwamatsu (1):
      net: stmmac: dwmac-visconti: Fix value of ETHER_CLK_SEL_FREQ_SEL_2P5M

Paolo Abeni (1):
      veth: ensure skb entering GRO are not cloned.

Paul Blakey (3):
      net/sched: Extend qdisc control block with tc control block
      net/sched: flow_dissector: Fix matching on zone id for invalid conns
      net: openvswitch: Fix matching zone id for invalid conns arriving from tc

Pavel Skripkin (2):
      asix: fix uninit-value in asix_mdio_read()
      asix: fix wrong return value in asix_check_host_enable()

Remi Pommarel (1):
      net: bridge: fix ioctl old_deviceless bridge argument

Rémi Denis-Courmont (1):
      phonet/pep: refuse to enable an unbound pipe

Sean Anderson (1):
      docs: networking: dpaa2: Fix DPNI header

Willem de Bruijn (3):
      docs: networking: replace skb_hwtstamp_tx with skb_tstamp_tx
      net: accept UFOv6 packages in virtio_net_hdr_to_skb
      net: skip virtio_net_hdr_set_proto if protocol already set

Xiang wangx (1):
      net: fix typo in a comment

Xiaoliang Yang (2):
      net: dsa: tag_ocelot: use traffic class to map priority on injected header
      net: stmmac: ptp: fix potentially overflowing expression

Yevhen Orlov (2):
      net: marvell: prestera: fix incorrect return of port_find
      net: marvell: prestera: fix incorrect structure access

 Documentation/networking/bonding.rst               |  11 +-
 .../ethernet/freescale/dpaa2/overview.rst          |   1 +
 Documentation/networking/timestamping.rst          |   4 +-
 drivers/net/bonding/bond_options.c                 |   2 +-
 drivers/net/ethernet/google/gve/gve_adminq.c       |   8 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |  17 +++
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  19 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.h          |   1 -
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  66 ++++++------
 drivers/net/ethernet/intel/igb/igb_main.c          |  19 ++--
 drivers/net/ethernet/lantiq_xrx200.c               |  34 ++++--
 .../net/ethernet/marvell/prestera/prestera_main.c  |  35 ++++---
 drivers/net/ethernet/micrel/ks8851_par.c           |   2 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h  |   2 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |  12 ++-
 .../net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c   |   4 +-
 drivers/net/ethernet/sfc/falcon/rx.c               |   5 +-
 drivers/net/ethernet/sfc/rx_common.c               |   5 +-
 drivers/net/ethernet/smsc/smc911x.c                |   5 +
 .../net/ethernet/stmicro/stmmac/dwmac-visconti.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   2 +-
 drivers/net/fjes/fjes_main.c                       |   5 +
 drivers/net/hamradio/mkiss.c                       |   4 +-
 drivers/net/tun.c                                  | 115 +++++++++++----------
 drivers/net/usb/asix_common.c                      |   8 +-
 drivers/net/usb/r8152.c                            |  43 +++++++-
 drivers/net/veth.c                                 |   8 +-
 include/linux/netdevice.h                          |   2 +-
 include/linux/skbuff.h                             |   3 +-
 include/linux/virtio_net.h                         |  25 ++++-
 include/net/pkt_sched.h                            |  16 +++
 include/net/sch_generic.h                          |   2 -
 include/net/sock.h                                 |   2 +-
 net/ax25/af_ax25.c                                 |   4 +-
 net/bridge/br_ioctl.c                              |   2 +-
 net/core/dev.c                                     |   8 +-
 net/core/flow_dissector.c                          |   3 +-
 net/dsa/tag_ocelot.c                               |   6 +-
 net/ipv4/af_inet.c                                 |   2 +-
 net/ipv4/tcp.c                                     |   3 +-
 net/ipv4/tcp_input.c                               |   2 +-
 net/ipv4/tcp_ipv4.c                                |  11 +-
 net/ipv4/udp.c                                     |   6 +-
 net/ipv6/tcp_ipv6.c                                |  11 +-
 net/ipv6/udp.c                                     |   4 +-
 net/mac80211/cfg.c                                 |   3 +
 net/netfilter/nf_conntrack_netlink.c               |   5 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/nfnetlink_log.c                      |   3 +-
 net/netfilter/nfnetlink_queue.c                    |   3 +-
 net/openvswitch/flow.c                             |   8 +-
 net/phonet/pep.c                                   |   2 +
 net/sched/act_ct.c                                 |  15 +--
 net/sched/cls_api.c                                |   7 +-
 net/sched/cls_flower.c                             |   6 +-
 net/sched/sch_frag.c                               |   3 +-
 net/tipc/crypto.c                                  |   8 +-
 57 files changed, 405 insertions(+), 213 deletions(-)
