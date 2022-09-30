Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29AE5F0E68
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 17:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiI3PEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 11:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiI3PEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 11:04:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AB11C404;
        Fri, 30 Sep 2022 08:04:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA68AB82785;
        Fri, 30 Sep 2022 15:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7984C433D6;
        Fri, 30 Sep 2022 15:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664550254;
        bh=4LfjCcfuGpWKigGKgQGzQWP8hdzrd5IN1Gl89HboE+U=;
        h=From:Subject:To:Cc:Date:From;
        b=SwDpvxZiiLfuAjwnS50wfVpzfcqFlDO/DcqEnJAmPecp6xmAsAaWi8sc/MhaPGmjt
         qxeXYElNz+QGcCZWsSXBP8N3YxLnzZUlCvZb68/K/XG/HXhcqBALqREQiZF8Ud47yo
         K2pVJYyT0cxlAxKYozXgD4m1+YDb54pGysV1Nf0WF9O9J9ecpkDmWR2GV1Yy8+wEx3
         CO5ShlpvskiBZZOj0Kk6XSv0Kcy26UUHpyVmflEYZXXiz2T+fMyzhme97ivsuXC/by
         0BeVU7XMOGHtyfM9xXPjCBWOwawxioLncshtnev97ORu0gHbhVkb3kyhEgDmw9qz1f
         bMq0AWZ0k+3eA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-next-2022-09-30
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20220930150413.A7984C433D6@smtp.kernel.org>
Date:   Fri, 30 Sep 2022 15:04:13 +0000 (UTC)
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

The following changes since commit 9837ec955b46b62d1dd2d00311461a950c50a791:

  Merge tag 'wireless-next-2022-09-03' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next (2022-09-04 11:24:34 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2022-09-30

for you to fetch changes up to 2fc6de5c6924aea5e84d2edaa40ed744f0720844:

  wifi: rtl8xxxu: Improve rtl8xxxu_queue_select (2022-09-29 09:18:42 +0300)

----------------------------------------------------------------
wireless-next patches for v6.1

Few stack changes and lots of driver changes in this round. brcmfmac
has more activity as usual and it gets new hardware support. ath11k
improves WCN6750 support and also other smaller features. And of
course changes all over.

Note: in early September wireless tree was merged to wireless-next to
avoid some conflicts with mac80211 patches, this shouldn't cause any
problems but wanted to mention anyway.

Major changes:

mac80211

* refactoring and preparation for Wi-Fi 7 Multi-Link Operation (MLO)
  feature continues

brcmfmac

* support CYW43439 SDIO chipset

* support BCM4378 on Apple platforms

* support CYW89459 PCIe chipset

rtw89

* more work to get rtw8852c supported

* P2P support

* support for enabling and disabling MSDU aggregation via nl80211

mt76

* tx status reporting improvements

ath11k

* cold boot calibration support on WCN6750

* Target Wake Time (TWT) debugfs support for STA interface

* support to connect to a non-transmit MBSSID AP profile

* enable remain-on-channel support on WCN6750

* implement SRAM dump debugfs interface

* enable threaded NAPI on all hardware

* WoW support for WCN6750

* support to provide transmit power from firmware via nl80211

* support to get power save duration for each client

* spectral scan support for 160 MHz

wcn36xx

* add SNR from a received frame as a source of system entropy

----------------------------------------------------------------
Aditya Kumar Singh (2):
      wifi: ath11k: move firmware stats out of debugfs
      wifi: ath11k: add get_txpower mac ops

Alexander Coffin (1):
      wifi: brcmfmac: fix use-after-free bug in brcmf_netdev_start_xmit()

Alexander Prutskov (1):
      brcmfmac: Support 89459 pcie

Baochen Qiang (5):
      wifi: ath11k: Split PCI write/read functions
      wifi: ath11k: implement SRAM dump debugfs interface
      wifi: ath11k: Include STA_KEEPALIVE_ARP_RESPONSE TLV header by default
      wifi: ath11k: Remove redundant ath11k_mac_drain_tx
      wifi: ath11k: Fix deadlock during WoWLAN suspend

Benjamin Berg (3):
      wifi: mac80211: use correct rx link_sta instead of default
      wifi: mac80211: make smps_mode per-link
      wifi: mac80211: keep A-MSDU data in sta and per-link

Bitterblue Smith (6):
      wifi: rtl8xxxu: Fix skb misuse in TX queue selection
      wifi: rtl8xxxu: gen2: Fix mistake in path B IQ calibration
      wifi: rtl8xxxu: Remove copy-paste leftover in gen2_update_rate_mask
      wifi: rtl8xxxu: gen2: Enable 40 MHz channel width
      wifi: rtl8xxxu: Fix AIFS written to REG_EDCA_*_PARAM
      wifi: rtl8xxxu: Improve rtl8xxxu_queue_select

Bryan O'Donoghue (1):
      wifi: wcn36xx: Add RX frame SNR as a source of system entropy

Chia-Yuan Li (1):
      wifi: rtw89: set response rate selection

Chin-Yen Lee (4):
      wifi: rtw89: support deep ps mode for rtw8852c
      wifi: rtw89: call tx_wake notify for 8852c in deep ps mode
      wifi: rtw89: correct enable functions of HCI/PCI DMA
      wifi: rtw89: pci: concentrate control function of TX DMA channel

Ching-Te Ku (15):
      wifi: rtw89: coex: Add v1 Wi-Fi firmware power-saving null data report
      wifi: rtw89: coex: Move coexistence firmware buffer size parameter to chip info
      wifi: rtw89: coex: Parsing Wi-Fi firmware error message from reports
      wifi: rtw89: coex: Parsing Wi-Fi firmware TDMA info from reports
      wifi: rtw89: coex: Remove trace_step at COEX-MECH control structure for RTL8852C
      wifi: rtw89: coex: Combine set grant WL/BT and correct the debug log
      wifi: rtw89: coex: add v1 cycle report to parsing Bluetooth A2DP status
      wifi: rtw89: coex: translate slot ID to readable name
      wifi: rtw89: coex: add v1 summary info to parse the traffic status from firmware
      wifi: rtw89: coex: add v1 Wi-Fi firmware steps report
      wifi: rtw89: coex: add WL_S0 hardware TX/RX mask to allow WL_S0 TX/RX during GNT_BT
      wifi: rtw89: coex: modify LNA2 setting to avoid BT destroyed Wi-Fi aggregation
      wifi: rtw89: coex: summarize Wi-Fi to BT scoreboard and inform BT one time a cycle
      wifi: rtw89: coex: add logic to control BT scan priority
      wifi: rtw89: coex: update coexistence to 6.3.0

Christian Marangi (1):
      wifi: ath11k: fix peer addition/deletion error on sta band migration

Dan Carpenter (4):
      wifi: mt76: mt7915: fix an uninitialized variable bug
      wifi: mt76: mt7921: fix use after free in mt7921_acpi_read()
      wifi: mt76: mt7921: delete stray if statement
      wifi: rtw89: uninitialized variable on error in rtw89_early_fw_feature_recognize()

Daniel Golle (9):
      wifi: rt2x00: add support for external PA on MT7620
      wifi: rt2x00: move up and reuse busy wait functions
      wifi: rt2x00: don't run Rt5592 IQ calibration on MT7620
      wifi: rt2x00: move helper functions up in file
      wifi: rt2x00: fix HT20/HT40 bandwidth switch on MT7620
      wifi: rt2x00: set correct TX_SW_CFG1 MAC register for MT7620
      wifi: rt2x00: set VGC gain for both chains of MT7620
      wifi: rt2x00: set SoC wmac clock register
      wifi: rt2x00: correctly set BBP register 86 for MT7620

David Bauer (1):
      wifi: rt2x00: add throughput LED trigger

Deren Wu (4):
      wifi: mt76: mt7921e: fix rmmod crash in driver reload test
      wifi: mt76: mt7921e: fix random fw download fail
      wifi: mt76: mt7663s: Switch to DEFINE_SIMPLE_DEV_PM_OPS() and pm_sleep_ptr()
      wifi: mt76: mt7921s: Switch to DEFINE_SIMPLE_DEV_PM_OPS() and pm_sleep_ptr()

Dian-Syuan Yang (3):
      wifi: rtw89: send OFDM rate only in P2P mode
      wifi: rtw89: support WMM-PS in P2P GO mode
      wifi: rtw89: support for processing P2P power saving

Duoming Zhou (1):
      mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv

Eric Huang (1):
      wifi: rtw89: add DIG register struct to share common algorithm

Gergo Koteles (1):
      wifi: mt76: mt76_usb.mt76u_mcu.burst is always false remove related code

Gustavo A. R. Silva (2):
      ipw2x00: Replace zero-length array with DECLARE_FLEX_ARRAY() helper
      iwlegacy: Replace zero-length arrays with DECLARE_FLEX_ARRAY() helper

Haim Dreyfuss (5):
      wifi: iwlwifi: mvm: don't check D0I3 version
      wifi: iwlwifi: mvm: Add support for wowlan info notification
      wifi: iwlwifi: mvm: Add support for wowlan wake packet notification
      wifi: iwlwifi: mvm: Add support for d3 end notification
      wifi: iwlwifi: mvm: enable resume based on notifications

Haim, Dreyfuss (1):
      wifi: iwlwifi: mvm: trigger resume flow before wait for notifications

Hans de Goede (3):
      wifi: brcmfmac: Use ISO3166 country code and rev 0 as fallback on 43430
      wifi: brcmfmac: Add DMI nvram filename quirk for Chuwi Hi8 Pro tablet
      wifi: rt2x00: Fix "Error - Attempt to send packet over invalid queue 2"

Hector Martin (12):
      dt-bindings: net: bcm4329-fmac: Add Apple properties & chips
      wifi: brcmfmac: firmware: Handle per-board clm_blob files
      wifi: brcmfmac: pcie/sdio/usb: Get CLM blob via standard firmware mechanism
      wifi: brcmfmac: firmware: Support passing in multiple board_types
      wifi: brcmfmac: pcie: Read Apple OTP information
      wifi: brcmfmac: of: Fetch Apple properties
      wifi: brcmfmac: pcie: Perform firmware selection for Apple platforms
      wifi: brcmfmac: firmware: Allow platform to override macaddr
      wifi: brcmfmac: msgbuf: Increase RX ring sizes to 1024
      wifi: brcmfmac: pcie: Support PCIe core revisions >= 64
      wifi: brcmfmac: pcie: Add IDs/properties for BCM4378
      arm64: dts: apple: Add WiFi module and antenna properties

Howard Hsu (2):
      wifi: mt76: mt7915: fix mcs value in ht mode
      wifi: mt76: mt7915: do not check state before configuring implicit beamform

Ilan Peer (1):
      wifi: iwlwifi: mvm: Add handling for scan offload match info notification

Jason Wang (2):
      wifi: mwifiex: Fix comment typo
      wifi: p54: Fix comment typo

Jeff Johnson (3):
      wifi: ath10k: Fix miscellaneous spelling errors
      wifi: ath11k: Fix miscellaneous spelling errors
      wifi: ath11k: Fix kernel-doc issues

Jesus Fernandez Manzano (1):
      wifi: ath11k: fix number of VHT beamformee spatial streams

Jianglei Nie (1):
      wifi: ath11k: mhi: fix potential memory leak in ath11k_mhi_register()

Jilin Yuan (3):
      wifi: wcn36xx: fix repeated words in comments
      wifi: ath9k: fix repeated to words in a comment
      wifi: ath9k: fix repeated the words in a comment

Jinpeng Cui (1):
      wifi: brcmfmac: remove redundant variable err

Johannes Berg (30):
      Merge remote-tracking branch 'wireless/main' into wireless-next
      wifi: mac80211: set link_sta in reorder timeout
      wifi: mac80211: isolate driver from inactive links
      wifi: mac80211: add ieee80211_find_sta_by_link_addrs API
      wifi: mac80211_hwsim: skip inactive links on TX
      wifi: mac80211_hwsim: track active STA links
      wifi: mac80211: extend ieee80211_nullfunc_get() for MLO
      wifi: mac80211_hwsim: send NDP for link (de)activation
      wifi: mac80211: add vif/sta link RCU dereference macros
      wifi: mac80211: set up beacon timing config on links
      wifi: mac80211: implement link switching
      wifi: mac80211_hwsim: always activate all links
      wifi: rsi: fix kernel-doc warning
      wifi: ipw2100: fix warnings about non-kernel-doc
      wifi: libertas: fix a couple of sparse warnings
      wifi: wl18xx: add some missing endian conversions
      wifi: mwifiex: mark a variable unused
      wifi: mwifiex: fix endian conversion
      wifi: mwifiex: fix endian annotations in casts
      wifi: cw1200: remove RCU STA pointer handling in TX
      wifi: cw1200: use get_unaligned_le64()
      wifi: b43: remove empty switch statement
      wifi: iwlwifi: mvm: fix typo in struct iwl_rx_no_data API
      wifi: iwlwifi: mvm: rxmq: refactor mac80211 rx_status setting
      wifi: iwlwifi: mvm: rxmq: further unify some VHT/HE code
      wifi: iwlwifi: mvm: refactor iwl_mvm_set_sta_rate() a bit
      wifi: iwlwifi: cfg: remove IWL_DEVICE_BZ_COMMON macro
      wifi: ipw2x00: fix array of flexible structures warnings
      wifi: rndis_wlan: fix array of flexible structures warning
      wifi: mwifiex: fix array of flexible structures warnings

Jun Yu (1):
      wifi: ath11k: retrieve MAC address from system firmware if provided

Kalle Valo (3):
      Merge tag 'mt76-for-kvalo-2022-09-15' of https://github.com/nbd168/wireless
      Merge tag 'iwlwifi-next-for-kalle-2022-09-18' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Kees Cook (2):
      wifi: iwlwifi: calib: Refactor iwl_calib_result usage for clarity
      wifi: iwlwifi: Track scan_cmd allocation size explicitly

Kuan-Chung Chen (4):
      wifi: rtw89: support for setting HE GI and LTF
      wifi: rtw89: support for setting TID specific configuration
      wifi: rtw89: disable 26-tone RU HE TB PPDU transmissions
      wifi: rtw89: support for enable/disable MSDU aggregation

Lo(Double)Hsiang Lo (1):
      brcmfmac: increase dcmd maximum buffer size

Lorenzo Bianconi (9):
      wifi: mt76: connac: introduce mt76_connac_reg_map structure
      wifi: mt76: add rx_check callback for usb devices
      wifi: mt76: mt7921: move mt7921_rx_check and mt7921_queue_rx_skb in mac.c
      wifi: mt76: sdio: add rx_check callback for sdio devices
      wifi: mt76: mt7615: add mt7615_mutex_acquire/release in mt7615_sta_set_decap_offload
      wifi: mt76: mt7915: fix possible unaligned access in mt7915_mac_add_twt_setup
      wifi: mt76: connac: fix possible unaligned access in mt76_connac_mcu_add_nested_tlv
      wifi: mt76: mt7663s: add rx_check callback
      wifi: mt76: fix uninitialized pointer in mt7921_mac_fill_rx

Manikanta Pubbisetty (12):
      wifi: ath11k: Register shutdown handler for WCN6750
      wifi: ath11k: Fix incorrect QMI message ID mappings
      wifi: ath11k: Add cold boot calibration support on WCN6750
      wifi: ath11k: Add TWT debugfs support for STA interface
      wifi: ath11k: Fix hardware restart failure due to twt debugfs failure
      wifi: ath11k: Add support to connect to non-transmit MBSSID profiles
      ath11k: Enable remain-on-channel support on WCN6750
      wifi: ath11k: Enable threaded NAPI
      wifi: ath11k: Add multi TX ring support for WCN6750
      wifi: ath11k: Increase TCL data ring size for WCN6750
      dt: bindings: net: add bindings to add WoW support on WCN6750
      wifi: ath11k: Add WoW support for WCN6750

Marek Vasut (1):
      wifi: brcmfmac: add 43439 SDIO ids and initialization

Ming Yen Hsieh (1):
      wifi: mt76: mt7921: introduce Country Location Control support

Naftali Goldstein (1):
      wifi: iwlwifi: mvm: d3: parse keys from wowlan info notification

Ping-Ke Shih (24):
      wifi: rtw89: use u32_get_bits to access C2H content of PHY capability
      wifi: rtw89: parse phycap of TX/RX antenna number
      wifi: rtw89: configure TX path via H2C command
      wifi: rtw89: record signal strength per RF path
      wifi: rtw89: support TX diversity for 1T2R chipset
      wifi: rtw89: 8852c: enable the interference cancellation of MU-MIMO on 6GHz
      wifi: rtw89: 8852c: enlarge polling timeout of RX DCK
      wifi: rtw89: coex: use void pointer as temporal type to copy report
      wifi: rtw89: coex: show connecting state in debug message
      wifi: rtw89: unify use of rtw89_h2c_tx()
      wifi: rtw89: initialize DMA of CMAC
      wifi: rtw89: mac: set NAV upper to 25ms
      wifi: rtw89: pci: update LTR settings
      wifi: rtw89: reset halt registers before turn on wifi CPU
      wifi: rtw89: set wifi_role of P2P
      wifi: rtw89: pci: mask out unsupported TX channels
      wifi: rtw89: mac: define DMA channel mask to avoid unsupported channels
      wifi: rtw89: add DMA busy checking bits to chip info
      wifi: rtw89: 8852b: implement chip_ops::{enable,disable}_bb_rf
      wifi: rtw89: pci: add to do PCI auto calibration
      wifi: rtw89: pci: set power cut closed for 8852be
      wifi: rtw89: mac: correct register of report IMR
      wifi: rtw89: check DLE FIFO size with reserved size
      wifi: rtw89: 8852b: configure DLE mem

Po Hao Huang (1):
      wifi: rtw89: support P2P

Po-Hao Huang (5):
      wifi: rtw89: 8852c: support hw_scan
      wifi: rtw89: split scan including lots of channels
      wifi: rtw89: free unused skb to prevent memory leak
      wifi: rtw89: fix rx filter after scan
      wifi: rtw89: 8852c: add multi-port ID to TX descriptor

Ramesh Rangavittal (1):
      brcmfmac: Remove the call to "dtim_assoc" IOVAR

Ruffalo Lavoisier (1):
      wifi: mt76: connac: fix in comment

Ryder Lee (2):
      wifi: mt76: move move mt76_sta_stats to mt76_wcid
      wifi: mt76: add PPDU based TxS support for WED device

Ryohei Kondo (1):
      brcmfmac: increase default max WOWL patterns to 16

Sean Wang (11):
      wifi: mt76: mt7921e: fix race issue between reset and suspend/resume
      wifi: mt76: mt7921s: fix race issue between reset and suspend/resume
      wifi: mt76: mt7921u: fix race issue between reset and suspend/resume
      wifi: mt76: mt7921u: remove unnecessary MT76_STATE_SUSPEND
      wifi: mt76: sdio: fix the deadlock caused by sdio->stat_work
      wifi: mt76: sdio: poll sta stat when device transmits data
      wifi: mt76: mt7921: add mt7921_mutex_acquire at mt7921_[start, stop]_ap
      wifi: mt76: mt7921: add mt7921_mutex_acquire at mt7921_sta_set_decap_offload
      wifi: mt76: mt7921: fix the firmware version report
      wifi: mt76: mt7921: get rid of the false positive reset
      wifi: mt76: mt7921: reset msta->airtime_ac while clearing up hw value

Shaomin Deng (1):
      bcma: Fix typo in comments

Shayne Chen (1):
      wifi: mt76: testmode: use random payload for tx packets

Tamizh Chelvam Raja (1):
      wifi: ath11k: Add spectral scan support for 160 MHz

Tomislav Požega (6):
      wifi: rt2x00: define RF5592 in init_eeprom routine
      wifi: rt2x00: add RF self TXDC calibration for MT7620
      wifi: rt2x00: add r calibration for MT7620
      wifi: rt2x00: add RXDCOC calibration for MT7620
      wifi: rt2x00: add RXIQ calibration for MT7620
      wifi: rt2x00: add TX LOFT calibration for MT7620

Venkateswara Naralasetty (1):
      wifi: ath11k: Add support to get power save duration for each client

Wen Gong (3):
      wifi: ath11k: change complete() to complete_all() for scan.completed
      wifi: ath11k: fix failed to find the peer with peer_id 0 when disconnected
      wifi: ath10k: reset pointer after memory free to avoid potential use-after-free

Xiaomeng Tong (1):
      cw1200: fix incorrect check to determine if no element is found in list

YN Chen (1):
      wifi: mt76: sdio: fix transmitting packet hangs

Yaara Baruch (1):
      wifi: iwlwifi: pcie: add support for BZ devices

Yedidya Benshimol (1):
      wifi: iwlwifi: mvm: iterate over interfaces after an assert in d3

Yi-Tang Chiu (1):
      wifi: rtw89: 8852c: set TX to single path TX on path B in 6GHz band

Zheyu Ma (1):
      wifi: rtl8xxxu: Simplify the error handling code

Zong-Zhe Yang (4):
      wifi: rtw89: 8852c: L1 DMA reset has offloaded to FW
      wifi: rtw89: introudce functions to drop packets
      wifi: rtw89: 8852c: support fw crash simulation
      wifi: rtw89: support SER L1 simulation

 .../bindings/net/wireless/brcm,bcm4329-fmac.yaml   |   39 +-
 .../bindings/net/wireless/qcom,ath11k.yaml         |   14 +
 arch/arm64/boot/dts/apple/t8103-j274.dts           |    4 +
 arch/arm64/boot/dts/apple/t8103-j293.dts           |    4 +
 arch/arm64/boot/dts/apple/t8103-j313.dts           |    4 +
 arch/arm64/boot/dts/apple/t8103-j456.dts           |    4 +
 arch/arm64/boot/dts/apple/t8103-j457.dts           |    4 +
 arch/arm64/boot/dts/apple/t8103-jxxx.dtsi          |    2 +
 drivers/bcma/driver_mips.c                         |    2 +-
 drivers/net/wireless/ath/ath10k/bmi.c              |    4 +-
 drivers/net/wireless/ath/ath10k/ce.c               |    2 +-
 drivers/net/wireless/ath/ath10k/core.c             |    2 +-
 drivers/net/wireless/ath/ath10k/core.h             |    4 +-
 drivers/net/wireless/ath/ath10k/coredump.c         |    2 +-
 drivers/net/wireless/ath/ath10k/coredump.h         |    2 +-
 drivers/net/wireless/ath/ath10k/debug.c            |    2 +-
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |    2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |    8 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |    2 +-
 drivers/net/wireless/ath/ath10k/hw.c               |    6 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   14 +-
 drivers/net/wireless/ath/ath10k/pci.c              |    2 +-
 drivers/net/wireless/ath/ath10k/pci.h              |    2 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |    2 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h          |    2 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |    2 +-
 drivers/net/wireless/ath/ath10k/thermal.c          |    2 +-
 drivers/net/wireless/ath/ath10k/thermal.h          |    2 +-
 drivers/net/wireless/ath/ath10k/usb.h              |    2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |    4 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |    2 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |   14 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |  186 ++-
 drivers/net/wireless/ath/ath11k/ahb.h              |   16 +
 drivers/net/wireless/ath/ath11k/ce.c               |    4 +-
 drivers/net/wireless/ath/ath11k/core.c             |  132 +-
 drivers/net/wireless/ath/ath11k/core.h             |   25 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |  488 ++++--
 drivers/net/wireless/ath/ath11k/debugfs.h          |   11 +-
 .../net/wireless/ath/ath11k/debugfs_htt_stats.h    |    4 +-
 drivers/net/wireless/ath/ath11k/debugfs_sta.c      |  107 ++
 drivers/net/wireless/ath/ath11k/dp.c               |   28 +-
 drivers/net/wireless/ath/ath11k/dp.h               |   20 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |    5 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |   21 +-
 drivers/net/wireless/ath/ath11k/hal.c              |    4 +-
 drivers/net/wireless/ath/ath11k/hal.h              |   23 +-
 drivers/net/wireless/ath/ath11k/hal_desc.h         |    8 +-
 drivers/net/wireless/ath/ath11k/hal_tx.c           |    4 +-
 drivers/net/wireless/ath/ath11k/hal_tx.h           |    2 +
 drivers/net/wireless/ath/ath11k/hif.h              |   11 +
 drivers/net/wireless/ath/ath11k/hw.c               |  118 +-
 drivers/net/wireless/ath/ath11k/hw.h               |   23 +
 drivers/net/wireless/ath/ath11k/mac.c              |  165 +-
 drivers/net/wireless/ath/ath11k/mhi.c              |   17 +-
 drivers/net/wireless/ath/ath11k/pci.c              |    1 +
 drivers/net/wireless/ath/ath11k/pcic.c             |  116 +-
 drivers/net/wireless/ath/ath11k/pcic.h             |    6 +
 drivers/net/wireless/ath/ath11k/peer.c             |   30 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   54 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |   10 +-
 drivers/net/wireless/ath/ath11k/rx_desc.h          |    2 +-
 drivers/net/wireless/ath/ath11k/spectral.c         |   22 +
 drivers/net/wireless/ath/ath11k/spectral.h         |    1 +
 drivers/net/wireless/ath/ath11k/thermal.c          |    2 +-
 drivers/net/wireless/ath/ath11k/thermal.h          |    2 +-
 drivers/net/wireless/ath/ath11k/trace.h            |   28 +
 drivers/net/wireless/ath/ath11k/wmi.c              |  246 ++-
 drivers/net/wireless/ath/ath11k/wmi.h              |   72 +-
 drivers/net/wireless/ath/ath11k/wow.c              |   21 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |    2 +-
 drivers/net/wireless/ath/ath9k/channel.c           |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h                |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |    2 +-
 drivers/net/wireless/ath/wcn36xx/hal.h             |    2 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c            |    4 +
 drivers/net/wireless/broadcom/b43/phy_n.c          |    6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |    4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |    1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   19 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   39 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |   10 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |   12 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |    1 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |    3 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |   18 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |    3 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |  116 +-
 .../broadcom/brcm80211/brcmfmac/firmware.h         |    4 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.h  |    4 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |   12 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  434 ++++-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   40 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |    2 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   23 +-
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |    7 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |    4 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.h       |    2 +-
 drivers/net/wireless/intel/ipw2x00/libipw.h        |   13 +-
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |   10 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |    7 +-
 drivers/net/wireless/intel/iwlegacy/commands.h     |    4 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |    8 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   42 +-
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h       |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/calib.c     |   22 +-
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h       |    1 +
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |    6 +-
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c      |   10 +-
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c       |   10 +-
 drivers/net/wireless/intel/iwlwifi/dvm/ucode.c     |    8 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |    5 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |   61 +-
 .../net/wireless/intel/iwlwifi/fw/api/offload.h    |   17 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |   20 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |    3 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  668 ++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   27 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   21 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   18 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   17 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  376 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   19 +-
 drivers/net/wireless/intersil/p54/main.c           |    2 +-
 drivers/net/wireless/mac80211_hwsim.c              |   94 +-
 drivers/net/wireless/marvell/libertas/cfg.c        |    2 +-
 drivers/net/wireless/marvell/libertas/main.c       |    3 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |    2 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |    4 +-
 drivers/net/wireless/marvell/mwifiex/init.c        |    9 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |    3 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |    2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |    4 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |    8 +-
 drivers/net/wireless/marvell/mwifiex/usb.c         |   12 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   50 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |    4 +
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c   |   16 +-
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |    1 +
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |   11 +-
 .../net/wireless/mediatek/mt76/mt76_connac2_mac.h  |    8 +
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |   76 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   18 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   11 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |    2 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |   30 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   27 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   19 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   18 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |  256 +--
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |    2 -
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |   21 +
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   12 +-
 .../net/wireless/mediatek/mt76/mt7921/acpi_sar.c   |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7921/eeprom.h |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |    1 +
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  147 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   28 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  198 +++
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   39 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |   99 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |  150 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mcu.c    |    9 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |    2 +
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   |   29 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mcu.c   |    7 +-
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |   40 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |    8 +-
 drivers/net/wireless/mediatek/mt76/sdio_txrx.c     |   23 +-
 drivers/net/wireless/mediatek/mt76/testmode.c      |    8 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |    5 +
 drivers/net/wireless/microchip/wilc1000/netdev.h   |    1 +
 drivers/net/wireless/microchip/wilc1000/sdio.c     |   39 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |   15 +-
 drivers/net/wireless/ralink/rt2x00/rt2800.h        |    3 +
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     | 1753 +++++++++++++++++++-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h     |   10 +
 drivers/net/wireless/ralink/rt2x00/rt2x00.h        |    5 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |   18 +
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c   |    2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |    6 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   94 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |    6 +-
 drivers/net/wireless/realtek/rtw89/coex.c          |  805 ++++++---
 drivers/net/wireless/realtek/rtw89/core.c          |  157 +-
 drivers/net/wireless/realtek/rtw89/core.h          |  135 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |   76 +-
 drivers/net/wireless/realtek/rtw89/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw89/fw.c            |  465 +++++-
 drivers/net/wireless/realtek/rtw89/fw.h            |  190 ++-
 drivers/net/wireless/realtek/rtw89/mac.c           |  259 ++-
 drivers/net/wireless/realtek/rtw89/mac.h           |   62 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   84 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |  194 ++-
 drivers/net/wireless/realtek/rtw89/pci.h           |   32 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |  167 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |    1 +
 drivers/net/wireless/realtek/rtw89/ps.c            |   75 +-
 drivers/net/wireless/realtek/rtw89/ps.h            |    3 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |  109 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   94 +-
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c     |    7 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |   94 ++
 drivers/net/wireless/realtek/rtw89/rtw8852be.c     |   25 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |  126 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c  |    3 +-
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c     |    7 +-
 drivers/net/wireless/realtek/rtw89/ser.c           |    4 +-
 drivers/net/wireless/rndis_wlan.c                  |    5 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |    1 +
 drivers/net/wireless/st/cw1200/queue.c             |   18 +-
 drivers/net/wireless/st/cw1200/sta.c               |    4 +-
 drivers/net/wireless/st/cw1200/txrx.c              |    8 +-
 drivers/net/wireless/ti/wl1251/main.c              |    2 +-
 drivers/net/wireless/ti/wl18xx/event.c             |    8 +-
 drivers/net/wireless/ti/wlcore/cmd.c               |    4 +-
 include/linux/bcma/bcma_driver_chipcommon.h        |    1 +
 include/linux/ieee80211.h                          |    8 +-
 include/linux/mmc/sdio_ids.h                       |    1 +
 include/net/mac80211.h                             |  189 ++-
 net/mac80211/chan.c                                |    6 +
 net/mac80211/debugfs_netdev.c                      |   26 +
 net/mac80211/driver-ops.c                          |  172 ++
 net/mac80211/driver-ops.h                          |  165 +-
 net/mac80211/he.c                                  |   12 +-
 net/mac80211/ht.c                                  |   13 +-
 net/mac80211/ieee80211_i.h                         |    4 +
 net/mac80211/iface.c                               |   12 +
 net/mac80211/key.c                                 |   42 +
 net/mac80211/key.h                                 |    3 +
 net/mac80211/link.c                                |  237 ++-
 net/mac80211/mlme.c                                |  125 +-
 net/mac80211/rc80211_minstrel_ht.c                 |    9 +-
 net/mac80211/rx.c                                  |   78 +-
 net/mac80211/sta_info.c                            |  100 +-
 net/mac80211/sta_info.h                            |    3 +
 net/mac80211/tx.c                                  |   53 +-
 net/mac80211/util.c                                |    2 +-
 net/mac80211/vht.c                                 |    8 +-
 net/mac80211/wpa.c                                 |    4 +-
 net/wireless/lib80211_crypt_ccmp.c                 |    2 +-
 251 files changed, 9768 insertions(+), 2629 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852b.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852be.c
