Return-Path: <netdev+bounces-9198-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDC52727E98
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:19:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7412E2816AA
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B23A1096D;
	Thu,  8 Jun 2023 11:19:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270B5C8FC
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 11:19:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BDE26B1
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 04:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686223186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sAXJdd97KiFYY0e9r/91ZtcCxcSiQCLGezCoABjxuhc=;
	b=T1+qXyfMUYTpdbZC61yy0TODgdFn8f5cfUY4N0jyEs/MuSXRDhb8PZhrXoGNJ1RAhstroI
	Oc6y2s5vEjPMLQ0hM5AbH179OUWcPzDogxgegl/L192RGceu170kbBggpJSORIARIUlgyL
	JNOlR1HaqBNHpUkv1bhGm8iiPT8BrTM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-wVt6Y_ljNBKe-hI7StWpVg-1; Thu, 08 Jun 2023 07:19:42 -0400
X-MC-Unique: wVt6Y_ljNBKe-hI7StWpVg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 727AA3C0C892;
	Thu,  8 Jun 2023 11:19:42 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4272F2026D49;
	Thu,  8 Jun 2023 11:19:41 +0000 (UTC)
From: Paolo Abeni <pabeni@redhat.com>
To: torvalds@linux-foundation.org
Cc: kuba@kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.4-rc6
Date: Thu,  8 Jun 2023 13:19:34 +0200
Message-Id: <20230608111934.18511-1-pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Linus!

The netfilter issue you have been notified is a WIP.

The following changes since commit 714069daa5d345483578e2ff77fb6f06f4dcba6a:

  Merge tag 'net-6.4-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-06-01 17:29:18 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.4-rc6

for you to fetch changes up to 6c0ec7ab5aaff3706657dd4946798aed483b9471:

  Merge branch 'bnxt_en-bug-fixes' (2023-06-08 10:52:48 +0200)

----------------------------------------------------------------
Networking fixes for 6.4-rc6, including fixes from can, wifi, netfilter,
bluetooth and ebpf.

Current release - regressions:

  - bpf: sockmap: avoid potential NULL dereference in sk_psock_verdict_data_ready()

  - wifi: iwlwifi: fix -Warray-bounds bug in iwl_mvm_wait_d3_notif()

  - phylink: actually fix ksettings_set() ethtool call

  - eth: dwmac-qcom-ethqos: fix a regression on EMAC < 3

Current release - new code bugs:

  - wifi: mt76: fix possible NULL pointer dereference in mt7996_mac_write_txwi()

Previous releases - regressions:

  - netfilter: fix NULL pointer dereference in nf_confirm_cthelper

  - wifi: rtw88/rtw89: correct PS calculation for SUPPORTS_DYNAMIC_PS

  - openvswitch: fix upcall counter access before allocation

  - bluetooth:
    - fix use-after-free in hci_remove_ltk/hci_remove_irk
    - fix l2cap_disconnect_req deadlock

  - nic: bnxt_en: prevent kernel panic when receiving unexpected PHC_UPDATE event

Previous releases - always broken:

  - core: annotate rfs lockless accesses

  - sched: fq_pie: ensure reasonable TCA_FQ_PIE_QUANTUM values

  - netfilter: add null check for nla_nest_start_noflag() in nft_dump_basechain_hook()

  - bpf: fix UAF in task local storage

  - ipv4: ping_group_range: allow GID from 2147483648 to 4294967294

  - ipv6: rpl: fix route of death.

  - tcp: gso: really support BIG TCP

  - mptcp: fixes for user-space PM address advertisement

  - smc: avoid to access invalid RMBs' MRs in SMCRv1 ADD LINK CONT

  - can: avoid possible use-after-free when j1939_can_rx_register fails

  - batman-adv: fix UaF while rescheduling delayed work

  - eth: qede: fix scheduling while atomic

  - eth: ice: make writes to /dev/gnssX synchronous

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Aditya Kumar Singh (1):
      wifi: mac80211: fix switch count in EMA beacons

Akihiro Suda (1):
      net/ipv4: ping_group_range: allow GID from 2147483648 to 4294967294

Alexander Sverdlin (1):
      net: dsa: lan9303: allow vid != 0 in port_fdb_{add|del} methods

Arnd Bergmann (1):
      net: dsa: qca8k: add CONFIG_LEDS_TRIGGERS dependency

Bartosz Golaszewski (1):
      net: stmmac: dwmac-qcom-ethqos: fix a regression on EMAC < 3

Ben Hutchings (1):
      lib: cpu_rmap: Fix potential use-after-free in irq_cpu_rmap_release()

Brett Creeley (2):
      pds_core: Fix FW recovery detection
      virtio_net: use control_buf for coalesce params

David S. Miller (4):
      Merge branch 'enetc-fixes'
      Merge tag 'linux-can-fixes-for-6.4-20230605' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'mptcp-addr-adv-fixes'
      Merge branch 'rfs-lockless-annotate'

Eelco Chaudron (1):
      net: openvswitch: fix upcall counter access before allocation

Eric Dumazet (10):
      bpf, sockmap: Avoid potential NULL dereference in sk_psock_verdict_data_ready()
      net/ipv6: fix bool/int mismatch for skip_notify_on_dev_down
      net/ipv6: convert skip_notify_on_dev_down sysctl to u8
      net/sched: fq_pie: ensure reasonable TCA_FQ_PIE_QUANTUM values
      tcp: gso: really support BIG TCP
      rfs: annotate lockless accesses to sk->sk_rxhash
      rfs: annotate lockless accesses to RFS sock flow table
      net: sched: add rcu annotations around qdisc->qdisc_sleeping
      net: sched: move rtm_tca_policy declaration to include file
      net: sched: act_police: fix sparse errors in tcf_police_dump()

Fedor Pchelkin (2):
      can: j1939: change j1939_netdev_lock type to mutex
      can: j1939: avoid possible use-after-free when j1939_can_rx_register fails

Florian Fainelli (1):
      net: bcmgenet: Fix EEE implementation

Florian Westphal (1):
      bpf: netfilter: Add BPF_NETFILTER bpf_attach_type

Gavrilov Ilia (1):
      netfilter: nf_tables: Add null check for nla_nest_start_noflag() in nft_dump_basechain_hook()

Geliang Tang (5):
      mptcp: only send RM_ADDR in nl_cmd_remove
      selftests: mptcp: update userspace pm addr tests
      mptcp: add address into userspace pm list
      selftests: mptcp: update userspace pm subflow tests
      mptcp: update userspace pm infos

Gustavo A. R. Silva (1):
      wifi: iwlwifi: mvm: Fix -Warray-bounds bug in iwl_mvm_wait_d3_notif()

Hangyu Hua (1):
      net: sched: fix possible refcount leak in tc_chain_tmplt_add()

Jakub Kicinski (9):
      Merge branch 'net-ipv6-skip_notify_on_dev_down-fix'
      netlink: specs: ethtool: fix random typos
      Merge tag 'wireless-2023-06-06' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge tag 'nf-23-06-07' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge tag 'for-net-2023-06-05' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      eth: bnxt: fix the wake condition
      eth: ixgbe: fix the wake condition
      Merge tag 'batadv-net-pullrequest-20230607' of git://git.open-mesh.org/linux-merge

Jeremy Sowden (1):
      netfilter: nft_bitwise: fix register tracking

Jiasheng Jiang (1):
      net: systemport: Replace platform_get_irq with platform_get_irq_optional

Jiri Olsa (1):
      bpf: Add extra path pointer check to d_path helper

Johan Hovold (2):
      Bluetooth: fix debugfs registration
      Bluetooth: hci_qca: fix debugfs registration

Johannes Berg (6):
      wifi: mac80211: use correct iftype HE cap
      wifi: cfg80211: reject bad AP MLD address
      wifi: mac80211: mlme: fix non-inheritence element
      wifi: mac80211: don't translate beacon/presp addrs
      wifi: cfg80211: fix locking in sched scan stop work
      wifi: cfg80211: fix locking in regulatory disconnect

KP Singh (1):
      bpf: Fix UAF in task local storage

Kuniyuki Iwashima (2):
      netfilter: ipset: Add schedule point in call_ad().
      ipv6: rpl: Fix Route of Death.

Lorenzo Bianconi (2):
      wifi: mt76: mt7615: fix possible race in mt7615_mac_sta_poll
      wifi: mt76: mt7996: fix possible NULL pointer dereference in mt7996_mac_write_txwi()

Luiz Augusto von Dentz (1):
      Bluetooth: Fix use-after-free in hci_remove_ltk/hci_remove_irk

Manish Chopra (1):
      qed/qede: Fix scheduling while atomic

Marc Kleine-Budde (1):
      Merge patch series "can: j1939: avoid possible use-after-free when j1939_can_rx_register fails"

Martin KaFai Lau (1):
      Merge branch 'Fix elem_size not being set for inner maps'

Michal Schmidt (1):
      ice: make writes to /dev/gnssX synchronous

Min-Hua Chen (1):
      net: sched: wrap tc_skip_wrapper with CONFIG_RETPOLINE

Oleksij Rempel (1):
      can: j1939: j1939_sk_send_loop_abort(): improved error queue handling in J1939 Socket

Pablo Neira Ayuso (1):
      netfilter: nf_tables: out-of-bound check in chain blob

Paolo Abeni (1):
      Merge branch 'bnxt_en-bug-fixes'

Pauli Virtanen (4):
      Bluetooth: ISO: consider right CIS when removing CIG at cleanup
      Bluetooth: ISO: Fix CIG auto-allocation to select configurable CIG
      Bluetooth: ISO: don't try to remove CIG if there are bound CIS left
      Bluetooth: ISO: use correct CIS order in Set CIG Parameters event

Pavan Chebbi (2):
      bnxt_en: Fix bnxt_hwrm_update_rss_hash_cfg()
      bnxt_en: Prevent kernel panic when receiving unexpected PHC_UPDATE event

Ping-Ke Shih (3):
      wifi: rtw88: correct PS calculation for SUPPORTS_DYNAMIC_PS
      wifi: rtw89: correct PS calculation for SUPPORTS_DYNAMIC_PS
      wifi: rtw89: remove redundant check of entering LPS

Qingfang DENG (1):
      neighbour: fix unaligned access to pneigh_entry

Rhys Rustad-Elliott (2):
      bpf: Fix elem_size not being set for inner maps
      selftests/bpf: Add access_inner_map selftest

Russell King (Oracle) (1):
      net: phylink: actually fix ksettings_set() ethtool call

Somnath Kotur (2):
      bnxt_en: Query default VLAN before VNIC setup on a VF
      bnxt_en: Implement .set_port / .unset_port UDP tunnel callbacks

Sreekanth Reddy (1):
      bnxt_en: Don't issue AP reset during ethtool's reset operation

Sungwoo Kim (1):
      Bluetooth: L2CAP: Add missing checks for invalid DCID

Tijs Van Buggenhout (1):
      netfilter: conntrack: fix NULL pointer dereference in nf_confirm_cthelper

Vikas Gupta (1):
      bnxt_en: Skip firmware fatal error recovery if chip is not accessible

Vladislav Efanov (1):
      batman-adv: Broken sync while rescheduling delayed work

Wei Fang (2):
      net: enetc: correct the statistics of rx bytes
      net: enetc: correct rx_bytes statistics of XDP

Weihao Gao (1):
      Fix gitignore for recently added usptream self tests

Wen Gu (1):
      net/smc: Avoid to access invalid RMBs' MRs in SMCRv1 ADD LINK CONT

Ying Hsu (1):
      Bluetooth: Fix l2cap_disconnect_req deadlock

Yonghong Song (1):
      selftests/bpf: Fix sockopt_sk selftest

Zhengping Jiang (1):
      Bluetooth: hci_sync: add lock to protect HCI_UNREGISTER

 Documentation/netlink/specs/ethtool.yaml           | 32 +++++------
 Documentation/networking/ip-sysctl.rst             |  4 +-
 drivers/bluetooth/hci_qca.c                        |  6 +-
 drivers/net/dsa/lan9303-core.c                     |  4 --
 drivers/net/dsa/qca/Kconfig                        |  1 +
 drivers/net/ethernet/amd/pds_core/dev.c            | 10 +++-
 drivers/net/ethernet/broadcom/bcmsysport.c         |  4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 42 ++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |  1 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 22 +++-----
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |  3 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |  5 ++
 drivers/net/ethernet/freescale/enetc/enetc.c       | 16 +++++-
 drivers/net/ethernet/intel/ice/ice_common.c        |  2 +-
 drivers/net/ethernet/intel/ice/ice_common.h        |  2 +-
 drivers/net/ethernet/intel/ice/ice_gnss.c          | 64 ++--------------------
 drivers/net/ethernet/intel/ice/ice_gnss.h          | 10 ----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.c           |  2 +-
 drivers/net/ethernet/qlogic/qede/qede.h            |  4 ++
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c    | 24 +++++++-
 drivers/net/ethernet/qlogic/qede/qede_main.c       | 34 +++++++++++-
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |  3 +-
 drivers/net/phy/phylink.c                          | 15 +++--
 drivers/net/virtio_net.c                           | 16 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  8 +--
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  3 +
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    | 19 ++++---
 drivers/net/wireless/realtek/rtw88/mac80211.c      | 14 ++---
 drivers/net/wireless/realtek/rtw88/main.c          |  4 +-
 drivers/net/wireless/realtek/rtw88/ps.c            | 43 +++++++++++++++
 drivers/net/wireless/realtek/rtw88/ps.h            |  2 +
 drivers/net/wireless/realtek/rtw89/core.c          |  3 -
 drivers/net/wireless/realtek/rtw89/mac80211.c      | 15 ++---
 drivers/net/wireless/realtek/rtw89/ps.c            | 26 +++++++++
 drivers/net/wireless/realtek/rtw89/ps.h            |  1 +
 include/linux/netdevice.h                          |  9 ++-
 include/net/bluetooth/hci.h                        |  1 +
 include/net/bluetooth/hci_core.h                   |  4 +-
 include/net/neighbour.h                            |  2 +-
 include/net/netns/ipv6.h                           |  2 +-
 include/net/ping.h                                 |  6 +-
 include/net/pkt_sched.h                            |  2 +
 include/net/rpl.h                                  |  3 -
 include/net/sch_generic.h                          |  6 +-
 include/net/sock.h                                 | 18 ++++--
 include/uapi/linux/bpf.h                           |  1 +
 kernel/bpf/map_in_map.c                            |  8 ++-
 kernel/bpf/syscall.c                               |  9 +++
 kernel/fork.c                                      |  2 +-
 kernel/trace/bpf_trace.c                           | 12 +++-
 lib/cpu_rmap.c                                     |  2 +-
 net/batman-adv/distributed-arp-table.c             |  2 +-
 net/bluetooth/hci_conn.c                           | 22 +++++---
 net/bluetooth/hci_core.c                           | 10 ++--
 net/bluetooth/hci_event.c                          | 44 +++++++++------
 net/bluetooth/hci_sync.c                           | 23 ++++++--
 net/bluetooth/l2cap_core.c                         | 13 +++++
 net/can/j1939/main.c                               | 24 ++++----
 net/can/j1939/socket.c                             |  5 ++
 net/core/dev.c                                     |  8 ++-
 net/core/skmsg.c                                   |  3 +-
 net/ipv4/sysctl_net_ipv4.c                         |  8 +--
 net/ipv4/tcp_offload.c                             | 19 +++----
 net/ipv6/exthdrs.c                                 | 29 ++++------
 net/ipv6/route.c                                   |  4 +-
 net/mac80211/he.c                                  | 15 +++--
 net/mac80211/mlme.c                                |  8 ++-
 net/mac80211/rx.c                                  |  4 +-
 net/mac80211/tx.c                                  |  2 +-
 net/mptcp/pm.c                                     | 23 ++++++--
 net/mptcp/pm_netlink.c                             | 18 ++++++
 net/mptcp/pm_userspace.c                           | 48 +++++++++++++++-
 net/mptcp/protocol.h                               |  1 +
 net/netfilter/ipset/ip_set_core.c                  |  8 +++
 net/netfilter/nf_conntrack_core.c                  |  3 +
 net/netfilter/nf_tables_api.c                      |  4 +-
 net/netfilter/nft_bitwise.c                        |  2 +-
 net/openvswitch/datapath.c                         | 19 -------
 net/openvswitch/vport.c                            | 18 +++++-
 net/sched/act_police.c                             | 10 ++--
 net/sched/cls_api.c                                |  3 +-
 net/sched/sch_api.c                                | 28 ++++++----
 net/sched/sch_fq_pie.c                             | 10 +++-
 net/sched/sch_generic.c                            | 30 +++++-----
 net/sched/sch_mq.c                                 |  8 +--
 net/sched/sch_mqprio.c                             |  8 +--
 net/sched/sch_pie.c                                |  5 +-
 net/sched/sch_red.c                                |  5 +-
 net/sched/sch_sfq.c                                |  5 +-
 net/sched/sch_taprio.c                             |  6 +-
 net/sched/sch_teql.c                               |  2 +-
 net/smc/smc_llc.c                                  |  4 +-
 net/wireless/core.c                                |  4 +-
 net/wireless/nl80211.c                             |  2 +
 net/wireless/reg.c                                 |  4 +-
 tools/include/uapi/linux/bpf.h                     |  1 +
 tools/lib/bpf/libbpf.c                             |  3 +-
 tools/lib/bpf/libbpf_probes.c                      |  2 +
 .../selftests/bpf/prog_tests/inner_array_lookup.c  | 31 +++++++++++
 .../testing/selftests/bpf/prog_tests/sockopt_sk.c  |  2 +-
 .../selftests/bpf/progs/inner_array_lookup.c       | 45 +++++++++++++++
 tools/testing/selftests/net/.gitignore             |  3 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    | 11 +++-
 105 files changed, 788 insertions(+), 386 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/inner_array_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/inner_array_lookup.c


