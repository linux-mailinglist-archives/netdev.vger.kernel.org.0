Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1FBFE3CD
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 18:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfKORS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 12:18:58 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33354 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbfKORS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 12:18:57 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0F3D060C16; Fri, 15 Nov 2019 17:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573838336;
        bh=5yRi1Lfa4JK4cFXmB5tAr/2ClxagcLuMBifYCznxQEU=;
        h=From:Subject:To:Cc:Date:From;
        b=cDJEwgQx2d7O324pZZE52M3B/t9Tt7VwMoNsLnPQbj9oqtwzQ7d72AYwrnj1gOMyG
         Npk0VAhBYrtx5MoQguDFTiqdCt80RjMk/F491gfJSJigpuq7JLGn2jhnCNtwzXeFDZ
         K2Zu+gdWpPRM406oCbmK5YCM49sKMSg3KhOPFuT4=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 85CB560B18;
        Fri, 15 Nov 2019 17:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573838335;
        bh=5yRi1Lfa4JK4cFXmB5tAr/2ClxagcLuMBifYCznxQEU=;
        h=From:Subject:To:Cc:From;
        b=L7Wda5kiOAMF4cjnjLOmMy75mXksHmGdblWdrpvrBZ0PuWJmyPZVBwyhhgUY8gFNr
         ytL7GMi0EhZF0rJeqFTHu4561YhnwhMmG4sClyHxtZ6NUAbWbiODqdvLrPGBmFt5Ds
         s5Zv9S/p2UO3jNAx/kVLLumLjlO/skDXywfZt33Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 85CB560B18
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2019-11-15
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20191115171856.0F3D060C16@smtp.codeaurora.org>
Date:   Fri, 15 Nov 2019 17:18:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit a3ead21d6eec4d18b48466c7b978566bc9cab676:

  Merge tag 'wireless-drivers-next-2019-11-05' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next (2019-11-05 18:36:35 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2019-11-15

for you to fetch changes up to 4f5969c36a4572dbaf8737dd9f486382d4e44b4a:

  rtw88: remove duplicated include from ps.c (2019-11-15 14:24:38 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for v5.5

Second set of patches for v5.5. Nothing special this time, smaller
features to various drivers and of course fixes all over.

Major changes:

iwlwifi

* update scan FW API

* bump the supported FW API version

* add debug dump collection on assert in WoWLAN

* enable adaptive dwell on P2P interfaces

ath10k

* request for PM_QOS_CPU_DMA_LATENCY to improve firmware initialisation time

qtnfmac

* add support for getting/setting transmit power

* handle MIC failure event from firmware

rtl8xxxu

* add support for Edimax EW-7611ULB

wil6210

* add SPDX license identifiers

----------------------------------------------------------------
Abhishek Ambure (1):
      ath10k: enable transmit data ack RSSI for QCA9884

Bjorn Andersson (3):
      ath10k: Correct error handling of dma_map_single()
      ath10k: Revert "ath10k: add cleanup in ath10k_sta_state()"
      ath10k: qmi: Sleep for a while before assigning MSA memory

Brian Norris (1):
      rtw88: signal completion even on firmware-request failure

Colin Ian King (2):
      ath10k: fix null dereference on pointer crash_data
      iwlwifi: remove redundant assignment to variable bufsz

Daniel Golle (1):
      rt2800: remove errornous duplicate condition

Eduardo Abinader (3):
      wcn36xx: remove unecessary return
      wcn36xx: fix typo
      brcmsmac: remove unnecessary return

Emmanuel Grumbach (2):
      iwlwifi: pcie: make iwl_pcie_gen2_update_byte_tbl static
      iwlwifi: mvm: sync the iwl_mvm_session_prot_notif layout

Haim Dreyfuss (1):
      iwlwifi: mvm: don't skip mgmt tid when flushing all tids

Hui Peng (1):
      ath10k: Fix a NULL-ptr-deref bug in ath10k_usb_alloc_urb_from_pipe

Ihab Zhaika (1):
      iwlwifi: refactor the SAR tables from mvm to acpi

Ikjoon Jang (1):
      ath10k: disable cpuidle during downloading firmware

Jes Sorensen (1):
      rtl8xxxu: Add support for Edimax EW-7611ULB

Johannes Berg (4):
      iwlwifi: FW API: reference enum in docs of modify_mask
      iwlwifi: remove IWL_DEVICE_22560/IWL_DEVICE_FAMILY_22560
      iwlwifi: 22000: fix some indentation
      iwlwifi: mvm: fix non-ACPI function

Kalle Valo (2):
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Larry Finger (3):
      rtlwifi: rtl8192de: Fix missing code to retrieve RX buffer address
      rtlwifi: rtl8192de: Fix missing callback that tests for hw release of buffer
      rtlwifi: rtl8192de: Fix missing enable interrupt flag

Lior David (1):
      wil6210: add SPDX license identifiers

Luca Coelho (3):
      iwlwifi: mvm: fix support for single antenna diversity
      iwlwifi: mvm: remove else-if in iwl_send_phy_cfg_cmd()
      iwlwifi: bump FW API to 51 for 22000 series

Miaoqing Pan (3):
      ath10k: fix array out-of-bounds access
      ath10k: fix memory leak for tpc_stats_final
      ath10k: fix get invalid tx rate for Mesh metric

Mikhail Karpenko (1):
      qtnfmac: add support for getting/setting transmit power

Mordechay Goodstein (3):
      iwlwifi: mvm: in VHT connection use only VHT capabilities
      iwlwifi: mvm: print rate_n_flags in a pretty format
      iwlwifi: mvm: start CTDP budget from 2400mA

Ping-Ke Shih (1):
      rtlwifi: fix memory leak in rtl92c_set_fw_rsvdpagepkt()

Saurav Girepunje (1):
      ath5k: eeprom: Remove unneeded variable

Sergey Matyukevich (6):
      qtnfmac: fix using skb after free
      qtnfmac: fix debugfs support for multiple cards
      qtnfmac: fix invalid channel information output
      qtnfmac: modify Rx descriptors queue setup
      qtnfmac: send EAPOL frames via control path
      qtnfmac: handle MIC failure event from firmware

Shahar S Matityahu (4):
      iwlwifi: dbg_ini: support dump collection upon assert during D3
      iwlwifi: scan: make new scan req versioning flow
      iwlwifi: scan: support scan req cmd ver 12
      iwlwifi: mvm: scan: enable adaptive dwell in p2p

Tomislav Požega (1):
      ath: rename regulatory rules

Tova Mussai (4):
      iwlwifi: nvm: update iwl_uhb_nvm_channels
      iwlwifi: scan: create function for scan scheduling params
      iwlwifi: scan: Create function to build scan cmd
      iwlwifi: scan: adapt the code to use api ver 11

Wang Xuerui (1):
      iwlwifi: mvm: fix unaligned read of rx_pkt_status

Yan-Hsuan Chuang (2):
      rtw88: raise LPS threshold to 50, for less power consumption
      rtw88: fix potential NULL pointer access for firmware

YueHaibing (4):
      ath10k: remove unneeded semicolon
      brcmsmac: remove set but not used variables
      rtlwifi: rtl8225se: remove some unused const variables
      rtw88: remove duplicated include from ps.c

Zheng Yongjun (1):
      rtl8xxxu: Remove set but not used variable 'rsr'

Zhi Chen (1):
      ath10k: fix potential issue of peer stats allocation

zhong jiang (2):
      ipw2x00: Remove redundant variable "rc"
      iwlegacy: Remove redundant variable "ret"

 drivers/net/wireless/ath/ath10k/core.c             |  12 +-
 drivers/net/wireless/ath/ath10k/debug.c            |   3 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   2 +-
 drivers/net/wireless/ath/ath10k/hw.c               |   1 +
 drivers/net/wireless/ath/ath10k/mac.c              |  11 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |   7 +
 drivers/net/wireless/ath/ath10k/snoc.c             |   2 +-
 drivers/net/wireless/ath/ath10k/txrx.c             |   2 +
 drivers/net/wireless/ath/ath10k/usb.c              |   8 +
 drivers/net/wireless/ath/ath10k/wmi.c              |  49 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |   4 +-
 drivers/net/wireless/ath/regd.c                    |  50 +-
 drivers/net/wireless/ath/wcn36xx/hal.h             |   2 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   2 -
 drivers/net/wireless/ath/wil6210/boot_loader.h     |  13 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |  13 +-
 drivers/net/wireless/ath/wil6210/debug.c           |  13 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |  13 +-
 drivers/net/wireless/ath/wil6210/ethtool.c         |  13 +-
 drivers/net/wireless/ath/wil6210/fw.c              |  13 +-
 drivers/net/wireless/ath/wil6210/fw.h              |  13 +-
 drivers/net/wireless/ath/wil6210/fw_inc.c          |  13 +-
 drivers/net/wireless/ath/wil6210/interrupt.c       |  13 +-
 drivers/net/wireless/ath/wil6210/main.c            |  13 +-
 drivers/net/wireless/ath/wil6210/netdev.c          |  13 +-
 drivers/net/wireless/ath/wil6210/p2p.c             |  13 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |  13 +-
 drivers/net/wireless/ath/wil6210/pm.c              |  13 +-
 drivers/net/wireless/ath/wil6210/pmc.c             |  13 +-
 drivers/net/wireless/ath/wil6210/pmc.h             |  17 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c      |  13 +-
 drivers/net/wireless/ath/wil6210/trace.c           |  13 +-
 drivers/net/wireless/ath/wil6210/trace.h           |  13 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |  13 +-
 drivers/net/wireless/ath/wil6210/txrx.h            |  13 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c       |  13 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.h       |  13 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |  13 +-
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c  |  13 +-
 drivers/net/wireless/ath/wil6210/wil_platform.c    |  15 +-
 drivers/net/wireless/ath/wil6210/wil_platform.h    |  13 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |  13 +-
 drivers/net/wireless/ath/wil6210/wmi.h             |  13 +-
 .../wireless/broadcom/brcm80211/brcmsmac/main.c    |  13 +-
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |   4 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |   3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  52 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       | 287 +++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |  84 ++++
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   | 208 ++++++++
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h    |  10 +-
 .../net/wireless/intel/iwlwifi/fw/api/time-event.h |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |  18 +
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |  11 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   1 -
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   2 -
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 392 +++------------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  21 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 557 ++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |  43 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  53 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  31 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  18 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   2 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  41 ++
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |  71 ++-
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |   3 +
 drivers/net/wireless/quantenna/qtnfmac/core.c      |  23 +-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |   1 -
 drivers/net/wireless/quantenna/qtnfmac/event.c     |  47 +-
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |  12 +-
 .../wireless/quantenna/qtnfmac/pcie/pcie_priv.h    |   4 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   |  36 +-
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   |  28 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |  57 +++
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |   5 +-
 .../wireless/realtek/rtl818x/rtl8180/rtl8225se.c   |  42 --
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   7 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |   9 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/sw.c    |   1 +
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |  25 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.h   |   2 +
 drivers/net/wireless/realtek/rtw88/main.c          |   5 +-
 drivers/net/wireless/realtek/rtw88/ps.c            |   1 -
 drivers/net/wireless/realtek/rtw88/ps.h            |   2 +-
 102 files changed, 1739 insertions(+), 1113 deletions(-)
