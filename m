Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F184B223B
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242548AbiBKJlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:41:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237122AbiBKJlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:41:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160CF1031;
        Fri, 11 Feb 2022 01:41:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9534DB828C2;
        Fri, 11 Feb 2022 09:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B3BC340E9;
        Fri, 11 Feb 2022 09:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644572460;
        bh=Osg09wnVq74dsZgoT8TIUbXe5E3FwinJqUwPXseixMk=;
        h=From:Subject:To:Cc:Date:From;
        b=tVhOEaaTcIsLX9lRBRFD8sHLSgbGf8nAL/qderm7pbbtwHCfmtPnwhFBT+OJXL9hU
         GGR1KTXlabCw3MNGjIaUmFu6lw1hUm+iE66jPQnG3FfhDLfimgzOBGf1CcO5wRyTqt
         ys1c7PSt5JDqnMvD0CleW97+6UhMrm6buIVNqNd8bUTVs0A8GW3lCsZRmDFYpG0uPv
         VDvR9RDlp0yGPs4zBEjLRZwAGLbiykaBw5R6PZKncrKuBxHI1p1BNn9eODr5I+u56e
         jY96KMTnIV+jclByyvwpz8Gds1r4EFXhr4LW5MbHdaNtBd164YSoApAgFOjeUCLARV
         /wZ+A9HShSk6w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-next-2022-02-11
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20220211094059.52B3BC340E9@smtp.kernel.org>
Date:   Fri, 11 Feb 2022 09:40:59 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

The following changes since commit e7d786331c62f260fa5174ff6dde788181f3bf6b:

  Merge branch 'udp-ipv6-optimisations' (2022-01-27 19:46:14 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2022-02-11

for you to fetch changes up to 4960ada836de4a22625fc69d5a6d0581ba061575:

  Merge tag 'mt76-for-kvalo-2022-02-04' of https://github.com/nbd168/wireless into main (2022-02-10 16:36:03 +0200)

----------------------------------------------------------------
wireless-next patches for v5.18

First set of patches for v5.18, with both wireless and stack patches.
rtw89 now has AP mode support and wcn36xx has survey support. But
otherwise pretty normal.

Major changes:

ath11k

* add LDPC FEC type in 802.11 radiotap header

* enable RX PPDU stats in monitor co-exist mode

wcn36xx

* implement survey reporting

brcmfmac

* add CYW43570 PCIE device

rtw88

* rtw8821c: enable RFE 6 devices

rtw89

* AP mode support

mt76

* mt7916 support

* background radar detection support

----------------------------------------------------------------
Aditya Kumar Singh (1):
      ath11k: fix workqueue not getting destroyed after rmmod

Aloka Dixit (1):
      ath11k: move function ath11k_dp_rx_process_mon_status

Avraham Stern (2):
      cfg80211: don't add non transmitted BSS to 6GHz scanned channels
      mac80211: fix struct ieee80211_tx_info size

Baligh Gasmi (1):
      mac80211: remove useless ieee80211_vif_is_mesh() check

Baochen Qiang (1):
      ath11k: Reconfigure hardware rate for WCN6855 after vdev is started

Ben Greear (1):
      mt76: mt7921: fix crash when startup fails.

Bo Jiao (14):
      mt76: mt7915: add mt7915_mmio_probe() as a common probing function
      mt76: mt7915: refine register definition
      mt76: add MT_RXQ_MAIN_WA for mt7916
      mt76: mt7915: rework dma.c to adapt mt7916 changes
      mt76: mt7915: add firmware support for mt7916
      mt76: mt7915: rework eeprom.c to adapt mt7916 changes
      mt76: mt7915: enlarge wcid size to 544
      mt76: mt7915: add txfree event v3
      mt76: mt7915: update rx rate reporting for mt7916
      mt76: mt7915: update mt7915_chan_mib_offs for mt7916
      mt76: mt7915: add mt7916 calibrated data support
      mt76: set wlan_idx_hi on mt7916
      mt76: mt7915: add device id for mt7916
      mt76: redefine mt76_for_each_q_rx to adapt mt7986 changes

Bryan O'Donoghue (4):
      wcn36xx: Implement get_snr()
      wcn36xx: Track the band and channel we are tuned to
      wcn36xx: Track SNR and RSSI for each RX frame
      wcn36xx: Add SNR reporting via get_survey()

Changcheng Deng (1):
      wilc1000: use min_t() to make code cleaner

Chien-Hsun Liao (2):
      rtw88: recover rates of rate adaptive mechanism
      rtw89: recover rates of rate adaptive mechanism

Chin-Yen Lee (1):
      rtw89: use pci_read/write_config instead of dbi read/write

Christophe JAILLET (1):
      ath: dfs_pattern_detector: Avoid open coded arithmetic in memory allocation

Colin Ian King (3):
      cw1200: wsm: make array queue_id_to_wmm_aci static const
      rtlwifi: remove redundant initialization of variable ul_encalgo
      brcmfmac: of: remove redundant variable len

Dan Carpenter (2):
      ath11k: fix error code in ath11k_qmi_assign_target_mem_chunk()
      rtw88: fix use after free in rtw_hw_scan_update_probe_req()

Felix Fietkau (11):
      mt76: mt7915: fix polling firmware-own status
      mt76: mt7915: move pci specific code back to pci.c
      mt76: connac: add support for passing the cipher field in bss_info
      mt76: mt7615: update bss_info with cipher after setting the group key
      mt76: mt7915: update bss_info with cipher after setting the group key
      mt76: mt7915: add support for passing chip/firmware debug data to user space
      mt76x02: improve mac error check/reset reliability
      mt76: mt76x02: improve tx hang detection
      mt76: mt7915: fix/rewrite the dfs state handling logic
      mt76: mt7615: fix/rewrite the dfs state handling logic
      mt76: mt76x02: use mt76_phy_dfs_state to determine radar detector state

Francesco Magliocca (1):
      ath10k: abstract htt_rx_desc structure

Gustavo A. R. Silva (1):
      brcmfmac: p2p: Replace one-element arrays with flexible-array members

Hans de Goede (1):
      brcmfmac: use ISO3166 country code and 0 rev as fallback on some devices

Hector Martin (8):
      brcmfmac: pcie: Release firmwares in the brcmf_pcie_setup error path
      brcmfmac: firmware: Allocate space for default boardrev in nvram
      brcmfmac: pcie: Declare missing firmware files in pcie.c
      brcmfmac: pcie: Replace brcmf_pcie_copy_mem_todev with memcpy_toio
      brcmfmac: pcie: Fix crashes due to early IRQs
      brcmfmac: of: Use devm_kstrdup for board_type & check for errors
      brcmfmac: fwil: Constify iovar name arguments
      brcmfmac: pcie: Read the console on init and shutdown

Jiapeng Chong (1):
      mac80211: Remove redundent assignment channel_type

Jiasheng Jiang (1):
      ray_cs: Check ioremap return value

Johannes Berg (8):
      mac80211: limit bandwidth in HE capabilities
      cfg80211/mac80211: assume CHECKSUM_COMPLETE includes SNAP
      ieee80211: fix -Wcast-qual warnings
      cfg80211: fix -Wcast-qual warnings
      ieee80211: radiotap: fix -Wcast-qual warnings
      mac80211: airtime: avoid variable shadowing
      cfg80211: pmsr: remove useless ifdef guards
      mac80211: remove unused macros

Johnson Lin (1):
      rtw89: refine DIG feature to support 160M and CCK PD

Kalle Valo (2):
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'mt76-for-kvalo-2022-02-04' of https://github.com/nbd168/wireless into main

Karthikeyan Periyasamy (1):
      ath11k: Refactor the fallback routine when peer create fails

Lad Prabhakar (2):
      ath10k: Use platform_get_irq() to get the interrupt
      wcn36xx: Use platform_get_irq_byname() to get the interrupt

Leon Yen (1):
      mt76: mt7921s: fix mt7921s_mcu_[fw|drv]_pmctrl

Lorenzo Bianconi (59):
      mt76: connac: fix sta_rec_wtbl tag len
      mt76: mt7915: rely on mt76_connac_mcu_alloc_sta_req
      mt76: mt7915: rely on mt76_connac_mcu_alloc_wtbl_req
      mt76: mt7915: rely on mt76_connac_mcu_add_tlv routine
      mt76: connac: move mt76_connac_mcu_get_cipher in common code
      mt76: connac: move mt76_connac_chan_bw in common code
      mt76: mt7915: rely on mt76_connac_get_phy utilities
      mt76: connac: move mt76_connac_mcu_add_key in connac module
      mt76: make mt76_sar_capa static
      mt76: mt7915: use proper aid value in mt7915_mcu_wtbl_generic_tlv in sta mode
      mt76: mt7915: use proper aid value in mt7915_mcu_sta_basic_tlv
      mt76: mt7915: remove duplicated defs in mcu.h
      mt76: connac: move mt76_connac_mcu_bss_omac_tlv in connac module
      mt76: connac: move mt76_connac_mcu_bss_ext_tlv in connac module
      mt76: connac: move mt76_connac_mcu_bss_basic_tlv in connac module
      mt76: mt7915: rely on mt76_connac_mcu_sta_ba_tlv
      mt76: mt7915: rely on mt76_connac_mcu_wtbl_ba_tlv
      mt76: mt7915: rely on mt76_connac_mcu_sta_ba
      mt76: mt7915: rely on mt76_connac_mcu_wtbl_generic_tlv
      mt76: mt7915: rely on mt76_connac_mcu_sta_basic_tlv
      mt76: mt7915: rely on mt76_connac_mcu_sta_uapsd
      mt76: mt7915: rely on mt76_connac_mcu_wtbl_smps_tlv
      mt76: mt7915: rely on mt76_connac_mcu_wtbl_ht_tlv
      mt76: mt7915: rely on mt76_connac_mcu_wtbl_hdr_trans_tlv
      mt76: connac: move mt76_connac_mcu_wtbl_update_hdr_trans in connac module
      mt76: connac: introduce is_connac_v1 utility routine
      mt76: connac: move mt76_connac_mcu_set_pm in connac module
      mt76: mt7921: get rid of mt7921_mcu_get_eeprom
      mt76: mt7915: rely on mt76_connac_mcu_start_firmware
      mt76: connac: move mt76_connac_mcu_restart in common module
      mt76: mt7915: rely on mt76_connac_mcu_patch_sem_ctrl/mt76_connac_mcu_start_patch
      mt76: mt7915: rely on mt76_connac_mcu_init_download
      mt76: connac: move mt76_connac_mcu_gen_dl_mode in mt76-connac module
      mt76: mt7915: rely on mt76_connac_mcu_set_rts_thresh
      mt76: connac: move mt76_connac_mcu_rdd_cmd in mt76-connac module
      mt76: mt7615: fix a possible race enabling/disabling runtime-pm
      mt76: mt7921e: process txfree and txstatus without allocating skbs
      mt76: mt7615e: process txfree and txstatus without allocating skbs
      mt76: mt7921: do not always disable fw runtime-pm
      mt76: mt7921: fix a leftover race in runtime-pm
      mt76: mt7615: fix a leftover race in runtime-pm
      mt76: mt7921: fix endianness issues in mt7921_mcu_set_tx()
      mt76: mt7921: toggle runtime-pm adding a monitor vif
      mt76: mt7915: introduce mt7915_set_radar_background routine
      mt76: mt7915: enable radar trigger on rdd2
      mt76: mt7915: introduce rdd_monitor debugfs node
      mt76: mt7915: report radar pattern if detected by rdd2
      mt76: mt7915: enable radar background detection
      dt-bindings:net:wireless:mediatek,mt76: add disable-radar-offchan
      mt76: connac: move mt76_connac_lmac_mapping in mt76-connac module
      mt76: mt7915: add missing DATA4_TB_SPTL_REUSE1 to mt7915_mac_decode_he_radiotap
      mt76: mt7921: remove duplicated code in mt7921_mac_decode_he_radiotap
      mt76: mt7663s: flush runtime-pm queue after waking up the device
      mt76: mt7603: check sta_rates pointer in mt7603_sta_rate_tbl_update
      mt76: mt7615: check sta_rates pointer in mt7615_sta_rate_tbl_update
      mt76: mt7915: fix possible memory leak in mt7915_mcu_add_sta
      mt76: mt7921s: fix a possible memory leak in mt7921_load_patch
      mt76: do not always copy ethhdr in reverse_frag0_hdr_trans
      mt76: dma: initialize skip_unmap in mt76_dma_rx_fill

MeiChia Chiu (1):
      mt76: mt7915: fix the nss setting in bitrates

Miles Hu (1):
      ath11k: enable RX PPDU stats in monitor co-exist mode

Minghao Chi (1):
      ath9k: remove redundant status variable

Mordechay Goodstein (4):
      mac80211: consider RX NSS in UHB connection
      mac80211: vht: use HE macros for parsing HE capabilities
      mac80211: mlme: add documentation from spec to code
      mac80211: mlme: validate peer HE supported rates

Muhammad Usama Anjum (1):
      rtw88: check for validity before using a pointer

P Praneesh (1):
      ath11k: add LDPC FEC type in 802.11 radiotap header

Pavel Skripkin (1):
      ath9k_htc: fix uninit value bugs

Peter Chiu (4):
      mt76: mt7915: fix ht mcs in mt7915_mac_add_txs_skb()
      mt76: mt7921: fix ht mcs in mt7921_mac_add_txs_skb()
      mt76: mt7915: fix mcs_map in mt7915_mcu_set_sta_he_mcs()
      mt76: mt7915: update max_mpdu_size in mt7915_mcu_sta_amsdu_tlv()

Peter Seiderer (5):
      ath5k: remove unused ah_txq_isr_qtrig member from struct ath5k_hw
      ath5k: remove unused ah_txq_isr_qcburn member from struct ath5k_hw
      ath5k: remove unused ah_txq_isr_qcborn member from struct ath5k_hw
      ath5k: remove unused ah_txq_isr_txurn member from struct ath5k_hw
      ath5k: fix ah_txq_isr_txok_all setting

Ping-Ke Shih (25):
      rtw89: remove duplicate definition of hardware port number
      rtw89: Add RX counters of VHT MCS-10/11 to debugfs
      rtw89: encapsulate RX handlers to single function
      rtw89: correct use of BA CAM
      rtw89: configure rx_filter according to FIF_PROBE_REQ
      rtw89: use hardware SSN to TX management frame
      rtw89: download beacon content to firmware
      rtw89: add C2H handle of BCN_CNT
      rtw89: implement mac80211_ops::set_tim to indicate STA to receive packets
      rtw89: allocate mac_id for each station in AP mode
      rtw89: extend firmware commands on states of sta_assoc and sta_disconnect
      rtw89: rename vif_maintain to role_maintain
      rtw89: configure mac port HIQ registers
      rtw89: send broadcast/multicast packets via HIQ if STAs are in sleep mode
      rtw89: set mac_id and port ID to TXWD
      rtw89: separate {init,deinit}_addr_cam functions
      rtw88: rtw8821c: enable rfe 6 devices
      rtw89: extend role_maintain to support AP mode
      rtw89: add addr_cam field to sta to support AP mode
      rtw89: only STA mode change vif_type mapping dynamically
      rtw89: maintain assoc/disassoc STA states of firmware and hardware
      rtw89: implement ieee80211_ops::start_ap and stop_ap
      rtw89: debug: add stations entry to show ID assignment
      rtw89: declare AP mode support
      rtw89: coex: set EN bit to PLT register

Piotr Dymacz (1):
      mt76: mt7615: add support for LG LGSBWAC02 (MT7663BUN)

Po-Hao Huang (2):
      rtw88: fix idle mode flow for hw scan
      rtw88: fix memory overrun and memory leak during hw_scan

Sean Wang (9):
      mt76: sdio: lock sdio when it is needed
      mt76: mt7921s: clear MT76_STATE_MCU_RUNNING immediately after reset
      mt76: mt7921e: make dev->fw_assert usage consistent
      mt76: mt76_connac: fix MCU_CE_CMD_SET_ROC definition error
      mt76: mt7921: set EDCA parameters with the MCU CE command
      mt76: mt7921e: fix possible probe failure after reboot
      mt76: sdio: disable interrupt in mt76s_sdio_irq
      mt76: sdio: honor the largest Tx buffer the hardware can support
      mt76: mt7921s: run sleep mode by default

Shayne Chen (1):
      mt76: mt7915: set bssinfo/starec command when adding interface

Soontak Lee (1):
      brcmfmac: add CYW43570 PCIE device

Wen Gong (4):
      ath10k: fix memory overwrite of the WoWLAN wakeup packet pattern
      ath11k: free peer for station when disconnect from AP for QCA6390/WCN6855
      ath11k: set WMI_PEER_40MHZ while peer assoc for 6 GHz
      ath11k: avoid firmware crash when reg set for QCA6390/WCN6855

Xing Song (1):
      mt76: stop the radar detector after leaving dfs channel

YN Chen (2):
      mt76: mt7921s: update mt7921s_wfsys_reset sequence
      mt76: mt7921: forbid the doze mode when coredump is in progress

Yang Guang (1):
      ssb: fix boolreturn.cocci warning

Yang Yingliang (1):
      ath11k: add missing of_node_put() to avoid leak

Zekun Shen (1):
      ath5k: fix OOB in ath5k_eeprom_read_pcal_info_5111

Zong-Zhe Yang (3):
      rtw89: extract modules by chipset
      rtw89: handle 6G band if supported by a chipset
      rtw89: include subband type in channel params

Íñigo Huguet (1):
      rtw89: fix maybe uninitialized `qempty` variable

 .../bindings/net/wireless/mediatek,mt76.yaml       |    9 +
 drivers/net/wireless/ath/ath10k/core.c             |   16 +
 drivers/net/wireless/ath/ath10k/htt.c              |  153 +++
 drivers/net/wireless/ath/ath10k/htt.h              |  296 ++++-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |  331 +++--
 drivers/net/wireless/ath/ath10k/htt_tx.c           |   36 +-
 drivers/net/wireless/ath/ath10k/hw.c               |   15 +-
 drivers/net/wireless/ath/ath10k/hw.h               |   27 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h          |   40 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   15 +-
 drivers/net/wireless/ath/ath10k/txrx.c             |    2 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |    2 +-
 drivers/net/wireless/ath/ath10k/wow.c              |    7 +-
 drivers/net/wireless/ath/ath11k/core.c             |   10 +
 drivers/net/wireless/ath/ath11k/core.h             |    1 +
 drivers/net/wireless/ath/ath11k/debugfs.c          |    6 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  195 ++-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |    5 +-
 drivers/net/wireless/ath/ath11k/hal_rx.h           |    8 +-
 drivers/net/wireless/ath/ath11k/hw.c               |   16 +
 drivers/net/wireless/ath/ath11k/hw.h               |    2 +
 drivers/net/wireless/ath/ath11k/mac.c              |   52 +-
 drivers/net/wireless/ath/ath11k/mhi.c              |    1 +
 drivers/net/wireless/ath/ath11k/peer.c             |   40 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |    3 +-
 drivers/net/wireless/ath/ath11k/reg.c              |   25 +-
 drivers/net/wireless/ath/ath5k/ath5k.h             |    4 -
 drivers/net/wireless/ath/ath5k/dma.c               |   23 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |    3 +
 drivers/net/wireless/ath/ath9k/eeprom.c            |    6 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    5 +
 drivers/net/wireless/ath/dfs_pattern_detector.c    |    6 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |  104 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c            |   36 +
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |   13 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   33 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |    2 +
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.c    |   34 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.h    |   28 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |   10 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   12 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   78 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |    1 -
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |    1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |    3 +
 drivers/net/wireless/mediatek/mt76/dma.c           |   14 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   30 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   22 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    3 +
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |   15 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |    1 -
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  136 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   12 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  220 +---
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |    1 +
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   22 +-
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c   |   15 +-
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |    1 +
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |   71 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  378 +++++-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |  117 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |    3 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c   |    5 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   25 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |   30 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h  |    2 +
 drivers/net/wireless/mediatek/mt76/mt7915/Kconfig  |    3 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |  217 +++-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |  454 +++++--
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |   87 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |    9 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  156 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  437 ++++---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |   15 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |  131 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    | 1323 +++++---------------
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   54 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |  577 ++++++++-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   87 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |  259 +---
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |  586 ++++++---
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |   61 +-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |   37 +-
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    |  119 --
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   10 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   37 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   36 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  274 +---
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   21 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |  125 ++
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |   37 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mcu.c    |   20 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |    3 +
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   |   15 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mac.c   |    6 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mcu.c   |   38 +
 drivers/net/wireless/mediatek/mt76/sdio.c          |   14 +-
 drivers/net/wireless/mediatek/mt76/sdio.h          |    2 +
 drivers/net/wireless/mediatek/mt76/sdio_txrx.c     |   26 +-
 drivers/net/wireless/microchip/wilc1000/spi.c      |    5 +-
 drivers/net/wireless/ray_cs.c                      |    6 +
 drivers/net/wireless/realtek/rtlwifi/cam.c         |    2 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |   42 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    5 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   83 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    4 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |    1 +
 drivers/net/wireless/realtek/rtw89/Kconfig         |    4 +
 drivers/net/wireless/realtek/rtw89/Makefile        |   13 +-
 drivers/net/wireless/realtek/rtw89/cam.c           |   40 +-
 drivers/net/wireless/realtek/rtw89/cam.h           |    5 +
 drivers/net/wireless/realtek/rtw89/coex.c          |   11 +-
 drivers/net/wireless/realtek/rtw89/core.c          |  458 +++++--
 drivers/net/wireless/realtek/rtw89/core.h          |  102 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |   93 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |  147 ++-
 drivers/net/wireless/realtek/rtw89/fw.h            |  140 ++-
 drivers/net/wireless/realtek/rtw89/mac.c           |   93 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |   22 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   80 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |  161 +--
 drivers/net/wireless/realtek/rtw89/pci.h           |    5 +
 drivers/net/wireless/realtek/rtw89/phy.c           |   91 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |    6 +
 drivers/net/wireless/realtek/rtw89/reg.h           |   18 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   20 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.h      |    2 +
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c     |   39 +
 drivers/net/wireless/realtek/rtw89/txrx.h          |    3 +
 drivers/net/wireless/st/cw1200/wsm.c               |    2 +-
 include/linux/ieee80211.h                          |    8 +-
 include/linux/ssb/ssb_driver_gige.h                |    2 +-
 include/net/cfg80211.h                             |   10 +-
 include/net/ieee80211_radiotap.h                   |    4 +-
 include/net/mac80211.h                             |   19 +-
 net/mac80211/airtime.c                             |   11 +-
 net/mac80211/debugfs.c                             |    2 +
 net/mac80211/debugfs_key.c                         |    2 +-
 net/mac80211/debugfs_netdev.c                      |    4 +-
 net/mac80211/ieee80211_i.h                         |    2 +-
 net/mac80211/mesh.c                                |    2 +-
 net/mac80211/mlme.c                                |  183 ++-
 net/mac80211/rc80211_minstrel_ht.c                 |    2 +-
 net/mac80211/rx.c                                  |    2 +
 net/mac80211/sta_info.c                            |    3 +-
 net/mac80211/status.c                              |   14 +-
 net/mac80211/util.c                                |   28 +-
 net/mac80211/vht.c                                 |    4 +-
 net/wireless/pmsr.c                                |    4 -
 net/wireless/scan.c                                |    9 +-
 net/wireless/util.c                                |    8 +-
 151 files changed, 6331 insertions(+), 3809 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852ae.c
