Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10127149C16
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 18:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgAZR1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 12:27:55 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:15112 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726612AbgAZR1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 12:27:54 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580059673; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=TMWHmJDCzC1QBzwA+SVJ9UExIFgdPzStho08ovXrJ0E=; b=WSer5eg0eD8VMU1m+f/zNTwPietJMd7E4pE9hT+WWGMw8L/ihBOVbL8a1CNOXIrcc81nmD/U
 FYpPjcCmE1v2c0Ku8TfDcKpGhElvUEESw8KN+0uXwcHkYsWfQmbgvr1RvMVUUjDlBKJ4WGOK
 gTEgpINBf5hzokNgPDkcglc8AWk=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2dcc18.7f52ca680ea0-smtp-out-n03;
 Sun, 26 Jan 2020 17:27:52 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 39009C433CB; Sun, 26 Jan 2020 17:27:51 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B0338C43383;
        Sun, 26 Jan 2020 17:27:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B0338C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2020-01-26
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20200126172751.39009C433CB@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 17:27:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit e07c5f2e4e911d933c8daa3c6f6be063ee0e5c2d:

  net: amd: a2065: Use print_hex_dump_debug() helper (2020-01-12 16:20:26 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2020-01-26

for you to fetch changes up to 2a13513f99e735184fd6f889d78da6424fda80a1:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2020-01-26 17:54:46 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for v5.6

Second set of patches for v5.6. Nothing special standing out, smaller
new features and fixes allover.

Major changes:

ar5523

* add support for SMCWUSBT-G2 USB device

iwlwifi

* support new versions of the FTM FW APIs

* support new version of the beacon template FW API

* print some extra information when the driver is loaded

rtw88

* support wowlan feature for 8822c

* add support for WIPHY_WOWLAN_NET_DETECT

brcmfmac

* add initial support for monitor mode

qtnfmac

* add module parameter to enable DFS offloading in firmware

* add support for STA HE rates

* add support for TWT responder and spatial reuse

----------------------------------------------------------------
Amadeusz Sławiński (9):
      rtlwifi: rtl8192cu: Fix typo
      rtlwifi: rtl8188ee: Make functions static & rm sw.h
      rtlwifi: rtl8192ce: Make functions static & rm sw.h
      rtlwifi: rtl8192cu: Remove sw.h header
      rtlwifi: rtl8192ee: Make functions static & rm sw.h
      rtlwifi: rtl8192se: Remove sw.h header
      rtlwifi: rtl8723ae: Make functions static & rm sw.h
      rtlwifi: rtl8723be: Make functions static & rm sw.h
      rtlwifi: rtl8821ae: Make functions static & rm sw.h

Andrei Otcheretianski (1):
      iwlwifi: mvm: Update BEACON_TEMPLATE_CMD firmware API

Anilkumar Kolli (1):
      ath11k: enable HE tlvs in ppdu stats for pktlog lite

Arnd Bergmann (1):
      ath11k: fix debugfs build failure

Avraham Stern (2):
      iwlwifi: mvm: add support for location range request version 8
      iwlwifi: mvm: add support for responder config command version 7

Bhagavathi Perumal S (2):
      ath11k: set TxBf parameters after vdev start
      ath11k: Add missing pdev rx rate stats

Bjorn Andersson (1):
      ath10k: Add optional qdss clk

Brian Norris (1):
      mwifiex: drop most magic numbers from mwifiex_process_tdls_action_frame()

Bryan O'Donoghue (2):
      ath10k: pci: Only dump ATH10K_MEM_REGION_TYPE_IOREG when safe
      ath10k: pci: Fix comment on ath10k_pci_dump_memory_sram

Chin-Yen Lee (7):
      rtw88: pci: reset ring index when release skbs in tx ring
      rtw88: pci: reset dma when reset pci trx ring
      rtw88: load wowlan firmware if wowlan is supported
      rtw88: support wowlan feature for 8822c
      rtw88: Add wowlan pattern match support
      rtw88: Add wowlan net-detect support
      rtw88: use rtw_hci_stop() instead of rtwdev->hci.ops->stop()

Colin Ian King (7):
      ath11k: ensure ts.flags is initialized before bit-wise or'ing in values
      ath11k: avoid null pointer dereference when pointer band is null
      ar5523: fix spelling mistake "to" -> "too"
      wcn36xx: fix spelling mistake "to" -> "too"
      rtlwifi: rtl8188ee: remove redundant assignment to variable cond
      rtlwifi: btcoex: fix spelling mistake "initilized" -> "initialized"
      iwlegacy: ensure loop counter addr does not wrap and cause an infinite loop

Dan Carpenter (1):
      ath11k: fix up some error paths

Ganapathi Bhat (1):
      MAINTAINERS: update for mwifiex driver maintainers

Govind Singh (2):
      dt: bindings: add dt entry flag to skip SCM call for msa region
      ath10k: Don't call SCM interface for statically mapped msa region

Jean-Philippe Brucker (1):
      brcmfmac: sdio: Fix OOB interrupt initialization on brcm43362

Johannes Berg (8):
      iwlwifi: mvm: update powersave correctly for D3
      iwlwifi: allocate more receive buffers for HE devices
      iwlwifi: pcie: map only used part of RX buffers
      iwlwifi: pcie: use partial pages if applicable
      iwlwifi: pcie: validate queue ID before array deref/bit ops
      iwlwifi: incorporate firmware filename into version
      iwlwifi: mvm: print out extended secboot status before dump
      iwlwifi: prph: remove some unused register definitions

John Crispin (1):
      ath11k: make sure to also report the RX bandwidth inside radiotap

Kalle Valo (2):
      Merge tag 'iwlwifi-next-for-kalle-2020-01-11' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Luca Coelho (10):
      iwlwifi: dbg_ini: don't skip a TX FIFO when dumping
      iwlwifi: remove some outdated iwl22000 configurations
      iwlwifi: remove CSR registers abstraction
      iwlwifi: yoyo: don't allow changing the domain via debugfs
      iwlwifi: yoyo: remove unnecessary active triggers status flag
      iwlwifi: yoyo: remove the iwl_dbg_tlv_gen_active_trigs() function
      iwlwifi: yoyo: check for the domain on all TLV types during init
      iwlwifi: assume the driver_data is a trans_cfg, but allow full cfg
      iwlwifi: implement a new device configuration table
      iwlwifi: add device name to device_info

Maital Hahn (1):
      wlcore: mesh: Add support for RX Broadcast Key

Mert Dirik (1):
      ar5523: Add USB ID of SMCWUSBT-G2 wireless adapter

Mikhail Karpenko (1):
      qtnfmac: add support for TWT responder and spatial reuse

Nathan Chancellor (1):
      hostap: Adjust indentation in prism2_hostapd_add_sta

Oren Givon (1):
      iwlwifi: add new iwlax411 struct for type SoSnj

Ping-Ke Shih (2):
      rtw88: fix rate mask for 1SS chip
      rtw88: fix TX secondary channel offset of 40M if current bw is 20M or 40M

Rafał Miłecki (2):
      brcmfmac: simplify building interface combinations
      brcmfmac: add initial support for monitor mode

Rakesh Pillai (1):
      ath10k: Correct the DMA direction for management tx buffers

Sergey Matyukevich (4):
      qtnfmac: cleanup slave_radar access function
      qtnfmac: add module param to configure DFS offload
      qtnfmac: control qtnfmac wireless interfaces bridging
      qtnfmac: add support for STA HE rates

Stephen Boyd (2):
      ath10k: Add newlines to printk messages
      ath10k: Use device_get_match_data() to simplify code

Tova Mussai (1):
      iwlwifi: scan: remove support for fw scan api v11

Tzu-En Huang (2):
      rtw88: 8822c: update power sequence to v15
      rtw88: remove unused spinlock

Wen Gong (1):
      ath10k: drop RX skb with invalid length for sdio

Yan-Hsuan Chuang (6):
      rtw88: add interface config for 8822c
      rtw88: remove unused variable 'in_lps'
      rtw88: remove unused vif pointer in struct rtw_vif
      rtw88: assign NULL to skb after being kfree()'ed
      rtw88: fix potential NULL skb access in TX ISR
      rtw88: use shorter delay time to poll PS state

YueHaibing (3):
      rtlwifi: rtl8821ae: remove unused variables
      rtlwifi: rtl8192ee: remove unused variables
      rtlwifi: rtl8723ae: remove unused variables

Zhi Chen (1):
      Revert "ath10k: fix DMA related firmware crashes on multiple devices"

Zong-Zhe Yang (1):
      rtw88: change max_num_of_tx_queue() definition to inline in pci.h

yuehaibing (1):
      brcmfmac: Remove always false 'idx < 0' statement

zhengbin (6):
      ath9k: use true,false for bool variable
      wil6210: use true,false for bool variable
      ath10k: use true,false for bool variable
      rtw88: use true,false for bool variable
      cw1200: use true,false for bool variable
      brcmfmac: use true,false for bool variable

 .../bindings/net/wireless/qcom,ath10k.txt          |   6 +-
 MAINTAINERS                                        |   1 -
 drivers/net/wireless/ath/ar5523/ar5523.c           |   4 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   2 +-
 drivers/net/wireless/ath/ath10k/hw.h               |   2 +-
 drivers/net/wireless/ath/ath10k/pci.c              |  21 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |   9 +
 drivers/net/wireless/ath/ath10k/qmi.h              |   1 +
 drivers/net/wireless/ath/ath10k/sdio.c             |  24 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |  19 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   2 +-
 drivers/net/wireless/ath/ath11k/Kconfig            |   2 +-
 drivers/net/wireless/ath/ath11k/Makefile           |   3 +-
 drivers/net/wireless/ath/ath11k/debug.c            |  15 +
 drivers/net/wireless/ath/ath11k/debug.h            |  22 +-
 drivers/net/wireless/ath/ath11k/debug_htt_stats.c  | 205 ++++-
 drivers/net/wireless/ath/ath11k/debug_htt_stats.h  |  42 +
 drivers/net/wireless/ath/ath11k/dp.h               |   8 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   3 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |  24 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  21 +-
 drivers/net/wireless/ath/ath9k/ar9003_aic.c        |   2 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |   2 +-
 drivers/net/wireless/ath/wil6210/main.c            |   2 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |   2 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |   8 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 153 +++-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  68 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.h    |   2 +
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  12 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/1000.c      |   6 +-
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c      |  12 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  81 +-
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c      |   7 +-
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c      |  19 +-
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c      |   3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c      |   3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |  12 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |   4 +-
 .../net/wireless/intel/iwlwifi/fw/api/location.h   | 144 +++-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |  41 -
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |   7 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   9 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |  29 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |  13 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  68 +-
 .../net/wireless/intel/iwlwifi/iwl-context-info.h  |  20 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |  27 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |  65 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h   |   1 -
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  26 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |  37 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  14 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |  10 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  22 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   6 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 239 ++++--
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |  95 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  27 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |  27 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  47 --
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |   2 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |  11 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 161 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  21 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       | 108 ++-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   5 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  51 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  16 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  12 +-
 drivers/net/wireless/intersil/hostap/hostap_ap.c   |   2 +-
 drivers/net/wireless/marvell/mwifiex/tdls.c        |  75 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |   9 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |  13 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |   2 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c      |  71 +-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |   3 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |  52 +-
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    |   2 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |   2 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.c   |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/sw.c    |   7 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/sw.h    |  12 -
 .../net/wireless/realtek/rtlwifi/rtl8192ce/sw.c    |   5 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/sw.h    |  15 -
 .../net/wireless/realtek/rtlwifi/rtl8192cu/sw.c    |  35 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/sw.h    |  27 -
 .../net/wireless/realtek/rtlwifi/rtl8192ee/dm.c    | 118 ---
 .../net/wireless/realtek/rtlwifi/rtl8192ee/sw.c    |   7 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/sw.h    |  11 -
 .../net/wireless/realtek/rtlwifi/rtl8192se/sw.c    |   1 -
 .../net/wireless/realtek/rtlwifi/rtl8192se/sw.h    |  13 -
 .../net/wireless/realtek/rtlwifi/rtl8723ae/dm.c    | 112 ---
 .../net/wireless/realtek/rtlwifi/rtl8723ae/sw.c    |   7 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/sw.h    |  13 -
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.c    |   7 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.h    |  13 -
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    | 118 ---
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    |   7 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.h    |  12 -
 drivers/net/wireless/realtek/rtw88/Makefile        |   1 +
 drivers/net/wireless/realtek/rtw88/debug.h         |   1 +
 drivers/net/wireless/realtek/rtw88/fw.c            | 389 ++++++++-
 drivers/net/wireless/realtek/rtw88/fw.h            | 186 +++++
 drivers/net/wireless/realtek/rtw88/hci.h           |   6 +
 drivers/net/wireless/realtek/rtw88/mac.c           |  12 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |  46 +-
 drivers/net/wireless/realtek/rtw88/main.c          |  91 ++-
 drivers/net/wireless/realtek/rtw88/main.h          |  72 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |  60 +-
 drivers/net/wireless/realtek/rtw88/pci.h           |   2 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |   2 +-
 drivers/net/wireless/realtek/rtw88/ps.c            |   4 +-
 drivers/net/wireless/realtek/rtw88/reg.h           |  29 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  24 +-
 drivers/net/wireless/realtek/rtw88/util.h          |   2 +
 drivers/net/wireless/realtek/rtw88/wow.c           | 890 +++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/wow.h           |  58 ++
 drivers/net/wireless/st/cw1200/txrx.c              |   2 +-
 drivers/net/wireless/ti/wlcore/cmd.c               |   6 +-
 drivers/net/wireless/ti/wlcore/cmd.h               |   2 +-
 drivers/net/wireless/ti/wlcore/main.c              |  23 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h          |   1 +
 136 files changed, 3495 insertions(+), 1410 deletions(-)
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.h
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.h
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.h
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.h
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.h
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.h
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.h
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/wow.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/wow.h
