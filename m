Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B316641020
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 22:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbiLBVnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 16:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbiLBVnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 16:43:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9272C3E0A1;
        Fri,  2 Dec 2022 13:42:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E68CEB822B4;
        Fri,  2 Dec 2022 21:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D3DC433C1;
        Fri,  2 Dec 2022 21:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670017375;
        bh=wlTH1WcLRnR+aeNLeMyviPP2/60/HtjT9GCMxo/Hjfc=;
        h=From:Subject:To:Cc:Date:From;
        b=Ln5uouUYK7Vgv5xHo4Zlaq/iSomJzIgVJx5ths4BboDPlf7e8zdZ1p5Mcjsx2TC0d
         LI23qN6rC8gpfwTodCL5S+MC1kcCFKjRtRvXaOfqJ152vtymnue5bIWfCjkAnrbjzN
         M3NhhN6Dgzn+3IudD097vS9eI9+I1jM5mKKBiVFgDi3V2q4lZepP0nJvKo5oKVZdfb
         XFnVQgQ1pu8xHqyaYCgjpVLG2E/fEJTj7IY0E9nPsfdIUabVFyGHDxpTx1024k9kib
         Fnu02F0qJPdDkmh6O3OSNvTROJzizjuRtY+PgmWlwMLhZealgZRM477euuQyQQEsSa
         +azEAM7a9aNWw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-next-2022-12-02
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20221202214254.D0D3DC433C1@smtp.kernel.org>
Date:   Fri,  2 Dec 2022 21:42:54 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 8cf4f8c7d99addb6c2c2273fac7c20ca7c50db45:

  Merge tag 'rxrpc-next-20221116' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs (2022-11-18 12:09:20 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2022-12-02

for you to fetch changes up to d03407183d97554dfffea70f385b5bdd520f846c:

  wifi: ath10k: fix QCOM_SMEM dependency (2022-12-02 20:24:06 +0200)

----------------------------------------------------------------
wireless-next patches for v6.2

Third set of patches for v6.2. mt76 has a new driver for mt7996 Wi-Fi 7
devices and iwlwifi also got initial Wi-Fi 7 support. Otherwise
smaller features and fixes.

Major changes:

ath10k

* store WLAN firmware version in SMEM image table

mt76

* mt7996: new driver for MediaTek Wi-Fi 7 (802.11be) devices

* mt7986, mt7915: enable Wireless Ethernet Dispatch (WED) offload support

* mt7915: add ack signal support

* mt7915: enable coredump support

* mt7921: remain_on_channel support

* mt7921: channel context support

iwlwifi

* enable Wi-Fi 7 Extremely High Throughput (EHT) PHY capabilities

* 320 MHz channels support

----------------------------------------------------------------
Abhishek Naik (1):
      wifi: iwlwifi: nvm: Update EHT capabilities for GL device

Alexander Wetzel (1):
      wifi: mac80211: Drop not needed check for NULL

Avraham Stern (2):
      wifi: iwlwifi: mvm: trigger PCI re-enumeration in case of PLDR sync
      wifi: iwlwifi: mvm: return error value in case PLDR sync failed

Ben Greear (3):
      wifi: iwlwifi: mvm: fix double free on tx path.
      wifi: mt76: mt7915: fix bounds checking for tx-free-done command
      Revert "mt76: use IEEE80211_OFFLOAD_ENCAP_ENABLED instead of MT_DRV_AMSDU_OFFLOAD"

Bitterblue Smith (1):
      wifi: rtl8xxxu: Fix use after rcu_read_unlock in rtl8xxxu_bss_info_changed

Bo Jiao (2):
      wifi: mt76: mt7915: rework mt7915_dma_reset()
      wifi: mt76: mt7915: enable full system reset support

Chen Zhongjin (1):
      wifi: cfg80211: Fix not unregister reg_pdev when load_builtin_regdb_keys() fails

Colin Ian King (2):
      wifi: ath9k: remove variable sent
      wifi: ath9k: Remove unused variable mismatch

Daniel Gabay (1):
      wifi: iwlwifi: mvm: print OTP info after alive

Deren Wu (3):
      wifi: mt76: fix coverity overrun-call in mt76_get_txpower()
      wifi: mt76: mt7921: Add missing __packed annotation of struct mt7921_clc
      wifi: mt76: do not send firmware FW_FEATURE_NON_DL region

Eric Huang (2):
      wifi: rtw89: read CFO from FD or preamble CFO field of phy status ie_type 1 accordingly
      wifi: rtw89: switch BANDEDGE and TX_SHAPE based on OFDMA trigger frame

Evelyn Tsai (2):
      wifi: mt76: mt7915: reserve 8 bits for the index of rf registers
      wifi: mt76: connac: update nss calculation in txs

Felix Fietkau (4):
      wifi: mac80211: add support for restricting netdev features per vif
      wifi: mac80211: fix and simplify unencrypted drop check for mesh
      wifi: mt76: move mt76_rate_power from core to mt76x02 driver code
      wifi: mt76: mt76x02: simplify struct mt76x02_rate_power

Gaosheng Cui (1):
      wifi: mt76: Remove unused inline function mt76_wcid_mask_test()

Gregory Greenman (1):
      wifi: iwlwifi: mei: fix parameter passing to iwl_mei_alive_notif()

Gustavo A. R. Silva (4):
      wifi: brcmfmac: Replace one-element array with flexible-array member
      wifi: brcmfmac: Use struct_size() and array_size() in code ralated to struct brcmf_gscan_config
      wifi: brcmfmac: replace one-element array with flexible-array member in struct brcmf_dload_data_le
      wifi: brcmfmac: Use struct_size() in code ralated to struct brcmf_dload_data_le

Ilan Peer (1):
      wifi: iwlwifi: mvm: Advertise EHT capabilities

JUN-KYU SHIN (1):
      wifi: cfg80211: fix comparison of BSS frequencies

Jeff Johnson (2):
      wifi: ath10k: Make QMI message rules const
      wifi: ath11k: Make QMI message rules const

Ji-Pin Jou (1):
      wifi: rtw88: fix race condition when doing H2C command

Jiri Slaby (SUSE) (1):
      wifi: ath11k: synchronize ath11k_mac_he_gi_to_nl80211_he_gi()'s return type

Johannes Berg (7):
      wifi: iwlwifi: mvm: support 320 MHz PHY configuration
      wifi: iwlwifi: mvm: set HE PHY bandwidth according to band
      wifi: iwlwifi: mvm: advertise 320 MHz in 6 GHz only conditionally
      wifi: iwlwifi: nvm-parse: support A-MPDU in EHT 2.4 GHz
      wifi: mac80211: remove unnecessary synchronize_net()
      wifi: cfg80211: use bss_from_pub() instead of container_of()
      wifi: mac80211: don't parse multi-BSSID in assoc resp

Kalle Valo (4):
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'mt76-for-kvalo-2022-12-01' of https://github.com/nbd168/wireless
      Merge tag 'iwlwifi-next-for-kalle-2022-11-28' of http://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      wifi: ath10k: fix QCOM_SMEM dependency

Kees Cook (3):
      wifi: p54: Replace zero-length array of trailing structs with flex-array
      wifi: carl9170: Replace zero-length array of trailing structs with flex-array
      wifi: ieee80211: Do not open-code qos address offsets

Kieran Frewen (1):
      wifi: mac80211: update TIM for S1G specification changes

Leon Yen (1):
      wifi: mt76: mt7921e: add pci .shutdown() support

Lorenzo Bianconi (14):
      wifi: mt76: mt7915: move wed init routines in mmio.c
      wifi: mt76: mt7915: enable wed for mt7986 chipset
      wifi: mt76: mt7915: enable wed for mt7986-wmac chipset
      wifi: mt76: mt7915: fix reporting of TX AGGR histogram
      wifi: mt76: mt7921: fix reporting of TX AGGR histogram
      wifi: mt76: mt7615: rely on mt7615_phy in mt7615_mac_reset_counters
      wifi: mt76: move aggr_stats array in mt76_phy
      wifi: mt76: do not run mt76u_status_worker if the device is not running
      wifi: mt76: add WED RX support to mt76_dma_{add,get}_buf
      wifi: mt76: add WED RX support to mt76_dma_rx_fill
      wifi: mt76: add WED RX support to dma queue alloc
      wifi: mt76: mt7915: enable WED RX support
      wifi: mt76: mt76x0: remove dead code in mt76x0_phy_get_target_power
      wifi: mt76: mt7915: mmio: fix naming convention

Lukas Bulwahn (1):
      wifi: b43: remove reference to removed config B43_PCMCIA

Ming Yen Hsieh (1):
      wifi: mt76: fix bandwidth 80MHz link fail in 6GHz band

Minsuk Kang (1):
      wifi: brcmfmac: Check the count value of channel spec to prevent out-of-bounds reads

Miri Korenblit (1):
      wifi: iwlwifi: mvm: support PPE Thresholds for EHT

Mordechay Goodstein (2):
      wifi: iwlwifi: rs: add support for parsing max MCS per NSS/BW in 11be
      wifi: iwlwifi: mvm: add support for EHT 1K aggregation size

Nicolas Cavallari (3):
      wifi: mt76: mt7915: Fix chainmask calculation on mt7915 DBDC
      wifi: mt76: mt7915: Fix VHT beamforming capabilities with DBDC
      wifi: mt76: mt7915: don't claim 160MHz support with mt7915 DBDC

Peter Chiu (1):
      wifi: mt76: mt7915: deal with special variant of mt7916

Philipp Hortmann (1):
      wifi: cfg80211: Correct example of ieee80211_iface_limit

Ping-Ke Shih (5):
      wifi: rtw89: 8852b: correct TX power controlled by BT-coexistence
      wifi: rtw89: avoid inaccessible IO operations during doing change_interface()
      wifi: rtw89: add HE radiotap for monitor mode
      wifi: rtw89: 8852b: turn off PoP function in monitor mode
      wifi: rtw88: 8821c: enable BT device recovery mechanism

Quan Zhou (1):
      wifi: mt76: mt7921: add unified ROC cmd/event support

Rahul Bhattacharjee (1):
      wifi: ath11k: Fix qmi_msg_handler data structure initialization

Ryder Lee (18):
      wifi: mt76: mt7915: fix mt7915_mac_set_timing()
      wifi: mt76: mt7915: improve accuracy of time_busy calculation
      wifi: mt76: mt7915: add ack signal support
      wifi: mt76: mt7915: enable use_cts_prot support
      wifi: mt76: mt7615: enable use_cts_prot support
      wifi: mt76: mt7915: add full system reset into debugfs
      wifi: mt76: mt7915: enable coredump support
      wifi: mt76: mt7915: add missing MODULE_PARM_DESC
      wifi: mt76: mt7915: add support to configure spatial reuse parameter set
      wifi: mt76: mt7915: add basedband Txpower info into debugfs
      wifi: mt76: mt7915: enable .sta_set_txpwr support
      wifi: mt76: mt7915: fix band_idx usage
      wifi: mt76: mt7915: introduce mt7915_get_power_bound()
      wifi: mt76: mt7915: enable per bandwidth power limit support
      wifi: mt76: mt7915: rely on band_idx of mt76_phy
      wifi: mt76: mt7996: enable use_cts_prot support
      wifi: mt76: mt7996: enable ack signal support
      wifi: mt76: mt7996: add support to configure spatial reuse parameter set

Sean Wang (7):
      wifi: mt76: mt7921: fix antenna signal are way off in monitor mode
      wifi: mt76: connac: add mt76_connac_mcu_uni_set_chctx
      wifi: mt76: mt7921: add chanctx parameter to mt76_connac_mcu_uni_add_bss signature
      wifi: mt76: mt7921: drop ieee80211_[start, stop]_queues in driver
      wifi: mt76: connac: accept hw scan request at a time
      wifi: mt76: mt7921: introduce remain_on_channel support
      wifi: mt76: mt7921: introduce chanctx support

Shayne Chen (14):
      wifi: mt76: mt7915: rework eeprom tx paths and streams init
      wifi: mt76: mt7915: rework testmode tx antenna setting
      wifi: mt76: connac: introduce mt76_connac_spe_idx()
      wifi: mt76: mt7915: add spatial extension index support
      wifi: mt76: mt7915: set correct antenna for radar detection on MT7915D
      wifi: mt76: connac: rework macros for unified command
      wifi: mt76: connac: update struct sta_rec_phy
      wifi: mt76: connac: rework fields for larger bandwidth support in sta_rec_bf
      wifi: mt76: connac: add more unified command IDs
      wifi: mt76: connac: introduce unified event table
      wifi: mt76: connac: add more bss info command tags
      wifi: mt76: connac: add more starec command tags
      wifi: mt76: connac: introduce helper for mt7996 chipset
      wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices

Sujuan Chen (4):
      wifi: mt76: introduce rxwi and rx token utility routines
      wifi: mt76: add info parameter to rx_skb signature
      wifi: mt76: connac: introduce mt76_connac_mcu_sta_wed_update utility routine
      wifi: mt76: mt7915: enable WED RX stats

Xiongfeng Wang (1):
      mt76: mt7915: Fix PCI device refcount leak in mt7915_pci_init_hif2()

Xiu Jianfeng (1):
      wifi: ath10k: Fix return value in ath10k_pci_init()

YN Chen (1):
      wifi: mt76: mt7921: fix wrong power after multiple SAR set

Youghandhar Chintala (2):
      wifi: ath11k: Trigger sta disconnect on hardware restart
      wifi: ath10k: Store WLAN firmware version in SMEM image table

Yuan Can (1):
      wifi: nl80211: Add checks for nla_nest_start() in nl80211_send_iface()

Zhengchao Shao (1):
      wifi: mac80211: fix memory leak in ieee80211_if_add()

Zhi-Jun You (2):
      wifi: ath10k: Use IEEE80211_SEQ_TO_SN() for seq_ctrl conversion
      wifi: ath10k: Remove redundant argument offset

Ziyang Xuan (1):
      wifi: plfxlc: fix potential memory leak in __lf_x_usb_enable_rx()

Zong-Zhe Yang (8):
      wifi: rtw89: fix physts IE page check
      wifi: rtw89: enable mac80211 virtual monitor interface
      wifi: rtw89: rfk: rename rtw89_mcc_info to rtw89_rfk_mcc_info
      wifi: rtw89: check if atomic before queuing c2h
      wifi: rtw89: introduce helpers to wait/complete on condition
      wifi: rtw89: mac: process MCC related C2H
      wifi: rtw89: fw: implement MCC related H2C
      wifi: rtw89: link rtw89_vif and chanctx stuffs

Íñigo Huguet (1):
      wifi: mac80211: fix maybe-unused warning

 drivers/net/wireless/ath/ath10k/Kconfig            |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   25 +-
 drivers/net/wireless/ath/ath10k/pci.c              |   20 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |   37 +-
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c     |  126 +-
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h     |  102 +-
 drivers/net/wireless/ath/ath11k/core.c             |    6 +
 drivers/net/wireless/ath/ath11k/hw.h               |    1 +
 drivers/net/wireless/ath/ath11k/mac.c              |    7 +
 drivers/net/wireless/ath/ath11k/mac.h              |    2 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   75 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.c        |    3 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |    2 -
 drivers/net/wireless/ath/carl9170/fwcmd.h          |    4 +-
 drivers/net/wireless/broadcom/b43/main.c           |   10 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   17 +
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |    7 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |    4 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c |    6 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |    6 +-
 .../net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h   |   33 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |   10 +-
 drivers/net/wireless/intel/iwlwifi/fw/rs.c         |    2 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |    3 +
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.h  |    3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h |    1 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  235 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |    1 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |    1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   29 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  189 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    2 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |   54 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |  125 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   12 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   85 +-
 drivers/net/wireless/intersil/p54/eeprom.h         |    4 +-
 drivers/net/wireless/mediatek/mt76/Kconfig         |    1 +
 drivers/net/wireless/mediatek/mt76/Makefile        |    1 +
 drivers/net/wireless/mediatek/mt76/debugfs.c       |   19 -
 drivers/net/wireless/mediatek/mt76/dma.c           |  244 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |    8 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   27 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   50 +-
 .../net/wireless/mediatek/mt76/mt7603/debugfs.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |    2 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   34 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |    7 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |    2 +
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |   16 +
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |   17 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  214 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   99 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |   28 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |   16 +-
 .../net/wireless/mediatek/mt76/mt76x02_debugfs.c   |   19 +-
 .../net/wireless/mediatek/mt76/mt76x02_eeprom.h    |    2 -
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |    6 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c   |   22 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.h   |    6 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c  |   14 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c |   16 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/Kconfig  |    1 +
 drivers/net/wireless/mediatek/mt76/mt7915/Makefile |    3 +-
 .../net/wireless/mediatek/mt76/mt7915/coredump.c   |  410 +++
 .../net/wireless/mediatek/mt76/mt7915/coredump.h   |  136 +
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |  307 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |  207 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |   66 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |    5 -
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  135 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  635 +++-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |  142 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  495 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   60 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |  414 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   65 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |  106 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   88 +-
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c    |   21 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |   71 +-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   91 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   56 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  233 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  161 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   74 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |   59 +-
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   |   31 +-
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |   22 +-
 drivers/net/wireless/mediatek/mt76/mt7996/Kconfig  |   12 +
 drivers/net/wireless/mediatek/mt76/mt7996/Makefile |    6 +
 .../net/wireless/mediatek/mt76/mt7996/debugfs.c    |  851 +++++
 drivers/net/wireless/mediatek/mt76/mt7996/dma.c    |  360 ++
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c |  229 ++
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.h |   75 +
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |  823 +++++
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    | 2498 ++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7996/mac.h    |  398 +++
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   | 1334 ++++++++
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    | 3607 ++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |  669 ++++
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |  386 +++
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |  523 +++
 drivers/net/wireless/mediatek/mt76/mt7996/pci.c    |  222 ++
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h   |  542 +++
 drivers/net/wireless/mediatek/mt76/sdio.c          |    2 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   30 +
 drivers/net/wireless/mediatek/mt76/usb.c           |   13 +-
 drivers/net/wireless/mediatek/mt76/util.h          |    6 -
 drivers/net/wireless/purelifi/plfxlc/usb.c         |    1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |    2 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |   18 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |   11 +
 drivers/net/wireless/realtek/rtw88/mac.c           |   18 +-
 drivers/net/wireless/realtek/rtw89/chan.c          |   40 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   73 +-
 drivers/net/wireless/realtek/rtw89/core.h          |   83 +-
 drivers/net/wireless/realtek/rtw89/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw89/fw.c            |  386 ++-
 drivers/net/wireless/realtek/rtw89/fw.h            |  451 ++-
 drivers/net/wireless/realtek/rtw89/mac.c           |  188 +
 drivers/net/wireless/realtek/rtw89/mac.h           |   35 +
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   12 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |    2 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |  129 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |    5 +
 drivers/net/wireless/realtek/rtw89/reg.h           |    2 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |    2 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |   39 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |    6 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c  |   20 +-
 drivers/net/wireless/realtek/rtw89/txrx.h          |    4 +-
 include/linux/ieee80211.h                          |   28 +-
 include/net/cfg80211.h                             |    2 +-
 include/net/fq_impl.h                              |   16 +-
 include/net/mac80211.h                             |    5 +
 net/mac80211/cfg.c                                 |    2 +-
 net/mac80211/iface.c                               |    5 +-
 net/mac80211/mlme.c                                |    2 +-
 net/mac80211/rx.c                                  |   38 +-
 net/mac80211/tx.c                                  |  299 +-
 net/wireless/nl80211.c                             |    3 +
 net/wireless/reg.c                                 |    4 +-
 net/wireless/scan.c                                |   44 +-
 157 files changed, 19213 insertions(+), 1629 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/coredump.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/coredump.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/Makefile
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/main.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/pci.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/regs.h
