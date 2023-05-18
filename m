Return-Path: <netdev+bounces-3646-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5254970829F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:26:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D510C281812
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9427823C94;
	Thu, 18 May 2023 13:26:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8237A23C8E
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 13:26:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A789EC
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684416387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=h6WZ53qnPThaK8hnheUrLtjB0x9EmlXz0f/GQCT0Kg0=;
	b=YoBK0AVqj72Ydy+9qE1dgaeW+pesrCnI6mUaUeOmy+D85urAJBi4QQkaXfpgq/Q8/pe5mM
	e0xfXZ/t3dMRfAsppgReIvybO9Og0LyHCrl7mtqa405Gpnhf6q5O73nbzV6cjb7CPUAVpP
	KvxRtsUNHwfBOYxdLSQs3JJv6AL85ak=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-219-HXpGK5bhOVC43C11xMUnPg-1; Thu, 18 May 2023 09:26:22 -0400
X-MC-Unique: HXpGK5bhOVC43C11xMUnPg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B859380101C;
	Thu, 18 May 2023 13:26:21 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.55])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 789CE14171C0;
	Thu, 18 May 2023 13:26:19 +0000 (UTC)
From: Paolo Abeni <pabeni@redhat.com>
To: torvalds@linux-foundation.org
Cc: kuba@kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.4-rc3
Date: Thu, 18 May 2023 15:25:54 +0200
Message-Id: <20230518132554.41223-1-pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Linus!

The following changes since commit 6e27831b91a0bc572902eb065b374991c1ef452a:

  Merge tag 'net-6.4-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-05-11 08:42:47 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.4-rc3

for you to fetch changes up to 6e42fae0a15519393d3cc5500dc8d84b8549a337:

  Merge tag 'linux-can-fixes-for-6.4-20230518' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can (2023-05-18 11:06:29 +0200)

----------------------------------------------------------------
Networking fixes for 6.4-rc3, including fixes from can, xfrm,
bluetooth and netfilter.

Current release - regressions:

  - ipv6: fix RCU splat in ipv6_route_seq_show()

  - wifi: iwlwifi: disable RFI feature

Previous releases - regressions:

  - tcp: fix possible sk_priority leak in tcp_v4_send_reset()

  - tipc: do not update mtu if msg_max is too small in mtu negotiation

  - netfilter: fix null deref on element insertion

  - devlink: change per-devlink netdev notifier to static one

  - phylink: fix ksettings_set() ethtool call

  - wifi: mac80211: fortify the spinlock against deadlock by interrupt

  - wifi: brcmfmac: check for probe() id argument being NULL

  - eth: ice:
    - fix undersized tx_flags variable
    - fix ice VF reset during iavf initialization

  - eth: hns3: fix sending pfc frames after reset issue

Previous releases - always broken:

  - xfrm: release all offloaded policy memory

  - nsh: use correct mac_offset to unwind gso skb in nsh_gso_segment()

  - vsock: avoid to close connected socket after the timeout

  - dsa: rzn1-a5psw: enable management frames for CPU port

  - eth: virtio_net: fix error unwinding of XDP initialization

  - eth: tun: fix memory leak for detached NAPI queue.

Misc:

  - MAINTAINERS: sctp: move Neil to CREDITS

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Ahmed Zaki (2):
      ice: Fix stats after PF reset
      iavf: send VLAN offloading caps once after VFR

Aleksandr Loktionov (1):
      igb: fix bit_shift to be in [1..8] range

Alexis Lothoré (1):
      net: dsa: rzn1-a5psw: fix STP states handling

Alon Giladi (2):
      wifi: iwlwifi: fix OEM's name in the ppag approved list
      wifi: iwlwifi: mvm: fix OEM's name in the tas approved list

Andrea Mayer (2):
      selftests: seg6: disable DAD on IPv6 router cfg for srv6_end_dt4_l3vpn_test
      selftets: seg6: disable rp_filter by default in srv6_end_dt4_l3vpn_test

Ariel Malamud (1):
      wifi: iwlwifi: mvm: Add locking to the rate read flow

Arnd Bergmann (5):
      wifi: b43: fix incorrect __packed annotation
      net: isa: include net/Space.h
      atm: hide unused procfs functions
      bridge: always declare tunnel functions
      mdio_bus: unhide mdio_bus_init prototype

Benedict Wong (1):
      xfrm: Check if_id in inbound policy/secpath match

Benjamin Poirier (1):
      net: selftests: Fix optstring

Christophe JAILLET (2):
      wifi: mac80211: Fix puncturing bitmap handling in __ieee80211_csa_finalize()
      cassini: Fix a memory leak in the error handling path of cas_init_one()

Clément Léger (2):
      net: dsa: rzn1-a5psw: enable management frames for CPU port
      net: dsa: rzn1-a5psw: disable learning for standalone ports

Dario Binacchi (5):
      dt-bindings: net: can: add "st,can-secondary" property
      ARM: dts: stm32f429: put can2 in secondary mode
      ARM: dts: stm32: add pin map for CAN controller on stm32f7
      can: bxcan: add support for single peripheral configuration
      ARM: dts: stm32: add CAN support on stm32f746

David S. Miller (4):
      Merge branch 'dsa-rzn1-a5psw-stp'
      Merge branch 'hns3-fixes'
      Merge branch 'tipc-fixes'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Dawid Wesierski (1):
      ice: Fix ice VF reset during iavf initialization

Dong Chenchen (1):
      net: nsh: Use correct mac_offset to unwind gso skb in nsh_gso_segment()

Eric Dumazet (3):
      ipv6: remove nexthop_fib6_nh_bh()
      tcp: fix possible sk_priority leak in tcp_v4_send_reset()
      vlan: fix a potential uninit-value in vlan_dev_hard_start_xmit()

Feng Liu (1):
      virtio_net: Fix error unwinding of XDP initialization

Florian Fainelli (1):
      net: bcmgenet: Restore phy_stop() depending upon suspend/close

Florian Westphal (2):
      netfilter: nf_tables: fix nft_trans type confusion
      netfilter: nft_set_rbtree: fix null deref on element insertion

Geert Uytterhoeven (1):
      can: CAN_BXCAN should depend on ARCH_STM32

Gregory Greenman (2):
      wifi: iwlwifi: mvm: rfi: disable RFI feature
      wifi: iwlwifi: mvm: fix access to fw_id_to_mac_id

Grygorii Strashko (1):
      net: phy: dp83867: add w/a for packet errors seen with short cables

Hans de Goede (1):
      wifi: brcmfmac: Check for probe() id argument being NULL

Huayu Chen (1):
      nfp: fix NFP_NET_MAX_DSCP definition error

Ido Schimmel (1):
      devlink: Fix crash with CONFIG_NET_NS=n

Ilan Peer (1):
      wifi: cfg80211: Drop entries with invalid BSSIDs in RNR

Jakub Kicinski (8):
      Merge branch 'selftests-seg6-make-srv6_end_dt4_l3vpn_test-more-robust'
      MAINTAINERS: don't CC docs@ for netlink spec changes
      MAINTAINERS: exclude wireless drivers from netdev
      Merge tag 'linux-can-fixes-for-6.4-20230515' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge tag 'ipsec-2023-05-16' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec
      MAINTAINERS: skip CCing netdev for Bluetooth patches
      Merge tag 'wireless-2023-05-17' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge tag 'nf-23-05-17' of https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf

Jan Sokolowski (1):
      ice: Fix undersized tx_flags variable

Jie Wang (2):
      net: hns3: fix output information incomplete for dumping tx queue info with debugfs
      net: hns3: fix reset delay time to avoid configuration timeout

Jijie Shao (2):
      net: hns3: fix sending pfc frames after reset issue
      net: hns3: fix reset timeout when enable full VF

Jimmy Assarsson (6):
      can: kvaser_pciefd: Set CAN_STATE_STOPPED in kvaser_pciefd_stop()
      can: kvaser_pciefd: Clear listen-only bit if not explicitly requested
      can: kvaser_pciefd: Call request_irq() before enabling interrupts
      can: kvaser_pciefd: Empty SRB buffer in probe
      can: kvaser_pciefd: Do not send EFLUSH command on TFD interrupt
      can: kvaser_pciefd: Disable interrupts in probe error path

Jiri Pirko (1):
      devlink: change per-devlink netdev notifier to static one

Johannes Berg (10):
      wifi: mac80211: fix min center freq offset tracing
      wifi: mac80211: simplify chanctx allocation
      wifi: mac80211: consider reserved chanctx for mindef
      wifi: mac80211: recalc chanctx mindef before assigning
      wifi: iwlwifi: mvm: always free dup_data
      wifi: iwlwifi: mvm: don't double-init spinlock
      wifi: iwlwifi: mvm: fix cancel_delayed_work_sync() deadlock
      wifi: iwlwifi: mvm: fix number of concurrent link checks
      wifi: iwlwifi: fw: fix DBGI dump
      wifi: iwlwifi: mvm: don't trust firmware n_channels

Kai-Heng Feng (1):
      net: wwan: t7xx: Ensure init is completed before system sleep

Kuniyuki Iwashima (1):
      tun: Fix memory leak for detached NAPI queue.

Leon Romanovsky (2):
      xfrm: release all offloaded policy memory
      xfrm: Fix leak of dev tracker

M Chetan Kumar (1):
      net: wwan: iosm: fix NULL pointer dereference when removing device

Marc Kleine-Budde (3):
      Merge patch series "can: bxcan: add support for single peripheral configuration"
      Merge patch series "can: kvaser_pciefd: Bug fixes"
      Revert "ARM: dts: stm32: add CAN support on stm32f746"

Marcelo Ricardo Leitner (1):
      MAINTAINERS: sctp: move Neil to CREDITS

Marco Migliore (1):
      net: dsa: mv88e6xxx: Fix mv88e6393x EPC write command offset

Martin Blumenstingl (1):
      wifi: rtw88: sdio: Always use two consecutive bytes for word operations

Martin Willi (1):
      Revert "Fix XFRM-I support for nested ESP tunnels"

Michael Lee (1):
      wifi: mac80211: Abort running color change when stopping the AP

Miri Korenblit (1):
      wifi: iwlwifi: Don't use valid_links to iterate sta links

Mirsad Goran Todorovac (1):
      wifi: mac80211: fortify the spinlock against deadlock by interrupt

Mukesh Sisodiya (1):
      wifi: iwlwifi: mvm: fix initialization of a return value

Nikolay Aleksandrov (1):
      mailmap: add entries for Nikolay Aleksandrov

Oliver Hartkopp (3):
      can: isotp: recvmsg(): allow MSG_CMSG_COMPAT flag
      can: j1939: recvmsg(): allow MSG_CMSG_COMPAT flag
      can: dev: fix missing CAN XL support in can_put_echo_skb()

Paolo Abeni (1):
      Merge tag 'linux-can-fixes-for-6.4-20230518' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can

Pieter Jansen van Vuuren (1):
      sfc: disable RXFCS and RXALL features by default

Ping-Ke Shih (3):
      wifi: rtw89: 8852b: adjust quota to avoid SER L1 caused by access null page
      wifi: rtw88: use work to update rate to avoid RCU warning
      wifi: rtw88: correct qsel_to_ep[] type as int

Russell King (Oracle) (2):
      net: mdio: i2c: fix rollball accessors
      net: phylink: fix ksettings_set() ethtool call

Ryder Lee (2):
      wifi: mt76: mt7996: fix endianness of MT_TXD6_TX_RATE
      wifi: mt76: connac: fix stats->tx_bytes calculation

Sabrina Dubroca (1):
      xfrm: don't check the default policy if the policy allows the packet

Shenwei Wang (1):
      net: fec: remove the xdp_return_frame when lack of tx BDs

Tobias Brunner (2):
      xfrm: Reject optional tunnel/BEET mode templates in outbound policies
      af_key: Reject optional tunnel/BEET mode templates in outbound policies

Tom Rix (1):
      netfilter: conntrack: define variables exp_nat_nla_policy and any_addr with CONFIG_NF_NAT

Uwe Kleine-König (1):
      net: fec: Better handle pm_runtime_get() failing in .remove()

Vladimir Oltean (1):
      net: pcs: xpcs: fix C73 AN not getting enabled

Xin Long (4):
      erspan: get the proto with the md version for collect_md
      tipc: add tipc_bearer_min_mtu to calculate min mtu
      tipc: do not update mtu if msg_max is too small in mtu negotiation
      tipc: check the bearer min mtu properly when setting it by netlink

Yun Lu (1):
      wifi: rtl8xxxu: fix authentication timeout due to incorrect RCR value

Zhengchao Shao (1):
      mac80211_hwsim: fix memory leak in hwsim_new_radio_nl

Zhuang Shengen (1):
      vsock: avoid to close connected socket after the timeout

 .mailmap                                           |  5 ++
 CREDITS                                            |  4 ++
 .../bindings/net/can/st,stm32-bxcan.yaml           | 19 +++--
 MAINTAINERS                                        |  7 +-
 arch/arm/boot/dts/stm32f429.dtsi                   |  1 +
 arch/arm/boot/dts/stm32f7-pinctrl.dtsi             | 82 +++++++++++++++++++++
 drivers/net/can/Kconfig                            |  2 +-
 drivers/net/can/bxcan.c                            | 34 ++++++---
 drivers/net/can/dev/skb.c                          |  3 +-
 drivers/net/can/kvaser_pciefd.c                    | 51 +++++++------
 drivers/net/dsa/mv88e6xxx/port.h                   |  2 +-
 drivers/net/dsa/rzn1_a5psw.c                       | 83 +++++++++++++++++-----
 drivers/net/dsa/rzn1_a5psw.h                       |  3 +-
 drivers/net/ethernet/3com/3c515.c                  |  4 +-
 drivers/net/ethernet/8390/ne.c                     |  1 +
 drivers/net/ethernet/8390/smc-ultra.c              |  1 +
 drivers/net/ethernet/8390/wd.c                     |  1 +
 drivers/net/ethernet/amd/lance.c                   |  1 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  8 ++-
 drivers/net/ethernet/cirrus/cs89x0.c               |  2 +
 drivers/net/ethernet/freescale/fec_main.c          | 16 +++--
 .../hisilicon/hns3/hns3_common/hclge_comm_cmd.c    | 25 +++++--
 .../hisilicon/hns3/hns3_common/hclge_comm_cmd.h    |  8 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |  1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 15 ++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  4 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |  5 ++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  5 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  5 --
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c       |  5 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |  5 ++
 drivers/net/ethernet/intel/ice/ice_sriov.c         |  8 +--
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  8 +--
 drivers/net/ethernet/intel/ice/ice_txrx.h          |  9 +--
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        | 19 +++++
 drivers/net/ethernet/intel/ice/ice_vf_lib.h        |  1 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |  1 +
 drivers/net/ethernet/intel/igb/e1000_mac.c         |  4 +-
 drivers/net/ethernet/netronome/nfp/nic/main.h      |  2 +-
 drivers/net/ethernet/sfc/ef100_netdev.c            |  4 +-
 drivers/net/ethernet/sun/cassini.c                 |  2 +
 drivers/net/mdio/mdio-i2c.c                        | 15 ++--
 drivers/net/pcs/pcs-xpcs.c                         |  2 +-
 drivers/net/phy/dp83867.c                          | 22 +++++-
 drivers/net/phy/phylink.c                          |  8 +--
 drivers/net/tun.c                                  | 15 ++++
 drivers/net/virtio_net.c                           | 61 +++++++++++-----
 drivers/net/wireless/broadcom/b43/b43.h            |  2 +-
 .../net/wireless/broadcom/b43legacy/b43legacy.h    |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  5 ++
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 11 +++
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 11 +++
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 19 ++---
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |  5 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/link.c      | 12 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 55 +++++++-------
 .../net/wireless/intel/iwlwifi/mvm/mld-mac80211.c  |  9 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c   | 14 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       | 10 +++
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c       | 16 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  9 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 13 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  2 +-
 .../net/wireless/mediatek/mt76/mt76_connac2_mac.h  |  2 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |  3 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |  2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  4 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |  2 +-
 drivers/net/wireless/realtek/rtw88/main.c          | 15 ++++
 drivers/net/wireless/realtek/rtw88/main.h          |  3 +
 drivers/net/wireless/realtek/rtw88/sdio.c          |  8 ---
 drivers/net/wireless/realtek/rtw88/usb.h           |  2 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |  4 ++
 drivers/net/wireless/realtek/rtw89/mac.h           |  2 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      | 28 ++++----
 drivers/net/wireless/virtual/mac80211_hwsim.c      |  3 +-
 drivers/net/wwan/iosm/iosm_ipc_imem.c              | 27 +++++--
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c          | 12 ++--
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h          |  6 +-
 drivers/net/wwan/t7xx/t7xx_pci.c                   | 18 +++++
 drivers/net/wwan/t7xx/t7xx_pci.h                   |  1 +
 include/linux/phy.h                                |  2 -
 include/net/nexthop.h                              | 23 ------
 net/8021q/vlan_dev.c                               |  4 +-
 net/atm/resources.c                                |  2 +
 net/bridge/br_private_tunnel.h                     |  8 +--
 net/can/isotp.c                                    |  2 +-
 net/can/j1939/socket.c                             |  2 +-
 net/devlink/core.c                                 | 16 ++---
 net/devlink/devl_internal.h                        |  1 -
 net/devlink/leftover.c                             |  5 +-
 net/ipv4/tcp_ipv4.c                                |  5 +-
 net/ipv6/ip6_fib.c                                 | 16 ++---
 net/ipv6/ip6_gre.c                                 | 13 ++--
 net/key/af_key.c                                   | 12 ++--
 net/mac80211/cfg.c                                 |  7 +-
 net/mac80211/chan.c                                | 75 +++++++++++--------
 net/mac80211/ieee80211_i.h                         |  3 +-
 net/mac80211/trace.h                               |  2 +-
 net/mac80211/tx.c                                  |  5 +-
 net/mac80211/util.c                                |  2 +-
 net/netfilter/nf_conntrack_netlink.c               |  4 ++
 net/netfilter/nf_tables_api.c                      |  4 +-
 net/netfilter/nft_set_rbtree.c                     | 20 ++++--
 net/nsh/nsh.c                                      |  8 +--
 net/tipc/bearer.c                                  | 17 ++++-
 net/tipc/bearer.h                                  |  3 +
 net/tipc/link.c                                    |  9 ++-
 net/tipc/udp_media.c                               |  5 +-
 net/vmw_vsock/af_vsock.c                           |  2 +-
 net/wireless/scan.c                                |  6 +-
 net/xfrm/xfrm_device.c                             |  2 +-
 net/xfrm/xfrm_interface_core.c                     | 54 ++------------
 net/xfrm/xfrm_policy.c                             | 20 ++----
 net/xfrm/xfrm_user.c                               | 15 ++--
 tools/testing/selftests/net/fib_nexthops.sh        |  2 +-
 .../selftests/net/srv6_end_dt4_l3vpn_test.sh       | 17 +++--
 123 files changed, 878 insertions(+), 455 deletions(-)


