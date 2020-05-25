Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB2B1E0DB8
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 13:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390365AbgEYLsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 07:48:46 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:61801 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390220AbgEYLsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 07:48:45 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590407323; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=K5b83dPvKxIPhbK6bx1860ONsTKQuBnRI3GAXqeECj4=; b=wtb0I29wdaojnwyv+qc3qaSGQQIcOKSBvVKqDbuFDazPkO/iDT6oAFpflvj4ILr7mbJH7Fht
 Ylak981bVWgwRCkhlJrT/JvYX75OFSp6oN2bHKq4OYg5izEqzwvpjMDIFtYbHD6XExJ2CgcZ
 gPEG41iOTn8TX767vrpXHloVQNw=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5ecbb08c3237f4f9714d403a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 25 May 2020 11:48:28
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7BF6CC433CA; Mon, 25 May 2020 11:48:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A31BCC433C6;
        Mon, 25 May 2020 11:48:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A31BCC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2020-05-25
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20200525114828.7BF6CC433CA@smtp.codeaurora.org>
Date:   Mon, 25 May 2020 11:48:28 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 790709f249728640faa4eff38286a9feb34fed81:

  net: relax SO_TXTIME CAP_NET_ADMIN check (2020-05-07 18:17:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2020-05-25

for you to fetch changes up to 472f0a240250df443ffc4f39835e829916193ca1:

  mt76: mt7915: Fix build error (2020-05-22 15:39:40 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.8

Second set of patches for v5.8. Lots of new features and new supported
hardware for mt76. Also rtw88 got new hardware support.

Major changes:

rtw88

* add support for Realtek 8723DE PCI adapter

* rename rtw88.ko/rtwpci.ko to rtw88_core.ko/rtw88_pci.ko

iwlwifi

* stop supporting swcrypto and bt_coex_active module parameters on
  mvm devices

* enable A-AMSDU in low latency

mt76

* new devices for mt76x0/mt76x2

* support for non-offload firmware on mt7663

* hw/sched scan support for mt7663

* mt7615/mt7663 MSI support

* TDLS support

* mt7603/mt7615 rate control fixes

* new driver for mt7915

* wowlan support for mt7663

* suspend/resume support for mt7663

----------------------------------------------------------------
Avraham Stern (1):
      iwlwifi: mvm: add support for range request command version 9

Chen Zhou (1):
      brcmfmac: make non-global functions static

ChenTao (1):
      rtl8187: Remove unused variable rtl8225z2_tx_power_ofdm

Chung-Hsien Hsu (1):
      brcmfmac: fix WPA/WPA2-PSK 4-way handshake offload and SAE offload failures

Colin Ian King (2):
      rtw88: 8723d: fix incorrect setting of ldo_pwr
      rtlwifi: rtl8192ee: remove redundant for-loop

Dan Carpenter (1):
      rtlwifi: Fix a double free in _rtl_usb_tx_urb_setup()

Dejin Zheng (1):
      mt76: mt7603: remove duplicate error message

Emmanuel Grumbach (4):
      iwlwifi: remove antenna_coupling module parameter
      iwlwifi: mvm: stop supporting swcrypto and bt_coex_active module parameters
      iwlwifi: mvm: remove iwlmvm's tfd_q_hang_detect module parameter
      iwlwifi: move iwl_set_soc_latency to iwl-drv to be used by other op_modes

Felix Fietkau (21):
      mt76: mt76x02: fix handling MCU timeouts during hw restart
      dt-bindings: net: wireless: mt76: document mediatek,eeprom-merge-otp property
      mt76: mt7615: disable merge of OTP ROM data by default
      mt76: mt7615: add support for applying DC offset calibration from EEPROM
      mt76: mt7615: add support for applying tx DPD calibration from EEPROM
      mt76: mt7603: disable merge of OTP ROM data by default
      mt76: mt76x2: disable merge of OTP ROM data by default
      mt76: mt7615: disable hw/sched scan ops for non-offload firmware
      mt76: mt7615: set hw scan limits only for firmware with offload support
      mt76: mt7615: rework IRQ handling to prepare for MSI support
      mt76: mt7615: fix sta ampdu factor for VHT
      mt76: fix A-MPDU density handling
      mt76: mt7615: use larger rx buffers if VHT is supported
      mt76: mt7615: never use an 802.11b CF-End rate on 5GHz
      mt76: mt7603: never use an 802.11b CF-End rate on 5GHz
      mt76: mt7615: adjust timing in mt7615_mac_set_timing to match fw/hw values
      mt76: mt7615: do not adjust MAC timings if the device is not running
      mt76: mt7615: fix tx status rate index calculation
      mt76: mt7603: fix tx status rate index calculation
      mt76: mt7615: set spatial extension index
      mt76: mt7615: fix getting maximum tx power from eeprom

Gustavo A. R. Silva (7):
      rndis_wlan: Remove logically dead code
      ipw2x00: Replace zero-length array with flexible-array
      iwlegacy: Replace zero-length array with flexible-array
      mwl8k: Replace zero-length array with flexible-array
      prism54: Replace zero-length array with flexible-array
      qtnfmac: Replace zero-length array with flexible-array
      rndis_wlan: Replace zero-length array with flexible-array

Jason Yan (1):
      brcmfmac: remove Comparison to bool in brcmf_p2p_send_action_frame()

Jia-Shyr Chuang (1):
      brcmfmac: set security after reiniting interface

Johannes Berg (10):
      iwlwifi: fw api: fix PHY data 2/3 position
      iwlwifi: pcie: allocate much smaller byte-count table
      iwlwifi: mvm: attempt to allocate smaller queues
      iwlwifi: dbg: mark a variable __maybe_unused
      iwlwifi: pcie: remove some dead code
      iwlwifi: pcie: gen2: use DMA pool for byte-count tables
      iwlwifi: use longer queues for 256-BA
      iwlwifi: mvm: don't transmit on unallocated queue
      iwlwifi: remove outdated copyright print/module statement
      iwlwifi: pcie: skip fragmented receive buffers

Jules Irenge (1):
      mt76: remove unnecessary annotations

Kalle Valo (2):
      Merge tag 'iwlwifi-next-for-kalle-2020-05-08' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge tag 'mt76-for-kvalo-2020-05-14' of https://github.com/nbd168/wireless

Kevin Lo (1):
      rtw88: no need to set registers for SDIO

Liad Kaufman (1):
      iwlwifi: dbg_ini: differentiate ax210 hw with same hw type

Lorenzo Bianconi (71):
      mt76: mt76x2u: introduce Mercury UD13 support
      mt76: mt7663: fix mt7615_mac_cca_stats_reset routine
      mt76: mt7663: enable nf estimation
      mt76: mt7615: make scs configurable per phy
      mt76: mt7663: disable RDD commands
      mt76: mt7615: add ethool support to mt7663 driver
      mt76: mt7615: introduce mt7615_mcu_set_channel_domain mcu command
      mt76: mt7615: introduce hw scan support
      mt76: mt7615: introduce scheduled scan support
      mt76: mt7615: introduce rlm tlv in bss_info mcu command
      mt76: add headroom and tailroom to mt76_mcu_ops data structure
      mt76: mt7615: introduce mt7663u support to mt7615_write_txwi
      mt76: mt7615: introduce mt7615_mac_update_rate_desc routine
      mt76: mt7615: introduce __mt7663_load_firmware routine
      mt76: mt7615: move mt7615_mac_wtbl_addr in mac.h
      mt76: mt76u: rely on mt7622 queue scheme for mt7663u
      mt76: mt7615: rework wtbl key configuration
      mt76: mt7615: introduce mt7615_wtbl_desc data structure
      mt76: mt7615: add address parameter to mt7615_eeprom_init
      mt76: mt7615: do not always reset the dfs state setting the channel
      mt76: mt7615: fix possible division by 0 in mt7615_mac_update_mib_stats
      mt76: mt7663: fix aggr range entry in debugfs
      mt76: mt7622: fix DMA unmap length
      mt76: mt7663: fix DMA unmap length
      mt76: mt7615: enable MSI by default
      mt76: mt7615: fix possible deadlock in mt7615_stop
      mt76: mt7615: move core shared code in mt7615-common module
      mt76: mt7615: introduce mt7663u support
      mt76: mt7615: enable scs for mt7663 driver
      mt76: mt7615: disable aspm by default
      mt76: mt7615: provide aid info to the mcu
      mt76: remove PS_NULLFUNC_STACK capability
      mt76: mt7663: introduce 802.11 PS support in sta mode
      mt76: add rx queues info to mt76 debugfs
      mt76: mt7615: parse mcu return code for unified commands
      mt76: mt7615: fix mt7615_firmware_own for mt7663e
      mt76: mt7615: fix max wtbl size for 7663
      mt76: mt7615: fix mt7615_driver_own routine
      mt76: mt7615: fix aid configuration in mt7615_mcu_wtbl_generic_tlv
      mt76: mt7615: rework mt7615_mac_sta_poll for usb code
      mt76: mt7663u: enable AirTimeFairness
      mt76: mt7615: move mcu bss upload before creating the sta
      mt76: enable TDLS support
      mt76: mt7615: add sta pointer to mt7615_mcu_add_bss_info signature
      mt76: mt7615: fix event report in mt7615_mcu_bss_event
      mt76: mt76x0: enable MCS 8 and MCS9
      mt76: mt7663: add the possibility to load firmware v2
      mt76: mt7663: remove check in mt7663_load_n9
      mt76: mt7615: fix ssid configuration in mt7615_mcu_hw_scan
      mt76: mt7615: introduce mt7615_check_offload_capability routine
      mt76: mt7615: do not mark sched_scan disabled in mt7615_scan_work
      mt76: mt7615: add passive mode for hw scan
      mt76: mt7615: free pci_vector if mt7615_pci_probe fails
      mt76: mt7615: introduce support for hardware beacon filter
      mt76: mt7615: add WoW support
      mt76: mt7615: introduce PM support
      mt76: mt7615: add gtk rekey offload support
      mt76: mt7615: introduce beacon_loss mcu event
      mt76: mt7663: read tx streams from eeprom
      mt76: mt7615: check return value of mt7615_eeprom_get_power_index
      mt76: mt7615: fix ibss mode for mt7663
      mt76: mt7663: fix target power parsing
      mt76: mt7615: fix delta tx power for mt7663
      mt76: mt7615: scan all channels if not specified
      mt76: mt7663u: copy key pointer in mt7663u_mac_write_txwi
      mt76: mt7663u: add missing register definitions
      mt76: mt7615: usb: cancel ps work stopping the vif
      mt76: mt7615: do not report scan_complete twice to mac80211
      mt76: mt7615: reduce hw scan timeout
      mt76: enable p2p support
      mt76: mt7615: fix typo defining ps work

Luca Coelho (8):
      iwlwifi: bump FW API to 55 for AX devices
      iwlwifi: mvm: initialize iwl_dev_tx_power_cmd to zero
      iwlwifi: mvm: add IML/ROM information to the assertion dumps
      iwlwifi: pcie: remove outdated comment about PCI RTPM reference
      iwlwifi: pcie: remove mangling for iwl_ax101_cfg_qu_hr
      iwlwifi: pcie: convert QnJ with Hr to the device table
      iwlwifi: pcie: remove occurrences of 22000 in the FW name defines
      iwlwifi: pcie: convert all AX101 devices to the device tables

Markus Elfring (1):
      mt76: mt7615: Delete an error message in mt7622_wmac_probe()

Matthew Garrett (1):
      mt76: mt76x02u: Add support for newer versions of the XBox One wifi adapter

Mordechay Goodstein (8):
      iwlwifi: yoyo: add support for parsing SHARED_MEM_ALLOC version 4
      iwlwifi: yoyo: use hweight_long instead of bit manipulating
      iwlwifi: yoyo: don't access TLV before verifying len
      iwlwifi: avoid debug max amsdu config overwriting itself
      iwlwifi: yoyo: add D3 resume timepoint
      iwlwifi: yoyo: remove magic number
      iwlwifi: dump api version in yaml format
      iwlwifi: tx: enable A-MSDU in low latency mode

Pali Rohár (2):
      ipw2x00: Fix comment for CLOCK_BOOTTIME constant
      mwifiex: Fix memory corruption in dump_station

Pawel Dembicki (1):
      mt76: mt76x0: pci: add mt7610 PCI ID

Ping-Ke Shih (9):
      rtw88: 8723d: Add LC calibration
      rtw88: 8723d: add IQ calibration
      rtw88: 8723d: Add power tracking
      rtw88: 8723d: Add shutdown callback to disable BT USB suspend
      rtw88: 8723d: implement flush queue
      rtw88: 8723d: set ltecoex register address in chip_info
      rtw88: 8723d: Add coex support
      rtw88: fill zeros to words 0x06 and 0x07 of security cam entry
      rtw88: 8723d: Add 8723DE to Kconfig and Makefile

Pramod Prakash (1):
      brcmfmac: fix 802.1d priority to ac mapping for pcie dongles

Ryder Lee (29):
      mt76: mt7615: modify mt7615_ampdu_stat_read for each phy
      mt76: mt7615: enable aggr_stats for both phy
      mt76: mt7615: cleanup mib related defines and structs
      mt76: mt7615: add more useful Tx mib counters
      mt76: avoid rx reorder buffer overflow
      mt76: add support for HE RX rate reporting
      mt76: add Rx stats support for radiotap
      mt76: adjust wcid size to support new 802.11ax generation
      mt76: add HE phy modes and hardware queue
      mt76: add mac80211 driver for MT7915 PCIe-based chipsets
      mt76: mt7915: enable Rx HE rate reporting
      mt76: mt7915: implement HE per-rate tx power support
      mt76: mt7915: register per-phy HE capabilities for each interface
      mt76: mt7915: add HE bss_conf support for interfaces
      mt76: mt7915: add HE capabilities support for peers
      mt76: mt7915: add Rx radiotap header support
      mt76: mt7915: add .sta_add_debugfs support
      mt76: mt7915: add .sta_statistics support
      mt76: mt7915: set peer Tx fixed rate through debugfs
      mt76: mt7915: add tsf related callbacks
      mt76: mt7915: enable firmware module debug support
      mt76: set runtime stream caps by mt76_phy
      mt76: mt7915: introduce mt7915_get_he_phy_cap
      mt76: mt7915: add Tx beamformer support
      mt76: mt7915: add Tx beamformee support
      mt76: mt7915: add TxBF capabilities
      mt76: mt7915: add debugfs to track TxBF status
      mt76: mt7915: allocate proper size for tlv tags
      mt76: mt7915: fix possible deadlock in mt7915_stop

Ryohei Kondo (1):
      brcmfmac: use actframe_abort to cancel ongoing action frame

Saravanan Shanmugham (1):
      brcmfmac: map 802.1d priority to precedence level based on AP WMM params

Sean Wang (12):
      mt76: mt7663: keep Rx filters as the default
      mt76: mt7615: introduce BSS absence event
      mt76: mt7615: remove unnecessary register operations
      mt76: mt7663: correct the name of the rom patch
      mt76: mt7615: make Kconfig entry obvious for MT7663E
      mt76: mt7663: fix up BMC entry indicated to unicmd firmware
      mt76: mt7615: introduce mt7615_mcu_set_hif_suspend mcu command
      mt76: mt7663u: introduce suspend/resume to mt7663u
      mt76: mt7663: introduce WoW with net detect support
      mt76: mt7663: add support to sched scan with randomise addr
      mt76: mt7663: fix the usage WoW with net detect support
      mt76: mt7615: configure bss info adding the interface

Shahar S Matityahu (1):
      iwlwifi: dbg: set debug descriptor to NULL outside of iwl_fw_free_dump_desc

Shaul Triebitz (1):
      iwlwifi: mvm: set properly station flags in STA_HE_CTXT_CMD

Soontak Lee (1):
      brcmfmac: Use seq/seq_len and set iv_initialize when plumbing of rxiv in (GTK) keys

Yan-Hsuan Chuang (2):
      rtw88: 8723d: fix sparse warnings for power tracking
      rtw88: rename rtw88.ko/rtwpci.ko to rtw88_core.ko/rtw88_pci.ko

YueHaibing (1):
      mt76: mt7915: Fix build error

Zong-Zhe Yang (6):
      rtw88: extract: export symbols used in chip functionalities
      rtw88: extract: export symbols about pci interface
      rtw88: extract: make 8822c an individual kernel module
      rtw88: extract: make 8822b an individual kernel module
      rtw88: extract: make 8723d an individual kernel module
      rtw88: extract: remove the unused after extracting

 .../bindings/net/wireless/mediatek,mt76.txt        |    3 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  265 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   24 +
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |    4 +
 .../broadcom/brcm80211/brcmfmac/flowring.c         |    4 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |   26 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |   23 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   38 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   17 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |    2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.h       |   12 +-
 drivers/net/wireless/intel/ipw2x00/libipw.h        |   28 +-
 drivers/net/wireless/intel/iwlegacy/commands.h     |   22 +-
 drivers/net/wireless/intel/iwlegacy/iwl-spectrum.h |    4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  104 +-
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h       |    3 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |   11 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |   11 +-
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |    5 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |   14 +-
 .../net/wireless/intel/iwlwifi/fw/api/location.h   |  110 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |   14 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   99 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |  104 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |   13 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |   55 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |    6 +-
 drivers/net/wireless/intel/iwlwifi/fw/smem.c       |   14 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   15 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   44 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   14 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h       |    7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |    7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h |    8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |    7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   34 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   11 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |   67 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   53 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   56 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   51 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   29 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  111 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |    5 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   32 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   19 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |   33 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   12 +-
 drivers/net/wireless/intersil/prism54/isl_oid.h    |    8 +-
 drivers/net/wireless/intersil/prism54/islpci_mgt.h |    2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   14 +-
 drivers/net/wireless/marvell/mwl8k.c               |    2 +-
 drivers/net/wireless/mediatek/mt76/Kconfig         |    1 +
 drivers/net/wireless/mediatek/mt76/Makefile        |    3 +-
 drivers/net/wireless/mediatek/mt76/agg-rx.c        |   12 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c       |   21 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   33 +-
 drivers/net/wireless/mediatek/mt76/mcu.c           |    9 +-
 drivers/net/wireless/mediatek/mt76/mmio.c          |    3 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   60 +-
 .../net/wireless/mediatek/mt76/mt7603/debugfs.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c |    5 +
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |    2 +
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   12 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.h    |    7 -
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c    |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/Kconfig  |   20 +-
 drivers/net/wireless/mediatek/mt76/mt7615/Makefile |   10 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |   47 +-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |   87 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |   87 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h |   33 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |  283 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  752 +++--
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |   39 +
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  331 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    | 1527 +++++++++-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |  293 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |   73 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |  177 +-
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |  132 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |  174 ++
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |  184 ++
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |  108 +-
 drivers/net/wireless/mediatek/mt76/mt7615/soc.c    |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |  446 +++
 .../net/wireless/mediatek/mt76/mt7615/usb_init.c   |  145 +
 .../net/wireless/mediatek/mt76/mt7615/usb_mcu.c    |   93 +
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |   26 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |    3 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |    3 +
 .../net/wireless/mediatek/mt76/mt76x02_debugfs.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |    7 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c   |    5 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h   |    6 -
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |   16 +
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |    4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |    4 +
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c |    5 +
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |    1 +
 .../net/wireless/mediatek/mt76/mt76x2/pci_main.c   |   21 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |    2 +
 drivers/net/wireless/mediatek/mt76/mt7915/Kconfig  |   13 +
 drivers/net/wireless/mediatek/mt76/mt7915/Makefile |    6 +
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |  463 +++
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |  285 ++
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |  243 ++
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |  125 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  701 +++++
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    | 1471 +++++++++
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |  346 +++
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |  833 ++++++
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    | 3161 ++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    | 1033 +++++++
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |  467 +++
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |  191 ++
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |  375 +++
 drivers/net/wireless/mediatek/mt76/tx.c            |    4 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |   15 +-
 drivers/net/wireless/mediatek/mt76/util.c          |    2 +-
 drivers/net/wireless/quantenna/qtnfmac/bus.h       |    2 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |   54 +-
 .../net/wireless/realtek/rtl818x/rtl8187/rtl8225.c |    4 -
 .../net/wireless/realtek/rtlwifi/rtl8192ee/phy.c   |   14 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |    8 +-
 drivers/net/wireless/realtek/rtw88/Kconfig         |   26 +-
 drivers/net/wireless/realtek/rtw88/Makefile        |   28 +-
 drivers/net/wireless/realtek/rtw88/bf.c            |    7 +
 drivers/net/wireless/realtek/rtw88/coex.c          |    3 +
 drivers/net/wireless/realtek/rtw88/debug.c         |    9 +-
 drivers/net/wireless/realtek/rtw88/efuse.c         |    1 +
 drivers/net/wireless/realtek/rtw88/fw.c            |    1 +
 drivers/net/wireless/realtek/rtw88/mac.c           |   30 +-
 drivers/net/wireless/realtek/rtw88/main.h          |   39 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |   49 +-
 drivers/net/wireless/realtek/rtw88/pci.h           |    4 -
 drivers/net/wireless/realtek/rtw88/phy.c           |   34 +-
 drivers/net/wireless/realtek/rtw88/phy.h           |    1 +
 drivers/net/wireless/realtek/rtw88/reg.h           |   11 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      | 1652 +++++++++-
 drivers/net/wireless/realtek/rtw88/rtw8723d.h      |  138 +
 drivers/net/wireless/realtek/rtw88/rtw8723de.c     |   30 +
 drivers/net/wireless/realtek/rtw88/rtw8723de.h     |   14 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |  124 +-
 drivers/net/wireless/realtek/rtw88/rtw8822be.c     |   30 +
 drivers/net/wireless/realtek/rtw88/rtw8822be.h     |   14 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   49 +-
 drivers/net/wireless/realtek/rtw88/rtw8822ce.c     |   30 +
 drivers/net/wireless/realtek/rtw88/rtw8822ce.h     |   14 +
 drivers/net/wireless/realtek/rtw88/rx.c            |    1 +
 drivers/net/wireless/realtek/rtw88/sec.c           |    6 +-
 drivers/net/wireless/realtek/rtw88/util.c          |   20 +-
 drivers/net/wireless/rndis_wlan.c                  |   32 +-
 159 files changed, 17363 insertions(+), 1911 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/usb.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/usb_init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/usb_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/Makefile
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/main.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/pci.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/regs.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723de.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723de.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822be.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822be.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822ce.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822ce.h
