Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A86C424E6D
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 10:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240400AbhJGICL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 04:02:11 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:42723 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233691AbhJGICF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 04:02:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633593612; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=DqbHGT5SABYomDXC03I/W+31shIQtTYwZnRzgEVJTeE=; b=VZqInHhW0KPdiLTxn3iA+tvp3zRKTwy3R/+5LL7QsT8F5SD1oBIFOTdqb1IYJWM1/l0NgUXc
 37UjfnFCKrUf6huZDod7AhFLzVAJ+h7XYbO1QE2qPTc88cHziyq3qZ3gFFSdFmk+FpQ6QdTH
 z3hga8BBuKjV2Dylq8dt2cI4Dfw=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 615ea9027ae92c7fc9382aae (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 07 Oct 2021 08:00:02
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 97852C43460; Thu,  7 Oct 2021 08:00:01 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E308DC4338F;
        Thu,  7 Oct 2021 07:59:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org E308DC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2021-10-07
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20211007080001.97852C43460@smtp.codeaurora.org>
Date:   Thu,  7 Oct 2021 08:00:01 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 6880fa6c56601bb8ed59df6c30fd390cc5f6dd8f:

  Linux 5.15-rc1 (2021-09-12 16:28:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2021-10-07

for you to fetch changes up to b3fcf9c5faaa2b09544f2cdd1eaae81c7a822f92:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2021-10-05 09:23:01 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.16

First set of patches for v5.16. ath11k getting most of new features
this time. Other drivers also have few new features, and of course the
usual set of fixes and cleanups all over.

Major changes:

rtw88

* support adaptivity for ETSI/JP DFS region

* 8821c: support RFE type4 wifi NIC

brcmfmac

* DMI nvram filename quirk for Cyberbook T116 tablet

ath9k

* load calibration data and pci init values via nvmem subsystem

ath11k

* include channel rx and tx time in survey dump statistics

* support for setting fixed Wi-Fi 6 rates from user space

* support for 80P80 and 160 MHz bandwidths

* spectral scan support for QCN9074

* support for calibration data files per radio

* support for calibration data via eeprom

* support for rx decapsulation offload (data frames in 802.3 format)

* support channel 2 in 6 GHz band

ath10k

* include frame time stamp in beacon and probe response frames

wcn36xx

* enable Idle Mode Power Save (IMPS) to reduce power consumption during idle

----------------------------------------------------------------
Aaron Ma (1):
      ath11k: qmi: avoid error messages when dma allocation fails

Ajay Singh (11):
      wilc1000: move 'deinit_lock' lock init/destroy inside module probe
      wilc1000: fix possible memory leak in cfg_scan_result()
      wilc1000: add new WID to pass wake_enable information to firmware
      wilc1000: configure registers to handle chip wakeup sequence
      wilc1000: add reset/terminate/repeat command support for SPI bus
      wilc1000: handle read failure issue for clockless registers
      wilc1000: ignore clockless registers status response for SPI
      wilc1000: invoke chip reset register before firmware download
      wilc1000: add 'initialized' flag check before adding an element to TX queue
      wilc1000: use correct write command sequence in wilc_spi_sync_ext()
      wilc1000: increase config packets response wait timeout limit

Alagu Sankar (1):
      ath10k: high latency fixes for beacon buffer

Anilkumar Kolli (5):
      ath11k: use hw_params to access board_size and cal_offset
      ath11k: clean up BDF download functions
      ath11k: add caldata file for multiple radios
      ath11k: add caldata download support from EEPROM
      ath11k: Fix pktlog lite rx events

Arnd Bergmann (1):
      ath11k: Wstringop-overread warning

Baochen Qiang (4):
      ath11k: Drop MSDU with length error in DP rx path
      ath11k: Fix inaccessible debug registers
      ath11k: Fix memory leak in ath11k_qmi_driver_event_work
      ath11k: Change DMA_FROM_DEVICE to DMA_TO_DEVICE when map reinjected packets

Benjamin Li (1):
      wcn36xx: handle connection loss indication

Bryan O'Donoghue (3):
      wcn36xx: Fix Antenna Diversity Switching
      wcn36xx: Add ability for wcn36xx_smd_dump_cmd_req to pass two's complement
      wcn36xx: Implement Idle Mode Power Save

Cai Huoqing (1):
      ipw2200: Fix a function name in print messages

Chin-Yen Lee (1):
      rtw88: move adaptivity mechanism to firmware

Chris Chiu (1):
      rtl8xxxu: Use lower tx rates for the ack packet

Christian Lamparter (2):
      ath9k: fetch calibration data via nvmem subsystem
      ath9k: owl-loader: fetch pci init values through nvmem

Dan Carpenter (1):
      ath11k: fix some sleeping in atomic bugs

Fabio Estevam (1):
      ath10k: sdio: Add missing BH locking around napi_schdule()

Guo-Feng Fan (2):
      rtw88: 8821c: support RFE type4 wifi NIC
      rtw88: 8821c: correct 2.4G tx power for type 2/4 NIC

Gustavo A. R. Silva (1):
      ath11k: Replace one-element array with flexible-array member

Hans de Goede (1):
      brcmfmac: Add DMI nvram filename quirk for Cyberbook T116 tablet

James Prestwood (1):
      brcmfmac: fix incorrect error prints

Jonas Dreßler (9):
      mwifiex: Small cleanup for handling virtual interface type changes
      mwifiex: Use function to check whether interface type change is allowed
      mwifiex: Run SET_BSS_MODE when changing from P2P to STATION vif-type
      mwifiex: Use helper function for counting interface types
      mwifiex: Update virtual interface counters right after setting bss_type
      mwifiex: Allow switching interface type from P2P_CLIENT to P2P_GO
      mwifiex: Handle interface type changes from AP to STATION
      mwifiex: Properly initialize private structure on interface type changes
      mwifiex: Fix copy-paste mistake when creating virtual interface

Kalle Valo (1):
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Karthikeyan Periyasamy (6):
      ath11k: fix 4addr multicast packet tx
      ath11k: Refactor spectral FFT bin size
      ath11k: Introduce spectral hw configurable param
      ath11k: Fix the spectral minimum FFT bin count
      ath11k: Add spectral scan support for QCN9074
      ath11k: Avoid "No VIF found" warning message

Krzysztof Kozlowski (3):
      zd1211rw: remove duplicate USB device ID
      ar5512: remove duplicate USB device ID
      rt2x00: remove duplicate USB device ID

Len Baker (1):
      brcmfmac: Replace zero-length array with flexible array member

Loic Poulain (1):
      ath10k: Fix missing frame timestamp for beacon/probe-resp

Marek Vasut (1):
      rsi: Fix module dev_oper_mode parameter description

Martin Fuzzey (3):
      rsi: fix occasional initialisation failure with BT coex
      rsi: fix key enabled check causing unwanted encryption for vap_id > 0
      rsi: fix rate mask set leading to P2P failure

Miles Hu (1):
      ath11k: add support for setting fixed HE rate/gi/ltf

P Praneesh (2):
      ath11k: add support for 80P80 and 160 MHz bandwidth
      ath11k: Add wmi peer create conf event in wmi_tlv_event_id

Pradeep Kumar Chitrapu (6):
      ath11k: add channel 2 into 6 GHz channel list
      ath11k: fix packet drops due to incorrect 6 GHz freq value in rx status
      ath11k: fix survey dump collection in 6 GHz
      ieee80211: Add new A-MPDU factor macro for HE 6 GHz peer caps
      ath11k: add 6 GHz params in peer assoc command
      ath11k: support SMPS configuration for 6 GHz

Sathishkumar Muruganandam (1):
      ath11k: fix 4-addr tx failure for AP and STA modes

Seevalamuthu Mariappan (12):
      ath11k: Rename atf_config to flag1 in target_resource_config
      ath11k: add support in survey dump with bss_chan_info
      ath11k: Align bss_chan_info structure with firmware
      ath11k: move static function ath11k_mac_vdev_setup_sync to top
      ath11k: add separate APIs for monitor mode
      ath11k: monitor mode clean up to use separate APIs
      ath11k: Add vdev start flag to disable hardware encryption
      ath11k: Assign free_vdev_map value before ieee80211_register_hw
      ath11k: Rename macro ARRAY_TO_STRING to PRINT_ARRAY_TO_BUF
      ath11k: Replace HTT_DBG_OUT with scnprintf
      ath11k: Remove htt stats fixed size array usage
      ath11k: Change masking and shifting in htt stats

Sohaib Mohamed (1):
      bcma: drop unneeded initialization value

Sriram R (5):
      ath11k: Add support for RX decapsulation offload
      ath11k: Update pdev tx and rx firmware stats
      ath11k: Avoid reg rules update during firmware recovery
      ath11k: Avoid race during regd updates
      ath11k: Fix crash during firmware recovery on reo cmd ring access

Venkateswara Naralasetty (1):
      ath11k: add HTT stats support for new stats

Wen Gong (6):
      ath11k: re-enable ht_cap/vht_cap for 5G band for WCN6855
      ath11k: enable 6G channels for WCN6855
      ath11k: copy cap info of 6G band under WMI_HOST_WLAN_5G_CAP for WCN6855
      ath11k: add handler for scan event WMI_SCAN_EVENT_DEQUEUED
      ath11k: indicate scan complete for scan canceled when scan running
      ath11k: indicate to mac80211 scan complete with aborted flag for ATH11K_SCAN_STARTING state

Zong-Zhe Yang (5):
      rtw88: upgrade rtw_regulatory mechanism and mapping
      rtw88: add regulatory strategy by chip type
      rtw88: support adaptivity for ETSI/JP DFS region
      rtw88: fix RX clock gate setting while fifo dump
      rtw88: refine fw_crash debugfs to show non-zero while triggering

 drivers/bcma/main.c                                |    2 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |    3 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   31 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |    5 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |    4 +
 drivers/net/wireless/ath/ath11k/core.c             |   58 +-
 drivers/net/wireless/ath/ath11k/core.h             |   49 +-
 drivers/net/wireless/ath/ath11k/dbring.c           |   16 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |   25 +-
 drivers/net/wireless/ath/ath11k/debugfs.h          |    4 +
 .../net/wireless/ath/ath11k/debugfs_htt_stats.c    | 4344 ++++++++++----------
 .../net/wireless/ath/ath11k/debugfs_htt_stats.h    |  226 +
 drivers/net/wireless/ath/ath11k/debugfs_sta.c      |    8 +-
 drivers/net/wireless/ath/ath11k/dp.h               |    8 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  243 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |   23 +-
 drivers/net/wireless/ath/ath11k/dp_tx.h            |    2 +-
 drivers/net/wireless/ath/ath11k/hal_desc.h         |    2 +
 drivers/net/wireless/ath/ath11k/hw.c               |   45 +
 drivers/net/wireless/ath/ath11k/hw.h               |   13 +-
 drivers/net/wireless/ath/ath11k/mac.c              | 1443 ++++++-
 drivers/net/wireless/ath/ath11k/mac.h              |    3 +
 drivers/net/wireless/ath/ath11k/pci.c              |    4 +-
 drivers/net/wireless/ath/ath11k/peer.c             |   11 +
 drivers/net/wireless/ath/ath11k/qmi.c              |  350 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |   18 +-
 drivers/net/wireless/ath/ath11k/reg.c              |   18 +-
 drivers/net/wireless/ath/ath11k/reg.h              |    2 +-
 drivers/net/wireless/ath/ath11k/spectral.c         |   42 +-
 drivers/net/wireless/ath/ath11k/trace.h            |   11 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  152 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |  107 +-
 .../net/wireless/ath/ath9k/ath9k_pci_owl_loader.c  |  105 +-
 drivers/net/wireless/ath/ath9k/eeprom.c            |   12 +-
 drivers/net/wireless/ath/ath9k/hw.h                |    2 +
 drivers/net/wireless/ath/ath9k/init.c              |   56 +
 drivers/net/wireless/ath/spectral_common.h         |    1 -
 drivers/net/wireless/ath/wcn36xx/debug.c           |    2 +-
 drivers/net/wireless/ath/wcn36xx/hal.h             |    6 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   11 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |   99 +-
 drivers/net/wireless/ath/wcn36xx/smd.h             |    3 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   12 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |   10 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |    2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |    2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  370 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |   11 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   31 +-
 drivers/net/wireless/microchip/wilc1000/hif.h      |    1 +
 drivers/net/wireless/microchip/wilc1000/netdev.h   |    2 -
 drivers/net/wireless/microchip/wilc1000/sdio.c     |    1 +
 drivers/net/wireless/microchip/wilc1000/spi.c      |   91 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |  134 +-
 drivers/net/wireless/microchip/wilc1000/wlan.h     |    5 +-
 drivers/net/wireless/microchip/wilc1000/wlan_cfg.c |    1 +
 drivers/net/wireless/microchip/wilc1000/wlan_if.h  |    7 +-
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c     |    1 -
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |    6 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |    2 +
 drivers/net/wireless/realtek/rtw88/debug.c         |   46 +-
 drivers/net/wireless/realtek/rtw88/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw88/fw.c            |   54 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |   24 +
 drivers/net/wireless/realtek/rtw88/main.c          |   22 +-
 drivers/net/wireless/realtek/rtw88/main.h          |   49 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |  119 +-
 drivers/net/wireless/realtek/rtw88/phy.h           |    2 +
 drivers/net/wireless/realtek/rtw88/reg.h           |    6 +
 drivers/net/wireless/realtek/rtw88/regd.c          |  753 ++--
 drivers/net/wireless/realtek/rtw88/regd.h          |    8 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |   19 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |   46 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.h      |    8 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   47 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |    3 +
 drivers/net/wireless/rsi/rsi_91x_core.c            |    2 +
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   10 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   74 +-
 drivers/net/wireless/rsi/rsi_91x_main.c            |   16 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   24 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |    5 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |    5 +-
 drivers/net/wireless/rsi/rsi_hal.h                 |   11 +
 drivers/net/wireless/rsi/rsi_main.h                |   15 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |    1 -
 include/linux/ieee80211.h                          |    1 +
 include/linux/platform_data/brcmfmac.h             |    2 +-
 88 files changed, 6293 insertions(+), 3338 deletions(-)
