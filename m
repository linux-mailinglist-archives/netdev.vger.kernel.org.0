Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15FA319CFD
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 12:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhBLLCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 06:02:32 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:56095 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231191AbhBLLAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 06:00:41 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613127607; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=951RgeDvuBvsski0rwHaCw1MXxFxMdZ5PpmzVkrmVck=; b=rvkMjzWIBgcZy7uJII0SlfdFXTJLi+QD1Ze40qSftAe7EmM/6S2gKvsAtpS0M4T4l03/Jx9F
 cYvl3f9Aq4m8ywikPbO4ZJ8lOmdhSd7NThIX9sXAQPtLqQ8j7HrzIL1oyrXEllC+pX1xmzCG
 py83tSTpWPHVJwb30tW6pMTOtVI=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 60265f954bd23a05aee9852b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 12 Feb 2021 10:59:33
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1F8E7C43461; Fri, 12 Feb 2021 10:59:33 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8ED3FC433C6;
        Fri, 12 Feb 2021 10:59:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8ED3FC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2021-02-12
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210212105933.1F8E7C43461@smtp.codeaurora.org>
Date:   Fri, 12 Feb 2021 10:59:33 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit badc6ac3212294bd37304c56ddf573c9ba3202e6:

  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2021-02-06 16:10:19 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2021-02-12

for you to fetch changes up to 9d083348e938eb0330639ad08dcfe493a59a8a40:

  rtw88: 8822c: update RF_B (2/2) parameter tables to v60 (2021-02-12 09:51:15 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for v5.12

Second set of patches for v5.12. Last time there was a smaller pull
request so unsurprisingly this time we have a big one. mt76 has new
hardware support and lots of new features, iwlwifi getting new
features and rtw88 got NAPI support. And the usual cleanups and fixes
all over.

Major changes:

ath10k

* support setting SAR limits via nl80211

rtw88

* support 8821 RFE type2 devices

* NAPI support

iwlwifi

* add new FW API support

* support for new So devices

* support for RF interference mitigation (RFI)

* support for PNVM (Platform Non-Volatile Memory, a firmware data
  file) from BIOS

mt76

* add new mt7921e driver

* 802.11 encap offload support

* support for multiple pcie gen1 host interfaces on 7915

* 7915 testmode support

* 7915 txbf support

brcmfmac

* support for CQM RSSI notifications

wil6210

* support for extended DMG MCS 12.1 rate

----------------------------------------------------------------
Abhishek Naik (1):
      iwlwifi: mvm: Check ret code for iwl_mvm_load_nvm_to_nic

Alvin Šipraga (1):
      brcmfmac: add support for CQM RSSI notifications

Anand K Mistry (2):
      ath10k: Fix suspicious RCU usage warning in ath10k_wmi_tlv_parse_peer_stats_info()
      ath10k: Fix lockdep assertion warning in ath10k_sta_statistics

Arnd Bergmann (4):
      brcmsmac: fix alignment constraints
      wl3501: fix alignment constraints
      mwl8k: fix alignment constraints
      carl9170: fix struct alignment conflict

Bhaskar Chowdhury (1):
      brcmsmac: Fix the spelling configation to configuration in the file d11.h

Carl Huang (1):
      ath10k: allow dynamic SAR power limits via common API

Colin Ian King (2):
      rtlwifi: rtl8192se: remove redundant initialization of variable rtstatus
      libertas: remove redundant initialization of variable ret

Dan Carpenter (1):
      ath11k: fix a locking bug in ath11k_mac_op_start()

Dror Moshe (2):
      iwlwifi: parse phy integration string from FW TLV
      iwlwifi: mvm: debugfs for phy-integration-ver

Emil Renner Berthing (1):
      rtlwifi: use tasklet_setup to initialize rx_work_tasklet

Emmanuel Grumbach (11):
      iwlwifi: remove TRANS_PM_OPS
      iwlwifi: mvm: don't check system_pm_mode without mutex held
      iwlwifi: mvm: cancel the scan delayed work when scan is aborted
      iwlwifi: mvm: fix CSA AP side
      iwlwifi: mvm: enhance a print in CSA flows
      iwlwifi: pcie: NULLify pointers after free
      iwlwifi: pcie: don't crash when rx queues aren't allocated in interrupt
      iwlwifi: mvm: register to mac80211 last
      iwlwifi: mvm: simplify iwl_mvm_dbgfs_register
      iwlwifi: mvm: isolate the get nvm flow
      iwlwifi: mvm: get NVM later in the mvm_start flow

Felix Fietkau (15):
      mt76: mt7603: fix ED/CCA monitoring with single-stream devices
      mt76: mt7915: ensure that init work completes before starting the device
      mt76: mt7915: do not set DRR group for stations
      mt76: mt7915: rework mcu API
      mt76: mt7915: disable RED support in the WA firmware
      mt76: mt7915: fix eeprom parsing for DBDC
      mt76: mt7915: fix eeprom DBDC band selection
      mt76: mt7615: unify init work
      mt76: mt7915: bring up the WA event rx queue for band1
      mt76: fix crash on tearing down ext phy
      mt76: mt7915: add support for using a secondary PCIe link for gen1
      mt76: mt7915: make vif index per adapter instead of per band
      mt76: move vif_mask back from mt76_phy to mt76_dev
      mt76: reduce q->lock hold time
      mt76: mt7615: reduce VHT maximum MPDU length

Golan Ben Ami (1):
      iwlwifi: mvm: reduce the print severity of failing getting NIC temp

Gregory Greenman (2):
      iwlwifi: mvm: add RFI-M support
      iwlwifi: acpi: add support for DSM RFI

Guo-Feng Fan (3):
      rtw88: coex: 8821c: correct antenna switch function
      rtw88: 8821c: Correct CCK RSSI
      rtw88: 8821c: support RFE type2 wifi NIC

Haim Dreyfuss (2):
      iwlwifi: mvm: don't send commands during suspend\resume transition
      iwlwifi: acpi: don't return valid pointer as an ERR_PTR

Hans de Goede (2):
      brcmfmac: Add DMI nvram filename quirk for Predia Basic tablet
      brcmfmac: Add DMI nvram filename quirk for Voyo winpad A15 tablet

Ihab Zhaika (1):
      iwlwifi: add new cards for So and Qu family

Ilan Peer (2):
      iwlwifi: pcie: Disable softirqs during Rx queue init
      iwlwifi: mvm: Support SCAN_CFG_CMD version 5

Jiapeng Chong (4):
      iwlegacy: 4965-mac: Simplify the calculation of variables
      ssb: Use true and false for bool variable
      rtlwifi: rtl8192se: Simplify bool comparison
      rtlwifi: rtl8821ae: phy: Simplify bool comparison

Johannes Berg (19):
      iwlwifi: mvm: add notification size checks
      iwlwifi: mvm: check more notification sizes
      iwlwifi: mvm: remove debugfs injection limitations
      iwlwifi: mvm: scan: fix scheduled scan restart handling
      iwlwifi: mvm: handle CCA-EXT delay firmware notification
      iwlwifi: pcie: properly implement NAPI
      iwlwifi: mvm: simplify TX power setting
      iwlwifi: mvm: debugfs: check length precisely in inject_packet
      iwlwifi: always allow maximum A-MSDU on newer devices
      iwlwifi: mvm: advertise BIGTK client support if available
      iwlwifi: fw api: make hdr a zero-size array again
      iwlwifi: mvm: slightly clean up rs_fw_set_supp_rates()
      iwlwifi: mvm: make iwl_mvm_tt_temp_changed() static
      iwlwifi: pcie: don't disable interrupts for reg_lock
      iwlwifi: mvm: remove useless iwl_mvm_resume_d3() function
      iwlwifi: api: clean up some documentation/bits
      iwlwifi: remove flags argument for nic_access
      iwlwifi: remove max_vht_ampdu_exponent config parameter
      iwlwifi: remove max_ht_ampdu_exponent config parameter

Kalle Valo (8):
      ath10k: remove unused struct ath10k::dev_type
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2021-02-05' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge tag 'mt76-for-kvalo-2021-01-29' of https://github.com/nbd168/wireless
      ath11k: pci: remove experimental warning
      ath11k: qmi: add debug message for allocated memory segment addresses and sizes
      Merge tag 'iwlwifi-next-for-kalle-2021-02-10' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Karthikeyan Periyasamy (2):
      ath11k: remove duplicate function declaration
      ath11k: Update tx descriptor search index properly

Krishnanand Prabhu (1):
      iwlwifi: mvm: add explicit check for non-data frames in get Tx rate

Linus Lüssing (2):
      ath10k: increase rx buffer size to 2048
      ath9k: fix data bus crash when setting nf_override via debugfs

Loic Poulain (1):
      wcn36xx: del BA session on TX stop

Lorenzo Bianconi (19):
      mt76: mt7915: run mt7915_configure_filter holding mt76 mutex
      mt76: mt7915: fix endianness warning in mt7915_mcu_set_radar_th
      mt76: mt7915: simplify mt7915_mcu_send_message routine
      mt76: move mac_work in mt76_core module
      mt76: move chainmask in mt76_phy
      mt76: mt7615: set mcu country code in mt7615_mcu_set_channel_domain()
      mt76: usb: process URBs with status EPROTO properly
      mt76: introduce mt76_vif data structure
      mt76: mt76_connac: create mcu library
      mt76: mt76_connac: move hw_scan and sched_scan routine in mt76_connac_mcu module
      mt76: mt76_connac: move WoW and suspend code in mt76_connac_mcu module
      mt76: mt76_connac: move pm data struct in mt76_connac.h
      mt76: mt76_connac: move pm utility routines in mt76_connac_lib module
      mt76: mt7921: rely on mt76_connac_mcu common library
      mt76: mt7921: rely on mt76_connac_mcu module for sched_scan and hw_scan
      mt76: mt7921: rely on mt76_connac_mcu module for suspend and WoW support
      mt76: mt7921: introduce regdomain notifier support
      mt76: mt7921: enable MSI interrupts
      mt76: mt7663: introduce coredump support

Luca Coelho (24):
      iwlwifi: bump FW API to 60 for AX devices
      iwlwifi: move SnJ and So rules to the new tables
      iwlwifi: add support for SnJ with Jf devices
      iwlwifi: mvm: move early time-point before nvm_init in non-unified
      iwlwifi: pcie: add support for SnJ with Hr1
      iwlwifi: mvm: set enabled in the PPAG command properly
      iwlwifi: mvm: implement approved list for the PPAG feature
      iwlwifi: mvm: add HP to the PPAG approved list
      iwlwifi: mvm: add Samsung to the PPAG approved list
      iwlwifi: mvm: add Microsoft to the PPAG approved list
      iwlwifi: mvm: add Asus to the PPAG approved list
      iwlwifi: bump FW API to 61 for AX devices
      iwlwifi: pcie: add a few missing entries for So with Hr
      iwlwifi: acpi: fix PPAG table sizes
      iwlwifi: mvm: fix the type we use in the PPAG table validity checks
      iwlwifi: mvm: store PPAG enabled/disabled flag properly
      iwlwifi: mvm: send stored PPAG command instead of local
      iwlwifi: mvm: assign SAR table revision to the command later
      iwlwifi: pnvm: set the PNVM again if it was already loaded
      iwlwifi: pnvm: increment the pointer before checking the TLV
      iwlwifi: pnvm: move file loading code to a separate function
      iwlwifi: pnvm: implement reading PNVM from UEFI
      iwlwifi: bump FW API to 62 for AX devices
      iwlwifi: remove incorrect comment in pnvm

Matti Gottlieb (4):
      iwlwifi: pcie: Change Ma device ID
      iwlwifi: pcie: add CDB bit to the device configuration parsing
      iwlwifi: pcie: add AX201 and AX211 radio modules for Ma devices
      iwlwifi: pcie: define FW_RESET_TIMEOUT for clarity

Max Chen (1):
      wil6210: Add Support for Extended DMG MCS 12.1

Miaoqing Pan (1):
      ath10k: fix wmi mgmt tx queue full due to race condition

Miri Korenblit (1):
      iwlwifi:mvm: Add support for version 2 of the LARI_CONFIG_CHANGE command.

Mordechay Goodstein (13):
      iwlwifi: mvm: add support for new flush queue response
      iwl-trans: iwlwifi: move sync NMI logic to trans
      iwlwifi: dbg: dump paged memory from index 1
      iwlwifi: tx: move handing sync/async host command to trans
      iwlwifi: mvm: add IML/ROM information for other HW families
      iwlwifi: mvm: add triggers for MLME events
      iwlwifi: fwrt: add suspend/resume time point
      iwlwifi: mvm: add tx fail time point
      iwlwifi: mvm: add debugfs entry to trigger a dump as any time-point
      iwlwifi: when HW has rate offload don't look at control field
      iwlwifi: dbg: remove unsupported regions
      iwlwifi: dbg: add op_mode callback for collecting debug data.
      iwlwifi: queue: add fake tx time point

Mukesh Sisodiya (1):
      iwlwifi: correction of group-id once sending REPLY_ERROR

Naftali Goldstein (1):
      iwlwifi: declare support for triggered SU/MU beamforming feedback

Po-Hao Huang (8):
      rtw88: add dynamic rrsr configuration
      rtw88: add rts condition
      rtw88: add napi support
      rtw88: replace tx tasklet with work queue
      rtw88: 8822c: update MAC/BB parameter tables to v60
      rtw88: 8822c: update RF_A parameter tables to v60
      rtw88: 8822c: update RF_B (1/2) parameter tables to v60
      rtw88: 8822c: update RF_B (2/2) parameter tables to v60

Rajkumar Manoharan (1):
      ath11k: add support to configure spatial reuse parameter set

Ravi Darsi (1):
      iwlwifi: mvm: global PM mode does not reset after FW crash

Ryder Lee (9):
      mt76: mt7915: add vif check in mt7915_update_vif_beacon()
      mt76: mt7615: add vif check in mt7615_update_vif_beacon()
      mt76: mt7915: fix MT_CIPHER_BIP_CMAC_128 setkey
      mt76: mt7915: reset token when mac_reset happens
      mt76: mt7615: reset token when mac_reset happens
      mt76: mt7915: drop zero-length packet to avoid Tx hang
      mt76: mt7915: simplify peer's TxBF capability check
      mt76: mt7915: add implicit Tx beamforming support
      mt76: mt7915: support TxBF for DBDC

Sara Sharon (1):
      iwlwifi: mvm: don't check if CSA event is running before removing

Sean Wang (14):
      mt76: mt7921: add MAC support
      mt76: mt7921: add MCU support
      mt76: mt7921: add DMA support
      mt76: mt7921: add EEPROM support
      mt76: mt7921: add ieee80211_ops
      mt76: mt7921: introduce mt7921e support
      mt76: mt7921: add debugfs support
      mt76: mt7921: introduce schedule scan support
      mt76: mt7921: introduce 802.11 PS support in sta mode
      mt76: mt7921: introduce support for hardware beacon filter
      mt76: mt7921: introduce beacon_loss mcu event
      mt76: mt7921: introduce PM support
      mt76: mt7921: introduce Runtime PM support
      mt76: mt7921: add coredump support

Shaul Triebitz (2):
      iwlwifi: mvm: csa: do not abort CSA before disconnect
      iwlmvm: set properly NIC_NOT_ACK_ENABLED flag

Shayne Chen (18):
      mt76: mt7915: add support for flash mode
      mt76: mt7915: add partial add_bss_info command on testmode init
      mt76: testmode: introduce dbdc support
      mt76: testmode: move mtd part to mt76_dev
      mt76: mt7915: move testmode data from dev to phy
      mt76: mt7615: move testmode data from dev to phy
      mt76: mt7915: force ldpc for bw larger than 20MHz in testmode
      mt76: testmode: add support to set user-defined spe index
      mt76: testmode: add attributes for ipg related parameters
      mt76: testmode: make tx queued limit adjustable
      mt76: mt7915: split edca update function
      mt76: mt7915: add support for ipg in testmode
      mt76: mt7915: calculate new packet length when tx_time is set in testmode
      mt76: mt7915: clean hw queue before starting new testmode tx
      mt76: testmode: add a new state for continuous tx
      mt76: mt7915: rework set state part in testmode
      mt76: mt7915: add support for continuous tx in testmode
      mt76: mt7615: mt7915: disable txpower sku when testmode enabled

Shuah Khan (2):
      ath10k: change ath10k_offchan_tx_work() peer present msg to a warn
      ath10k: hold RCU lock when calling ieee80211_find_sta_by_ifaddr()

Stanislaw Gruszka (1):
      rt2800usb: add Sweex LW163V2 id's

Takashi Iwai (1):
      iwlwifi: dbg: Mark ucode tlv data as const

Tamizh Chelvam (1):
      ath10k: Add new debug level for sta related logs

Tom Rix (2):
      ath10k: remove h from printk format specifier
      ath11k: remove h from printk format specifier

Vsevolod Kozlov (1):
      wilc1000: Fix use of void pointer as a wrong struct type

Wen Gong (3):
      ath11k: add ieee80211_unregister_hw to avoid kernel crash caused by NULL pointer
      ath10k: pass the ssid info to get the correct bss entity
      ath10k: restore tx sk_buff of htt header for SDIO

Xu Wang (1):
      mt76: mt7915: Remove unneeded semicolon

Yen-lin Lai (1):
      mwifiex: Report connected BSS with cfg80211_connect_bss()

Zekun Shen (1):
      ath10k: sanitity check for ep connectivity

Zheng Yongjun (4):
      wcn36xx: Remove unnecessary memset
      mt76: mt7615: convert comma to semicolon
      mt76: mt7915: convert comma to semicolon
      atmel: at76c50x: use DEFINE_MUTEX() for mutex lock

wengjianfeng (5):
      rtl8xxxu: remove unused assignment value
      wl1251: cmd: remove redundant assignment
      mwl8k: assign value when defining variables
      rsi: remove redundant assignment
      rt2x00: remove duplicate word and fix typo in comment

 drivers/net/wireless/ath/ath10k/core.c             |    16 +
 drivers/net/wireless/ath/ath10k/core.h             |     4 +-
 drivers/net/wireless/ath/ath10k/debug.h            |     1 +
 drivers/net/wireless/ath/ath10k/htc.c              |     4 +
 drivers/net/wireless/ath/ath10k/htt.h              |     2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |    32 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |    14 +-
 drivers/net/wireless/ath/ath10k/hw.h               |     2 +
 drivers/net/wireless/ath/ath10k/mac.c              |   287 +-
 drivers/net/wireless/ath/ath10k/trace.h            |     4 +-
 drivers/net/wireless/ath/ath10k/txrx.c             |     4 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |    16 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |     6 +-
 drivers/net/wireless/ath/ath11k/core.h             |     9 +-
 .../net/wireless/ath/ath11k/debugfs_htt_stats.c    |    12 +
 .../net/wireless/ath/ath11k/debugfs_htt_stats.h    |    15 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |    18 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |     1 +
 drivers/net/wireless/ath/ath11k/hal_tx.c           |     2 +
 drivers/net/wireless/ath/ath11k/hal_tx.h           |     1 +
 drivers/net/wireless/ath/ath11k/mac.c              |   183 +-
 drivers/net/wireless/ath/ath11k/mac.h              |     6 +
 drivers/net/wireless/ath/ath11k/pci.c              |     2 -
 drivers/net/wireless/ath/ath11k/peer.c             |     9 +-
 drivers/net/wireless/ath/ath11k/peer.h             |     3 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |     5 +
 drivers/net/wireless/ath/ath11k/trace.h            |     2 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   231 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |    37 +-
 drivers/net/wireless/ath/ath9k/debug.c             |     5 +-
 drivers/net/wireless/ath/carl9170/fwcmd.h          |     2 +-
 drivers/net/wireless/ath/carl9170/wlan.h           |    20 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |     3 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |     5 +-
 drivers/net/wireless/ath/wcn36xx/smd.h             |     2 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |    38 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |    17 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c       |     2 +
 drivers/net/wireless/ath/wil6210/wil6210.h         |     3 +
 drivers/net/wireless/ath/wil6210/wmi.c             |    11 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |     4 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    87 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |     6 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |    32 +
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |    28 +
 .../net/wireless/broadcom/brcm80211/brcmsmac/d11.h |     4 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |     3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/1000.c      |     8 +-
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c      |    14 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |    99 +-
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c      |     8 +-
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c      |    20 +-
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c      |     3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c      |     6 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |     1 -
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |    10 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tt.c        |     7 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |    50 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |    24 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |    12 +-
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |    18 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |    15 +
 .../net/wireless/intel/iwlwifi/fw/api/location.h   |     7 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |     5 +
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |    15 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rfi.h    |    60 +
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |     7 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |     5 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |    32 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |    88 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |     4 +
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |     3 +
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |     2 +
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |   185 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |    21 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |     2 +
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |    86 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h   |     6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |    16 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.c  |     9 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |    82 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |     6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |     1 +
 drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h   |    14 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |     1 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |    25 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |    47 +-
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile    |     1 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |    39 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   169 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |     3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   151 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |    18 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   133 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    31 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   274 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c       |   118 +
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |     5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |    13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   125 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |    26 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    23 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |     3 -
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |    10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   187 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |    61 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |    21 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   311 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |    20 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   283 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |    12 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   146 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |   130 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   177 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      |   133 +
 drivers/net/wireless/intel/iwlwifi/queue/tx.h      |     1 +
 drivers/net/wireless/marvell/libertas/if_sdio.c    |     2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |    35 +-
 drivers/net/wireless/marvell/mwl8k.c               |     5 +-
 drivers/net/wireless/mediatek/mt76/Kconfig         |     5 +
 drivers/net/wireless/mediatek/mt76/Makefile        |     4 +
 drivers/net/wireless/mediatek/mt76/dma.c           |     8 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |     4 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |     8 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |    75 +-
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |    24 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    16 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |     2 -
 drivers/net/wireless/mediatek/mt76/mt7615/Kconfig  |     3 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |    17 +
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |    64 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   210 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   192 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  1617 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |   683 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   132 +-
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |     9 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |    23 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c   |    11 +-
 .../net/wireless/mediatek/mt76/mt7615/testmode.c   |   101 +-
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |    12 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |   105 +
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |   119 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  1842 ++
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   979 +
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |     4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |     4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |     2 -
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |    10 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |     2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c   |     4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |    14 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c    |     2 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |     2 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_main.c   |     4 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |     2 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |     2 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |    28 +
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |   102 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |    42 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |    25 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |    48 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   129 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |     2 +
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |    46 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   542 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |    63 +
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |    69 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |   177 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |    29 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |   528 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.h   |    59 +
 drivers/net/wireless/mediatek/mt76/mt7921/Kconfig  |    11 +
 drivers/net/wireless/mediatek/mt76/mt7921/Makefile |     5 +
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |   250 +
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    |   356 +
 drivers/net/wireless/mediatek/mt76/mt7921/eeprom.c |   100 +
 drivers/net/wireless/mediatek/mt76/mt7921/eeprom.h |    27 +
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   282 +
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  1516 +
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    |   333 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  1161 +
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  1308 +
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |   434 +
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   342 +
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |   292 +
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |   419 +
 drivers/net/wireless/mediatek/mt76/testmode.c      |   124 +-
 drivers/net/wireless/mediatek/mt76/testmode.h      |    17 +
 drivers/net/wireless/mediatek/mt76/tx.c            |    39 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |     1 +
 drivers/net/wireless/microchip/wilc1000/netdev.c   |     2 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |    15 +-
 drivers/net/wireless/microchip/wilc1000/wlan.h     |     3 +-
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c     |     1 +
 drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c  |     2 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |     2 -
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |     4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/phy.c   |     2 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |     2 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |     3 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |     2 +-
 drivers/net/wireless/realtek/rtw88/main.c          |    10 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    17 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |   154 +-
 drivers/net/wireless/realtek/rtw88/pci.h           |    14 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |    62 +-
 drivers/net/wireless/realtek/rtw88/phy.h           |     3 +
 drivers/net/wireless/realtek/rtw88/reg.h           |     2 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |   109 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.h      |    22 +
 .../net/wireless/realtek/rtw88/rtw8821c_table.c    |   397 +
 .../net/wireless/realtek/rtw88/rtw8821c_table.h    |     1 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |     2 -
 .../net/wireless/realtek/rtw88/rtw8822c_table.c    | 32755 ++++++++++++++-----
 drivers/net/wireless/realtek/rtw88/tx.c            |    11 +-
 drivers/net/wireless/realtek/rtw88/tx.h            |     6 +-
 drivers/net/wireless/rsi/rsi_91x_core.c            |     3 +-
 drivers/net/wireless/ti/wl1251/cmd.c               |    36 +-
 drivers/net/wireless/wl3501.h                      |     2 +-
 include/linux/ssb/ssb_driver_gige.h                |    14 +-
 224 files changed, 40724 insertions(+), 13053 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/rfi.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76_connac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/Makefile
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/eeprom.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/main.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/pci.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/regs.h
