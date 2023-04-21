Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDFD6EA890
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 12:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjDUKrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 06:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDUKrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 06:47:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506E26E92;
        Fri, 21 Apr 2023 03:47:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D125960B6F;
        Fri, 21 Apr 2023 10:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800BCC433D2;
        Fri, 21 Apr 2023 10:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682074047;
        bh=1IdxVsfiU2P3wvyH26uA5oNthQwth4FqRj3IitWCtMQ=;
        h=From:Subject:To:Cc:Date:From;
        b=O3l3O6+FA0IN9+bsCeXtSg0fUj4Puyr9ExNpTdfkWHfdlNihVmn+EKP56tnXLCfZd
         tuLK8cxrti1QJo2fDdQxUNc9FKUHq1jThs0BigjP4h7dKiUGRJpJbWkDWtFAwsBlas
         DZx//spalc+PeI3tlnr421xFszPYl+1q/p5jvJE8d23V5AfgBPZ6buzWsEXr0AmVig
         iEVMoA1knaEI3dFO3wPOJlWZQWwXmd9kp2SA7PhI/fpP1VWyfmb9A9U7fuM/WhyvX/
         OfsNMMEbvIydTA+K2U1TuozARLJbAU0wgtYUoxcHGf+McEJQdum6HzFpaUFwzqTAqp
         fK2RumGUQ9YVQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-next-2023-04-21
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20230421104726.800BCC433D2@smtp.kernel.org>
Date:   Fri, 21 Apr 2023 10:47:26 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit b536f32b5b034f592df0f0ba129ad59fa0f3e532:

  net: stmmac: dwmac-imx: use platform specific reset for imx93 SoCs (2023-04-05 19:01:22 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2023-04-21

for you to fetch changes up to 3288ee5844b74cebb94ed15bc9b5b9d3223ae038:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2023-04-20 19:43:45 +0300)

----------------------------------------------------------------
wireless-next patches for v6.4

Most likely the last -next pull request for v6.4. We have changes all
over. rtw88 now supports SDIO bus and iwlwifi continues to work on
Wi-Fi 7 support. Not much stack changes this time.

Major changes:

cfg80211/mac80211

* fix some Fine Time Measurement (FTM) frames not being bufferable

* flush frames before key removal to avoid potential unencrypted
  transmission depending on the hardware design

iwlwifi

* preparation for Wi-Fi 7 EHT and multi-link support

rtw88

* SDIO bus support

* RTL8822BS, RTL8822CS and RTL8821CS SDIO chipset support

rtw89

* framework firmware backwards compatibility

brcmfmac

* Cypress 43439 SDIO support

mt76

* mt7921 P2P support

* mt7996 mesh A-MSDU support

* mt7996 EHT support

* mt7996 coredump support

wcn36xx

* support for pronto v3 hardware

ath11k

* PCIe DeviceTree bindings

* WCN6750: enable SAR support

ath10k

* convert DeviceTree bindings to YAML

----------------------------------------------------------------
Aaradhana Sahu (1):
      wifi: ath12k: fix packets are sent in native wifi mode while we set raw mode

Aditya Kumar Singh (2):
      wifi: ath11k: fix deinitialization of firmware resources
      wifi: ath12k: fix firmware assert during channel switch for peer sta

Aloka Dixit (1):
      wifi: mac80211: set EHT support flag in AP mode

Alon Giladi (2):
      wifi: iwlwifi: acpi: support modules with high antenna gain
      wifi: iwlwifi: fw: fix argument to efi.get_variable

Arnd Bergmann (1):
      wifi: airo: remove ISA_DMA_API dependency

Avraham Stern (10):
      wifi: iwlwifi: mvm: use OFDM rate if IEEE80211_TX_CTL_NO_CCK_RATE is set
      wifi: iwlwifi: trans: don't trigger d3 interrupt twice
      wifi: iwlwifi: mvm: don't set CHECKSUM_COMPLETE for unsupported protocols
      wifi: iwlwifi: mvm: fix shift-out-of-bounds
      wifi: iwlwifi: mvm: make HLTK configuration for PASN station optional
      wifi: iwlwifi: mvm: avoid iterating over an un-initialized list
      wifi: iwlwifi: modify scan request and results when in link protection
      wifi: iwlwifi: mei: make mei filtered scan more aggressive
      wifi: iwlwifi: mei: re-ask for ownership after it was taken by CSME
      wifi: iwlwifi: mvm: fix RFKILL report when driver is going down

Ayala Beker (2):
      wifi: iwlwifi: mvm: don't drop unencrypted MCAST frames
      wifi: iwlwifi: mvm: scan legacy bands and UHB channels with same antenna

Baochen Qiang (2):
      wifi: ath12k: Identify DFS channel when sending scan channel list command
      wifi: ath12k: Enable IMPS for WCN7850

Bastian Germann (1):
      wifi: ath9k: Remove Qwest/Actiontec 802AIN ID

Bhagavathi Perumal S (1):
      wifi: ath11k: Fix invalid management rx frame length issue

Bitterblue Smith (5):
      wifi: rtl8xxxu: Clean up some messy ifs
      wifi: rtl8xxxu: Support devices with 5-6 out endpoints
      wifi: rtl8xxxu: Don't print the vendor/product/serial
      wifi: rtl8xxxu: Add rtl8xxxu_write{8,16,32}_{set,clear}
      wifi: rtl8xxxu: Simplify setting the initial gain

Bo Jiao (1):
      wifi: mt76: mt7996: enable full system reset support

Cai Huoqing (3):
      wifi: ath11k: Remove redundant pci_clear_master
      wifi: ath10k: Remove redundant pci_clear_master
      wifi: ath12k: Remove redundant pci_clear_master

Chih-Kang Chang (2):
      wifi: rtw89: fix power save function in WoWLAN mode
      wifi: rtw89: prohibit enter IPS during HW scan

Chin-Yen Lee (1):
      wifi: rtw89: support WoWLAN mode for 8852be

Ching-Te Ku (3):
      wifi: rtw89: coex: Enable Wi-Fi RX gain control for free run solution
      wifi: rtw89: coex: Add path control register to monitor list
      wifi: rtw89: coex: Update function to get BT RSSI and hardware counter

Colin Ian King (2):
      wifi: iwlwifi: Fix spelling mistake "upto" -> "up to"
      wifi: iwlwifi: mvm: Fix spelling mistake "Gerenal" -> "General"

Dan Carpenter (1):
      wifi: mt76: mt7915: unlock on error in mt7915_thermal_temp_store()

Daniel Gabay (4):
      wifi: iwlwifi: nvm: Update HE capabilities on 6GHz band for EHT device
      wifi: iwlwifi: pcie: fix possible NULL pointer dereference
      wifi: iwlwifi: yoyo: skip dump correctly on hw error
      wifi: iwlwifi: yoyo: Fix possible division by zero

Deren Wu (3):
      wifi: mt76: remove redundent MCU_UNI_CMD_* definitions
      wifi: mt76: mt7921: fix wrong command to set STA channel
      wifi: mt76: mt7921: fix PCI DMA hang after reboot

Emmanuel Grumbach (2):
      wifi: iwlwifi: make the loop for card preparation effective
      wifi: iwlwifi: mvm: adopt the latest firmware API

Eric Dumazet (1):
      wifi: mac80211_hwsim: fix potential NULL deref in hwsim_pmsr_report_nl()

Eric Huang (2):
      wifi: rtw89: use hardware CFO to improve performance
      wifi: rtw89: correct 5 MHz mask setting

Felix Fietkau (5):
      wifi: mt76: add missing locking to protect against concurrent rx/status calls
      wifi: mac80211: remove ieee80211_tx_status_8023
      wifi: mt76: mt7615: increase eeprom size for mt7663
      wifi: mt76: dma: use napi_build_skb
      wifi: mt76: set NL80211_EXT_FEATURE_CAN_REPLACE_PTK0 on supported drivers

Frank Wunderlich (1):
      dt-bindings: mt76: add active-low property for led

Ganesh Babu Jothiram (1):
      wifi: ath11k: Configure the FTM responder role using firmware capability flag

Golan Ben Ami (2):
      wifi: iwlwifi: mvm: enable bz hw checksum from c step
      wifi: iwlwifi: move debug buffer allocation failure to info verbosity

Gregory Greenman (7):
      wifi: iwlwifi: mvm: fix the order of TIMING_MEASUREMENT notifications
      wifi: iwlwifi: fix duplicate entry in iwl_dev_info_table
      wifi: iwlwifi: call napi_synchronize() before freeing rx/tx queues
      wifi: iwlwifi: bump FW API to 77 for AX devices
      wifi: iwlwifi: mvm: update mac id management
      wifi: iwlwifi: bump FW API to 78 for AX devices
      wifi: iwlwifi: mvm: enable support for MLO APIs

Gustavo A. R. Silva (5):
      wifi: ath11k: Replace fake flex-array with flexible-array member
      wifi: carl9170: Fix multiple -Warray-bounds warnings
      wifi: carl9170: Replace fake flex-array with flexible-array member
      wifi: mt76: Replace zero-length array with flexible-array member
      wifi: mt76: mt7921: Replace fake flex-arrays with flexible-array members

Haim Dreyfuss (1):
      wifi: iwlwifi: mvm: support wowlan info notification version 2

Hans de Goede (1):
      wifi: iwlwifi: dvm: Fix memcpy: detected field-spanning write backtrace

Harshit Mogalapalli (1):
      wifi: ath12k: Add missing unwind goto in ath12k_pci_probe()

Harshitha Prem (8):
      wifi: ath11k: fix BUFFER_DONE read on monitor ring rx  buffer
      wifi: ath12k: fix incorrect handling of AMSDU frames
      wifi: ath12k: incorrect channel survey dump
      wifi: ath11k: Ignore frags from uninitialized peer in dp.
      wifi: ath11k: fix undefined behavior with __fls in dp
      wifi: ath11k: fix double free of peer rx_tid during reo cmd failure
      wifi: ath11k: Prevent REO cmd failures
      wifi: ath11k: add peer mac information in failure cases

Howard Hsu (1):
      wifi: mt76: mt7915: rework init flow in mt7915_thermal_init()

Hyunwoo Kim (1):
      wifi: iwlwifi: pcie: Fix integer overflow in iwl_write_to_user_buf

Ilan Peer (2):
      wifi: iwlwifi: mvm: Fix setting the rate for non station cases
      wifi: iwlwifi: mvm: Fix _iwl_mvm_get_scan_type()

Jernej Skrabec (1):
      wifi: rtw88: Add support for the SDIO based RTL8822BS chipset

Jiefeng Li (1):
      wifi: mt76: mt7921: fix missing unwind goto in `mt7921u_probe`

Johan Hovold (1):
      dt-bindings: net: wireless: add ath11k pcie bindings

Johannes Berg (43):
      wifi: iwlwifi: debug: fix crash in __iwl_err()
      wifi: iwlwifi: nvm-parse: enable 160/320 MHz for AP mode
      wifi: iwlwifi: mvm: convert TID to FW value on queue remove
      wifi: iwlwifi: mvm: fix A-MSDU checks
      wifi: iwlwifi: mvm: refactor TX csum mode check
      wifi: ieee80211: clean up public action codes
      wifi: ieee80211: correctly mark FTM frames non-bufferable
      wifi: mac80211: flush queues on STA removal
      wifi: mac80211: add flush_sta method
      wifi: iwlwifi: mvm: request limiting to 8 MSDUs per A-MSDU
      wifi: iwlwifi: mvm: add DSM_FUNC_ENABLE_6E value to debugfs
      wifi: iwlwifi: pcie: work around ROM bug on AX210 integrated
      wifi: iwlwifi: mvm: track AP STA pointer and use it for MFP
      wifi: iwlwifi: mvm: make iwl_mvm_mac_ctxt_send_beacon() static
      wifi: iwlwifi: mvm: fix ptk_pn memory leak
      wifi: iwlwifi: mvm: set STA mask for keys in MLO
      wifi: iwlwifi: mvm: validate station properly in flush
      wifi: iwlwifi: mvm: tx: remove misleading if statement
      wifi: iwlwifi: nvm-parse: add full BW UL MU-MIMO support
      wifi: iwlwifi: mvm: fix getting lowest TX rate for MLO
      wifi: iwlwifi: mvm: properly implement HE AP support
      wifi: iwlwifi: mvm: factor out iwl_mvm_sta_fw_id_mask()
      wifi: iwlwifi: mvm: use correct sta mask to remove queue
      wifi: iwlwifi: mvm: track station mask for BAIDs
      wifi: iwlwifi: mvm: implement BAID link switching
      wifi: iwlwifi: mvm: implement key link switching
      wifi: iwlwifi: mvm: allow number of beacons from FW
      wifi: iwlwifi: mvm: use BSSID when building probe requests
      wifi: iwlwifi: mvm: allow NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT
      wifi: iwlwifi: mvm: remove per-STA MFP setting
      wifi: iwlwifi: mvm: fix iwl_mvm_sta_rc_update for MLO
      wifi: iwlwifi: mvm: only clients can be 20MHz-only
      wifi: iwlwifi: mvm: rs-fw: properly access sband->iftype_data
      wifi: iwlwifi: mvm: initialize per-link STA ratescale data
      wifi: iwlwifi: mvm: remove RS rate init update argument
      wifi: iwlwifi: fix iwl_mvm_max_amsdu_size() for MLO
      wifi: iwlwifi: mvm: configure TLC on link activation
      wifi: iwlwifi: mvm: add MLO support to SF - use sta pointer
      wifi: iwlwifi: mvm: check firmware response size
      wifi: iwlwifi: fw: fix memory leak in debugfs
      wifi: iwlwifi: mvm: fix MIC removal confusion
      wifi: iwlwifi: mvm: fix potential memory leak
      wifi: iwlwifi: mvm: prefer RCU_INIT_POINTER()

Jonas Jelonek (1):
      wifi: ath9k: fix per-packet TX-power cap for TPC

Kalle Valo (3):
      wifi: ath11k: print a warning when crypto_alloc_shash() fails
      Merge tag 'mt76-for-kvalo-2023-04-18' of https://github.com/nbd168/wireless
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Kang Chen (1):
      wifi: mt76: handle failure of vzalloc in mt7615_coredump_work

Konrad Dybcio (1):
      dt-bindings: net: Convert ath10k to YAML

Larry Finger (1):
      wifi: rtw88: Fix memory leak in rtw88_usb

Lorenz Brun (1):
      wifi: mt76: mt7915: expose device tree match table

Lorenzo Bianconi (8):
      wifi: mt76: mt7921: introduce mt7921_get_mac80211_ops utility routine
      wifi: mt76: move irq_tasklet in mt76_dev struct
      wifi: mt76: add mt76_connac_irq_enable utility routine
      wifi: mt76: get rid of unused sta_ps callbacks
      wifi: mt76: add mt76_connac_gen_ppe_thresh utility routine
      wifi: mt76: mt7921: get rid of eeprom.h
      wifi: mt76: move shared mac definitions in mt76_connac2_mac.h
      wifi: mt76: move mcu_uni_event and mcu_reg_event in common code

Manikanta Pubbisetty (2):
      wifi: ath11k: Optimize 6 GHz scan time
      wifi: ath11k: Send 11d scan start before WMI_START_SCAN_CMDID

Marek Vasut (1):
      wifi: brcmfmac: add Cypress 43439 SDIO ids

Mario Limonciello (1):
      wifi: mt76: mt7921e: Set memory space enable in PCI_COMMAND if unset

Martin Blumenstingl (8):
      wifi: rtw88: Clear RTW_FLAG_POWERON early in rtw_mac_power_switch()
      wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets
      wifi: rtw88: mac: Support SDIO specific bits in the power on sequence
      wifi: rtw88: main: Add the {cpwm,rpwm}_addr for SDIO based chipsets
      wifi: rtw88: main: Reserve 8 bytes of extra TX headroom for SDIO cards
      mmc: sdio: add Realtek SDIO vendor ID and various wifi device IDs
      wifi: rtw88: Add support for the SDIO based RTL8822CS chipset
      wifi: rtw88: Add support for the SDIO based RTL8821CS chipset

Ming Yen Hsieh (1):
      wifi: mt76: fix 6GHz high channel not be scanned

Miri Korenblit (3):
      wifi: iwlwifi: add a validity check of queue_id in iwl_txq_reclaim
      wifi: iwlwifi: mvm: cleanup beacon_inject_active during hw restart
      wifi: iwlwifi: mvm: enable new MLD FW API

Mukesh Sisodiya (9):
      wifi: iwlwifi: Update configuration for SO,SOF MAC and HR RF
      wifi: iwlwifi: mvm: move function sequence
      wifi: iwlwifi: Update init sequence if tx diversity supported
      wifi: iwlwifi: Update configurations for Bnj-a0 and specific rf devices
      wifi: iwlwifi: dbg: print pc register data once fw dump occurred
      wifi: iwlwifi: Fix the duplicate dump name
      wifi: iwlwifi: Add RF Step Type for BZ device
      wifi: iwlwifi: add a new PCI device ID for BZ device
      wifi: iwlwifi: Update support for b0 version

Muna Sinada (1):
      wifi: ath11k: Remove disabling of 80+80 and 160 MHz

Nagarajan Maran (1):
      wifi: ath11k: Fix SKB corruption in REO destination ring

Neil Chen (1):
      wifi: mt76: mt7921: use driver flags rather than mac80211 flags to mcu

P Praneesh (3):
      wifi: ath12k: fill peer meta data during reo_reinject
      wifi: ath11k: fix rssi station dump not updated in QCN9074
      wifi: ath11k: fix writing to unintended memory region

Peter Chiu (4):
      wifi: mt76: drop the incorrect scatter and gather frame
      wifi: mt76: mt7996: fix pointer calculation in ie countdown event
      wifi: mt76: mt7996: init mpdu density cap
      wifi: mt76: mt7996: remove mt7996_mcu_set_pm()

Ping-Ke Shih (13):
      wifi: rtw89: use schedule_work to request firmware
      wifi: rtw89: add firmware format version to backward compatible with older drivers
      wifi: rtw89: read version of analog hardware
      wifi: rtw89: 8851b: fix TX path to path A for one RF path chip
      wifi: rtw89: mac: update MAC settings to support 8851b
      wifi: rtw89: pci: update PCI related settings to support 8851B
      wifi: rtw89: 8851b: add BB and RF tables (1 of 2)
      wifi: rtw89: 8851b: add BB and RF tables (2 of 2)
      wifi: rtw89: 8851b: add tables for RFK
      wifi: rtw89: fix crash due to null pointer of sta in AP mode
      wifi: rtw89: coex: send more hardware module info to firmware for 8851B
      wifi: rtw89: use struct instead of macros to set H2C command of hardware scan
      wifi: rtw89: mac: use regular int as return type of DLE buffer request

Po-Hao Huang (17):
      wifi: rtw89: 8852c: add beacon filter and CQM support
      wifi: rtw89: add function to wait for completion of TX skbs
      wifi: rtw89: add ieee80211::remain_on_channel ops
      wifi: rtw89: add flag check for power state
      wifi: rtw89: fix authentication fail during scan
      wifi: rtw89: refine scan function after chanctx
      wifi: rtw89: update statistics to FW for fine-tuning performance
      wifi: rtw89: Disallow power save with multiple stations
      wifi: rtw89: add support of concurrent mode
      wifi: rtw88: add bitmap for dynamic port settings
      wifi: rtw88: add port switch for AP mode
      wifi: rtw88: 8822c: extend reserved page number
      wifi: rtw88: disallow PS during AP mode
      wifi: rtw88: refine reserved page flow for AP mode
      wifi: rtw88: prevent scan abort with other VIFs
      wifi: rtw88: handle station mode concurrent scan with AP mode
      wifi: rtw88: 8822c: add iface combination

Pradeep Kumar Chitrapu (2):
      wifi: ath11k: fix tx status reporting in encap offload mode
      wifi: ath11k: Fix incorrect update of radiotap fields

Quan Zhou (3):
      wifi: mt76: mt7921e: fix probe timeout after reboot
      wifi: mt76: mt7921e: improve reliability of dma reset
      wifi: mt76: mt7921e: stop chip reset worker in unregister hook

Rajat Soni (1):
      wifi: ath12k: fix memory leak in ath12k_qmi_driver_event_work()

Reese Russell (1):
      wifi: mt76: mt7921: add Netgear AXE3000 (A8000) support

Rob Herring (1):
      bcma: Add explicit of_device.h include

Ryder Lee (15):
      wifi: mt76: mt7996: fix radiotap bitfield
      wifi: mt76: dynamic channel bandwidth changes in AP mode
      wifi: mt76: connac: refresh tx session timer for WED device
      wifi: mt76: mt7915: remove mt7915_mcu_beacon_check_caps()
      wifi: mt76: mt7996: remove mt7996_mcu_beacon_check_caps()
      wifi: mt76: mt7915: drop redundant prefix of mt7915_txpower_puts()
      wifi: mt76: mt7996: add full system reset knobs into debugfs
      wifi: mt76: mt7996: enable coredump support
      wifi: mt76: connac: fix txd multicast rate setting
      wifi: mt76: connac: add nss calculation into mt76_connac2_mac_tx_rate_val()
      wifi: mt76: mt7996: enable BSS_CHANGED_BASIC_RATES support
      wifi: mt76: mt7996: enable BSS_CHANGED_MCAST_RATE support
      wifi: mt76: mt7996: enable configured beacon tx rate
      wifi: mt76: mt7996: enable mesh HW amsdu/de-amsdu support
      wifi: mt76: mt7996: fill txd by host driver

Sascha Hauer (4):
      wifi: rtw88: usb: fix priority queue to endpoint mapping
      wifi: rtw88: rtw8821c: Fix rfe_option field width
      wifi: rtw88: set pkg_type correctly for specific rtw8821c variants
      wifi: rtw88: call rtw8821c_switch_rf_set() according to chip variant

Sean Wang (2):
      wifi: mt76: mt7921: enable p2p support
      mt76: mt7921: fix kernel panic by accessing unallocated eeprom.data

Shayne Chen (3):
      wifi: mt76: mt7996: add eht rx rate support
      wifi: mt76: mt7996: let non-bufferable MMPDUs use correct hw queue
      wifi: mt76: mt7996: remove unused eeprom band selection

Simon Horman (1):
      wifi: rtw88: Update spelling in main.h

StanleyYP Wang (1):
      wifi: mt76: mt7996: fix eeprom tx path bitfields

Sujuan Chen (1):
      wifi: mt76: mt7915: add dev->hif2 support for mt7916 WED device

Takashi Iwai (1):
      wifi: ath11k: pci: Add more MODULE_FIRMWARE() entries

Tamizh Chelvam Raja (1):
      wifi: ath11k: Disable Spectral scan upon removing interface

Toke Høiland-Jørgensen (1):
      wifi: ath9k: Don't mark channelmap stack variable read-only in ath9k_mci_update_wlan_channels()

Tom Rix (3):
      wifi: ath10k: remove unused ath10k_get_ring_byte function
      wifi: iwlwifi: mvm: initialize seq variable
      wifi: iwlwifi: fw: move memset before early return

Vladimir Lypak (1):
      wifi: wcn36xx: add support for pronto-v3

Yang Li (1):
      wifi: mt76: mt7996: Remove unneeded semicolon

Yingsha Xu (1):
      wifi: mac80211: remove return value check of debugfs_create_dir()

Youghandhar Chintala (1):
      wifi: ath11k: enable SAR support on WCN6750

Zong-Zhe Yang (2):
      wifi: rtw89: fw: use generic flow to set/check features
      wifi: rtw89: support parameter tables by RFE type

 .../bindings/net/wireless/mediatek,mt76.yaml       |     5 +
 .../bindings/net/wireless/qcom,ath10k.txt          |   215 -
 .../bindings/net/wireless/qcom,ath10k.yaml         |   358 +
 .../bindings/net/wireless/qcom,ath11k-pci.yaml     |    58 +
 MAINTAINERS                                        |     2 +-
 drivers/bcma/main.c                                |     1 +
 drivers/net/wireless/ath/ath10k/ce.c               |     7 -
 drivers/net/wireless/ath/ath10k/pci.c              |     6 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |     6 +
 drivers/net/wireless/ath/ath11k/core.c             |    10 +-
 drivers/net/wireless/ath/ath11k/dbring.c           |    12 +-
 .../net/wireless/ath/ath11k/debugfs_htt_stats.h    |    73 +-
 drivers/net/wireless/ath/ath11k/dp.c               |     4 +-
 drivers/net/wireless/ath/ath11k/dp.h               |     6 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   140 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |    33 +-
 drivers/net/wireless/ath/ath11k/dp_tx.h            |     1 +
 drivers/net/wireless/ath/ath11k/hal_rx.c           |    14 +-
 drivers/net/wireless/ath/ath11k/hal_rx.h           |    20 +-
 drivers/net/wireless/ath/ath11k/hw.c               |    28 +-
 drivers/net/wireless/ath/ath11k/hw.h               |     3 +-
 drivers/net/wireless/ath/ath11k/mac.c              |    50 +-
 drivers/net/wireless/ath/ath11k/pci.c              |    14 +-
 drivers/net/wireless/ath/ath11k/peer.h             |     1 +
 drivers/net/wireless/ath/ath11k/wmi.c              |    48 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |     5 +
 drivers/net/wireless/ath/ath12k/core.h             |     1 +
 drivers/net/wireless/ath/ath12k/dp_rx.c            |    15 +-
 drivers/net/wireless/ath/ath12k/dp_tx.c            |     4 +
 drivers/net/wireless/ath/ath12k/hw.c               |     2 +-
 drivers/net/wireless/ath/ath12k/mac.c              |   117 +-
 drivers/net/wireless/ath/ath12k/pci.c              |     8 +-
 drivers/net/wireless/ath/ath12k/qmi.c              |     4 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |     6 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |     2 -
 drivers/net/wireless/ath/ath9k/mci.c               |     4 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |    30 +-
 drivers/net/wireless/ath/carl9170/cmd.c            |     2 +-
 drivers/net/wireless/ath/carl9170/fwcmd.h          |     4 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |    23 +-
 drivers/net/wireless/ath/wcn36xx/dxe.h             |     4 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |     1 +
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |     1 +
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |     9 +-
 drivers/net/wireless/cisco/Kconfig                 |     2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   104 +-
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c       |     5 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |    41 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |    37 +-
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    |    14 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |     3 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |    10 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |     4 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c       |    11 +
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |     4 +
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |     1 +
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |     1 +
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |     2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |     9 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |     4 +
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |     8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-debug.c     |     3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |    18 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.h  |     5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |    25 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |     7 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |    21 +-
 drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h   |     4 +-
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |    40 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |    36 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |    32 +
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |    25 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |    19 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   236 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |    69 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |    76 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c   |   114 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac.c   |    21 +-
 .../net/wireless/intel/iwlwifi/mvm/mld-mac80211.c  |    29 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c   |   139 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    76 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |    12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |    81 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |    13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |    21 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |     5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |    71 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   107 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c        |    29 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    35 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |     4 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |    77 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   422 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |     1 +
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |    18 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |    73 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |    15 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      |    10 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |    10 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |     1 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |    17 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |    19 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |     5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |     5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |     7 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |     1 +
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |    18 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |    12 -
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |    11 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |    11 -
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |    11 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |    11 +-
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |     2 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c   |     1 -
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |     1 -
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |    21 +
 .../net/wireless/mediatek/mt76/mt76_connac2_mac.h  |    22 +
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |    78 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |    21 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |    19 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |     5 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |    36 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |    10 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |    35 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |     6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |    33 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |     1 -
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   115 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |    17 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |    18 +-
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c    |     2 +
 .../net/wireless/mediatek/mt76/mt7921/acpi_sar.h   |    10 +-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |     1 -
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    |    50 +-
 drivers/net/wireless/mediatek/mt76/mt7921/eeprom.h |    30 -
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |    43 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |    18 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    |    53 -
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |    42 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |    31 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |    11 -
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |    23 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |    64 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   |    23 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mac.c   |     2 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mcu.c   |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |    27 +-
 .../net/wireless/mediatek/mt76/mt7921/usb_mac.c    |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/Kconfig  |     1 +
 drivers/net/wireless/mediatek/mt76/mt7996/Makefile |     2 +
 .../net/wireless/mediatek/mt76/mt7996/coredump.c   |   268 +
 .../net/wireless/mediatek/mt76/mt7996/coredump.h   |    97 +
 .../net/wireless/mediatek/mt76/mt7996/debugfs.c    |   149 +-
 drivers/net/wireless/mediatek/mt76/mt7996/dma.c    |    64 +
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c |     4 -
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.h |     9 +-
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |    72 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |   501 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.h    |    62 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |    78 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |   222 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |    30 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |    23 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |    76 +-
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h   |    51 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |     6 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |    19 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188e.c |     5 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c |     8 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c |     5 -
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |    54 -
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8710b.c |     9 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c |     4 -
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |     6 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   113 +-
 drivers/net/wireless/realtek/rtw88/Kconfig         |    36 +
 drivers/net/wireless/realtek/rtw88/Makefile        |    12 +
 drivers/net/wireless/realtek/rtw88/debug.h         |     1 +
 drivers/net/wireless/realtek/rtw88/fw.c            |    20 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |     2 +-
 drivers/net/wireless/realtek/rtw88/mac.c           |    55 +-
 drivers/net/wireless/realtek/rtw88/mac.h           |     1 -
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    40 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   157 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    23 +-
 drivers/net/wireless/realtek/rtw88/reg.h           |    12 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |     1 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |    26 +-
 drivers/net/wireless/realtek/rtw88/rtw8821cs.c     |    36 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |     1 +
 drivers/net/wireless/realtek/rtw88/rtw8822bs.c     |    36 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |     1 +
 drivers/net/wireless/realtek/rtw88/rtw8822cs.c     |    36 +
 drivers/net/wireless/realtek/rtw88/sdio.c          |  1394 ++
 drivers/net/wireless/realtek/rtw88/sdio.h          |   178 +
 drivers/net/wireless/realtek/rtw88/usb.c           |    71 +-
 drivers/net/wireless/realtek/rtw89/chan.c          |    35 +
 drivers/net/wireless/realtek/rtw89/chan.h          |     3 +
 drivers/net/wireless/realtek/rtw89/core.c          |   362 +-
 drivers/net/wireless/realtek/rtw89/core.h          |   155 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |    13 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |   456 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |   311 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |   144 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |     5 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |    92 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |    38 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |     4 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |    92 +-
 drivers/net/wireless/realtek/rtw89/ps.c            |    12 +-
 drivers/net/wireless/realtek/rtw89/ps.h            |    19 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |     3 +
 .../wireless/realtek/rtw89/rtw8851b_rfk_table.c    |   534 +
 .../wireless/realtek/rtw89/rtw8851b_rfk_table.h    |    38 +
 .../net/wireless/realtek/rtw89/rtw8851b_table.c    | 14824 +++++++++++++++++++
 .../net/wireless/realtek/rtw89/rtw8851b_table.h    |    21 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |    22 +-
 .../net/wireless/realtek/rtw89/rtw8852a_table.c    |    15 +
 .../net/wireless/realtek/rtw89/rtw8852a_table.h    |    11 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |    55 +-
 .../net/wireless/realtek/rtw89/rtw8852b_table.c    |    15 +
 .../net/wireless/realtek/rtw89/rtw8852b_table.h    |    11 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |    40 +-
 .../net/wireless/realtek/rtw89/rtw8852c_table.c    |    21 +
 .../net/wireless/realtek/rtw89/rtw8852c_table.h    |    16 +-
 drivers/net/wireless/realtek/rtw89/wow.c           |     2 +-
 drivers/net/wireless/virtual/mac80211_hwsim.c      |     3 +
 include/linux/ieee80211.h                          |    63 +-
 include/linux/mmc/sdio_ids.h                       |    14 +-
 include/net/mac80211.h                             |    26 +-
 net/mac80211/cfg.c                                 |     4 +
 net/mac80211/debugfs.c                             |     4 -
 net/mac80211/driver-ops.h                          |    15 +
 net/mac80211/sta_info.c                            |    12 +
 net/mac80211/status.c                              |    24 -
 net/mac80211/trace.h                               |     7 +
 net/mac80211/tx.c                                  |     4 +-
 240 files changed, 23374 insertions(+), 2874 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/eeprom.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/coredump.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/coredump.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8851b_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8851b_table.h
