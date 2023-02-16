Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24C069924C
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 11:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjBPKyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 05:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjBPKyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 05:54:16 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB40FEB5D;
        Thu, 16 Feb 2023 02:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=11w31CCSVjfNkWOUbZjtt6Vhv3mHCirym9Ht5E50Cfw=; t=1676544852; x=1677754452; 
        b=p3tFEtqGm9KPsQgqX/4X7nngez2Vy5Sqkt+63xX5oFeujHodzmtRVzEhhY2mhOcUsJPQO6zMgcO
        jeHz7WbES8VqSQckbybsq+3ggUz8zV9fmnl3XdjViVonksV5vkkGz/5A5bX55KfAJIyCdFUdRqaKA
        zfCcbJBiLXNXb5PGJQHRljM4jigomd746Q8XtznCV4lco1ei5bTZeebRWziLAOiVawNq3vNldyDkT
        TN/yVwe6kM2tJXF2hTSzw+QHS54NxZVbieJFv0OOeEsIVh/6HT4LkM5Ll2huoIpwSYY6ufnJFn9pa
        KBR2bMpiVoAAlmgn5QxkZtTtx1wNzhFB92EA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pSbtx-00DzcI-1a;
        Thu, 16 Feb 2023 11:54:09 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-next-2023-03-16
Date:   Thu, 16 Feb 2023 11:54:05 +0100
Message-Id: <20230216105406.208416-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here's a last (obviously) set of new work for -next. The
major changes are summarized in the tag below.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 75da437a2f172759b2273091a938772e687242d0:

  Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2023-02-10 19:50:48 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2023-03-16

for you to fetch changes up to 1a30a6b25f263686dbf2028d56041ac012b10dcb:

  wifi: brcmfmac: p2p: Introduce generic flexible array frame member (2023-02-16 09:33:25 +0100)

----------------------------------------------------------------
Major stack changes:
 * EHT channel puncturing support (client & AP)
 * some support for AP MLD without mac80211
 * fixes for A-MSDU on mesh connections

Major driver changes:

iwlwifi
 * EHT rate reporting
 * Bump FW API to 74 for AX devices
 * STEP equalizer support: transfer some STEP (connection to radio
   on platforms with integrated wifi) related parameters from the
   BIOS to the firmware

mt76
 * switch to using page pool allocator
 * mt7996 EHT (Wi-Fi 7) support
 * Wireless Ethernet Dispatch (WED) reset support

libertas
 * WPS enrollee support

brcmfmac
 * Rename Cypress 89459 to BCM4355
 * BCM4355 and BCM4377 support

mwifiex
 * SD8978 chipset support

rtl8xxxu
 * LED support

ath12k
 * new driver for Qualcomm Wi-Fi 7 devices

ath11k
 * IPQ5018 support
 * Fine Timing Measurement (FTM) responder role support
 * channel 177 support

ath10k
 * store WLAN firmware version in SMEM image table

----------------------------------------------------------------
Aaron Ma (1):
      wifi: mt76: mt7921: fix error code of return in mt7921_acpi_read

Alexander Wetzel (1):
      wifi: cfg80211: Fix use after free for wext

Aloka Dixit (4):
      wifi: cfg80211: move puncturing bitmap validation from mac80211
      wifi: nl80211: validate and configure puncturing bitmap
      wifi: cfg80211: include puncturing bitmap in channel switch events
      wifi: mac80211: configure puncturing bitmap

Alvin Šipraga (2):
      wifi: nl80211: emit CMD_START_AP on multicast group when an AP is started
      wifi: nl80211: add MLO_LINK_ID to CMD_STOP_AP event

Andrei Otcheretianski (1):
      wifi: mac80211: Don't translate MLD addresses for multicast

Arend van Spriel (1):
      wifi: brcmfmac: change cfg80211_set_channel() name and signature

Arnd Bergmann (1):
      wifi: mac80211: avoid u32_encode_bits() warning

Ayala Barazani (1):
      wifi: iwlwifi: mvm: Support STEP equalizer settings from BIOS.

Bitterblue Smith (4):
      wifi: rtl8xxxu: Register the LED and make it blink
      wifi: rtl8xxxu: Add LED control code for RTL8188EU
      wifi: rtl8xxxu: Add LED control code for RTL8192EU
      wifi: rtl8xxxu: Add LED control code for RTL8723AU

Bo Liu (1):
      rfkill: Use sysfs_emit() to instead of sprintf()

Chin-Yen Lee (4):
      wifi: rtw89: fix potential wrong mapping for pkt-offload
      wifi: rtw89: refine packet offload flow
      wifi: rtw89: 8852be: enable CLKREQ of PCI capability
      wifi: rtw89: move H2C of del_pkt_offload before polling FW status ready

Ching-Te Ku (8):
      wifi: rtw89: coex: Update Wi-Fi external control TDMA parameters/tables
      wifi: rtw89: coex: Clear Bluetooth HW PTA counter when radio state change
      wifi: rtw89: coex: Force to update TDMA parameter when radio state change
      wifi: rtw89: coex: Refine coexistence log
      wifi: rtw89: coex: Set Bluetooth background scan PTA request priority
      wifi: rtw89: coex: Correct A2DP exist variable source
      wifi: rtw89: coex: Fix test fail when coexist with raspberryPI A2DP idle
      wifi: rtw89: coex: Update Wi-Fi Bluetooth coexistence version to 7.0.0

Chuanhong Guo (1):
      wifi: mt76: mt7921u: add support for Comfast CF-952AX

Dan Carpenter (1):
      wifi: mwifiex: fix loop iterator in mwifiex_update_ampdu_txwinsize()

Deren Wu (7):
      wifi: mt76: mt7921: fix channel switch fail in monitor mode
      wifi: mt76: mt7921: add ack signal support
      wifi: mt76: mt7921: fix invalid remain_on_channel duration
      wifi: mt76: add flexible polling wait-interval support
      wifi: mt76: mt7921: reduce polling time in pmctrl
      wifi: mt76: add memory barrier to SDIO queue kick
      wifi: mt76: support ww power config in dts node

Dinesh Karthikeyan (3):
      wifi: ath12k: Fix incorrect qmi_file_type enum values
      wifi: ath12k: Add new qmi_bdf_type to handle caldata
      wifi: ath12k: Add support to read EEPROM caldata

Doug Brown (4):
      wifi: libertas: fix code style in Marvell structs
      wifi: libertas: only add RSN/WPA IE in lbs_add_wpa_tlv
      wifi: libertas: add new TLV type for WPS enrollee IE
      wifi: libertas: add support for WPS enrollee IE in probe requests

Emmanuel Grumbach (1):
      wifi: iwlwifi: mention the response structure in the kerneldoc

Fedor Pchelkin (2):
      wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg() if there is no callback function
      wifi: ath9k: hif_usb: clean up skbs if ath9k_hif_usb_rx_stream() fails

Felix Fietkau (6):
      wifi: mt76: mt7921: fix deadlock in mt7921_abort_roc
      wifi: cfg80211: move A-MSDU check in ieee80211_data_to_8023_exthdr
      wifi: cfg80211: factor out bridge tunnel / RFC1042 header check
      wifi: mac80211: remove mesh forwarding congestion check
      wifi: mac80211: fix receiving A-MSDU frames on mesh interfaces
      wifi: mac80211: add a workaround for receiving non-standard mesh A-MSDU

Gilad Itzkovitch (1):
      wifi: mac80211: Fix for Rx fragmented action frames

Golan Ben Ami (1):
      wifi: iwlwifi: bump FW API to 74 for AX devices

Govindaraj Saminathan (1):
      wifi: ath11k: Fix race condition with struct htt_ppdu_stats_info

Gregory Greenman (2):
      wifi: iwlwifi: mvm: always send nullfunc frames on MGMT queue
      wifi: iwlwifi: mei: fix compilation errors in rfkill()

Gustavo A. R. Silva (3):
      wifi: brcmfmac: Replace one-element array with flexible-array member
      wifi: mwifiex: Replace one-element arrays with flexible-array members
      wifi: mwifiex: Replace one-element array with flexible-array member

Hector Martin (4):
      wifi: brcmfmac: Rename Cypress 89459 to BCM4355
      wifi: brcmfmac: pcie: Add IDs/properties for BCM4355
      wifi: brcmfmac: pcie: Add IDs/properties for BCM4377
      wifi: brcmfmac: pcie: Perform correct BCM4364 firmware selection

Heiner Kallweit (1):
      wifi: iwlwifi: improve tag handling in iwl_request_firmware

Howard Hsu (4):
      wifi: mt76: mt7915: call mt7915_mcu_set_thermal_throttling() only after init_work
      wifi: mt76: mt7915: rework mt7915_mcu_set_thermal_throttling
      wifi: mt76: mt7915: rework mt7915_thermal_temp_store()
      wifi: mt76: mt7915: add error message in mt7915_thermal_set_cur_throttle_state()

Jaewan Kim (2):
      wifi: mac80211_hwsim: Rename pid to portid to avoid confusion
      wifi: nl80211: return error message for malformed chandef

Jiapeng Chong (1):
      wifi: ath10k: Remove the unused function ath10k_ce_shadow_src_ring_write_index_set()

Jiasheng Jiang (2):
      wifi: iwl3945: Add missing check for create_singlethread_workqueue
      wifi: iwl4965: Add missing check for create_singlethread_workqueue()

Johannes Berg (7):
      wifi: iwlwifi: mvm: add minimal EHT rate reporting
      wifi: cfg80211: trace: remove MAC_PR_{FMT,ARG}
      wifi: mac80211: mlme: handle EHT channel puncturing
      wifi: mac80211: fix off-by-one link setting
      wifi: mac80211: pass 'sta' to ieee80211_rx_data_set_sta()
      wifi: mac80211: always initialize link_sta with sta
      wifi: mac80211: add documentation for amsdu_mesh_control

Jonathan Neuschäfer (1):
      wifi: wl1251: Fix a typo ("boradcast")

Kalle Valo (8):
      wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices
      wifi: ath11k: debugfs: fix to work with multiple PCI devices
      wifi: ath12k: hal: add ab parameter to macros using it
      wifi: ath12k: hal: convert offset macros to functions
      wifi: ath12k: wmi: delete PSOC_HOST_MAX_NUM_SS
      Merge tag 'iwlwifi-next-for-kalle-2023-01-30' of http://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge tag 'mt76-for-kvalo-2023-02-03' of https://github.com/nbd168/wireless
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Karthikeyan Kathirvel (1):
      wifi: ath11k: Fix scan request param frame size warning

Karthikeyan Periyasamy (1):
      wifi: mac80211: fix non-MLO station association

Kees Cook (1):
      wifi: brcmfmac: p2p: Introduce generic flexible array frame member

Krzysztof Kozlowski (1):
      dt-bindings: net: wireless: minor whitespace and name cleanups

Kuan-Chung Chen (1):
      wifi: rtw89: disallow enter PS mode after create TDLS link

Lorenzo Bianconi (25):
      wifi: mt76: introduce mt76_queue_is_wed_rx utility routine
      wifi: mt76: mt7915: fix memory leak in mt7915_mcu_exit
      wifi: mt76: mt7996: fix memory leak in mt7996_mcu_exit
      wifi: mt76: dma: free rx_head in mt76_dma_rx_cleanup
      wifi: mt76: dma: fix memory leak running mt76_dma_tx_cleanup
      wifi: mt76: mt7915: avoid mcu_restart function pointer
      wifi: mt76: mt7603: avoid mcu_restart function pointer
      wifi: mt76: mt7615: avoid mcu_restart function pointer
      wifi: mt76: mt7921: avoid mcu_restart function pointer
      wifi: mt76: fix switch default case in mt7996_reverse_frag0_hdr_trans
      wifi: mt76: mt7915: fix memory leak in mt7915_mmio_wed_init_rx_buf
      wifi: mt76: switch to page_pool allocator
      wifi: mt76: enable page_pool stats
      wifi: mt76: mt7996: rely on mt76_connac2_mac_tx_rate_val
      wifi: mt76: mt7996: rely on mt76_connac_txp_common structure
      wifi: mt76: mt7996: rely on mt76_connac_txp_skb_unmap
      wifi: mt76: mt7996: rely on mt76_connac_tx_complete_skb
      wifi: mt76: mt7996: avoid mcu_restart function pointer
      wifi: mt76: remove __mt76_mcu_restart macro
      wifi: mt76: mt7915: add mt7915 wed reset callbacks
      wifi: mt76: mt7915: complete wed reset support
      wifi: mt76: mt76x0u: report firmware version through ethtool
      wifi: mac80211: move color collision detection report in a delayed work
      wifi: cfg80211: get rid of gfp in cfg80211_bss_color_notify
      wifi: cfg80211: remove gfp parameter from cfg80211_obss_color_collision_notify description

Lukas Wunner (3):
      wifi: mwifiex: Add missing compatible string for SD8787
      wifi: mwifiex: Support SD8978 chipset
      wifi: mwifiex: Support firmware hotfix version in GET_HW_SPEC responses

Marc Bornand (1):
      wifi: cfg80211: Set SSID if it is not already set

Martin Blumenstingl (4):
      wifi: rtw88: pci: Use enum type for rtw_hw_queue_mapping() and ac_to_hwq
      wifi: rtw88: pci: Change queue datatype to enum rtw_tx_queue_type
      wifi: rtw88: Move enum rtw_tx_queue_type mapping code to tx.{c,h}
      wifi: rtw88: mac: Use existing macros in rtw_pwr_seq_parser()

MeiChia Chiu (2):
      wifi: mt76: mt7915: remove BW160 and BW80+80 support
      wifi: mt76: mt7996: add EHT beamforming support

Miaoqian Lin (1):
      wifi: ath11k: Fix memory leak in ath11k_peer_rx_frag_setup

Minsuk Kang (2):
      wifi: ath9k: Fix use-after-free in ath9k_hif_usb_disconnect()
      wifi: ath9k: Fix potential stack-out-of-bounds write in ath9k_wmi_rsp_callback()

Mordechay Goodstein (3):
      wifi: iwlwifi: rx: add sniffer support for EHT mode
      wifi: iwlwifi: mvm: add sniffer meta data APIs
      wifi: iwlwifi: mvm: simplify by using SKB MAC header pointer

Mukesh Sisodiya (1):
      wifi: iwlwifi: mvm: Reset rate index if rate is wrong

Nagarajan Maran (1):
      wifi: ath11k: fix monitor mode bringup crash

Neil Chen (1):
      wifi: mt76: mt7921: fix rx filter incorrect by drv/fw inconsistent

Peter Chiu (2):
      wifi: mt76: mt7915: set sku initial value to zero
      wifi: mt76: mt7915: wed: enable red per-band token drop

Peter Lafreniere (1):
      wifi: rsi: Avoid defines prefixed with CONFIG

Ping-Ke Shih (7):
      wifi: rtw89: add use of pkt_list offload to debug entry
      wifi: rtw89: 8852b: reset IDMEM mode to default value
      wifi: rtw89: 8852b: don't support LPS-PG mode after firmware 0.29.26.0
      wifi: rtw89: 8852b: try to use NORMAL_CE type firmware first
      wifi: rtw89: 8852b: correct register mask name of TX power offset
      wifi: rtl8xxxu: fix txdw7 assignment of TX DESC v3
      wifi: rtw89: use readable return 0 in rtw89_mac_cfg_ppdu_status()

Raj Kumar Bhagat (1):
      wifi: ath11k: fix ce memory mapping for ahb devices

Rameshkumar Sundaram (2):
      wifi: cfg80211: Allow action frames to be transmitted with link BSS in MLD
      wifi: mac80211: Allow NSS change only up to capability

Ryder Lee (1):
      wifi: mt76: mt7915: fix WED TxS reporting

Sascha Hauer (3):
      wifi: rtw88: usb: Set qsel correctly
      wifi: rtw88: usb: send Zero length packets if necessary
      wifi: rtw88: usb: drop now unnecessary URB size check

Shayne Chen (18):
      wifi: mt76: mt7915: add chip id condition in mt7915_check_eeprom()
      wifi: mt76: mt7996: fix chainmask calculation in mt7996_set_antenna()
      wifi: mt76: mt7996: update register for CFEND_RATE
      wifi: mt76: mt7996: do not hardcode vht beamform cap
      wifi: mt76: connac: fix POWER_CTRL command name typo
      wifi: mt76: add EHT phy type
      wifi: mt76: connac: add CMD_CBW_320MHZ
      wifi: mt76: connac: add helpers for EHT capability
      wifi: mt76: connac: add cmd id related to EHT support
      wifi: mt76: increase wcid size to 1088
      wifi: mt76: add EHT rate stats for ethtool
      wifi: mt76: mt7996: add variants support
      wifi: mt76: mt7996: add helpers for wtbl and interface limit
      wifi: mt76: mt7996: rework capability init
      wifi: mt76: mt7996: add EHT capability init
      wifi: mt76: mt7996: add support for EHT rate report
      wifi: mt76: mt7996: enable EHT support in firmware
      wifi: mac80211: make rate u32 in sta_set_rate_info_rx()

Sowmiya Sree Elavalagan (1):
      wifi: ath11k: Add support to configure FTM responder role

Sriram R (8):
      dt: bindings: net: ath11k: add IPQ5018 compatible
      wifi: ath11k: update hw params for IPQ5018
      wifi: ath11k: update ce configurations for IPQ5018
      wifi: ath11k: remap ce register space for IPQ5018
      wifi: ath11k: update hal srng regs for IPQ5018
      wifi: ath11k: initialize hw_ops for IPQ5018
      wifi: ath11k: add new hw ops for IPQ5018 to get rx dest ring hashmap
      wifi: ath11k: add ipq5018 device support

Sujuan Chen (3):
      wifi: mt76: mt7915: release rxwi in mt7915_wed_release_rx_buf
      wifi: mt76: dma: add reset to mt76_dma_wed_setup signature
      wifi: mt76: dma: reset wed queues in mt76_dma_rx_reset

Thiraviyam Mariyappan (4):
      wifi: ath12k: Fix uninitilized variable clang warnings
      wifi: ath12k: hal_rx: Use memset_startat() for clearing queue descriptors
      wifi: ath12k: dp_mon: Fix out of bounds clang warning
      wifi: ath12k: dp_mon: Fix uninitialized warning related to the pktlog

Tom Rix (2):
      wifi: iwlwifi: mvm: remove h from printk format specifier
      wifi: zd1211rw: remove redundant decls

Veerendranath Jakkam (3):
      wifi: cfg80211: Authentication offload to user space for MLO connection in STA mode
      wifi: cfg80211: Extend cfg80211_new_sta() for MLD AP
      wifi: cfg80211: Extend cfg80211_update_owe_info_event() for MLD AP

Vinay Gannevaram (1):
      wifi: nl80211: Allow authentication frames and set keys on NAN interface

Wen Gong (2):
      wifi: ath11k: add channel 177 into 5 GHz channel list
      wifi: cfg80211: call reg_notifier for self managed wiphy from driver hint

Wenli Looi (1):
      wifi: ath9k: remove most hidden macro dependencies on ah

Zong-Zhe Yang (9):
      wifi: rtw89: correct unit for port offset and refine macro
      wifi: rtw89: split out generic part of rtw89_mac_port_tsf_sync()
      wifi: rtw89: mac: add function to get TSF
      wifi: rtw89: debug: avoid invalid access on RTW89_DBG_SEL_MAC_30
      wifi: rtw89: deal with RXI300 error
      wifi: rtw89: fix parsing offset for MCC C2H
      wifi: rtw89: refine MCC C2H debug logs
      wifi: rtw89: use passed channel in set_tx_shape_dfir()
      wifi: rtw89: phy: set TX power according to RF path number by chip

 .../bindings/net/wireless/esp,esp8089.yaml         |   18 +-
 .../bindings/net/wireless/ieee80211.yaml           |    1 -
 .../bindings/net/wireless/marvell-8xxx.txt         |    4 +-
 .../bindings/net/wireless/mediatek,mt76.yaml       |    1 -
 .../bindings/net/wireless/qcom,ath11k.yaml         |   12 +-
 .../bindings/net/wireless/silabs,wfx.yaml          |    1 -
 .../bindings/net/wireless/ti,wlcore.yaml           |   62 +-
 MAINTAINERS                                        |    7 +
 drivers/net/wireless/ath/Kconfig                   |    1 +
 drivers/net/wireless/ath/Makefile                  |    1 +
 drivers/net/wireless/ath/ath10k/ce.c               |    8 -
 drivers/net/wireless/ath/ath11k/ahb.c              |   47 +-
 drivers/net/wireless/ath/ath11k/ce.h               |   16 +
 drivers/net/wireless/ath/ath11k/core.c             |   93 +
 drivers/net/wireless/ath/ath11k/core.h             |   18 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |   48 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   24 +-
 drivers/net/wireless/ath/ath11k/hal.c              |   17 +-
 drivers/net/wireless/ath/ath11k/hal.h              |    5 +
 drivers/net/wireless/ath/ath11k/hw.c               |  371 ++
 drivers/net/wireless/ath/ath11k/hw.h               |   12 +
 drivers/net/wireless/ath/ath11k/mac.c              |  102 +-
 drivers/net/wireless/ath/ath11k/pci.c              |    2 +
 drivers/net/wireless/ath/ath11k/wmi.h              |    1 +
 drivers/net/wireless/ath/ath12k/Kconfig            |   34 +
 drivers/net/wireless/ath/ath12k/Makefile           |   27 +
 drivers/net/wireless/ath/ath12k/ce.c               |  964 +++
 drivers/net/wireless/ath/ath12k/ce.h               |  184 +
 drivers/net/wireless/ath/ath12k/core.c             |  939 +++
 drivers/net/wireless/ath/ath12k/core.h             |  822 +++
 drivers/net/wireless/ath/ath12k/dbring.c           |  357 +
 drivers/net/wireless/ath/ath12k/dbring.h           |   80 +
 drivers/net/wireless/ath/ath12k/debug.c            |  102 +
 drivers/net/wireless/ath/ath12k/debug.h            |   67 +
 drivers/net/wireless/ath/ath12k/dp.c               | 1580 +++++
 drivers/net/wireless/ath/ath12k/dp.h               | 1816 +++++
 drivers/net/wireless/ath/ath12k/dp_mon.c           | 2596 ++++++++
 drivers/net/wireless/ath/ath12k/dp_mon.h           |  106 +
 drivers/net/wireless/ath/ath12k/dp_rx.c            | 4234 ++++++++++++
 drivers/net/wireless/ath/ath12k/dp_rx.h            |  145 +
 drivers/net/wireless/ath/ath12k/dp_tx.c            | 1211 ++++
 drivers/net/wireless/ath/ath12k/dp_tx.h            |   41 +
 drivers/net/wireless/ath/ath12k/hal.c              | 2222 ++++++
 drivers/net/wireless/ath/ath12k/hal.h              | 1142 ++++
 drivers/net/wireless/ath/ath12k/hal_desc.h         | 2961 ++++++++
 drivers/net/wireless/ath/ath12k/hal_rx.c           |  850 +++
 drivers/net/wireless/ath/ath12k/hal_rx.h           |  704 ++
 drivers/net/wireless/ath/ath12k/hal_tx.c           |  145 +
 drivers/net/wireless/ath/ath12k/hal_tx.h           |  194 +
 drivers/net/wireless/ath/ath12k/hif.h              |  144 +
 drivers/net/wireless/ath/ath12k/htc.c              |  789 +++
 drivers/net/wireless/ath/ath12k/htc.h              |  316 +
 drivers/net/wireless/ath/ath12k/hw.c               | 1041 +++
 drivers/net/wireless/ath/ath12k/hw.h               |  312 +
 drivers/net/wireless/ath/ath12k/mac.c              | 7038 ++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/mac.h              |   76 +
 drivers/net/wireless/ath/ath12k/mhi.c              |  616 ++
 drivers/net/wireless/ath/ath12k/mhi.h              |   46 +
 drivers/net/wireless/ath/ath12k/pci.c              | 1374 ++++
 drivers/net/wireless/ath/ath12k/pci.h              |  135 +
 drivers/net/wireless/ath/ath12k/peer.c             |  342 +
 drivers/net/wireless/ath/ath12k/peer.h             |   67 +
 drivers/net/wireless/ath/ath12k/qmi.c              | 3087 +++++++++
 drivers/net/wireless/ath/ath12k/qmi.h              |  569 ++
 drivers/net/wireless/ath/ath12k/reg.c              |  732 ++
 drivers/net/wireless/ath/ath12k/reg.h              |   95 +
 drivers/net/wireless/ath/ath12k/rx_desc.h          | 1441 ++++
 drivers/net/wireless/ath/ath12k/trace.c            |   10 +
 drivers/net/wireless/ath/ath12k/trace.h            |  152 +
 drivers/net/wireless/ath/ath12k/wmi.c              | 6600 ++++++++++++++++++
 drivers/net/wireless/ath/ath12k/wmi.h              | 4803 +++++++++++++
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    2 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |   10 +-
 drivers/net/wireless/ath/ath9k/ar9002_calib.c      |   30 +-
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |   10 +-
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |   14 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |    4 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |   74 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   64 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |   12 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |    4 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |   12 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.c        |    6 +-
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c      |   56 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   26 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |   82 +-
 drivers/net/wireless/ath/ath9k/ar9003_wow.c        |   18 +-
 drivers/net/wireless/ath/ath9k/btcoex.c            |   14 +-
 drivers/net/wireless/ath/ath9k/calib.c             |   32 +-
 drivers/net/wireless/ath/ath9k/eeprom.h            |   12 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c        |   10 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   37 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    6 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    4 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  128 +-
 drivers/net/wireless/ath/ath9k/mac.c               |   42 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    4 +-
 drivers/net/wireless/ath/ath9k/reg.h               |  148 +-
 drivers/net/wireless/ath/ath9k/rng.c               |    6 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c              |    2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    7 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |    6 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |    4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   33 +-
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |    8 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |   18 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |   12 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |    2 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |    1 +
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |    2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |  145 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |   59 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h       |   19 +-
 .../wireless/intel/iwlwifi/iwl-context-info-gen3.h |   21 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |    4 +
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |    6 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |    7 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |    1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   80 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |    7 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |    5 +
 drivers/net/wireless/mac80211_hwsim.c              |    6 +-
 drivers/net/wireless/marvell/libertas/cfg.c        |   76 +-
 drivers/net/wireless/marvell/libertas/types.h      |   21 +-
 drivers/net/wireless/marvell/mwifiex/11h.c         |    2 +-
 drivers/net/wireless/marvell/mwifiex/11n.c         |    6 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |    2 +-
 drivers/net/wireless/marvell/mwifiex/Kconfig       |    5 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |    5 +
 drivers/net/wireless/marvell/mwifiex/fw.h          |   23 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   26 +-
 drivers/net/wireless/marvell/mwifiex/sdio.h        |    1 +
 drivers/net/wireless/mediatek/mt76/Kconfig         |    1 +
 drivers/net/wireless/mediatek/mt76/dma.c           |  120 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |    1 +
 drivers/net/wireless/mediatek/mt76/eeprom.c        |    1 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   68 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   55 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |    3 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_mcu.c   |    1 -
 .../net/wireless/mediatek/mt76/mt7615/usb_mcu.c    |    1 -
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |    5 +
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |    7 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   46 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   16 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb_mcu.c    |    1 +
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |   45 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   70 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   12 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   39 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  120 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |    1 +
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   96 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |    7 +
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c    |    2 +
 .../net/wireless/mediatek/mt76/mt7921/acpi_sar.c   |    7 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   11 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   15 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  116 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  106 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |    9 +
 .../net/wireless/mediatek/mt76/mt7921/pci_mcu.c    |    9 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |    8 +
 .../net/wireless/mediatek/mt76/mt7921/testmode.c   |    1 -
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |    4 +-
 .../net/wireless/mediatek/mt76/mt7996/debugfs.c    |    8 +-
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c |   27 +
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |  406 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |  149 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.h    |   24 -
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |   17 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  234 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |   16 +
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |   26 +-
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h   |   15 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |    4 +
 drivers/net/wireless/mediatek/mt76/usb.c           |   42 +-
 drivers/net/wireless/mediatek/mt76/util.c          |   10 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c     |    3 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |    8 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188e.c |   25 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |   24 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c |   25 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   40 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |    6 +
 drivers/net/wireless/realtek/rtw88/mac.c           |    4 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |   50 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |   41 +
 drivers/net/wireless/realtek/rtw88/tx.h            |    3 +
 drivers/net/wireless/realtek/rtw88/usb.c           |   18 +-
 drivers/net/wireless/realtek/rtw89/coex.c          |  212 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   33 +-
 drivers/net/wireless/realtek/rtw89/core.h          |    6 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |   43 +
 drivers/net/wireless/realtek/rtw89/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw89/fw.c            |   84 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |   40 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |   88 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |   19 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |    1 +
 drivers/net/wireless/realtek/rtw89/pci.c           |    2 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |    9 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |    3 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |    7 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |    5 +-
 drivers/net/wireless/realtek/rtw89/ser.c           |    1 +
 drivers/net/wireless/realtek/rtw89/wow.c           |   26 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |    4 +-
 drivers/net/wireless/rsi/rsi_hal.h                 |    2 +-
 drivers/net/wireless/ti/wl1251/init.c              |    2 +-
 drivers/net/wireless/zydas/zd1211rw/zd_rf.h        |    3 -
 include/linux/ieee80211.h                          |    1 +
 include/linux/mmc/sdio_ids.h                       |    1 +
 include/net/cfg80211.h                             |  132 +-
 include/net/mac80211.h                             |    8 +-
 include/uapi/linux/nl80211.h                       |   32 +
 net/mac80211/cfg.c                                 |   50 +-
 net/mac80211/chan.c                                |    2 +-
 net/mac80211/debugfs_netdev.c                      |    3 -
 net/mac80211/ieee80211_i.h                         |    6 +-
 net/mac80211/link.c                                |    3 +
 net/mac80211/mlme.c                                |  167 +-
 net/mac80211/rx.c                                  |  401 +-
 net/mac80211/sta_info.c                            |    5 +-
 net/mac80211/sta_info.h                            |    3 +
 net/mac80211/tx.c                                  |    2 +-
 net/mac80211/vht.c                                 |   25 +-
 net/rfkill/core.c                                  |   16 +-
 net/wireless/ap.c                                  |    2 +-
 net/wireless/chan.c                                |   69 +
 net/wireless/mlme.c                                |    5 +-
 net/wireless/nl80211.c                             |  156 +-
 net/wireless/nl80211.h                             |    2 +-
 net/wireless/reg.c                                 |    3 +
 net/wireless/sme.c                                 |   48 +-
 net/wireless/trace.h                               |  309 +-
 net/wireless/util.c                                |  183 +-
 246 files changed, 58095 insertions(+), 2067 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath12k/Kconfig
 create mode 100644 drivers/net/wireless/ath/ath12k/Makefile
 create mode 100644 drivers/net/wireless/ath/ath12k/ce.c
 create mode 100644 drivers/net/wireless/ath/ath12k/ce.h
 create mode 100644 drivers/net/wireless/ath/ath12k/core.c
 create mode 100644 drivers/net/wireless/ath/ath12k/core.h
 create mode 100644 drivers/net/wireless/ath/ath12k/dbring.c
 create mode 100644 drivers/net/wireless/ath/ath12k/dbring.h
 create mode 100644 drivers/net/wireless/ath/ath12k/debug.c
 create mode 100644 drivers/net/wireless/ath/ath12k/debug.h
 create mode 100644 drivers/net/wireless/ath/ath12k/dp.c
 create mode 100644 drivers/net/wireless/ath/ath12k/dp.h
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_mon.c
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_mon.h
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_rx.c
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_rx.h
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_tx.c
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_tx.h
 create mode 100644 drivers/net/wireless/ath/ath12k/hal.c
 create mode 100644 drivers/net/wireless/ath/ath12k/hal.h
 create mode 100644 drivers/net/wireless/ath/ath12k/hal_desc.h
 create mode 100644 drivers/net/wireless/ath/ath12k/hal_rx.c
 create mode 100644 drivers/net/wireless/ath/ath12k/hal_rx.h
 create mode 100644 drivers/net/wireless/ath/ath12k/hal_tx.c
 create mode 100644 drivers/net/wireless/ath/ath12k/hal_tx.h
 create mode 100644 drivers/net/wireless/ath/ath12k/hif.h
 create mode 100644 drivers/net/wireless/ath/ath12k/htc.c
 create mode 100644 drivers/net/wireless/ath/ath12k/htc.h
 create mode 100644 drivers/net/wireless/ath/ath12k/hw.c
 create mode 100644 drivers/net/wireless/ath/ath12k/hw.h
 create mode 100644 drivers/net/wireless/ath/ath12k/mac.c
 create mode 100644 drivers/net/wireless/ath/ath12k/mac.h
 create mode 100644 drivers/net/wireless/ath/ath12k/mhi.c
 create mode 100644 drivers/net/wireless/ath/ath12k/mhi.h
 create mode 100644 drivers/net/wireless/ath/ath12k/pci.c
 create mode 100644 drivers/net/wireless/ath/ath12k/pci.h
 create mode 100644 drivers/net/wireless/ath/ath12k/peer.c
 create mode 100644 drivers/net/wireless/ath/ath12k/peer.h
 create mode 100644 drivers/net/wireless/ath/ath12k/qmi.c
 create mode 100644 drivers/net/wireless/ath/ath12k/qmi.h
 create mode 100644 drivers/net/wireless/ath/ath12k/reg.c
 create mode 100644 drivers/net/wireless/ath/ath12k/reg.h
 create mode 100644 drivers/net/wireless/ath/ath12k/rx_desc.h
 create mode 100644 drivers/net/wireless/ath/ath12k/trace.c
 create mode 100644 drivers/net/wireless/ath/ath12k/trace.h
 create mode 100644 drivers/net/wireless/ath/ath12k/wmi.c
 create mode 100644 drivers/net/wireless/ath/ath12k/wmi.h

