Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA15C30C86A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237123AbhBBRtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:49:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:50092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234124AbhBBRqG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 12:46:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CF9464F6D;
        Tue,  2 Feb 2021 17:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612287925;
        bh=C2ydb8roGKdATXFQSLSkhYZe3wUyfvywdGjJMwOCeiY=;
        h=From:To:Cc:Subject:Date:From;
        b=ALI6arN9t3erqAlZC85HlaNE6Ox5yXyegeKyEsY6gCyRqGixLC1LbcuS1CGg01OkN
         vXAYGUEUdl/2OnJHWWSeVY6aZ2puChLQx+IwAkJQ4WTaqyznT8tTwV0M2jiyKNakkK
         b/h+ayZCg4FN2HbtheN9+PCAqP/OYbc2ug+Bt5BMhQQmotB6nJ9w+Setp/Yiz5wloT
         oiGXqOfsyaqIqX8NwpJ4NkQxqQRIaOk8ZwrvV9EHy3lYVMYbbBFlprq/0YyBAgLPZq
         bhhmnIfJWuRu7LUFVTvdhxKr9x2rpDroYGDU92HUs5v3Lv1wYvv18XeVhft2EF3kS3
         xf2FN7YpKzhEA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.11-rc7
Date:   Tue,  2 Feb 2021 09:45:24 -0800
Message-Id: <20210202174524.179983-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 909b447dcc45db2f9bd5f495f1d16c419812e6df:

  Merge tag 'net-5.11-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-01-28 15:24:43 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc7

for you to fetch changes up to 6c9f18f294c4a1a6d8b1097e39c325481664ee1c:

  net: hsr: align sup_multicast_addr in struct hsr_priv to u16 boundary (2021-02-02 08:57:18 -0800)

----------------------------------------------------------------
Networking fixes for 5.11-rc7, including fixes from bpf and mac80211
trees.

Current release - regressions:

 - ip_tunnel: fix mtu calculation

 - mlx5: fix function calculation for page trees

Previous releases - regressions:

 - vsock: fix the race conditions in multi-transport support

 - neighbour: prevent a dead entry from updating gc_list

 - dsa: mv88e6xxx: override existent unicast portvec in port_fdb_add

Previous releases - always broken:

 - bpf, cgroup: two copy_{from,to}_user() warn_on_once splats for BPF
                cgroup getsockopt infra when user space is trying
		to race against optlen, from Loris Reiff.

 - bpf: add missing fput() in BPF inode storage map update helper

 - udp: ipv4: manipulate network header of NATed UDP GRO fraglist

 - mac80211: fix station rate table updates on assoc

 - r8169: work around RTL8125 UDP HW bug

 - igc: report speed and duplex as unknown when device is runtime
        suspended

 - rxrpc: fix deadlock around release of dst cached on udp tunnel

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Ahmed S. Darwish (1):
      net: arcnet: Fix RESET flag handling

Aleksandr Loktionov (1):
      i40e: Revert "i40e: don't report link up for a VF who hasn't enabled queues"

Alex Elder (4):
      net: ipa: add a missing __iomem attribute
      net: ipa: be explicit about endianness
      net: ipa: use the right accessor in ipa_endpoint_status_skip()
      net: ipa: fix two format specifier errors

Alexander Ovechkin (1):
      net: sched: replaced invalid qdisc tree flush helper in qdisc_replace

Alexander Popov (1):
      vsock: fix the race conditions in multi-transport support

Andreas Oetken (1):
      net: hsr: align sup_multicast_addr in struct hsr_priv to u16 boundary

Chinmay Agarwal (1):
      neighbour: Prevent a dead entry from updating gc_list

DENG Qingfang (1):
      net: dsa: mv88e6xxx: override existent unicast portvec in port_fdb_add

Dan Carpenter (1):
      net: ipa: pass correct dma_handle to dma_free_coherent()

Daniel Jurgens (1):
      net/mlx5: Fix function calculation for page trees

David Howells (1):
      rxrpc: Fix deadlock around release of dst cached on udp tunnel

Dongseok Yi (1):
      udp: ipv4: manipulate network header of NATed UDP GRO fraglist

Felix Fietkau (1):
      mac80211: fix station rate table updates on assoc

Hans de Goede (1):
      staging: rtl8723bs: Move wiphy setup to after reading the regulatory settings from the chip

Heiner Kallweit (2):
      r8169: work around RTL8125 UDP hw bug
      r8169: fix WoL on shutdown if CONFIG_DEBUG_SHIRQ is set

Jakub Kicinski (5):
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'mac80211-for-net-2021-02-02' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211
      Merge branch 'net-ipa-a-few-bug-fixes'
      Merge tag 'mlx5-fixes-2021-02-01' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux

Kai-Heng Feng (1):
      igc: Report speed and duplex as unknown when device is runtime suspended

Kevin Lo (2):
      igc: set the default return value to -IGC_ERR_NVM in igc_write_nvm_srwr
      igc: check return value of ret_val in igc_config_fc_after_link_up

Lijun Pan (1):
      ibmvnic: device remove has higher precedence over reset

Loris Reiff (2):
      bpf, cgroup: Fix optlen WARN_ON_ONCE toctou
      bpf, cgroup: Fix problematic bounds check

Maor Dickman (1):
      net/mlx5e: Release skb in case of failure in tc update skb

Maor Gottlieb (1):
      net/mlx5: Fix leak upon failure of rule creation

Maxim Mikityanskiy (1):
      net/mlx5e: Update max_opened_tc also when channels are closed

Mikko Ylinen (1):
      bpf: Drop disabled LSM hooks from the sleepable set

Pan Bian (1):
      bpf, inode_storage: Put file handler if no storage was found

Quentin Monnet (1):
      bpf, preload: Fix build when $(O) points to a relative path

Sabyrzhan Tasbolatov (1):
      net/rds: restrict iovecs length for RDS_CMSG_RDMA_ARGS

Stefan Chulski (1):
      net: mvpp2: TCAM entry enable should be written after SRAM data

Vadim Fedorenko (1):
      net: ip_tunnel: fix mtu calculation

Vincent Bernat (1):
      docs: networking: swap words in icmp_errors_use_inbound_ifaddr doc

Xie He (1):
      net: lapb: Copy the skb before sending a packet

 Documentation/networking/ip-sysctl.rst             |  2 +-
 drivers/net/arcnet/arc-rimi.c                      |  4 +-
 drivers/net/arcnet/arcdevice.h                     |  6 ++
 drivers/net/arcnet/arcnet.c                        | 66 +++++++++++++++++--
 drivers/net/arcnet/com20020-isa.c                  |  4 +-
 drivers/net/arcnet/com20020-pci.c                  |  2 +-
 drivers/net/arcnet/com20020_cs.c                   |  2 +-
 drivers/net/arcnet/com90io.c                       |  4 +-
 drivers/net/arcnet/com90xx.c                       |  4 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  6 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  5 --
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 13 +---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |  1 -
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |  3 +-
 drivers/net/ethernet/intel/igc/igc_i225.c          |  3 +-
 drivers/net/ethernet/intel/igc/igc_mac.c           |  2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     | 10 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 16 +++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  5 ++
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c          | 75 +++++++++++++++++++---
 drivers/net/ipa/gsi.c                              |  4 +-
 drivers/net/ipa/ipa_endpoint.c                     |  6 +-
 drivers/net/ipa/ipa_mem.c                          |  4 +-
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c       |  4 +-
 fs/afs/main.c                                      |  6 +-
 include/net/sch_generic.h                          |  2 +-
 include/net/udp.h                                  |  2 +-
 kernel/bpf/bpf_inode_storage.c                     |  6 +-
 kernel/bpf/bpf_lsm.c                               | 12 ++++
 kernel/bpf/cgroup.c                                |  7 +-
 kernel/bpf/preload/Makefile                        |  5 +-
 net/core/neighbour.c                               |  7 +-
 net/hsr/hsr_main.h                                 |  5 +-
 net/ipv4/ip_tunnel.c                               | 16 ++---
 net/ipv4/udp_offload.c                             | 69 ++++++++++++++++++--
 net/ipv6/udp_offload.c                             |  2 +-
 net/lapb/lapb_out.c                                |  3 +-
 net/mac80211/driver-ops.c                          |  5 +-
 net/mac80211/rate.c                                |  3 +-
 net/rds/rdma.c                                     |  3 +
 net/rxrpc/af_rxrpc.c                               |  6 +-
 net/vmw_vsock/af_vsock.c                           | 17 +++--
 44 files changed, 328 insertions(+), 107 deletions(-)
