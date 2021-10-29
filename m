Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FC843FD8F
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 15:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhJ2Ntn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 09:49:43 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:25061 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231594AbhJ2Ntm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 09:49:42 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635515233; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=MhO4/NVbYZrm1JjbzH4nFVOMt6qQ2O61FeFQ0NTX31Q=; b=GA3OjGpP5V/i6M/Pe5U+ITaoBKNWtgFRZlh15KIxJhkR1/rcDnjCZgOWcyf29wVqlwTtbbLU
 6008tOAB670mqNVbJJE1Kxy2eseJYVlHUFaV/sQbctrX50fChIwrwnU/Y6rEwoU1dxqhAshu
 2/QLhqQGTnTrvPRR3d3r0iHuOpQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 617bfb5c648aeeca5c770272 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 Oct 2021 13:47:08
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DE2B0C4360D; Fri, 29 Oct 2021 13:47:07 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 15F47C4338F;
        Fri, 29 Oct 2021 13:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 15F47C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2021-10-29
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20211029134707.DE2B0C4360D@smtp.codeaurora.org>
Date:   Fri, 29 Oct 2021 13:47:07 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 06338ceff92510544a732380dbb2d621bd3775bf:

  net: phy: fixed warning: Function parameter not described (2021-10-26 14:09:50 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2021-10-29

for you to fetch changes up to 2619f904b25cd056fba9b4694c57647d6782b1af:

  Merge tag 'iwlwifi-next-for-kalle-2021-10-28' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2021-10-28 16:29:15 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.16

Fourth set of patches for v5.16. Mostly fixes this time, wcn36xx and
iwlwifi have some new features but nothing really out of ordinary. We
have one conflict with kspp tree.

Conflicts:

kspp tree has a conflict in drivers/net/wireless/intel/iwlwifi/fw/api/tx.h:

https://lkml.kernel.org/r/20211028192934.01520d7e@canb.auug.org.au

Major changes:

ath11k

* fix QCA6390 A-MSDU handling (CVE-2020-24588)

wcn36xx

* enable hardware scan offload for 5Ghz band

* add missing 5GHz channels 136 and 144

iwlwifi

* support a new ACPI table revision

* improvements in the device selection code

* new hardware support

* support for WiFi 6E enablement via BIOS

* support firmware API version 67

* support for 160MHz in ranging measurements

----------------------------------------------------------------
Abinaya Kalaiselvan (1):
      ath10k: fix module load regression with iram-recovery feature

Arnd Bergmann (1):
      ath10k: fix invalid dma_addr_t token assignment

Avraham Stern (1):
      iwlwifi: mvm: add support for 160Mhz in ranging measurements

Ayala Barazani (1):
      iwlwifi: ACPI: support revision 3 WGDS tables

Baochen Qiang (1):
      ath11k: change return buffer manager for QCA6390

Benjamin Li (3):
      wcn36xx: add proper DMA memory barriers in rx path
      wcn36xx: switch on antenna diversity feature bit
      wcn36xx: add missing 5GHz channels 136 and 144

Bryan O'Donoghue (3):
      wcn36xx: Treat repeated BMPS entry fail as connection loss
      Revert "wcn36xx: Disable bmps when encryption is disabled"
      Revert "wcn36xx: Enable firmware link monitoring"

Cai Huoqing (1):
      mt76: Make use of the helper macro kthread_run()

Emmanuel Grumbach (1):
      iwlwifi: mvm: fix some kerneldoc issues

Felix Fietkau (1):
      mt76: connac: fix unresolved symbols when CONFIG_PM is unset

Geert Uytterhoeven (1):
      wlcore: spi: Use dev_err_probe()

Gregory Greenman (2):
      iwlwifi: mvm: improve log when processing CSA
      iwlwifi: mvm: update RFI TLV

Hauke Mehrtens (1):
      mt76: Print error message when reading EEPROM from mtd failed

Ilan Peer (1):
      iwlwifi: mvm: Use all Rx chains for roaming scan

Johan Hovold (7):
      ath10k: fix control-message timeout
      ath6kl: fix control-message timeout
      ath10k: fix division by zero in send path
      ath6kl: fix division by zero in send path
      rtl8187: fix control-message timeouts
      rsi: fix control-message timeout
      mwifiex: fix division by zero in fw download path

Johannes Berg (30):
      iwlwifi: mvm: fix ieee80211_get_he_iftype_cap() iftype
      iwlwifi: mvm: disable RX-diversity in powersave
      iwlwifi: add vendor specific capabilities for some RFs
      iwlwifi: add some missing kernel-doc in struct iwl_fw
      iwlwifi: api: remove unused RX status bits
      iwlwifi: remove MODULE_AUTHOR() statements
      iwlwifi: remove contact information
      iwlwifi: fix fw/img.c license statement
      iwlwifi: api: fix struct iwl_wowlan_status_v7 kernel-doc
      iwlwifi: mvm: correct sta-state logic for TDLS
      iwlwifi: fw dump: add infrastructure for dump scrubbing
      iwlwifi: parse debug exclude data from firmware file
      iwlwifi: mvm: scrub key material in firmware dumps
      iwlwifi: remove redundant iwl_finish_nic_init() argument
      iwlwifi: mvm: remove session protection after auth/assoc
      iwlwifi: allow rate-limited error messages
      iwlwifi: mvm: reduce WARN_ON() in TX status path
      iwlwifi: pcie: try to grab NIC access early
      iwlwifi: mvm: set BT-coex high priority for 802.1X/4-way-HS
      iwlwifi: pnvm: print out the version properly
      iwlwifi: pcie: fix killer name matching for AX200
      iwlwifi: pcie: remove duplicate entry
      iwlwifi: pcie: refactor dev_info lookup
      iwlwifi: pcie: remove two duplicate PNJ device entries
      iwlwifi: pcie: simplify iwl_pci_find_dev_info()
      iwlwifi: dump host monitor data when NIC doesn't init
      iwlwifi: fw: uefi: add missing include guards
      iwlwifi: mvm: d3: use internal data representation
      iwlwifi: mvm: remove session protection on disassoc
      iwlwifi: mvm: extend session protection on association

Kalle Valo (4):
      Merge tag 'iwlwifi-next-for-kalle-2021-10-22' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge tag 'mt76-for-kvalo-2021-10-23' of https://github.com/nbd168/wireless
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2021-10-28' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next

Kevin Lo (2):
      rtw89: remove duplicate register definitions
      rtw89: fix return value in hfc_pub_cfg_chk

Loic Poulain (9):
      wcn36xx: Fix (QoS) null data frame bitrate/modulation
      wcn36xx: Fix tx_status mechanism
      wcn36xx: Correct band/freq reporting on RX
      wcn36xx: Enable hardware scan offload for 5Ghz band
      wcn36xx: Add chained transfer support for AMSDU
      wcn36xx: Fix HT40 capability for 2Ghz band
      wcn36xx: Fix discarded frames due to wrong sequence number
      wcn36xx: Fix packet drop on resume
      wcn36xx: Channel list update before hardware scan

Lorenzo Bianconi (2):
      mt76: mt7915: fix endiannes warning mt7915_mcu_beacon_check_caps
      mt76: mt7921: disable 4addr capability

Luca Coelho (7):
      iwlwifi: mvm: Support new rate_n_flags for REPLY_RX_MPDU_CMD and RX_NO_DATA_NOTIF
      iwlwifi: mvm: remove csi from iwl_mvm_pass_packet_to_mac80211()
      iwlwifi: mvm: read 6E enablement flags from DSM and pass to FW
      iwlwifi: mvm: don't get address of mvm->fwrt just to dereference as a pointer
      iwlwifi: rename GEO_TX_POWER_LIMIT to PER_CHAIN_LIMIT_OFFSET_CMD
      iwlwifi: mvm: fix WGDS table print in iwl_mvm_chub_update_mcc()
      iwlwifi: bump FW API to 67 for AX devices

Lv Ruyi (1):
      rtw89: fix error function parameter

Matti Gottlieb (3):
      iwlwifi: Add support for getting rf id with blank otp
      iwlwifi: Add support for more BZ HWs
      iwlwifi: Start scratch debug register for Bz family

Mike Golant (1):
      iwlwifi: pcie: update sw error interrupt for BZ family

Miri Korenblit (11):
      iwlwifi: mvm: Remove antenna c references
      iwlwifi: mvm: update definitions due to new rate & flags
      iwlwifi: mvm: add definitions for new rate & flags
      iwlwifi: mvm: convert old rate & flags to the new format.
      iwlwifi: mvm: Support version 3 of tlc_update_notif.
      iwlwifi: mvm: Support new version of ranging response notification
      iwlwifi: mvm: Add support for new rate_n_flags in tx_cmd.
      iwlwifi: mvm: Support new version of BEACON_TEMPLATE_CMD.
      iwlwifi: mvm: Support new TX_RSP and COMPRESSED_BA_RES versions
      iwlwifi: mvm: Add RTS and CTS flags to iwl_tx_cmd_flags.
      iwlwifi: mvm: Read acpi dsm to get channel activation bitmap

Mordechay Goodstein (1):
      iwlwifi: mvm: add lmac/umac PC info in case of error

Mukesh Sisodiya (2):
      iwlwifi: yoyo: fw debug config from context info and preset
      iwlwifi: yoyo: support for ROM usniffer

Nathan Errera (1):
      iwlwifi: rename CHANNEL_SWITCH_NOA_NOTIF to CHANNEL_SWITCH_START_NOTIF

Ping-Ke Shih (1):
      rtw89: Fix variable dereferenced before check 'sta'

Roee Goldfiner (2):
      iwlwifi: BZ Family BUS_MASTER_DISABLE_REQ code duplication
      iwlwifi: BZ Family SW reset support

Rotem Saado (2):
      iwlwifi: dbg: treat dbgc allocation failure when tlv is missing
      iwlwifi: dbg: treat non active regions as unsupported regions

Ryder Lee (4):
      mt76: mt7615: apply cached RF data for DBDC
      mt76: mt7915: remove mt7915_mcu_add_he()
      mt76: mt7915: rework .set_bitrate_mask() to support more options
      mt76: mt7915: rework debugfs fixed-rate knob

Sara Sharon (1):
      iwlwifi: mvm: set inactivity timeouts also for PS-poll

Shayne Chen (2):
      mt76: mt7915: add WA firmware log support
      mt76: mt7915: add debugfs knobs for MCU utilization

Wang Hai (2):
      libertas_tf: Fix possible memory leak in probe and disconnect
      libertas: Fix possible memory leak in probe and disconnect

Yaara Baruch (3):
      iwlwifi: add new killer devices to the driver
      iwlwifi: add new device id 7F70
      iwlwifi: add new pci SoF with JF

Ye Guojin (1):
      libertas: replace snprintf in show functions with sysfs_emit

 drivers/net/wireless/ath/ath10k/core.c             |  11 +-
 drivers/net/wireless/ath/ath10k/coredump.c         |  11 +-
 drivers/net/wireless/ath/ath10k/coredump.h         |   7 +
 drivers/net/wireless/ath/ath10k/mac.c              |  10 +-
 drivers/net/wireless/ath/ath10k/usb.c              |   7 +-
 drivers/net/wireless/ath/ath11k/core.c             |   5 +
 drivers/net/wireless/ath/ath11k/dp.c               |   4 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  29 +-
 drivers/net/wireless/ath/ath11k/hal_rx.c           |   6 +-
 drivers/net/wireless/ath/ath11k/hw.c               |  11 +-
 drivers/net/wireless/ath/ath11k/hw.h               |   9 +
 drivers/net/wireless/ath/ath6kl/usb.c              |   7 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |  49 +--
 drivers/net/wireless/ath/wcn36xx/hal.h             |  32 ++
 drivers/net/wireless/ath/wcn36xx/main.c            |  44 +--
 drivers/net/wireless/ath/wcn36xx/pmc.c             |  13 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |  90 +++++-
 drivers/net/wireless/ath/wcn36xx/smd.h             |   1 +
 drivers/net/wireless/ath/wcn36xx/txrx.c            | 147 +++++++--
 drivers/net/wireless/ath/wcn36xx/txrx.h            |   3 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |   7 +-
 drivers/net/wireless/intel/iwlwifi/Makefile        |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/1000.c      |   5 -
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c      |   5 -
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  33 +-
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c      |   5 -
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c      |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h       |  11 +-
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c   |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h       |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c   |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/led.c       |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/led.h       |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c       |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |   6 -
 drivers/net/wireless/intel/iwlwifi/dvm/power.c     |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/power.h     |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/rs.h        |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c        |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c      |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c      |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c       |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/tt.c        |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/tt.h        |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c        |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/ucode.c     |   5 -
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       | 150 ++++++---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |  43 ++-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |  45 +--
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |  57 ++++
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |  35 ++
 .../net/wireless/intel/iwlwifi/fw/api/location.h   |  10 +-
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    |  10 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |   3 +
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |  23 ++
 drivers/net/wireless/intel/iwlwifi/fw/api/phy.h    |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |  55 +++-
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     | 234 +++++++++++---
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |  31 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h    |   2 +
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |  40 ++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  46 ++-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c       |   9 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |   4 -
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |  12 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.c        |  58 +---
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |  12 +
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/paging.c     |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/rs.c         | 252 +++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |   7 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h       |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   8 +-
 .../wireless/intel/iwlwifi/iwl-context-info-gen3.h |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   8 +
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   | 228 ++++++++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h   |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-debug.c     |  24 +-
 drivers/net/wireless/intel/iwlwifi/iwl-debug.h     |  26 +-
 .../net/wireless/intel/iwlwifi/iwl-devtrace-data.h |   5 -
 .../net/wireless/intel/iwlwifi/iwl-devtrace-io.h   |   5 -
 .../wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h  |   5 -
 .../net/wireless/intel/iwlwifi/iwl-devtrace-msg.h  |   5 -
 .../wireless/intel/iwlwifi/iwl-devtrace-ucode.h    |   5 -
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c  |   5 -
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h  |   5 -
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  44 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h       |   3 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-read.c   |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |  50 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-io.h        |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  17 +
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |  36 +++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  30 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        | 357 ++++++++++++---------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  19 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |  15 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 106 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  44 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 269 ++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  17 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       | 194 ++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |  28 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |  16 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        | 182 ++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |  17 -
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  39 +--
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      | 119 ++++---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 117 +++++--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  54 ++--
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |   4 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 300 ++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   9 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |  38 +--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  90 ++++--
 drivers/net/wireless/marvell/libertas/if_usb.c     |   2 +
 drivers/net/wireless/marvell/libertas/mesh.c       |  18 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |   2 +
 drivers/net/wireless/marvell/mwifiex/usb.c         |  16 +
 drivers/net/wireless/mediatek/mt76/eeprom.c        |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  22 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   2 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   1 +
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    | 167 ++++++++--
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   8 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |  34 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    | 204 +++++++++---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |  23 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   3 +
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |  17 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |  17 +
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   3 +-
 drivers/net/wireless/mediatek/mt76/util.h          |  10 +-
 .../net/wireless/realtek/rtl818x/rtl8187/rtl8225.c |  14 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   6 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |   2 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |   5 -
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   2 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |   2 +-
 drivers/net/wireless/ti/wlcore/spi.c               |   9 +-
 146 files changed, 3609 insertions(+), 1398 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/rs.c
