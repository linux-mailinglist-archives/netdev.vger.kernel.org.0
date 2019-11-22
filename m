Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10A41107774
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 19:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfKVSis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 13:38:48 -0500
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:46678
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726698AbfKVSis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 13:38:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574447926;
        h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=CUuuBguwJS96jzR/TTDgPovrRxvrsecBoAet3uXBD5s=;
        b=nqzPfnRJyoxUwiAi/Y5hxEoeL5Iwm0mC9NgC0Nmc99T/864hh3MZOLtUj/SY7ioV
        D5DJdAzAzGvSgROHsh4VziTb1KEmi5g9szc1SL0iQfnGJbzfNHQZw4mSTk+6bQmvICk
        Hnx/0YeXtMXkdzsNxx1hChB5mAdTzeHcRRroPqag=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574447926;
        h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=CUuuBguwJS96jzR/TTDgPovrRxvrsecBoAet3uXBD5s=;
        b=JJFzPsTL4r2/FSp4lL7XyIo8EQ6PM8HUtmJv6nkC1LPi6X7JfKb+NKp9qzeuZM01
        7vL2iTYNxMHwFTxU8+K+cICcTay8pKO7qGR2p38kIyeNYJKTEnEKbKkkvB0SAVjByRi
        3RLc7gAD3gV/U0+Pb9SmcTkklP34O+m5ZCHgMchA=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D898DC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-drivers-next-2019-11-22
Date:   Fri, 22 Nov 2019 18:38:46 +0000
Message-ID: <0101016e9468c9df-b9fff56f-0e3f-48d1-bcff-e6586926e7b6-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SES-Outgoing: 2019.11.22-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know=
 if
there are any problems.

Kalle

The following changes since commit 19b7e21c55c81713c4011278143006af9f232504:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2019-11-1=
6 21:51:42 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-2019-11-22

for you to fetch changes up to 05d6c8cfdbd6cefac6b373bad72775fcc4193c80:

  mt76: fix fix ampdu locking (2019-11-21 20:38:30 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for v5.5

Last set of patches for v5.5. Major features here 802.11ax support for
qtnfmac and airtime fairness support to mt76. And naturally smaller
fixes and improvements all over.

Major changes:

qtnfmac

* add 802.11ax support in AP mode

* enable offload bridging support

iwlwifi

* support TX/RX antennas reporting

mt76

* mt7615 smart carrier sense support

* aggregation statistics via debugfs

* airtime fairness (ATF) support

* mt76x0 OF mac address support

----------------------------------------------------------------
Ben Greear (1):
      iwlwifi: mvm: Report tx/rx antennas

Colin Ian King (1):
      mt76: mt76x0e: make array mt76x0_chan_map static const, makes object =
smaller

Denis Efremov (1):
      iwlwifi: dvm: excessive if in rs_bt_update_lq()

Felix Fietkau (22):
      mt76: mt7615: fix control frame rx in monitor mode
      mt76: remove aggr_work field from struct mt76_wcid
      mt76: use cancel_delayed_work_sync in mt76_rx_aggr_shutdown
      mt76: mt7603: remove q_rx field from struct mt7603_dev
      mt76: report rx a-mpdu subframe status
      mt76: rename mt76_driver_ops txwi_flags to drv_flags and include tx a=
ligned4
      mt76: store current channel survey_state in struct mt76_dev
      mt76: track rx airtime for airtime fairness and survey
      mt76: mt7603: track tx airtime for airtime fairness and survey
      mt76: mt7603: switch to a different counter for survey busy time
      mt76: unify channel survey update code
      mt76: mt76x02: move MT_CH_TIME_CFG init to mt76x02_mac_cc_reset
      mt76: mt76x02: track approximate tx airtime for airtime fairness and =
survey
      mt76: mt7615: fix survey channel busy time
      mt76: enable airtime fairness
      mt76: do not use devm API for led classdev
      mt76: add missing locking around ampdu action
      mt76: drop rcu read lock in mt76_rx_aggr_stop
      mt76: fix aggregation stop issue
      mt76: avoid enabling interrupt if NAPI poll is still pending
      mt76: add sanity check for a-mpdu rx wcid index
      mt76: remove obsolete .add_buf() from struct mt76_queue_ops

Igor Mitsyanko (5):
      qtnfmac: remove VIF in firmware in case of error
      qtnfmac: track broadcast domain of each interface
      qtnfmac: add interface ID to each packet
      qtnfmac: advertise netdev port parent ID
      qtnfmac: signal that all packets coming from device are already flood=
ed

Johannes Berg (8):
      iwlwifi: pcie: fix support for transmitting SKBs with fraglist
      iwlwifi: pcie: make some RX functions static
      iwlwifi: config: remove max_rx_agg_size
      iwlwifi: mvm: remove left-over non-functional email alias
      iwlwifi: pcie: rx: use rxq queue_size instead of constant
      iwlwifi: pcie: trace IOVA for iwlwifi_dev_tx_tb
      iwlwifi: mvm: remove outdated comment referring to wake lock
      iwlwifi: check kasprintf() return value

Kalle Valo (2):
      Merge tag 'iwlwifi-next-for-kalle-2019-11-20' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next
      Merge tag 'mt76-for-kvalo-2019-11-20' of https://github.com/nbd168/wi=
reless

Lorenzo Bianconi (29):
      mt76: remove empty flag in mt76_txq_schedule_list
      mt76: usb: add lockdep_assert_held in __mt76u_vendor_request
      mt76: mt7615: enable SCS by default
      mt76: mt76x02: move mac_reset_counter in mt76x02_lib module
      mt76: mt76x2: move mt76x02_mac_reset_counters in mt76x02_mac_start
      mt76: mt76x0u: reset counter starting the device
      mt76: mt76x02u: move mt76x02u_mac_start in mt76x02-usb module
      mt76: move queue debugfs entry to driver specific code
      mt76: mt7615: add queue entry in debugfs
      mt76: move aggr_stats array in mt76_dev
      mt76: mt7615: collect aggregation stats
      mt76: mt7603: collect aggregation stats
      mt76: mt7615: report tx_time, bss_rx and busy time to mac80211
      mt76: mt7615: introduce mt7615_mac_wtbl_update routine
      mt76: mt7615: track tx/rx airtime for airtime fairness
      mt76: refactor cc_lock locking scheme
      mt76: mt76x02u: update ewma pkt len in mt76x02u_tx_prepare_skb
      mt76: mt76x0: remove 350ms delay in mt76x0_phy_calibrate
      mt76: mt76u: rely on usb_interface instead of usb_dev
      mt76: mt76u: rely on a dedicated stats workqueue
      mt76: use mt76_dev in mt76_is_{mmio,usb}
      mt76: move SUPPORTS_REORDERING_BUFFER hw property in mt76_register_de=
vice
      mt76: mt7615: add ibss support
      mt76: move interface_modes definition in mt76_core module
      mt76: mt7615: disable radar pattern detector during scanning
      mt76: fix possible out-of-bound access in mt7615_fill_txs/mt7603_fill=
_txs
      mt76: move mt76_get_antenna in mt76_core module
      mt76: mt7615: read {tx,rx} mask from eeprom
      mt76: mt76u: fix endpoint definition order

Luca Coelho (1):
      iwlwifi: bump FW API to 52 for 22000 series

Markus Theil (1):
      mt76: fix fix ampdu locking

Mikhail Karpenko (2):
      qtnfmac: add TLV for extension IEs
      qtnfmac: process HE capabilities requests

Pawel Dembicki (1):
      mt76: mt76x0: eeprom: add support for MAC address from OF

Ping-Ke Shih (2):
      rtlwifi: rf_lock use non-irqsave spin_lock
      rtlwifi: set proper udelay within rf_serial_read

Rafa=C5=82 Mi=C5=82ecki (2):
      brcmfmac: disable PCIe interrupts before bus reset
      brcmfmac: remove monitor interface when detaching

Stanislaw Gruszka (1):
      Revert "mt76: mt76x0e: don't use hw encryption for MT7630E"

Tova Mussai (1):
      iwlwifi: scan: support scan req FW API ver 13

Yan-Hsuan Chuang (4):
      rtw88: pci: use macros to access PCI DBI/MDIO registers
      rtw88: pci: use for loop instead of while loop for DBI/MDIO
      rtw88: pci: enable CLKREQ function if host supports it
      rtw88: allows to enable/disable HCI link PS mechanism

YueHaibing (1):
      mt76: mt7615: remove unneeded semicolon

zhengbin (5):
      brcmfmac: remove set but not used variable 'mpnum','nsp','nmp'
      ipw2x00: remove set but not used variable 'reason'
      ipw2x00: remove set but not used variable 'force_update'
      rtl8xxxu: Remove set but not used variable 'vif','dev','len'
      mt76: Remove set but not used variable 'idx'

 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |   6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   5 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   2 +
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |   3 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |   3 -
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/led.c       |   3 +
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |  56 +++-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   2 -
 .../net/wireless/intel/iwlwifi/iwl-devtrace-data.h |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/led.c       |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  13 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |   2 -
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  54 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   2 -
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  28 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  14 +-
 drivers/net/wireless/mediatek/mt76/Makefile        |   2 +-
 drivers/net/wireless/mediatek/mt76/agg-rx.c        |  20 +-
 drivers/net/wireless/mediatek/mt76/airtime.c       | 326 +++++++++++++++++=
++++
 drivers/net/wireless/mediatek/mt76/debugfs.c       |   5 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |  11 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      | 194 +++++++++++-
 drivers/net/wireless/mediatek/mt76/mt76.h          | 113 +++----
 .../net/wireless/mediatek/mt76/mt7603/debugfs.c    |  38 +++
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |   2 +
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |  14 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    | 141 +++++++--
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |  25 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |  11 +-
 drivers/net/wireless/mediatek/mt76/mt7603/regs.h   |   5 +
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    | 100 +++++++
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |   2 +
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |  18 ++
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h |   3 +
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |  43 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    | 187 ++++++++++--
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  52 +++-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  16 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |  11 +
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |  57 +++-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |  27 --
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |   9 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |  29 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |  13 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  16 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |   3 +-
 .../net/wireless/mediatek/mt76/mt76x02_debugfs.c   |   5 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 119 ++++++--
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |   8 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c  |  10 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_usb.h   |   1 +
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |  31 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |  24 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mac.h    |   1 -
 .../net/wireless/mediatek/mt76/mt76x2/mt76x2u.h    |   1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |   4 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |  30 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_main.c   |  26 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   6 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |   7 -
 .../net/wireless/mediatek/mt76/mt76x2/usb_mac.c    |  27 --
 .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |   9 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |  23 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |  44 ++-
 drivers/net/wireless/quantenna/qtnfmac/bus.h       |  23 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  17 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 127 +++++++-
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |   1 +
 drivers/net/wireless/quantenna/qtnfmac/core.c      | 128 ++++++--
 drivers/net/wireless/quantenna/qtnfmac/core.h      |   2 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   |  47 ++-
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   |   5 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |  76 +++++
 drivers/net/wireless/quantenna/qtnfmac/switchdev.h |  24 ++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   6 -
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.c   |  14 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/phy.c   |  13 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/phy.c   |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/phy.c   |  10 +-
 .../realtek/rtlwifi/rtl8723com/phy_common.c        |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |  10 +-
 drivers/net/wireless/realtek/rtw88/hci.h           |   6 +
 drivers/net/wireless/realtek/rtw88/pci.c           | 155 ++++++++--
 drivers/net/wireless/realtek/rtw88/pci.h           |  16 +
 drivers/net/wireless/realtek/rtw88/ps.c            |   6 +
 96 files changed, 2252 insertions(+), 562 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/airtime.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/switchdev.h
