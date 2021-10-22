Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE8C437361
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 09:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhJVIBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 04:01:17 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:28917 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbhJVIBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 04:01:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634889539; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=3OyfiDeFNVsUeuQZXK1S4BAHmd9PMTB+l2L7/7vv6Xs=; b=rJdfMMMibR0jt29HwBHGiCwiXF/MPMlQiaHkXXDeLzw8hzk2/ZCEYOl2H4nsqRx0eV6HBGZN
 8020+UuYPk/4+EdMEy8E+YkZSw+lNTwQeszNnQm3lw+REMsSzgHTlWFLQD22yf3lZhyfn7M/
 JFkYeW21LYm81aR8XtZOok+dUm4=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 61726f3514914866fa42887d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 22 Oct 2021 07:58:45
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0E679C4360D; Fri, 22 Oct 2021 07:58:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.1 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,TO_NO_BRKTS_PCNT autolearn=no
        autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D00D8C43460;
        Fri, 22 Oct 2021 07:58:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org D00D8C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2021-10-22
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20211022075845.0E679C4360D@smtp.codeaurora.org>
Date:   Fri, 22 Oct 2021 07:58:45 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 0182d0788cd66292cb1698b48dd21887d93c68ed:

  octeontx2-pf: Simplify the receive buffer size calculation (2021-10-10 11:46:54 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2021-10-22

for you to fetch changes up to 9bc0b1aa8b7e54d62082749fc5404660690d17ce:

  Merge tag 'mt76-for-kvalo-2021-10-20' of https://github.com/nbd168/wireless (2021-10-20 19:08:25 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.16

Second set of patches for v5.16 and this time we have a big one. We
have the new Realtek driver rtw89 with over 90 kLOC and also over 150
patches for mt76. ath9k also got few new small features. And the usual
cleanups and fixes all over.

Major changes:

rtw89

* new Realtek 802.11ax driver

* supports Realtek 8852AE 802.11ax 2x2 chip

ath9k

* add option to reset the wifi chip via debugfs

* convert Device Tree bindings to the json-schema

* support Device Tree ieee80211-freq-limit property to limit channels

mt76

* mt7921 aspm support

* mt7921 testmode support

* mt7915 LED support

* mt7921 6GHz band support

* support for eeprom data in DT

* mt7915 TWT support

* mt7921s SDIO support

----------------------------------------------------------------
Baochen Qiang (3):
      ath11k: Handle MSI enablement during rmmod and SSR
      ath11k: Change number of TCL rings to one for QCA6390
      ath11k: Identify DFS channel when sending scan channel list command

Ben Greear (9):
      mt76: mt7915: fix he_mcs capabilities for 160mhz
      mt76: mt7915: fix potential NPE in TXS processing
      mt76: mt7915: fix hwmon temp sensor mem use-after-free
      mt76: mt7915: add ethtool stats support
      mt76: mt7915: add tx stats gathered from tx-status callbacks
      mt76: mt7915: add some per-station tx stats to ethtool
      mt76: mt7915: add tx mu/su counters to mib
      mt76: mt7915: add more MIB registers
      mt76: mt7915: add mib counters to ethtool stats

Bo Jiao (2):
      mt76: mt7915: fix calling mt76_wcid_alloc with incorrect parameter
      mt76: mt7915: adapt new firmware to update BA winsize for Rx session

Christian Lamparter (2):
      dt-bindings: net: wireless: qca,ath9k: convert to the json-schema
      ath9k: support DT ieee80211-freq-limit property to limit channels

Christophe JAILLET (2):
      wireless: Remove redundant 'flush_workqueue()' calls
      mt76: switch from 'pci_' to 'dma_' API

Colin Ian King (6):
      ath11k: Fix spelling mistake "incompaitiblity" -> "incompatibility"
      ath11k: Remove redundant assignment to variable fw_size
      rtlwifi: rtl8192ee: Remove redundant initialization of variable version
      mt7601u: Remove redundant initialization of variable ret
      rtw89: Fix two spelling mistakes in debug messages
      rtw89: Remove redundant check of ret after call to rtw89_mac_enable_bb_rf

Dan Carpenter (4):
      b43legacy: fix a lower bounds test
      b43: fix a lower bounds test
      ath9k: fix an IS_ERR() vs NULL check
      mt76: mt7915: fix info leak in mt7915_mcu_set_pre_cal()

Daniel Golle (2):
      mt76: support reading EEPROM data embedded in fdt
      dt: bindings: net: mt76: add eeprom-data property

Deren Wu (4):
      mt76: mt7921: Fix out of order process by invalid event pkt
      mt76: mt7921: Add mt7922 support
      mt76: mt7921: fix dma hang in rmmod
      mt76: mt7921: add delay config for sched scan

Felix Fietkau (4):
      mt76: mt7615: fix skb use-after-free on mac reset
      mt76: mt7915: fix WMM index on DBDC cards
      mt76: disable BH around napi_schedule() calls
      mt76: do not access 802.11 header in ccmp check for 802.3 rx skbs

Gustavo A. R. Silva (1):
      ath11k: Use kcalloc() instead of kzalloc()

Jakub Kicinski (14):
      wireless: use eth_hw_addr_set()
      wireless: use eth_hw_addr_set() instead of ether_addr_copy()
      wireless: use eth_hw_addr_set() for dev->addr_len cases
      ath6kl: use eth_hw_addr_set()
      wil6210: use eth_hw_addr_set()
      atmel: use eth_hw_addr_set()
      brcmfmac: prepare for const netdev->dev_addr
      airo: use eth_hw_addr_set()
      ipw2200: prepare for const netdev->dev_addr
      hostap: use eth_hw_addr_set()
      wilc1000: use eth_hw_addr_set()
      ray_cs: use eth_hw_addr_set()
      wl3501_cs: use eth_hw_addr_set()
      zd1201: use eth_hw_addr_set()

Johannes Berg (4):
      iwlwifi: mvm: reset PM state on unsuccessful resume
      iwlwifi: pnvm: don't kmemdup() more than we have
      iwlwifi: pnvm: read EFI data only if long enough
      iwlwifi: cfg: set low-latency-xtal for some integrated So devices

Jonas Dreßler (7):
      mwifiex: Read a PCI register after writing the TX ring write pointer
      mwifiex: Try waking the firmware until we get an interrupt
      mwifiex: Don't log error on suspend if wake-on-wlan is disabled
      mwifiex: Log an error on command failure during key-material upload
      mwifiex: Fix an incorrect comment
      mwifiex: Send DELBA requests according to spec
      mwifiex: Deactive host sleep using HSCFG after it was activated manually

Kalle Valo (2):
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'mt76-for-kvalo-2021-10-20' of https://github.com/nbd168/wireless

Leon Yen (2):
      mt76: connac: fix mt76_connac_gtk_rekey_tlv usage
      mt76: connac: fix GTK rekey offload failure on WPA mixed mode

Linus Lüssing (2):
      ath9k: add option to reset the wifi chip via debugfs
      ath9k: Fix potential interrupt storm on queue reset

Lorenzo Bianconi (64):
      mt76: mt7921: fix endianness in mt7921_mcu_tx_done_event
      mt76: mt7921: avoid unnecessary spin_lock/spin_unlock in mt7921_mcu_tx_done_event
      mt76: mt7915: fix endianness warning in mt7915_mac_add_txs_skb
      mt76: mt7921: fix endianness warning in mt7921_update_txs
      mt76: mt7615: fix endianness warning in mt7615_mac_write_txwi
      mt76: mt7921: fix survey-dump reporting
      mt76: mt76x02: fix endianness warnings in mt76x02_mac.c
      mt76: mt7921: introduce testmode support
      mt76: mt7921: get rid of monitor_vif
      mt76: mt7921: get rid of mt7921_mac_set_beacon_filter
      mt76: mt7921: introduce mt7921_mcu_set_beacon_filter utility routine
      mt76: overwrite default reg_ops if necessary
      mt76: mt7615: move mt7615_mcu_set_p2p_oppps in mt76_connac module
      mt76: mt7921: fix endianness warnings in mt7921_mac_decode_he_mu_radiotap
      mt76: mt7915: introduce bss coloring support
      mt76: mt7915: improve code readability in mt7915_mcu_sta_bfer_ht
      mt76: mt7921: move mt7921_queue_rx_skb to mac.c
      mt76: mt7921: always wake device if necessary in debugfs
      mt76: mt7921: update mib counters dumping phy stats
      mt76: mt7921: start reworking tx rate reporting
      mt76: mt7921: add support for tx status reporting
      mt76: mt7921: report tx rate directly from tx status
      mt76: mt7921: remove mcu rate reporting code
      mt76: mt7921: remove mt7921_sta_stats
      mt76: mt7915: honor all possible error conditions in mt7915_mcu_init()
      mt76: mt7915: fix possible infinite loop release semaphore
      mt76: connac: set 6G phymode in mt76_connac_get_phy_mode{,v2}
      mt76: connac: enable 6GHz band for hw scan
      mt76: connac: add 6GHz support to mt76_connac_mcu_set_channel_domain
      mt76: connac: set 6G phymode in single-sku support
      mt76: connac: add 6GHz support to mt76_connac_mcu_sta_tlv
      mt76: connac: add 6GHz support to mt76_connac_mcu_uni_add_bss
      mt76: connac: enable hw amsdu @ 6GHz
      mt76: add 6GHz support
      mt76: mt7921: add 6GHz support
      mt76: introduce packet_id idr
      mt76: remove mt76_wcid pointer from mt76_tx_status_check signature
      mt76: substitute sk_buff_head status_list with spinlock_t status_lock
      mt76: schedule status timeout at dma completion
      mt76: introduce __mt76_mcu_send_firmware routine
      mt76: mt7915: introduce __mt7915_get_tsf routine
      mt76: mt7915: introduce mt7915_mcu_twt_agrt_update mcu command
      mt76: mt7915: introduce mt7915_mac_add_twt_setup routine
      mt76: mt7915: enable twt responder capability
      mt76: mt7915: add twt_stats knob in debugfs
      mt76: debugfs: improve queue node readability
      mt76: connac: fix possible NULL pointer dereference in mt76_connac_get_phy_mode_v2
      mt76: rely on phy pointer in mt76_register_debugfs_fops routine signature
      mt76: mt7915: introduce mt76 debugfs sub-dir for ext-phy
      mt76: mt7915: improve code readability for xmit-queue handler
      mt76: sdio: export mt76s_alloc_rx_queue and mt76s_alloc_tx routines
      mt76: mt7915: remove dead code in debugfs code
      mt76: sdio: move common code in mt76_sdio module
      mt76: sdio: introduce parse_irq callback
      mt76: move mt76_sta_stats in mt76.h
      mt76: move mt76_ethtool_worker_info in mt76 module
      mt76: mt7915: run mt7915_get_et_stats holding mt76 mutex
      mt76: mt7915: move tx amsdu stats in mib_stats
      mt76: do not reset MIB counters in get_stats callback
      mt76: mt7921: add some more MIB counters
      mt76: mt7921: introduce stats reporting through ethtool
      mt76: mt7921: add sta stats accounting in mt7921_mac_add_txs_skb
      mt76: mt7921: move tx amsdu stats in mib_stats
      mt76: mt7921: add per-vif counters in ethtool

MeiChia Chiu (1):
      mt76: mt7915: add LED support

Ping-Ke Shih (2):
      rtw89: add Realtek 802.11ax driver
      MAINTAINERS: add rtw89 wireless driver

Qing Wang (1):
      ath5k: replace snprintf in show functions with sysfs_emit

Richard Huynh (1):
      mt76: mt76x0: correct VHT MCS 8/9 tx power eeprom offset

Ryder Lee (23):
      MAINTAINERS: mt76: update MTK folks
      mt76: mt7915: report HE MU radiotap
      mt76: mt7915: fix an off-by-one bound check
      mt76: mt7915: take RCU read lock when calling ieee80211_bss_get_elem()
      mt76: mt7915: cleanup -Wunused-but-set-variable
      mt76: mt7915: report tx rate directly from tx status
      mt76: mt7915: remove mt7915_sta_stats
      mt76: mt7915: add control knobs for thermal throttling
      mt76: mt7915: send EAPOL frames at lowest rate
      mt76: mt7921: send EAPOL frames at lowest rate
      mt76: add support for setting mcast rate
      mt76: mt7915: add HE-LTF into fixed rate command
      mt76: mt7915: update mac timing settings
      mt76: use IEEE80211_OFFLOAD_ENCAP_ENABLED instead of MT_DRV_AMSDU_OFFLOAD
      mt76: mt7915: rework debugfs queue info
      mt76: mt7915: rename debugfs tx-queues
      mt76: fill boottime_ns in Rx path
      mt76: mt7915: enable configured beacon tx rate
      mt76: mt7615: fix hwmon temp sensor mem use-after-free
      mt76: mt7615: fix monitor mode tear down crash
      mt76: mt7915: introduce mt7915_mcu_beacon_check_caps()
      mt76: mt7915: fix txbf starec TLV issues
      mt76: mt7915: improve starec readability of txbf

Sean Wang (27):
      mt76: mt7921: enable aspm by default
      mt76: fix build error implicit enumeration conversion
      mt76: add mt76_default_basic_rate more devices can rely on
      mt76: mt7921: fix mgmt frame using unexpected bitrate
      mt76: mt7915: fix mgmt frame using unexpected bitrate
      mt76: mt7921: report HE MU radiotap
      mt76: mt7921: fix firmware usage of RA info using legacy rates
      mt76: mt7921: fix kernel warning from cfg80211_calculate_bitrate
      mt76: mt7921: robustify hardware initialization flow
      mt76: mt7921: fix retrying release semaphore without end
      mt76: drop MCU header size from buffer size in __mt76_mcu_send_firmware
      mt76: mt7921: add MU EDCA cmd support
      mt76: mt7921: refactor mac.c to be bus independent
      mt76: mt7921: refactor dma.c to be pcie specific
      mt76: mt7921: refactor mcu.c to be bus independent
      mt76: mt7921: refactor init.c to be bus independent
      mt76: mt7921: add MT7921_COMMON module
      mt76: connac: move mcu reg access utility routines in mt76_connac_lib module
      mt76: mt7663s: rely on mcu reg access utility
      mt76: mt7921: make all event parser reusable between mt7921s and mt7921e
      mt76: mt7921: use physical addr to unify register access
      mt76: sdio: extend sdio module to support CONNAC2
      mt76: connac: extend mcu_get_nic_capability
      mt76: mt7921: rely on mcu_get_nic_capability
      mt76: mt7921: refactor mt7921_mcu_send_message
      mt76: mt7921: introduce mt7921s support
      mt76: mt7921s: add reset support

Shayne Chen (12):
      mt76: mt7915: fix potential overflow of eeprom page index
      mt76: mt7915: switch proper tx arbiter mode in testmode
      mt76: mt7915: fix bit fields for HT rate idx
      mt76: mt7915: fix sta_rec_wtbl tag len
      mt76: mt7915: rework starec TLV tags
      mt76: mt7915: fix muar_idx in mt7915_mcu_alloc_sta_req()
      mt76: mt7915: set VTA bit in tx descriptor
      mt76: mt7915: set muru platform type
      mt76: mt7915: enable HE UL MU-MIMO
      mt76: mt7915: rework mt7915_mcu_sta_muru_tlv()
      mt76: mt7915: fix missing HE phy cap
      mt76: mt7915: change max rx len limit of hw modules

Stephen Boyd (1):
      ath10k: Don't always treat modem stop events as crashes

Sven Eckelmann (1):
      ath10k: fix max antenna gain unit

Tim Gardner (1):
      ath11k: Remove unused variable in ath11k_dp_rx_mon_merg_msdus()

Tuo Li (1):
      ath: dfs_pattern_detector: Fix possible null-pointer dereference in channel_detector_create()

Xing Song (1):
      mt76: use a separate CCMP PN receive counter for management frames

Xingbang Liu (1):
      mt76: move spin_lock_bh to spin_lock in tasklet

YN Chen (2):
      mt76: mt7921: add .set_sar_specs support
      mt76: connac: add support for limiting to maximum regulatory Tx power

Yaara Baruch (1):
      iwlwifi: change all JnP to NO-160 configuration

Yang Li (1):
      rtw89: remove unneeded semicolon

Yang Yingliang (1):
      rtw89: fix return value check in rtw89_cam_send_sec_key_cmd()

Zheyu Ma (1):
      mwl8k: Fix use-after-free in mwl8k_fw_state_machine()

Ziyang Xuan (1):
      rsi: stop thread firstly in rsi_91x_init() error handling

jing yangyang (1):
      mt76: fix boolreturn.cocci warnings

 .../bindings/net/wireless/mediatek,mt76.yaml       |     5 +
 .../devicetree/bindings/net/wireless/qca,ath9k.txt |    48 -
 .../bindings/net/wireless/qca,ath9k.yaml           |    90 +
 MAINTAINERS                                        |    11 +-
 drivers/net/wireless/ath/ath10k/core.c             |     3 -
 drivers/net/wireless/ath/ath10k/mac.c              |     6 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |     3 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |     1 -
 drivers/net/wireless/ath/ath10k/snoc.c             |    77 +
 drivers/net/wireless/ath/ath10k/snoc.h             |     5 +
 drivers/net/wireless/ath/ath10k/wmi.h              |     3 +
 drivers/net/wireless/ath/ath11k/core.c             |    10 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |     2 +-
 drivers/net/wireless/ath/ath11k/dp.c               |    10 +-
 drivers/net/wireless/ath/ath11k/dp.h               |     1 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |    10 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |    13 +-
 drivers/net/wireless/ath/ath11k/hw.h               |     2 +-
 drivers/net/wireless/ath/ath11k/mac.c              |     4 +-
 drivers/net/wireless/ath/ath11k/pci.c              |    41 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |     1 -
 drivers/net/wireless/ath/ath11k/wmi.c              |    10 +-
 drivers/net/wireless/ath/ath5k/sysfs.c             |     8 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |     9 +-
 drivers/net/wireless/ath/ath9k/debug.c             |    57 +-
 drivers/net/wireless/ath/ath9k/debug.h             |     1 +
 drivers/net/wireless/ath/ath9k/init.c              |     6 +-
 drivers/net/wireless/ath/ath9k/main.c              |     4 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c    |    10 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |    10 +-
 drivers/net/wireless/ath/wil6210/main.c            |     6 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |     2 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |     2 +-
 drivers/net/wireless/atmel/atmel.c                 |    19 +-
 drivers/net/wireless/broadcom/b43/phy_g.c          |     2 +-
 drivers/net/wireless/broadcom/b43legacy/radio.c    |     2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |     6 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |     4 +-
 drivers/net/wireless/cisco/airo.c                  |    27 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |     4 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |    10 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.h       |     2 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |     1 -
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |     1 -
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |     2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |     1 -
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |    13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |     5 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |     6 +-
 drivers/net/wireless/intersil/hostap/hostap_hw.c   |     5 +-
 drivers/net/wireless/intersil/hostap/hostap_main.c |     4 +-
 drivers/net/wireless/intersil/orinoco/main.c       |     2 +-
 drivers/net/wireless/marvell/libertas/cmd.c        |     5 +-
 drivers/net/wireless/marvell/libertas/main.c       |     4 +-
 drivers/net/wireless/marvell/mwifiex/11n.c         |     7 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |    14 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |    21 +
 drivers/net/wireless/marvell/mwifiex/main.c        |    22 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |     1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c        |    36 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |     4 +
 drivers/net/wireless/marvell/mwifiex/uap_event.c   |     3 +-
 drivers/net/wireless/marvell/mwl8k.c               |     2 +-
 drivers/net/wireless/mediatek/mt76/Makefile        |     2 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c       |    22 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |    14 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   242 +-
 drivers/net/wireless/mediatek/mt76/mcu.c           |     8 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   126 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |    11 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |     3 +
 drivers/net/wireless/mediatek/mt76/mt7603/pci.c    |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/Makefile |     2 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |    29 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |     6 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |    62 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |    10 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |    68 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |    20 +-
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |     4 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |     5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c   |   296 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_mcu.c   |    11 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |     2 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |     7 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   355 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |    37 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |     2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |     4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |    15 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |    12 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |     3 +
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |     5 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   381 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   170 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   646 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |    11 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   334 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  1046 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   105 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |     3 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   144 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |     5 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   149 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |    23 +
 .../net/wireless/mediatek/mt76/mt7915/testmode.h   |     6 +
 drivers/net/wireless/mediatek/mt76/mt7921/Kconfig  |    18 +-
 drivers/net/wireless/mediatek/mt76/mt7921/Makefile |     7 +-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |    99 +-
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    |    74 +-
 drivers/net/wireless/mediatek/mt76/mt7921/eeprom.c |   100 -
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |    93 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   776 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    |    32 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   328 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   448 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |    63 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   179 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |    66 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |   348 +
 .../net/wireless/mediatek/mt76/mt7921/pci_mcu.c    |   115 +
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |    58 +-
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   |   317 +
 .../net/wireless/mediatek/mt76/mt7921/sdio_mac.c   |   220 +
 .../net/wireless/mediatek/mt76/mt7921/sdio_mcu.c   |   135 +
 .../net/wireless/mediatek/mt76/mt7921/testmode.c   |   197 +
 drivers/net/wireless/mediatek/mt76/sdio.c          |   303 +-
 .../net/wireless/mediatek/mt76/{mt7615 => }/sdio.h |    33 +-
 .../mediatek/mt76/{mt7615 => }/sdio_txrx.c         |   134 +-
 drivers/net/wireless/mediatek/mt76/testmode.c      |     4 +-
 drivers/net/wireless/mediatek/mt76/testmode.h      |     7 +
 drivers/net/wireless/mediatek/mt76/tx.c            |    84 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |     2 +-
 drivers/net/wireless/mediatek/mt7601u/dma.c        |     2 +-
 drivers/net/wireless/microchip/wilc1000/netdev.c   |    14 +-
 drivers/net/wireless/microchip/wilc1000/netdev.h   |     3 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c      |     6 +-
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |     2 -
 drivers/net/wireless/ray_cs.c                      |     2 +-
 drivers/net/wireless/realtek/Kconfig               |     1 +
 drivers/net/wireless/realtek/Makefile              |     1 +
 drivers/net/wireless/realtek/rtlwifi/pci.c         |     1 -
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |     2 +-
 drivers/net/wireless/realtek/rtw89/Kconfig         |    50 +
 drivers/net/wireless/realtek/rtw89/Makefile        |    25 +
 drivers/net/wireless/realtek/rtw89/cam.c           |   695 +
 drivers/net/wireless/realtek/rtw89/cam.h           |   165 +
 drivers/net/wireless/realtek/rtw89/coex.c          |  5716 +++
 drivers/net/wireless/realtek/rtw89/coex.h          |   181 +
 drivers/net/wireless/realtek/rtw89/core.c          |  2502 +
 drivers/net/wireless/realtek/rtw89/core.h          |  3384 ++
 drivers/net/wireless/realtek/rtw89/debug.c         |  2489 +
 drivers/net/wireless/realtek/rtw89/debug.h         |    77 +
 drivers/net/wireless/realtek/rtw89/efuse.c         |   188 +
 drivers/net/wireless/realtek/rtw89/efuse.h         |    13 +
 drivers/net/wireless/realtek/rtw89/fw.c            |  1641 +
 drivers/net/wireless/realtek/rtw89/fw.h            |  1378 +
 drivers/net/wireless/realtek/rtw89/mac.c           |  3836 ++
 drivers/net/wireless/realtek/rtw89/mac.h           |   860 +
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   676 +
 drivers/net/wireless/realtek/rtw89/pci.c           |  3060 ++
 drivers/net/wireless/realtek/rtw89/pci.h           |   635 +
 drivers/net/wireless/realtek/rtw89/phy.c           |  2868 ++
 drivers/net/wireless/realtek/rtw89/phy.h           |   311 +
 drivers/net/wireless/realtek/rtw89/ps.c            |   150 +
 drivers/net/wireless/realtek/rtw89/ps.h            |    16 +
 drivers/net/wireless/realtek/rtw89/reg.h           |  2159 +
 drivers/net/wireless/realtek/rtw89/regd.c          |   353 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |  2036 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.h      |   109 +
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c  |  3911 ++
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.h  |    24 +
 .../wireless/realtek/rtw89/rtw8852a_rfk_table.c    |  1607 +
 .../wireless/realtek/rtw89/rtw8852a_rfk_table.h    |   133 +
 .../net/wireless/realtek/rtw89/rtw8852a_table.c    | 48725 +++++++++++++++++++
 .../net/wireless/realtek/rtw89/rtw8852a_table.h    |    28 +
 drivers/net/wireless/realtek/rtw89/sar.c           |   190 +
 drivers/net/wireless/realtek/rtw89/sar.h           |    26 +
 drivers/net/wireless/realtek/rtw89/ser.c           |   491 +
 drivers/net/wireless/realtek/rtw89/ser.h           |    15 +
 drivers/net/wireless/realtek/rtw89/txrx.h          |   358 +
 drivers/net/wireless/realtek/rtw89/util.h          |    17 +
 drivers/net/wireless/rndis_wlan.c                  |     2 -
 drivers/net/wireless/rsi/rsi_91x_main.c            |     1 +
 drivers/net/wireless/st/cw1200/bh.c                |     2 -
 drivers/net/wireless/wl3501_cs.c                   |     3 +-
 drivers/net/wireless/zydas/zd1201.c                |     9 +-
 187 files changed, 97735 insertions(+), 2768 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/sdio_mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/sdio_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/testmode.c
 rename drivers/net/wireless/mediatek/mt76/{mt7615 => }/sdio.h (72%)
 rename drivers/net/wireless/mediatek/mt76/{mt7615 => }/sdio_txrx.c (67%)
 create mode 100644 drivers/net/wireless/realtek/rtw89/Kconfig
 create mode 100644 drivers/net/wireless/realtek/rtw89/Makefile
 create mode 100644 drivers/net/wireless/realtek/rtw89/cam.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/cam.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/coex.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/coex.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/core.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/core.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/debug.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/debug.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/efuse.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/efuse.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/fw.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/fw.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/mac.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/mac.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/mac80211.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/pci.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/pci.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/phy.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/phy.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/ps.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/ps.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/reg.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/regd.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852a.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852a.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852a_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852a_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/sar.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/sar.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/ser.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/ser.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/txrx.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/util.h
