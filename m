Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919D55188B6
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238617AbiECPkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238374AbiECPkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:40:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3990C2ED7B;
        Tue,  3 May 2022 08:36:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5DE4B81EC6;
        Tue,  3 May 2022 15:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1671C385A4;
        Tue,  3 May 2022 15:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651592183;
        bh=eGJmz7hs7pZ4vN/8mMAro/4Uvn3MpfDqAKs67gAKCSc=;
        h=From:Subject:To:Cc:Date:From;
        b=k+KkkPBxMs5EErB0wocKXJ8TzX9ogol8VNTrRkn0GYneUx/83qX9kHu/noV/1Uj2v
         3Hr9qF6i09vzRroRkmeg7XVXihSxdDyKcZuynX+zBHLGZTyzgQlvjcSRXU1AnpnrVk
         qEFWPNOT2cJbG23h9c7PjS9ZIWmmjJA5mR0dQfDiJJEwSVIrM25o6kwhMuL/gTAV7M
         mKLAnZkr9ucPbOrN/XpM+qseKXCFgyaEHdBvlpnwdl4uNb7ewFVVkNjAhMajUFDcav
         yRgrkkFt/fawic3CPu46caar7x5PNuShoPWeLSGQ1EZaTO/X8MssTr6+WATJ66uh7W
         y6kuE9W+h5aCA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-next-2022-05-03
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20220503153622.C1671C385A4@smtp.kernel.org>
Date:   Tue,  3 May 2022 15:36:22 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

The following changes since commit 0b5c21bbc01e92745ca1ca4f6fd87d878fa3ea5e:

  net: ensure net_todo_list is processed quickly (2022-04-05 14:28:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2022-05-03

for you to fetch changes up to f39af96d352dd4f36a4a43601ea90561e17e5ca6:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2022-05-03 08:38:03 +0300)

----------------------------------------------------------------
wireless-next patches for v5.19

First set of patches for v5.19 and this is a big one. We have two new
drivers, a change in mac80211 STA API affecting most drivers and
ath11k getting support for WCN6750. And as usual lots of fixes and
cleanups all over.

Major changes:

new drivers

* wfx: silicon labs devices

* plfxlc: pureLiFi X, XL, XC devices

mac80211

* host based BSS color collision detection

* prepare sta handling for IEEE 802.11be Multi-Link Operation (MLO) support

rtw88

* support TP-Link T2E devices

rtw89

* support firmware crash simulation

* preparation for 8852ce hardware support

ath11k

* Wake-on-WLAN support for QCA6390 and WCN6855

* device recovery (firmware restart) support for QCA6390 and WCN6855

* support setting Specific Absorption Rate (SAR) for WCN6855

* read country code from SMBIOS for WCN6855/QCA6390

* support for WCN6750

wcn36xx

* support for transmit rate reporting to user space

----------------------------------------------------------------
Abhishek Kumar (1):
      ath10k: skip ath10k_halt during suspend for driver state RESTARTING

Alexander Wetzel (1):
      rtl818x: Prevent using not initialized queues

Andrejs Cainikovs (2):
      mwifiex: Select firmware based on strapping
      mwifiex: Add SD8997 SDIO-UART firmware

Baochen Qiang (4):
      ath11k: enable PLATFORM_CAP_PCIE_GLOBAL_RESET QMI host capability
      ath11k: Remove unnecessary delay in ath11k_core_suspend
      ath11k: Add support for SAR
      ath11k: Don't use GFP_KERNEL in atomic context

Benjamin Stürz (1):
      wcn36xx: Improve readability of wcn36xx_caps_name

Carl Huang (6):
      ath11k: Add basic WoW functionalities
      ath11k: Add WoW net-detect functionality
      ath11k: implement hardware data filter
      ath11k: purge rx pktlog when entering WoW
      ath11k: support ARP and NS offload
      ath11k: support GTK rekey offload

Chia-Yuan Li (5):
      rtw89: pci: refine pci pre_init function
      rtw89: ser: configure D-MAC interrupt mask
      rtw89: ser: configure C-MAC interrupt mask
      rtw89: 8852c: disable firmware watchdog if CPU disabled
      rtw89: 8852c: add 8852c specific BT-coexistence initial function

Chih-Kang Chang (3):
      rtw88: add HT MPDU density value for each chip
      rtw88: fix not disabling beacon filter after disconnection
      rtw88: fix hw scan may cause disconnect issue

Ching-Te Ku (1):
      rtw89: coex: Add case for scan offload

Chris Chiu (2):
      rtl8xxxu: feed antenna information for cfg80211
      rtl8xxxu: fill up txrate info for gen1 chips

Christophe Leroy (1):
      orinoco: Prepare cleanup of powerpc's asm/prom.h

Colin Ian King (1):
      ath11k: Fix spelling mistake "reseting" -> "resetting"

Dan Carpenter (1):
      ath9k_htc: fix potential out of bounds access with invalid rxstatus->rs_keyix

Edmond Gagnon (1):
      wcn36xx: Implement tx_rate reporting

Erik Stromdahl (2):
      ath10k: add support for MSDU IDs for USB devices
      ath10k: enable napi on RX path for usb

Guo Zhengkui (1):
      rtlwifi: btcoex: fix if == else warning

Gustavo A. R. Silva (2):
      iwlwifi: fw: Replace zero-length arrays with flexible-array members
      iwlwifi: mei: Replace zero-length array with flexible-array member

Hamid Zamani (1):
      brcmfmac: use ISO3166 country code and 0 rev as fallback on brcmfmac43602 chips

Haowen Bai (3):
      b43legacy: Fix assigning negative value to unsigned variable
      b43: Fix assigning negative value to unsigned variable
      ipw2x00: Fix potential NULL dereference in libipw_xmit()

Hari Chandrakanthan (2):
      ath11k: change fw build id format in driver init log
      ath11k: disable spectral scan during spectral deinit

Jakob Koschel (1):
      rtlwifi: replace usage of found with dedicated list iterator variable

Jakub Kicinski (3):
      ath10k: remove a copy of the NAPI_POLL_WEIGHT define
      wil6210: use NAPI_POLL_WEIGHT for napi budget
      rtw88: remove a copy of the NAPI_POLL_WEIGHT define

Jiapeng Chong (1):
      plfxlc: Remove unused include <linux/version.h>

Jimmy Hon (2):
      rtw88: 8821ce: add support for device ID 0xb821
      rtw88: 8821ce: Disable PCIe ASPM L1 for 8821CE using chip ID

Joe Perches (1):
      rtw89: rtw89_ser: add const to struct state_ent and event_ent

Johannes Berg (1):
      nl80211: show SSID for P2P_GO interfaces

Johnson Lin (3):
      rtw89: packed IGI configuration flow into function for DIG feature
      rtw89: disabled IGI configuration for unsupported hardware
      rtw89: Skip useless dig gain and igi related settings for 8852C

Julia Lawall (1):
      ath6kl: fix typos in comments

Jérôme Pouiller (1):
      wfx: get out from the staging area

Kalle Valo (6):
      ath11k: mhi: remove state machine
      ath11k: mhi: add error handling for suspend and resume
      ath11k: mhi: remove unnecessary goto from ath11k_mhi_start()
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge branch 'wfx-move-out-of-staging'
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Karthikeyan Kathirvel (1):
      ath11k: Change max no of active probe SSID and BSSID to fw capability

Karthikeyan Periyasamy (2):
      ath11k: Refactor the peer delete
      ath11k: Add peer rhash table support

Kevin Lo (1):
      rtw88: use the correct bit in the REG_HCI_OPT_CTRL register

Lorenzo Bianconi (2):
      mac80211: protect ieee80211_assign_beacon with next_beacon check
      mac80211: introduce BSS color collision detection

Lv Ruyi (2):
      rtlwifi: Fix spelling mistake "cacluated" -> "calculated"
      rtlwifi: rtl8192cu: Fix spelling mistake "writting" -> "writing"

Manikanta Pubbisetty (17):
      ath11k: PCI changes to support WCN6750
      ath11k: Refactor PCI code to support WCN6750
      ath11k: Choose MSI config based on HW revision
      ath11k: Refactor MSI logic to support WCN6750
      ath11k: Remove core PCI references from PCI common code
      ath11k: Do not put HW in DBS mode for WCN6750
      ath11k: WMI changes to support WCN6750
      ath11k: Update WBM idle ring HP after FW mode on
      dt: bindings: net: add bindings of WCN6750 for ath11k
      ath11k: Move parameters in bus_params to hw_params
      ath11k: Add HW params for WCN6750
      ath11k: Add register access logic for WCN6750
      ath11k: Fetch device information via QMI for WCN6750
      ath11k: Add QMI changes for WCN6750
      ath11k: HAL changes to support WCN6750
      ath11k: Datapath changes to support WCN6750
      ath11k: Add support for WCN6750 device

Meng Tang (2):
      ath10k: Use of_device_get_match_data() helper
      ipw2x00: use DEVICE_ATTR_*() macro

Minghao Chi (12):
      ath9k: Use platform_get_irq() to get the interrupt
      wlcore: debugfs: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wlcore: main: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wlcore: sysfs: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wlcore: testmode: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wlcore: vendor_cmd: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wlcore: sdio: using pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wlcore: cmd: using pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wil6210: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wl18xx: debugfs: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wl12xx: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
      wl12xx: scan: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()

Nagarajan Maran (1):
      ath11k: fix driver initialization failure with WoW unsupported hw

Niels Dossche (2):
      ath11k: acquire ab->base_lock in unassign when finding the peer by addr
      mwifiex: add mutex lock for call in mwifiex_dfs_chan_sw_work_queue

Peter Seiderer (2):
      mac80211: minstrel_ht: fix where rate stats are stored (fixes debugfs output)
      ath9k: fix ath_get_rate_txpower() to respect the rate list end tag

Ping-Ke Shih (62):
      rtw89: reduce export symbol number of mac size and quota
      rtw89: add chip_info::h2c_desc_size/fill_txdesc_fwcmd to support new chips
      rtw89: pci: support variant of fill_txaddr_info
      rtw89: support variant of fill_txdesc
      rtw89: support hardware generate security header
      rtw89: read RX bandwidth from v1 type RX descriptor
      rtw89: handle potential uninitialized variable
      rtw89: pci: add register definition to rtw89_pci_info to generalize pci code
      rtw89: pci: add pci attributes to configure operating mode
      rtw89: pci: add LTR setting for v1 chip
      rtw89: pci: set address info registers depends on chips
      rtw89: pci: add deglitch setting
      rtw89: pci: add L1 settings
      rtw89: extend dmac_pre_init to support 8852C
      rtw89: update STA scheduler parameters for v1 chip
      rtw89: add chip_ops::{enable,disable}_bb_rf to support v1 chip
      rtw89: Turn on CR protection of CMAC
      rtw89: 8852c: update security engine setting
      rtw89: update scheduler setting
      rtw89: initialize NAV control
      rtw89: update TMAC parameters
      rtw89: update ptcl_init
      rtw89: ser: configure top ERR IMR for firmware to recover
      rtw89: change station scheduler setting for hardware TX mode
      rtw89: reset BA CAM
      rtw88: do PHY calibration while starting AP
      rtw89: extend H2C of CMAC control info
      rtw89: add new H2C to configure security CAM via DCTL for V1 chip
      rtw89: configure security CAM for V1 chip
      rtw89: pci: correct return value handling of rtw89_write16_mdio_mask()
      rtw89: 8852c: add BB and RF parameters tables
      rtw89: 8852c: add TX power by rate and limit tables
      rtw89: 8852c: phy: configure TSSI bandedge
      rtw89: 8852c: add BB initial and reset functions
      rtw89: 8852c: add efuse gain offset parser
      rtw89: 8852c: add HFC parameters
      rtw89: 8852c: add set channel function of RF part
      rtw89: 8852c: set channel of MAC part
      rtw89: 8852c: add set channel of BB part
      rtw89: 8852c: add help function of set channel
      rtw89: pci: add variant IMR/ISR and configure functions
      rtw89: pci: add variant RPWM/CPWM to enter low power mode
      rtw89: pci: reclaim TX BD only if it really need
      rtw89: pci: add a separate interrupt handler for low power mode
      rtw89: ser: re-enable interrupt in threadfn if under_recovery
      rtw89: ps: access TX/RX rings via another registers in low power mode
      rtw89: pci: allow to process RPP prior to TX BD
      rtw89: don't flush hci queues and send h2c if power is off
      rtw89: add RF H2C to notify firmware
      rtw89: 8852c: configure default BB TX/RX path
      rtw89: 8852c: implement chip_ops related to TX power
      rtw89: 8852c: implement chip_ops::get_thermal
      rtw89: 8852c: fill freq and band of RX status by PPDU report
      rtw89: 8852c: add chip_ops related to BTC
      rtw89: 8852c: rfk: add RFK tables
      rtw89: 8852c: rfk: add DACK
      rtw89: 8852c: rfk: add LCK
      rtw89: 8852c: rfk: add TSSI
      rtw89: 8852c: rfk: add RCK
      rtw89: 8852c: rfk: add RX DCK
      rtw89: 8852c: rfk: add IQK
      rtw89: 8852c: rfk: add DPK

Po Hao Huang (3):
      rtw89: change idle mode condition during hw_scan
      rtw89: packet offload handler to avoid warning
      rtw89: fix misconfiguration on hw_scan channel time

Po-Hao Huang (8):
      rtw88: change idle mode condition during hw_scan
      rtw88: add ieee80211:sta_rc_update ops
      rtw88: fix incorrect frequency reported
      rtw88: Add update beacon flow for AP mode
      rtw88: 8821c: Enable TX report for management frames
      rtw88: 8821c: fix debugfs rssi value
      rtw88: fix uninitialized 'tim_offset' warning
      rtw88: pci: 8821c: Disable 21ce completion timeout

Srinivasan Raju (2):
      wireless: add plfxlc driver for pureLiFi X, XL, XC devices
      plfxlc: fix le16_to_cpu warning for beacon_interval

Sriram R (1):
      mac80211: prepare sta handling for MLO support

Thibaut VARÈNE (1):
      ath9k: fix QCA9561 PA bias level

Toke Høiland-Jørgensen (1):
      mac80211: Improve confusing comment around tx_info clearing

Ulf Hansson (1):
      brcmfmac: Avoid keeping power to SDIO card unless WOWL is used

Wan Jiabing (3):
      ath10k: simplify if-if to if-else
      wil6210: simplify if-if to if-else
      ath9k: hif_usb: simplify if-if to if-else

Wen Gong (15):
      ath11k: remove unused ATH11K_BD_IE_BOARD_EXT
      ath11k: disable regdb support for QCA6390
      ath11k: add support for device recovery for QCA6390/WCN6855
      ath11k: add synchronization operation between reconfigure of mac80211 and ath11k_base
      ath11k: Add hw-restart option to simulate_fw_crash
      ath11k: fix the warning of dev_wake in mhi_pm_disable_transition()
      ath11k: add fallback board name without variant while searching board-2.bin
      ath11k: add read variant from SMBIOS for download board data
      ath11k: store and send country code to firmware after recovery
      ath11k: add support to search regdb data in board-2.bin for WCN6855
      ath11k: reduce the wait time of 11d scan and hw scan while add interface
      ath11k: add support for extended wmi service bit
      ath11k: read country code from SMBIOS for WCN6855/QCA6390
      ath11k: fix warning of not found station for bssid in message
      ath11k: change management tx queue to avoid connection timed out

Wenli Looi (7):
      ath9k: make ATH_SREV macros more consistent
      ath9k: split set11nRateFlags and set11nChainSel
      ath9k: use AR9300_MAX_CHAINS when appropriate
      ath9k: fix ar9003_get_eepmisc
      ath9k: refactor ar9003_hw_spur_mitigate_ofdm
      ath9k: add functions to get paprd rate mask
      ath9k: make is2ghz consistent in ar9003_eeprom

Xiaomeng Tong (1):
      carl9170: tx: fix an incorrect use of list iterator

Yang Li (3):
      wcn36xx: clean up some inconsistent indenting
      ath9k: Remove unnecessary print function dev_err()
      rtw89: remove unneeded semicolon

Yang Yingliang (1):
      ath11k: fix missing unlock on error in ath11k_wow_op_resume()

Youghandhar Chintala (1):
      ath10k: Trigger sta disconnect on hardware restart

YueHaibing (1):
      ath11k: Fix build warning without CONFIG_IPV6

Zong-Zhe Yang (15):
      rtw89: ser: fix CAM leaks occurring in L2 reset
      rtw89: mac: move table of mem base addr to common
      rtw89: mac: correct decision on error status by scenario
      rtw89: ser: control hci interrupts on/off by state
      rtw89: ser: dump memory for fw payload engine while L2 reset
      rtw89: ser: dump fw backtrace while L2 reset
      rtw89: reconstruct fw feature
      rtw89: support FW crash simulation
      rtw89: add UK to regulation type
      rtw89: 8852a: update txpwr tables to HALRF_027_00_038
      rtw89: regd: consider 6G band
      rtw89: regd: update mapping table to R59-R32
      rtw89: ser: fix unannotated fall-through
      rtw89: 8852c: add TX power track tables
      rtw89: 8852c: support bb gain info

 .../bindings/net/wireless/qcom,ath11k.yaml         |   361 +-
 .../{staging => }/net/wireless/silabs,wfx.yaml     |     2 +-
 MAINTAINERS                                        |    10 +-
 drivers/net/wireless/Kconfig                       |     2 +
 drivers/net/wireless/Makefile                      |     2 +
 drivers/net/wireless/ath/ar5523/ar5523.c           |     4 +-
 drivers/net/wireless/ath/ath10k/ahb.c              |     9 +-
 drivers/net/wireless/ath/ath10k/core.c             |    25 +
 drivers/net/wireless/ath/ath10k/core.h             |     3 -
 drivers/net/wireless/ath/ath10k/hw.h               |     2 +
 drivers/net/wireless/ath/ath10k/mac.c              |   101 +-
 drivers/net/wireless/ath/ath10k/pci.c              |     2 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |     2 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |     2 +-
 drivers/net/wireless/ath/ath10k/usb.c              |    27 +
 drivers/net/wireless/ath/ath11k/Makefile           |     3 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |   153 +-
 drivers/net/wireless/ath/ath11k/ce.c               |     4 +-
 drivers/net/wireless/ath/ath11k/core.c             |   572 +-
 drivers/net/wireless/ath/ath11k/core.h             |   168 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |     4 +
 drivers/net/wireless/ath/ath11k/hal.c              |    15 +-
 drivers/net/wireless/ath/ath11k/hal.h              |    15 +-
 drivers/net/wireless/ath/ath11k/htc.c              |     6 +
 drivers/net/wireless/ath/ath11k/hw.c               |   186 +
 drivers/net/wireless/ath/ath11k/hw.h               |    43 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   629 +-
 drivers/net/wireless/ath/ath11k/mac.h              |     3 +-
 drivers/net/wireless/ath/ath11k/mhi.c              |   285 +-
 drivers/net/wireless/ath/ath11k/mhi.h              |    17 +-
 drivers/net/wireless/ath/ath11k/pci.c              |   984 +-
 drivers/net/wireless/ath/ath11k/pci.h              |    28 +-
 drivers/net/wireless/ath/ath11k/pcic.c             |   748 +
 drivers/net/wireless/ath/ath11k/pcic.h             |    46 +
 drivers/net/wireless/ath/ath11k/peer.c             |   373 +-
 drivers/net/wireless/ath/ath11k/peer.h             |    10 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   262 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |    26 +-
 drivers/net/wireless/ath/ath11k/reg.c              |    44 +-
 drivers/net/wireless/ath/ath11k/reg.h              |     2 +-
 drivers/net/wireless/ath/ath11k/spectral.c         |    17 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   810 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |   402 +-
 drivers/net/wireless/ath/ath11k/wow.c              |   763 +
 drivers/net/wireless/ath/ath11k/wow.h              |    45 +
 drivers/net/wireless/ath/ath6kl/htc_mbox.c         |     2 +-
 drivers/net/wireless/ath/ath9k/ahb.c               |    10 +-
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |     9 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |     2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |    85 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |     2 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |     9 +-
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c      |    10 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |    25 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |     2 +-
 drivers/net/wireless/ath/ath9k/debug_sta.c         |     4 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |     5 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |    20 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |     8 +
 drivers/net/wireless/ath/ath9k/mac.h               |     6 +-
 drivers/net/wireless/ath/ath9k/main.c              |     2 +-
 drivers/net/wireless/ath/ath9k/reg.h               |    10 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |     8 +-
 drivers/net/wireless/ath/carl9170/main.c           |     8 +-
 drivers/net/wireless/ath/carl9170/tx.c             |     8 +-
 drivers/net/wireless/ath/wcn36xx/hal.h             |     7 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   160 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |    98 +-
 drivers/net/wireless/ath/wcn36xx/smd.h             |     2 +
 drivers/net/wireless/ath/wcn36xx/txrx.c            |    29 +
 drivers/net/wireless/ath/wcn36xx/txrx.h            |     1 +
 drivers/net/wireless/ath/wil6210/cfg80211.c        |     5 +-
 drivers/net/wireless/ath/wil6210/netdev.c          |     8 +-
 drivers/net/wireless/ath/wil6210/pm.c              |     5 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |     1 -
 drivers/net/wireless/broadcom/b43/phy_n.c          |     2 +-
 drivers/net/wireless/broadcom/b43legacy/phy.c      |     2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |    39 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |     1 +
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |     2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |    64 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |   119 +-
 drivers/net/wireless/intel/ipw2x00/libipw_tx.c     |     2 +-
 drivers/net/wireless/intel/iwlegacy/3945-rs.c      |     6 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |    22 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |     6 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |    22 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c      |     2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c       |     4 +-
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |     4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |     4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/filter.h |     2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |     4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h    |     2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h   |     2 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |     2 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |    10 +-
 drivers/net/wireless/intel/iwlwifi/mei/sap.h       |     2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |     2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |    38 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |    38 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |    35 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c        |     8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    31 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |     6 +-
 drivers/net/wireless/intersil/orinoco/airport.c    |     1 +
 drivers/net/wireless/mac80211_hwsim.c              |     4 +-
 drivers/net/wireless/marvell/mwifiex/11h.c         |     2 +
 drivers/net/wireless/marvell/mwifiex/sdio.c        |    23 +-
 drivers/net/wireless/marvell/mwifiex/sdio.h        |     6 +
 drivers/net/wireless/marvell/mwl8k.c               |    48 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |    16 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |    83 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |     4 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |     4 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   140 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |     2 +-
 drivers/net/wireless/mediatek/mt7601u/mac.c        |     2 +-
 drivers/net/wireless/mediatek/mt7601u/tx.c         |     4 +-
 drivers/net/wireless/purelifi/Kconfig              |    17 +
 drivers/net/wireless/purelifi/Makefile             |     2 +
 drivers/net/wireless/purelifi/plfxlc/Kconfig       |    14 +
 drivers/net/wireless/purelifi/plfxlc/Makefile      |     3 +
 drivers/net/wireless/purelifi/plfxlc/chip.c        |    98 +
 drivers/net/wireless/purelifi/plfxlc/chip.h        |    70 +
 drivers/net/wireless/purelifi/plfxlc/firmware.c    |   276 +
 drivers/net/wireless/purelifi/plfxlc/intf.h        |    52 +
 drivers/net/wireless/purelifi/plfxlc/mac.c         |   754 +
 drivers/net/wireless/purelifi/plfxlc/mac.h         |   184 +
 drivers/net/wireless/purelifi/plfxlc/usb.c         |   891 +
 drivers/net/wireless/purelifi/plfxlc/usb.h         |   198 +
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |     8 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c   |     2 +-
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |     8 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   146 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |    44 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    |    16 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |    40 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |    15 +-
 drivers/net/wireless/realtek/rtlwifi/rc.c          |    20 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |    26 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |     8 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    |    26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |     6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |    30 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   |     2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |    26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |     4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |    12 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |     8 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |    26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/trx.c   |     2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |    26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |     8 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |    12 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |     8 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |    30 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   |     6 +-
 drivers/net/wireless/realtek/rtw88/bf.c            |     2 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |    29 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |     4 +-
 drivers/net/wireless/realtek/rtw88/mac.c           |     2 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    44 +-
 drivers/net/wireless/realtek/rtw88/main.c          |    73 +-
 drivers/net/wireless/realtek/rtw88/main.h          |     8 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |    19 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |     2 +-
 drivers/net/wireless/realtek/rtw88/reg.h           |     2 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |     1 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |     5 +
 .../net/wireless/realtek/rtw88/rtw8821c_table.c    |     2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821ce.c     |     4 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |     1 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |     1 +
 drivers/net/wireless/realtek/rtw88/rx.c            |     3 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |    31 +-
 drivers/net/wireless/realtek/rtw88/tx.h            |     4 +
 drivers/net/wireless/realtek/rtw89/cam.c           |    57 +-
 drivers/net/wireless/realtek/rtw89/cam.h           |     4 +
 drivers/net/wireless/realtek/rtw89/coex.c          |    24 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   182 +-
 drivers/net/wireless/realtek/rtw89/core.h          |   281 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |    70 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |   299 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |   388 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |   713 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |    81 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |     4 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   957 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |   389 +
 drivers/net/wireless/realtek/rtw89/phy.c           |   451 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |    73 +-
 drivers/net/wireless/realtek/rtw89/ps.c            |    34 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |  1887 +-
 drivers/net/wireless/realtek/rtw89/regd.c          |   513 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |    81 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c  |    16 +-
 .../net/wireless/realtek/rtw89/rtw8852a_table.c    |   605 +-
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c     |    40 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |  2310 ++-
 drivers/net/wireless/realtek/rtw89/rtw8852c.h      |    20 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c  |  4023 ++++
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.h  |    27 +
 .../wireless/realtek/rtw89/rtw8852c_rfk_table.c    |   781 +
 .../wireless/realtek/rtw89/rtw8852c_rfk_table.h    |    67 +
 .../net/wireless/realtek/rtw89/rtw8852c_table.c    | 19470 +++++++++++++++++++
 .../net/wireless/realtek/rtw89/rtw8852c_table.h    |    36 +
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c     |    48 +
 drivers/net/wireless/realtek/rtw89/ser.c           |   250 +-
 drivers/net/wireless/realtek/rtw89/txrx.h          |   107 +
 drivers/net/wireless/realtek/rtw89/util.h          |    30 +
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |    12 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |     8 +-
 drivers/net/wireless/silabs/Kconfig                |    18 +
 drivers/net/wireless/silabs/Makefile               |     3 +
 .../{staging => net/wireless/silabs}/wfx/Kconfig   |     0
 .../{staging => net/wireless/silabs}/wfx/Makefile  |     0
 drivers/{staging => net/wireless/silabs}/wfx/bh.c  |     0
 drivers/{staging => net/wireless/silabs}/wfx/bh.h  |     0
 drivers/{staging => net/wireless/silabs}/wfx/bus.h |     0
 .../wireless/silabs}/wfx/bus_sdio.c                |     0
 .../{staging => net/wireless/silabs}/wfx/bus_spi.c |     0
 .../{staging => net/wireless/silabs}/wfx/data_rx.c |     0
 .../{staging => net/wireless/silabs}/wfx/data_rx.h |     0
 .../{staging => net/wireless/silabs}/wfx/data_tx.c |     0
 .../{staging => net/wireless/silabs}/wfx/data_tx.h |     0
 .../{staging => net/wireless/silabs}/wfx/debug.c   |     0
 .../{staging => net/wireless/silabs}/wfx/debug.h   |     0
 .../{staging => net/wireless/silabs}/wfx/fwio.c    |     0
 .../{staging => net/wireless/silabs}/wfx/fwio.h    |     0
 .../wireless/silabs}/wfx/hif_api_cmd.h             |     0
 .../wireless/silabs}/wfx/hif_api_general.h         |     0
 .../wireless/silabs}/wfx/hif_api_mib.h             |     0
 .../{staging => net/wireless/silabs}/wfx/hif_rx.c  |     0
 .../{staging => net/wireless/silabs}/wfx/hif_rx.h  |     0
 .../{staging => net/wireless/silabs}/wfx/hif_tx.c  |     0
 .../{staging => net/wireless/silabs}/wfx/hif_tx.h  |     0
 .../wireless/silabs}/wfx/hif_tx_mib.c              |     0
 .../wireless/silabs}/wfx/hif_tx_mib.h              |     0
 .../{staging => net/wireless/silabs}/wfx/hwio.c    |     0
 .../{staging => net/wireless/silabs}/wfx/hwio.h    |     0
 drivers/{staging => net/wireless/silabs}/wfx/key.c |     0
 drivers/{staging => net/wireless/silabs}/wfx/key.h |     0
 .../{staging => net/wireless/silabs}/wfx/main.c    |     0
 .../{staging => net/wireless/silabs}/wfx/main.h    |     0
 .../{staging => net/wireless/silabs}/wfx/queue.c   |     0
 .../{staging => net/wireless/silabs}/wfx/queue.h   |     0
 .../{staging => net/wireless/silabs}/wfx/scan.c    |     0
 .../{staging => net/wireless/silabs}/wfx/scan.h    |     0
 drivers/{staging => net/wireless/silabs}/wfx/sta.c |     8 +-
 drivers/{staging => net/wireless/silabs}/wfx/sta.h |     0
 .../{staging => net/wireless/silabs}/wfx/traces.h  |     0
 drivers/{staging => net/wireless/silabs}/wfx/wfx.h |     0
 drivers/net/wireless/st/cw1200/sta.c               |     4 +-
 drivers/net/wireless/ti/wl18xx/debugfs.c           |    18 +-
 drivers/net/wireless/ti/wlcore/cmd.c               |    14 +-
 drivers/net/wireless/ti/wlcore/debugfs.c           |    52 +-
 drivers/net/wireless/ti/wlcore/main.c              |   241 +-
 drivers/net/wireless/ti/wlcore/scan.c              |     6 +-
 drivers/net/wireless/ti/wlcore/sdio.c              |     3 +-
 drivers/net/wireless/ti/wlcore/sysfs.c             |     6 +-
 drivers/net/wireless/ti/wlcore/testmode.c          |    12 +-
 drivers/net/wireless/ti/wlcore/tx.c                |     6 +-
 drivers/net/wireless/ti/wlcore/vendor_cmd.c        |    18 +-
 drivers/staging/Kconfig                            |     1 -
 drivers/staging/Makefile                           |     1 -
 drivers/staging/wfx/TODO                           |     6 -
 include/net/mac80211.h                             |    90 +-
 net/mac80211/agg-rx.c                              |    12 +-
 net/mac80211/agg-tx.c                              |     6 +-
 net/mac80211/airtime.c                             |     4 +-
 net/mac80211/cfg.c                                 |    33 +-
 net/mac80211/chan.c                                |     8 +-
 net/mac80211/debugfs.c                             |     1 +
 net/mac80211/debugfs_sta.c                         |    12 +-
 net/mac80211/eht.c                                 |     6 +-
 net/mac80211/ethtool.c                             |     4 +-
 net/mac80211/he.c                                  |     8 +-
 net/mac80211/ht.c                                  |     8 +-
 net/mac80211/ibss.c                                |    26 +-
 net/mac80211/key.c                                 |     9 +-
 net/mac80211/mesh_hwmp.c                           |     2 +-
 net/mac80211/mesh_plink.c                          |    24 +-
 net/mac80211/mlme.c                                |    18 +-
 net/mac80211/ocb.c                                 |     2 +-
 net/mac80211/rate.c                                |     8 +-
 net/mac80211/rc80211_minstrel_ht.c                 |    23 +-
 net/mac80211/rx.c                                  |   131 +-
 net/mac80211/s1g.c                                 |     4 +-
 net/mac80211/sta_info.c                            |   110 +-
 net/mac80211/sta_info.h                            |   155 +-
 net/mac80211/status.c                              |    41 +-
 net/mac80211/tdls.c                                |    26 +-
 net/mac80211/trace.h                               |     4 +-
 net/mac80211/tx.c                                  |    26 +-
 net/mac80211/vht.c                                 |    78 +-
 net/wireless/nl80211.c                             |     1 +
 298 files changed, 43484 insertions(+), 4104 deletions(-)
 rename Documentation/devicetree/bindings/{staging => }/net/wireless/silabs,wfx.yaml (98%)
 create mode 100644 drivers/net/wireless/ath/ath11k/pcic.c
 create mode 100644 drivers/net/wireless/ath/ath11k/pcic.h
 create mode 100644 drivers/net/wireless/purelifi/Kconfig
 create mode 100644 drivers/net/wireless/purelifi/Makefile
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/Kconfig
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/Makefile
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/chip.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/chip.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/firmware.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/intf.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/mac.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/mac.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/usb.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/usb.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852c_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852c_table.h
 create mode 100644 drivers/net/wireless/silabs/Kconfig
 create mode 100644 drivers/net/wireless/silabs/Makefile
 rename drivers/{staging => net/wireless/silabs}/wfx/Kconfig (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/Makefile (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/bh.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/bh.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/bus.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/bus_sdio.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/bus_spi.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/data_rx.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/data_rx.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/data_tx.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/data_tx.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/debug.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/debug.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/fwio.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/fwio.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_api_cmd.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_api_general.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_api_mib.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_rx.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_rx.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_tx.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_tx.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_tx_mib.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hif_tx_mib.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hwio.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/hwio.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/key.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/key.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/main.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/main.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/queue.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/queue.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/scan.c (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/scan.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/sta.c (99%)
 rename drivers/{staging => net/wireless/silabs}/wfx/sta.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/traces.h (100%)
 rename drivers/{staging => net/wireless/silabs}/wfx/wfx.h (100%)
 delete mode 100644 drivers/staging/wfx/TODO
