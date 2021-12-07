Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609F246BE01
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238078AbhLGOpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238073AbhLGOpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 09:45:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774F0C061574;
        Tue,  7 Dec 2021 06:42:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 66474CE1AC9;
        Tue,  7 Dec 2021 14:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9949C341C1;
        Tue,  7 Dec 2021 14:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638888132;
        bh=+IZYi5tF5eeVo8PJHFZk0ExTUkfFnfuCSbil5UxDY9o=;
        h=From:Subject:To:Cc:Date:From;
        b=VMG7o3+1jlTer3Teev3LtQfIgNRPlhNzUOHlsSFQyt77DyouezpUhbPuC7aQnuLDH
         vRNZ+3z2CLXcEorrDCe5ep7zD+bvKjZ2vxMWGX13Kj1HA8aztHQTH/MyxPxOuN0pMs
         QKPV1hEsnSZhr+O79WxiJiHQdUVpRb8uvb3joOkbx29vpg/CBOnlNekSkJZoxq3NAU
         Oc4LykJtGd1qRp2OhYngKHCxUZ0vDr8gVoRQSdcJ7wlumS+2oyMtm+oApvmvKWaKTi
         YVMuix4FLpuwGuO2f8KXn79fcIQ7prbzkoUJkblPBITj0TFmSrdC1BrxUGXLXodL6j
         qibTbvPKWTPaA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-drivers-next-2021-12-07
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20211207144211.A9949C341C1@smtp.kernel.org>
Date:   Tue,  7 Dec 2021 14:42:11 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 3b1abcf1289466eca4c46db8b55c06422f0abf34:

  Merge tag 'regmap-no-bus-update-bits' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap (2021-11-18 17:50:18 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2021-12-07

for you to fetch changes up to fe6db7eda9306d665f7b8fc3decdb556ec10fb85:

  iwlwifi: mei: fix linking when tracing is not enabled (2021-12-05 13:55:15 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for v5.17

First set of patches for v5.17. The biggest change is the iwlmei
driver for Intel's AMT devices. Also now WCN6855 support in ath11k
should be usable.

Major changes:

ath10k

* fetch (pre-)calibration data via nvmem subsystem

ath11k

* enable 802.11 power save mode in station mode for qca6390 and wcn6855

* trace log support

* proper board file detection for WCN6855 based on PCI ids

* BSS color change support

rtw88

* add debugfs file to force lowest basic rate

* add quirk to disable PCI ASPM on HP 250 G7 Notebook PC

mwifiex

* add quirk to disable deep sleep with certain hardware revision in
  Surface Book 2 devices

iwlwifi

* add iwlmei driver for co-operating with Intel's Active Management
  Technology (AMT) devices

----------------------------------------------------------------
Ajay Singh (1):
      wilc1000: remove '-Wunused-but-set-variable' warning in chip_wakeup()

Alexander Usyskin (1):
      mei: bus: add client dma interface

Anilkumar Kolli (1):
      ath11k: Add missing qmi_txn_cancel()

Baochen Qiang (1):
      ath11k: Fix crash caused by uninitialized TX ring

Benjamin Li (5):
      wcn36xx: add debug prints for sw_scan start/complete
      wcn36xx: implement flush op to speed up connected scan
      wcn36xx: ensure pairing of init_scan/finish_scan and start_scan/end_scan
      wcn36xx: populate band before determining rate on RX
      wcn36xx: fix RX BD rate mapping for 5GHz legacy rates

Bryan O'Donoghue (4):
      wcn36xx: Indicate beacon not connection loss on MISSED_BEACON_IND
      wcn36xx: Fix DMA channel enable/disable cycle
      wcn36xx: Release DMA channel descriptor allocations
      wcn36xx: Put DXE block into reset before freeing memory

Carl Huang (1):
      ath11k: enable 802.11 power save mode in station mode

Changcheng Deng (1):
      rtw89: remove unneeded variable

Chia-Yuan Li (1):
      rtw89: add AXIDMA and TX FIFO dump in mac_mem_dump

Christian Lamparter (1):
      ath10k: fetch (pre-)calibration data via nvmem subsystem

Emmanuel Grumbach (6):
      iwlwifi: mei: add the driver to allow cooperation with CSME
      iwlwifi: mei: add debugfs hooks
      iwlwifi: integrate with iwlmei
      iwlwifi: mvm: add vendor commands needed for iwlmei
      iwlwifi: mvm: read the rfkill state and feed it to iwlmei
      iwlwifi: mei: fix linking when tracing is not enabled

Jason Wang (1):
      wlcore: no need to initialise statics to false

John Crispin (1):
      ath11k: add support for BSS color change

Jonas Dreßler (4):
      mwifiex: Use a define for firmware version string length
      mwifiex: Add quirk to disable deep sleep with certain hardware revision
      mwifiex: Ensure the version string from the firmware is 0-terminated
      mwifiex: Ignore BTCOEX events from the 88W8897 firmware

Kalle Valo (2):
      ath11k: convert ath11k_wmi_pdev_set_ps_mode() to use enum wmi_sta_ps_mode
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Karthikeyan Kathirvel (2):
      ath11k: clear the keys properly via DISABLE_KEY
      ath11k: reset RSN/WPA present state for open BSS

Karthikeyan Periyasamy (4):
      ath11k: fix fw crash due to peer get authorized before key install
      ath11k: fix error routine when fallback of add interface fails
      ath11k: avoid unnecessary BH disable lock in STA kickout event
      ath11k: fix DMA memory free in CE pipe cleanup

Kees Cook (5):
      libertas: Use struct_group() for memcpy() region
      libertas_tf: Use struct_group() for memcpy() region
      intersil: Use struct_group() for memcpy() region
      mwl8k: Use named struct for memcpy() region
      rtlwifi: rtl8192de: Style clean-ups

Loic Poulain (1):
      brcmfmac: Configure keep-alive packet on suspend

P Praneesh (16):
      ath11k: disable unused CE8 interrupts for ipq8074
      ath11k: allocate dst ring descriptors from cacheable memory
      ath11k: modify dp_rx desc access wrapper calls inline
      ath11k: avoid additional access to ath11k_hal_srng_dst_num_free
      ath11k: avoid active pdev check for each msdu
      ath11k: remove usage quota while processing rx packets
      ath11k: add branch predictors in process_rx
      ath11k: allocate HAL_WBM2SW_RELEASE ring from cacheable memory
      ath11k: remove mod operator in dst ring processing
      ath11k: avoid while loop in ring selection of tx completion interrupt
      ath11k: add branch predictors in dp_tx path
      ath11k: avoid unnecessary lock contention in tx_completion path
      ath11k: fix FCS_ERR flag in radio tap header
      ath11k: send proper txpower and maxregpower values to firmware
      ath11k: Increment pending_mgmt_tx count before tx send invoke
      ath11k: Disabling credit flow for WMI path

Peter Seiderer (1):
      ath9k: fix intr_txqs setting

Ping-Ke Shih (2):
      rtw89: fix potentially access out of range of RF register array
      rtw88: add quirk to disable pci caps on HP 250 G7 Notebook PC

Rameshkumar Sundaram (3):
      ath11k: Send PPDU_STATS_CFG with proper pdev mask to firmware
      ath11k: Clear auth flag only for actual association in security mode
      ath11k: use cache line aligned buffers for dbring

Seevalamuthu Mariappan (2):
      ath11k: Fix 'unused-but-set-parameter' error
      ath11k: add hw_param for wakeup_mhi

Sven Eckelmann (1):
      ath11k: Fix ETSI regd with weather radar overlap

Venkateswara Naralasetty (2):
      ath11k: fix firmware crash during channel switch
      ath11k: add trace log support

Wen Gong (6):
      ath11k: set correct NL80211_FEATURE_DYNAMIC_SMPS for WCN6855
      ath11k: enable IEEE80211_VHT_EXT_NSS_BW_CAPABLE if NSS ratio enabled
      ath11k: remove return for empty tx bitrate in mac_op_sta_statistics
      ath11k: fix the value of msecs_to_jiffies in ath11k_debugfs_fw_stats_request
      ath11k: move peer delete after vdev stop of station for QCA6390 and WCN6855
      ath11k: add string type to search board data in board-2.bin for WCN6855

Yang Guang (1):
      ath9k: use swap() to make code cleaner

Ye Guojin (1):
      rtw89: remove unnecessary conditional operators

Yu-Yen Ting (2):
      rtw88: follow the AP basic rates for tx mgmt frame
      rtw88: add debugfs to force lowest basic rate

Zekun Shen (4):
      ar5523: Fix null-ptr-deref with unexpected WDCMSG_TARGET_START reply
      mwifiex: Fix skb_over_panic in mwifiex_usb_recv()
      rsi: Fix use-after-free in rsi_rx_done_handler()
      rsi: Fix out-of-bounds read in rsi_read_pkt()

Zong-Zhe Yang (4):
      rtw89: fill regd field of limit/limit_ru tables by enum
      rtw89: update rtw89 regulation definition to R58-R31
      rtw89: update tx power limit/limit_ru tables to R54
      rtw89: update rtw89_regulatory map to R58-R31

 drivers/misc/mei/bus.c                             |    67 +-
 drivers/misc/mei/client.c                          |     3 +
 drivers/misc/mei/hw.h                              |     5 +
 drivers/net/wireless/ath/ar5523/ar5523.c           |     4 +
 drivers/net/wireless/ath/ath10k/core.c             |    64 +-
 drivers/net/wireless/ath/ath10k/core.h             |     6 +
 drivers/net/wireless/ath/ath11k/ce.c               |    55 +-
 drivers/net/wireless/ath/ath11k/ce.h               |     3 +-
 drivers/net/wireless/ath/ath11k/core.c             |    52 +-
 drivers/net/wireless/ath/ath11k/core.h             |    16 +
 drivers/net/wireless/ath/ath11k/dbring.c           |    16 +-
 drivers/net/wireless/ath/ath11k/dbring.h           |     2 +-
 drivers/net/wireless/ath/ath11k/debug.c            |    12 +-
 drivers/net/wireless/ath/ath11k/debug.h            |     3 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |     2 +-
 drivers/net/wireless/ath/ath11k/dp.c               |    48 +-
 drivers/net/wireless/ath/ath11k/dp.h               |     4 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   225 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |    86 +-
 drivers/net/wireless/ath/ath11k/hal.c              |    35 +-
 drivers/net/wireless/ath/ath11k/hal.h              |     1 +
 drivers/net/wireless/ath/ath11k/htc.c              |    71 +-
 drivers/net/wireless/ath/ath11k/htc.h              |     9 +-
 drivers/net/wireless/ath/ath11k/hw.c               |     2 -
 drivers/net/wireless/ath/ath11k/hw.h               |     5 +
 drivers/net/wireless/ath/ath11k/mac.c              |   324 +-
 drivers/net/wireless/ath/ath11k/mac.h              |     1 +
 drivers/net/wireless/ath/ath11k/pci.c              |    22 +-
 drivers/net/wireless/ath/ath11k/peer.h             |     1 +
 drivers/net/wireless/ath/ath11k/qmi.c              |    21 +-
 drivers/net/wireless/ath/ath11k/reg.c              |   103 +-
 drivers/net/wireless/ath/ath11k/trace.c            |     1 +
 drivers/net/wireless/ath/ath11k/trace.h            |   172 +
 drivers/net/wireless/ath/ath11k/wmi.c              |   159 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |    20 +-
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |     2 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |    14 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |    96 +-
 drivers/net/wireless/ath/wcn36xx/dxe.h             |     1 +
 drivers/net/wireless/ath/wcn36xx/main.c            |    49 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |     8 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c            |    41 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |     1 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    21 +
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |    19 +
 drivers/net/wireless/intel/iwlwifi/Kconfig         |    26 +
 drivers/net/wireless/intel/iwlwifi/Makefile        |     1 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |    61 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |    11 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |     2 +
 drivers/net/wireless/intel/iwlwifi/mei/Makefile    |     8 +
 drivers/net/wireless/intel/iwlwifi/mei/internal.h  |    20 +
 drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h   |   505 +
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |  1982 +++
 drivers/net/wireless/intel/iwlwifi/mei/net.c       |   409 +
 drivers/net/wireless/intel/iwlwifi/mei/sap.h       |   733 ++
 .../net/wireless/intel/iwlwifi/mei/trace-data.h    |    82 +
 drivers/net/wireless/intel/iwlwifi/mei/trace.c     |    15 +
 drivers/net/wireless/intel/iwlwifi/mei/trace.h     |    76 +
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile    |     1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |     3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   120 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    74 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   203 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |     4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |     7 +-
 .../net/wireless/intel/iwlwifi/mvm/vendor-cmd.c    |   151 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |    25 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |    21 +-
 drivers/net/wireless/intersil/hostap/hostap_hw.c   |     5 +-
 drivers/net/wireless/intersil/hostap/hostap_wlan.h |    14 +-
 drivers/net/wireless/marvell/libertas/host.h       |    10 +-
 drivers/net/wireless/marvell/libertas/tx.c         |     5 +-
 .../net/wireless/marvell/libertas_tf/libertas_tf.h |    10 +-
 drivers/net/wireless/marvell/libertas_tf/main.c    |     3 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |     4 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |    18 +
 drivers/net/wireless/marvell/mwifiex/main.h        |     5 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |     3 +
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |    28 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |     3 +
 drivers/net/wireless/marvell/mwifiex/usb.c         |     3 +-
 drivers/net/wireless/marvell/mwl8k.c               |    10 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |     5 -
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |    17 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |     1 -
 drivers/net/wireless/realtek/rtw88/debug.c         |    39 +
 drivers/net/wireless/realtek/rtw88/main.h          |     1 +
 drivers/net/wireless/realtek/rtw88/pci.c           |     9 +
 drivers/net/wireless/realtek/rtw88/tx.c            |    27 +-
 drivers/net/wireless/realtek/rtw89/core.h          |     9 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |     7 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |     5 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |    10 +
 drivers/net/wireless/realtek/rtw89/phy.c           |    47 +-
 drivers/net/wireless/realtek/rtw89/regd.c          |   375 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |     4 +-
 .../net/wireless/realtek/rtw89/rtw8852a_table.c    | 12201 +++++++++++--------
 drivers/net/wireless/rsi/rsi_91x_main.c            |     4 +
 drivers/net/wireless/rsi/rsi_91x_usb.c             |     9 +-
 drivers/net/wireless/rsi/rsi_usb.h                 |     2 +
 drivers/net/wireless/ti/wlcore/sdio.c              |     2 +-
 include/linux/mei_cl_bus.h                         |     3 +
 103 files changed, 13380 insertions(+), 5930 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/Makefile
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/internal.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/main.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/net.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/sap.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/trace-data.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/trace.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/trace.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/vendor-cmd.c
