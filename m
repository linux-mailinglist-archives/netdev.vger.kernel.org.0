Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDF94D61B4
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 13:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348619AbiCKMlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 07:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbiCKMlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 07:41:39 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9BC1A58D5;
        Fri, 11 Mar 2022 04:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=Odf2LlNBZpX3L/1nkTsnnZLonaPm8773/EfQ80gWtjY=; t=1647002435; x=1648212035; 
        b=VchM/Vpb246pTdxP3rkqx9WF0MWfNqGrt79CYgsT/ly7IB0W8RLmQb09RqYjtE7H/ypTg8XqCdw
        lHUgfs+XPRWpq94m6gvYjCw6BYoEIVa4iAvj5fH1xqcGjj7jlb8GUcajAxuJo8Pqs6PuOuWYEX2pC
        Zgud/+aOMQ6Ey3h45Y6XZMQMYHUl9Kd+7zMJo6a2aAuB6sVUfQU0orQK2mDrnw8p0eBhQiFxIzGHX
        m7Eym6lQgXjUqqijk7CRfV1pI0LhS0Jz4i1qPnfFdgYSbgSEUdEQ+ce9A+4+FZb8A7tqdFEwhaHiX
        fGwlb0mg7foqsj/o/VqgwVow17irrUKlqJOw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nSeZN-00Bu9Y-9C;
        Fri, 11 Mar 2022 13:40:33 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-next-2022-03-11
Date:   Fri, 11 Mar 2022 13:40:28 +0100
Message-Id: <20220311124029.213470-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here's another (almost certainly final for 5.8) set of
patches for net-next.

Note that there's a minor merge conflict - Stephen already
noticed it and resolved it here:
https://lore.kernel.org/linux-wireless/20220217110903.7f58acae@canb.auug.org.au/

I didn't resolve it explicitly by merging back since it's
such a simple conflict, but let me know if you want me to
do that (now or in the future).


Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit b96a79253fff1cd2c928b379eadd8c7a6f8055e1:

  Merge tag 'wireless-next-2022-02-11' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next (2022-02-11 14:19:23 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2022-03-11

for you to fetch changes up to 7d352ccf1e9935b5222ca84e8baeb07a0c8f94b9:

  mac80211: Add support to trigger sta disconnect on hardware restart (2022-03-11 11:59:19 +0100)

----------------------------------------------------------------
brcmfmac
 * add BCM43454/6 support

rtw89
 * add support for 160 MHz channels and 6 GHz band
 * hardware scan support

iwlwifi
 * support UHB TAS enablement via BIOS
 * remove a bunch of W=1 warnings
 * add support for channel switch offload
 * support 32 Rx AMPDU sessions in newer devices
 * add support for a couple of new devices
 * add support for band disablement via BIOS

mt76
 * mt7915 thermal management improvements
 * SAR support for more mt76 drivers
 * mt7986 wmac support on mt7915

ath11k
 * debugfs interface to configure firmware debug log level
 * debugfs interface to test Target Wake Time (TWT)
 * provide 802.11ax High Efficiency (HE) data via radiotap

ath9k
 * use hw_random API instead of directly dumping into random.c

wcn36xx
 * fix wcn3660 to work on 5 GHz band

ath6kl
 * add device ID for WLU5150-D81

cfg80211/mac80211
 * initial EHT (from 802.11be) support
   (EHT rates, 320 MHz, larger block-ack)
 * support disconnect on HW restart

----------------------------------------------------------------
Abhishek Naik (2):
      iwlwifi: nvm: Correct HE capability
      iwlwifi: tlc: Add logs in rs_fw_rate_init func to print TLC configuration

Andrei Otcheretianski (1):
      iwlwifi: pcie: make sure iwl_rx_packet_payload_len() will not underflow

André Apitzsch (1):
      ath6kl: add device ID for WLU5150-D81

Anilkumar Kolli (1):
      ath11k: Fix uninitialized symbol 'rx_buf_sz'

Ayala Barazani (4):
      iwlwifi: mvm: allow enabling UHB TAS in the USA via ACPI setting
      iwlwifi: mvm: Disable WiFi bands selectively with BIOS
      iwlwifi: mvm: add a flag to reduce power command.
      iwlwifi: Configure FW debug preset via module param.

Baochen Qiang (2):
      ath11k: Fix missing rx_desc_get_ldpc_support in wcn6855_ops
      ath11k: Fix frames flush failure caused by deadlock

Beni Lev (1):
      mac80211_hwsim: Add debugfs to control rx status RSSI

Bixuan Cui (1):
      iwlwifi: mvm: rfi: use kmemdup() to replace kzalloc + memcpy

Bjoern A. Zeeb (2):
      iwlwifi: de-const properly where needed
      iwlwifi: propagate (const) type qualifier

Bo Jiao (3):
      mt76: mt7915: Fix channel state update error issue
      mt76: mt7915: add support for MT7986
      mt76: mt7915: introduce band_idx in mt7915_phy

Brian Norris (1):
      Revert "ath: add support for special 0x0 regulatory domain"

Bryan O'Donoghue (1):
      wcn36xx: Differentiate wcn3660 from wcn3620

Cai Huoqing (1):
      iwlwifi: Make use of the helper macro LIST_HEAD()

Carl Huang (1):
      ath11k: fix invalid m3 buffer address

Chad Monroe (1):
      mt76: connac: adjust wlan_idx size from u8 to u16

Changcheng Deng (1):
      mt76: mt7915: use min_t() to make code cleaner

Chin-Yen Lee (2):
      rtw88: 8822ce: add support for TX/RX 1ss mode
      rtw89: add tx_wake notify for low ps mode

Ching-Te Ku (5):
      rtw88: coex: Improve WLAN throughput when HFP COEX
      rtw88: coex: update BT PTA counter regularly
      rtw88: coex: Add WLAN MIMO power saving for Bluetooth gaming controller
      rtw88: coex: Add C2H/H2C handshake with BT mailbox for asking HID Info
      rtw88: coex: Update rtl8822c COEX version to 22020720

Christian Lamparter (5):
      carl9170: replace GFP_ATOMIC in ampdu_action, it can sleep
      carl9170: devres-ing hwrng_register usage
      carl9170: devres-ing input_allocate_device
      carl9170: replace bitmap_zalloc with devm_bitmap_zalloc
      carl9170: devres ar->survey_info

Christophe JAILLET (1):
      mac80211: Use GFP_KERNEL instead of GFP_ATOMIC when possible

Colin Ian King (5):
      carl9170: fix missing bit-wise or operator for tx_params
      iwlwifi: Fix -EIO error code that is never returned
      ath9k: make array voice_priority static const
      bcma: gpio: remove redundant re-assignment of chip->owner
      brcmfmac: make the read-only array pktflags static const

Dan Carpenter (3):
      wcn36xx: Uninitialized variable in wcn36xx_change_opchannel()
      iwlwifi: mvm: fix off by one in iwl_mvm_stat_iterator_all_macs()
      iwlwifi: mvm: Fix an error code in iwl_mvm_up()

Deren Wu (2):
      mt76: mt7921s: fix missing fc type/sub-type for 802.11 pkts
      mt76: mt7615: fix compiler warning on frame size

Double Lo (1):
      MAINTAINERS: brcm80211: remove Infineon maintainers

Emmanuel Grumbach (3):
      iwlwifi: mvm: starting from 22000 we have 32 Rx AMPDU sessions
      iwlwifi: don't dump_stack() when we get an unexpected interrupt
      iwlwifi: mvm: always remove the session protection after association

Felix Fietkau (2):
      mt76: improve signal strength reporting
      mt76: fix dfs state issue with 160 MHz channels

Francesco Magliocca (1):
      ath10k: fix pointer arithmetic error in trace call

Golan Ben Ami (1):
      iwlwifi: bump FW API to 70 for AX devices

Gregory Greenman (1):
      iwlwifi: mvm: rfi: handle deactivation notification

Gustavo A. R. Silva (13):
      brcmfmac: Replace zero-length arrays with flexible-array members
      rtw89: core.h: Replace zero-length array with flexible-array member
      ath10k: Replace zero-length array with flexible-array member
      ath11k: Replace zero-length arrays with flexible-array members
      ath6kl: Replace zero-length arrays with flexible-array members
      ath: Replace zero-length arrays with flexible-array members
      carl9170: Replace zero-length arrays with flexible-array members
      ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_begin_scan_cmd
      ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_start_scan_cmd
      ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_channel_list_reply
      ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_connect_event
      ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_disconnect_event
      ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_aplist_event

Ilan Peer (16):
      mac80211_hwsim: Add custom regulatory for 6GHz
      ieee80211: Add EHT (802.11be) definitions
      cfg80211: Add data structures to capture EHT capabilities
      cfg80211: add NO-EHT flag to regulatory
      cfg80211: Support configuration of station EHT capabilities
      mac80211: Support parsing EHT elements
      mac80211: Add initial support for EHT and 320 MHz channels
      mac80211: Add EHT capabilities to association/probe request
      mac80211: Handle station association response with EHT
      mac80211: Add support for storing station EHT capabilities
      mac80211_hwsim: Advertise support for EHT capabilities
      iwlwifi: mvm: Correctly set fragmented EBS
      iwlwifi: scan: Modify return value of a function
      iwlwifi: mvm: Passively scan non PSC channels only when requested so
      iwlwifi: mvm: Unify the scan iteration functions
      iwlwifi: mvm: Consider P2P GO operation during scan

Jason A. Donenfeld (1):
      ath9k: use hw_random API instead of directly dumping into random.c

Jia Ding (1):
      cfg80211: Add support for EHT 320 MHz channel width

Jiri Kosina (1):
      rtw89: fix RCU usage in rtw89_core_txq_push()

Johan Almbladh (1):
      mt76: mt7915: fix injected MPDU transmission to not use HW A-MSDU

Johannes Berg (39):
      ieee80211: use tab to indent struct ieee80211_neighbor_ap_info
      nl80211: use RCU to read regdom in reg get/dump
      ieee80211: add helper to check HE capability element size
      mac80211: parse only HE capability elements with valid size
      nl80211: accept only HE capability elements with valid size
      mac80211_hwsim: check TX and STA bandwidth
      mac80211_hwsim: don't shadow a global variable
      iwlwifi: prefer WIDE_ID() over iwl_cmd_id()
      iwlwifi: mvm: fw: clean up hcmd struct creation
      iwlwifi: make iwl_fw_lookup_cmd_ver() take a cmd_id
      iwlwifi: fix various more -Wcast-qual warnings
      iwlwifi: avoid void pointer arithmetic
      iwlwifi: mvm: refactor iwl_mvm_sta_rx_agg()
      iwlwifi: mvm: support new BAID allocation command
      iwlwifi: mvm: align locking in D3 test debugfs
      iwlwifi: mvm: support v3 of station HE context command
      iwlwifi: fw: make dump_start callback void
      iwlwifi: move symbols into a separate namespace
      iwlwifi: dbg-tlv: clean up iwl_dbg_tlv_update_drams()
      iwlwifi: avoid variable shadowing
      iwlwifi: make some functions friendly to sparse
      iwlwifi: mei: avoid -Wpointer-arith and -Wcast-qual warnings
      iwlwifi: pcie: adjust to Bz completion descriptor
      iwlwifi: drv: load tlv debug data earlier
      iwlwifi: eeprom: clean up macros
      iwlwifi: remove unused macros
      iwlwifi: debugfs: remove useless double condition
      iwlwifi: mei: use C99 initializer for device IDs
      iwlwifi: mvm: make iwl_mvm_reconfig_scd() static
      iwlwifi: make iwl_txq_dyn_alloc_dma() return the txq
      iwlwifi: remove command ID argument from queue allocation
      iwlwifi: mvm: remove iwl_mvm_disable_txq() flags argument
      iwlwifi: support new queue allocation command
      iwlwifi: api: remove ttl field from TX command
      iwlwifi: mvm: update BAID allocation command again
      rtw89: fix HE PHY bandwidth capability
      iwlwifi: mvm: remove cipher scheme support
      iwlwifi: pcie: fix SW error MSI-X mapping
      iwlwifi: use 4k queue size for Bz A-step

John Crispin (2):
      ath11k: add WMI calls to manually add/del/pause/resume TWT dialogs
      ath11k: add debugfs for TWT debug calls

Kalle Valo (7):
      ath11k: pci: fix crash on suspend if board file is not found
      ath11k: mhi: use mhi_sync_power_up()
      Merge tag 'iwlwifi-next-for-kalle-2022-02-18' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge tag 'mt76-for-kvalo-2022-02-24' of https://github.com/nbd168/wireless
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2022-03-10' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Karthikeyan Kathirvel (1):
      ath11k: fix destination monitor ring out of sync

Kees Cook (1):
      iwlwifi: dbg_ini: Split memcpy() to avoid multi-field write

Linus Lüssing (1):
      mac80211: fix potential double free on mesh join

Lorenzo Bianconi (6):
      mt76: mt7615: introduce SAR support
      mt76: fix endianness errors in reverse_frag0_hdr_trans
      mt76: mt7915: fix endianness warnings in mt7915_debugfs_rx_fw_monitor
      mt76: mt7915: fix endianness warnings in mt7915_mac_tx_free()
      mt76: mt7921: fix injected MPDU transmission to not use HW A-MSDU
      MAINTAINERS: add devicetree bindings entry for mt76

Lu Jicong (1):
      rtlwifi: rtl8192ce: remove duplicated function '_rtl92ce_phy_set_rf_sleep'

Luca Coelho (7):
      iwlwifi: mvm: don't iterate unadded vifs when handling FW SMPS req
      iwlwifi: read and print OTP minor version
      iwlwifi: remove unused DC2DC_CONFIG_CMD definitions
      iwlwifi: mvm: don't send BAID removal to the FW during hw_restart
      iwlwifi: fix small doc mistake for iwl_fw_ini_addr_val
      iwlwifi: bump FW API to 71 for AX devices
      iwlwifi: bump FW API to 72 for AX devices

Lv Ruyi (CGEL ZTE) (1):
      ath11k: remove unneeded flush_workqueue

Matt Chen (1):
      iwlwifi: acpi: move ppag code from mvm to fw/acpi

Matti Gottlieb (1):
      iwlwifi: pcie: Adapt rx queue write pointer for Bz family

MeiChia Chiu (2):
      mt76: mt7915: fix the muru tlv issue
      mac80211: correct legacy rates check in ieee80211_calc_rx_airtime

Miaoqian Lin (1):
      ath10k: Fix error handling in ath10k_setup_msa_resources

Mike Golant (1):
      iwlwifi: add support for BZ-U and BZ-L HW

Minghao Chi (CGEL ZTE) (3):
      wcn36xx: use struct_size over open coded arithmetic
      iwlwifi/fw: use struct_size over open coded arithmetic
      iwlwifi: dvm: use struct_size over open coded arithmetic

Miri Korenblit (4):
      iwlwifi: mvm: add support for CT-KILL notification version 2
      iwlwifi: mvm: use debug print instead of WARN_ON()
      iwlwifi: mvm: refactor setting PPE thresholds in STA_HE_CTXT_CMD
      iwlwifi: mvm: move only to an enabled channel

Mordechay Goodstein (11):
      ieee80211: add EHT 1K aggregation definitions
      mac80211: calculate max RX NSS for EHT mode
      mac80211: parse AddBA request with extended AddBA element
      iwlwifi: cfg: add support for 1K BA queue
      iwlwifi: dbg: add infra for tracking free buffer size
      iwlwifi: mvm: only enable HE DCM if we also support TX
      iwlwifi: advertise support for HE - DCM BPSK RX/TX
      iwlwifi: mvm: add additional info for boot info failures
      iwlwifi: mvm: add additional info for boot info failures
      iwlwifi: dbg: in sync mode don't call schedule
      iwlwifi: dbg: check trigger data before access

Mukesh Sisodiya (7):
      iwlwifi: yoyo: add IMR DRAM dump support
      iwlwifi: yoyo: Avoid using dram data if allocation failed
      iwlwifi: yoyo: support dump policy for the dump size
      iwlwifi: yoyo: send hcmd to fw after dump collection completes.
      iwlwifi: yoyo: disable IMR DRAM region if IMR is disabled
      iwlwifi: mvm: add support for IMR based on platform
      iwlwifi: yoyo: dump IMR DRAM only for HW and FW error

Nathan Errera (1):
      iwlwifi: mvm: offload channel switch timing to FW

Nicolas Cavallari (3):
      mt76: mt7915e: Fix degraded performance after temporary overheat
      mt76: mt7915e: Add a hwmon attribute to get the actual throttle state.
      mt76: mt7915e: Enable thermal management by default

Peter Chiu (2):
      dt-bindings: net: wireless: mt76: document bindings for MT7986
      mt76: mt7915: initialize smps mode in mt7915_mcu_sta_rate_ctrl_tlv()

Ping-Ke Shih (19):
      rtw89: add 6G support to rate adaptive mechanism
      rtw89: declare if chip support 160M bandwidth
      rtw89: handle TX/RX 160M bandwidth
      rtw88: change rtw_info() to proper message level
      rtw89: get channel parameters of 160MHz bandwidth
      rtw89: declare HE capabilities in 6G band
      rtw89: 8852c: add 8852c empty files
      rtw89: pci: add struct rtw89_pci_info
      rtw89: pci: add V1 of PCI channel address
      rtw89: pci: use a struct to describe all registers address related to DMA channel
      rtw89: read chip version depends on chip ID
      rtw89: add power_{on/off}_func
      rtw89: add hci_func_en_addr to support variant generation
      rtw89: add chip_info::{h2c,c2h}_reg to support more chips
      rtw89: add page_regs to handle v1 chips
      rtw89: 8852c: add chip::dle_mem
      rtw89: support DAV efuse reading operation
      rtw89: 8852c: process efuse of phycap
      rtw89: 8852c: process logic efuse map

Po Hao Huang (1):
      rtw89: 8852a: add ieee80211_ops::hw_scan

Pradeep Kumar Chitrapu (3):
      ath11k: switch to using ieee80211_tx_status_ext()
      ath11k: decode HE status tlv
      ath11k: translate HE status to radiotap format

Rameshkumar Sundaram (1):
      ath11k: Invalidate cached reo ring entry before accessing it

Rotem Saado (3):
      iwlwifi: yoyo: fix DBGI_SRAM ini dump header.
      iwlwifi: yoyo: fix DBGC allocation flow
      iwlwifi: yoyo: remove DBGI_SRAM address reset writing

Ryder Lee (1):
      mt76: mt7915: check band idx for bcc event

Seevalamuthu Mariappan (2):
      ath11k: Add debugfs interface to configure firmware debug log level
      ath11k: Handle failure in qmi firmware ready

Shayne Chen (1):
      mt76: mt7915: fix potential memory leak of fw monitor packets

Sriram R (1):
      nl80211: add support for 320MHz channel limitation

Takashi Iwai (1):
      iwlwifi: mvm: Don't call iwl_mvm_sta_from_mac80211() with NULL sta

Tom Rix (1):
      bcma: cleanup comments

Veerendranath Jakkam (2):
      nl80211: add EHT MCS support
      nl80211: fix typo of NL80211_IF_TYPE_OCB in documentation

Venkateswara Naralasetty (5):
      ath11k: Rename ath11k_ahb_ext_irq_config
      ath11k: fix kernel panic during unload/load ath11k modules
      ath11k: fix WARN_ON during ath11k_mac_update_vif_chan
      ath11k: fix radar detection in 160 Mhz
      ath11k: add dbring debug support

Wan Jiabing (1):
      mt76: mt7915: simplify conditional

Wang Qing (1):
      cw1200: use time_is_after_jiffies() instead of open coding it

Wen Gong (3):
      ath11k: fix uninitialized rate_idx in ath11k_dp_tx_update_txcompl()
      ath11k: add ath11k_qmi_free_resource() for recovery
      ath11k: configure RDDM size to mhi for recovery by firmware

Xiang wangx (1):
      iwlwifi: Fix syntax errors in comments

Yaara Baruch (2):
      iwlwifi: pcie: add support for MS devices
      iwlwifi: pcie: iwlwifi: fix device id 7F70 struct

Yang Li (2):
      wcn36xx: clean up some inconsistent indenting
      mt76: mt7615: Fix assigning negative values to unsigned variable

Yi-Tang Chiu (1):
      rtw89: Limit the CFO boundaries of x'tal value

Yihao Han (1):
      mac80211: replace DEFINE_SIMPLE_ATTRIBUTE with DEFINE_DEBUGFS_ATTRIBUTE

Youghandhar Chintala (1):
      mac80211: Add support to trigger sta disconnect on hardware restart

Zhao, Jiaqing (1):
      brcmfmac: Add BCM43454/6 support

Zong-Zhe Yang (5):
      rtw89: make rfk helpers common across chips
      rtw89: refine naming of rfk helpers with prefix
      rtw89: extend subband for 6G band
      rtw89: phy: handle txpwr lmt/lmt_ru of 6G band
      rtw89: phy: handle txpwr lmt/lmt_ru of 160M bandwidth

 .../bindings/net/wireless/mediatek,mt76.yaml       |   33 +-
 MAINTAINERS                                        |    4 +-
 drivers/bcma/driver_chipcommon.c                   |    2 +-
 drivers/bcma/driver_chipcommon_pmu.c               |    6 +-
 drivers/bcma/driver_gpio.c                         |    1 -
 drivers/bcma/driver_pci_host.c                     |    6 +-
 drivers/bcma/main.c                                |    4 +-
 drivers/bcma/sprom.c                               |    4 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |    2 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |    2 +-
 drivers/net/wireless/ath/ath10k/swap.h             |    2 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |    6 +-
 drivers/net/wireless/ath/ath11k/ce.h               |    2 +-
 drivers/net/wireless/ath/ath11k/core.c             |    7 +-
 drivers/net/wireless/ath/ath11k/core.h             |   11 +-
 drivers/net/wireless/ath/ath11k/dbring.c           |   19 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |  509 ++++
 drivers/net/wireless/ath/ath11k/debugfs.h          |  180 +-
 drivers/net/wireless/ath/ath11k/dp.h               |   13 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  166 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |   30 +-
 drivers/net/wireless/ath/ath11k/hal_desc.h         |    1 +
 drivers/net/wireless/ath/ath11k/hal_rx.c           |  471 +++-
 drivers/net/wireless/ath/ath11k/hal_rx.h           |  135 +-
 drivers/net/wireless/ath/ath11k/hw.c               |    7 +
 drivers/net/wireless/ath/ath11k/hw.h               |    1 +
 drivers/net/wireless/ath/ath11k/mac.c              |   64 +-
 drivers/net/wireless/ath/ath11k/mhi.c              |    4 +-
 drivers/net/wireless/ath/ath11k/pci.c              |   10 +
 drivers/net/wireless/ath/ath11k/qmi.c              |   12 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |    1 +
 drivers/net/wireless/ath/ath11k/rx_desc.h          |    6 +-
 drivers/net/wireless/ath/ath11k/spectral.c         |    2 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  300 ++-
 drivers/net/wireless/ath/ath11k/wmi.h              |  132 +
 drivers/net/wireless/ath/ath6kl/usb.c              |    1 +
 drivers/net/wireless/ath/ath6kl/wmi.c              |   22 +-
 drivers/net/wireless/ath/ath6kl/wmi.h              |   38 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |    3 +-
 drivers/net/wireless/ath/ath9k/mci.c               |    2 +-
 drivers/net/wireless/ath/ath9k/rng.c               |   72 +-
 drivers/net/wireless/ath/carl9170/carl9170.h       |    1 -
 drivers/net/wireless/ath/carl9170/fwdesc.h         |    2 +-
 drivers/net/wireless/ath/carl9170/main.c           |   61 +-
 drivers/net/wireless/ath/carl9170/wlan.h           |    2 +-
 drivers/net/wireless/ath/regd.c                    |   10 +-
 drivers/net/wireless/ath/spectral_common.h         |    4 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   15 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |    2 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c            |    4 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |    1 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |    2 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |    3 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |    1 +
 .../wireless/broadcom/brcm80211/brcmfmac/xtlv.h    |    2 +-
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |    1 +
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   55 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |    1 +
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c        |    7 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  229 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |   39 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   13 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/config.h |   33 -
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |  148 +-
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |   37 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |   19 +-
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    |   34 +
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |  127 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |   52 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/phy.h    |   16 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |   27 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rfi.h    |   10 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |    6 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |    7 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h    |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  331 ++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |    5 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   36 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.c        |    7 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |   14 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |    5 +-
 drivers/net/wireless/intel/iwlwifi/fw/paging.c     |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |   22 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |    5 +-
 drivers/net/wireless/intel/iwlwifi/fw/smem.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |   12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   17 +-
 .../wireless/intel/iwlwifi/iwl-context-info-gen3.h |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |    3 +
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   72 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h   |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  181 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h       |    2 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-read.c   |   12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |   30 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |   18 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h |    5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   43 +-
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c    |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   13 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |   12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   59 +-
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |   10 +-
 drivers/net/wireless/intel/iwlwifi/mei/net.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   29 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   18 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |   25 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |   24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  406 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   50 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  361 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   17 +-
 .../net/wireless/intel/iwlwifi/mvm/offloading.c    |    3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   34 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |   43 +-
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c     |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c       |   13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   32 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |    2 -
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  294 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  313 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |    3 +
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |   11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   40 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |    5 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   38 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   46 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  112 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   51 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |    4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   14 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      |  101 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.h      |   21 +-
 drivers/net/wireless/mac80211_hwsim.c              |  410 ++-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   34 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |    5 -
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |   14 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   42 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   24 +
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |   15 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |    5 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |    8 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |    2 -
 drivers/net/wireless/mediatek/mt76/mt7915/Kconfig  |   10 +
 drivers/net/wireless/mediatek/mt76/mt7915/Makefile |    1 +
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   12 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |   28 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |   85 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |   13 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  105 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  273 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   21 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  131 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |    9 +
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |  132 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   43 +
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |  289 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c    | 1210 +++++++++
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |   43 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   46 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    |    3 +
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |    8 +-
 drivers/net/wireless/mediatek/mt76/testmode.c      |    5 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/phy.c   |   32 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |  298 ++-
 drivers/net/wireless/realtek/rtw88/coex.h          |    5 +
 drivers/net/wireless/realtek/rtw88/debug.c         |    6 +-
 drivers/net/wireless/realtek/rtw88/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw88/fw.c            |   17 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |    9 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    8 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   44 +-
 drivers/net/wireless/realtek/rtw88/main.h          |   48 +-
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |    1 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |    3 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |    5 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   47 +-
 drivers/net/wireless/realtek/rtw88/sar.c           |    8 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |    2 +-
 drivers/net/wireless/realtek/rtw89/core.c          |  241 +-
 drivers/net/wireless/realtek/rtw89/core.h          |  142 +-
 drivers/net/wireless/realtek/rtw89/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw89/efuse.c         |  160 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |  539 +++-
 drivers/net/wireless/realtek/rtw89/fw.h            |  351 +++
 drivers/net/wireless/realtek/rtw89/mac.c           |  270 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |   50 +
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   67 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |  200 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |   76 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |  266 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |   60 +
 drivers/net/wireless/realtek/rtw89/reg.h           |  122 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   37 +
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c  |   62 +-
 .../wireless/realtek/rtw89/rtw8852a_rfk_table.c    | 2744 ++++++++++----------
 .../wireless/realtek/rtw89/rtw8852a_rfk_table.h    |   49 +-
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c     |    7 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |  479 ++++
 drivers/net/wireless/realtek/rtw89/rtw8852c.h      |   76 +
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c     |   43 +
 drivers/net/wireless/st/cw1200/queue.c             |    3 +-
 include/linux/ieee80211.h                          |  339 ++-
 include/net/cfg80211.h                             |   87 +-
 include/net/mac80211.h                             |   16 +
 include/uapi/linux/nl80211.h                       |   97 +-
 net/mac80211/Makefile                              |    3 +-
 net/mac80211/agg-rx.c                              |   20 +-
 net/mac80211/airtime.c                             |    4 +-
 net/mac80211/cfg.c                                 |   11 +-
 net/mac80211/chan.c                                |    5 +-
 net/mac80211/eht.c                                 |   76 +
 net/mac80211/ieee80211_i.h                         |   21 +
 net/mac80211/main.c                                |   14 +-
 net/mac80211/mesh.c                                |    7 +-
 net/mac80211/mlme.c                                |  184 +-
 net/mac80211/util.c                                |  271 +-
 net/mac80211/vht.c                                 |   34 +-
 net/wireless/chan.c                                |   91 +-
 net/wireless/nl80211.c                             |  137 +-
 net/wireless/reg.c                                 |    6 +
 net/wireless/util.c                                |  131 +
 231 files changed, 13672 insertions(+), 3867 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/soc.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852c.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852c.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852ce.c
 create mode 100644 net/mac80211/eht.c

