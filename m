Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576171E922A
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 16:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgE3Ord (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 10:47:33 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:35745 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729029AbgE3Orc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 10:47:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590850050; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=/JgjKi6Q8l2P9JxSxayv+hLybp2PDvTvazxLpoUOcs4=; b=OtDrX6a9yGgfZGlnutxnolXC6OwBcfOgfRsFBRj23t4tpneyAAF0dw//QK98rsjlGabj2eUX
 7TQESm49OWj5OGXpXzsF78V/Wi86Qg07HadXF6rCF6YcKl3lCskrrQVF3ZTCH0ET18oaqcMx
 hBdbVtKD/EN5f9UH2RjLO+7x0Tk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-east-1.postgun.com with SMTP id
 5ed272022c549984750807a2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 30 May 2020 14:47:30
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3755FC433C9; Sat, 30 May 2020 14:47:29 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BD22FC433C6;
        Sat, 30 May 2020 14:47:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BD22FC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2020-05-30
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20200530144729.3755FC433C9@smtp.codeaurora.org>
Date:   Sat, 30 May 2020 14:47:29 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 50ce4c099bebf56be86c9448f7f4bcd34f33663c:

  sctp: fix typo sctp_ulpevent_nofity_peer_addr_change (2020-05-27 15:08:02 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2020-05-30

for you to fetch changes up to e948ed0427991d197c861fcac4961e699b978d5d:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2020-05-30 17:31:27 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.8

Third set of patches for v5.8. Final new features before the merge
window (most likely) opens, noteworthy here is adding WPA3 support to
old drivers rt2800, b43 and b43_legacy.

Major changes:

ath10k

* SDIO and SNOC busses are not experimental anymore

ath9k

* allow receive of broadcast Action frames

ath9k_htc

* allow receive of broadcast Action frames

rt2800

* enable WPA3 support out of box

b43

* enable WPA3 support

b43_legacy

* enable WPA3 support

mwifiex

* advertise max number of clients to user space

mt76

* mt7663: add remain-on-channel support

* mt7915: add spatial reuse support

* add support for mt7611n hardware

iwlwifi

* add ACPI DSM support

* support enabling 5.2GHz bands in Indonesia via ACPI

* bump FW API version to 56

----------------------------------------------------------------
Arnd Bergmann (3):
      wil6210: avoid gcc-10 zero-length-bounds warning
      ath10k: fix gcc-10 zero-length-bounds warnings
      ath10k: fix ath10k_pci struct layout

Avraham Stern (1):
      iwlwifi: mvm: add support for range request version 10

Chien-Hsun Liao (1):
      rtw88: 8822c: remove CCK TX setting when switch channel

Christophe JAILLET (2):
      wcn36xx: Fix error handling path in 'wcn36xx_probe()'
      ath11k: Fix some resource leaks in error path in 'ath11k_thermal_register()'

Colin Ian King (2):
      ath11k: remove redundant initialization of pointer info
      mt76: mt7915: fix a handful of spelling mistakes

DENG Qingfang (1):
      mt76: mt7615: add support for MT7611N

Dan Carpenter (1):
      airo: Fix read overflows sending packets

Dinghao Liu (5):
      wlcore: fix runtime pm imbalance in wl1271_tx_work
      wlcore: fix runtime pm imbalance in wlcore_regdomain_config
      wlcore: fix runtime pm imbalance in wl1271_op_suspend
      wlcore: fix runtime pm imbalance in __wl1271_op_remove_interface
      wlcore: fix runtime pm imbalance in wlcore_irq_locked

Double Lo (2):
      brcmfmac: fix 4339 CRC error under SDIO 3.0 SDR104 mode
      brcmfmac: 43012 Update MES Watermark

Douglas Anderson (1):
      ath10k: Remove ath10k_qmi_register_service_notifier() declaration

Felix Fietkau (3):
      mt76: fix per-driver wcid range checks after wcid array size bump
      mt76: fix wcid allocation issues
      mt76: only iterate over initialized rx queues

Frank Kao (1):
      brcmfmac: set F2 blocksize and watermark for 4354/4356 SDIO

Gil Adam (2):
      iwlwifi: acpi: support device specific method (DSM)
      iwlwifi: acpi: evaluate dsm to enable 5.2 bands in Indonesia

Govind Singh (4):
      ath11k: Add support for multibus support
      ath11k: Add drv private for bus opaque struct
      ath11k: Remove bus layer includes from upper layer
      ath10k: remove experimental tag from SDIO and SNOC busses in Kconfig

Gustavo A. R. Silva (4):
      ath10k: Replace zero-length array with flexible-array
      carl9170: Replace zero-length array with flexible-array
      wil6210: Replace zero-length array with flexible-array
      wcn36xx: Replace zero-length array with flexible-array

Haim Dreyfuss (2):
      iwlwifi: set NO_HE if the regulatory domain forbids it
      iwlwifi: pcie: don't count on the FW to set persistence mode

Johannes Berg (1):
      iwlwifi: pcie: gen3: indicate 8k/12k RB size to device

Jouni Malinen (2):
      ath9k: Set RX filter based to allow broadcast Action frame RX
      ath9k_htc: Set RX filter based to allow broadcast Action frame RX

Kalle Valo (4):
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge tag 'mt76-for-kvalo-2020-05-28' of https://github.com/nbd168/wireless
      Merge tag 'iwlwifi-next-for-kalle-2020-05-29' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Larry Finger (2):
      b43: Fix connection problem with WPA3
      b43_legacy: Fix connection problem with WPA3

Lorenzo Bianconi (5):
      mt76: mt7615: introduce remain_on_channel support
      mt76: mt76x02: remove check in mt76x02_mcu_msg_send
      mt76: mt7615: fix NULL pointer deref in mt7615_register_ext_phy
      mt76: mt7615: switch to per-vif power_save support
      mt76: mt7915: fix possible NULL pointer dereference in mt7915_register_ext_phy

Luca Coelho (1):
      iwlwifi: bump FW API to 56 for AX devices

Miles Hu (1):
      ath11k: remove stale monitor status descriptor

Mordechay Goodstein (3):
      iwlwifi: pcie: keep trans instead of trans_pcie in iwl_txq
      iwlwifi: move iwl_txq and substructures to a common trans header
      iwlwifi: move txq-specific from trans_pcie to common trans

Muna Sinada (2):
      ath11k: reset trigger frame MAC padding duration
      ath11k: clear DCM max constellation tx value

Pali Rohár (3):
      cw1200: Remove local sdio VENDOR and DEVICE id definitions
      mwifiex: Parse all API_VER_ID properties
      mwifiex: Add support for NL80211_ATTR_MAX_AP_ASSOC_STA

Pascal Terjan (2):
      libertas: Use shared constant for rfc1042 header
      atmel: Use shared constant for rfc1042 header

Ping-Ke Shih (3):
      rtw88: coex: 8723d: set antanna control owner
      rtw88: coex: 8723d: handle BT inquiry cases
      rtw88: fix EAPOL 4-way failure by finish IQK earlier

Pradeep Kumar Chitrapu (1):
      ath11k: fix htt stats module not handle multiple skbs

Rakesh Pillai (2):
      ath10k: Skip handling del_server during driver exit
      ath10k: Remove msdu from idr when management pkt send fails

Rui Salvaterra (1):
      rt2800: enable MFP support unconditionally

Ryder Lee (5):
      mt76: mt7915: add spatial reuse support
      mt76: mt7915: fix some sparse warnings
      mt76: mt7915: fix sparse warnings: incorrect type initializer
      mt76: mt7915: fix decoded radiotap HE flags
      mt76: mt7915: fix some sparse warnings

Sean Wang (1):
      mt76: mt7615: fix hw_scan with ssid_type for specified SSID only

Sergey Matyukevich (1):
      MAINTAINERS: update qtnfmac maintainers

Sharon (1):
      iwlwifi: mvm: fix aux station leak

Wei Yongjun (1):
      ath11k: convert to devm_platform_get_and_ioremap_resource

Wen Gong (1):
      ath10k: fix __le32 warning in ath10k_wmi_tlv_op_gen_request_peer_stats_info()

Wright Feng (2):
      brcmfmac: set F2 blocksize for 4373
      brcmfmac: fix 43455 CRC error under SDIO 3.0 SDR104 mode

Yan-Hsuan Chuang (2):
      Revert "rtw88: no need to set registers for SDIO"
      rtw88: 8822c: fix missing brace warning for old compilers

YueHaibing (2):
      mt76: mt7615: Use kmemdup in mt7615_queue_key_update()
      mt76: mt7915: remove set but not used variable 'msta'

 MAINTAINERS                                        |   2 +-
 drivers/net/wireless/ath/ath10k/Kconfig            |   7 +-
 drivers/net/wireless/ath/ath10k/ce.h               |   2 +-
 drivers/net/wireless/ath/ath10k/core.h             |   2 +-
 drivers/net/wireless/ath/ath10k/coredump.h         |   4 +-
 drivers/net/wireless/ath/ath10k/debug.h            |   2 +-
 drivers/net/wireless/ath/ath10k/htt.h              |  42 +++----
 drivers/net/wireless/ath/ath10k/hw.h               |   2 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   3 +
 drivers/net/wireless/ath/ath10k/pci.h              |   9 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |  13 ++-
 drivers/net/wireless/ath/ath10k/qmi.h              |   7 +-
 drivers/net/wireless/ath/ath10k/wmi-ops.h          |  10 ++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |  17 ++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |   6 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |  42 +++----
 drivers/net/wireless/ath/ath11k/ahb.c              |  59 +++++++---
 drivers/net/wireless/ath/ath11k/ahb.h              |  22 ----
 drivers/net/wireless/ath/ath11k/core.c             |  47 +++-----
 drivers/net/wireless/ath/ath11k/core.h             |  10 +-
 drivers/net/wireless/ath/ath11k/debug_htt_stats.c  |  48 ++++++--
 drivers/net/wireless/ath/ath11k/dp.c               |   1 +
 drivers/net/wireless/ath/ath11k/dp.h               |   1 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  11 +-
 drivers/net/wireless/ath/ath11k/hal.c              |  87 +++++++-------
 drivers/net/wireless/ath/ath11k/hal_desc.h         |   2 +
 drivers/net/wireless/ath/ath11k/hal_rx.c           |  22 ++--
 drivers/net/wireless/ath/ath11k/hal_tx.c           |  13 ++-
 drivers/net/wireless/ath/ath11k/hal_tx.h           |   1 +
 drivers/net/wireless/ath/ath11k/hif.h              |  65 +++++++++++
 drivers/net/wireless/ath/ath11k/htc.c              |   4 +-
 drivers/net/wireless/ath/ath11k/hw.h               |   5 +
 drivers/net/wireless/ath/ath11k/mac.c              |   6 +-
 drivers/net/wireless/ath/ath11k/thermal.c          |   6 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   2 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   3 +-
 drivers/net/wireless/ath/ath9k/init.c              |   2 +
 drivers/net/wireless/ath/ath9k/main.c              |   1 +
 drivers/net/wireless/ath/ath9k/recv.c              |   3 +-
 drivers/net/wireless/ath/carl9170/fwcmd.h          |   2 +-
 drivers/net/wireless/ath/carl9170/hw.h             |   2 +-
 drivers/net/wireless/ath/wcn36xx/hal.h             |   4 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   6 +-
 drivers/net/wireless/ath/wcn36xx/testmode.h        |   2 +-
 drivers/net/wireless/ath/wil6210/fw.h              |  16 +--
 drivers/net/wireless/ath/wil6210/wmi.c             |   2 +-
 drivers/net/wireless/ath/wil6210/wmi.h             |  58 +++++-----
 drivers/net/wireless/atmel/atmel.c                 |   3 +-
 drivers/net/wireless/broadcom/b43/main.c           |   2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  22 +++-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  58 ++++++++--
 drivers/net/wireless/cisco/airo.c                  |  12 ++
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  99 ++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |  22 ++++
 .../net/wireless/intel/iwlwifi/fw/api/location.h   |  14 +--
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |  34 +++++-
 .../wireless/intel/iwlwifi/iwl-context-info-gen3.h |  12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   5 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     | 128 +++++++++++++++++++++
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |  42 ++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  43 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  18 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   6 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |  10 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |   6 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 121 +------------------
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   6 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |  11 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  47 +++-----
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  70 ++++++-----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 120 ++++++++++---------
 drivers/net/wireless/marvell/libertas/rx.c         |   5 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   5 +
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |  29 ++++-
 drivers/net/wireless/marvell/mwifiex/fw.h          |  10 ++
 drivers/net/wireless/marvell/mwifiex/main.h        |   1 +
 drivers/net/wireless/mediatek/mt76/debugfs.c       |   2 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |   7 ++
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |  22 ++--
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  17 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   | 108 +++++++++++++----
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  66 +++++++++--
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |  25 +++-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |  19 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |   5 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   2 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  58 +++++-----
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  41 +++++--
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   1 +
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   2 +
 drivers/net/wireless/mediatek/mt76/util.c          |  12 +-
 drivers/net/wireless/mediatek/mt76/util.h          |  14 +--
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c     |   3 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |  21 +++-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   3 +-
 drivers/net/wireless/realtek/rtw88/main.c          |  17 +++
 drivers/net/wireless/realtek/rtw88/main.h          |   4 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |  50 +++++++-
 drivers/net/wireless/realtek/rtw88/rtw8723d.h      |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |  95 +++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  24 +++-
 drivers/net/wireless/st/cw1200/cw1200_sdio.c       |   9 +-
 drivers/net/wireless/ti/wlcore/main.c              |  33 +++---
 drivers/net/wireless/ti/wlcore/tx.c                |   1 +
 120 files changed, 1634 insertions(+), 743 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath11k/hif.h
