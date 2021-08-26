Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815C93F8E7A
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243400AbhHZTLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:11:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230442AbhHZTLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 15:11:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40CCF60F5B;
        Thu, 26 Aug 2021 19:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630005018;
        bh=0Bc2Rcdi/WAl1Rb7oHpt4pArjU0OWD8Bo1hi0ebkhJ8=;
        h=From:To:Cc:Subject:Date:From;
        b=nUrzmjhdkWIW6v7f8D31rENSpXJ3xMb88qr4muvZnOdedHEogNrOKSUSAPQ+pIUTx
         mZgnV5MnNqEtK8waQLqjz7ZXmbpphBlrnuTENNI2RkObBPEgFiEsEPZwhXMMCO2WQH
         i7Gdpt2PViCi7przXovTriv9PSLXbNT2jP5eJojKHgb4ikWCgTSZpxsUttXqXJsVA5
         YGvzG6L4b5PGXGsiyS0HP8hkWG6cLR4u6p89o9myDogwiNnlLrSty2aJW118XSzPv7
         YcgIdbUfhkGaZgvBB69d2sV5U2r5UwpTxl3OGqDlf8kYlGup0NA9uFxbMSHHJWmKtM
         +0/dbVbTA8X1g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-can@vger.kernel.org, kvalo@codeaurora.org
Subject: [GIT PULL] Networking for 5.14-rc8
Date:   Thu, 26 Aug 2021 12:10:17 -0700
Message-Id: <20210826191017.1345100-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Closing 3 hw-dependent regressions. Any fixes of note are
in the "old code" category. Nothing blocking release from
our perspective, don't read too much into the tag name.

The following changes since commit f87d64319e6f980c82acfc9b95ed523d053fb7ac:

  Merge tag 'net-5.14-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-08-19 12:33:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc8

for you to fetch changes up to 9ebc2758d0bbed951511d1709be0717178ec2660:

  Revert "net: really fix the build..." (2021-08-26 11:08:32 -0700)

----------------------------------------------------------------
Networking fixes for 5.14(-rc8?), including fixes from can and bpf.

Current release - regressions:

 - stmmac: revert "stmmac: align RX buffers"

 - usb: asix: ax88772: move embedded PHY detection as early as possible

 - usb: asix: do not call phy_disconnect() for ax88178

 - Revert "net: really fix the build...", from Kalle to fix QCA6390

Current release - new code bugs:

 - phy: mediatek: add the missing suspend/resume callbacks

Previous releases - regressions:

 - qrtr: fix another OOB Read in qrtr_endpoint_post

 - stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings

Previous releases - always broken:

 - inet: use siphash in exception handling

 - ip_gre: add validation for csum_start

 - bpf: fix ringbuf helper function compatibility

 - rtnetlink: return correct error on changing device netns

 - e1000e: do not try to recover the NVM checksum on Tiger Lake

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aaron Ma (1):
      igc: fix page fault when thunderbolt is unplugged

Andrey Ignatov (1):
      rtnetlink: Return correct error on changing device netns

Christophe JAILLET (1):
      xgene-v2: Fix a resource leak in the error handling path of 'xge_probe()'

DENG Qingfang (1):
      net: phy: mediatek: add the missing suspend/resume callbacks

Daniel Borkmann (1):
      bpf: Fix ringbuf helper function compatibility

David S. Miller (5):
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'asix-fixes'
      Merge tag 'linux-can-fixes-for-5.14-20210826' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'inet-siphash'
      Merge branch 'dsa-hellcreek-fixes'

Davide Caratti (1):
      net/sched: ets: fix crash when flipping from 'strict' to 'quantum'

Eric Dumazet (2):
      ipv6: use siphash in rt6_exception_hash()
      ipv4: use siphash instead of Jenkins in fnhe_hashfun()

Guangbin Huang (1):
      net: hns3: fix get wrong pfc_en when query PFC configuration

Guojia Liao (1):
      net: hns3: fix duplicate node in VLAN list

Harini Katakam (1):
      net: macb: Add a NULL check on desc_ptp

Jacob Keller (1):
      ice: do not abort devlink info if board identifier can't be found

Jakub Kicinski (2):
      Merge branch 'net-hns3-add-some-fixes-for-net'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf

Kalle Valo (1):
      Revert "net: really fix the build..."

Kurt Kanzenbach (2):
      net: dsa: hellcreek: Fix incorrect setting of GCL
      net: dsa: hellcreek: Adjust schedule look ahead window

Marc Zyngier (1):
      stmmac: Revert "stmmac: align RX buffers"

Maxim Kiselev (1):
      net: marvell: fix MVNETA_TX_IN_PRGRS bit number

Michael Riesch (1):
      net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings

Nathan Rossi (1):
      net: dsa: mv88e6xxx: Update mv88e6393x serdes errata

Oleksij Rempel (2):
      net: usb: asix: ax88772: move embedded PHY detection as early as possible
      net: usb: asix: do not call phy_disconnect() for ax88178

Petko Manolov (1):
      net: usb: pegasus: fixes of set_register(s) return value evaluation;

Rahul Lakkireddy (1):
      cxgb4: dont touch blocked freelist bitmap after free

Sasha Neftin (2):
      e1000e: Fix the max snoop/no-snoop latency for 10M
      e1000e: Do not take care about recovery NVM checksum

Shai Malin (2):
      qed: Fix the VF msix vectors flow
      qede: Fix memset corruption

Shreyansh Chouhan (2):
      ip_gre: add validation for csum_start
      ip6_gre: add validation for csum_start

Song Yoong Siang (2):
      net: stmmac: fix kernel panic due to NULL pointer dereference of xsk_pool
      net: stmmac: fix kernel panic due to NULL pointer dereference of buf->xdp

Stefan Mätje (1):
      can: usb: esd_usb2: esd_usb2_rx_event(): fix the interchange of the CAN RX and TX error counters

Toshiki Nishioka (1):
      igc: Use num_tx_queues when iterating over tx_ring queue

Wong Vee Khee (1):
      net: stmmac: fix kernel panic due to NULL pointer dereference of plat->est

Xiaolong Huang (1):
      net: qrtr: fix another OOB Read in qrtr_endpoint_post

Yonglong Liu (1):
      net: hns3: fix speed unknown issue in bond 4

Yufeng Mo (4):
      net: hns3: clear hardware resource when loading driver
      net: hns3: add waiting time before cmdq memory is released
      net: hns3: change the method of getting cmd index in debugfs
      net: hns3: fix GRO configuration error after reset

kernel test robot (1):
      net: usb: asix: ax88772: fix boolconv.cocci warnings

zhang kai (1):
      ipv6: correct comments about fib6_node sernum

王贇 (1):
      net: fix NULL pointer reference in cipso_v4_doi_free

 drivers/bus/mhi/core/internal.h                    |  2 +-
 drivers/bus/mhi/core/main.c                        |  9 ++--
 drivers/net/can/usb/esd_usb2.c                     |  4 +-
 drivers/net/dsa/hirschmann/hellcreek.c             |  8 ++--
 drivers/net/dsa/mv88e6xxx/serdes.c                 | 11 ++---
 drivers/net/ethernet/apm/xgene-v2/main.c           |  4 +-
 drivers/net/ethernet/cadence/macb_ptp.c            | 11 ++++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  7 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 14 +++---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |  1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  6 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  4 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 13 +-----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 52 +++++++++++++++++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  7 ++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |  1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 21 ++++++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |  2 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        | 32 +++++++++----
 drivers/net/ethernet/intel/e1000e/ich8lan.h        |  3 ++
 drivers/net/ethernet/intel/ice/ice_devlink.c       |  4 +-
 drivers/net/ethernet/intel/igc/igc_main.c          | 36 ++++++++-------
 drivers/net/ethernet/intel/igc/igc_ptp.c           |  3 +-
 drivers/net/ethernet/marvell/mvneta.c              |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c         |  7 ++-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |  9 ----
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  8 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    | 12 ++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c   | 12 ++---
 drivers/net/mhi/net.c                              |  2 +-
 drivers/net/phy/mediatek-ge.c                      |  4 ++
 drivers/net/usb/asix.h                             |  1 +
 drivers/net/usb/asix_devices.c                     | 49 +++++++++++---------
 drivers/net/usb/pegasus.c                          |  4 +-
 drivers/net/wwan/mhi_wwan_ctrl.c                   |  2 +-
 include/linux/mhi.h                                |  7 +--
 include/net/ip6_fib.h                              |  4 +-
 kernel/bpf/verifier.c                              |  8 +++-
 net/core/rtnetlink.c                               |  3 +-
 net/ipv4/cipso_ipv4.c                              | 18 ++++----
 net/ipv4/ip_gre.c                                  |  2 +
 net/ipv4/route.c                                   | 12 ++---
 net/ipv6/ip6_fib.c                                 |  2 +-
 net/ipv6/ip6_gre.c                                 |  2 +
 net/ipv6/route.c                                   | 20 ++++++---
 net/qrtr/mhi.c                                     | 16 +------
 net/qrtr/qrtr.c                                    |  2 +-
 net/sched/sch_ets.c                                |  7 +++
 52 files changed, 293 insertions(+), 186 deletions(-)
