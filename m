Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D73D47E45D
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 15:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348760AbhLWOLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 09:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbhLWOLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 09:11:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B543C061401;
        Thu, 23 Dec 2021 06:11:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC625B81F7B;
        Thu, 23 Dec 2021 14:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78808C36AE9;
        Thu, 23 Dec 2021 14:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640268669;
        bh=42liZ7wygqtqa2nPd4L0oCqr3PjyKbZ0/a/l1AQq0jw=;
        h=From:Subject:To:Cc:Date:From;
        b=S6UgDKQbg6uc02H1EfLpcWBHq68AxUrBonrSLm+7LHrk6f6vBbooV0NjroOGWlWm+
         m4bOh5LGYRRT1VrJ48LAlXUabu8GjfbO6+t5TJgmxtmYws/xzUB+Uy63PL1AweNhBU
         j+zJeDy0+y007mobKYPNd5FHnLaP1puDg2SGGdAyL1Dc4T1YVemgIE9IQVahhQT8mo
         pcCQkjLXRFTaxD0dOqif5hHpBRUHwCayQj96moxP6d+VQGXIJz7LHgD7xQcOdckmKP
         ZtG7Afw+mTjltA3cEIHLa76c0Mcw9m4lkYFi07pmli4OVzQ/cjgMogf+pwLZGMZfl7
         7Vham89ishzYA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-drivers-next-2021-12-23
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20211223141108.78808C36AE9@smtp.kernel.org>
Date:   Thu, 23 Dec 2021 14:11:08 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit f85b244ee395c774a0039c176f46fc0d3747a0ae:

  xdp: move the if dev statements to the first (2021-12-18 12:35:49 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2021-12-23

for you to fetch changes up to d430dffbe9dd30759f3c64b65bf85b0245c8d8ab:

  mt76: mt7921: fix a possible race enabling/disabling runtime-pm (2021-12-22 19:53:52 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for v5.17

Third set of patches for v5.17, and the final one if all goes well. We
have Specific Absorption Rate (SAR) support for both mt76 and rtw88.
Also iwlwifi should be now W=1 warning free. But otherwise nothing
really special this time, business as usual.

Major changes:

mt76

* Specific Absorption Rate (SAR) support

* mt7921: new PCI ids

* mt7921: 160 MHz channel support

iwlwifi

* fix W=1 and sparse warnings

* BNJ hardware support

* add new killer device ids

* support for Time-Aware-SAR (TAS) from the BIOS

* Optimized Connectivity Experience (OCE) scan support

rtw88

* hardware scan

* Specific Absorption Rate (SAR) support

ath11k

* qca6390/wcn6855: report signal and tx bitrate

* qca6390: rfkill support

* qca6390/wcn6855: regdb.bin support

ath5k

* switch to rate table based lookup

wilc1000

* spi: reset/enable GPIO support

----------------------------------------------------------------
Avraham Stern (4):
      iwlwifi: mvm: add support for OCE scan
      iwlwifi: mvm: perform 6GHz passive scan after suspend
      iwlwifi: mvm: set protected flag only for NDP ranging
      iwlwifi: mvm: fix AUX ROC removal

Ayala Barazani (1):
      iwlwifi: mvm: Add list of OEMs allowed to use TAS

Ayala Beker (2):
      iwlwifi: mvm: correctly set channel flags
      iwlwifi: mvm: correctly set schedule scan profiles

Baochen Qiang (1):
      ath11k: Fix unexpected return buffer manager error for QCA6390

Ben Greear (1):
      ath11k: Fix napi related hang

Bjoern A. Zeeb (2):
      iwlwifi: iwl-eeprom-parse: mostly dvm only
      iwlwifi: do not use __unused as variable name

Bo Jiao (1):
      mt76: fix the wiphy's available antennas to the correct value

Changcheng Deng (1):
      mt76: mt7921: fix boolreturn.cocci warning

Cheng Wang (1):
      ath11k: add support of firmware logging for WCN6855

Chin-Yen Lee (2):
      rtw88: don't check CRC of VHT-SIG-B in 802.11ac signal
      rtw88: don't consider deep PS mode when transmitting packet

Chris Chiu (1):
      rtl8xxxu: Improve the A-MPDU retransmission rate with RTS/CTS protection

Chung-Hsuan Hung (1):
      rtw89: 8852a: correct bit definition of dfs_en

Dan Carpenter (3):
      wilc1000: fix double free error in probe()
      iwlwifi: mvm: fix a stray tab
      iwlwifi: mvm: clean up indenting in iwl_mvm_tlc_update_notif()

Daniel Golle (1):
      mt76: eeprom: tolerate corrected bit-flips

David Mosberger-Tang (3):
      wilc1000: Convert static "chipid" variable to device-local variable
      wilc1000: Add reset/enable GPIO support to SPI driver
      wilc1000: Document enable-gpios and reset-gpios properties

Deren Wu (5):
      mt76: mt7921: add support for PCIe ID 0x0608/0x0616
      mt76: mt7921: introduce 160 MHz channel bandwidth support
      mt76: mt7921s: fix bus hang with wrong privilege
      mt76: mt7921: fix network buffer leak by txs missing
      mt76: mt7921s: fix cmd timeout in throughput test

Emmanuel Grumbach (2):
      iwlwifi: mei: clear the ownership when the driver goes down
      iwlwifi: mei: wait before mapping the shared area

Felix Fietkau (10):
      mt76: mt7915: fix decap offload corner case with 4-addr VLAN frames
      mt76: mt7615: fix decap offload corner case with 4-addr VLAN frames
      mt76: mt7615: improve wmm index allocation
      mt76: mt7915: improve wmm index allocation
      mt76: clear sta powersave flag after notifying driver
      mt76: mt7603: improve reliability of tx powersave filtering
      mt76: mt7615: clear mcu error interrupt status on mt7663
      mt76: allow drivers to drop rx packets early
      mt76: mt7915: process txfree and txstatus without allocating skbs
      mt76: mt7615: in debugfs queue stats, skip wmm index 3 on mt7663

Gregory Greenman (1):
      iwlwifi: mvm: rfi: update rfi table

Ilan Peer (2):
      iwlwifi: mvm: Increase the scan timeout guard to 30 seconds
      iwlwifi: mvm: Fix calculation of frame length

Jason Wang (1):
      ath10k: replace strlcpy with strscpy

Johannes Berg (22):
      iwlwifi: mei: fix W=1 warnings
      iwlwifi: mvm: add missing min_size to kernel-doc
      iwlwifi: mvm: add dbg_time_point to debugfs
      iwlwifi: fix Bz NMI behaviour
      iwlwifi: fw: remove dead error log code
      iwlwifi: parse error tables from debug TLVs
      iwlwifi: dump CSR scratch from outer function
      iwlwifi: dump both TCM error tables if present
      iwlwifi: dump RCM error tables
      iwlwifi: mvm: fix 32-bit build in FTM
      iwlwifi: fix debug TLV parsing
      iwlwifi: fix leaks/bad data after failed firmware load
      iwlwifi: mvm: isolate offload assist (checksum) calculation
      iwlwifi: remove module loading failure message
      iwlwifi: mvm: use a define for checksum flags mask
      iwlwifi: mvm: handle RX checksum on Bz devices
      iwlwifi: mvm: don't trust hardware queue number
      iwlwifi: mvm: change old-SN drop threshold
      iwlwifi: mvm: support Bz TX checksum offload
      iwlwifi: mvm: drop too short packets silently
      iwlwifi: mvm: remove card state notification code
      iwlwifi: fw: fix some scan kernel-doc

Jonas Jelonek (1):
      ath5k: switch to rate table based lookup

Kai-Heng Feng (1):
      rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE

Kalle Valo (3):
      Merge tag 'mt76-for-kvalo-2021-12-18' of https://github.com/nbd168/wireless
      Merge tag 'iwlwifi-next-for-kalle-2021-12-21-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Larry Finger (1):
      rtlwifi: rtl8192cu: Fix WARNING when calling local_irq_restore() with interrupts enabled

Lorenzo Bianconi (26):
      mt76: mt7915: get rid of mt7915_mcu_set_fixed_rate routine
      mt76: debugfs: fix queue reporting for mt76-usb
      mt76: fix possible OOB issue in mt76_calculate_default_rate
      mt76: mt7921: fix possible NULL pointer dereference in mt7921_mac_write_txwi
      mt76: connac: fix a theoretical NULL pointer dereference in mt76_connac_get_phy_mode
      mt76: mt7615: remove dead code in get_omac_idx
      mt76: connac: remove PHY_MODE_AX_6G configuration in mt76_connac_get_phy_mode
      mt76: mt7921: honor mt76_connac_mcu_set_rate_txpower return value in mt7921_config
      mt76: move sar utilities to mt76-core module
      mt76: mt76x02: introduce SAR support
      mt76: mt7603: introduce SAR support
      mt76: mt7915: introduce SAR support
      mt76: connac: fix last_chan configuration in mt76_connac_mcu_rate_txpower_band
      mt76: move sar_capa configuration in common code
      mt76: mt7663: disable 4addr capability
      mt76: connac: introduce MCU_EXT macros
      mt76: connac: align MCU_EXT definitions with 7915 driver
      mt76: connac: remove MCU_FW_PREFIX bit
      mt76: connac: introduce MCU_UNI_CMD macro
      mt76: connac: introduce MCU_CE_CMD macro
      mt76: connac: rely on MCU_CMD macro
      mt76: mt7915: rely on mt76_connac definitions
      mt76: mt7915: introduce mt76_vif in mt7915_vif
      mt76: mt7921: remove dead definitions
      mt76: connac: rely on le16_add_cpu in mt76_connac_mcu_add_nested_tlv
      mt76: mt7921: fix a possible race enabling/disabling runtime-pm

Luca Coelho (5):
      iwlwifi: mvm: fix imbalanced locking in iwl_mvm_start_get_nvm()
      iwlwifi: recognize missing PNVM data and then log filename
      iwlwifi: don't pass actual WGDS revision number in table_revision
      iwlwifi: bump FW API to 69 for AX devices
      iwlwifi: pcie: make sure prph_info is set when treating wakeup IRQ

Matti Gottlieb (1):
      iwlwifi: Read the correct addresses when getting the crf id

MeiChia Chiu (1):
      mt76: mt7915: add mu-mimo and ofdma debugfs knobs

Mike Golant (2):
      iwlwifi: pcie: add jacket bit to device configuration parsing
      iwlwifi: add support for BNJ HW

Miri Korenblit (3):
      iwlwifi: mvm: support revision 1 of WTAS table
      iwlwifi: mvm: always store the PPAG table as the latest version.
      iwlwifi: mvm: add US/CA to TAS block list if OEM isn't allowed

Mordechay Goodstein (2):
      iwlwifi: rs: add support for TLC config command ver 4
      iwlwifi: return op_mode only in case the failure is from MEI

Mukesh Sisodiya (2):
      iwlwifi: yoyo: support TLV-based firmware reset
      iwlwifi: yoyo: fix issue with new DBGI_SRAM region read.

Nathan Errera (1):
      iwlwifi: mvm: test roc running status bits before removing the sta

Peter Chiu (1):
      mt76: mt7615: fix possible deadlock while mt7615_register_ext_phy()

Po-Hao Huang (2):
      rtw88: 8822c: update rx settings to prevent potential hw deadlock
      rtw88: 8822c: add ieee80211_ops::hw_scan

Ryder Lee (3):
      mt76: mt7915: fix SMPS operation fail
      mt76: only set rx radiotap flag from within decoder functions
      mt76: only access ieee80211_hdr after mt76_insert_ccmp_hdr

Sean Wang (9):
      mt76: mt7921: drop offload_flags overwritten
      mt76: mt7921: fix MT7921E reset failure
      mt76: mt7921: move mt76_connac_mcu_set_hif_suspend to bus-related files
      mt76: mt7921s: fix the device cannot sleep deeply in suspend
      mt76: mt7921s: fix possible kernel crash due to invalid Rx count
      mt76: mt7921: clear pm->suspended in mt7921_mac_reset_work
      mt76: mt7921: fix possible resume failure
      mt76: mt7921s: make pm->suspended usage consistent
      mt76: mt7921s: fix suspend error with enlarging mcu timeout value

Shayne Chen (5):
      mt76: mt7915: fix return condition in mt7915_tm_reg_backup_restore()
      mt76: mt7915: add default calibrated data support
      mt76: testmode: add support to set MAC
      mt76: mt7615: fix unused tx antenna mask in testmode
      mt76: mt7921: use correct iftype data on 6GHz cap init

Tetsuo Handa (2):
      ath9k_htc: fix NULL pointer dereference at ath9k_htc_rxep()
      ath9k_htc: fix NULL pointer dereference at ath9k_htc_tx_get_packet()

Tzung-Bi Shih (1):
      mt76: mt7921: reduce log severity levels for informative messages

Wen Gong (6):
      ath11k: report rssi of each chain to mac80211 for QCA6390/WCN6855
      ath11k: add signal report to mac80211 for QCA6390 and WCN6855
      ath11k: fix warning of RCU usage for ath11k_mac_get_arvif_by_vdev_id()
      ath11k: report tx bitrate for iw wlan station dump
      ath11k: add support for hardware rfkill for QCA6390
      ath11k: add regdb.bin download for regdb offload

Xing Song (2):
      mt76: reverse the first fragmented frame to 802.11
      mt76: do not pass the received frame with decryption error

Yaara Baruch (1):
      iwlwifi: pcie: add killer devices to the driver

Zekun Shen (1):
      ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream

Zong-Zhe Yang (1):
      rtw88: support SAR via kernel common API

 .../bindings/net/wireless/microchip,wilc1000.yaml  |  19 +
 drivers/net/wireless/ath/ath10k/coredump.c         |   6 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |  12 +-
 drivers/net/wireless/ath/ath11k/core.c             | 110 ++-
 drivers/net/wireless/ath/ath11k/core.h             |  17 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |  37 +
 drivers/net/wireless/ath/ath11k/debugfs.h          |   8 +
 drivers/net/wireless/ath/ath11k/debugfs_sta.c      |  78 +-
 drivers/net/wireless/ath/ath11k/debugfs_sta.h      |   2 -
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  38 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            | 106 ++-
 drivers/net/wireless/ath/ath11k/dp_tx.h            |   1 +
 drivers/net/wireless/ath/ath11k/hal_rx.c           |  17 +-
 drivers/net/wireless/ath/ath11k/hal_rx.h           |  39 +-
 drivers/net/wireless/ath/ath11k/hw.h               |   7 +
 drivers/net/wireless/ath/ath11k/mac.c              | 213 +++++-
 drivers/net/wireless/ath/ath11k/mac.h              |   5 +
 drivers/net/wireless/ath/ath11k/pci.c              |  12 +-
 drivers/net/wireless/ath/ath11k/qmi.c              | 124 ++-
 drivers/net/wireless/ath/ath11k/qmi.h              |  13 +
 drivers/net/wireless/ath/ath11k/trace.h            |  28 +
 drivers/net/wireless/ath/ath11k/wmi.c              | 265 ++++++-
 drivers/net/wireless/ath/ath11k/wmi.h              |  36 +
 drivers/net/wireless/ath/ath5k/base.c              |  50 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   7 +
 drivers/net/wireless/ath/ath9k/htc.h               |   2 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  13 +
 drivers/net/wireless/ath/ath9k/wmi.c               |   4 +
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  58 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  47 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |  23 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h  |   9 -
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |  10 +-
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |  26 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |  25 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |   8 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |  56 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |  45 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |  11 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   7 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c       | 149 ++--
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   1 -
 drivers/net/wireless/intel/iwlwifi/fw/img.c        |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |   4 +
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |   3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  13 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |  58 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  92 ++-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.c  |   4 +
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   2 -
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  13 +-
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |  17 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   1 +
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 169 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  18 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  41 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c       |  46 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |  97 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  48 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  40 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |  24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 102 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 286 ++++---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   7 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c       |   5 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |  19 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |   2 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  90 ++-
 drivers/net/wireless/mediatek/mt76/mt76.h          |  12 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |  31 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    |   4 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |   3 +
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   1 +
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    | 122 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |   2 +
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  15 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    | 200 +++--
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    | 127 ----
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |   1 +
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |   8 +-
 .../net/wireless/mediatek/mt76/mt7615/testmode.c   |  25 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_mcu.c    |   2 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |   3 -
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   | 169 ++---
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   | 521 +++++++++++--
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |   5 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |  34 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |   2 +
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c   |  29 +
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h |   2 +
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |   5 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_main.c   |   7 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |   4 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |   9 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    | 227 +++++-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |  83 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    | 205 ++++-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |  70 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    | 267 ++++---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    | 841 ++-------------------
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |  27 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |   1 +
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |  17 +-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |  12 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |  12 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    | 136 +++-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  80 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    | 160 ++--
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    | 153 +---
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   2 +
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |  25 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |   4 +
 .../net/wireless/mediatek/mt76/mt7921/pci_mcu.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   |  51 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mac.c   |   2 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mcu.c   |   2 +-
 .../net/wireless/mediatek/mt76/mt7921/testmode.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |  11 +-
 drivers/net/wireless/mediatek/mt76/sdio_txrx.c     |   3 +-
 drivers/net/wireless/mediatek/mt76/testmode.c      |  36 +-
 drivers/net/wireless/mediatek/mt76/testmode.h      |   4 +
 drivers/net/wireless/microchip/wilc1000/netdev.c   |   1 -
 drivers/net/wireless/microchip/wilc1000/netdev.h   |   1 +
 drivers/net/wireless/microchip/wilc1000/sdio.c     |   2 +
 drivers/net/wireless/microchip/wilc1000/spi.c      |  64 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |  29 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |   1 +
 drivers/net/wireless/realtek/rtw88/Makefile        |   1 +
 drivers/net/wireless/realtek/rtw88/bf.c            |  14 +-
 drivers/net/wireless/realtek/rtw88/bf.h            |   7 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |  12 +-
 drivers/net/wireless/realtek/rtw88/debug.h         |   1 +
 drivers/net/wireless/realtek/rtw88/fw.c            | 388 ++++++++++
 drivers/net/wireless/realtek/rtw88/fw.h            | 143 ++++
 drivers/net/wireless/realtek/rtw88/mac80211.c      |  91 ++-
 drivers/net/wireless/realtek/rtw88/main.c          |  87 ++-
 drivers/net/wireless/realtek/rtw88/main.h          |  75 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |  78 +-
 drivers/net/wireless/realtek/rtw88/pci.h           |   2 +
 drivers/net/wireless/realtek/rtw88/phy.c           |  63 +-
 drivers/net/wireless/realtek/rtw88/phy.h           |   1 +
 drivers/net/wireless/realtek/rtw88/ps.c            |   3 +
 drivers/net/wireless/realtek/rtw88/ps.h            |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |   3 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.h      |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |   4 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  14 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |   4 +
 drivers/net/wireless/realtek/rtw88/rx.c            |  10 +
 drivers/net/wireless/realtek/rtw88/sar.c           | 114 +++
 drivers/net/wireless/realtek/rtw88/sar.h           |  22 +
 drivers/net/wireless/realtek/rtw89/reg.h           |   2 +-
 164 files changed, 5378 insertions(+), 2635 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/sar.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sar.h
