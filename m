Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C22C5803A2
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 19:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbiGYRpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 13:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiGYRpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 13:45:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C0863E8;
        Mon, 25 Jul 2022 10:45:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C7D3B810A4;
        Mon, 25 Jul 2022 17:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA465C341C6;
        Mon, 25 Jul 2022 17:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658771148;
        bh=AvUBbTpqdohreDmZPw7mAChc8dm9GcojJgRMj0m8G2c=;
        h=From:Subject:To:Cc:Date:From;
        b=RgC/mnP77Cep8OHPWYwHiJOCWDx9poLcd12dnaJe3QN2Xf0+TsFpfu8o/I5W2PDBj
         8XgP3KUlGL/tagiCNRa68y1GwF7OtkUwNzkzDjBuFDXDlTu+/KNbt1x6znLhHVCXa6
         Zb8YkTWlVRqCos7Mx/FlgCJHh18lektk6dcdvj3MJhCh+9ygClNhqW3ugK+uiC++Xe
         PTk3x6ejTBgayfK8Kch1itmSgyNYzh9HFBPyGYB87c+hDk8utroLaR99VmRg7eomyR
         z4h81J353KG748wF8P0DOocEseoUvL/YsG/RqLmyEPYXi+uweLoAUbmJjW8KLpTmLI
         h9xKw9SJD+kUA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-next-2022-07-25
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20220725174547.EA465C341C6@smtp.kernel.org>
Date:   Mon, 25 Jul 2022 17:45:47 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

The following changes since commit c8fda7d28100698cd02aaa849f952c8b59b7bea1:

  Merge tag 'mlx5-updates-2022-07-13' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2022-07-14 22:11:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2022-07-25

for you to fetch changes up to 9fab4cc8c3450df15c9bcaedd0d3c954211a7a54:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2022-07-25 19:50:38 +0300)

----------------------------------------------------------------
wireless-next patches for v5.20

Third set of patches for v5.20. MLO work continues and we have a lot
of stack changes due to that, including driver API changes. Not much
driver patches except on mt76.

Major changes:

cfg80211/mac80211

* more prepartion for Wi-Fi 7 Multi-Link Operation (MLO) support,
  works with one link now

* align with IEEE Draft P802.11be_D2.0

* hardware timestamps for receive and transmit

mt76

* preparation for new chipset support

* ACPI SAR support

----------------------------------------------------------------
Aditya Kumar Singh (1):
      wifi: mac80211: fix mesh airtime link metric estimating

Andrei Otcheretianski (14):
      wifi: mac80211_hwsim: Support link channel matching on rx
      wifi: mac80211: Consider MLO links in offchannel logic
      wifi: cfg80211: Allow MLO TX with link source address
      wifi: mac80211: Remove AP SMPS leftovers
      wifi: mac80211_hwsim: Ack link addressed frames
      wifi: nl80211: Support MLD parameters in nl80211_set_station()
      wifi: cfg80211/mac80211: Support control port TX from specific link
      wifi: mac80211: Allow EAPOL frames from link addresses
      wifi: mac80211: Allow EAPOL tx from specific link
      wifi: mac80211: don't check carrier in chanctx code
      wifi: mac80211: Support multi link in ieee80211_recalc_min_chandef()
      wifi: mac80211: select link when transmitting to non-MLO stations
      wifi: mac80211_hwsim: do rc update per link
      wifi: mac80211_hwsim: use MLO link ID for TX

Avraham Stern (6):
      wifi: ieee80211: add helper functions for detecting TM/FTM frames
      wifi: nl80211: add RX and TX timestamp attributes
      wifi: cfg80211: add a function for reporting TX status with hardware timestamps
      wifi: cfg80211/nl80211: move rx management data into a struct
      wifi: cfg80211: add hardware timestamps to frame RX info
      wifi: mac80211: add hardware timestamps for RX and TX

Christophe JAILLET (2):
      wifi: p54: Fix an error handling path in p54spi_probe()
      wifi: p54: Use the bitmap API to allocate bitmaps

Dan Carpenter (2):
      mt76: mt7915: fix endian bug in mt7915_rf_regval_set()
      wifi: wil6210: debugfs: fix info leak in wil_write_file_wmi()

Deren Wu (9):
      mt76: add 6 GHz band support in mt76_sar_freq_ranges
      mt76: mt7921: introduce ACPI SAR support
      mt76: mt7921: introduce ACPI SAR config in tx power
      mt76: enable the VHT extended NSS BW feature
      mt76: mt7921: not support beacon offload disable command
      mt76: mt7921: fix command timeout in AP stop period
      mt76: mt7921s: fix possible sdio deadlock in command fail
      mt76: mt7921: fix aggregation subframes setting to HE max
      mt76: mt7921: enlarge maximum VHT MPDU length to 11454

Felix Fietkau (11):
      mt76: mt7915: add missing bh-disable around tx napi enable/schedule
      mt76: mt7615: add missing bh-disable around rx napi schedule
      mt76: mt7915: disable UL MU-MIMO for mt7915
      mt76: mt7615: add sta_rec with EXTRA_INFO_NEW for the first time only
      mt76: mt76x02: improve reliability of the beacon hang check
      mt76: allow receiving frames with invalid CCMP PN via monitor interfaces
      mt76: mt7615: fix throughput regression on DFS channels
      mt76: pass original queue id from __mt76_tx_queue_skb to the driver
      mt76: do not use skb_set_queue_mapping for internal purposes
      mt76: remove q->qid
      wifi: mac80211: exclude multicast packets from AQL pending airtime

Gregory Greenman (4):
      wifi: mac80211: replace link_id with link_conf in start/stop_ap()
      wifi: mac80211: replace link_id with link_conf in switch/(un)assign_vif_chanctx()
      wifi: mac80211: remove link_id parameter from link_info_changed()
      wifi: mac80211: add macros to loop over active links

Ilan Peer (3):
      wifi: mac80211: Align with Draft P802.11be_D1.5
      wifi: mac80211: Align with Draft P802.11be_D2.0
      wifi: nl80211: allow link ID in set_wiphy with frequency

Jilin Yuan (17):
      wifi: ath5k: fix repeated words in comments
      wifi: ath6kl: fix repeated words in comments
      wifi: ath: fix repeated words in comments
      wifi: wil6210: fix repeated words in comments
      wifi: wcn36xx: fix repeated words in comments
      wifi: atmel: fix repeated words in comments
      wifi: b43: fix repeated words in comments
      wifi: brcmfmac: fix repeated words in comments
      wifi: brcmsmac: fix repeated words in comments
      wifi: ipw2x00: fix repeated words in comments
      wifi: iwlegacy: fix repeated words in comments
      wifi: qtnfmac: fix repeated words in comments
      wifi: rt2x00: fix repeated words in comments
      wifi: rtlwifi: fix repeated words in comments
      wifi: rtl8192se: fix repeated words in comments
      wifi: rsi: fix repeated words in comments
      wifi: wl1251: fix repeated words in comments

Johannes Berg (115):
      wifi: rsi: remove unused variable
      wifi: mac80211_hwsim: use 32-bit skb cookie
      wifi: mac80211: consistently use sdata_dereference()
      wifi: mac80211: rx: accept link-addressed frames
      wifi: nl80211: hold wdev mutex in add/mod/del link station
      wifi: nl80211: hold wdev mutex for channel switch APIs
      wifi: nl80211: hold wdev mutex for station APIs
      wifi: mac80211: RCU-ify link/link_conf pointers
      wifi: cfg80211: make cfg80211_auth_request::key_idx signed
      wifi: cfg80211: drop BSS elements from assoc trace for now
      wifi: mac80211: debug: omit link if non-MLO connection
      wifi: mac80211: skip powersave recalc if driver SUPPORTS_DYNAMIC_PS
      wifi: mac80211: separate out connection downgrade flags
      wifi: mac80211: fix key lookup
      wifi: nl80211: acquire wdev mutex for dump_survey
      wifi: mac80211: move ieee80211_request_smps_mgd_work
      wifi: mac80211: set up/tear down client vif links properly
      wifi: mac80211: provide link ID in link_conf
      wifi: mac80211: move ps setting to vif config
      wifi: mac80211: expect powersave handling in driver for MLO
      wifi: mac80211: change QoS settings API to take link into account
      wifi: mac80211: remove unused bssid variable
      wifi: mac80211: mlme: track AP (MLD) address separately
      wifi: mac80211: mlme: do IEEE80211_STA_RESET_SIGNAL_AVE per link
      wifi: mac80211: mlme: first adjustments for MLO
      wifi: mac80211: split IEEE80211_STA_DISABLE_WMM to link data
      wifi: mac80211: mlme: use ieee80211_get_link_sband()
      wifi: mac80211: mlme: remove sta argument from ieee80211_config_bw
      wifi: mac80211: mlme: use correct link_sta
      wifi: cfg80211: remove BSS pointer from cfg80211_disassoc_request
      wifi: cfg80211: prepare association failure APIs for MLO
      wifi: mac80211: mlme: unify assoc data event sending
      wifi: cfg80211: adjust assoc comeback for MLO
      wifi: cfg80211: put cfg80211_rx_assoc_resp() arguments into a struct
      wifi: cfg80211: extend cfg80211_rx_assoc_resp() for MLO
      wifi: mac80211: refactor elements parsing with parameter struct
      wifi: mac80211: don't re-parse elems in ieee80211_assoc_success()
      wifi: mac80211: move tdls_chan_switch_prohibited to link data
      wifi: mac80211: fix multi-BSSID element parsing
      wifi: mac80211: don't set link address for station
      wifi: mac80211: remove redundant condition
      wifi: cfg80211: add ieee80211_chanwidth_rate_flags()
      wifi: mac80211: use only channel width in ieee80211_parse_bitrates()
      wifi: mac80211: refactor adding rates to assoc request
      wifi: mac80211: refactor adding custom elements
      wifi: mac80211: mlme: simplify adding ht/vht/he/eht elements
      wifi: mac80211: consider EHT element size in assoc request
      wifi: cfg80211: clean up links appropriately
      wifi: mac80211: tighten locking check
      wifi: mac80211: fix link manipulation
      wifi: nl80211: better validate link ID for stations
      wifi: nl80211: add EML/MLD capabilities to per-iftype capabilities
      wifi: nl80211: set BSS to NULL if IS_ERR()
      wifi: mac80211: skip rate statistics for MLD STAs
      wifi: mac80211: add a helper to fragment an element
      wifi: nl80211: check MLO support in authenticate
      wifi: nl80211: advertise MLO support
      wifi: cfg80211: set country_elem to NULL
      wifi: nl80211: reject link specific elements on assoc link
      wifi: nl80211: reject fragmented and non-inheritance elements
      wifi: nl80211: fix some attribute policy entries
      wifi: mac80211: prohibit DEAUTH_NEED_MGD_TX_PREP in MLO
      wifi: mac80211: release channel context on link stop
      wifi: mac80211: mlme: clean up supported channels element code
      wifi: mac80211: add multi-link element to AUTH frames
      wifi: mac80211: make ieee80211_check_rate_mask() link-aware
      wifi: mac80211: move IEEE80211_SDATA_OPERATING_GMODE to link
      wifi: mac80211: mlme: refactor link station setup
      wifi: mac80211: mlme: shift some code around
      wifi: mac80211: mlme: change flags in ieee80211_determine_chantype()
      wifi: mac80211: mlme: switch some things back to deflink
      wifi: mac80211: mlme: refactor assoc req element building
      wifi: mac80211: mlme: refactor ieee80211_prep_channel() a bit
      wifi: mac80211: mlme: refactor assoc success handling
      wifi: mac80211: mlme: remove address arg to ieee80211_mark_sta_auth()
      wifi: mac80211: mlme: refactor assoc link setup
      wifi: mac80211: mlme: look up beacon elems only if needed
      wifi: cfg80211: add cfg80211_get_iftype_ext_capa()
      wifi: mac80211: mlme: refactor ieee80211_set_associated()
      wifi: mac80211: limit A-MSDU subframes for client too
      wifi: mac80211_hwsim: implement sta_state for MLO
      wifi: mac80211: fix up link station creation/insertion
      wifi: mac80211: do link->MLD address translation on RX
      wifi: mac80211_hwsim: fix TX link selection
      wifi: mac80211: add API to parse multi-link element
      wifi: mac80211: support MLO authentication/association with one link
      wifi: mac80211: remove stray printk
      wifi: mac80211: mlme: set sta.mlo correctly
      wifi: mac80211: tx: use AP address in some places for MLO
      wifi: mac80211: mlme: fix override calculation
      wifi: mac80211: fix NULL pointer deref with non-MLD STA
      wifi: mac80211: fix RX MLD address translation
      wifi: mac80211_hwsim: fix address translation for MLO
      wifi: mac80211: fast-xmit: handle non-MLO clients
      wifi: mac80211: mlme: set sta.mlo to mlo state
      wifi: mac80211: validate link address doesn't change
      wifi: mac80211: fix link sta hash table handling
      wifi: mac80211: more station handling sanity checks
      wifi: nl80211: require MLD address on link STA add/modify
      wifi: mac80211: return error from control port TX for drops
      wifi: nl80211/mac80211: clarify link ID in control port TX
      wifi: mac80211: mlme: fix link_sta setup
      wifi: mac80211: sta_info: fix link_sta insertion
      wifi: mac80211_hwsim: handle links for wmediumd/virtio
      wifi: cfg80211: report link ID in NL80211_CMD_FRAME
      wifi: mac80211: report link ID to cfg80211 on mgmt RX
      wifi: nl80211: add MLO link ID to the NL80211_CMD_FRAME TX API
      wifi: mac80211: expand ieee80211_mgmt_tx() for MLO
      wifi: mac80211: optionally implement MLO multicast TX
      wifi: mac80211: rx: track link in RX data
      wifi: mac80211: verify link addresses are different
      wifi: mac80211: mlme: transmit assoc frame with address translation
      wifi: mac80211: remove erroneous sband/link validation
      wifi: mac80211: mlme: fix disassoc with MLO
      wifi: mac80211: fix link data leak

Justin Stitt (2):
      wifi: mt7601u: eeprom: fix clang -Wformat warning
      wifi: mt7601u: fix clang -Wformat warning

Kai-Heng Feng (1):
      mt76: mt7921: Let PCI core handle power state and use pm_sleep_ptr()

Kalle Valo (3):
      wifi: ath11k: mac: fix long line
      Merge tag 'mt76-for-kvalo-2022-07-11' of https://github.com/nbd168/wireless
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Lian Chen (1):
      wifi: mac80211: make 4addr null frames using min_rate for WDS

Liang He (2):
      mediatek: mt76: mac80211: Fix missing of_node_put() in mt76_led_init()
      mediatek: mt76: eeprom: fix missing of_node_put() in mt76_find_power_limits_node()

Lorenzo Bianconi (40):
      mt76: mt7915: fix endianness in mt7915_rf_regval_get
      mt76: mt76x02u: fix possible memory leak in __mt76x02u_mcu_send_msg
      mt76: mt7921: add missing bh-disable around rx napi schedule
      mt76: mt7921: get rid of mt7921_mcu_exit
      mt76: connac: move shared fw structures in connac module
      mt76: mt7921: move fw toggle in mt7921_load_firmware
      mt76: connac: move mt76_connac2_load_ram in connac module
      mt76: connac: move mt76_connac2_load_patch in connac module
      mt76: mt7663: rely on mt76_connac2_fw_trailer
      mt76: mt7921: rely on mt76_dev in mt7921_mac_write_txwi signature
      mt76: mt7915: rely on mt76_dev in mt7915_mac_write_txwi signature
      mt76: connac: move mac connac2 defs in mt76_connac2_mac.h
      mt76: connac: move connac2_mac_write_txwi in mt76_connac module
      mt76: connac: move mt76_connac2_mac_add_txs_skb in connac module
      mt76: connac: move HE radiotap parsing in connac module
      mt76: connac: move mt76_connac2_reverse_frag0_hdr_trans in mt76-connac module
      mt76: connac: move mt76_connac2_mac_fill_rx_rate in connac module
      mt76: mt7921s: remove unnecessary goto in mt7921s_mcu_drv_pmctrl
      mt76: mt7615: do not update pm stats in case of error
      mt76: mt7921: do not update pm states in case of error
      mt76: mt7915: get rid of unnecessary new line in mt7915_mac_write_txwi
      mt76: connac: move mt76_connac_fw_txp in common module
      mt76: move mt7615_txp_ptr in mt76_connac module
      mt76: connac: move mt76_connac_tx_free in shared code
      mt76: connac: move mt76_connac_tx_complete_skb in shared code
      mt76: connac: move mt76_connac_write_hw_txp in shared code
      mt76: connac: move mt7615_txp_skb_unmap in common code
      mt76: mt7915: rely on mt76_connac_tx_free
      mt76: move mcu_txd/mcu_rxd structures in shared code
      mt76: move mt76_connac2_mcu_fill_message in mt76_connac module
      mt76: mt7915: do not copy ieee80211_ops pointer in mt7915_mmio_probe
      mt76: mt7921: make mt7921_pci_driver static
      mt76: connac: move tx initialization/cleanup in mt76_connac module
      mt76: add len parameter to __mt76_mcu_msg_alloc signature
      mt76: introduce MT_RXQ_BAND2 and MT_RXQ_BAND2_WA in mt76_rxq_id
      mt76: add phy_idx in mt76_rx_status
      mt76: introduce phys array in mt76_dev structure
      mt76: add phy_idx to mt76_wcid
      mt76: convert MT_TX_HW_QUEUE_EXT_PHY to MT_TX_HW_QUEUE_PHY
      mt76: get rid of mt76_wcid_hw routine

MeiChia Chiu (3):
      mt76: do not check the ccmp pn for ONLY_MONITOR frame
      mt76: mt7915: update the maximum size of beacon offload
      mt76: mt7915 add ht mpdu density

Peter Chiu (2):
      dt-bindings: net: wireless: mt76: add clock description for MT7986.
      mt76: mt7915: update mpdu density in 6g capability

Rustam Subkhankulov (1):
      wifi: p54: add missing parentheses in p54_flush()

Ryder Lee (2):
      mt76: mt7915: add more ethtool stats
      mt76: add DBDC rxq handlings into mac_reset_work

Sean Wang (4):
      mt76: mt7921: enable HW beacon filter not depending on PM flag
      mt76: mt7921: enable HW beacon filter in the initialization stage
      mt76: mt7921: reduce log severity levels for informative messages
      mt76: mt7921: reduce the mutex lock scope during reset

Shaul Triebitz (5):
      wifi: mac80211: add an ieee80211_get_link_sband
      wifi: cfg80211: add API to add/modify/remove a link station
      wifi: cfg80211/mac80211: separate link params from station params
      wifi: mac80211: implement callbacks for <add/mod/del>_link_station
      wifi: nl80211: enable setting the link address at new station

Shayne Chen (2):
      mt76: mt7915: fix incorrect testmode ipg on band 1 caused by wmm_idx
      mt76: mt7915: add sta_rec with EXTRA_INFO_NEW for the first time only

Tetsuo Handa (1):
      wifi: mac80211: do not abuse fq.lock in ieee80211_do_stop()

XueBing Chen (1):
      wifi: cfg80211: use strscpy to replace strlcpy

YN Chen (2):
      mt76: mt7921: add PATCH_FINISH_REQ cmd response handling
      mt76: mt7921s: fix firmware download random fail

 .../bindings/net/wireless/mediatek,mt76.yaml       |   13 +
 drivers/net/wireless/ath/ath10k/mac.c              |    9 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   12 +-
 drivers/net/wireless/ath/ath5k/base.c              |    2 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |    5 +-
 drivers/net/wireless/ath/ath6kl/hif.h              |    2 +-
 drivers/net/wireless/ath/ath6kl/sdio.c             |    2 +-
 drivers/net/wireless/ath/ath6kl/wmi.h              |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |    3 +-
 drivers/net/wireless/ath/ath9k/main.c              |    7 +-
 drivers/net/wireless/ath/carl9170/main.c           |    3 +-
 drivers/net/wireless/ath/hw.c                      |    2 +-
 drivers/net/wireless/ath/wcn36xx/hal.h             |    2 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |    2 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |   14 +-
 drivers/net/wireless/ath/wil6210/txrx.h            |    2 +-
 drivers/net/wireless/atmel/atmel.c                 |    2 +-
 drivers/net/wireless/broadcom/b43/main.c           |    3 +-
 drivers/net/wireless/broadcom/b43/phy_common.h     |    2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |    3 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |    2 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |    3 +-
 .../wireless/broadcom/brcm80211/brcmsmac/main.c    |    2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |    2 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |    2 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |    5 +-
 drivers/net/wireless/intel/iwlegacy/common.h       |    3 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |    5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   23 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |    2 +-
 drivers/net/wireless/intersil/p54/fwio.c           |    6 +-
 drivers/net/wireless/intersil/p54/main.c           |    7 +-
 drivers/net/wireless/intersil/p54/p54spi.c         |    3 +-
 drivers/net/wireless/mac80211_hwsim.c              |  287 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |   20 +-
 drivers/net/wireless/marvell/mwl8k.c               |    5 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   19 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |    5 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   61 +-
 drivers/net/wireless/mediatek/mt76/mcu.c           |   10 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   85 +-
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |    9 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  121 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |   69 -
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   28 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |   75 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |    3 -
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   10 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |  109 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |  116 +
 .../net/wireless/mediatek/mt76/mt76_connac2_mac.h  |  323 ++
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |  920 ++++
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  305 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |  156 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |    3 +-
 .../net/wireless/mediatek/mt76/mt76x02_beacon.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   11 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |    3 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |    3 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |   69 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   21 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  915 +---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |  333 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   23 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  403 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   51 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   19 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   32 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   24 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |   11 +-
 drivers/net/wireless/mediatek/mt76/mt7921/Makefile |    1 +
 .../net/wireless/mediatek/mt76/mt7921/acpi_sar.c   |  279 +
 .../net/wireless/mediatek/mt76/mt7921/acpi_sar.h   |   93 +
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    |   21 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   13 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  716 +--
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    |  340 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  123 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  420 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |   88 -
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   50 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |   34 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |  106 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mcu.c    |   17 +-
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   |    2 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mcu.c   |   31 +-
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |   14 +-
 .../net/wireless/mediatek/mt76/mt7921/usb_mac.c    |    4 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |    8 +-
 drivers/net/wireless/mediatek/mt76/testmode.c      |    9 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   54 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |    7 +-
 drivers/net/wireless/mediatek/mt7601u/debugfs.c    |    2 +-
 drivers/net/wireless/mediatek/mt7601u/eeprom.c     |    2 +-
 drivers/net/wireless/mediatek/mt7601u/mt7601u.h    |    3 +-
 drivers/net/wireless/mediatek/mt7601u/tx.c         |    3 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   20 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |    4 +-
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c     |    5 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |    5 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h     |    3 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h        |    5 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c     |    5 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |    5 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.c       |    5 +-
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |    3 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |    3 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |    3 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |    5 +-
 drivers/net/wireless/realtek/rtlwifi/regd.c        |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |    2 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    6 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |    8 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |    2 -
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |    3 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |    2 +-
 drivers/net/wireless/silabs/wfx/sta.c              |   17 +-
 drivers/net/wireless/silabs/wfx/sta.h              |   11 +-
 drivers/net/wireless/st/cw1200/sta.c               |    3 +-
 drivers/net/wireless/st/cw1200/sta.h               |    3 +-
 drivers/net/wireless/ti/wl1251/acx.h               |    2 +-
 drivers/net/wireless/ti/wl1251/main.c              |    3 +-
 drivers/net/wireless/ti/wlcore/main.c              |   11 +-
 include/linux/ieee80211.h                          |  123 +-
 include/net/cfg80211.h                             |  322 +-
 include/net/mac80211.h                             |   90 +-
 include/uapi/linux/nl80211.h                       |   52 +-
 net/mac80211/agg-rx.c                              |    2 +-
 net/mac80211/agg-tx.c                              |    4 +-
 net/mac80211/cfg.c                                 |  484 +-
 net/mac80211/chan.c                                |  145 +-
 net/mac80211/debug.h                               |   31 +-
 net/mac80211/debugfs.c                             |    3 +-
 net/mac80211/debugfs_netdev.c                      |    2 +-
 net/mac80211/driver-ops.c                          |    8 +-
 net/mac80211/driver-ops.h                          |   50 +-
 net/mac80211/ht.c                                  |   34 +-
 net/mac80211/ibss.c                                |   50 +-
 net/mac80211/ieee80211_i.h                         |  225 +-
 net/mac80211/iface.c                               |  405 +-
 net/mac80211/main.c                                |   17 +-
 net/mac80211/mesh.c                                |   36 +-
 net/mac80211/mesh_hwmp.c                           |    9 +-
 net/mac80211/mesh_plink.c                          |    5 +-
 net/mac80211/mlme.c                                | 5783 ++++++++++++--------
 net/mac80211/ocb.c                                 |    8 +-
 net/mac80211/offchannel.c                          |   74 +-
 net/mac80211/rate.c                                |    9 +-
 net/mac80211/rate.h                                |    2 +-
 net/mac80211/rx.c                                  |  153 +-
 net/mac80211/scan.c                                |   12 +-
 net/mac80211/spectmgmt.c                           |   16 +-
 net/mac80211/sta_info.c                            |  153 +-
 net/mac80211/sta_info.h                            |   16 +-
 net/mac80211/status.c                              |   41 +-
 net/mac80211/tdls.c                                |   15 +-
 net/mac80211/trace.h                               |   57 +-
 net/mac80211/tx.c                                  |  305 +-
 net/mac80211/util.c                                |  345 +-
 net/mac80211/vht.c                                 |   64 +-
 net/wireless/core.c                                |    3 +-
 net/wireless/core.h                                |    7 +-
 net/wireless/ethtool.c                             |   12 +-
 net/wireless/mlme.c                                |  155 +-
 net/wireless/nl80211.c                             |  530 +-
 net/wireless/nl80211.h                             |    9 +-
 net/wireless/rdev-ops.h                            |   66 +-
 net/wireless/sme.c                                 |    2 +-
 net/wireless/trace.h                               |  203 +-
 net/wireless/util.c                                |   57 +
 179 files changed, 9964 insertions(+), 7669 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76_connac2_mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h
