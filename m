Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37A9363454
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 10:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhDRI0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 04:26:48 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:53319 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhDRI0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 04:26:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618734380; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=FgbaDoGVPzLieicU8HrNnjSdfuxbhdYvUj+c8GIaKJk=; b=ogbioOBqBNOK6a5T57Y58puSDbe742C1qbJtkycXom8JvI58Ztzqve/8Gfg1bI9tDvUZUbvM
 aXHt+U72Xa2rEJNcneGdEZf2PtZqCQrTlB2XpIZAsQleY1ZiPpEz8k5QMokzd+ahQnQCxJWp
 KvrrY26tRoPdaVmpVGSlHH4zOEE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 607bed262cc44d3aea10d3ea (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 18 Apr 2021 08:26:14
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7DC5DC433F1; Sun, 18 Apr 2021 08:26:14 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E60DFC433D3;
        Sun, 18 Apr 2021 08:26:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E60DFC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2021-04-18
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210418082614.7DC5DC433F1@smtp.codeaurora.org>
Date:   Sun, 18 Apr 2021 08:26:14 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 3a1aa533f7f676aad68f8dbbbba10b9502903770:

  Merge tag 'linux-can-next-for-5.13-20210414' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next (2021-04-14 14:37:02 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2021-04-18

for you to fetch changes up to fb8517f4fade44fa5e42e29ca4d6e4a7ed50b512:

  rtw88: 8822c: add CFO tracking (2021-04-18 09:38:27 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.13

Second set of patches for v5.13. A lot of iwlwifi and mt76 patches
this time, and also smaller features and fixes all over.

mt76

* mt7915/mt7615 decapsulation offload support

* threaded NAPI support

* new device IDs

* mt7921 device reset support

* rx timestamp support

iwlwifi

* passive scan support for 6GHz

* new hardware support

wilc1000

* CRC support for SPI bus

----------------------------------------------------------------
Aditya Srivastava (1):
      rsi: fix comment syntax in file headers

Arnd Bergmann (3):
      libertas: avoid -Wempty-body warning
      wlcore: fix overlapping snprintf arguments in debugfs
      airo: work around stack usage warning

Avraham Stern (3):
      iwlwifi: mvm: support range request command version 12
      iwlwifi: mvm: responder: support responder config command version 8
      iwlwifi: mvm: when associated with PMF, use protected NDP ranging negotiation

Bhaskar Chowdhury (2):
      rtlwifi: Few mundane typo fixes
      brcmfmac: A typo fix

Brian Norris (1):
      mwifiex: don't print SSID to logs

Chen Lin (2):
      cw1200: Remove unused function pointer typedef cw1200_wsm_handler
      cw1200: Remove unused function pointer typedef wsm_*

Christophe JAILLET (4):
      rtlwifi: remove rtl_get_tid_h
      rtlwifi: Simplify locking of a skb list accesses
      rtl8xxxu: Simplify locking of a skb list accesses
      carl9170: remove get_tid_h

Colin Ian King (2):
      mt76: mt7921: remove redundant check on type
      rtlwifi: remove redundant assignment to variable err

Dan Carpenter (2):
      ipw2x00: potential buffer overflow in libipw_wx_set_encodeext()
      wilc1000: fix a loop timeout condition

David Bauer (1):
      mt76: mt76x0: disable GTK offloading

David Mosberger-Tang (5):
      wilc1000: Make SPI transfers work at 48MHz
      wilc1000: Introduce symbolic names for SPI protocol register
      wilc1000: Check for errors at end of DMA write
      wilc1000: Add support for enabling CRC
      wilc1000: Bring MAC address setting in line with typical Linux behavior

Emmanuel Grumbach (5):
      iwlwifi: mvm: don't allow CSA if we haven't been fully associated
      iwlwifi: remove TCM events
      iwlwifi: don't warn if we can't wait for empty tx queues
      iwlwifi: mvm: don't disconnect immediately if we don't hear beacons after CSA
      iwlwifi: mvm: don't WARN if we can't remove a time event

Eric Lin (1):
      wl3501: fix typo of 'Networks' in comment

Eric Y.Y. Wong (1):
      mt76: mt76x0u: Add support for TP-Link T2UHP(UN) v1

Felix Fietkau (15):
      mt76: add support for 802.3 rx frames
      mt76: mt7915: add rx checksum offload support
      mt76: mt7915: add support for rx decapsulation offload
      mt76: mt7615: fix key set/delete issues
      mt76: mt7615: fix tx skb dma unmap
      mt76: mt7915: fix tx skb dma unmap
      mt76: use threaded NAPI
      mt76: mt7915: fix key set/delete issue
      mt76: mt7915: refresh repeater entry MAC address when setting BSSID
      mt76: mt7615: fix chip reset on MT7622 and MT7663e
      mt76: mt7615: limit firmware log message printk to buffer length
      mt76: mt7915: limit firmware log message printk to buffer length
      mt76: fix potential DMA mapping leak
      mt76: mt7921: remove 80+80 MHz support capabilities
      mt76: mt7615: always add rx header translation tlv when adding stations

Guobin Huang (2):
      mt76: mt7615: remove redundant dev_err call in mt7622_wmac_probe()
      rtlwifi: rtl8192de: Use DEFINE_SPINLOCK() for spinlock

Gustavo A. R. Silva (1):
      rtl8xxxu: Fix fall-through warnings for Clang

Harish Mitty (1):
      iwlwifi: mvm: refactor ACPI DSM evaluation function

Ilan Peer (1):
      iwlwifi: mvm: Add support for 6GHz passive scan

Jiapeng Chong (3):
      mt76: mt7921: remove unneeded semicolon
      wil6210: wmi: Remove useless code
      bcma: remove unused function

Johannes Berg (11):
      iwlwifi: pcie: avoid unnecessarily taking spinlock
      iwlwifi: pcie: normally grab NIC access for inflight-hcmd
      iwlwifi: pcie: make cfg vs. trans_cfg more robust
      iwlwifi: mvm: write queue_sync_state only for sync
      iwlwifi: mvm: clean up queue sync implementation
      iwlwifi: remove remaining software checksum code
      iwlwifi: mvm: don't lock mutex in RCU critical section
      iwlwifi: warn on SKB free w/o op-mode
      iwlwifi: trans/pcie: defer transport initialisation
      iwlwifi: fw: print out trigger delay when collecting data
      iwlwifi: pcie: don't enable BHs with IRQs disabled

Kalle Valo (2):
      Merge tag 'mt76-for-kvalo-2021-04-12' of https://github.com/nbd168/wireless
      Merge tag 'iwlwifi-next-for-kalle-2021-04-12-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next

Lorenzo Bianconi (34):
      mt76: mt7915: enable hw rx-amsdu de-aggregation
      mt76: mt7921: enable random mac addr during scanning
      mt76: mt7921: removed unused definitions in mcu.h
      mt76: connac: always check return value from mt76_connac_mcu_alloc_wtbl_req
      mt76: mt7915: always check return value from mt7915_mcu_alloc_wtbl_req
      mt76: mt7615: fix memory leak in mt7615_coredump_work
      mt76: mt7921: fix aggr length histogram
      mt76: mt7915: fix aggr len debugfs node
      mt76: mt7921: fix stats register definitions
      mt76: mt7615: fix mib stats counter reporting to mac80211
      mt76: connac: fix kernel warning adding monitor interface
      mt76: check return value of mt76_txq_send_burst in mt76_txq_schedule_list
      mt76: mt7921: get rid of mt7921_sta_rc_update routine
      mt76: mt7921: check mcu returned values in mt7921_start
      mt76: mt7921: reduce mcu timeouts for suspend, offload and hif_ctrl msg
      mt76: introduce mcu_reset function pointer in mt76_mcu_ops structure
      mt76: mt7921: introduce mt7921_run_firmware utility routine.
      mt76: mt7921: introduce __mt7921_start utility routine
      mt76: dma: introduce mt76_dma_queue_reset routine
      mt76: dma: export mt76_dma_rx_cleanup routine
      mt76: mt7921: add wifi reset support
      mt76: mt7921: remove leftovers from dbdc configuration
      mt76: mt7921: remove duplicated macros in mcu.h
      mt76: mt7921: get rid of mt7921_mac_wtbl_lmac_addr
      mt76: connac: introduce mt76_sta_cmd_info data structure
      mt76: mt7921: properly configure rcpi adding a sta to the fw
      dt-bindings:net:wireless:ieee80211: txt to yaml conversion
      dt-bindings:net:wireless:mediatek,mt76: txt to yaml conversion
      mt76: mt7921: fix key set/delete issue
      mt76: mt7921: always wake the device in mt7921_remove_interface
      mt76: mt7921: rework mt7921_mcu_debug_msg_event routine
      mt76: mt7921: introduce MT_WFDMA_DUMMY_CR definition
      mt76: mt7921: introduce MCU_EVENT_LP_INFO event parsing
      mt76: mt7921: add rcu section in mt7921_mcu_tx_rate_report

Luca Coelho (1):
      iwlwifi: bump FW API to 63 for AX devices

Lv Yunlong (1):
      mwl8k: Fix a double Free in mwl8k_probe_hw

Marek Vasut (1):
      rsi: Use resume_noirq for SDIO

Matti Gottlieb (2):
      iwlwifi: pcie: Add support for Bz Family
      iwlwifi: pcie: Change ma product string name

Miri Korenblit (3):
      iwlwifi: mvm: enable PPAG in China
      iwlwifi: mvm: support BIOS enable/disable for 11ax in Ukraine
      iwlwifi: mvm: add support for version 3 of LARI_CONFIG_CHANGE command.

Mordechay Goodstein (7):
      iwlwifi: pcie: clear only FH bits handle in the interrupt
      iwlwifi: move iwl_configure_rxq to be used by other op_modes
      iwlwifi: queue: avoid memory leak in reset flow
      iwlwifi: mvm: remove PS from lower rates.
      iwlwifi: pcie: merge napi_poll_msix functions
      iwlwifi: pcie: add ISR debug info for msix debug
      iwlwifi: rs-fw: don't support stbc for HE 160

Mukesh Sisodiya (1):
      iwlwifi: dbg: disable ini debug in 9000 family and below

Nigel Christian (1):
      mt76: mt7921: remove unnecessary variable

Ping-Ke Shih (2):
      rtlwifi: 8821ae: upgrade PHY and RF parameters
      rtw88: Fix array overrun in rtw_get_tx_power_params()

Po-Hao Huang (2):
      rtw88: update statistics to fw for fine-tuning performance
      rtw88: 8822c: add CFO tracking

Ravi Darsi (1):
      iwlwifi: mvm: Use IWL_INFO in fw_reset_handshake()

Roee Goldfiner (1):
      iwlwifi: mvm: umac error table mismatch

Ryder Lee (32):
      mt76: always use WTBL_MAX_SIZE for tlv allocation
      mt76: use PCI_VENDOR_ID_MEDIATEK to avoid open coded
      mt76: mt7615: enable hw rx-amsdu de-aggregation
      mt76: mt7615: add rx checksum offload support
      mt76: mt7615: add support for rx decapsulation offload
      mt76: mt7615: fix TSF configuration
      mt76: mt7615: remove hdr->fw_ver check
      mt76: mt7915: fix mib stats counter reporting to mac80211
      mt76: mt7915: add missing capabilities for DBDC
      mt76: mt7615: fix CSA notification for DBDC
      mt76: mt7615: stop ext_phy queue when mac reset happens
      mt76: mt7915: fix CSA notification for DBDC
      mt76: mt7915: stop ext_phy queue when mac reset happens
      mt76: mt7915: fix PHY mode for DBDC
      mt76: mt7915: fix rxrate reporting
      mt76: mt7915: fix txrate reporting
      mt76: mt7915: check mcu returned values in mt7915_ops
      mt76: mt7615: check mcu returned values in mt7615_ops
      mt76: mt7615: add missing capabilities for DBDC
      mt76: mt7915: fix possible deadlock while mt7915_register_ext_phy()
      mt76: mt7615: only enable DFS test knobs for mt7615
      mt76: mt7615: cleanup mcu tx queue in mt7615_dma_reset()
      mt76: mt7622: trigger hif interrupt for system reset
      mt76: mt7615: keep mcu_add_bss_info enabled till interface removal
      mt76: mt7915: keep mcu_add_bss_info enabled till interface removal
      mt76: mt7915: cleanup mcu tx queue in mt7915_dma_reset()
      mt76: mt7615: fix .add_beacon_offload()
      mt76: mt7915: fix mt7915_mcu_add_beacon
      mt76: mt7915: add wifi subsystem reset
      mt76: report Rx timestamp
      mt76: mt7915: add mmio.c
      mt76: mt7615: add missing SPDX tag in mmio.c

Sander Vanheule (1):
      mt76: mt7615: support loading EEPROM for MT7613BE

Sara Sharon (1):
      iwlwifi: mvm: enable TX on new CSA channel before disconnecting

Sean Wang (17):
      mt76: mt7921: fix suspend/resume sequence
      mt76: mt7921: fix memory leak in mt7921_coredump_work
      mt76: mt7921: switch to new api for hardware beacon filter
      mt76: connac: fix up the setting for ht40 mode in mt76_connac_mcu_uni_add_bss
      mt76: mt7921: fixup rx bitrate statistics
      mt76: mt7921: add flush operation
      mt76: connac: update sched_scan cmd usage
      mt76: mt7921: fix the base of PCIe interrupt
      mt76: mt7921: fix the base of the dynamic remap
      mt76: mt7663: fix when beacon filter is being applied
      mt76: mt7663s: make all of packets 4-bytes aligned in sdio tx aggregation
      mt76: mt7663s: fix the possible device hang in high traffic
      mt76: mt7921: fix inappropriate WoW setup with the missing ARP informaiton
      mt76: mt7921: fix the dwell time control
      mt76: mt7921: fix kernel crash when the firmware fails to download
      mt76: mt7921: fix the insmod hangs
      mt76: mt7921: reduce the data latency during hw scan

Shayne Chen (1):
      mt76: mt7915: fix txpower init for TSSI off chips

Wan Jiabing (3):
      libertas: struct lbs_private is declared duplicately
      brcmfmac: Remove duplicate struct declaration
      wilc1000: Remove duplicate struct declaration

Yang Li (1):
      rtlwifi: rtl8188ee: remove redundant assignment of variable rtlpriv->btcoexist.reg_bt_sco

wengjianfeng (2):
      qtnfmac: remove meaningless labels
      qtnfmac: remove meaningless goto statement and labels

ybaruch (5):
      iwlwifi: change step in so-gf struct
      iwlwifi: change name to AX 211 and 411 family
      iwlwifi: add 160Mhz to killer 1550 name
      iwlwifi: add ax201 killer device
      iwlwifi: add new so-gf device

zuoqilin (1):
      mwifiex: Remove unneeded variable: "ret"

 .../devicetree/bindings/net/wireless/ieee80211.txt |  24 -
 .../bindings/net/wireless/ieee80211.yaml           |  45 ++
 .../bindings/net/wireless/mediatek,mt76.txt        |  78 ----
 .../bindings/net/wireless/mediatek,mt76.yaml       | 121 +++++
 drivers/bcma/driver_mips.c                         |   7 -
 drivers/net/wireless/ath/carl9170/carl9170.h       |   7 +-
 drivers/net/wireless/ath/carl9170/tx.c             |   2 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   |   1 -
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.h |   2 +-
 drivers/net/wireless/cisco/airo.c                  | 117 ++---
 drivers/net/wireless/intel/ipw2x00/libipw_wx.c     |   6 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  72 ++-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  78 +++-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |  13 +-
 .../net/wireless/intel/iwlwifi/fw/api/location.h   | 173 ++++++-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |  20 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |  22 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |  30 --
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |   8 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   3 +
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |   5 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |  59 +++
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   3 +
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h   |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |  91 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |  11 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  10 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |  85 +++-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |  27 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 232 +++-------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  59 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |  20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  58 +--
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 128 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |  38 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |  27 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  18 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  80 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   5 +
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  68 ++-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  29 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  80 ++--
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      |  41 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.h      |   3 +-
 drivers/net/wireless/marvell/libertas/decl.h       |   1 -
 drivers/net/wireless/marvell/libertas/mesh.h       |  12 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  11 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |   3 +-
 drivers/net/wireless/marvell/mwl8k.c               |   1 +
 drivers/net/wireless/mediatek/mt76/agg-rx.c        |  19 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |  55 ++-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  74 ++-
 drivers/net/wireless/mediatek/mt76/mcu.c           |   4 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |  24 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |   3 +
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |  33 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/pci.c    |   2 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |  29 +-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |  28 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |   1 +
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |  20 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    | 380 ++++++----------
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |   8 +
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   | 166 +++++--
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    | 103 ++++-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |  34 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |   3 +
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |  24 +-
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |   6 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |   1 +
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    | 168 +++++++
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |   9 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_txrx.c  |  11 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |   5 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  73 ++-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |  44 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   4 +
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/Makefile |   2 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    | 110 +----
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |  19 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   | 123 +++--
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    | 163 ++++---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |  15 +
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   | 124 +++--
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    | 248 ++++++----
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |  14 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   | 152 +++++++
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |  87 +---
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |  13 +
 drivers/net/wireless/mediatek/mt76/mt7921/Makefile |   4 +-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |   8 +-
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |  12 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    | 470 +++++++++++--------
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   | 208 +++++----
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    | 164 +++++--
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |  43 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |  29 +-
 .../wireless/mediatek/mt76/mt7921/mt7921_trace.h   |  51 +++
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |  24 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |  37 +-
 drivers/net/wireless/mediatek/mt76/mt7921/trace.c  |  12 +
 drivers/net/wireless/mediatek/mt76/sdio.c          |   3 +
 drivers/net/wireless/mediatek/mt76/tx.c            |  15 +-
 drivers/net/wireless/microchip/wilc1000/Kconfig    |   1 +
 drivers/net/wireless/microchip/wilc1000/netdev.c   |  25 +-
 drivers/net/wireless/microchip/wilc1000/spi.c      | 298 ++++++++----
 drivers/net/wireless/microchip/wilc1000/wlan.c     |   2 +-
 drivers/net/wireless/microchip/wilc1000/wlan.h     |   1 -
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  27 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |  67 ---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   1 -
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  19 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |  15 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |   2 -
 .../net/wireless/realtek/rtlwifi/rtl8192de/sw.c    |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.c | 500 +++++++++++++++------
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   1 -
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   8 +-
 drivers/net/wireless/realtek/rtw88/coex.h          |   8 +
 drivers/net/wireless/realtek/rtw88/debug.h         |   1 +
 drivers/net/wireless/realtek/rtw88/fw.c            |  15 +
 drivers/net/wireless/realtek/rtw88/fw.h            |  13 +
 drivers/net/wireless/realtek/rtw88/main.h          |  13 +
 drivers/net/wireless/realtek/rtw88/phy.c           |  72 ++-
 drivers/net/wireless/realtek/rtw88/phy.h           |   2 +
 drivers/net/wireless/realtek/rtw88/reg.h           |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      | 129 +++++-
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |   5 +
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |   2 +-
 drivers/net/wireless/rsi/rsi_boot_params.h         |   2 +-
 drivers/net/wireless/rsi/rsi_coex.h                |   2 +-
 drivers/net/wireless/rsi/rsi_common.h              |   2 +-
 drivers/net/wireless/rsi/rsi_debugfs.h             |   2 +-
 drivers/net/wireless/rsi/rsi_hal.h                 |   2 +-
 drivers/net/wireless/rsi/rsi_main.h                |   2 +-
 drivers/net/wireless/rsi/rsi_mgmt.h                |   2 +-
 drivers/net/wireless/rsi/rsi_ps.h                  |   2 +-
 drivers/net/wireless/rsi/rsi_sdio.h                |   2 +-
 drivers/net/wireless/rsi/rsi_usb.h                 |   2 +-
 drivers/net/wireless/st/cw1200/bh.c                |   3 -
 drivers/net/wireless/st/cw1200/wsm.h               |  12 -
 drivers/net/wireless/ti/wlcore/boot.c              |  13 +-
 drivers/net/wireless/ti/wlcore/debugfs.h           |   7 +-
 drivers/net/wireless/wl3501.h                      |   2 +-
 170 files changed, 4533 insertions(+), 2421 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/wireless/ieee80211.txt
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ieee80211.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
 create mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/mt7921_trace.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/trace.c
