Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD3F2814AD
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388018AbgJBOIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:08:31 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:49129 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387908AbgJBOIb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:08:31 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601647709; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=NZRbr42kzhPtYFYDN7Dy2G6XWn31adY4t7u2EsUyHgg=; b=gjD/68zqdE5zZ4pSQqpTtVb1iCiyflPr+mcotWkoYQzGxp4t/MMVDO/gFU4DuCdqb1HyT9jh
 hqpVkwYQfbrQMym3BPD2G6LsgZtOeqtyl/Z3IEJBDLHN2VP9AwRQbS+47VLO5q5mUl92P/rU
 w7Ldok4iJS0O+GRCoYQPxARwa0E=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f77345b57b88ccb56930df9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 02 Oct 2020 14:08:27
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F37A8C433CB; Fri,  2 Oct 2020 14:08:26 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 364E3C433CA;
        Fri,  2 Oct 2020 14:08:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 364E3C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2020-10-02
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20201002140826.F37A8C433CB@smtp.codeaurora.org>
Date:   Fri,  2 Oct 2020 14:08:26 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 0675c285ea65540cccae64c87dfc7a00c7ede03a:

  net: vlan: Fixed signedness in vlan_group_prealloc_vid() (2020-09-28 00:51:39 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2020-10-02

for you to fetch changes up to 70442ee62d70cac010c6a181c27a90549f58b69a:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2020-10-01 22:40:44 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.10

Third set of patches for v5.10. Lots of iwlwifi patches this time, but
also few patches ath11k and of course smaller changes to other
drivers.

Major changes:

rtw88

* properly recover from firmware crashes on 8822c

* dump firmware crash log

iwlwifi

* protected Target Wake Time (TWT) implementation

* support disabling 5.8GHz channels via ACPI

* support VHT extended NSS capability

* enable Target Wake Time (TWT) by default

ath11k

* improvements to QCA6390 PCI support to make it more usable

----------------------------------------------------------------
Alex Dewar (2):
      wl3501_cs: Remove unnecessary NULL check
      ath11k: Correctly check errors for calls to debugfs_create_dir()

Andrei Otcheretianski (2):
      iwlwifi: mvm: Don't install CMAC/GMAC key in AP mode
      iwlwifi: use correct group for alive notification

Avraham Stern (7):
      iwlwifi: mvm: add an option to add PASN station
      iwlwifi: mvm: add support for range request command ver 11
      iwlwifi: mvm: add support for responder dynamic config command version 3
      iwlwifi: mvm: location: set the HLTK when PASN station is added
      iwlwifi: mvm: responder: allow to set only the HLTK for an associated station
      iwlwifi: mvm: initiator: add option for adding a PASN responder
      iwlwifi: mvm: ignore the scan duration parameter

Ayala Beker (1):
      iwlwifi: mvm: clear all scan UIDs

Ben Greear (1):
      ath11k: support loading ELF board files

Carl Huang (12):
      ath11k: fix AP mode for QCA6390
      ath11k: add packet log support for QCA6390
      ath11k: pci: fix rmmod crash
      ath11k: fix warning caused by lockdep_assert_held
      ath11k: debugfs: fix crash during rmmod
      ath11k: read and write registers below unwindowed address
      ath11k: enable shadow register configuration and access
      ath11k: set WMI pipe credit to 1 for QCA6390
      ath11k: start a timer to update TCL HP
      ath11k: start a timer to update REO cmd ring
      ath11k: start a timer to update HP for CE pipe 4
      ath11k: enable idle power save mode

Colin Ian King (1):
      qtnfmac: fix resource leaks on unsupported iftype error return path

Dan Halperin (2):
      iwlwifi: mvm: add support for new version of WOWLAN_TKIP_SETTING_API_S
      iwlwifi: mvm: add support for new WOWLAN_TSC_RSC_PARAM version

Emmanuel Grumbach (1):
      iwlwifi: mvm: split a print to avoid a WARNING in ROC

Gil Adam (4):
      iwlwifi: acpi: evaluate dsm to disable 5.8GHz channels
      iwlwifi: acpi: support ppag table command v2
      iwlwifi: regulatory: regulatory capabilities api change
      iwlwifi: thermal: support new temperature measurement API

Golan Ben Ami (1):
      iwlwifi: enable twt by default

Govind Singh (2):
      ath11k: Move non-fatal warn logs to dbg level
      ath11k: Use GFP_ATOMIC instead of GFP_KERNEL in idr_alloc

Ihab Zhaika (2):
      iwlwifi: add new cards for AX201 family
      iwlwifi: add new cards for MA family

Ilan Peer (1):
      iwlwifi: mvm: Add FTM initiator RTT smoothing logic

Johannes Berg (6):
      iwlwifi: mvm: rs-fw: handle VHT extended NSS capability
      iwlwifi: mvm: use CHECKSUM_COMPLETE
      iwlwifi: mvm: d3: support GCMP ciphers
      iwlwifi: align RX status flags with firmware
      iwlwifi: mvm: d3: parse wowlan status version 11
      iwlwifi: api: fix u32 -> __le32

Julia Lawall (1):
      bcma: use semicolons rather than commas to separate statements

Kai-Heng Feng (1):
      rtw88: pci: Power cycle device during shutdown

Kalle Valo (7):
      Merge tag 'iwlwifi-next-for-kalle-2020-09-30-2' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      ath11k: mac: fix parenthesis alignment
      ath11k: add interface_modes to hw_params
      ath11k: pci: check TCSR_SOC_HW_VERSION
      ath11k: disable monitor mode on QCA6390
      ath11k: remove unnecessary casts to u32
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Li Heng (1):
      ath9k: Remove set but not used variable

Loic Poulain (1):
      wcn36xx: Advertise beacon filtering support in bmps

Luca Coelho (12):
      iwlwifi: dbg: remove IWL_FW_INI_TIME_POINT_WDG_TIMEOUT
      iwlwifi: don't export acpi functions unnecessarily
      iwlwifi: remove iwl_validate_sar_geo_profile() export
      iwlwifi: acpi: remove dummy definition of iwl_sar_set_profile()
      iwlwifi: add a common struct for all iwl_tx_power_cmd versions
      iwlwifi: acpi: prepare SAR profile selection code for multiple sizes
      iwlwifi: support REDUCE_TX_POWER_CMD version 6
      iwlwifi: acpi: rename geo structs to contain versioning
      iwlwifi: support version 3 of GEO_TX_POWER_LIMIT
      iwlwifi: mvm: remove redundant log in iwl_mvm_tvqm_enable_txq()
      iwlwifi: support version 5 of the alive notification
      iwlwifi: bump FW API to 57 for AX devices

Mordechay Goodstein (22):
      iwlwifi: sta: defer ADDBA transmit in case reclaimed SN != next SN
      iwlwifi: msix: limit max RX queues for 9000 family
      iwlwifi: wowlan: adapt to wowlan status API version 10
      iwlwifi: fw: move assert descriptor parser to common code
      iwlwifi: iwl-trans: move all txcmd init to trans alloc
      iwlwifi: move bc_pool to a common trans header
      iwlwifi: iwl-trans: move tfd to trans layer
      iwlwifi: move bc_table_dword to a common trans header
      iwlwifi: dbg: add dumping special device memory
      iwl-trans: move dev_cmd_offs, page_offs to a common trans header
      iwlwifi: mvm: remove redundant support_umac_log field
      iwlwifi: rs: set RTS protection for all non legacy rates
      iwlwifi: acpi: in non acpi compilations remove iwl_sar_geo_init
      iwlwifi: fw: add default value for iwl_fw_lookup_cmd_ver
      iwlwifi: remove wide_cmd_header field
      iwlwifi: move all bus-independent TX functions to common code
      iwlwifi: dbg: remove no filter condition
      iwlwifi: dbg: run init_cfg function once per driver load
      iwlwifi: phy-ctxt: add new API VER 3 for phy context cmd
      iwlwifi: pcie: make iwl_pcie_txq_update_byte_cnt_tbl bus independent
      iwlwifi: dbg: add debug host notification (DHN) time point
      iwlwifi: yoyo: add support for internal buffer allocation in D3

Naftali Goldstein (1):
      iwlwifi: mvm: process ba-notifications also when sta rcu is invalid

Nathan Errera (2):
      iwlwifi: mvm: support new KEK KCK api
      iwlwifi: mvm: support more GTK rekeying algorithms

Roee Goldfiner (1):
      iwlwifi: add new card for MA family

Sara Sharon (1):
      iwlwifi: mvm: add d3 prints

Shaul Triebitz (3):
      iwlwifi: mvm: add PROTECTED_TWT firmware API
      iwlwifi: mvm: set PROTECTED_TWT in MAC data policy
      iwlwifi: mvm: set PROTECTED_TWT feature if supported by firmware

Tzu-En Huang (5):
      rtw88: increse the size of rx buffer size
      rtw88: handle and recover when firmware crash
      rtw88: add dump firmware fifo support
      rtw88: add dump fw crash log
      rtw88: show current regulatory in tx power table

Wang Qing (1):
      wl1251/wl12xx: fix a typo in comments

Wen Gong (3):
      ath11k: change to disable softirqs for ath11k_regd_update to solve deadlock
      ath11k: Use GFP_ATOMIC instead of GFP_KERNEL in ath11k_dp_htt_get_ppdu_desc
      ath11k: mac: remove unused conf_mutex to solve a deadlock

Wright Feng (2):
      brcmfmac: Fix warning when hitting FW crash with flow control feature
      brcmfmac: Fix warning message after dongle setup failed

 drivers/bcma/driver_pci_host.c                     |    4 +-
 drivers/net/wireless/ath/ath11k/ce.c               |   80 +
 drivers/net/wireless/ath/ath11k/ce.h               |    3 +
 drivers/net/wireless/ath/ath11k/core.c             |   21 +
 drivers/net/wireless/ath/ath11k/core.h             |    3 +
 drivers/net/wireless/ath/ath11k/debugfs.c          |   33 +-
 drivers/net/wireless/ath/ath11k/dp.c               |  102 +-
 drivers/net/wireless/ath/ath11k/dp.h               |   27 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  136 +-
 drivers/net/wireless/ath/ath11k/dp_rx.h            |    6 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |   83 +-
 drivers/net/wireless/ath/ath11k/hal.c              |  137 +-
 drivers/net/wireless/ath/ath11k/hal.h              |   19 +-
 drivers/net/wireless/ath/ath11k/hal_rx.c           |    6 +-
 drivers/net/wireless/ath/ath11k/hal_rx.h           |    2 +-
 drivers/net/wireless/ath/ath11k/htc.c              |    6 +
 drivers/net/wireless/ath/ath11k/hw.h               |    5 +
 drivers/net/wireless/ath/ath11k/mac.c              |  159 +-
 drivers/net/wireless/ath/ath11k/pci.c              |   93 +-
 drivers/net/wireless/ath/ath11k/pci.h              |    7 +
 drivers/net/wireless/ath/ath11k/qmi.c              |   25 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |    2 +-
 drivers/net/wireless/ath/ath11k/reg.c              |    6 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |    2 +-
 .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h   |   21 -
 drivers/net/wireless/ath/wcn36xx/pmc.c             |    2 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   11 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |   10 +-
 drivers/net/wireless/intel/iwlwifi/Makefile        |    1 +
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   68 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |   72 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |   58 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h  |   25 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   10 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |   82 +-
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |   32 +-
 .../net/wireless/intel/iwlwifi/fw/api/location.h   |  231 ++-
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |   16 +-
 .../net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h   |   32 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/phy.h    |   13 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |  133 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |   11 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |   29 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |    7 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   56 +
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |   14 +
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |    3 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.c        |   55 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |    8 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |    3 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |    3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   13 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   26 +-
 drivers/net/wireless/intel/iwlwifi/iwl-debug.h     |    6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   98 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |    2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |   78 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   34 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |    8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  273 +++-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |  363 ++++-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |  205 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  356 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   64 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   51 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   18 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |  126 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |    6 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   85 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   70 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   53 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |    3 +
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |   78 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   77 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   46 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |    2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   34 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  158 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |    2 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |    4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  132 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 1089 +-------------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  535 +------
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      | 1529 ++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/queue/tx.h      |  230 +++
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |    2 +
 drivers/net/wireless/realtek/rtw88/debug.c         |   26 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |   86 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |   18 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   81 +-
 drivers/net/wireless/realtek/rtw88/main.c          |  193 +++
 drivers/net/wireless/realtek/rtw88/main.h          |   32 +
 drivers/net/wireless/realtek/rtw88/pci.c           |    5 +
 drivers/net/wireless/realtek/rtw88/pci.h           |    4 +-
 drivers/net/wireless/realtek/rtw88/reg.h           |    5 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |    3 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |    3 +
 drivers/net/wireless/realtek/rtw88/util.h          |    2 +
 drivers/net/wireless/ti/wl1251/reg.h               |    2 +-
 drivers/net/wireless/ti/wl12xx/reg.h               |    2 +-
 drivers/net/wireless/wl3501_cs.c                   |    4 +-
 103 files changed, 5533 insertions(+), 2798 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/queue/tx.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/queue/tx.h
