Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039FA278EB7
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 18:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgIYQgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 12:36:39 -0400
Received: from z5.mailgun.us ([104.130.96.5]:13679 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728353AbgIYQgj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 12:36:39 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601051797; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=uq9wnPAJfAfz56eGzc10YGXZwPOCBmud0Ye7AtRy598=; b=K4fyXzPneZCQU6azh94ajMJuZdW6ftULjzILPFZ3q0SWdKifTXEVSFxN9vC2+LWTIaI05CZc
 7CRapBkK3vfpX/COnStVDSjaje8JxfZ7gVnLgWd9E2xj+nFwKfzE0ddCOfEQPd4k5GOmG2P5
 yH3eagrBainYnS+X+ANdZ8IW9eQ=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f6e1c851dcd99b9f29ce5ec (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 25 Sep 2020 16:36:21
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D90BDC433FF; Fri, 25 Sep 2020 16:36:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,TO_NO_BRKTS_PCNT autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C856FC433C8;
        Fri, 25 Sep 2020 16:36:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C856FC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2020-09-25
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20200925163621.D90BDC433FF@smtp.codeaurora.org>
Date:   Fri, 25 Sep 2020 16:36:21 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 5a6bd84f815485800699f55c78f690b2ed35f0c5:

  net: hns: use IRQ_NOAUTOEN to avoid irq is enabled due to request_irq (2020-09-11 17:40:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2020-09-25

for you to fetch changes up to bc8befe6f950264f2f4f6cbe267a3e934a15e26b:

  ath11k: fix undefined reference to 'ath11k_debugfs_htt_ext_stats_handler' (2020-09-25 19:09:48 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.10

Second set of patches for v5.10. Biggest change here is wcn3680
support to wcn36xx driver, otherwise smaller features. And naturally
the usual fixes and cleanups.

Major changes:

brcmfmac

* support 4-way handshake offloading for WPA/WPA2-PSK in AP mode

* support SAE authentication offload in AP mode

mt76

* mt7663 runtime power management improvements

* mt7915 A-MSDU offload

wcn36xx

* add support wcn3680 Wi-Fi 5 devices

ath11k

* spectral scan support for ipq6018

----------------------------------------------------------------
Andreas Färber (2):
      rtw88: Fix probe error handling race with firmware loading
      rtw88: Fix potential probe error handling race with wow firmware loading

Bo YU (1):
      ath11k: Add checked value for ath11k_ahb_remove

Brooke Basile (1):
      ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()

Bryan O'Donoghue (31):
      wcn36xx: Add VHT fields to parameter data structures
      wcn36xx: Use V1 data structure to store supported rates
      wcn36xx: Add wcn36xx_set_default_rates_v1
      wcn36xx: Add wcn36xx_smd_set_sta_default_vht_params()
      wcn36xx: Add wcn36xx_smd_set_sta_default_ht_ldpc_params()
      wcn36xx: Add wcn36xx_smd_set_sta_vht_params()
      wcn36xx: Add wcn36xx_smd_set_sta_ht_ldpc_params()
      wcn36xx: Add wcn36xx_smd_set_bss_vht_params()
      wcn36xx: Add wrapper function wcn36xx_smd_set_sta_params_v1()
      wcn36xx: Functionally decompose wcn36xx_smd_config_sta()
      wcn36xx: Move wcn36xx_smd_set_sta_params() inside wcn36xx_smd_config_bss()
      wcn36xx: Move BSS parameter setup to wcn36xx_smd_set_bss_params()
      wcn36xx: Update wcn36xx_smd_config_bss_v1() to operate internally
      wcn36xx: Add wcn36xx_smd_config_bss_v0
      wcn36xx: Convert to using wcn36xx_smd_config_bss_v0()
      wcn36xx: Remove dead code in wcn36xx_smd_config_bss()
      wcn36xx: Add accessor macro HW_VALUE_CHANNEL for hardware channels
      wcn36xx: Use HW_VALUE_CHANNEL macro to get channel number
      wcn36xx: Add accessor macro HW_VALUE_PHY for PHY settings
      wcn36xx: Encode PHY mode for 80MHz channel in hw_value
      wcn36xx: Set PHY into correct mode for 80MHz channel width
      wcn36xx: Extend HAL param config list
      wcn36xx: Define wcn3680 specific firmware parameters
      wcn36xx: Add ability to download wcn3680 specific firmware parameters
      wcn36xx: Latch VHT specific BSS parameters to firmware
      wcn36xx: Define INIT_HAL_MSG_V1()
      wcn36xx: Convert to VHT parameter structure on wcn3680
      wcn36xx: Add VHT rates to wcn36xx_update_allowed_rates()
      wcn36xx: Advertise ieee802.11 VHT flags
      wcn36xx: Mark internal smd functions static
      wcn36xx: Ensure spaces between functions

Chih-Min Chen (1):
      mt76: mt7915: fix unexpected firmware mode

Christophe JAILLET (1):
      airo: switch from 'pci_' to 'dma_' API

Chung-Hsien Hsu (2):
      brcmfmac: support 4-way handshake offloading for WPA/WPA2-PSK in AP mode
      brcmfmac: support SAE authentication offload in AP mode

Dan Carpenter (1):
      ath6kl: wmi: prevent a shift wrapping bug in ath6kl_wmi_delete_pstream_cmd()

Felix Fietkau (44):
      mt76: mt7915: fix crash on tx rate report for invalid stations
      mt76: fix double DMA unmap of the first buffer on 7615/7915
      mt76: set interrupt mask register to 0 before requesting irq
      mt76: mt7915: clean up and fix interrupt masking in the irq handler
      mt76: mt7615: only clear unmasked interrupts in irq tasklet
      mt76: mt76x02: clean up and fix interrupt masking in the irq handler
      mt76: mt7615: do not do any work in napi poll after calling napi_complete_done()
      mt76: mt7915: do not do any work in napi poll after calling napi_complete_done()
      mt76: mt7915: clean up station stats polling and rate control update
      mt76: mt7915: increase tx retry count
      mt76: mt7915: enable offloading of sequence number assignment
      mt76: move mt76_check_agg_ssn to driver tx_prepare calls
      mt76: mt7615: remove mtxq->agg_ssn assignment
      mt76: mt7915: simplify aggregation session check
      mt76: mt7915: add missing flags in WMM parameter settings
      mt76: mt7615: fix reading airtime statistics
      mt76: mt7915: optimize mt7915_mac_sta_poll
      mt76: dma: update q->queued immediately on cleanup
      mt76: mt7915: schedule tx tasklet in mt7915_mac_tx_free
      mt76: mt7915: significantly reduce interrupt load
      mt76: mt7615: significantly reduce interrupt load
      mt76: mt7915: add support for accessing mapped registers via bus ops
      mt76: add memory barrier to DMA queue kick
      mt76: mt7603: check for single-stream EEPROM configuration
      mt76: usb: fix use of q->head and q->tail
      mt76: sdio: fix use of q->head and q->tail
      mt76: unify queue tx cleanup code
      mt76: remove qid argument to drv->tx_complete_skb
      mt76: remove swq from struct mt76_sw_queue
      mt76: rely on AQL for burst size limits on tx queueing
      mt76: remove struct mt76_sw_queue
      mt76: mt7603: tune tx ring size
      mt76: mt76x02: tune tx ring size
      mt76: mt7615: fix MT_ANT_SWITCH_CON register definition
      mt76: mt7615: fix antenna selection for testmode tx_frames
      mt76: testmode: add a limit for queued tx_frames packets
      mt76: add utility functions for deferring work to a kernel thread
      mt76: convert from tx tasklet to tx worker thread
      mt76: mt7915: fix HE BSS info
      mt76: dma: cache dma map address/len in struct mt76_queue_entry
      mt76: mt7915: simplify mt7915_lmac_mapping
      mt76: mt7915: fix queue/tid mapping for airtime reporting
      mt76: move txwi handling code to dma.c, since it is mmio specific
      mt76: remove retry_q from struct mt76_txq and related code

Govind Singh (1):
      ath11k: Remove rproc references from common core layer

Gustavo A. R. Silva (1):
      mt76: Use fallthrough pseudo-keyword

Huang Guobin (1):
      net: wilc1000: clean up resource in error path of init mon interface

Ivan Safonov (1):
      rtw88: rtw8822c: eliminate code duplication, use native swap() function

Jason Yan (4):
      brcmsmac: main: Eliminate empty brcms_c_down_del_timer()
      rtlwifi: rtl8192ee: use true,false for bool variable large_cfo_hit
      rtlwifi: rtl8821ae: use true,false for bool variable large_cfo_hit
      rtlwifi: rtl8723be: use true,false for bool variable large_cfo_hit

Jing Xiangfeng (1):
      ssb: Remove meaningless jump label to simplify the code

Joe Perches (1):
      rtlwifi: Use ffs in <foo>_phy_calculate_bit_shift

Kalle Valo (9):
      ath11k: refactor debugfs code into debugfs.c
      ath11k: debugfs: use ath11k_debugfs_ prefix
      ath11k: rename debug_htt_stats.[c|h] to debugfs_htt_stats.[c|h]
      ath11k: debugfs: move some function declarations to correct header files
      ath11k: wmi: remove redundant configuration values from init
      ath11k: remove redundant num_keep_alive_pattern assignment
      Merge tag 'mt76-for-kvalo-2020-09-23' of https://github.com/nbd168/wireless
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      ath11k: fix undefined reference to 'ath11k_debugfs_htt_ext_stats_handler'

Karthikeyan Periyasamy (1):
      ath11k: Add support spectral scan for IPQ6018

Lee Jones (3):
      brcmsmac: phytbl_lcn: Remove unused array 'dot11lcn_gain_tbl_rev1'
      brcmsmac: phy_lcn: Remove unused variable 'lcnphy_rx_iqcomp_table_rev0'
      mt76: mt76x0: Move tables used only by init.c to their own header file

Liu Shixin (2):
      ath5k: convert to use DEFINE_SEQ_ATTRIBUTE macro
      mt76: mt7915: convert to use le16_add_cpu()

Lorenzo Bianconi (28):
      mt76: mt7615: move drv_own/fw_own in mt7615_mcu_ops
      mt76: mt7663s: move drv_own/fw_own in mt7615_mcu_ops
      mt76: mt7615: hold mt76 lock queueing wd in mt7615_queue_key_update
      mt76: do not inject packets if MT76_STATE_PM is set
      mt76: mt7615: reschedule runtime-pm receiving a tx interrupt
      mt76: mt76s: fix oom in mt76s_tx_queue_skb_raw
      mt76: mt76s: move tx processing in a dedicated wq
      mt76: mt7663s: move rx processing in txrx wq
      mt76: mt76s: move status processing in txrx wq
      mt76: mt76s: move tx/rx processing in 2 separate works
      mt76: mt76s: get rid of unused variable
      mt76: mt7615: release mutex in mt7615_reset_test_set
      mt76: mt7663s: use NULL instead of 0 in sdio code
      mt76: mt7615: fix possible memory leak in mt7615_tm_set_tx_power
      mt76: mt7615: fix a possible NULL pointer dereference in mt7615_pm_wake_work
      mt76: fix a possible NULL pointer dereference in mt76_testmode_dump
      mt76: mt7663u: fix dma header initialization
      mt76: mt7622: fix fw hang on mt7622
      mt76: mt7663s: do not use altx for ctl/mgmt traffic
      mt76: mt7663s: split mt7663s_tx_update_sched in mt7663s_tx_{pick,update}_quota
      mt76: mt7663s: introduce __mt7663s_xmit_queue routine
      mt76: move pad estimation out of mt76_skb_adjust_pad
      mt76: mt7663s: fix possible quota leak in mt7663s_refill_sched_quota
      mt76: mt7663s: introduce sdio tx aggregation
      mt76: mt7663: check isr read return value in mt7663s_rx_work
      mt76: mt7615: unlock dfs bands
      mt76: mt7915: fix possible memory leak in mt7915_mcu_add_beacon
      mt76: mt7663s: remove max_tx_fragments limitation

Qinglang Miao (3):
      mt7601u: Convert to DEFINE_SHOW_ATTRIBUTE
      zd1201: simplify the return expression of zd1201_set_maxassoc()
      mt76: Convert to DEFINE_SHOW_ATTRIBUTE

Rakesh Pillai (1):
      ath10k: Use bdf calibration variant for snoc targets

Ryder Lee (3):
      mt76: mt7915: enable U-APSD on AP side
      mt76: mt7915: add Tx A-MSDU offloading support
      mt76: mt7615: fix VHT LDPC capability

Sean Wang (2):
      mt76: mt7663s: fix resume failure
      mt76: mt7663s: fix unable to handle kernel paging request

Shayne Chen (2):
      mt76: mt7615: register ext_phy if DBDC is detected
      mt76: mt7915: add offchannel condition in switch channel command

Wang Hai (1):
      mt76: mt7615: Remove set but unused variable 'index'

Ye Bin (1):
      mt76: Fix unsigned expressions compared with zero

YueHaibing (4):
      wlcore: Remove unused macro WL1271_SUSPEND_SLEEP
      qtnfmac: Remove unused macro QTNF_DMP_MAX_LEN
      wlcore: Remove unused function no_write_handler()
      ath11k: Remove unused function ath11k_htc_restore_tx_skb()

Zhang Changzhong (1):
      brcmfmac: check return value of driver_for_each_device()

Zheng Bin (15):
      rtlwifi: rtl8188ee: fix comparison pointer to bool warning in phy.c
      rtlwifi: rtl8188ee: fix comparison pointer to bool warning in trx.c
      rtlwifi: rtl8188ee: fix comparison pointer to bool warning in hw.c
      rtlwifi: rtl8723ae: fix comparison pointer to bool warning in rf.c
      rtlwifi: rtl8723ae: fix comparison pointer to bool warning in trx.c
      rtlwifi: rtl8723ae: fix comparison pointer to bool warning in phy.c
      rtlwifi: rtl8192ee: fix comparison to bool warning in hw.c
      rtlwifi: rtl8192c: fix comparison to bool warning in phy_common.c
      rtlwifi: rtl8192cu: fix comparison to bool warning in mac.c
      rtlwifi: rtl8821ae: fix comparison to bool warning in hw.c
      rtlwifi: rtl8821ae: fix comparison to bool warning in phy.c
      rtlwifi: rtl8192cu: fix comparison to bool warning in hw.c
      rtlwifi: rtl8192ce: fix comparison to bool warning in hw.c
      rtlwifi: rtl8192de: fix comparison to bool warning in hw.c
      rtlwifi: rtl8723be: fix comparison to bool warning in hw.c

 drivers/net/wireless/ath/ath10k/core.c             |   18 +-
 drivers/net/wireless/ath/ath10k/core.h             |    2 +
 drivers/net/wireless/ath/ath10k/qmi.c              |    8 +
 drivers/net/wireless/ath/ath11k/Makefile           |    2 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |   49 +-
 drivers/net/wireless/ath/ath11k/ahb.h              |    8 +
 drivers/net/wireless/ath/ath11k/core.c             |   48 +-
 drivers/net/wireless/ath/ath11k/core.h             |    1 -
 drivers/net/wireless/ath/ath11k/debug.c            | 1108 +------------------
 drivers/net/wireless/ath/ath11k/debug.h            |  244 +----
 drivers/net/wireless/ath/ath11k/debugfs.c          | 1112 ++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/debugfs.h          |  217 ++++
 .../{debug_htt_stats.c => debugfs_htt_stats.c}     |   12 +-
 .../{debug_htt_stats.h => debugfs_htt_stats.h}     |   27 +-
 drivers/net/wireless/ath/ath11k/debugfs_sta.c      |   29 +-
 drivers/net/wireless/ath/ath11k/debugfs_sta.h      |   44 +
 drivers/net/wireless/ath/ath11k/dp.c               |    2 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   15 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |    7 +-
 drivers/net/wireless/ath/ath11k/htc.c              |    9 -
 drivers/net/wireless/ath/ath11k/hw.c               |    8 +-
 drivers/net/wireless/ath/ath11k/hw.h               |    1 +
 drivers/net/wireless/ath/ath11k/mac.c              |    9 +-
 drivers/net/wireless/ath/ath11k/spectral.c         |   26 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   51 +-
 drivers/net/wireless/ath/ath5k/debug.c             |   25 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |    5 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   19 +
 drivers/net/wireless/ath/wcn36xx/hal.h             |  138 ++-
 drivers/net/wireless/ath/wcn36xx/main.c            |   99 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |  663 ++++++++----
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |    9 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   49 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   14 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |    1 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |    4 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |    3 +
 .../wireless/broadcom/brcm80211/brcmsmac/main.c    |    9 -
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |   55 -
 .../broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c   |   99 --
 drivers/net/wireless/cisco/airo.c                  |   15 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c       |    9 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |  162 ++-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   43 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   61 +-
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |    8 +-
 .../net/wireless/mediatek/mt76/mt7603/debugfs.c    |   18 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |   26 +-
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c |   17 +-
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.h |    3 +
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |    5 -
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   25 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7603/pci.c    |    2 +
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c    |    2 +
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |   30 +-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |   55 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |    3 +
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   25 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   42 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   11 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  190 ++--
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |   25 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   21 +-
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |    7 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |    3 +
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c   |   38 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_mcu.c   |   22 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_txrx.c  |  282 +++--
 .../net/wireless/mediatek/mt76/mt7615/testmode.c   |   11 +-
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |    2 -
 .../net/wireless/mediatek/mt76/mt7615/usb_mcu.c    |    8 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |   29 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |    1 +
 .../net/wireless/mediatek/mt76/mt76x0/initvals.h   |  145 ---
 .../wireless/mediatek/mt76/mt76x0/initvals_init.h  |  159 +++
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |    4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |    2 +
 .../net/wireless/mediatek/mt76/mt76x02_debugfs.c   |   34 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c   |    6 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_dma.h   |    1 -
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |    3 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |   70 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_usb.h   |    3 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |   12 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |    5 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |    5 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |    2 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   11 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |  146 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   10 +
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  257 +++--
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   39 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  132 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   33 +
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   48 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |   30 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   17 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |  160 ++-
 drivers/net/wireless/mediatek/mt76/testmode.c      |   19 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |  330 +++---
 drivers/net/wireless/mediatek/mt76/usb.c           |   86 +-
 drivers/net/wireless/mediatek/mt76/util.c          |   28 +
 drivers/net/wireless/mediatek/mt76/util.h          |   76 ++
 drivers/net/wireless/mediatek/mt7601u/debugfs.c    |   34 +-
 drivers/net/wireless/microchip/wilc1000/mon.c      |    3 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c      |    1 -
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |   12 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.c   |   20 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |    4 +-
 .../wireless/realtek/rtlwifi/rtl8192c/phy_common.c |   10 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    |    8 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/mac.c   |    8 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |    8 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |    9 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/dm.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/phy.c   |    8 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/phy.c   |    9 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/phy.c   |    8 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/rf.c    |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/dm.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |    2 +-
 .../realtek/rtlwifi/rtl8723com/phy_common.c        |    8 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |   24 +-
 drivers/net/wireless/realtek/rtw88/main.c          |    5 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   15 +-
 drivers/net/wireless/ti/wlcore/debugfs.c           |    7 -
 drivers/net/wireless/ti/wlcore/main.c              |    1 -
 drivers/net/wireless/zydas/zd1201.c                |    6 +-
 drivers/ssb/pci.c                                  |    7 +-
 140 files changed, 4176 insertions(+), 3428 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath11k/debugfs.c
 create mode 100644 drivers/net/wireless/ath/ath11k/debugfs.h
 rename drivers/net/wireless/ath/ath11k/{debug_htt_stats.c => debugfs_htt_stats.c} (99%)
 rename drivers/net/wireless/ath/ath11k/{debug_htt_stats.h => debugfs_htt_stats.h} (98%)
 create mode 100644 drivers/net/wireless/ath/ath11k/debugfs_sta.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/initvals_init.h
