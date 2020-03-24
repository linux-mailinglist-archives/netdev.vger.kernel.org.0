Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF8AF19085B
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 09:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgCXIyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 04:54:55 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:10678 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726524AbgCXIyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 04:54:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585040094; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=pgdNyVK6ArWU823vTo3eLN8uAU8wWyDX0LomewTnjQY=; b=T8dryAVSSlE/dQICWkDY+IKP1xECmQbhY3wJXYxzanw+fNh9vgE0DOI60JnXDUMQnBcGH2mL
 Grsrq2CM+EwEtlYaJf5JE2Ej0uK/Eb0+6mym6vBp0HAi+FX8PZC3Mm+m0qj6VEt3SpuH73Wk
 qprIlTeOvXWcyFE5UkC0bA8lHIM=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e79cacf.7f7fec6b1298-smtp-out-n02;
 Tue, 24 Mar 2020 08:54:39 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 45DC7C432C2; Tue, 24 Mar 2020 08:54:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B5121C433CB;
        Tue, 24 Mar 2020 08:54:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B5121C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2020-03-24
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20200324085438.45DC7C432C2@smtp.codeaurora.org>
Date:   Tue, 24 Mar 2020 08:54:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit e6e0f093d97872353bda8922456064dbcf5d82a2:

  dt-bindings: soc: qcom: fix IPA binding (2020-03-12 00:05:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2020-03-24

for you to fetch changes up to 8d4ccd7770e795e03c217624507ce17b5ab1c156:

  rtl8xxxu: Fix sparse warning: cast from restricted __le16 (2020-03-23 19:35:20 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for v5.7

Second set of patches for v5.7. Lots of cleanup patches this time, but
of course various new features as well fixes.

When merging with wireless-drivers this pull request has a conflict in:

drivers/net/wireless/intel/iwlwifi/pcie/drv.c

To solve that just drop the changes from commit cf52c8a776d1 in
wireless-drivers and take the hunk from wireless-drivers-next as is.
The list of specific subsystem device IDs are not necessary after
commit d6f2134a3831 (in wireless-drivers-next) anymore, the detection
is based on other characteristics of the devices.

Major changes:

qtnfmac

* support WPA3 SAE and OWE in AP mode

ath10k

* support for getting btcoex settings from Device Tree

* support QCA9377 SDIO device

ath11k

* add HE rate accounting

* add thermal sensor and cooling devices

mt76

* MT7663 support for the MT7615 driver

----------------------------------------------------------------
Anilkumar Kolli (1):
      ath11k: fix parsing PPDU_CTRL type in pktlog

Brian Norris (2):
      mwifiex: set needed_headroom, not hard_header_len
      rtw88: don't hold all IRQs disabled for PS operations

Chen Wandun (1):
      mt76: remove variable 'val' set but not used

Chris Chiu (1):
      rtl8xxxu: Fix sparse warning: cast from restricted __le16

Dan Carpenter (1):
      mt76: mt7615: remove a stray if statement

Dmitry Lebed (1):
      qtnfmac: add interface combination check for repeater mode

Erik Stromdahl (1):
      ath10k: add QCA9377 sdio hw_param item

Felix Fietkau (5):
      mt76: mt7615: fix antenna mask initialization in DBDC mode
      mt76: mt7603: add upper limit for dynamic sensitivity minimum receive power
      mt76: mt7603: make dynamic sensitivity adjustment configurable via debugfs
      mt76: mt7615: fix monitor injection of beacon frames
      mt76: mt76x02: reset MCU timeout counter earlier in watchdog reset

Govindaraj Saminathan (1):
      ath11k: config reorder queue for all tids during peer setup

Gustavo A. R. Silva (14):
      wireless: realtek: Replace zero-length array with flexible-array member
      wireless: ti: Replace zero-length array with flexible-array member
      hostap: Replace zero-length array with flexible-array member
      orinoco: Replace zero-length array with flexible-array member
      libertas: Replace zero-length array with flexible-array member
      p54: Replace zero-length array with flexible-array member
      wireless: marvell: Replace zero-length array with flexible-array member
      brcmfmac: Replace zero-length array with flexible-array member
      zd1211rw: Replace zero-length array with flexible-array member
      cw1200: Replace zero-length array with flexible-array member
      adm80211: Replace zero-length array with flexible-array member
      atmel: at76c50x: Replace zero-length array with flexible-array member
      ray_cs: Replace zero-length array with flexible-array member
      wl3501_cs: Replace zero-length array with flexible-array member

John Crispin (2):
      ath11k: drop tx_info from ath11k_sta
      ath11k: add HE rate accounting to driver

Kalle Valo (4):
      ath10k: fix few checkpatch warnings
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge tag 'mt76-for-kvalo-2020-03-17' of https://github.com/nbd168/wireless
      Merge tag 'iwlwifi-next-for-kalle-2020-03-17' of git://git.kernel.org/.../iwlwifi/iwlwifi-next

Karthikeyan Periyasamy (2):
      ath11k: fix rcu lock protect in peer assoc confirmation
      ath11k: fix warn-on in disassociation

Kevin Lo (1):
      rtw88: remove unused member of struct rtw_hal

Krzysztof Kozlowski (1):
      ath5k: Add proper dependency for ATH5K_AHB

Lorenzo Bianconi (30):
      mt76: mt76u: loop over all possible rx queues in mt76u_rx_tasklet
      mt76: mt76u: fix a possible memory leak in mt76u_init
      mt76: mt76u: rely only on data buffer for usb control messagges
      mt76: mt7615: introduce mt7615_mcu_fill_msg
      mt76: mt7615: introduce mt7615_mcu_wait_response
      mt76: mt7615: cleanup fw queue just for mmio devices
      mt76: mt7615: introduce mt7615_init_device routine
      mt76: always init to 0 mcu messages
      mt76: mt7615: introduce mt7615_mcu_send_message routine
      mt76: mt7615: add mt7615_mcu_ops data structure
      mt76: mt7615: move mt7615_mcu_set_bmc to mt7615_mcu_ops
      mt76: mt7615: move mt7615_mcu_set_sta in mt7615_mcu_ops
      mt76: mt7615: rely on skb API for mt7615_mcu_set_eeprom
      mt76: mt7615: rework mt7615_mcu_set_bss_info using skb APIs
      mt76: mt7615: move more mcu commands in mt7615_mcu_ops data structure
      mt76: mt7615: introduce MCU_FW_PREFIX for fw mcu commands
      mt76: mt7615: introduce mt7615_register_map
      mt76: mt7615: add mt7663e support to mt7615_reg_map
      mt76: mt7615: add mt7663e support to mt7615_{driver,firmware}_own
      mt76: mt7615: add mt7663e support to mt7615_mcu_set_eeprom
      mt76: mt7615: introduce mt7615_eeprom_parse_hw_band_cap routine
      mt76: mt7615: introduce mt7615_init_mac_chain routine
      mt76: mt7615: introduce uni cmd command types
      mt76: mt7615: introduce set_bmc and st_sta for uni commands
      mt76: mt7615: introduce set_ba uni command
      mt76: mt7615: get rid of sta_rec_wtbl data structure
      mt76: mt7615: introduce mt7663e support
      mt76: mt7615: fix mt7663e firmware struct endianness
      mt76: mt7615: fix endianness in unified command
      mt76: mt7615: add missing declaration in mt7615.h

Luca Coelho (13):
      iwlwifi: move the remaining 0x2526 configs to the new table
      iwlwifi: combine 9260 cfgs that only change names
      iwlwifi: add mac/rf types and 160MHz to the device tables
      iwlwifi: add GNSS differentiation to the device tables
      iwlwifi: add Pu/PnJ/Th device values to differentiate them
      iwlwifi: map 9461 and 9462 using RF type and RF ID
      iwlwifi: move TH1 devices to the new table
      iwlwifi: convert the 9260-1x1 device to use the new parameters
      iwlwifi: remove 9260 devices with 0x1010 and 0x1210 subsytem IDs
      iwlwifi: move pu devices to new table
      iwlwifi: move shared clock entries to new table
      iwlwifi: remove trans entries from COMMON 9260 macro
      iwlwifi: move AX200 devices to the new table

Nathan Chancellor (1):
      ath11k: Silence clang -Wsometimes-uninitialized in ath11k_update_per_peer_stats_from_txcompl

Pradeep Kumar Chitrapu (2):
      ath11k: add thermal cooling device support
      ath11k: add thermal sensor device support

Remi Pommarel (1):
      ath9k: Handle txpower changes even when TPC is disabled

Sean Wang (1):
      mt76: mt7615: add more uni mcu commands

Sergey Matyukevich (4):
      qtnfmac: support WPA3 SAE in AP mode
      qtnfmac: support WPA3 OWE in AP mode
      qtnfmac: set valid edmg in cfg80211_chan_def
      qtnfmac: assign each wiphy to its own virtual platform device

Sergiu Cuciurean (1):
      libertas: Use new structure for SPI transfer delays

Takashi Iwai (8):
      ath11k: Use scnprintf() for avoiding potential buffer overflow
      ath5k: Use scnprintf() for avoiding potential buffer overflow
      carl9170: Use scnprintf() for avoiding potential buffer overflow
      b43: Use scnprintf() for avoiding potential buffer overflow
      b43legacy: Use scnprintf() for avoiding potential buffer overflow
      ipw2x00: Use scnprintf() for avoiding potential buffer overflow
      prism54: Use scnprintf() for avoiding potential buffer overflow
      ssb: Use scnprintf() for avoiding potential buffer overflow

Tamizh Chelvam (2):
      dt-bindings: ath10k: Add new dt entries to identify coex support
      ath10k: Add support to read btcoex related data from DT

Venkateswara Naralasetty (1):
      ath11k: fix incorrect peer stats counters update

Vikas Patel (2):
      ath11k: Fixing dangling pointer issue upon peer delete failure
      ath10k: avoid consecutive OTP download to reduce boot time

Wen Gong (2):
      ath10k: start recovery process when read int status fail for sdio
      ath10k: use kzalloc to read for ath10k_sdio_hif_diag_read

Xu Wang (1):
      iwlegacy: Remove unneeded variable ret

Yan-Hsuan Chuang (5):
      rtw88: extract alloc rsvd_page and h2c skb routines
      rtw88: associate reserved pages with each vif
      rtw88: pci: define a mask for TX/RX BD indexes
      rtw88: kick off TX packets once for higher efficiency
      rtw88: 8822c: config RF table path B before path A

Yibo Zhao (2):
      ath10k: fix not registering airtime of 11a station with WMM disable
      ath10k: allow qca988x family to support ack rssi of tx data packets.

Yingying Tang (1):
      ath10k: fix unsupported chip reset debugs file write

chenqiwu (1):
      b43legacy: replace simple_strtol() with kstrtoint()

 .../bindings/net/wireless/qcom,ath10k.txt          |    7 +
 drivers/net/wireless/admtek/adm8211.h              |    2 +-
 drivers/net/wireless/ath/ath10k/ahb.c              |    4 +-
 drivers/net/wireless/ath/ath10k/core.c             |   82 +-
 drivers/net/wireless/ath/ath10k/core.h             |    3 +
 drivers/net/wireless/ath/ath10k/debug.c            |   12 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |    3 +-
 drivers/net/wireless/ath/ath10k/hw.c               |    1 +
 drivers/net/wireless/ath/ath10k/hw.h               |    3 +
 drivers/net/wireless/ath/ath10k/mac.c              |    3 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |   25 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |    2 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |    7 +
 drivers/net/wireless/ath/ath11k/Makefile           |    1 +
 drivers/net/wireless/ath/ath11k/core.c             |   14 +-
 drivers/net/wireless/ath/ath11k/core.h             |    6 +-
 drivers/net/wireless/ath/ath11k/debug.h            |   13 +-
 drivers/net/wireless/ath/ath11k/debug_htt_stats.c  |   12 +-
 drivers/net/wireless/ath/ath11k/debugfs_sta.c      |   11 +-
 drivers/net/wireless/ath/ath11k/dp.c               |   41 +-
 drivers/net/wireless/ath/ath11k/dp.h               |   11 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   97 +-
 drivers/net/wireless/ath/ath11k/dp_rx.h            |    2 +
 drivers/net/wireless/ath/ath11k/dp_tx.c            |    1 +
 drivers/net/wireless/ath/ath11k/hal_rx.c           |   13 +-
 drivers/net/wireless/ath/ath11k/hal_rx.h           |   30 +
 drivers/net/wireless/ath/ath11k/mac.c              |   48 +-
 drivers/net/wireless/ath/ath11k/mac.h              |    1 +
 drivers/net/wireless/ath/ath11k/rx_desc.h          |    8 +
 drivers/net/wireless/ath/ath11k/thermal.c          |  224 ++
 drivers/net/wireless/ath/ath11k/thermal.h          |   53 +
 drivers/net/wireless/ath/ath11k/wmi.c              |  147 ++
 drivers/net/wireless/ath/ath11k/wmi.h              |   53 +
 drivers/net/wireless/ath/ath5k/Kconfig             |    2 +-
 drivers/net/wireless/ath/ath5k/debug.c             |  174 +-
 drivers/net/wireless/ath/ath9k/main.c              |    3 +
 drivers/net/wireless/ath/carl9170/debug.c          |    2 +-
 drivers/net/wireless/atmel/at76c50x-usb.h          |    2 +-
 drivers/net/wireless/broadcom/b43/debugfs.c        |    2 +-
 drivers/net/wireless/broadcom/b43legacy/debugfs.c  |    2 +-
 drivers/net/wireless/broadcom/b43legacy/sysfs.c    |    6 +-
 .../broadcom/brcm80211/brcmfmac/firmware.h         |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |    2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |   16 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |   48 +-
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |    4 +-
 drivers/net/wireless/intel/ipw2x00/libipw_wx.c     |    8 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |    4 +-
 drivers/net/wireless/intel/iwlegacy/4965.c         |    3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   47 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |  161 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   59 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  355 ++-
 .../net/wireless/intersil/hostap/hostap_common.h   |    2 +-
 drivers/net/wireless/intersil/hostap/hostap_wlan.h |    2 +-
 drivers/net/wireless/intersil/orinoco/fw.c         |    2 +-
 drivers/net/wireless/intersil/orinoco/hermes.h     |    2 +-
 drivers/net/wireless/intersil/orinoco/hermes_dld.c |    6 +-
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |    2 +-
 drivers/net/wireless/intersil/p54/eeprom.h         |    8 +-
 drivers/net/wireless/intersil/p54/lmac.h           |    6 +-
 drivers/net/wireless/intersil/p54/p54.h            |    2 +-
 drivers/net/wireless/intersil/prism54/oid_mgt.c    |   34 +-
 drivers/net/wireless/marvell/libertas/host.h       |    4 +-
 drivers/net/wireless/marvell/libertas/if_sdio.c    |    2 +-
 drivers/net/wireless/marvell/libertas/if_spi.c     |    5 +-
 drivers/net/wireless/marvell/libertas/if_usb.h     |    2 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.h  |    2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |    2 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |   40 +-
 drivers/net/wireless/marvell/mwl8k.c               |    6 +-
 drivers/net/wireless/mediatek/mt76/mcu.c           |    6 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |    5 +-
 .../net/wireless/mediatek/mt76/mt7603/debugfs.c    |    4 +
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |    2 +
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    |    1 -
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |    2 +
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |   50 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |   66 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h |    2 +
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |  161 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   30 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |   11 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   44 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    | 2761 ++++++++++++--------
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |  144 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |   67 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   66 +-
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |    8 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |   87 +-
 drivers/net/wireless/mediatek/mt76/mt7615/soc.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |    3 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |    5 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |   36 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |   53 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |   38 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |    2 +
 drivers/net/wireless/quantenna/qtnfmac/core.c      |   18 +-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |    5 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c     |   54 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |   33 +-
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    |    2 +
 drivers/net/wireless/rayctl.h                      |    2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |    2 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |    8 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |    6 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |  265 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |   27 +-
 drivers/net/wireless/realtek/rtw88/hci.h           |   20 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   22 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   15 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    4 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |  199 +-
 drivers/net/wireless/realtek/rtw88/pci.h           |    7 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |    2 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |  131 +-
 drivers/net/wireless/realtek/rtw88/tx.h            |   10 +-
 drivers/net/wireless/realtek/rtw88/wow.c           |   39 +-
 drivers/net/wireless/st/cw1200/wsm.h               |    2 +-
 drivers/net/wireless/ti/wl1251/cmd.h               |    4 +-
 drivers/net/wireless/ti/wl1251/wl12xx_80211.h      |    2 +-
 drivers/net/wireless/ti/wlcore/acx.h               |    2 +-
 drivers/net/wireless/ti/wlcore/boot.h              |    2 +-
 drivers/net/wireless/ti/wlcore/cmd.h               |    2 +-
 drivers/net/wireless/ti/wlcore/conf.h              |    2 +-
 drivers/net/wireless/ti/wlcore/wl12xx_80211.h      |    2 +-
 drivers/net/wireless/wl3501.h                      |    2 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.h       |    8 +-
 drivers/ssb/sprom.c                                |    4 +-
 130 files changed, 4260 insertions(+), 2276 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath11k/thermal.c
 create mode 100644 drivers/net/wireless/ath/ath11k/thermal.h
