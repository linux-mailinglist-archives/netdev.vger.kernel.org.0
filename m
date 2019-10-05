Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABEC9CC740
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 03:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbfJEBrS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 4 Oct 2019 21:47:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60982 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfJEBrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 21:47:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58FB714F3AC24;
        Fri,  4 Oct 2019 18:47:17 -0700 (PDT)
Date:   Fri, 04 Oct 2019 18:47:16 -0700 (PDT)
Message-Id: <20191004.184716.781001651692902038.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 18:47:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) ieeeu02154 atusb driver use and free, from Johan Hovold.

2) Need to validate TCA_CBQ_WRROPT netlink attributes, from Eric
   Dumazet.

3) txq null deref in mac80211, from Miaoqing Pan.

4) ionic driver needs to select NET_DEVLINK, from Arnd Bergmann.

5) Need to disable bh during nft_connlimit GC, from Pablo Neira Ayuso.

6) Avoid division by zero in taprio scheduler, from Vladimir Oltean.

7) Various xgmac fixes in stmmac driver from Jose Abreu.

8) Avoid 64-bit division in mlx5 leading to link errors on 32-bit
   from Michal Kubecek.

9) Fix bad VLAN check in rtl8366 DSA driver, from Linus Walleij.

10) Fix sleep while atomic in sja1105, from Vladimir Oltean.

11) Suspend/resume deadlock in stmmac, from Thierry Reding.

12) Various UDP GSO fixes from Josh Hunt.

13) Fix slab out of bounds access in tcp_zerocopy_receive(), from
    Eric Dumazet.

14) Fix OOPS in __ipv6_ifa_notify(), from David Ahern.

15) Memory leak in NFC's llcp_sock_bind, from Eric Dumazet.

Please pull, thanks a lot!

The following changes since commit 02dc96ef6c25f990452c114c59d75c368a1f4c8f:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2019-09-28 17:47:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net 

for you to fetch changes up to ef129d34149ea23d0d442844fc25ae26a85589fc:

  selftests/net: add nettest to .gitignore (2019-10-04 18:36:34 -0700)

----------------------------------------------------------------
Adam Zerella (1):
      docs: networking: Add title caret and missing doc

Alexey Dobriyan (1):
      net: make sock_prot_memory_pressure() return "const char *"

Andrea Merello (1):
      net: phy: allow for reset line to be tied to a sleepy GPIO controller

Arnd Bergmann (1):
      ionic: select CONFIG_NET_DEVLINK

Christophe JAILLET (1):
      ieee802154: mcr20a: simplify a bit 'mcr20a_handle_rx_read_buf_complete()'

David Ahern (3):
      ipv6: Handle race in addrconf_dad_work
      Revert "ipv6: Handle race in addrconf_dad_work"
      ipv6: Handle missing host route in __ipv6_ifa_notify

David Howells (1):
      rxrpc: Fix rxrpc_recvmsg tracepoint

David S. Miller (6):
      Merge tag 'ieee802154-for-davem-2019-09-28' of git://git.kernel.org/.../sschmidt/wpan
      Merge tag 'mac80211-for-davem-2019-10-01' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'stmmac-fixes'
      Merge branch 'SJA1105-DSA-locking-fixes-for-PTP'
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'Fix-regression-with-AR8035-speed-downgrade'

Dexuan Cui (1):
      vsock: Fix a lockdep warning in __vsock_release()

Dongli Zhang (1):
      xen-netfront: do not use ~0U as error return value for xennet_fill_frags()

Dotan Barak (1):
      net/rds: Fix error handling in rds_ib_add_one()

Eric Dumazet (6):
      sch_cbq: validate TCA_CBQ_WRROPT to avoid crash
      tcp: adjust rto_base in retransmits_timed_out()
      ipv6: drop incoming packets having a v4mapped source address
      tcp: fix slab-out-of-bounds in tcp_zerocopy_receive()
      sch_dsmark: fix potential NULL deref in dsmark_init()
      nfc: fix memory leak in llcp_sock_bind()

Florian Westphal (1):
      netfilter: drop bridge nf reset from nf_reset

Haishuang Yan (1):
      erspan: remove the incorrect mtu limit for erspan

Jakub Kicinski (1):
      selftests/net: add nettest to .gitignore

Johan Hovold (2):
      ieee802154: atusb: fix use-after-free at disconnect
      hso: fix NULL-deref on tty open

Johannes Berg (4):
      nl80211: validate beacon head
      cfg80211: validate SSID/MBSSID element ordering assumption
      cfg80211: initialize on-stack chandefs
      mac80211: keep BHs disabled while calling drv_tx_wake_queue()

Jose Abreu (9):
      net: stmmac: xgmac: Not all Unicast addresses may be available
      net: stmmac: xgmac: Detect Hash Table size dinamically
      net: stmmac: selftests: Always use max DMA size in Jumbo Test
      net: stmmac: dwmac4: Always update the MAC Hash Filter
      net: stmmac: Correctly take timestamp for PTPv2
      net: stmmac: Do not stop PHY if WoL is enabled
      net: stmmac: xgmac: Disable the Timestamp interrupt by default
      net: stmmac: xgmac: Fix RSS not writing all Keys to HW
      net: stmmac: xgmac: Fix RSS writing wrong keys

Josh Hunt (2):
      udp: fix gso_segs calculations
      udp: only do GSO if # of segs > 1

Kai-Heng Feng (1):
      r8152: Set macpassthru in reset_resume callback

Linus Walleij (1):
      net: dsa: rtl8366: Check VLAN ID and not ports

Lorenzo Bianconi (1):
      net: socionext: netsec: always grab descriptor lock

Martin KaFai Lau (1):
      net: Unpublish sk from sk_reuseport_cb before call_rcu

Miaoqing Pan (2):
      nl80211: fix null pointer dereference
      mac80211: fix txq null pointer dereference

Michal Kubecek (1):
      mlx5: avoid 64-bit division in dr_icm_pool_mr_create()

Michal Vok·Ë (1):
      net: dsa: qca8k: Use up to 7 ports for all operations

Navid Emamdoost (3):
      ieee802154: ca8210: prevent memory leak
      net: dsa: sja1105: Prevent leaking memory
      net: qlogic: Fix memory leak in ql_alloc_large_buffers

Oleksij Rempel (1):
      net: ag71xx: fix mdio subnode support

Pablo Neira Ayuso (1):
      netfilter: nft_connlimit: disable bh on garbage collection

Paolo Abeni (1):
      net: ipv4: avoid mixed n_redirects and rate_tokens usage

Randy Dunlap (1):
      lib: textsearch: fix escapes in example code

Reinhard Speyerer (1):
      qmi_wwan: add support for Cinterion CLS8 devices

Russell King (4):
      net: phy: fix write to mii-ctrl1000 register
      net: phy: extract link partner advertisement reading
      net: phy: extract pause mode
      net: phy: at803x: use operating parameters from PHY-specific status

Thierry Reding (1):
      net: stmmac: Avoid deadlock on suspend/resume

Tuong Lien (1):
      tipc: fix unlimited bundling of small messages

Vasundhara Volam (1):
      devlink: Fix error handling in param and info_get dumpit cb

Vishal Kulkarni (1):
      cxgb4:Fix out-of-bounds MSI-X info array access

Vladimir Oltean (7):
      net: dsa: sja1105: Ensure PTP time for rxtstamp reconstruction is not in the past
      net: sched: taprio: Fix potential integer overflow in taprio_set_picos_per_byte
      net: sched: taprio: Avoid division by zero on invalid link speed
      net: sched: cbs: Avoid division by zero when calculating the port rate
      net: dsa: sja1105: Initialize the meta_lock
      net: dsa: sja1105: Fix sleeping while atomic in .port_hwtstamp_set
      ptp_qoriq: Initialize the registers' spinlock before calling ptp_qoriq_settime

Wen Yang (2):
      net: mscc: ocelot: add missing of_node_put after calling of_get_child_by_name
      net: dsa: rtl8366rb: add missing of_node_put after calling of_get_child_by_name

Yizhuo (1):
      net: hisilicon: Fix usage of uninitialized variable in function mdio_sc_cfg_reg_write()

 Documentation/networking/device_drivers/index.rst              |  1 +
 Documentation/networking/j1939.rst                             |  2 +-
 drivers/net/dsa/qca8k.c                                        |  4 ++--
 drivers/net/dsa/rtl8366.c                                      | 11 +++++++----
 drivers/net/dsa/rtl8366rb.c                                    | 16 ++++++++++------
 drivers/net/dsa/sja1105/sja1105_main.c                         | 24 ++++++++++++++----------
 drivers/net/dsa/sja1105/sja1105_spi.c                          |  6 ++++--
 drivers/net/ethernet/atheros/ag71xx.c                          |  6 ++++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c                 |  9 ++++++---
 drivers/net/ethernet/hisilicon/hns_mdio.c                      |  6 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c |  3 ++-
 drivers/net/ethernet/mscc/ocelot_board.c                       | 14 ++++++++------
 drivers/net/ethernet/pensando/Kconfig                          |  1 +
 drivers/net/ethernet/qlogic/qla3xxx.c                          |  1 +
 drivers/net/ethernet/socionext/netsec.c                        | 30 +++++++-----------------------
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c              | 13 +++++++------
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h                 |  3 ++-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c            |  9 +++++----
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c             |  1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c              | 25 +++++++++++++++++--------
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c         |  4 ----
 drivers/net/ieee802154/atusb.c                                 |  3 ++-
 drivers/net/ieee802154/ca8210.c                                |  2 +-
 drivers/net/ieee802154/mcr20a.c                                |  2 +-
 drivers/net/phy/at803x.c                                       | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/phy/mdio_device.c                                  |  2 +-
 drivers/net/phy/phy-core.c                                     | 20 +++++++++++++-------
 drivers/net/phy/phy.c                                          |  5 +++++
 drivers/net/phy/phy_device.c                                   | 65 ++++++++++++++++++++++++++++++++++++++++-------------------------
 drivers/net/ppp/pptp.c                                         |  4 ++--
 drivers/net/tun.c                                              |  2 +-
 drivers/net/usb/hso.c                                          | 12 ++++++++----
 drivers/net/usb/qmi_wwan.c                                     |  1 +
 drivers/net/usb/r8152.c                                        |  3 +--
 drivers/net/virtio_net.c                                       |  2 +-
 drivers/net/vrf.c                                              |  8 ++++----
 drivers/net/wireless/mac80211_hwsim.c                          |  4 ++--
 drivers/net/xen-netfront.c                                     | 17 +++++++++--------
 drivers/ptp/ptp_qoriq.c                                        |  3 ++-
 drivers/staging/octeon/ethernet-tx.c                           |  6 ++----
 include/linux/dsa/sja1105.h                                    |  4 +++-
 include/linux/mii.h                                            |  9 +++++++++
 include/linux/phy.h                                            |  2 ++
 include/linux/skbuff.h                                         |  5 +----
 include/trace/events/rxrpc.h                                   |  2 +-
 lib/textsearch.c                                               |  4 ++--
 net/batman-adv/soft-interface.c                                |  2 +-
 net/core/devlink.c                                             |  6 +++---
 net/core/skbuff.c                                              |  2 +-
 net/core/sock.c                                                | 13 +++++++++----
 net/dccp/ipv4.c                                                |  2 +-
 net/dsa/tag_sja1105.c                                          | 12 +++++++++++-
 net/ipv4/ip_gre.c                                              |  1 +
 net/ipv4/ip_input.c                                            |  2 +-
 net/ipv4/ipmr.c                                                |  4 ++--
 net/ipv4/netfilter/nf_dup_ipv4.c                               |  2 +-
 net/ipv4/raw.c                                                 |  2 +-
 net/ipv4/route.c                                               |  5 ++---
 net/ipv4/tcp.c                                                 |  6 ++----
 net/ipv4/tcp_ipv4.c                                            |  2 +-
 net/ipv4/tcp_timer.c                                           |  9 +++++++--
 net/ipv4/udp.c                                                 | 15 +++++++++------
 net/ipv6/addrconf.c                                            | 17 ++++++++++++-----
 net/ipv6/ip6_input.c                                           | 12 +++++++++++-
 net/ipv6/netfilter/nf_dup_ipv6.c                               |  2 +-
 net/ipv6/raw.c                                                 |  2 +-
 net/ipv6/udp.c                                                 |  9 +++++++--
 net/l2tp/l2tp_core.c                                           |  2 +-
 net/l2tp/l2tp_eth.c                                            |  2 +-
 net/l2tp/l2tp_ip.c                                             |  2 +-
 net/l2tp/l2tp_ip6.c                                            |  2 +-
 net/mac80211/debugfs_netdev.c                                  | 11 +++++++++--
 net/mac80211/util.c                                            | 13 ++++++++-----
 net/netfilter/ipvs/ip_vs_xmit.c                                |  2 +-
 net/netfilter/nft_connlimit.c                                  |  7 ++++++-
 net/nfc/llcp_sock.c                                            |  7 ++++++-
 net/openvswitch/vport-internal_dev.c                           |  2 +-
 net/packet/af_packet.c                                         |  4 ++--
 net/rds/ib.c                                                   |  6 +++---
 net/sched/sch_cbq.c                                            | 43 +++++++++++++++++++++++++++++--------------
 net/sched/sch_cbs.c                                            |  2 +-
 net/sched/sch_dsmark.c                                         |  2 ++
 net/sched/sch_taprio.c                                         |  5 ++---
 net/sctp/input.c                                               |  2 +-
 net/tipc/link.c                                                | 29 ++++++++++++++++++-----------
 net/tipc/msg.c                                                 |  5 +----
 net/vmw_vsock/af_vsock.c                                       | 16 ++++++++++++----
 net/vmw_vsock/hyperv_transport.c                               |  2 +-
 net/vmw_vsock/virtio_transport_common.c                        |  2 +-
 net/wireless/nl80211.c                                         | 44 +++++++++++++++++++++++++++++++++++++++++---
 net/wireless/reg.c                                             |  2 +-
 net/wireless/scan.c                                            |  7 ++++++-
 net/wireless/wext-compat.c                                     |  2 +-
 net/xfrm/xfrm_input.c                                          |  2 +-
 net/xfrm/xfrm_interface.c                                      |  2 +-
 net/xfrm/xfrm_output.c                                         |  2 +-
 net/xfrm/xfrm_policy.c                                         |  2 +-
 tools/testing/selftests/net/.gitignore                         |  1 +
 tools/testing/selftests/net/udpgso.c                           | 16 ++++------------
 99 files changed, 539 insertions(+), 281 deletions(-)
