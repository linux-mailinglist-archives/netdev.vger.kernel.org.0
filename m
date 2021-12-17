Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2495C478C00
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 14:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbhLQNJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 08:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236558AbhLQNJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 08:09:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E624C061574;
        Fri, 17 Dec 2021 05:09:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 248FCB827F3;
        Fri, 17 Dec 2021 13:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34887C36AE9;
        Fri, 17 Dec 2021 13:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639746593;
        bh=1Zje6HGT9/tWd7kdJKEbT7DR1WDLt1g9vO6R9zxeBr4=;
        h=From:Subject:To:Cc:Date:From;
        b=o/MwDRC8zSe1z3qSOIlXcvrloKAWa2CaxnGPBu4T0PMLJcO+NhcTTNCvVBw2zpyZp
         YuSNS7t9EJiLFa3/XDjAhaFekoTY6rwPSlwXLcJwYZCK92/uk8lQzAw+m40TR5QplS
         0kNdPIBldsl3dom8ywdnr/lqvf3hKz10TJwoFoajaGUtkZcFWyFxJ22E7bx4WWXYl8
         36SHqo/WRaViRh/XwPAc5G09wHL3oxrw0Nb94V6wM6avLIiOype/dukMG3if2mwelE
         h2W5y5lgF+XM9nym4M5L4JUv6HDu/guLlJOSfdismRqHjCLi/fu81Ls9A71naZodzT
         /zVWyHcQenyNA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-drivers-next-2021-12-17
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20211217130952.34887C36AE9@smtp.kernel.org>
Date:   Fri, 17 Dec 2021 13:09:52 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 1fe5b01262844be03de98afdd56d1d393df04d7e:

  Merge branch 's390-net-updates-2021-12-06' (2021-12-07 22:01:08 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2021-12-17

for you to fetch changes up to fd5e3c4ab92e39b3411147b3fd845e70e81ac7a7:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2021-12-16 20:12:58 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for v5.17

Second set of patches for v5.17, planning to do at least one more.
Smaller new features, nothing special this time.

Major changes:

rtw88

* debugfs file to fix tx rate

iwlwifi

* support SAR GEO Offset Mapping (SGOM) via BIOS

* support firmware API version 68

* add some new device IDs

ath11k

* support PCI devices with 1 MSI vector

* WCN6855 hw2.1 support

* 11d scan offload support

* full monitor mode, only supported on QCN9074

* scan MAC address randomization support

* reserved host DDR addresses from DT for PCI devices support

ath9k

* switch to rate table based lookup

ath

* extend South Korea regulatory domain support

wcn36xx

* beacon filter support

----------------------------------------------------------------
Anilkumar Kolli (7):
      ath11k: Fix mon status ring rx tlv processing
      ath11k: Use host CE parameters for CE interrupts configuration
      ath11k: Add htt cmd to enable full monitor mode
      ath11k: add software monitor ring descriptor for full monitor
      ath11k: Process full monitor mode rx support
      dt: bindings: add new DT entry for ath11k PCI device support
      ath11k: Use reserved host DDR addresses from DT for PCI devices

Arnd Bergmann (1):
      iwlwifi: work around reverse dependency on MEI

Ayala Barazani (1):
      iwlwifi: support SAR GEO Offset Mapping override via BIOS

Baochen Qiang (3):
      ath11k: Set IRQ affinity to CPU0 in case of one MSI vector
      ath11k: add support for WCN6855 hw2.1
      ath11k: Avoid false DEADLOCK warning reported by lockdep

Brian Norris (1):
      mwifiex: Fix possible ABBA deadlock

Bryan O'Donoghue (3):
      wcn36xx: Fix beacon filter structure definitions
      wcn36xx: Fix physical location of beacon filter comment
      wcn36xx: Implement beacon filtering

Carl Huang (8):
      ath11k: get msi_data again after request_irq is called
      ath11k: add CE and ext IRQ flag to indicate irq_handler
      ath11k: use ATH11K_PCI_IRQ_DP_OFFSET for DP IRQ
      ath11k: refactor multiple MSI vector implementation
      ath11k: add support one MSI vector
      ath11k: do not restore ASPM in case of single MSI vector
      ath11k: support MAC address randomization in scan
      ath11k: set DTIM policy to stick mode for station interface

Ching-Te Ku (7):
      rtw89: coex: correct C2H header length
      rtw89: coex: Not to send H2C when WL not ready and count H2C
      rtw89: coex: Add MAC API to get BT polluted counter
      rtw89: coex: Define LPS state for BTC using
      rtw89: coex: Update BT counters while receiving report
      rtw89: coex: Cancel PS leaving while C2H comes
      rtw89: coex: Update COEX to 5.5.8

Christophe JAILLET (1):
      carl9170: Use the bitmap API when applicable

Colin Ian King (2):
      ath11k: Fix spelling mistake "detetction" -> "detection"
      iwlwifi: mei: Fix spelling mistake "req_ownserhip" -> "req_ownership"

David Mosberger-Tang (10):
      wilc1000: Add id_table to spi_driver
      wilc1000: Fix copy-and-paste typo in wilc_set_mac_address
      wilc1000: Fix missing newline in error message
      wilc1000: Remove misleading USE_SPI_DMA macro
      wilc1000: Fix spurious "FW not responding" error
      wilc1000: Rename SPI driver from "WILC_SPI" to "wilc1000_spi"
      wilc1000: Rename irq handler from "WILC_IRQ" to netdev name
      wilc1000: Rename tx task from "K_TXQ_TASK" to NETDEV-tx
      wilc1000: Rename workqueue from "WILC_wq" to "NETDEV-wq"
      wilc1000: Improve WILC TX performance when power_save is off

Emmanuel Grumbach (3):
      iwlwifi: mei: don't rely on the size from the shared area
      iwlwifi: mvm: fix a possible NULL pointer deference
      iwlwifi: mvm: remove session protection upon station removal

Fabio Estevam (1):
      ath10k: Fix the MTU size on QCA9377 SDIO

Haim Dreyfuss (1):
      iwlwifi: pcie: support Bz suspend/resume trigger

Ilan Peer (2):
      iwlwifi: mvm: Fix wrong documentation for scan request command
      iwlwifi: mvm: Add support for a new version of scan request command

Johannes Berg (15):
      iwlwifi: mvm: fix delBA vs. NSSN queue sync race
      iwlwifi: mvm: synchronize with FW after multicast commands
      iwlwifi: mvm: d3: move GTK rekeys condition
      iwlwifi: mvm: parse firmware alive message version 6
      iwlwifi: mvm: d3: support v12 wowlan status
      iwlwifi: mvm: support RLC configuration command
      iwlwifi: fw: api: add link to PHY context command struct v1
      iwlwifi: mvm: add support for PHY context command v4
      iwlwifi: mvm: add some missing command strings
      iwlwifi: mvm/api: define system control command
      iwlwifi: mvm: always use 4K RB size by default
      iwlwifi: pcie: retake ownership after reset
      iwlwifi: implement reset flow for Bz devices
      iwlwifi: fw: correctly detect HW-SMEM region subtype
      iwlwifi: mvm: optionally suppress assert log

Jonas Jelonek (1):
      ath9k: switch to rate table based lookup

Kalle Valo (6):
      Revert "ath11k: add read variant from SMBIOS for download board data"
      ath10k: htt: remove array of flexible structures
      ath10k: wmi: remove array of flexible structures
      ath11k: add ab to TARGET_NUM_VDEVS & co
      Merge tag 'iwlwifi-next-for-kalle-2021-12-08' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Kees Cook (4):
      ath11k: Use memset_startat() for clearing queue descriptors
      libertas: Add missing __packed annotation with struct_group()
      libertas_tf: Add missing __packed annotations
      ath6kl: Use struct_group() to avoid size-mismatched casting

Loic Poulain (3):
      wcn36xx: Use correct SSN for ADD BA request
      wcn36xx: Fix max channels retrieval
      brcmfmac: Fix incorrect type assignments for keep-alive

Luca Coelho (3):
      iwlwifi: remove unused iwlax210_2ax_cfg_so_hr_a0 structure
      iwlwifi: add missing entries for Gf4 with So and SoF
      iwlwifi: bump FW API to 68 for AX devices

Lv Yunlong (1):
      wireless: iwlwifi: Fix a double free in iwl_txq_dyn_alloc_dma

Matti Gottlieb (1):
      iwlwifi: Fix FW name for gl

Merlijn Wajer (1):
      wl1251: specify max. IE length

Mike Golant (2):
      iwlwifi: support 4-bits in MAC step value
      iwlwifi: add support for Bz-Z HW

Miri Korenblit (1):
      iwlwifi: acpi: fix wgds rev 3 size

Mordechay Goodstein (3):
      iwlwifi: mvm: add support for statistics update version 15
      iwlwifi: mvm: update rate scale in moving back to assoc state
      iwlwifi: fw: add support for splitting region type bits

Mukesh Sisodiya (2):
      iwlwifi: yoyo: support for DBGC4 for dram
      iwlwifi: dbg: disable ini debug in 8000 family and below

Peter Oh (1):
      ath: regdom: extend South Korea regulatory domain support

Ping-Ke Shih (5):
      rtw89: add const in the cast of le32_get_bits()
      rtw89: use inline function instead macro to set H2C and CAM
      rtw89: update scan_mac_addr during scanning period
      rtw89: fix sending wrong rtwsta->mac_id to firmware to fill address CAM
      rtw89: don't kick off TX DMA if failed to write skb

Po Hao Huang (1):
      rtw89: fix incorrect channel info during scan

Rameshkumar Sundaram (1):
      ath11k: Fix deleting uninitialized kernel timer during fragment cache flush

Sebastian Gottschall (1):
      ath10k: Fix tx hanging

Seevalamuthu Mariappan (2):
      ath11k: Fix QMI file type enum value
      ath11k: Change qcn9074 fw to operate in mode-2

Shaul Triebitz (1):
      iwlwifi: mvm: avoid clearing a just saved session protection id

Sriram R (1):
      ath11k: Avoid NULL ptr access during mgmt tx cleanup

Sven Eckelmann (1):
      ath11k: Fix buffer overflow when scanning with extraie

Venkateswara Naralasetty (1):
      ath11k: add spectral/CFR buffer validation support

Wen Gong (13):
      ath11k: change to treat alpha code na as world wide regdomain
      ath11k: calculate the correct NSS of peer for HE capabilities
      ath11k: fix read fail for htt_stats and htt_peer_stats for single pdev
      ath11k: skip sending vdev down for channel switch
      ath11k: add read variant from SMBIOS for download board data
      ath11k: change to use dynamic memory for channel list of scan
      ath11k: avoid deadlock by change ieee80211_queue_work for regd_update_work
      ath11k: add configure country code for QCA6390 and WCN6855
      ath11k: add 11d scan offload support
      ath11k: add wait operation for tx management packets for flush from mac80211
      ath10k: fix scan abort when duration is set for hw scan
      ath11k: enable IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS for WCN6855
      ath10k: drop beacon and probe response which leak from other channel

Yaara Baruch (3):
      iwlwifi: swap 1650i and 1650s killer struct names
      iwlwifi: add new Qu-Hr device
      iwlwifi: add new ax1650 killer device

Yan-Hsuan Chuang (1):
      rtw88: add debugfs to fix tx rate

Yang Shen (1):
      iwlwifi: mvm: demote non-compliant kernel-doc header

Zhou Qingyang (1):
      ath11k: Fix a NULL pointer dereference in ath11k_mac_op_hw_scan()

Zong-Zhe Yang (2):
      rtw88: refine tx_pwr_tbl debugfs to show channel and bandwidth
      rtw89: remove cch_by_bw which is not used

zhangyue (1):
      rsi: fix array out of bound

 .../bindings/net/wireless/qcom,ath11k.yaml         |   30 +
 drivers/net/wireless/ath/ath10k/core.c             |   19 +-
 drivers/net/wireless/ath/ath10k/htt.h              |  110 -
 drivers/net/wireless/ath/ath10k/htt_tx.c           |    3 +
 drivers/net/wireless/ath/ath10k/hw.h               |    3 +
 drivers/net/wireless/ath/ath10k/mac.c              |    9 +-
 drivers/net/wireless/ath/ath10k/txrx.c             |    2 -
 drivers/net/wireless/ath/ath10k/wmi.c              |   27 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |    4 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |   16 +-
 drivers/net/wireless/ath/ath11k/core.c             |  110 +-
 drivers/net/wireless/ath/ath11k/core.h             |   19 +
 drivers/net/wireless/ath/ath11k/dbring.c           |   30 +
 drivers/net/wireless/ath/ath11k/dbring.h           |    2 +
 drivers/net/wireless/ath/ath11k/dp.c               |    1 +
 drivers/net/wireless/ath/ath11k/dp.h               |   54 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  423 +++-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |   57 +-
 drivers/net/wireless/ath/ath11k/dp_tx.h            |    2 +
 drivers/net/wireless/ath/ath11k/hal.c              |   22 +
 drivers/net/wireless/ath/ath11k/hal.h              |    2 +
 drivers/net/wireless/ath/ath11k/hal_desc.h         |   19 +
 drivers/net/wireless/ath/ath11k/hal_rx.c           |   57 +-
 drivers/net/wireless/ath/ath11k/hal_rx.h           |   17 +
 drivers/net/wireless/ath/ath11k/hw.c               |   14 +-
 drivers/net/wireless/ath/ath11k/hw.h               |   22 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  437 +++-
 drivers/net/wireless/ath/ath11k/mac.h              |   11 +
 drivers/net/wireless/ath/ath11k/mhi.c              |   49 +-
 drivers/net/wireless/ath/ath11k/pci.c              |  212 +-
 drivers/net/wireless/ath/ath11k/pci.h              |    3 +
 drivers/net/wireless/ath/ath11k/qmi.c              |   69 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |    4 +-
 drivers/net/wireless/ath/ath11k/reg.c              |   15 +
 drivers/net/wireless/ath/ath11k/spectral.c         |   14 +
 drivers/net/wireless/ath/ath11k/wmi.c              |  211 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |   63 +-
 drivers/net/wireless/ath/ath6kl/htc.h              |   19 +-
 drivers/net/wireless/ath/ath6kl/htc_mbox.c         |   15 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   45 +-
 drivers/net/wireless/ath/carl9170/main.c           |    9 +-
 drivers/net/wireless/ath/regd.h                    |    1 +
 drivers/net/wireless/ath/regd_common.h             |    3 +
 drivers/net/wireless/ath/wcn36xx/hal.h             |   29 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   25 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |  117 +-
 drivers/net/wireless/ath/wcn36xx/smd.h             |    5 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    4 +-
 drivers/net/wireless/intel/iwlwifi/Kconfig         |   52 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   29 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |    8 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h  |   17 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   13 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |   81 +-
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |   62 +
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |   13 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |    5 +
 .../net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h   |    9 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |   14 +
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |   48 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/stats.h  |   92 +-
 .../intel/iwlwifi/fw/api/{soc.h => system.h}       |   16 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   21 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |   18 +
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |    4 +
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |   88 +
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h       |   20 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |    2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   19 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |    2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |    7 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   13 +-
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |   30 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  184 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |    8 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   55 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   39 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   30 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |   62 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |    8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  261 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |    5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   51 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   10 +
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   51 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   40 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   13 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  115 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      |    8 +-
 drivers/net/wireless/marvell/libertas/host.h       |    2 +-
 .../net/wireless/marvell/libertas_tf/libertas_tf.h |   28 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |    8 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |   10 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |    5 +-
 drivers/net/wireless/microchip/wilc1000/netdev.c   |   21 +-
 drivers/net/wireless/microchip/wilc1000/netdev.h   |    1 +
 drivers/net/wireless/microchip/wilc1000/spi.c      |   16 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |    7 +-
 drivers/net/wireless/microchip/wilc1000/wlan.h     |    2 -
 drivers/net/wireless/realtek/rtw88/debug.c         |   49 +
 drivers/net/wireless/realtek/rtw88/main.c          |    1 +
 drivers/net/wireless/realtek/rtw88/main.h          |    1 +
 drivers/net/wireless/realtek/rtw88/tx.c            |    9 +
 drivers/net/wireless/realtek/rtw89/cam.c           |   61 +-
 drivers/net/wireless/realtek/rtw89/cam.h           |  472 +++--
 drivers/net/wireless/realtek/rtw89/coex.c          |   73 +-
 drivers/net/wireless/realtek/rtw89/coex.h          |    6 +
 drivers/net/wireless/realtek/rtw89/core.c          |   88 +-
 drivers/net/wireless/realtek/rtw89/core.h          |   30 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |    2 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |    5 +-
 drivers/net/wireless/realtek/rtw89/fw.h            | 2170 ++++++++++++--------
 drivers/net/wireless/realtek/rtw89/mac.c           |   16 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |    1 +
 drivers/net/wireless/realtek/rtw89/mac80211.c      |    7 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |  111 +
 drivers/net/wireless/realtek/rtw89/phy.h           |   60 +
 drivers/net/wireless/realtek/rtw89/reg.h           |   23 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   21 +-
 drivers/net/wireless/realtek/rtw89/txrx.h          |   91 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |    3 +
 drivers/net/wireless/ti/wl1251/main.c              |    6 +
 131 files changed, 5596 insertions(+), 1919 deletions(-)
 rename drivers/net/wireless/intel/iwlwifi/fw/api/{soc.h => system.h} (70%)
