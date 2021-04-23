Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3713691B5
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242267AbhDWMDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:03:41 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:45517 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231472AbhDWMDk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 08:03:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619179384; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=nbgYqv4ESqd8ez6g2DTGa1l10ecLXF7Hwi4XID81/gY=; b=d+nVIHPcVyOr566Qp/9zdFX5i5n00g654veA0H9tMQQ3/A87ypuGEmLGGYzLAKG8FQB7ZnOH
 os4tZGabQXpqVLwX9FBNbPe9iSu9EwSs1GLBYPm9WDoz8U9FpPOBhiwCop3RpACixs+gIJV0
 +K/dV4+6jaL3CDZLNY7e3uAuZ/U=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 6082b76974f773a6642bdffa (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 23 Apr 2021 12:02:48
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 248EBC4338A; Fri, 23 Apr 2021 12:02:48 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9AD15C433D3;
        Fri, 23 Apr 2021 12:02:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9AD15C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2021-04-23
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210423120248.248EBC4338A@smtp.codeaurora.org>
Date:   Fri, 23 Apr 2021 12:02:48 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit a926c025d56bb1acd8a192fca0e307331ee91b30:

  net: wwan: mhi_wwan_ctrl: Fix RX buffer starvation (2021-04-20 17:13:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2021-04-23

for you to fetch changes up to 9382531ec63fc123d1d6ff07b0558b6af4ea724b:

  Merge tag 'mt76-for-kvalo-2021-04-21' of https://github.com/nbd168/wireless (2021-04-22 17:41:56 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.13

Third, and final, set of patches for v5.13. We got one more week
before the merge window and this includes from that extra week.
Smaller features to rtw88 and mt76, but mostly this contains fixes.

rtw88

* 8822c: Add gap-k calibration to improve long range performance

mt76

* parse rate power limits from DT

* debugfs file to test firmware crash

* debugfs to disable NAPI threaded mode

----------------------------------------------------------------
Anilkumar Kolli (1):
      ath11k: fix warning in ath11k_mhi_config

Christophe JAILLET (1):
      brcmfmac: Avoid GFP_ATOMIC when GFP_KERNEL is enough

Colin Ian King (3):
      mt76: mt7615: Fix a dereference of pointer sta before it is null checked
      ath11k: qmi: Fix spelling mistake "requeqst" -> "request"
      wlcore: Fix buffer overrun by snprintf due to incorrect buffer size

Dan Carpenter (3):
      mt76: mt7615: fix a precision vs width bug in printk
      mt76: mt7915: fix a precision vs width bug in printk
      mt76: mt7921: fix a precision vs width bug in printk

Felix Fietkau (6):
      mt76: flush tx status queue on DMA reset
      mt76: add functions for parsing rate power limits from DT
      mt76: mt7615: implement support for using DT rate power limits
      mt76: mt7615: fix hardware error recovery for mt7663
      mt76: mt7615: fix entering driver-own state on mt7663
      mt76: mt7615: load ROM patch before checking patch semaphore status

Guo-Feng Fan (4):
      rtw88: 8822c: reorder macro position according to the register number
      rtw88: 8822c: Add gap-k calibration to improve long range performance
      rtw88: 8822c: debug: allow debugfs to enable/disable TXGAPK
      rtw88: 8821c: Don't set RX_FLAG_DECRYPTED if packet has no encryption

Gustavo A. R. Silva (2):
      wl3501_cs: Fix out-of-bounds warnings in wl3501_send_pkt
      wl3501_cs: Fix out-of-bounds warnings in wl3501_mgmt_join

Kalle Valo (1):
      Merge tag 'mt76-for-kvalo-2021-04-21' of https://github.com/nbd168/wireless

Lee Gibson (1):
      qtnfmac: Fix possible buffer overflow in qtnf_event_handle_external_auth

Lorenzo Bianconi (43):
      mt76: mt7921: add mt7921_dma_cleanup in mt7921_unregister_device
      dt-bindings:net:wireless:mediatek,mt76: introduce power-limits node
      mt76: mt7615: do not use mt7615 single-sku values for mt7663
      mt76: introduce single-sku support for mt7663/mt7921
      mt76: mt7921: move hw configuration in mt7921_register_device
      mt76: improve mcu error logging
      mt76: mt7921: run mt7921_mcu_fw_log_2_host holding mt76 mutex
      mt76: mt7921: do not use 0 as NULL pointer
      mt76: connac: move mcu_update_arp_filter in mt76_connac module
      mt76: mt7921: remove leftover function declaration
      mt76: mt7921: fix a race between mt7921_mcu_drv_pmctrl and mt7921_mcu_fw_pmctrl
      mt76: mt7663: fix a race between mt7615_mcu_drv_pmctrl and mt7615_mcu_fw_pmctrl
      mt76: connac: introduce wake counter for fw_pmctrl synchronization
      mt76: mt7921: rely on mt76_connac_pm_ref/mt76_connac_pm_unref in tx path
      mt76: mt7663: rely on mt76_connac_pm_ref/mt76_connac_pm_unref in tx path
      mt76: dma: add the capability to define a custom rx napi poll routine
      mt76: mt7921: rely on mt76_connac_pm_ref/mt76_connac_pm_unref in tx/rx napi
      mt76: mt7663: rely on mt76_connac_pm_ref/mt76_connac_pm_unref in tx/rx napi
      mt76: connac: unschedule ps_work in mt76_connac_pm_wake
      mt76: connac: check wake refcount in mcu_fw_pmctrl
      mt76: connac: remove MT76_STATE_PM in mac_tx_free
      mt76: mt7921: get rid of useless MT76_STATE_PM in mt7921_mac_work
      mt76: connac: alaways wake the device before scanning
      mt76: mt7615: rely on pm refcounting in mt7615_led_set_config
      mt76: connac: do not run mt76_txq_schedule_all directly
      mt76: connac: use waitqueue for runtime-pm
      mt76: remove MT76_STATE_PM in tx path
      mt76: mt7921: add awake and doze time accounting
      mt76: mt7921: enable sw interrupts
      mt76: mt7921: move mt7921_dma_reset in dma.c
      mt76: mt7921: introduce mt7921_wpdma_reset utility routine
      mt76: mt7921: introduce mt7921_dma_{enable,disable} utilities
      mt76: mt7921: introduce mt7921_wpdma_reinit_cond utility routine
      mt76: move token_lock, token and token_count in mt76_dev
      mt76: move token utilities in mt76 common module
      mt76: mt7921: get rid of mcu_reset function pointer
      mt76: mt7921: improve doze opportunity
      mt76: mt7663: add awake and doze time accounting
      mt76: connac: unschedule mac_work before going to sleep
      mt76: mt7921: introduce mt7921_mcu_sta_add routine
      mt76: debugfs: introduce napi_threaded node
      mt76: move mt76_token_init in mt76_alloc_device
      mt76: mt7921: reinit wpdma during drv_own if necessary

Lv Yunlong (1):
      ath10k: Fix a use after free in ath10k_htc_send_bundle

Ping-Ke Shih (1):
      rtlwifi: implement set_tim by update beacon content

Po-Hao Huang (1):
      rtw88: refine napi deinit flow

Ryder Lee (6):
      mt76: mt7615: fix memleak when mt7615_unregister_device()
      mt76: mt7915: fix memleak when mt7915_unregister_device()
      mt76: mt7915: only free skbs after mt7915_dma_reset() when reset happens
      mt76: mt7615: only free skbs after mt7615_dma_reset() when reset happens
      mt76: mt7615: use ieee80211_free_txskb() in mt7615_tx_token_put()
      mt76: mt7915: add support for applying pre-calibration data

Sean Wang (7):
      mt76: mt7921: add dumping Tx power table
      mt76: mt7921: add wifisys reset support in debugfs
      mt76: mt7921: abort uncompleted scan by wifi reset
      mt76: connac: introduce mt76_connac_mcu_set_deep_sleep utility
      mt76: mt7921: enable deep sleep when the device suspends
      mt76: mt7921: fix possible invalid register access
      mt76: mt7921: mt7921_stop should put device in fw_own state

Shayne Chen (8):
      mt76: testmode: add support to send larger packet
      mt76: mt7915: rework mt7915_tm_set_tx_len()
      mt76: mt7915: fix rate setting of tx descriptor in testmode
      mt76: extend DT rate power limits to support 11ax devices
      mt76: mt7915: add support for DT rate power limits
      mt76: mt7915: rework the flow of txpower setting
      mt76: mt7915: directly read per-rate tx power from registers
      mt76: mt7915: do not read rf value from efuse in flash mode

Shuah Khan (1):
      ath10k: Fix ath10k_wmi_tlv_op_pull_peer_stats_info() unlock without lock

Toke Høiland-Jørgensen (1):
      ath9k: Fix error check in ath9k_hw_read_revisions() for PCI devices

Wan Jiabing (1):
      libertas_tf: Remove duplicate struct declaration

Yu-Yen Ting (1):
      rtw88: Fix potential unrecoverable tx queue stop

 .../bindings/net/wireless/mediatek,mt76.yaml       | 107 +++
 drivers/net/wireless/ath/ath10k/htc.c              |   2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   3 +
 drivers/net/wireless/ath/ath11k/mhi.c              |  15 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   2 +-
 drivers/net/wireless/ath/ath9k/hw.c                |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +-
 .../net/wireless/marvell/libertas_tf/libertas_tf.h |   1 -
 drivers/net/wireless/mediatek/mt76/debugfs.c       |  28 +
 drivers/net/wireless/mediatek/mt76/dma.c           |  10 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |   1 +
 drivers/net/wireless/mediatek/mt76/eeprom.c        | 231 ++++++-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   3 +
 drivers/net/wireless/mediatek/mt76/mcu.c           |   4 -
 drivers/net/wireless/mediatek/mt76/mt76.h          |  77 ++-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   2 +
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    |   5 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |  32 +-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |  47 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |  22 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  44 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  43 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    | 198 +++---
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |  24 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   7 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |  16 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |  23 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |  11 +
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |  54 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |  23 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   | 197 +++++-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |  37 ++
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c   |   5 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |   4 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |  78 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c | 165 ++---
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |  51 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  85 +--
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  95 +--
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   8 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    | 185 +++++-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   2 +
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |  19 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |  26 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   5 +
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |  22 +-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    | 144 +++-
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    | 240 +++++--
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |  36 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    | 193 ++----
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  62 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    | 126 ++--
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |  17 +
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |  60 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |  30 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |  17 +-
 drivers/net/wireless/mediatek/mt76/testmode.c      | 159 ++++-
 drivers/net/wireless/mediatek/mt76/testmode.h      |   2 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |  81 ++-
 drivers/net/wireless/quantenna/qtnfmac/event.c     |   6 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |  32 +
 drivers/net/wireless/realtek/rtlwifi/core.h        |   1 +
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   3 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   1 +
 drivers/net/wireless/realtek/rtw88/debug.c         |  91 +++
 drivers/net/wireless/realtek/rtw88/fw.c            |  12 +
 drivers/net/wireless/realtek/rtw88/fw.h            |   5 +
 drivers/net/wireless/realtek/rtw88/main.h          |  31 +
 drivers/net/wireless/realtek/rtw88/pci.c           |  29 +-
 drivers/net/wireless/realtek/rtw88/pci.h           |   1 +
 drivers/net/wireless/realtek/rtw88/reg.h           |   8 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |   3 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      | 724 ++++++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      | 336 ++++++----
 drivers/net/wireless/ti/wlcore/debugfs.h           |   2 +-
 drivers/net/wireless/wl3501.h                      |  47 +-
 drivers/net/wireless/wl3501_cs.c                   |  54 +-
 81 files changed, 3428 insertions(+), 1157 deletions(-)
