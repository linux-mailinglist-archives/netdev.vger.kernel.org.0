Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D573FAB3C
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 13:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbhH2L6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 07:58:04 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:38874 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235229AbhH2L6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 07:58:03 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630238231; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=SfWS72/k+pjQBP2Xi7iozWednfnZ6+QrLFbGNTFG8fg=; b=dLQ9/3Hw2zjuTDe2ZyVJeZFkkhWFJtdg6Fbp14Ro+7s8RZ3D5IMrItFyu/PRarN0EXlcWzGc
 AKHOajm5PtHoPo+qmCw+Vrkbx0mvQoR564UAlNHOw+LQDl9Q4AcPFCm9sMfhZnQz9JMm6oOA
 8omVqzYlSh0QIjmoSxd8F//mBMA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 612b7605f61b2f864be24efa (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 29 Aug 2021 11:56:53
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C5027C43460; Sun, 29 Aug 2021 11:56:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URI_DEOBFU_INSTR autolearn=no
        autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 035B1C4338F;
        Sun, 29 Aug 2021 11:56:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 035B1C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2021-08-29
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210829115652.C5027C43460@smtp.codeaurora.org>
Date:   Sun, 29 Aug 2021 11:56:52 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit e3f30ab28ac866256169153157f466d90f44f122:

  Merge branch 'pktgen-samples-next' (2021-08-25 13:44:30 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2021-08-29

for you to fetch changes up to 8d4be124062bddbb2bcb887702a0601b790b9a83:

  ssb: fix boolreturn.cocci warning (2021-08-29 14:47:42 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.15

Second, and most likely last, set of patches for v5.15. Lots of
iwlwifi patches this time, but smaller changes to other drivers as
well. Nothing special standing out.

Major changes:

rtw88

* add quirk to disable pci caps on HP Pavilion 14-ce0xxx

brcmfmac

* Add WPA3 Personal with FT to supported cipher suites

wcn36xx

* allow firmware name to be overridden by DT

iwlwifi

* support scanning hidden 6GHz networks

* support for a new hardware family (Bz)

* support for new firmware API versions

mwifiex

* add reset_d3cold quirk for Surface gen4+ devices

----------------------------------------------------------------
Abhishek Naik (1):
      iwlwifi: skip first element in the WTAS ACPI table

Ahmad Fatoum (1):
      brcmfmac: pcie: fix oops on failure to resume and reprobe

Avraham Stern (4):
      iwlwifi: mvm: silently drop encrypted frames for unknown station
      iwlwifi: mvm: don't schedule the roc_done_wk if it is already running
      iwlwifi: mvm: add support for range request command version 13
      iwlwifi: mvm: add support for responder config command version 9

Bjorn Andersson (1):
      wcn36xx: Allow firmware name to be overridden by DT

Christophe JAILLET (1):
      intel: switch from 'pci_' to 'dma_' API

Colin Ian King (1):
      rsi: make array fsm_state static const, makes object smaller

Dan Carpenter (1):
      ath6kl: wmi: fix an error code in ath6kl_wmi_sync_point()

David Mosberger-Tang (1):
      wilc1000: Convert module-global "isinit" to device-specific variable

Dror Moshe (1):
      iwlwifi: move get pnvm file name to a separate function

Gregory Greenman (2):
      iwlwifi: mvm: support version 11 of wowlan statuses notification
      iwlwifi: mvm: introduce iwl_stored_beacon_notif_v3

Ilan Peer (5):
      iwlwifi: mvm: Do not use full SSIDs in 6GHz scan
      iwlwifi: mvm: Add support for hidden network scan on 6GHz band
      iwlwifi: mvm: Fix umac scan request probe parameters
      iwlwifi: mvm: Refactor setting of SSIDs for 6GHz scan
      iwlwifi: mvm: Fix scan channel flags settings

Jing Yangyang (1):
      ssb: fix boolreturn.cocci warning

Johannes Berg (33):
      iwlwifi: nvm: enable IEEE80211_HE_PHY_CAP10_HE_MU_M1RU_MAX_LTF
      iwlwifi: mvm: avoid FW restart while shutting down
      iwlwifi: pcie: optimise struct iwl_rx_mem_buffer layout
      iwlwifi: pcie: free RBs during configure
      iwlwifi: prepare for synchronous error dumps
      iwlwifi: pcie: dump error on FW reset handshake failures
      iwlwifi: mvm: set replay counter on key install
      iwlwifi: mvm: restrict FW SMPS request
      iwlwifi: mvm: avoid static queue number aliasing
      iwlwifi: mvm: clean up number of HW queues
      iwlwifi: mvm: treat MMPDUs in iwl_mvm_mac_tx() as bcast
      iwlwifi: split off Bz devices into their own family
      iwlwifi: give Bz devices their own name
      iwlwifi: read MAC address from correct place on Bz
      iwlwifi: pcie: implement Bz device startup
      iwlwifi: implement Bz NMI behaviour
      iwlwifi: pcie: implement Bz reset flow
      iwlwifi: mvm: support new station key API
      iwlwifi: mvm: simplify __iwl_mvm_set_sta_key()
      iwlwifi: mvm: d3: separate TKIP data from key iteration
      iwlwifi: mvm: d3: remove fixed cmd_flags argument
      iwlwifi: mvm: d3: refactor TSC/RSC configuration
      iwlwifi: mvm: d3: add separate key iteration for GTK type
      iwlwifi: mvm: d3: make key reprogramming iteration optional
      iwlwifi: mvm: d3: implement RSC command version 5
      iwlwifi: mvm: fix access to BSS elements
      iwlwifi: fw: correctly limit to monitor dump
      iwlwifi: pcie: avoid dma unmap/remap in crash dump
      iwlwifi: fix __percpu annotation
      iwlwifi: api: remove datamember from struct
      iwlwifi: fw: fix debug dump data declarations
      iwlwifi: allow debug init in RF-kill
      iwlwifi: mvm: don't use FW key ID in beacon protection

Jonas Dreßler (1):
      mwifiex: pcie: add DMI-based quirk implementation for Surface devices

Joseph Gates (1):
      wcn36xx: Ensure finish scan is not requested before start scan

Kalle Valo (2):
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge commit 'e257d969f36503b8eb1240f32653a1afb3109f86' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next

Linus Walleij (1):
      ssb: Drop legacy header include

Loic Poulain (1):
      wcn36xx: Fix missing frame timestamp for beacon/probe-resp

Luca Coelho (15):
      iwlwifi: print PNVM complete notification status in hexadecimal
      iwlwifi: pcie: remove spaces from queue names
      iwlwifi: mvm: remove check for vif in iwl_mvm_vif_from_mac80211()
      iwlwifi: rename ACPI_SAR_NUM_CHAIN_LIMITS to ACPI_SAR_NUM_CHAINS
      iwlwifi: convert flat SAR profile table to a struct version
      iwlwifi: remove ACPI_SAR_NUM_TABLES definition
      iwlwifi: pass number of chains and sub-bands to iwl_sar_set_profile()
      iwlwifi: acpi: support reading and storing WRDS revision 1 and 2
      iwlwifi: support reading and storing EWRD revisions 1 and 2
      iwlwifi: remove unused ACPI_WGDS_TABLE_SIZE definition
      iwlwifi: convert flat GEO profile table to a struct version
      iwlwifi: acpi: support reading and storing WGDS revision 2
      iwlwifi: bump FW API to 65 for AX devices
      iwlwifi: acpi: fill in WGDS table with defaults
      iwlwifi: acpi: fill in SAR tables with defaults

Miaoqing Pan (1):
      ath9k: fix sleeping in atomic context

Miri Korenblit (2):
      iwlwifi: mvm: Read the PPAG and SAR tables at INIT stage
      iwlwifi: mvm: load regdomain at INIT stage

Mordechay Goodstein (3):
      iwlwifi: iwl-nvm-parse: set STBC flags for HE phy capabilities
      iwlwifi: iwl-dbg-tlv: add info about loading external dbg bin
      iwlwifi: mvm: remove trigger EAPOL time event

Mukesh Sisodiya (2):
      iwlwifi: yoyo: cleanup internal buffer allocation in D3
      iwlwifi: yoyo: support for new DBGI_SRAM region

Nathan Chancellor (1):
      rtlwifi: rtl8192de: Fix initialization of place in _rtl92c_phy_get_rightchnlplace()

Paweł Drewniak (1):
      brcmfmac: Add WPA3 Personal with FT to supported cipher suites

Shaul Triebitz (4):
      iwlwifi: mvm: set BROADCAST_TWT_SUPPORTED in MAC policy
      iwlwifi: mvm: trigger WRT when no beacon heard
      iwlwifi: add 'Rx control frame to MBSSID' HE capability
      iwlwifi: mvm: support broadcast TWT alone

Tom Rix (1):
      iwlwifi: remove trailing semicolon in macro definition

Tsuchiya Yuto (1):
      mwifiex: pcie: add reset_d3cold quirk for Surface gen4+ devices

Ugo Rémery (1):
      rtw88: add quirk to disable pci caps on HP Pavilion 14-ce0xxx

Wei Yongjun (1):
      iwlwifi: mvm: fix old-style static const declaration

Zekun Shen (1):
      ath9k: fix OOB read ar9300_eeprom_restore_internal

Zenghui Yu (2):
      bcma: Fix memory leak for internally-handled cores
      bcma: Drop the unused parameter of bcma_scan_read32()

Zhang Qilong (1):
      iwlwifi: mvm: fix a memory leak in iwl_mvm_mac_ctxt_beacon_changed

Zheng Yongjun (1):
      iwlwifi: use DEFINE_MUTEX() for mutex lock

 drivers/bcma/main.c                                |   6 +-
 drivers/bcma/scan.c                                |   7 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |   4 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   3 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  12 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |  12 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |   4 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c            |   4 +
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |   2 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   8 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   2 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |  52 +-
 drivers/net/wireless/intel/iwlegacy/3945.c         |  10 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |  78 ++-
 drivers/net/wireless/intel/iwlegacy/common.c       |  19 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  76 ++-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       | 304 ++++++++---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |  66 ++-
 drivers/net/wireless/intel/iwlwifi/fw/api/coex.h   |   2 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   3 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |  22 +-
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |   8 +-
 .../net/wireless/intel/iwlwifi/fw/api/location.h   | 189 ++++++-
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |   4 +-
 .../net/wireless/intel/iwlwifi/fw/api/offload.h    |  31 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h    |   8 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 144 +++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |   7 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |  22 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |  15 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.h       |  20 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |  22 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |  34 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h   |  24 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |  26 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  40 +-
 drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h   |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   7 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        | 580 +++++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  11 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |  85 ++-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |  27 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 108 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  44 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  35 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  74 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  45 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  93 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 120 +++--
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |  41 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  24 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  17 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |  53 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  59 ++-
 drivers/net/wireless/marvell/mwifiex/Makefile      |   1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c        |  11 +
 drivers/net/wireless/marvell/mwifiex/pcie.h        |   1 +
 drivers/net/wireless/marvell/mwifiex/pcie_quirks.c | 161 ++++++
 drivers/net/wireless/marvell/mwifiex/pcie_quirks.h |  23 +
 drivers/net/wireless/microchip/wilc1000/spi.c      |  15 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |   4 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |   9 +
 drivers/net/wireless/rsi/rsi_91x_debugfs.c         |   2 +-
 include/linux/ssb/ssb.h                            |   2 +-
 include/linux/ssb/ssb_driver_extif.h               |   2 +-
 78 files changed, 2192 insertions(+), 815 deletions(-)
 create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
 create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
