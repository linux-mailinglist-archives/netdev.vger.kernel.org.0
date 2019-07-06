Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC23D60F47
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 09:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbfGFHE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 03:04:28 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48166 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfGFHE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 03:04:28 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 58BD860A4E; Sat,  6 Jul 2019 07:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1562396666;
        bh=1IY073TffnETI0jbiqswuT2o30hS7nxeZuNQscxY/lM=;
        h=From:To:Cc:Subject:Date:From;
        b=cRzte7oc4ix5tFmIFkffG8mA5XJXs/FmQzmk2GeC/Q0o6uO+zKzIjutF1df1nFux1
         xNcXk7F8y0MUsnH6dlz2wSVwx1WUlqmv+Yz05Nr0K3VJ5LomebHlD6pCQ61HZ8vlTr
         F6uOS3bs8z+7rRJqWUTgQdBeBJFsy/Y2SlU5Jiv8=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 08B6D602B7;
        Sat,  6 Jul 2019 07:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1562396665;
        bh=1IY073TffnETI0jbiqswuT2o30hS7nxeZuNQscxY/lM=;
        h=From:To:Cc:Subject:Date:From;
        b=mLzdBEjbg0ysrL0/IjHrwEMDQzkk8HyZ2koKVpqhvIhq5eOntHJaGhk2o/FWstV6E
         8B549OHjmijb4Kmk3wLGJ4SJg5ZSl+/IdW18AMqlulGP1/r1h/dFfqfda5/srKSI0l
         PbyUpU9xokhNC4iJzfWdtvhZXcP5oewOSKLJn6bU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 08B6D602B7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2019-07-06
Date:   Sat, 06 Jul 2019 10:04:20 +0300
Message-ID: <878stbabkb.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

here's a pull request to net-next tree for v5.3, more info below. I will
be offline from Sunday to Thursday, but Johannes should be able to help
during that time.

Kalle

The following changes since commit 8b89d8dad5df177032e7e97ecfb18f01134e0e4b:

  Merge branch 'macb-build-fixes' (2019-06-26 14:09:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-for-davem-2019-07-06

for you to fetch changes up to 5adcdab6ae1b0a53456e8a269b1856094dc20a59:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2019-07-01 22:23:11 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for 5.3

Second, and last, set of patches for 5.3.

Major changes:

mt76

* use NAPI polling for tx cleanup on mt7603/mt7615

* add support for toggling edcca on mt7603

* fix rate control / tx status reporting issues on mt76x02/mt7603

* add support for eeprom calibration data from mtd on mt7615

* support configuring tx power on mt7615

* per-chain signal reporting on mt7615

iwlwifi

* Update the FW API for Channel State Information (CSI)

* Special Specific Absorption Rate (SAR) implementation for South Korea

ath10k

* fixes for SDIO support

* add support for firmware logging via WMI

----------------------------------------------------------------
Ahmad Masri (4):
      wil6210: enlarge Tx status ring size
      wil6210: increase the frequency of status ring hw tail update
      wil6210: set WIL_WMI_CALL_GENERAL_TO_MS as wmi_call timeout
      wil6210: drop old event after wmi_call timeout

Alexei Avshalom Lazar (3):
      wil6210: do not reset FW in STA to P2P client interface switch
      wil6210: Add support for setting RBUFCAP configuration
      wil6210: update cid boundary check of wil_find_cid/_by_idx()

Andrei Otcheretianski (1):
      iwlwifi: mvm: Drop large non sta frames

Ashok Raj Nagarajan (1):
      ath10k: add support for controlling tx power to a station

Balaji Pothunoori (1):
      ath10k: enabling tx stats support over pktlog

Brian Norris (2):
      mwifiex: dispatch/rotate from reorder table atomically
      mwifiex: don't disable hardirqs; just softirqs

Christian Lamparter (2):
      carl9170: fix misuse of device driver API
      carl9170: remove dead branch in op_conf_tx callback

Christoph Hellwig (4):
      b43legacy: remove b43legacy_dma_set_mask
      b43legacy: simplify engine type / DMA mask selection
      b43: remove b43_dma_set_mask
      b43: simplify engine type / DMA mask selection

Claire Chang (2):
      ath10k: acquire lock to fix lockdep's warning
      ath10k: add missing error handling

Dan Carpenter (3):
      mt76: Fix a signedness bug in mt7615_add_interface()
      mt76: mt7615: Use after free in mt7615_mcu_set_bcn()
      iwlwifi: remove some unnecessary NULL checks

Dedy Lansky (1):
      wil6210: fix printout in wil_read_pmccfg

Dundi Raviteja (2):
      ath10k: Add peer delete response event
      ath10k: Fix memory leak in qmi

Emmanuel Grumbach (7):
      iwlwifi: support FSEQ TLV even when FMAC is not compiled
      iwlwifi: mvm: make the usage of TWT configurable
      iwlwifi: pcie: fix ALIVE interrupt handling for gen2 devices w/o MSI-X
      iwlwifi: fix RF-Kill interrupt while FW load for gen2 devices
      iwlwifi: pcie: don't service an interrupt that was masked
      iwlwifi: don't WARN when calling iwl_get_shared_mem_conf with RF-Kill
      iwlwifi: mvm: clear rfkill_safe_init_done when we start the firmware

Erik Stromdahl (2):
      ath10k: add inline wrapper for htt_h2t_aggr_cfg_msg
      ath10k: add htt_h2t_aggr_cfg_msg op for high latency devices

Fabio Estevam (1):
      ath10k: Change the warning message string

Felix Fietkau (7):
      mt76: mt7603: fix reading target tx power from eeprom
      mt76: fix setting chan->max_power
      mt76: mt76x02: fix tx status reporting issues
      mt76: mt76x02: fix tx reordering on rate control probing without a-mpdu
      mt76: mt76x0: fix RF frontend initialization for external PA
      mt76: mt7603: rework and fix tx status reporting
      mt76: mt7603: improve hardware rate switching configuration

Govind Singh (1):
      ath10k: Add WMI diag fw logging support for WCN3990

Greg Kroah-Hartman (1):
      wil6210: no need to check return value of debugfs_create functions

Gustavo A. R. Silva (2):
      iwlwifi: lib: Use struct_size() helper
      iwlwifi: d3: Use struct_size() helper

Haim Dreyfuss (2):
      iwlwifi: Add support for SAR South Korea limitation
      iwlwifi: mvm: Add log information about SAR status

Jiri Kosina (1):
      iwlwifi: iwl_mvm_tx_mpdu() must be called with BH disabled

Johannes Berg (3):
      iwlwifi: update CSI API
      iwlwifi: fix module init error paths
      iwlwifi: mvm: delay GTK setting in FW in AP mode

Kalle Valo (5):
      ath10k: remove unnecessary 'out of memory' message
      ath10k: pci: remove unnecessary casts
      Merge tag 'mt76-for-kvalo-2019-06-27' of https://github.com/nbd168/wireless
      Merge tag 'iwlwifi-next-for-kalle-2019-06-29' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Lorenzo Bianconi (53):
      mt76: mt76x02: remove useless return in mt76x02_resync_beacon_timer
      mt76: move tx_napi in mt76_dev
      mt76: mt7603: use napi polling for tx cleanup
      mt76: mt7615: use napi polling for tx cleanup
      mt76: move netif_napi_del in mt76_dma_cleanup
      mt7615: mcu: simplify __mt7615_mcu_set_wtbl
      mt7615: mcu: simplify __mt7615_mcu_set_sta_rec
      mt7615: mcu: remove bss_info_convert_vif_type routine
      mt7615: mcu: use proper msg size in mt7615_mcu_add_wtbl_bmc
      mt7615: mcu: use proper msg size in mt7615_mcu_add_wtbl
      mt7615: mcu: unify mt7615_mcu_add_wtbl_bmc and mt7615_mcu_del_wtbl_bmc
      mt7615: mcu: remove unused parameter in mt7615_mcu_del_wtbl
      mt7615: remove query from mt7615_mcu_msg_send signature
      mt7615: remove dest from mt7615_mcu_msg_send signature
      mt7615: mcu: remove skb_ret from mt7615_mcu_msg_send
      mt7615: mcu: unify __mt7615_mcu_set_dev_info and mt7615_mcu_set_dev_info
      mt7615: mcu: do not use function pointers whenever possible
      mt7615: mcu: remove unused structure in mcu.h
      mt7615: mcu: use standard signature for mt7615_mcu_msg_send
      mt7615: initialize mt76_mcu_ops data structure
      mt7615: mcu: init mcu_restart function pointer
      mt7615: mcu: run __mt76_mcu_send_msg in mt7615_mcu_send_firmware
      mt76: mt7603: stop mac80211 queues before setting the channel
      mt76: mt7615: rearrange cleanup operations in mt7615_unregister_device
      mt76: mt7615: add static qualifier to mt7615_rx_poll_complete
      mt76: mt76x02: remove enable from mt76x02_edcca_init signature
      mt76: mt76x2u: remove mt76x02_edcca_init in mt76x2u_set_channel
      mt76: mt76x2: move mutex_lock inside mt76x2_set_channel
      mt76: mt76x02: run mt76x02_edcca_init atomically in mt76_edcca_set
      mt76: mt7603: add debugfs knob to enable/disable edcca
      mt76: mt76x02: fix edcca file permission
      mt76: mt7615: do not process rx packets if the device is not initialized
      mt76: move mt76_insert_ccmp_hdr in mt76-module
      mt76: mt7615: add support for mtd eeprom parsing
      mt76: mt7615: select wifi band according to eeprom
      mt76: generalize mt76_get_txpower for 4x4:4 devices
      mt76: mt7615: add the capability to configure tx power
      mt76: mt7615: init get_txpower mac80211 callback
      mt76: mt7615: rearrange locking in mt7615_config
      mt76: move mt76_get_rate in mt76-module
      mt76: mt7615: remove unused variable in mt7615_mcu_set_bcn
      mt76: mt7615: remove key check in mt7615_mcu_set_wtbl_key
      mt76: mt7615: simplify mt7615_mcu_set_sta_rec routine
      mt76: mt7615: init per-channel target power
      mt76: mt7615: take into account extPA when configuring tx power
      mt76: mt76x02u: fix sparse warnings: should it be static?
      mt76: mt76u: reduce rx memory footprint
      mt76: mt7615: remove cfg80211_chan_def from mt7615_set_channel signature
      mt76: move nl80211_dfs_regions in mt76_dev data structure
      mt76: mt76u: get rid of {out,in}_max_packet
      mt76: mt7615: fix sparse warnings: incorrect type in assignment (different base types)
      mt76: mt7615: fix sparse warnings: warning: cast from restricted __le16
      mt76: mt7603: fix sparse warnings: warning: incorrect type in assignment (different base types)

Luca Coelho (2):
      iwlwifi: pcie: increase the size of PCI dumps
      iwlwifi: mvm: remove MAC_FILTER_IN_11AX for AP mode

Maya Erez (2):
      wil6210: clear FW and ucode log address
      wil6210: publish max_msdu_size to FW on BCAST ring

Miaoqing Pan (3):
      ath10k: fix fw crash by moving chip reset after napi disabled
      ath10k: fix failure to set multiple fixed rate
      ath10k: fix PCIE device wake up failed

Mordechay Goodstein (2):
      iwlwifi: mvm: add a debugfs entry to set a fixed size AMSDU for all TX packets
      iwlwifi: mvm: remove multiple debugfs entries

Naftali Goldstein (1):
      iwlwifi: mvm: correctly fill the ac array in the iwl_mac_ctx_cmd

Rakesh Pillai (1):
      ath10k: wait for vdev delete response from firmware

Ryder Lee (5):
      mt76: mt7615: enable support for mesh
      mt76: mt7615: fix slow performance when enable encryption
      mt76: mt7615: add support for per-chain signal strength reporting
      mt76: mt7615: fix incorrect settings in mesh mode
      mt76: mt7615: update peer's bssid when state transition occurs

Shahar S Matityahu (15):
      iwlwifi: dbg: allow dump collection in case of an early error
      iwlwifi: dbg_ini: dump headers cleanup
      iwlwifi: dbg_ini: abort region collection in case the size is 0
      iwlwifi: dbg_ini: add consecutive trigger firing support
      iwlwifi: dbg_ini: use different barker for ini dump
      iwlwifi: dbg_ini: support debug info TLV
      iwlwifi: dbg_ini: implement dump info collection
      iwlwifi: fw api: support adwell HB default APs number api
      iwlwifi: dbg: fix debug monitor stop and restart delays
      iwlwifi: dbg_ini: enforce apply point early on buffer allocation tlv
      iwlwifi: dbg_ini: remove redundant checking of ini mode
      iwlwifi: dbg: move trans debug fields to a separate struct
      iwlwifi: dbg_ini: fix debug monitor stop and restart in ini mode
      iwlwifi: dbg: don't stop dbg recording before entering D3 from 9000 devices
      iwlwifi: dbg: debug recording stop and restart command remove

Shaul Triebitz (1):
      iwlwifi: mvm: convert to FW AC when configuring MU EDCA

Tzahi Sabo (1):
      wil6210: add support for reading multiple RFs temperature via debugfs

Tzu-En Huang (1):
      rtw88: remove all RTW_MAX_POWER_INDEX macro

Venkateswara Naralasetty (1):
      ath10k: Add wrapper function to ath10k debug

Wen Gong (6):
      ath10k: add support for firmware crash recovery on SDIO chip
      ath10k: change firmware file name for UTF mode of SDIO/USB
      ath10k: add report MIC error for sdio chip
      ath10k: add new hw_ops for sdio chip
      ath10k: Move non-fatal warn logs to dbg level for SDIO chip
      ath10k: destroy sdio workqueue while remove sdio module

Yan-Hsuan Chuang (6):
      rtw88: resolve order of tx power setting routines
      rtw88: do not use (void *) as argument
      rtw88: unify prefixes for tx power setting routine
      rtw88: remove unused variable
      rtw88: fix incorrect tx power limit at 5G
      rtw88: choose the lowest as world-wide power limit

YueHaibing (2):
      mt76: mt7615: Make mt7615_irq_handler static
      mt76: Remove set but not used variables 'pid' and 'final_mpdu'

Zefir Kurtisi (1):
      ath9k: correctly handle short radar pulses

Zong-Zhe Yang (3):
      rtw88: correct power limit selection
      rtw88: update tx power limit table to RF v20
      rtw88: refine flow to get tx power index

 drivers/net/wireless/ath/ath10k/core.c             |   34 +-
 drivers/net/wireless/ath/ath10k/core.h             |   15 +-
 drivers/net/wireless/ath/ath10k/debug.c            |    8 +-
 drivers/net/wireless/ath/ath10k/debug.h            |   25 +-
 drivers/net/wireless/ath/ath10k/hif.h              |   15 +
 drivers/net/wireless/ath/ath10k/htt.c              |    2 +-
 drivers/net/wireless/ath/ath10k/htt.h              |   16 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   20 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |    9 +-
 drivers/net/wireless/ath/ath10k/hw.c               |    6 +-
 drivers/net/wireless/ath/ath10k/hw.h               |    7 +
 drivers/net/wireless/ath/ath10k/mac.c              |  209 +++-
 drivers/net/wireless/ath/ath10k/pci.c              |   25 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |   46 +
 drivers/net/wireless/ath/ath10k/qmi.h              |    1 +
 drivers/net/wireless/ath/ath10k/sdio.c             |   17 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   15 +
 drivers/net/wireless/ath/ath10k/swap.c             |    4 +-
 drivers/net/wireless/ath/ath10k/testmode.c         |   17 +-
 drivers/net/wireless/ath/ath10k/trace.c            |    1 +
 drivers/net/wireless/ath/ath10k/trace.h            |    6 +-
 drivers/net/wireless/ath/ath10k/usb.c              |    2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   33 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |    8 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |   16 +-
 drivers/net/wireless/ath/ath9k/recv.c              |    6 +-
 drivers/net/wireless/ath/carl9170/main.c           |    9 +-
 drivers/net/wireless/ath/carl9170/usb.c            |   39 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |   22 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |  168 +--
 drivers/net/wireless/ath/wil6210/main.c            |   19 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |    1 +
 drivers/net/wireless/ath/wil6210/rx_reorder.c      |   31 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |    9 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c       |   16 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.h       |    2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |    6 +
 drivers/net/wireless/ath/wil6210/wmi.c             |  127 +-
 drivers/net/wireless/ath/wil6210/wmi.h             |   47 +-
 drivers/net/wireless/broadcom/b43/dma.c            |   69 +-
 drivers/net/wireless/broadcom/b43legacy/dma.c      |   57 +-
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c       |    3 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |   28 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |    5 +-
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |   22 +
 .../net/wireless/intel/iwlwifi/fw/api/location.h   |   11 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |   12 +
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |   15 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  427 ++++---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |  133 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |  111 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   17 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |    7 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |   28 +-
 drivers/net/wireless/intel/iwlwifi/fw/smem.c       |   12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   33 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   35 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   75 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |    1 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   66 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   72 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   16 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   66 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |    9 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   26 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   25 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |    4 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   16 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   20 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |   10 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |    2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   29 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   68 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   11 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  187 +--
 drivers/net/wireless/marvell/mwifiex/11n.c         |   53 +-
 drivers/net/wireless/marvell/mwifiex/11n.h         |    5 +-
 drivers/net/wireless/marvell/mwifiex/11n_aggr.c    |   26 +-
 drivers/net/wireless/marvell/mwifiex/11n_aggr.h    |    2 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |  125 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   35 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |   76 +-
 drivers/net/wireless/marvell/mwifiex/init.c        |   32 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |   29 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |   58 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |    5 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |   10 +-
 drivers/net/wireless/marvell/mwifiex/tdls.c        |   68 +-
 drivers/net/wireless/marvell/mwifiex/txrx.c        |    5 +-
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c    |   10 +-
 drivers/net/wireless/marvell/mwifiex/usb.c         |   10 +-
 drivers/net/wireless/marvell/mwifiex/util.c        |   15 +-
 drivers/net/wireless/marvell/mwifiex/wmm.c         |  109 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |    1 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   62 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   23 +-
 drivers/net/wireless/mediatek/mt76/mt7603/core.c   |    2 +-
 .../net/wireless/mediatek/mt76/mt7603/debugfs.c    |   30 +
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |   29 +-
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.h |    2 +
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |   26 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |  191 +--
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    8 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |   15 +-
 drivers/net/wireless/mediatek/mt76/mt7603/regs.h   |    6 +
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |   23 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |   97 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h |   61 +
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   77 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   85 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |    5 +
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   52 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    | 1265 ++++++++++---------
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |   56 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   16 +-
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |    7 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |    5 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |    1 -
 .../net/wireless/mediatek/mt76/mt76x02_beacon.c    |    4 +-
 .../net/wireless/mediatek/mt76/mt76x02_debugfs.c   |   10 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c   |   18 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.h   |    2 -
 .../net/wireless/mediatek/mt76/mt76x02_eeprom.h    |    1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |  106 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |   18 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h  |    3 +
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c  |    9 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |   11 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c   |    9 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_main.c   |   16 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_phy.c    |    8 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |    2 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |   23 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_phy.c    |    7 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |   20 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   26 +-
 drivers/net/wireless/realtek/rtw88/main.h          |   27 +-
 drivers/net/wireless/realtek/rtw88/phy.c           | 1298 +++++++++++---------
 drivers/net/wireless/realtek/rtw88/phy.h           |   18 +-
 drivers/net/wireless/realtek/rtw88/regd.c          |   69 +-
 drivers/net/wireless/realtek/rtw88/regd.h          |    4 +
 .../net/wireless/realtek/rtw88/rtw8822c_table.c    |  799 +++++++++++-
 150 files changed, 5196 insertions(+), 2976 deletions(-)
