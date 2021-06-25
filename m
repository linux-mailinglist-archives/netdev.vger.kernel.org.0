Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79453B4303
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 14:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhFYMTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 08:19:36 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:62180 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhFYMTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 08:19:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624623428; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=e4CjloP606dccpe8BkPx5IhuKQ/jUAZY1wpvLwp/LWg=; b=S7Iy+eKezlBWZPRXypCCJpCYsl791MnEsvOCHlj9kDMTnQFlBJhQ7aFd+aEW4jwDyjOnGueU
 di1OasThl+CvUXX8AcfzaPYjUdzFcOfsD3FoVKNvBkTnSgJCYJXTAnMRI1jk/d0wFEN+Qhpg
 Xpt+PLt+54F+/xZDSylHAYgcsrE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60d5c9420090905e16217fb3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 25 Jun 2021 12:17:06
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 57905C433F1; Fri, 25 Jun 2021 12:17:05 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 66BC1C433D3;
        Fri, 25 Jun 2021 12:17:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 66BC1C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2021-06-25
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210625121705.57905C433F1@smtp.codeaurora.org>
Date:   Fri, 25 Jun 2021 12:17:05 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 0c33795231bff5df410bd405b569c66851e92d4b:

  Merge tag 'wireless-drivers-next-2021-06-16' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next (2021-06-16 12:59:42 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2021-06-25

for you to fetch changes up to c2a3823dad4988943c0b0f61af9336301e30d4e5:

  iwlwifi: acpi: remove unused function iwl_acpi_eval_dsm_func() (2021-06-24 19:21:57 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.14

Second, and most likely the last, set of patches for v5.14. mt76 and
iwlwifi have most patches in this round, but rtw88 also has some new
features. Nothing special really standing out.

mt76

* mt7915 MSI support

* disable ASPM on mt7915

* mt7915 tx status reporting

* mt7921 decap offload

rtw88

* beacon filter support

* path diversity support

* firmware crash information via devcoredump

* quirks for disabling pci capabilities

mt7601u

* add USB ID for a XiaoDu WiFi Dongle

ath11k

* enable support for QCN9074 PCI devices

brcmfmac

* support parse country code map from DeviceTree

iwlwifi

* support for new hardware

* support for BIOS control of 11ax enablement in Russia

* support UNII4 band enablement from BIOS

----------------------------------------------------------------
Abhishek Naik (1):
      iwlwifi: mvm: Read acpi dsm to get unii4 enable/disable bitmap.

Anilkumar Kolli (1):
      ath11k: Enable QCN9074 device

Avraham Stern (1):
      iwlwifi: mvm: support LMR feedback

Caleb Connolly (1):
      ath10k: demote chan info without scan request warning

Chin-Yen Lee (2):
      rtw88: add rtw_fw_feature_check api
      rtw88: notify fw when driver in scan-period to avoid potential problem

Dan Carpenter (1):
      mt76: mt7915: fix a signedness bug in mt7915_mcu_apply_tx_dpd()

Deren Wu (5):
      mt76: connac: update BA win size in Rx direction
      mt76: mt7921: introduce mac tx done handling
      mt76: mt7921: update statistic in active mode only
      mt76: mt7921: enable random mac address during sched_scan
      mt76: mt7921: enable HE BFee capability

Dmitry Osipenko (2):
      cfg80211: Add wiphy_info_once()
      brcmfmac: Silence error messages about unsupported firmware features

Emmanuel Grumbach (5):
      iwlwifi: mvm: support LONG_GROUP for WOWLAN_GET_STATUSES version
      iwlwifi: mvm: introduce iwl_proto_offload_cmd_v4
      iwlwifi: mvm: update iwl_wowlan_patterns_cmd
      iwlwifi: mvm: introduce iwl_wowlan_kek_kck_material_cmd_v4
      iwlwifi: mvm: introduce iwl_wowlan_get_status_cmd

Evelyn Tsai (1):
      mt76: mt7915: fix tssi indication field of DBDC NICs

Felix Fietkau (14):
      mt76: mt7915: add MSI support
      mt76: mt7915: disable ASPM
      mt76: mt7915: move mt7915_queue_rx_skb to mac.c
      mt76: mt7615: fix fixed-rate tx status reporting
      mt76: mt7615: avoid use of ieee80211_tx_info_clear_status
      mt76: mt7603: avoid use of ieee80211_tx_info_clear_status
      mt76: intialize tx queue entry wcid to 0xffff by default
      mt76: improve tx status codepath
      mt76: dma: use ieee80211_tx_status_ext to free packets when tx fails
      mt76: mt7915: rework tx rate reporting
      mt76: mt7915: add support for tx status reporting
      mt76: mt7915: improve error recovery reliability
      mt76: mt7921: enable VHT BFee capability
      mt76: mt7915: drop the use of repeater entries for station interfaces

Harish Mitty (1):
      iwlwifi: mvm: Call NMI instead of REPLY_ERROR

Ilan Peer (1):
      iwlwifi: mvm: Explicitly stop session protection before unbinding

Johannes Berg (18):
      iwlwifi: mvm: don't change band on bound PHY contexts
      iwlwifi: pcie: handle pcim_iomap_table() failures better
      iwlwifi: pcie: print interrupt number, not index
      iwlwifi: pcie: remove CSR_HW_RF_ID_TYPE_CHIP_ID
      iwlwifi: remove duplicate iwl_ax201_cfg_qu_hr declaration
      iwlwifi: pcie: identify the RF module
      iwlwifi: mvm: don't request SMPS in AP mode
      iwlwifi: mvm: apply RX diversity per PHY context
      iwlwifi: mvm: honour firmware SMPS requests
      iwlwifi: correct HE capabilities
      iwlwifi: pcie: fix some kernel-doc comments
      iwlwifi: pcie: remove TR/CR tail allocations
      iwlwifi: pcie: free IML DMA memory allocation
      iwlwifi: pcie: fix context info freeing
      iwlwifi: mvm: fill phy_data.d1 for no-data RX
      iwlwifi: pcie: free some DMA memory earlier
      iwlwifi: move error dump to fw utils
      iwlwifi: fw: dump TCM error table if present

Kalle Valo (4):
      Merge tag 'mt76-for-kvalo-2021-06-18' of https://github.com/nbd168/wireless into pending
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2021-06-22' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      iwlwifi: acpi: remove unused function iwl_acpi_eval_dsm_func()

Kees Cook (6):
      orinoco: Avoid field-overflowing memcpy()
      mwl8k: Avoid memcpy() over-reading of mcs.rx_mask
      rtlwifi: rtl8192de: Fully initialize curvecount_val
      mwifiex: Avoid memset() over-write of WEP key_material
      ath11k: Avoid memcpy() over-reading of he_cap
      wcn36xx: Avoid memset() beyond end of struct field

Lorenzo Bianconi (40):
      mt76: move mt76_rates in mt76 module
      mt76: mt7921: enable rx hw de-amsdu
      mt76: connac: add missing configuration in mt76_connac_mcu_wtbl_hdr_trans_tlv
      mt76: mt7921: enable rx header traslation offload
      mt76: mt7921: enable rx csum offload
      mt76: fix possible NULL pointer dereference in mt76_tx
      mt76: mt7615: fix NULL pointer dereference in tx_prepare_skb()
      mt76: mt76x0: use dev_debug instead of dev_err for hw_rf_ctrl
      mt76: mt7615: free irq if mt7615_mmio_probe fails
      mt76: mt7663: enable hw rx header translation
      mt76: mt7921: enable runtime pm by default
      mt76: mt7921: return proper error value in mt7921_mac_init
      mt76: mt7921: do not schedule hw reset if the device is not running
      mt76: mt7921: reset wfsys during hw probe
      mt76: mt7615: remove useless if condition in mt7615_add_interface()
      mt76: testmode: fix memory leak in mt76_testmode_alloc_skb
      mt76: testmode: remove unnecessary function calls in mt76_testmode_free_skb
      mt76: testmode: remove undefined behaviour in mt76_testmode_alloc_skb
      mt76: allow hw driver code to overwrite wiphy interface_modes
      mt76: mt7921: set MT76_RESET during mac reset
      mt76: mt7921: enable hw offloading for wep keys
      mt76: mt7921: remove mt7921_get_wtbl_info routine
      mt76: connac: fix UC entry is being overwritten
      mt76: connac: add mt76_connac_power_save_sched in mt76_connac_pm_unref
      mt76: mt7921: wake the device before dumping power table
      mt76: mt7921: make mt7921_set_channel static
      mt76: connac: add mt76_connac_mcu_get_nic_capability utility routine
      mt76: reduce rx buffer size to 2048
      mt76: move mt76_get_next_pkt_id in mt76.h
      mt76: connac: check band caps in mt76_connac_mcu_set_rate_txpower
      mt76: mt7921: improve code readability for mt7921_update_txs
      mt76: mt7921: limit txpower according to userlevel power
      mt76: mt7921: introduce dedicated control for deep_sleep
      mt76: disable TWT capabilities for the moment
      mt76: sdio: do not run mt76_txq_schedule directly
      mt76: mt7663s: rely on pm reference counting
      mt76: mt7663s: rely on mt76_connac_pm_ref/mt76_connac_pm_unref in tx path
      mt76: mt7663s: enable runtime-pm
      mt76: mt7615: set macwork timeout according to runtime-pm
      mt76: mt7921: allow chip reset during device restart

Luca Coelho (8):
      iwlwifi: mvm: pass the clock type to iwl_mvm_get_sync_time()
      iwlwifi: mvm: fix indentation in some scan functions
      iwlwifi: remove unused REMOTE_WAKE_CONFIG_CMD definitions
      iwlwifi: increase PNVM load timeout
      iwlwifi: fix NUM_IWL_UCODE_TLV_* definitions to avoid sparse errors
      iwlwifi: move UEFI code to a separate file
      iwlwifi: support loading the reduced power table from UEFI
      iwlwifi: bump FW API to 64 for AX devices

Matti Gottlieb (1):
      iwlwifi: pcie: Add support for AX231 radio module with Ma devices

Miri Korenblit (1):
      iwlwifi: mvm: support BIOS enable/disable for 11ax in Russia

Mukesh Sisodiya (1):
      iwlwifi: yoyo: support region TLV version 2

Naftali Goldstein (2):
      iwlwifi: mvm: don't request mac80211 to disable/enable sta's queues
      iwlwifi: support ver 6 of WOWLAN_CONFIGURATION and ver 10 of WOWLAN_GET_STATUSES

Pascal Terjan (1):
      rtl8xxxu: Fix device info for RTL8192EU devices

Ping-Ke Shih (1):
      rtw88: add quirks to disable pci capabilities

Po-Hao Huang (6):
      rtw88: add beacon filter support
      rtw88: add path diversity
      rtw88: 8822c: fix lc calibration timing
      rtw88: 8822c: update RF parameter tables to v62
      rtw88: refine unwanted h2c command
      rtw88: fix c2h memory leak

Ryder Lee (17):
      mt76: mt7915: cleanup mt7915_mcu_sta_rate_ctrl_tlv()
      mt76: mt7915: add .set_bitrate_mask() callback
      mt76: mt7915: add thermal sensor device support
      mt76: mt7915: add thermal cooling device support
      mt76: mt7615: add thermal sensor device support
      mt76: mt7915: add .offset_tsf callback
      mt76: mt7615: add .offset_tsf callback
      mt76: mt7615: fix potential overflow on large shift
      mt76: mt7915: use mt7915_mcu_get_mib_info() to get survey data
      mt76: mt7915: setup drr group for peers
      mt76: mt7615: update radar parameters
      mt76: mt7915: fix MT_EE_CAL_GROUP_SIZE
      mt76: make mt76_update_survey() per phy
      mt76: mt7915: introduce mt7915_mcu_set_txbf()
      mt76: mt7915: improve MU stability
      mt76: mt7915: fix IEEE80211_HE_PHY_CAP7_MAX_NC for station mode
      mt76: fix iv and CCMP header insertion

Sean Wang (14):
      mt76: mt7921: fix mt7921_wfsys_reset sequence
      mt76: mt7921: Don't alter Rx path classifier
      mt76: connac: fw_own rely on all packet memory all being free
      mt76: mt7921: fix reset under the deep sleep is enabled
      mt76: mt7921: consider the invalid value for to_rssi
      mt76: mt7921: add back connection monitor support
      mt76: mt7921: avoid unnecessary consecutive WiFi resets
      mt76: mt7921: fix invalid register access in wake_work
      mt76: mt7921: fix OMAC idx usage
      mt76: connac: fix the maximum interval schedule scan can support
      mt76: mt7921: enable deep sleep at runtime
      mt76: mt7921: add deep sleep control to runtime-pm knob
      mt76: mt7921: fix kernel warning when reset on vif is not sta
      mt76: mt7921: fix the coredump is being truncated

Shaul Triebitz (2):
      iwlwifi: mvm: fix error print when session protection ends
      iwlwifi: advertise broadcast TWT support

Shawn Guo (1):
      brcmfmac: support parse country code map from DT

Shayne Chen (4):
      mt76: mt7915: use mt7915_mcu_get_txpower_sku() to get per-rate txpower
      mt76: mt7915: read all eeprom fields from fw in efuse mode
      mt76: testmode: move chip-specific stats dump before common stats
      mt76: mt7915: fix rx fcs error count in testmode

Tom Rix (2):
      mt76: add a space between comment char and SPDX tag
      mt76: use SPDX header file comment style

Wan Jiabing (1):
      rtw88: Remove duplicate include of coex.h

Wei Mingzhi (1):
      mt7601u: add USB device ID for some versions of XiaoDu WiFi Dongle.

YN Chen (2):
      mt76: connac: fix WoW with disconnetion and bitmap pattern
      mt76: connac: add bss color support for sta mode

Zong-Zhe Yang (1):
      rtw88: dump FW crash via devcoredump

wengjianfeng (1):
      rtw88: coex: remove unnecessary variable and label

ybaruch (1):
      iwlwifi: add 9560 killer device

Íñigo Huguet (1):
      rtl8xxxu: avoid parsing short RX packet

 drivers/net/wireless/ath/ath10k/wmi.c              |    2 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   14 +-
 drivers/net/wireless/ath/ath11k/pci.c              |    2 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |   21 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   16 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   11 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   |    4 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |   57 +-
 drivers/net/wireless/intel/iwlwifi/Makefile        |    3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   16 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |    6 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |   86 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |   10 +
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |    5 -
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |  110 +--
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |   26 +
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |    3 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |   19 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   47 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c       |  418 ++++++++
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   25 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |  120 +--
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.h       |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |  262 +++++
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h       |   42 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |    6 +-
 .../wireless/intel/iwlwifi/iwl-context-info-gen3.h |   20 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |    5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   13 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   11 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  138 +--
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   20 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  118 ++-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |    4 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |    9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   44 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   25 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   20 +-
 .../net/wireless/intel/iwlwifi/mvm/offloading.c    |   26 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   40 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |   26 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    8 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   45 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  357 +------
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |   90 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   19 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   24 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   34 -
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   78 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   39 +-
 drivers/net/wireless/intersil/orinoco/hw.c         |   18 +-
 drivers/net/wireless/intersil/orinoco/hw.h         |    5 +-
 drivers/net/wireless/intersil/orinoco/wext.c       |    2 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |    6 +
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |   11 +-
 drivers/net/wireless/marvell/mwl8k.c               |    4 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   19 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   64 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   56 +-
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |   32 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   43 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/regs.h   |   12 -
 drivers/net/wireless/mediatek/mt76/mt7615/Makefile |    2 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |   22 +-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |   13 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   85 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  156 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |   42 -
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   60 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |   99 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |   11 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   19 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |   10 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |   12 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |    2 +
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.h   |    2 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_mcu.c   |   39 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_txrx.c  |   16 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |   11 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |   19 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |   10 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  228 ++++-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   72 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   36 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h  |   18 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   16 +-
 drivers/net/wireless/mediatek/mt76/mt7915/Makefile |    2 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   78 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |   45 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |   44 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |   13 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  179 +++-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  384 ++++----
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |   56 ++
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |  103 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  673 +++++++++----
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   80 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   39 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |   41 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   32 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |   21 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.h   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/Makefile |    2 +-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |   37 +
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    |   22 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   99 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  248 +++--
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    |   14 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  172 ++--
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  203 ++--
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |  166 +---
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   20 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |   34 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |   17 +-
 drivers/net/wireless/mediatek/mt76/testmode.c      |   35 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   82 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |    1 +
 drivers/net/wireless/mediatek/mt7601u/usb.c        |    1 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   11 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |   59 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   11 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |    2 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |   45 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |    7 +
 drivers/net/wireless/realtek/rtw88/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw88/fw.c            |  114 +++
 drivers/net/wireless/realtek/rtw88/fw.h            |   55 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    9 +
 drivers/net/wireless/realtek/rtw88/main.c          |  196 ++--
 drivers/net/wireless/realtek/rtw88/main.h          |   57 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |   32 +
 drivers/net/wireless/realtek/rtw88/phy.c           |   81 ++
 drivers/net/wireless/realtek/rtw88/phy.h           |    1 +
 drivers/net/wireless/realtek/rtw88/ps.c            |    4 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  113 ++-
 .../net/wireless/realtek/rtw88/rtw8822c_table.c    | 1008 ++++++++++----------
 include/net/cfg80211.h                             |    2 +
 145 files changed, 5551 insertions(+), 3064 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/dump.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/uefi.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/uefi.h
