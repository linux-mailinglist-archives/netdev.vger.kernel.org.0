Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B5252D7D8
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbiESPfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiESPfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:35:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CE166CA8;
        Thu, 19 May 2022 08:33:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98CAFB824E4;
        Thu, 19 May 2022 15:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D051C385AA;
        Thu, 19 May 2022 15:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652974415;
        bh=iN/b/mVmWI/1TMJNL9Q5VXRGSrILpffMubNxFY/r+Ok=;
        h=From:Subject:To:Cc:Date:From;
        b=ZiYtjT4tr6sY/K7QlwdYMUsGqv3Nb2B+CvujDpZpWsw6NF1lsVm4i7Iuy6GgbhTVh
         QQMvITAWZDnrWzkFj4Vt7RPBjVtVzX4hNx9M6xldsxhtQ9G6IicSokIJxDts5r04UO
         dWSsg5ugT0sUBxmcErDBICHgcwLDt3p0QWra/P6jeEh7JRhEMwNs6xerGihEol/0+W
         lzRbm17H42ZgcmMF6DnQUhDnFrlB6pWwqRFGA+yyKfHxWo6aZNQYJAJyRXZwajqLpB
         sEhNQq58xF+ZdWZaoKvkY2/7Pb3CMQ9BL3rgZ1+YHjYekJ+Vw0wGF6kXMLHNfY1JX2
         r/SnZYnonKcnA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-next-2022-05-19
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20220519153334.8D051C385AA@smtp.kernel.org>
Date:   Thu, 19 May 2022 15:33:34 +0000 (UTC)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit f43f0cd2d9b07caf38d744701b0b54d4244da8cc:

  Merge tag 'wireless-next-2022-05-03' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next (2022-05-03 17:27:51 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2022-05-19

for you to fetch changes up to 78488a64aea94a3336ee97f345c1496e9bc5ebdf:

  iwlwifi: mei: fix potential NULL-ptr deref (2022-05-18 12:58:59 +0200)

----------------------------------------------------------------
wireless-next patches for v5.19

Second set of patches for v5.19 and most likely the last one. rtw89
got support for 8852ce devices and mt76 now supports Wireless Ethernet
Dispatch.

Major changes:

cfg80211/mac80211

* support disabling EHT mode

rtw89

* add support for Realtek 8852ce devices

mt76

* Wireless Ethernet Dispatch support for flow offload

* non-standard VHT MCS10-11 support

* mt7921 AP mode support

* mt7921 ipv6 NS offload support

ath11k

* enable keepalive during WoWLAN suspend

* implement remain-on-channel support

----------------------------------------------------------------
Ajay Singh (5):
      wilc1000: increase firmware version array size
      wilc1000: use fixed function base register value to access SDIO_FBR_ENABLE_CSA
      wilc1000: fix crash observed in AP mode with cfg80211_register_netdevice()
      wilc1000: use 'u64' datatype for cookie variable
      wilc1000: add valid vmm_entry check before fetching from TX queue

Andy Shevchenko (1):
      bcma: gpio: Switch to use fwnode instead of of_node

Anilkumar Kolli (1):
      ath11k: Reuse the available memory after firmware reload

Avraham Stern (1):
      iwlwifi: mei: clear the sap data header before sending

Baochen Qiang (4):
      ath11k: Handle keepalive during WoWLAN suspend and resume
      ath11k: Implement remain-on-channel support
      ath11k: Don't check arvif->is_started before sending management frames
      ath11k: Designating channel frequency when sending management frames

Bo Jiao (2):
      mt76: mt7915: disable RX_HDR_TRANS_SHORT
      mt76: mt7615/mt7915: do reset_work with mt76's work queue

Chin-Yen Lee (1):
      rtw88: adjust adaptivity option to 1

Christophe JAILLET (1):
      mt76: mt7921: Fix the error handling path of mt7921_pci_probe()

Colin Ian King (3):
      ath11k: remove redundant assignment to variables vht_mcs and he_mcs
      mt76: mt7915: make read-only array ppet16_ppet8_ru3_ru0 static const
      mt76: mt7921: make read-only array ppet16_ppet8_ru3_ru0 static const

Deren Wu (2):
      mt76: fix antenna config missing in 6G cap
      mt76: mt7921: add ipv6 NS offload support

Dimitri John Ledkov (1):
      cfg80211: declare MODULE_FIRMWARE for regulatory.db

Dongliang Mu (1):
      rtlwifi: Use pr_warn instead of WARN_ONCE

Emmanuel Grumbach (2):
      iwlwifi: mvm: fix assert 1F04 upon reconfig
      iwlwifi: mvm: always tell the firmware to accept MCAST frames in BSS

Evelyn Tsai (1):
      mt76: fix MBSS index condition in DBDC mode

Felix Fietkau (16):
      mac80211: upgrade passive scan to active scan on DFS channels after beacon rx
      mt76: mt7915: fix DBDC default band selection on MT7915D
      mt76: mt7915: rework hardware/phy initialization
      mt76: reduce tx queue lock hold time
      mt76: dma: use kzalloc instead of devm_kzalloc for txwi
      mt76: mt7915: accept rx frames with non-standard VHT MCS10-11
      mt76: mt7921: accept rx frames with non-standard VHT MCS10-11
      mt76: fix use-after-free by removing a non-RCU wcid pointer
      mt76: fix rx reordering with non explicit / psmp ack policy
      mt76: do not attempt to reorder received 802.3 packets without agg session
      mt76: fix encap offload ethernet type check
      mt76: fix tx status related use-after-free race on station removal
      mt76: dma: add wrapper macro for accessing queue registers
      mt76: add support for overriding the device used for DMA mapping
      mt76: make number of tokens configurable dynamically
      mt76: mt7915: add Wireless Ethernet Dispatch support

H. Nikolaus Schaller (1):
      wl1251: dynamically allocate memory used for DMA

Haim Dreyfuss (1):
      iwlwifi: mvm: use NULL instead of ERR_PTR when parsing wowlan status

Hangyu Hua (1):
      mac80211: tx: delete a redundant if statement in ieee80211_check_fast_xmit()

Hsuan Hung (1):
      rtw89: 8852c: add settings to decrease the effect of DC

Jaehee Park (1):
      wfx: use container_of() to get vif

Jakub Kicinski (3):
      wil6210: switch to netif_napi_add_tx()
      mt76: switch to netif_napi_add_tx()
      qtnfmac: switch to netif_napi_add_weight()

Jiapeng Chong (1):
      ssb: remove unreachable code

Johannes Berg (19):
      cfg80211: remove cfg80211_get_chan_state()
      nl80211: don't hold RTNL in color change request
      nl80211: rework internal_flags usage
      wil6210: remove 'freq' debugfs
      mac80211: unify CCMP/GCMP AAD construction
      mac80211: fix typo in documentation
      mac80211: remove stray multi_sta_back_32bit docs
      mac80211: mlme: move in RSSI reporting code
      mac80211: use ifmgd->bssid instead of ifmgd->associated->bssid
      mac80211: mlme: use local SSID copy
      mac80211: remove unused argument to ieee80211_sta_connection_lost()
      mac80211: remove useless bssid copy
      mac80211: mlme: track assoc_bss/associated separately
      cfg80211: fix kernel-doc for cfg80211_beacon_data
      mac80211: refactor freeing the next_beacon
      iwlwifi: pcie: simplify MSI-X cause mapping
      iwlwifi: mvm: clean up authorized condition
      iwlwifi: fw: init SAR GEO table only if data is present
      iwlwifi: mei: fix potential NULL-ptr deref

Jonas Jelonek (2):
      mac80211: extend current rate control tx status API
      mac80211: minstrel_ht: support ieee80211_rate_status

Kalle Valo (4):
      ath11k: mac: fix too long line
      ath10k: mac: fix too long lines
      Merge tag 'mt76-for-kvalo-2022-05-12' of https://github.com/nbd168/wireless
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Lavanya Suresh (1):
      mac80211: disable BSS color collision detection in case of no free colors

Lorenzo Bianconi (11):
      mt76: mt7921u: add suspend/resume support
      mt76: mt7921: rely on mt76_dev rxfilter in mt7921_configure_filter
      mt76: mt7921: honor pm user configuration in mt7921_sniffer_interface_iter
      mt76: mt7915: fix unbounded shift in mt7915_mcu_beacon_mbss
      mt76: mt7915: fix possible uninitialized pointer dereference in mt7986_wmac_gpio_setup
      mt76: mt7915: fix possible NULL pointer dereference in mt7915_mac_fill_rx_vector
      mt76: mt7915: do not pass data pointer to mt7915_mcu_muru_debug_set
      mt76: mt7915: report rx mode value in mt7915_mac_fill_rx_rate
      mt76: mt7915: use 0xff to initialize bitrate_mask in mt7915_init_bitrate_mask
      mt76: mt7915: configure soc clocks in mt7986_wmac_init
      mt76: add gfp to mt76_mcu_msg_alloc signature

Manikanta Pubbisetty (2):
      ath11k: Add support for targets without trustzone
      ath11k: Fix RX de-fragmentation issue on WCN6750

MeiChia Chiu (1):
      mt76: mt7915: add support for 6G in-band discovery

Miri Korenblit (1):
      iwlwifi: mvm: remove vif_count

Mordechay Goodstein (1):
      iwlwifi: mvm: add OTP info in case of init failure

Muna Sinada (2):
      cfg80211: support disabling EHT mode
      mac80211: support disabling EHT mode

Pavel Löbl (1):
      brcmfmac: allow setting wlan MAC address using device tree

Peter Chiu (4):
      mt76: mt7915: update mt7986 patch in mt7986_wmac_adie_patch_7976()
      mt76: mt7915: fix twt table_mask to u16 in mt7915_dev
      mt76: mt7915: reject duplicated twt flows
      mt76: mt7915: limit minimum twt duration

Peter Seiderer (1):
      mac80211: minstrel_ht: fill all requested rates

Ping-Ke Shih (17):
      rtw89: 8852c: rfk: get calibrated channels to notify firmware
      rtw89: 8852c: add chip_ops::bb_ctrl_btc_preagc
      rtw89: 8852c: add basic and remaining chip_info
      rtw89: ps: fine tune polling interval while changing low power mode
      rtw89: correct AID settings of beamformee
      rtw89: 8852c: correct register definitions used by 8852c
      rtw89: 8852c: fix warning of FIELD_PREP() mask type
      rtw89: 8852c: add 8852ce to Makefile and Kconfig
      mac80211: consider Order bit to fill CCMP AAD
      rtw89: correct setting of RX MPDU length
      rtw89: correct CCA control
      rtw89: add debug select to dump MAC pages 0x30 to 0x33
      rtw89: add debug entry to dump BSSID CAM
      rtw89: add ieee80211::sta_rc_update ops
      rtw89: 8852c: set TX antenna path
      rtw89: cfo: check mac_id to avoid out-of-bounds
      rtw89: pci: only mask out INT indicator register for disable interrupt v1

Rameshkumar Sundaram (1):
      nl80211: Parse NL80211_ATTR_HE_BSS_COLOR as a part of nl80211_parse_beacon

Robert Marko (1):
      ath10k: support bus and device specific API 1 BDF selection

Ryder Lee (7):
      mt76: mt7915: always call mt7915_wfsys_reset() during init
      mt76: mt7915: remove SCS feature
      mt76: mt7915: rework SER debugfs knob
      mt76: mt7915: introduce mt7915_mac_severe_check()
      mt76: mt7915: move MT_INT_MASK_CSR to init.c
      mt76: mt7915: improve error handling for fw_debug knobs
      mt76: mt7915: add more statistics from fw_util debugfs knobs

Sean Wang (3):
      mt76: mt7921: Add AP mode support
      mt76: mt7921: fix kernel crash at mt7921_pci_remove
      mt76: connac: use skb_put_data instead of open coding

Shayne Chen (1):
      mt76: mt7915: add debugfs knob for RF registers read/write

Srinivasan R (1):
      wireless: Fix Makefile to be in alphabetical order

Tetsuo Handa (1):
      wfx: avoid flush_workqueue(system_highpri_wq) usage

Wen Gong (1):
      ath11k: reset 11d state in process of recovery

Yunbo Yu (1):
      mt76: mt7603: move spin_lock_bh() to spin_lock()

Zong-Zhe Yang (2):
      rtw89: 8852c: update txpwr tables to HALRF_027_00_052
      rtw89: convert rtw89_band to nl80211_band precisely

 drivers/bcma/driver_gpio.c                         |    7 +-
 drivers/net/wireless/Makefile                      |    2 +-
 drivers/net/wireless/ath/ath10k/core.c             |   13 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   13 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |  178 +-
 drivers/net/wireless/ath/ath11k/ahb.h              |    9 +
 drivers/net/wireless/ath/ath11k/core.c             |   10 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |    8 +-
 drivers/net/wireless/ath/ath11k/hal.h              |    2 +-
 drivers/net/wireless/ath/ath11k/hw.c               |   23 +-
 drivers/net/wireless/ath/ath11k/hw.h               |    2 +
 drivers/net/wireless/ath/ath11k/mac.c              |  172 +-
 drivers/net/wireless/ath/ath11k/mac.h              |    4 +
 drivers/net/wireless/ath/ath11k/qmi.c              |   24 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |    2 +
 drivers/net/wireless/ath/ath11k/reg.c              |    3 +
 drivers/net/wireless/ath/ath11k/wmi.c              |   62 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |   46 +
 drivers/net/wireless/ath/ath11k/wow.c              |   34 +
 drivers/net/wireless/ath/wil6210/debugfs.c         |   14 -
 drivers/net/wireless/ath/wil6210/netdev.c          |   10 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |   23 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |    1 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |    4 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |    3 +
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |    3 +
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |    2 +
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |    3 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   22 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   32 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   17 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    1 -
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |    3 +
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   44 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   48 +-
 drivers/net/wireless/mediatek/mt76/agg-rx.c        |    8 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |  215 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   14 +-
 drivers/net/wireless/mediatek/mt76/mcu.c           |    8 +-
 drivers/net/wireless/mediatek/mt76/mmio.c          |    9 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   50 +-
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |    8 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |   12 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    8 +-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |   10 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |    8 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |    2 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |    7 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |    1 -
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |    8 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   10 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |  201 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |   61 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |    2 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  129 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  249 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |    2 +
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   72 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  148 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   39 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   39 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   26 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |   99 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   61 +-
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c    |   41 +-
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   15 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   41 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  155 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  122 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   15 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |   10 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |    5 +
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |   62 +-
 .../net/wireless/mediatek/mt76/mt7921/usb_mac.c    |    7 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   53 +-
 drivers/net/wireless/microchip/wilc1000/hif.h      |    2 +-
 drivers/net/wireless/microchip/wilc1000/mon.c      |    4 +-
 drivers/net/wireless/microchip/wilc1000/netdev.c   |    3 +-
 drivers/net/wireless/microchip/wilc1000/sdio.c     |    2 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |    7 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   |    4 +-
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   |    4 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |    2 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |    2 +-
 drivers/net/wireless/realtek/rtw89/Kconfig         |   18 +-
 drivers/net/wireless/realtek/rtw89/Makefile        |    9 +
 drivers/net/wireless/realtek/rtw89/core.c          |   11 +-
 drivers/net/wireless/realtek/rtw89/core.h          |   14 +
 drivers/net/wireless/realtek/rtw89/debug.c         |    5 +
 drivers/net/wireless/realtek/rtw89/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw89/fw.c            |    2 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |   23 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |    1 +
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   12 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |    3 -
 drivers/net/wireless/realtek/rtw89/phy.c           |   30 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |    3 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |   22 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |  229 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c  |   18 +
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.h  |    1 +
 .../net/wireless/realtek/rtw89/rtw8852c_table.c    | 3714 ++++++++++----------
 drivers/net/wireless/silabs/wfx/bh.c               |    6 +-
 drivers/net/wireless/silabs/wfx/data_rx.c          |    5 +-
 drivers/net/wireless/silabs/wfx/data_tx.c          |    3 +-
 drivers/net/wireless/silabs/wfx/hif_tx.c           |    2 +-
 drivers/net/wireless/silabs/wfx/key.c              |    4 +-
 drivers/net/wireless/silabs/wfx/main.c             |    6 +
 drivers/net/wireless/silabs/wfx/queue.c            |    3 +-
 drivers/net/wireless/silabs/wfx/scan.c             |   11 +-
 drivers/net/wireless/silabs/wfx/sta.c              |   76 +-
 drivers/net/wireless/silabs/wfx/wfx.h              |    7 +-
 drivers/net/wireless/ti/wl1251/event.c             |   22 +-
 drivers/net/wireless/ti/wl1251/io.c                |   20 +-
 drivers/net/wireless/ti/wl1251/tx.c                |   15 +-
 drivers/ssb/pci.c                                  |    1 -
 include/net/cfg80211.h                             |   14 +-
 include/net/mac80211.h                             |   36 +-
 include/uapi/linux/nl80211.h                       |    2 +
 net/mac80211/cfg.c                                 |   60 +-
 net/mac80211/debugfs_netdev.c                      |    2 +-
 net/mac80211/ieee80211_i.h                         |   12 +-
 net/mac80211/main.c                                |    4 +-
 net/mac80211/mlme.c                                |  117 +-
 net/mac80211/offchannel.c                          |    2 +-
 net/mac80211/rc80211_minstrel_ht.c                 |  154 +-
 net/mac80211/rc80211_minstrel_ht.h                 |    2 +-
 net/mac80211/scan.c                                |   20 +
 net/mac80211/status.c                              |   91 +-
 net/mac80211/tx.c                                  |    2 -
 net/mac80211/util.c                                |   40 -
 net/mac80211/wpa.c                                 |  103 +-
 net/wireless/chan.c                                |   93 +-
 net/wireless/core.h                                |   14 +-
 net/wireless/ibss.c                                |    4 +-
 net/wireless/nl80211.c                             |  416 ++-
 net/wireless/reg.c                                 |    4 +
 139 files changed, 5325 insertions(+), 3091 deletions(-)
