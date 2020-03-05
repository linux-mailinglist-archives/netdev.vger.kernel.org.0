Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F60317A815
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 15:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCEOtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 09:49:55 -0500
Received: from mail27.static.mailgun.info ([104.130.122.27]:64327 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726533AbgCEOty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 09:49:54 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583419792; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=xae2evbHpigYHji1dsEDUDE+LTdYB5hpfvCffUaCSTM=; b=pgm6Gc2TJKXzEFOKGQsifsjUnEueynMrXrqSv+wjqc+mBlhWX0gm5sEg8wpIx4AiiXZaDjUf
 qriSlNTqSSQHPJuozpnnij4MrhlzPaseZN9FQVYbpokgD+nFmj2suzW0uIv6dH9d+cu9q8tL
 8ASUqg5nabEf9wwb4YtS/+orW4A=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e611189.7f8e724971b8-smtp-out-n02;
 Thu, 05 Mar 2020 14:49:45 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EC8D5C433A2; Thu,  5 Mar 2020 14:49:44 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.6 required=2.0 tests=ALL_TRUSTED,FUZZY_XPILL,
        MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4268CC43383;
        Thu,  5 Mar 2020 14:49:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4268CC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2020-03-05
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20200305144944.EC8D5C433A2@smtp.codeaurora.org>
Date:   Thu,  5 Mar 2020 14:49:44 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit bb6d3fb354c5ee8d6bde2d576eb7220ea09862b9:

  Linux 5.6-rc1 (2020-02-09 16:08:48 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2020-03-05

for you to fetch changes up to 6065bb8a9c4004f339bd0976cdb8e30e5a07d5c9:

  Merge tag 'mt76-for-kvalo-2020-02-14' of https://github.com/nbd168/wireless (2020-03-03 17:35:57 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for v5.7

First set of patches for v5.7. Lots of mt76 patches as they missed the
v5.6 deadline and hence they were postponed to the next version.
Otherwise nothing special standing out.

mt76

Major changes:

* dual-band concurrent support for MT7615

* fixes for rx path race conditions

* coverage class support for MT7615

* beacon fixes for USB devices

* MT7615 LED support

* set_antenna support for MT7615

* tracing improvements

* preparation for supporting new USB devices

* tx power fixes

brcmfmac

* support BRCM 4364 found in MacBook Pro 15,2

----------------------------------------------------------------
Chien-Hsun Liao (1):
      rtw88: 8822c: modify rf protection setting

Dan Carpenter (1):
      rtw88: Use kfree_skb() instead of kfree()

Felix Fietkau (68):
      mt76: move initialization of some struct members to mt76_alloc_device
      mt76: introduce struct mt76_phy
      mt76: add support for an extra wiphy in the rx path
      mt76: add support for an extra wiphy in the main tx path
      mt76: add support for an extra wiphy in the tx status path
      mt76: add support for an extra wiphy in mt76_sta_state()
      mt76: move channel state to struct mt76_phy
      mt76: keep a set of software tx queues per phy
      mt76: move state from struct mt76_dev to mt76_phy
      mt76: move chainmask back to driver specific structs
      mt76: move txpower_conf back to driver specific structs
      mt76: move txpower and antenna mask to struct mt76_phy
      mt76: add multiple wiphy support to mt76_get_min_avg_rssi
      mt76: add priv pointer to struct mt76_phy
      mt76: add function for allocating an extra wiphy
      mt76: add ext_phy field to struct mt76_wcid
      mt76: move ampdu_ref from mt76_dev to driver struct
      mt76: mt7615: add dual-phy support for mac80211 ops
      mt76: mt7615: add multiple wiphy support for smart carrier sense
      mt76: mt7615: add missing register init for dual-wiphy support
      mt76: mt7615: remove useless MT_HW_RDD0/1 enum
      mt76: mt7615: add multiple wiphy support to the dfs support code
      mt76: mt7615: rework chainmask handling
      mt76: mt7615: add multiple wiphy support to the rx path
      mt76: mt7615: initialize dbdc settings on interface add
      mt76: mt7615: move radio/mac initialization to .start/stop callbacks
      mt76: mt7615: select the correct tx queue for frames sent to the second phy
      mt76: mt7615: add support for registering a second wiphy via debugfs
      mt76: mt7615: update beacon contents on BSS_CHANGED_BEACON
      mt76: mt7615: defer mcu initialization via workqueue
      mt7615: replace sta_state callback with sta_add/sta_remove
      mt76: fix rx dma ring descriptor state on reset
      mt76: disable bh in mt76_dma_rx_poll
      mt76: mt7615: measure channel noise and report it via survey
      mt76: mt7615: increase MCU command timeout
      mt76: mt7603: fix input validation issues for powersave-filtered frames
      mt76: clear skb pointers from rx aggregation reorder buffer during cleanup
      mt76: set dma-done flag for flushed descriptors
      mt76: fix handling full tx queues in mt76_dma_tx_queue_skb_raw
      mt76: dma: do not write cpu_idx on rx queue reset until after refill
      mt76: mt7603: increase dma mcu rx ring size
      mt76: enable Airtime Queue Limit support
      dt-bindings: net: wireless: mt76: document bindings for MT7622
      mt76: mt7615: add __aligned(4) to txp structs
      mt76: mt7615: move mmio related code from pci.c to mmio.c
      mt76: mt7615: split up firmware loading functions
      mt76: mt7615: store N9 firmware version instead of CR4
      mt76: mt7615: fix MT_INT_TX_DONE_ALL definition for MT7622
      mt76: mt7615: add dma and tx queue initialization for MT7622
      mt76: mt7615: add eeprom support for MT7622
      mt76: mt7615: add calibration free support for MT7622
      mt76: mt7615: disable 5 GHz on MT7622
      mt76: mt7615: implement probing and firmware loading on MT7622
      mt76: mt7615: implement DMA support for MT7622
      mt76: mt7615: decrease rx ring size for MT7622
      mt76: mt7615: disable DBDC on MT7622
      mt76: mt7615: add Kconfig entry for MT7622
      mt76: mt7615: fix and rework tx power handling
      mt76: mt7615: report firmware log event messages
      mt76: mt7615: implement hardware reset support
      mt76: mt7615: add support for testing hardware reset
      mt76: mt7615: fix adding active monitor interfaces
      mt76: mt7615: fix monitor mode on second PHY
      mt76: avoid extra RCU synchronization on station removal
      mt76: mt76x2: avoid starting the MAC too early
      mt76: fix rounding issues on converting per-chain and combined txpower
      mt76: mt7615: rework rx phy index handling
      mt76: do not set HOST_BROADCAST_PS_BUFFERING for mt7615

Ganapathi Bhat (1):
      mwifiex: change license text from MARVELL to NXP

Guenter Roeck (1):
      brcmfmac: abort and release host after error

H. Nikolaus Schaller (2):
      DTS: bindings: wl1251: mark ti,power-gpio as optional
      wl1251: remove ti,power-gpio for SDIO mode

Igor Mitsyanko (9):
      qtnfmac: use MAJOR.MINOR format for firmware protocol
      qtnfmac: pass hardware capabilities in TLV element
      qtnfmac: merge PHY_PARAMS_GET into MAC_INFO
      qtnfmac: drop QTN_TLV_ID_NUM_IFACE_COMB TLV type
      qtnfmac: implement extendable channel survey dump
      qtnfmac: pass max scan SSIDs limit on per-radio basis
      qtnfmac: cleanup alignment in firmware communication protocol
      qtnfmac: update channel switch command to support 6GHz band
      qtnfmac: drop unnecessary TLVs from scan command

Joe Perches (1):
      rtw88: 8822[bc]: Make tables const, reduce data object size

Kalle Valo (1):
      Merge tag 'mt76-for-kvalo-2020-02-14' of https://github.com/nbd168/wireless

Lorenzo Bianconi (42):
      mt76: mt7603: reset STA_CCA counter setting the channel
      mt76: eeprom: add support for big endian eeprom partition
      dt-bindings: net: wireless: mt76: introduce big-endian property
      mt76: mt7615: report firmware version using ethtool
      mt76: mt76x02: fix coverage_class type
      mt76: mt7603: set 0 as min coverage_class value
      mt76: mt7615: add set_coverage class support
      mt76: mt7615: introduce LED support
      mt76: mt76x02: simplify led reg definitions
      mt76: mt7603: simplify led reg definitions
      mt76: fix compilation warning in mt76_eeprom_override()
      mt76: move dev_irq tracepoint in mt76 module
      mt76: move mac_txdone tracepoint in mt76 module
      mt76: mt7615: add tracing support
      mt76: mt76x2: get rid of leftover target
      mt76: mt7615: initialize radar specs from host driver
      mt76: move WIPHY_FLAG_HAS_CHANNEL_SWITCH in mt76_phy_init
      mt76: mt7615: remove leftover routine declaration
      mt76: rely on mac80211 utility routines to compute airtime
      mt76: mt76x02u: avoid overwrite max_tx_fragments
      mt76: mt76u: check tx_status_data pointer in mt76u_tx_tasklet
      mt76: mt76u: add mt76u_process_rx_queue utility routine
      mt76: mt76u: add mt76_queue to mt76u_get_next_rx_entry signature
      mt76: mt76u: add mt76_queue to mt76u_refill_rx signature
      mt76: mt76u: use mt76_queue as mt76u_complete_rx context
      mt76: mt76u: add queue id parameter to mt76u_submit_rx_buffers
      mt76: mt76u: move mcu buffer allocation in mt76x02u drivers
      mt76: mt76u: introduce mt76u_free_rx_queue utility routine
      mt76: mt76u: stop/free all possible rx queues
      mt76: mt76u: add mt76u_alloc_rx_queue utility routine
      mt76: mt76u: add queue parameter to mt76u_rx_urb_alloc
      mt76: mt76u: resume all rx queue in mt76u_resume_rx
      mt76: mt76u: introduce mt76u_alloc_mcu_queue utility routine
      mt76: mt76u: add {read/write}_extended utility routines
      mt76: mt76u: take into account different queue mapping for 7663
      mt76: mt76u: introduce mt76u_skb_dma_info routine
      mt76: mt76u: add endpoint to mt76u_bulk_msg signature
      mt76: mt76u: introduce MT_DRV_RX_DMA_HDR flag
      mt76: mt7615: rely on mt76_queues_read for mt7622
      mt76: mt76u: rename stat_wq in wq
      mt76: mt7615: remove rx_mask in mt7615_eeprom_parse_hw_cap
      mt76: Introduce mt76_mcu data structure

Markus Theil (7):
      mt76: use AC specific reorder timeout
      mt76: mt76x02: omit beacon slot clearing
      mt76: mt76x02: split beaconing
      mt76: mt76x02: add check for invalid vif idx
      mt76: mt76x02: remove a copy call for usb speedup
      mt76: speed up usb bulk copy
      mt76: mt76x02: add channel switch support for usb interfaces

Martin Kepplinger (1):
      rsi: fix null pointer dereference during rsi_shutdown()

Pablo Greco (1):
      mt76: mt7615: Fix build with older compilers

Ping-Ke Shih (3):
      rtw88: move rtw_enter_ips() to the last when config
      rtw88: add ciphers to suppress error message
      rtw88: Use secondary channel offset enumeration

Ryder Lee (15):
      mt76: mt7615: fix MT7615_CFEND_RATE_DEFAULT value
      mt76: mt7615: add missing settings for simultaneous dual-band support
      mt76: mt7615: rework set_channel function
      mt76: mt7615: add set_antenna callback
      mt76: mt7615: report TSF information
      mt76: mt7615: add per-phy mib statistics
      mt76: mt7615: add a get_stats() callback
      mt76: mt7615: fix endianness in mt7615_mcu_set_eeprom
      mt76: mt7615: simplify mcu_set_bmc flow
      mt76: mt7615: simplify mcu_set_sta flow
      mt76: mt7615: add a helper to encapsulate sta_rec operation
      mt76: mt7615: add starec operating flow for firmware v2
      mt76: mt7615: use new tag sta_rec_wtbl
      mt76: mt7615: switch mt7615_mcu_set_tx_ba to v2 format
      mt76: mt7615: switch mt7615_mcu_set_rx_ba to v2 format

Sean Wang (1):
      mt76: mt76u: extend RX scatter gather number

Sergey Matyukevich (1):
      qtnfmac: fix potential Spectre vulnerabilities

Shayne Chen (2):
      mt76: do not overwrite max_tx_fragments if it has been set
      mt76: fix possible undetected invalid MAC address

Stanislaw Gruszka (3):
      mt76: usb: use max packet length for m76u_copy
      mt76: mt76x02u: do not set NULL beacons
      mt76: mt76x02: minor mt76x02_mac_set_beacon optimization

Tzu-En Huang (2):
      rtw88: 8822c: update power sequence to v16
      rtw88: Fix incorrect beamformee role setting

Yan-Hsuan Chuang (5):
      rtw88: remove unused parameter vif in rtw_lps_pg_info_get()
      rtw88: add rtw_read8_mask and rtw_read16_mask
      rtw88: pci: 8822c should set clock delay to zero
      rtw88: avoid holding mutex for cancel_delayed_work_sync()
      rtw88: disable TX-AMSDU on 2.4G band

brian m. carlson (1):
      brcmfmac: add the BRCM 4364 found in MacBook Pro 15,2

 .../bindings/net/wireless/mediatek,mt76.txt        |   29 +-
 .../devicetree/bindings/net/wireless/ti,wl1251.txt |    3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |    1 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    3 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |    2 +
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |    2 +
 drivers/net/wireless/marvell/mwifiex/11ac.c        |    8 +-
 drivers/net/wireless/marvell/mwifiex/11ac.h        |    8 +-
 drivers/net/wireless/marvell/mwifiex/11h.c         |    8 +-
 drivers/net/wireless/marvell/mwifiex/11n.c         |    8 +-
 drivers/net/wireless/marvell/mwifiex/11n.h         |    8 +-
 drivers/net/wireless/marvell/mwifiex/11n_aggr.c    |    8 +-
 drivers/net/wireless/marvell/mwifiex/11n_aggr.h    |    8 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |    8 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.h   |    8 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |    8 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.h    |    8 +-
 drivers/net/wireless/marvell/mwifiex/cfp.c         |    8 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |    8 +-
 drivers/net/wireless/marvell/mwifiex/debugfs.c     |    8 +-
 drivers/net/wireless/marvell/mwifiex/decl.h        |    8 +-
 drivers/net/wireless/marvell/mwifiex/ethtool.c     |    8 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |    8 +-
 drivers/net/wireless/marvell/mwifiex/ie.c          |    8 +-
 drivers/net/wireless/marvell/mwifiex/init.c        |    8 +-
 drivers/net/wireless/marvell/mwifiex/ioctl.h       |    8 +-
 drivers/net/wireless/marvell/mwifiex/join.c        |    8 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |    8 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |    8 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |    8 +-
 drivers/net/wireless/marvell/mwifiex/pcie.h        |    6 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |    8 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |    8 +-
 drivers/net/wireless/marvell/mwifiex/sdio.h        |    8 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |    8 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |    8 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |    8 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |    8 +-
 drivers/net/wireless/marvell/mwifiex/sta_rx.c      |    8 +-
 drivers/net/wireless/marvell/mwifiex/sta_tx.c      |    8 +-
 drivers/net/wireless/marvell/mwifiex/tdls.c        |    9 +-
 drivers/net/wireless/marvell/mwifiex/txrx.c        |    8 +-
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c     |    8 +-
 drivers/net/wireless/marvell/mwifiex/uap_event.c   |    8 +-
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c    |    8 +-
 drivers/net/wireless/marvell/mwifiex/usb.c         |    8 +-
 drivers/net/wireless/marvell/mwifiex/usb.h         |    6 +-
 drivers/net/wireless/marvell/mwifiex/util.c        |    8 +-
 drivers/net/wireless/marvell/mwifiex/util.h        |    8 +-
 drivers/net/wireless/marvell/mwifiex/wmm.c         |    8 +-
 drivers/net/wireless/marvell/mwifiex/wmm.h         |    8 +-
 drivers/net/wireless/mediatek/mt76/Makefile        |    2 +-
 drivers/net/wireless/mediatek/mt76/agg-rx.c        |   17 +-
 drivers/net/wireless/mediatek/mt76/airtime.c       |  326 ------
 drivers/net/wireless/mediatek/mt76/dma.c           |   49 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |   20 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  392 +++++---
 drivers/net/wireless/mediatek/mt76/mcu.c           |   12 +-
 drivers/net/wireless/mediatek/mt76/mmio.c          |    3 -
 drivers/net/wireless/mediatek/mt76/mt76.h          |  165 ++-
 drivers/net/wireless/mediatek/mt76/mt7603/core.c   |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |   21 +-
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |   22 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   39 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |   25 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    |   22 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |    7 +-
 drivers/net/wireless/mediatek/mt76/mt7603/regs.h   |   15 +-
 drivers/net/wireless/mediatek/mt76/mt7615/Kconfig  |   11 +
 drivers/net/wireless/mediatek/mt76/mt7615/Makefile |    7 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |  120 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |  178 +++-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |   38 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |  350 +++++--
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  991 ++++++++++++++----
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |   77 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  380 +++++--
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    | 1051 ++++++++++++--------
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |  126 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |  115 +++
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |  203 +++-
 .../wireless/mediatek/mt76/mt7615/mt7615_trace.h   |   56 ++
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |   98 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |  163 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/soc.c    |   77 ++
 drivers/net/wireless/mediatek/mt76/mt7615/trace.c  |   12 +
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |    4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |    6 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |    8 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |    9 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci_mcu.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |   32 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   31 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb_mcu.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |   13 +-
 .../net/wireless/mediatek/mt76/mt76x02_beacon.c    |   91 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c   |   14 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   43 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |    5 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c   |   10 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |   31 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c   |    4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.h   |    4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h  |   12 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_trace.h |   46 -
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c  |    7 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |   61 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |   34 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   28 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/Makefile |    2 -
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c |    4 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h |    2 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |    6 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_main.c   |   25 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_phy.c    |    8 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c    |   26 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |    4 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |   20 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_mac.c    |    2 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |   19 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_phy.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/trace.c         |    3 +
 drivers/net/wireless/mediatek/mt76/trace.h         |   54 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   85 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |  455 ++++++---
 drivers/net/wireless/mediatek/mt76/util.c          |    8 +-
 drivers/net/wireless/mediatek/mt76/util.h          |   14 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |   64 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |  651 ++++++------
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |    4 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c      |   47 +-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |   26 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c     |   67 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   |    2 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |  329 ++++--
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |   45 +-
 drivers/net/wireless/realtek/rtw88/bf.c            |    6 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |    3 +
 drivers/net/wireless/realtek/rtw88/fw.c            |   11 +-
 drivers/net/wireless/realtek/rtw88/hci.h           |   26 +
 drivers/net/wireless/realtek/rtw88/mac.c           |   25 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   37 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   19 +-
 drivers/net/wireless/realtek/rtw88/main.h          |   32 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |    9 +-
 drivers/net/wireless/realtek/rtw88/pci.h           |    1 +
 drivers/net/wireless/realtek/rtw88/phy.c           |   10 -
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |   30 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   50 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |    5 +
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |    9 +-
 drivers/net/wireless/ti/wl1251/sdio.c              |   32 +-
 156 files changed, 5267 insertions(+), 3114 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/airtime.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mt7615_trace.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/soc.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/trace.c
