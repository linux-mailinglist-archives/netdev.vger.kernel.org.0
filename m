Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431E92D849A
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 06:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgLLFJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 00:09:37 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:58347 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbgLLFJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 00:09:10 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607749721; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=8RnOXl83fEmuMGHa5FIb9bhpDaffuPuLS3bWS25jmZs=; b=NUylzzpfRY1LKIQKTS5pZcKKz1VapmaRB9c0/8mI2OwfEQ2bEZwdZwnNmhfByUPPrHApvDZ+
 dPGrQWLX95Fkh+rC5RNTyEm+zirde+OJFgtASQGflSDRscay5w3v6vEkqdCkKxibFWNvjTJI
 tDXId9igHzIYklMcChUy7PBXo2s=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5fd45058f81e894c552e6228 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 12 Dec 2020 05:08:40
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EF50EC433C6; Sat, 12 Dec 2020 05:08:39 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 70C4BC433CA;
        Sat, 12 Dec 2020 05:08:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 70C4BC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2020-12-12
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20201212050839.EF50EC433C6@smtp.codeaurora.org>
Date:   Sat, 12 Dec 2020 05:08:39 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit af3f4a85d90218bb59315d591bd2bffa5e646466:

  Merge branch 'mlxsw-Misc-updates' Ido Schimmel says: (2020-12-06 19:22:15 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2020-12-12

for you to fetch changes up to 7ab250385ec276b7b37a2ecc96d375a75b573bd4:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2020-12-12 06:51:34 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for v5.11

Second set of patches for v5.11. iwlwifi gaining support for the new 6
GHz band and rtw88 got a new channel. Lots of new features for mt76
and ath11k now has working suspend for PCI devices. And as always,
smaller fixes and cleanups all over.

Major changes:

rtw88

* add support for channel 144

mt76

* support for more sta interfaces on mt7615/mt7915

* mt7915 encapsulation offload

* performance improvements

* channel noise report on mt7915

* mt7915 testmode support

* mt7915 DBDC support

iwlwifi

* support 6 GHz band

ath11k

* suspend support for QCA6390 PCI devices

* support TXOP duration based RTS threshold

* mesh: add support for 256 bitmap in blockack frames in 11ax

----------------------------------------------------------------
Abhishek Kumar (1):
      ath10k: add option for chip-id based BDF selection

Ajay Singh (1):
      wilc1000: changes for SPI communication stall issue found with Iperf

Allen Pais (1):
      wireless: mt76: convert tasklets to use new tasklet_setup() API

Anilkumar Kolli (2):
      ath11k: add 64bit check before reading msi high addr
      ath11k: fix rmmod failure if qmi sequence fails

Avraham Stern (1):
      iwlwifi: mvm: add size checks for range response notification

Bhaumik Bhatt (1):
      ath11k: use MHI provided APIs to allocate and free MHI controller

Carl Huang (13):
      ath11k: put hw to DBS using WMI_PDEV_SET_HW_MODE_CMDID
      ath11k: pci: fix hot reset stability issues
      ath11k: pci: fix L1ss clock unstable problem
      ath11k: pci: disable VDD4BLOW
      ath11k: mhi: hook suspend and resume
      ath11k: hif: implement suspend and resume functions
      ath11k: pci: read select_window register to ensure write is finished
      ath11k: htc: implement suspend handling
      ath11k: dp: stop rx pktlog before suspend
      ath11k: set credit_update flag for flow controlled ep only
      ath11k: implement WoW enable and wakeup commands
      ath11k: hif: add ce irq enable and disable functions
      ath11k: implement suspend for QCA6390 PCI devices

Chin-Yen Lee (1):
      rtw88: reduce polling time of IQ calibration

Christophe JAILLET (1):
      mwl8k: switch from 'pci_' to 'dma_' API

Chuanhong Guo (1):
      mt76: mt7615: retry if mt7615_mcu_init returns -EAGAIN

Colin Ian King (3):
      wilc1000: remove redundant assignment to pointer vif
      rtw88: coex: fix missing unitialization of variable 'interval'
      brcmfmac: remove redundant assignment to pointer 'entry'

Dan Carpenter (1):
      ath11k: unlock on error path in ath11k_mac_op_add_interface()

David Bauer (1):
      mt76: mt7603: add additional EEPROM chip ID

Devin Bayer (1):
      ath11k: pci: add MODULE_FIRMWARE macros

Emmanuel Grumbach (7):
      iwlwifi: mvm: remove the read_nvm from iwl_run_init_mvm_ucode
      iwlwifi: pcie: remove obsolete pre-release support code
      iwlwifi: mvm: remove the read_nvm from iwl_run_unified_mvm_ucode
      iwlwifi: follow the new inclusive terminology
      iwlwifi: sort out the NVM offsets
      iwlwifi: remove sw_csum_tx
      iwlwifi: mvm: purge the BSS table upon firmware load

Felix Fietkau (25):
      mt76: mt7915: add 802.11 encap offload support
      mt76: mt7915: add encap offload for 4-address mode stations
      mt76: use ieee80211_rx_list to pass frames to the network stack as a batch
      mt76: mt7615: add debugfs knob for setting extended local mac addresses
      mt76: do not set NEEDS_UNIQUE_STA_ADDR for 7615 and 7915
      mt76: mt7915: support 32 station interfaces
      mt76: mt7915: fix processing txfree events
      mt76: mt7915: use napi_consume_skb to bulk-free tx skbs
      mt76: mt7915: fix DRR sta bss group index
      mt76: mt7915: disable OFDMA/MU-MIMO UL
      mt76: rename __mt76_mcu_send_msg to mt76_mcu_send_msg
      mt76: rename __mt76_mcu_skb_send_msg to mt76_mcu_skb_send_msg
      mt76: implement .mcu_parse_response in struct mt76_mcu_ops
      mt76: move mcu timeout handling to .mcu_parse_response
      mt76: move waiting and locking out of mcu_ops->mcu_skb_send_msg
      mt76: make mcu_ops->mcu_send_msg optional
      mt76: mt7603: switch to .mcu_skb_send_msg
      mt76: implement functions to get the response skb for MCU calls
      mt76: mt7915: move eeprom parsing out of mt7915_mcu_parse_response
      mt76: mt7915: query station rx rate from firmware
      mt76: add back the SUPPORTS_REORDERING_BUFFER flag
      mt76: mt7915: fix endian issues
      mt76: improve tx queue stop/wake
      mt76: mt7915: stop queues when running out of tx tokens
      mt76: attempt to free up more room when filling the tx queue

Ganapathi Bhat (1):
      mwifiex: change license text of Makefile and README from MARVELL to NXP

Gustavo A. R. Silva (11):
      mt76: mt7615: Fix fall-through warnings for Clang
      airo: Fix fall-through warnings for Clang
      rt2x00: Fix fall-through warnings for Clang
      rtw88: Fix fall-through warnings for Clang
      zd1201: Fix fall-through warnings for Clang
      ath5k: Fix fall-through warnings for Clang
      carl9170: Fix fall-through warnings for Clang
      wcn36xx: Fix fall-through warnings for Clang
      iwlwifi: mvm: Fix fall-through warnings for Clang
      iwlwifi: dvm: Fix fall-through warnings for Clang
      iwlwifi: iwl-drv: Fix fall-through warnings for Clang

Janie Tu (1):
      iwlwifi: mvm: fix sar profile printing issue

Johannes Berg (23):
      iwlwifi: copy iwl_he_capa for modifications
      iwlwifi: validate MPDU length against notification length
      iwlwifi: pcie: validate RX descriptor length
      iwlwifi: mvm: clear up iwl_mvm_notify_rx_queue() argument type
      iwlwifi: mvm: move iwl_mvm_stop_device() out of line
      iwlwifi: pcie: change 12k A-MSDU config to use 16k buffers
      iwlwifi: mvm: fix 22000 series driver NMI
      iwlwifi: mvm: do more useful queue sync accounting
      iwlwifi: mvm: clean up scan state on failure
      iwlwifi: pcie: remove MSIX_HW_INT_CAUSES_REG_IML handling
      iwlwifi: fw: file: fix documentation for SAR flag
      iwlwifi: pcie: remove unnecessary setting of inta_mask
      iwlwifi: trans: consider firmware dead after errors
      iwlwifi: dbg-tlv: fix old length in is_trig_data_contained()
      iwlwifi: use SPDX tags
      iwlwifi: pcie: clean up some rx code
      iwlwifi: mvm: validate firmware sync response size
      iwlwifi: add an extra firmware state in the transport
      iwlwifi: support firmware reset handshake
      iwlwifi: mvm: disconnect if channel switch delay is too long
      iwlwifi: tighten RX MPDU bounds checks
      iwlwifi: mvm: hook up missing RX handlers
      iwlwifi: mvm: validate notification size when waiting

Kalle Valo (5):
      Merge tag 'mt76-for-kvalo-2020-12-04' of https://github.com/nbd168/wireless
      Merge tag 'iwlwifi-next-for-kalle-2020-12-09' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      ath11k: mhi: print a warning if firmware crashed
      ath11k: htc: remove unused struct ath11k_htc_ops
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Lee Jones (7):
      rtw88: pci: Add prototypes for .probe, .remove and .shutdown
      iwlwifi: mvm: rs: Demote non-conformant function documentation headers
      iwlwifi: iwl-eeprom-read: Demote one nonconformant function header
      iwlwifi: iwl-eeprom-parse: Fix 'struct iwl_eeprom_enhanced_txpwr's header
      iwlwifi: iwl-phy-db: Add missing struct member description for 'trans'
      iwlwifi: fw: dbg: Fix misspelling of 'reg_data' in function header
      iwlwifi: fw: acpi: Demote non-conformant function headers

Lorenzo Bianconi (37):
      mt76: mt7663s: move tx/rx processing in the same txrx workqueue
      mt76: mt7663s: convert txrx_work to mt76_worker
      mt76: mt7663s: disable interrupt during txrx_worker processing
      mt76: sdio: convert {status/net}_work to mt76_worker
      mt76: mt7615: enable beacon filtering by default for offload fw
      mt76: mt7615: introduce quota debugfs node for mt7663s
      mt76: mt7663s: get rid of mt7663s_sta_add
      mt76: mt7663s: fix a possible ple quota underflow
      mt76: sdio: get rid of sched.lock
      mt76: dma: fix possible deadlock running mt76_dma_cleanup
      mt76: fix memory leak if device probing fails
      mt76: move mt76_mcu_send_firmware in common module
      mt76: switch to wep sw crypto for mt7615/mt7915
      mt76: fix tkip configuration for mt7615/7663 devices
      mt76: mt7615: run key configuration in mt7615_set_key for usb/sdio devices
      mt76: mt76u: rely on woker APIs for rx work
      mt76: mt76u: use dedicated thread for status work
      mt76: mt7915: make mt7915_eeprom_read static
      mt76: mt7615: refactor usb/sdio rate code
      mt76: mt7915: rely on eeprom definitions
      mt76: move mt76_init_tx_queue in common code
      mt76: sdio: introduce mt76s_alloc_tx_queue
      mt76: sdio: rely on mt76_queue in mt76s_process_tx_queue signature
      mt76: mt7663s: rely on mt76_queue in mt7663s_tx_run_queue signature
      mt76: dma: rely on mt76_queue in mt76_dma_tx_cleanup signature
      mt76: rely on mt76_queue in tx_queue_skb signature
      mt76: introduce mt76_init_mcu_queue utility routine
      mt76: rely on mt76_queue in tx_queue_skb_raw signature
      mt76: move mcu queues to mt76_dev q_mcu array
      mt76: move tx hw data queues in mt76_phy
      mt76: move band capabilities in mt76_phy
      mt76: rely on mt76_phy in mt76_init_sband_2g and mt76_init_sband_5g
      mt76: move band allocation in mt76_register_phy
      mt76: move hw mac_addr in mt76_phy
      mt76: mt7915: introduce dbdc support
      mt76: mt7915: get rid of dbdc debugfs knob
      mt76: mt7615: fix rdd mcu cmd endianness

Luca Coelho (1):
      iwlwifi: mvm: add support for 6GHz

Mathy Vanhoef (1):
      ath9k_htc: adhere to the DONT_REORDER transmit flag

Matti Gottlieb (1):
      iwlwifi: Add a new card for MA family

Mordechay Goodstein (9):
      iwlwifi: remove all queue resources before free
      iwlwifi: yoyo: add the ability to dump phy periphery
      iwlwifi: move reclaim flows to the queue file
      iwlwifi: mvm: Init error table memory to zero
      iwlwifi: enable sending/setting debug host event
      iwlwifi: avoid endless HW errors at assert time
      iwlwifi: fix typo in comment
      iwlwifi: mvm: iterate active stations when updating statistics
      iwlwifi: mvm: check that statistics TLV version match struct version

Naftali Goldstein (1):
      iwlwifi: d3: do not send the WOWLAN_CONFIGURATION command for netdetect

Ping-Ke Shih (2):
      rtw88: fix multiple definition of rtw_pm_ops
      rtlwifi: rtl8192de: fix ofdm power compensation

Pradeep Kumar Chitrapu (4):
      ath11k: fix incorrect wmi param for configuring HE operation
      ath11k: support TXOP duration based RTS threshold
      ath11k: mesh: add support for 256 bitmap in blockack frames in 11ax
      ath11k: Fix incorrect tlvs in scan start command

Rotem Saado (1):
      iwlwifi: yoyo: align the write pointer to DWs

Ryder Lee (8):
      mt76: mt7915: measure channel noise and report it via survey
      mt76: mt7915: fix VHT LDPC capability
      mt76: mt7915: update ppe threshold
      mt76: mt7915: rename mt7915_mcu_get_rate_info to mt7915_mcu_get_tx_rate
      mt76: mt7915: fix sparse warning cast from restricted __le16
      mt76: mt7915: use BIT_ULL for omac_idx
      mt76: mt7915: remove unused mt7915_mcu_bss_sync_tlv()
      mt76: mt7615: support 16 interfaces

Sara Sharon (1):
      iwlwifi: mvm: fix a race in CSA that caused assert 0x3420

Sean Wang (1):
      mt76: mt7663s: introduce WoW support via GPIO

Seevalamuthu Mariappan (1):
      ath11k: Ignore resetting peer auth flag in peer assoc cmd

Shayne Chen (12):
      mt76: testmode: switch ib and wb rssi to array type for per-antenna report
      mt76: testmode: add snr attribute in rx statistics
      mt76: testmode: add tx_rate_stbc parameter
      mt76: testmode: add support for LTF and GI combinations for HE mode
      mt76: mt7915: fix tx rate related fields in tx descriptor
      mt76: testmode: add support for HE rate modes
      mt76: mt7915: implement testmode tx support
      mt76: mt7915: implement testmode rx support
      mt76: mt7915: add support to set txpower in testmode
      mt76: mt7915: add support to set tx frequency offset in testmode
      mt76: mt7915: fix memory leak in mt7915_mcu_get_rx_rate()
      mt76: mt7915: fix ht mcs in mt7915_mcu_get_rx_rate()

Souptick Joarder (1):
      mt76: remove unused variable q

Taehee Yoo (2):
      mt76: mt7915: set fops_sta_stats.owner to THIS_MODULE
      mt76: set fops_tx_stats.owner to THIS_MODULE

Tom Rix (2):
      ath9k: remove trailing semicolon in macro definition
      carl9170: remove trailing semicolon in macro definition

Wen Gong (2):
      ath10k: fix a check patch warning returnNonBoolInBooleanFunction of sdio.c
      ath10k: add atomic protection for device recovery

Zhang Changzhong (1):
      adm8211: fix error return code in adm8211_probe()

Zhang Xiaohui (1):
      mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start

Zheng Yongjun (1):
      cw1200: txrx: convert comma to semicolon

Zong-Zhe Yang (1):
      rtw88: declare hw supports ch 144

 drivers/net/wireless/admtek/adm8211.c              |   6 +-
 drivers/net/wireless/ath/ath10k/core.c             |  54 +-
 drivers/net/wireless/ath/ath10k/core.h             |   4 +
 drivers/net/wireless/ath/ath10k/debug.c            |   6 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   1 +
 drivers/net/wireless/ath/ath10k/pci.c              |   2 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |   8 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   2 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   2 +-
 drivers/net/wireless/ath/ath11k/Makefile           |   3 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |   9 +-
 drivers/net/wireless/ath/ath11k/ce.c               |   2 +-
 drivers/net/wireless/ath/ath11k/ce.h               |   2 +
 drivers/net/wireless/ath/ath11k/core.c             | 100 ++-
 drivers/net/wireless/ath/ath11k/core.h             |  12 +
 drivers/net/wireless/ath/ath11k/debugfs.c          |   1 +
 drivers/net/wireless/ath/ath11k/dp.c               |   2 +-
 drivers/net/wireless/ath/ath11k/dp.h               |   2 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  48 ++
 drivers/net/wireless/ath/ath11k/dp_rx.h            |   3 +
 drivers/net/wireless/ath/ath11k/hif.h              |  32 +
 drivers/net/wireless/ath/ath11k/htc.c              |  31 +-
 drivers/net/wireless/ath/ath11k/htc.h              |  10 +-
 drivers/net/wireless/ath/ath11k/hw.h               |   7 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  48 +-
 drivers/net/wireless/ath/ath11k/mhi.c              |  27 +-
 drivers/net/wireless/ath/ath11k/mhi.h              |   3 +
 drivers/net/wireless/ath/ath11k/pci.c              | 227 ++++++-
 drivers/net/wireless/ath/ath11k/pci.h              |  25 +
 drivers/net/wireless/ath/ath11k/qmi.c              |  41 +-
 drivers/net/wireless/ath/ath11k/wmi.c              | 178 +++--
 drivers/net/wireless/ath/ath11k/wmi.h              | 170 ++++-
 drivers/net/wireless/ath/ath11k/wow.c              |  73 ++
 drivers/net/wireless/ath/ath11k/wow.h              |  10 +
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |   1 +
 drivers/net/wireless/ath/ath9k/common-debug.c      |   2 +-
 drivers/net/wireless/ath/ath9k/dfs_debug.c         |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   7 +-
 drivers/net/wireless/ath/carl9170/debug.c          |   4 +-
 drivers/net/wireless/ath/carl9170/tx.c             |   1 +
 drivers/net/wireless/ath/wcn36xx/smd.c             |   2 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |   2 +-
 drivers/net/wireless/cisco/airo.c                  |   1 +
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  70 +-
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c      |  70 +-
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c      |  69 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |  58 +-
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h       |  61 +-
 drivers/net/wireless/intel/iwlwifi/dvm/calib.c     |  61 +-
 drivers/net/wireless/intel/iwlwifi/dvm/calib.h     |  60 +-
 drivers/net/wireless/intel/iwlwifi/dvm/commands.h  |  61 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c        |  22 +-
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  97 +--
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |  74 +--
 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h  |  69 +-
 .../net/wireless/intel/iwlwifi/fw/api/binding.h    |  67 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/cmdhdr.h |  67 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/coex.h   |  69 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |  70 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/config.h |  70 +-
 .../net/wireless/intel/iwlwifi/fw/api/context.h    |  68 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |  69 +-
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |  70 +-
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |  61 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |  81 +--
 drivers/net/wireless/intel/iwlwifi/fw/api/filter.h |  68 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/led.h    |  62 +-
 .../net/wireless/intel/iwlwifi/fw/api/location.h   |  64 +-
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    |  70 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |  64 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |  78 +--
 .../net/wireless/intel/iwlwifi/fw/api/offload.h    |  68 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/paging.h |  67 +-
 .../net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h   |  69 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/phy.h    |  70 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |  70 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |  66 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |  68 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |  83 +--
 drivers/net/wireless/intel/iwlwifi/fw/api/sf.h     |  68 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/soc.h    |  68 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h    |  67 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/stats.h  |  69 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h   |  70 +-
 .../net/wireless/intel/iwlwifi/fw/api/time-event.h |  70 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |  64 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h    |  69 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 153 +++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |  70 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |  96 +--
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h    |  68 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |  69 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |  79 +--
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |  68 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |  64 +-
 drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c |  64 +-
 drivers/net/wireless/intel/iwlwifi/fw/notif-wait.h |  63 +-
 drivers/net/wireless/intel/iwlwifi/fw/paging.c     |  69 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |  62 +-
 drivers/net/wireless/intel/iwlwifi/fw/smem.c       |  67 +-
 drivers/net/wireless/intel/iwlwifi/iwl-agn-hw.h    |  61 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  68 +-
 .../wireless/intel/iwlwifi/iwl-context-info-gen3.h |  56 +-
 .../net/wireless/intel/iwlwifi/iwl-context-info.h  |  58 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |  71 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |  67 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h   |  64 +-
 drivers/net/wireless/intel/iwlwifi/iwl-debug.c     |  62 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  71 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h       |  64 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.c  |  77 +--
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.h  |  76 +--
 .../net/wireless/intel/iwlwifi/iwl-eeprom-read.c   |  64 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-read.h   |  61 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |  66 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |  68 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.h        |  61 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h |  61 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 176 +++--
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |  65 +-
 drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h   |  69 +-
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c    |  80 +--
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h    |  62 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |  93 +--
 drivers/net/wireless/intel/iwlwifi/iwl-scd.h       |  62 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |  67 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  99 +--
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c   |  65 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |  65 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |  71 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  82 +--
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  67 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  71 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h   |  65 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 112 ++--
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |  64 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |  70 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 108 +--
 drivers/net/wireless/intel/iwlwifi/mvm/led.c       |  69 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  97 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 131 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  88 +--
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |  69 +-
 .../net/wireless/intel/iwlwifi/mvm/offloading.c    |  67 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       | 103 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |  71 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |  70 +-
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c     |  68 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |  76 +--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        | 122 +---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      | 148 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 423 +++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c        |  66 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  86 +--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |  70 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |  68 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |  68 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.h    |  67 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |  70 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  80 +--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  71 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |  57 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |  60 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  90 +--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  80 +--
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       | 113 +---
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |  83 +--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 155 +----
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  57 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 351 +---------
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      | 308 +++++++--
 drivers/net/wireless/intel/iwlwifi/queue/tx.h      |  68 +-
 drivers/net/wireless/marvell/mwifiex/Makefile      |   6 +-
 drivers/net/wireless/marvell/mwifiex/README        |   7 +-
 drivers/net/wireless/marvell/mwifiex/join.c        |   2 +
 drivers/net/wireless/marvell/mwl8k.c               |  72 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c       |   4 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |  37 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |  12 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      | 149 +++--
 drivers/net/wireless/mediatek/mt76/mcu.c           |  80 +++
 drivers/net/wireless/mediatek/mt76/mt76.h          | 121 +++-
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |  30 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |  61 +-
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |  12 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    | 131 ++--
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/pci.c    |   3 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    | 139 +++-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |  55 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |  22 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |  23 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    | 199 +++---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   | 122 ++--
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    | 544 +++++++--------
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |  17 +
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |  92 +--
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |  11 +
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c   |  71 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_mcu.c   |  42 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_txrx.c  | 142 ++--
 .../net/wireless/mediatek/mt76/mt7615/testmode.c   |  28 +-
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |   9 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_mcu.c    |  16 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |  89 +--
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |  12 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |   3 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci_mcu.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c   |  10 +-
 .../net/wireless/mediatek/mt76/mt76x02_eeprom.c    |   8 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |  16 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c   |  55 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h   |   2 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |  76 +--
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |   2 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |  13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c    |  18 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |   3 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_mcu.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt7915/Makefile |   2 +
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |  47 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |  76 +--
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |  64 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |   1 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   | 435 ++++++------
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    | 539 +++++++++++----
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |  16 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   | 133 +++-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    | 734 +++++++++++++--------
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |  54 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |  64 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |  24 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |  52 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   | 377 +++++++++++
 .../net/wireless/mediatek/mt76/mt7915/testmode.h   |  40 ++
 drivers/net/wireless/mediatek/mt76/sdio.c          | 196 +++---
 drivers/net/wireless/mediatek/mt76/testmode.c      |  41 +-
 drivers/net/wireless/mediatek/mt76/testmode.h      |  18 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |  60 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |  89 ++-
 drivers/net/wireless/microchip/wilc1000/spi.c      |  23 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |   1 -
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c   |   1 +
 .../net/wireless/realtek/rtlwifi/rtl8192de/dm.c    |  13 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |   2 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |   2 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   1 +
 drivers/net/wireless/realtek/rtw88/pci.h           |   8 +
 drivers/net/wireless/realtek/rtw88/rtw8723de.c     |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8723de.h     |   4 -
 drivers/net/wireless/realtek/rtw88/rtw8821ce.c     |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8821ce.h     |   4 -
 drivers/net/wireless/realtek/rtw88/rtw8822be.c     |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8822be.h     |   4 -
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  17 +-
 drivers/net/wireless/realtek/rtw88/rtw8822ce.c     |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8822ce.h     |   4 -
 drivers/net/wireless/st/cw1200/txrx.c              |   2 +-
 drivers/net/wireless/zydas/zd1201.c                |   2 +-
 276 files changed, 6622 insertions(+), 10777 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath11k/wow.c
 create mode 100644 drivers/net/wireless/ath/ath11k/wow.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/testmode.h
