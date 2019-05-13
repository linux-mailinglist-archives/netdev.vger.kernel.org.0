Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7EA1BB8A
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 19:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbfEMRIK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 May 2019 13:08:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40356 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730269AbfEMRIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 13:08:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2BB5414E2860E;
        Mon, 13 May 2019 10:08:09 -0700 (PDT)
Date:   Mon, 13 May 2019 10:08:08 -0700 (PDT)
Message-Id: <20190513.100808.446548500573250493.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 May 2019 10:08:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes all over:

1) Netdev refcnt leak in nf_flow_table, from Taehee Yoo.

2) Fix RCU usage in nf_tables, from Florian Westphal.

3) Fix DSA build when NET_DSA_TAG_BRCM_PREPEND is not set, from
   Yue Haibing.

4) Add missing page read/write ops to realtek driver, from Heiner
   Kallweit.

5) Endianness fix in qrtr code, from Nicholas Mc Guire.

6) Fix various bugs in DSA_SKB_* macros, from Vladimir Oltean.

7) Several BPF documentation cures, from Quentin Monnet.

8) Fix undefined behavior in narrow load handling of BPF verifier,
   from Krzesimir Nowak.

9) DMA ops crash in SGI Seeq driver due to not set netdev parent
   device pointer, from Thomas Bogendoerfer.

10) Flow dissector has to disable preemption when invoking BPF
    program, from Eric Dumazet.

Please pull, thank you.

The following changes since commit b970afcfcabd63cd3832e95db096439c177c3592:

  Merge tag 'powerpc-5.2-1' of ssh://gitolite.kernel.org/pub/scm/linux/kernel/git/powerpc/linux (2019-05-10 05:29:27 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 

for you to fetch changes up to d4c26eb6e721683a0f93e346ce55bc8dc3cbb175:

  net: ethernet: stmmac: dwmac-sun8i: enable support of unicast filtering (2019-05-13 09:59:41 -0700)

----------------------------------------------------------------
Andrii Nakryiko (1):
      libbpf: detect supported kernel BTF features and sanitize BTF

Corentin Labbe (1):
      net: ethernet: stmmac: dwmac-sun8i: enable support of unicast filtering

Daniel Borkmann (3):
      bpf: fix out of bounds backwards jmps due to dead code removal
      bpf: add various test cases for backward jumps
      Merge branch 'bpf-uapi-doc-fixes'

David S. Miller (4):
      Merge branch 'of_get_mac_address-fixes'
      Merge branch 'dsa-Fix-a-bug-and-avoid-dangerous-usage-patterns'
      Merge git://git.kernel.org/.../bpf/bpf
      Merge git://git.kernel.org/.../pablo/nf

Eric Dumazet (1):
      flow_dissector: disable preemption around BPF calls

Florian Westphal (4):
      netfilter: nf_tables: delay chain policy update until transaction is complete
      netfilter: nf_tables: fix base chain stat rcu_dereference usage
      netfilter: ebtables: CONFIG_COMPAT: reject trailing data after last rule
      netfilter: nf_tables: correct NFT_LOGLEVEL_MAX value

Grygorii Strashko (1):
      net: ethernet: ti: netcp_ethss: fix build

Hariprasad Kelam (1):
      net: dccp : proto: remove Unneeded variable "err"

Heiner Kallweit (2):
      net: phy: realtek: add missing page operations
      net: phy: realtek: fix double page ops in generic Realtek driver

Jakub Jankowski (1):
      netfilter: nf_conntrack_h323: restore boundary check correctness

Jarod Wilson (1):
      bonding: fix arp_validate toggling in active-backup mode

Jerome Brunet (1):
      net: meson: fixup g12a glue ephy id

Kelsey Skunberg (1):
      selftests: bpf: Add files generated after build to .gitignore

Kristian Evensen (1):
      netfilter: ctnetlink: Resolve conntrack L3-protocol flush regression

Krzesimir Nowak (1):
      bpf: fix undefined behavior in narrow load handling

Kunihiko Hayashi (1):
      net: phy: realtek: Replace phy functions with non-locked version in rtl8211e_config_init()

Maxime Chevallier (1):
      net: mvpp2: cls: Add missing NETIF_F_NTUPLE flag

Nicholas Mc Guire (1):
      net: qrtr: use protocol endiannes variable

Pablo Neira Ayuso (2):
      netfilter: nft_flow_offload: add entry to flowtable after confirmation
      netfilter: nf_tables: remove NFT_CT_TIMEOUT

Paolo Abeni (1):
      Revert "selinux: do not report error on connect(AF_UNSPEC)"

Petr ¦tetiar (6):
      of_net: remove nvmem-mac-address property
      dt-bindings: doc: net: remove Linux API references
      powerpc: tsi108: fix similar warning reported by kbuild test robot
      net: ethernet: fix similar warning reported by kbuild test robot
      net: wireless: mt76: fix similar warning reported by kbuild test robot
      of_net: Fix missing of_find_device_by_node ref count drop

Quentin Monnet (4):
      bpf: fix script for generating man page on BPF helpers
      bpf: fix recurring typo in documentation for BPF helpers
      bpf: fix minor issues in documentation for BPF helpers.
      tools: bpf: synchronise BPF UAPI header with tools

Subash Abhinov Kasiviswanathan (1):
      netfilter: nf_conntrack_h323: Remove deprecated config check

Taehee Yoo (4):
      netfilter: nf_flow_table: fix netdev refcnt leak
      netfilter: nf_flow_table: check ttl value in flow offload data path
      netfilter: nf_flow_table: fix missing error check for rhashtable_insert_fast
      netfilter: nf_flow_table: do not flow offload deleted conntrack entries

Thomas Bogendoerfer (1):
      net: seeq: fix crash caused by not set dev.parent

Thomas Falcon (2):
      net/ibmvnic: Update MAC address settings after adapter reset
      net/ibmvnic: Update carrier state after link state change

Tobin C. Harding (1):
      bridge: Fix error path for kobject_init_and_add()

Vladimir Oltean (3):
      net: dsa: Initialize DSA_SKB_CB(skb)->deferred_xmit variable
      net: dsa: Remove dangerous DSA_SKB_CLONE() macro
      net: dsa: Remove the now unused DSA_SKB_CB_COPY() macro

YueHaibing (1):
      dsa: tag_brcm: Fix build error without CONFIG_NET_DSA_TAG_BRCM_PREPEND

 Documentation/devicetree/bindings/net/keystone-netcp.txt         |   6 +--
 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt |   4 +-
 arch/powerpc/sysdev/tsi108_dev.c                                 |   3 +-
 drivers/net/bonding/bond_options.c                               |   7 ----
 drivers/net/ethernet/allwinner/sun4i-emac.c                      |   2 +-
 drivers/net/ethernet/arc/emac_main.c                             |   2 +-
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c                 |   2 +-
 drivers/net/ethernet/davicom/dm9000.c                            |   2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c                     |   2 +-
 drivers/net/ethernet/freescale/fman/mac.c                        |   2 +-
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c            |   2 +-
 drivers/net/ethernet/freescale/gianfar.c                         |   2 +-
 drivers/net/ethernet/freescale/ucc_geth.c                        |   2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                               |  62 ++++++++++++++-------------
 drivers/net/ethernet/ibm/ibmvnic.h                               |   2 -
 drivers/net/ethernet/marvell/mv643xx_eth.c                       |   2 +-
 drivers/net/ethernet/marvell/mvneta.c                            |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                  |   4 +-
 drivers/net/ethernet/marvell/sky2.c                              |   2 +-
 drivers/net/ethernet/micrel/ks8851.c                             |   2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c                         |   2 +-
 drivers/net/ethernet/nxp/lpc_eth.c                               |   2 +-
 drivers/net/ethernet/renesas/sh_eth.c                            |   2 +-
 drivers/net/ethernet/seeq/sgiseeq.c                              |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c                |   2 +
 drivers/net/ethernet/ti/Makefile                                 |   2 +-
 drivers/net/ethernet/ti/cpsw.c                                   |   2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c                      |   2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c                    |   2 +-
 drivers/net/phy/mdio-mux-meson-g12a.c                            |   2 +-
 drivers/net/phy/realtek.c                                        |  16 +++++--
 drivers/net/wireless/mediatek/mt76/eeprom.c                      |   2 +-
 drivers/of/of_net.c                                              |  34 +++++----------
 include/net/dsa.h                                                |  15 -------
 include/uapi/linux/bpf.h                                         | 145 ++++++++++++++++++++++++++++++++-------------------------------
 include/uapi/linux/netfilter/nf_tables.h                         |   4 +-
 kernel/bpf/core.c                                                |   4 +-
 kernel/bpf/verifier.c                                            |   2 +-
 net/bridge/br_if.c                                               |  13 +++---
 net/bridge/netfilter/ebtables.c                                  |   4 +-
 net/core/flow_dissector.c                                        |   2 +
 net/dccp/proto.c                                                 |   3 +-
 net/dsa/slave.c                                                  |   2 +
 net/dsa/tag_brcm.c                                               |   2 +-
 net/netfilter/nf_conntrack_h323_asn1.c                           |   2 +-
 net/netfilter/nf_conntrack_h323_main.c                           |  11 ++---
 net/netfilter/nf_conntrack_netlink.c                             |   2 +-
 net/netfilter/nf_flow_table_core.c                               |  34 +++++++++++----
 net/netfilter/nf_flow_table_ip.c                                 |   6 +++
 net/netfilter/nf_tables_api.c                                    |  59 ++++++++++++++++++++------
 net/netfilter/nft_flow_offload.c                                 |   4 +-
 net/qrtr/qrtr.c                                                  |   7 ++--
 scripts/bpf_helpers_doc.py                                       |   8 ++--
 security/selinux/hooks.c                                         |   8 ++--
 tools/include/uapi/linux/bpf.h                                   | 145 ++++++++++++++++++++++++++++++++-------------------------------
 tools/lib/bpf/libbpf.c                                           | 130 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 tools/lib/bpf/libbpf_internal.h                                  |  27 ++++++++++++
 tools/lib/bpf/libbpf_probes.c                                    |  73 ++++++++++++++++++--------------
 tools/testing/selftests/bpf/.gitignore                           |   2 +
 tools/testing/selftests/bpf/verifier/jump.c                      | 195 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 60 files changed, 750 insertions(+), 344 deletions(-)
 create mode 100644 tools/lib/bpf/libbpf_internal.h
