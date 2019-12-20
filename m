Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 350FA127F2E
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfLTPWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:22:11 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:39532 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727233AbfLTPWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:22:10 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576855329; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=rsSdJfNNfzfkGmZCCHCsmvo92P1vHVxqTOMR+oxP4F4=; b=ZYlWzqHbttn/pe78kYgJgSqynGx550A3PeuEtsqMSbQRDb2Nmh7v8G8nlpL8H7g2nmbaTH67
 KDP4Nymn4AAGcuo6v66wCSG1B1N9eTD8r6QHLuakgQNBCgTgpzACr4uKRrZuBVRS/V9k5v7Z
 hOJ/81E0dGvcDz222EeUO3Ewn7w=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfce720.7efd98014490-smtp-out-n02;
 Fri, 20 Dec 2019 15:22:08 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8EBF5C433A2; Fri, 20 Dec 2019 15:22:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D3E72C43383;
        Fri, 20 Dec 2019 15:22:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D3E72C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2019-12-20
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20191220152207.8EBF5C433A2@smtp.codeaurora.org>
Date:   Fri, 20 Dec 2019 15:22:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit e42617b825f8073569da76dc4510bfa019b1c35a:

  Linux 5.5-rc1 (2019-12-08 14:57:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2019-12-20

for you to fetch changes up to ae0a723c4cfd89dad31ce238f47ccfbe81b35b84:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2019-12-19 18:27:36 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for v5.6

First set of patches for v5.6. The biggest thing here is of course the
new driver ath11k but also new features for other drivers as well a
myriad of bug fixes.

Major changes:

ath11k

* a new driver for Qualcomm Wi-Fi 6 (IEEE 802.11ax) devices

ath10k

* significant improvements on receive throughput and firmware download
  with SDIO bus

* report signal strength for each chain also on SDIO

* set max mtu to 1500 on SDIO devices

brcmfmac

* add support for BCM4359 SDIO chipset

wil6210

* support set_multicast_to_unicast cfg80211 operation

* support set_cqm_rssi_config cfg80211 operation

wcn36xx

* disable HW_CONNECTION_MONITOR as firmware is buggy

----------------------------------------------------------------
Aditya Pakki (1):
      orinoco: avoid assertion in case of NULL pointer

Ahmad Masri (2):
      wil6210: dump Rx status message on errors
      wil6210: support set_multicast_to_unicast cfg80211 operation

Alagu Sankar (1):
      ath10k: enable RX bundle receive for sdio

Alexei Avshalom Lazar (3):
      wil6210: minimize the time that mem_lock is held
      wil6210: take mem_lock for writing in crash dump collection
      wil6210: add verification for cid upper bound

Anilkumar Kolli (6):
      ath11k: fix wmi service ready ext tlv parsing
      ath11k: update tcl cmd descriptor parameters for STA mode
      ath11k: tracing: fix ath11k tracing
      ath11k: qmi clean up ce and HTC service config update
      ath11k: qmi clean up in ath11k_qmi_wlanfw_wlan_cfg_send()
      ath11k: pktlog: fix sending/using the pdev id

Austin Kim (1):
      brcmsmac: Remove always false 'channel < 0' statement

Brian Norris (1):
      mwifiex: delete unused mwifiex_get_intf_num()

Christophe JAILLET (2):
      ath10k: Fix some typo in some warning messages
      rt2x00usb: Fix a warning message in 'rt2x00usb_watchdog_tx_dma()'

Chung-Hsien Hsu (1):
      brcmfmac: set F2 blocksize and watermark for 4359

Colin Ian King (5):
      wil6210: fix break that is never reached because of zero'ing of a retry counter
      ath11k: fix several spelling mistakes
      ath11k: fix memory leak on reg_info
      ath11k: fix uninitialized variable radioup
      ath11k: fix missing free of skb on error return path

Dan Carpenter (4):
      ath11k: delete a stray unlock in ath11k_dbg_htt_stats_req()
      ath11k: checking for NULL vs IS_ERR()
      ath11k: remove an unneeded NULL check
      brcmfmac: Fix use after free in brcmf_sdio_readframes()

Dedy Lansky (3):
      wil6210: reduce ucode_debug memory region
      wil6210: fix MID valid bits in Rx status message
      wil6210: add support for set_cqm_rssi_config

Dmitry Osipenko (1):
      brcmfmac: Keep OOB wake-interrupt disabled when it shouldn't be enabled

Eduardo Abinader (1):
      wcn36xx: disable HW_CONNECTION_MONITOR

Ganapathi Bhat (1):
      MAINTAINERS: update Ganapathi Bhat's email address

Ganesh Sesetti (1):
      ath11k: Fix htt stats sounding info and pdev cca stats

Govind Singh (1):
      ath10k: move non-fatal warn logs to dbg level

Govindaraj Saminathan (1):
      ath11k: unlock mutex during failure in qmi fw ready

Jeffrey Hugo (3):
      ath10k: Handle when FW doesn't support QMI_WLFW_HOST_CAP_REQ_V01
      ath10k: Fix qmi init error handling
      ath10k: Handle "invalid" BDFs for msm8998 devices

Johan Hovold (12):
      ath9k: fix storage endpoint lookup
      rsi: fix use-after-free on failed probe and unbind
      rsi: fix use-after-free on probe errors
      rsi: fix memory leak on failed URB submission
      rsi: fix non-atomic allocation in completion handler
      rsi: add missing endpoint sanity checks
      at76c50x-usb: fix endpoint debug message
      brcmfmac: fix interface sanity check
      orinoco_usb: fix interface sanity check
      rtl8xxxu: fix interface sanity check
      rsi_91x_usb: fix interface sanity check
      zd1211rw: fix storage endpoint lookup

John Crispin (17):
      ath11k: add RX stats support for radiotap
      ath11k: ignore event 0x6017
      ath11k: convert message from info to dbg
      ath11k: add HE support
      ath11k: add TWT support
      ath11k: add spatial reuse support
      ath11k: optimize RX path latency
      ath11k: fix indentation in ath11k_mac_prepare_he_mode()
      ath11k: add wmi helper for turning STA PS on/off
      ath11k: disable PS for STA interfaces by default upon bringup
      ath11k: drop memset when setting up a tx cmd desc
      ath11k: rename ath11k_wmi_base instances from wmi_sc to wmi_ab
      ath11k: move some tx_status parsing to debugfs code
      ath11k: optimise ath11k_dp_tx_completion_handler
      ath11k: optimize ath11k_hal_tx_status_parse
      ath11k: add some missing __packed qualifiers
      ath11k: explicitly cast wmi commands to their correct struct type

Kalle Valo (7):
      ath10k: sdio: cosmetic cleanup
      ath10k: sdio: remove struct ath10k_sdio_rx_data::status
      dt: bindings: net: add qcom,ath11k.yaml
      ath11k: driver for Qualcomm IEEE 802.11ax devices
      MAINTAINERS: add ath11k
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Karthikeyan Periyasamy (4):
      ath11k: fix resource leak in ath11k_mac_sta_state
      ath11k: avoid WMM param truncation
      ath11k: avoid burst time conversion logic
      ath11k: avoid use_after_free in ath11k_dp_rx_msdu_coalesce API

Kees Cook (1):
      ath11k: Use sizeof_field() instead of FIELD_SIZEOF()

Larry Finger (13):
      rtlwifi: rtl8192de: Remove unused GET_XXX and SET_XXX macros
      rtlwifi: rtl8192de: Replace local bit manipulation macros
      rtlwifi: rtl8192de: Convert macros that set descriptor
      rtlwifi: rtl8192de: Convert inline routines to little-endian words
      rtlwifi: rtl8192de: Remove usage of private bit manipulation macros
      rtlwifi: rtl8188ee: Remove usage of private bit manipulation
      rtlwifi: rtl8192ce: rtl8192c_com: Remove usage of private bit manipulation macros
      rtlwifi: Remove dependence on special bit manipulation macros for common driver
      rtlwifi: rtl88821ae: Remove usage of private bit manipulation macros
      rtlwifi: rtl8192ee: Remove usage of private bit manipulation macros
      rtlwifi: rtl8723ae: Remove usage of private bit manipulation macros
      rtlwifi: rtl8723be: Remove usage of private bit manipulation macros
      rtlwifi: Remove last definitions of local bit manipulation macros

Linus Lüssing (1):
      ath10k: fix RX of frames with broken FCS in monitor mode

Maharaja Kennadyrajan (1):
      ath11k: add support for controlling tx power to a station

Manikanta Pubbisetty (1):
      ath11k: fix vht guard interval mapping

Michael Straube (6):
      rtlwifi: rtl8192ce: use generic rtl_query_rxpwrpercentage
      rtlwifi: rtl8192cu: use generic rtl_query_rxpwrpercentage
      rtlwifi: rtl8192de: use generic rtl_query_rxpwrpercentage
      rtlwifi: rtl8192ce: use generic rtl_signal_scale_mapping
      rtlwifi: rtl8192cu: use generic rtl_signal_scale_mapping
      rtlwifi: rtl8192de: use generic rtl_signal_scale_mapping

Miles Hu (1):
      ath11k: fix memory leak in monitor mode

Nathan Chancellor (1):
      ath11k: Remove unnecessary enum scan_priority

Navid Emamdoost (2):
      brcmfmac: Fix memory leak in brcmf_p2p_create_p2pdev()
      brcmfmac: Fix memory leak in brcmf_usbdev_qinit

Phong Tran (4):
      b43legacy: Fix -Wcast-function-type
      ipw2x00: Fix -Wcast-function-type
      iwlegacy: Fix -Wcast-function-type
      rtlwifi: rtl_pci: Fix -Wcast-function-type

Pradeep Kumar Chitrapu (3):
      ath11k: remove unused tx ring counters
      ath11k: fix pdev when invoking ath11k_wmi_send_twt_enable_cmd()
      ath11k: set the BA buffer size to 256 when HE is enabled

Rafał Miłecki (1):
      brcmfmac: set interface carrier to off by default

Soeren Moch (3):
      brcmfmac: fix rambase for 4359/9
      brcmfmac: make errors when setting roaming parameters non-fatal
      brcmfmac: add support for BCM4359 SDIO chipset

Sriram R (3):
      ath11k: Fix skb_panic observed during msdu coalescing
      ath11k: add necessary peer assoc params in wmi dbg
      ath11k: Update tx and rx chain count properly on drv_set_antenna

Stanislaw Gruszka (2):
      rt2x00: implement reconfig_complete
      rt2x00: use RESET state bit to prevent IV changes on restart

Sven Eckelmann (1):
      ath11k: register HE mesh capabilities

Tamizh chelvam (2):
      ath11k: fix missed bw conversion in tx completion
      ath11k: Remove dead code while handling amsdu packets

Vasanthakumar Thiagarajan (3):
      ath11k: Fix target crash due to WBM_IDLE_LINK ring desc shortage
      ath11k: Move mac80211 hw allocation before wmi_init command
      ath11k: Setup REO destination ring before sending wmi_init command

Venkateswara Naralasetty (4):
      ath11k: update bawindow size in delba process
      ath11k: Advertise MPDU start spacing as no restriction
      ath11k: update tx duration in station info
      ath11k: Skip update peer stats for management packets

Vikas Patel (1):
      ath11k: Fixing TLV length issue in peer pktlog WMI command

Wen Gong (14):
      ath10k: change max RX bundle size from 8 to 32 for sdio
      ath10k: add workqueue for RX path of sdio
      ath10k: correct the tlv len of ath10k_wmi_tlv_op_gen_config_pno_start
      ath10k: add large size for BMI download data for SDIO
      ath10k: add NL80211_FEATURE_ND_RANDOM_MAC_ADDR for NLO
      ath10k: report rssi of each chain to mac80211 for sdio
      ath10k: enable firmware log by default for sdio
      ath10k: set max mtu to 1500 for sdio chip
      ath10k: set WMI_PEER_AUTHORIZE after a firmware crash
      ath10k: change log level for mpdu status of sdio chip
      ath10k: enable wow feature for sdio chip
      ath10k: enable napi on RX path for sdio
      ath10k: change bundle count for max rx bundle for sdio
      ath: add support for special 0x0 regulatory domain

Wright Feng (3):
      brcmfmac: reset two D11 cores if chip has two D11 cores
      brcmfmac: add RSDB condition when setting interface combinations
      brcmfmac: not set mbss in vif if firmware does not support MBSS

yu kuai (1):
      bcma: remove set but not used variable 'sizel'

zhengbin (1):
      ath11k: Remove unneeded semicolon

 .../bindings/net/wireless/qcom,ath11k.yaml         |  273 +
 MAINTAINERS                                        |    9 +-
 drivers/bcma/scan.c                                |    7 +-
 drivers/net/wireless/ath/Kconfig                   |    1 +
 drivers/net/wireless/ath/Makefile                  |    1 +
 drivers/net/wireless/ath/ath10k/bmi.c              |   52 +-
 drivers/net/wireless/ath/ath10k/bmi.h              |   10 +
 drivers/net/wireless/ath/ath10k/core.c             |   15 +-
 drivers/net/wireless/ath/ath10k/core.h             |    2 +
 drivers/net/wireless/ath/ath10k/debug.c            |    2 +
 drivers/net/wireless/ath/ath10k/htc.c              |   10 +-
 drivers/net/wireless/ath/ath10k/htc.h              |   23 +-
 drivers/net/wireless/ath/ath10k/htt.h              |    3 +
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   63 +-
 drivers/net/wireless/ath/ath10k/hw.h               |    3 +
 drivers/net/wireless/ath/ath10k/mac.c              |    6 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |   14 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |  232 +-
 drivers/net/wireless/ath/ath10k/sdio.h             |   21 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |    5 +-
 drivers/net/wireless/ath/ath10k/testmode.c         |    4 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   10 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   18 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |    2 +
 drivers/net/wireless/ath/ath11k/Kconfig            |   35 +
 drivers/net/wireless/ath/ath11k/Makefile           |   26 +
 drivers/net/wireless/ath/ath11k/ahb.c              | 1003 ++++
 drivers/net/wireless/ath/ath11k/ahb.h              |   35 +
 drivers/net/wireless/ath/ath11k/ce.c               |  808 +++
 drivers/net/wireless/ath/ath11k/ce.h               |  183 +
 drivers/net/wireless/ath/ath11k/core.c             |  795 +++
 drivers/net/wireless/ath/ath11k/core.h             |  826 +++
 drivers/net/wireless/ath/ath11k/debug.c            | 1060 ++++
 drivers/net/wireless/ath/ath11k/debug.h            |  281 +
 drivers/net/wireless/ath/ath11k/debug_htt_stats.c  | 4431 +++++++++++++++
 drivers/net/wireless/ath/ath11k/debug_htt_stats.h  | 1620 ++++++
 drivers/net/wireless/ath/ath11k/debugfs_sta.c      |  543 ++
 drivers/net/wireless/ath/ath11k/dp.c               |  899 +++
 drivers/net/wireless/ath/ath11k/dp.h               | 1527 +++++
 drivers/net/wireless/ath/ath11k/dp_rx.c            | 4194 ++++++++++++++
 drivers/net/wireless/ath/ath11k/dp_rx.h            |   86 +
 drivers/net/wireless/ath/ath11k/dp_tx.c            |  962 ++++
 drivers/net/wireless/ath/ath11k/dp_tx.h            |   40 +
 drivers/net/wireless/ath/ath11k/hal.c              | 1124 ++++
 drivers/net/wireless/ath/ath11k/hal.h              |  897 +++
 drivers/net/wireless/ath/ath11k/hal_desc.h         | 2468 ++++++++
 drivers/net/wireless/ath/ath11k/hal_rx.c           | 1190 ++++
 drivers/net/wireless/ath/ath11k/hal_rx.h           |  332 ++
 drivers/net/wireless/ath/ath11k/hal_tx.c           |  154 +
 drivers/net/wireless/ath/ath11k/hal_tx.h           |   69 +
 drivers/net/wireless/ath/ath11k/htc.c              |  773 +++
 drivers/net/wireless/ath/ath11k/htc.h              |  313 ++
 drivers/net/wireless/ath/ath11k/hw.h               |  127 +
 drivers/net/wireless/ath/ath11k/mac.c              | 5908 ++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/mac.h              |  147 +
 drivers/net/wireless/ath/ath11k/peer.c             |  236 +
 drivers/net/wireless/ath/ath11k/peer.h             |   35 +
 drivers/net/wireless/ath/ath11k/qmi.c              | 2433 ++++++++
 drivers/net/wireless/ath/ath11k/qmi.h              |  445 ++
 drivers/net/wireless/ath/ath11k/reg.c              |  702 +++
 drivers/net/wireless/ath/ath11k/reg.h              |   35 +
 drivers/net/wireless/ath/ath11k/rx_desc.h          | 1212 ++++
 drivers/net/wireless/ath/ath11k/testmode.c         |  199 +
 drivers/net/wireless/ath/ath11k/testmode.h         |   29 +
 drivers/net/wireless/ath/ath11k/testmode_i.h       |   50 +
 drivers/net/wireless/ath/ath11k/trace.c            |    9 +
 drivers/net/wireless/ath/ath11k/trace.h            |  113 +
 drivers/net/wireless/ath/ath11k/wmi.c              | 5810 +++++++++++++++++++
 drivers/net/wireless/ath/ath11k/wmi.h              | 4764 ++++++++++++++++
 drivers/net/wireless/ath/ath9k/hif_usb.c           |    2 +-
 drivers/net/wireless/ath/regd.c                    |   10 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |    1 -
 drivers/net/wireless/ath/wil6210/cfg80211.c        |   34 +
 drivers/net/wireless/ath/wil6210/main.c            |   10 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |   32 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c       |   13 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.h       |    8 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |    6 +-
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c  |   17 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |   80 +-
 drivers/net/wireless/ath/wil6210/wmi.h             |   33 +
 drivers/net/wireless/atmel/at76c50x-usb.c          |    2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |    5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |   18 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   68 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |   54 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.h    |    1 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |    2 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |    3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   18 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |    1 -
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |    5 +-
 .../wireless/broadcom/brcm80211/brcmsmac/main.c    |    2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |    7 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |    5 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |    5 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |    5 +-
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |    7 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |   13 -
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |   21 +-
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c     |    1 +
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c     |    1 +
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c     |    1 +
 drivers/net/wireless/ralink/rt2x00/rt2x00.h        |    2 +
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |   11 -
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c     |   20 +
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |    2 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |    2 +-
 drivers/net/wireless/realtek/rtlwifi/base.h        |    4 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   10 +-
 drivers/net/wireless/realtek/rtlwifi/ps.c          |   20 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/fw.c    |   12 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/fw.h    |  103 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |   11 +-
 .../wireless/realtek/rtlwifi/rtl8192c/dm_common.c  |   19 +-
 .../wireless/realtek/rtlwifi/rtl8192c/fw_common.h  |   14 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    |   11 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |   48 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/mac.c   |   49 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/fw.h    |   61 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |  299 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.h   |  853 ++-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.h    |   36 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/fw.h    |   14 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.h    |   30 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.h    |  102 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  115 -
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   12 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |   49 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |    2 +-
 include/linux/mmc/sdio_ids.h                       |    2 +
 132 files changed, 50743 insertions(+), 1377 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
 create mode 100644 drivers/net/wireless/ath/ath11k/Kconfig
 create mode 100644 drivers/net/wireless/ath/ath11k/Makefile
 create mode 100644 drivers/net/wireless/ath/ath11k/ahb.c
 create mode 100644 drivers/net/wireless/ath/ath11k/ahb.h
 create mode 100644 drivers/net/wireless/ath/ath11k/ce.c
 create mode 100644 drivers/net/wireless/ath/ath11k/ce.h
 create mode 100644 drivers/net/wireless/ath/ath11k/core.c
 create mode 100644 drivers/net/wireless/ath/ath11k/core.h
 create mode 100644 drivers/net/wireless/ath/ath11k/debug.c
 create mode 100644 drivers/net/wireless/ath/ath11k/debug.h
 create mode 100644 drivers/net/wireless/ath/ath11k/debug_htt_stats.c
 create mode 100644 drivers/net/wireless/ath/ath11k/debug_htt_stats.h
 create mode 100644 drivers/net/wireless/ath/ath11k/debugfs_sta.c
 create mode 100644 drivers/net/wireless/ath/ath11k/dp.c
 create mode 100644 drivers/net/wireless/ath/ath11k/dp.h
 create mode 100644 drivers/net/wireless/ath/ath11k/dp_rx.c
 create mode 100644 drivers/net/wireless/ath/ath11k/dp_rx.h
 create mode 100644 drivers/net/wireless/ath/ath11k/dp_tx.c
 create mode 100644 drivers/net/wireless/ath/ath11k/dp_tx.h
 create mode 100644 drivers/net/wireless/ath/ath11k/hal.c
 create mode 100644 drivers/net/wireless/ath/ath11k/hal.h
 create mode 100644 drivers/net/wireless/ath/ath11k/hal_desc.h
 create mode 100644 drivers/net/wireless/ath/ath11k/hal_rx.c
 create mode 100644 drivers/net/wireless/ath/ath11k/hal_rx.h
 create mode 100644 drivers/net/wireless/ath/ath11k/hal_tx.c
 create mode 100644 drivers/net/wireless/ath/ath11k/hal_tx.h
 create mode 100644 drivers/net/wireless/ath/ath11k/htc.c
 create mode 100644 drivers/net/wireless/ath/ath11k/htc.h
 create mode 100644 drivers/net/wireless/ath/ath11k/hw.h
 create mode 100644 drivers/net/wireless/ath/ath11k/mac.c
 create mode 100644 drivers/net/wireless/ath/ath11k/mac.h
 create mode 100644 drivers/net/wireless/ath/ath11k/peer.c
 create mode 100644 drivers/net/wireless/ath/ath11k/peer.h
 create mode 100644 drivers/net/wireless/ath/ath11k/qmi.c
 create mode 100644 drivers/net/wireless/ath/ath11k/qmi.h
 create mode 100644 drivers/net/wireless/ath/ath11k/reg.c
 create mode 100644 drivers/net/wireless/ath/ath11k/reg.h
 create mode 100644 drivers/net/wireless/ath/ath11k/rx_desc.h
 create mode 100644 drivers/net/wireless/ath/ath11k/testmode.c
 create mode 100644 drivers/net/wireless/ath/ath11k/testmode.h
 create mode 100644 drivers/net/wireless/ath/ath11k/testmode_i.h
 create mode 100644 drivers/net/wireless/ath/ath11k/trace.c
 create mode 100644 drivers/net/wireless/ath/ath11k/trace.h
 create mode 100644 drivers/net/wireless/ath/ath11k/wmi.c
 create mode 100644 drivers/net/wireless/ath/ath11k/wmi.h
