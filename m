Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD27266220
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgIKP2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:28:23 -0400
Received: from a27-11.smtp-out.us-west-2.amazonses.com ([54.240.27.11]:47014
        "EHLO a27-11.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgIKP1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:27:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gbvhytky6xpx7itkhb67ktsxbiwpnxix; d=codeaurora.org; t=1599838034;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:From:Subject:To:Cc:Message-Id:Date;
        bh=psoPRl1Gm8dqvPxbRcYJNQYJoHbqIujWmJaTfkmN40s=;
        b=Ar3yZ/cz+4l5BK4qt2mblqItzmU+fmxFfjStkrJzkbZncbbuy1hyQjlk4qGBBu61
        NAKfJVxG1abY4hJM+QgbmZXw+FQMUQGIQHHxzMLts+xna+nTfAmIMvE/X1dobb0gRIq
        th1Xo3fELL+gaN8ulQI1TUakPP1DQOQBM/ZoLZBM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599838034;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:From:Subject:To:Cc:Message-Id:Date:Feedback-ID;
        bh=psoPRl1Gm8dqvPxbRcYJNQYJoHbqIujWmJaTfkmN40s=;
        b=QgKoyW26lzPLCyh4t1rA/9I8DPIrHc5exBfJxF/IKXfOYMYN4UgLk3R6eaC3h2FC
        /ugBFcddCUuC5S+pofh1aejOFXdWob5RWvusw0vbE6SUiAetBqs0g9Qn7t35EmEinTq
        BZemh/8tOBE7pyU3+g2uZTobh03GpOJs95qx+5mU=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 75B82C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2020-09-11
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-ID: <010101747dc71664-6f75120f-bb39-4a59-b278-cf35faef8c2e-000000@us-west-2.amazonses.com>
Date:   Fri, 11 Sep 2020 15:27:13 +0000
X-SES-Outgoing: 2020.09.11-54.240.27.11
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 9123e3a74ec7b934a4a099e98af6a61c2f80bbf5:

  Linux 5.9-rc1 (2020-08-16 13:04:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2020-09-11

for you to fetch changes up to 5941d003f0a60877a956cc3cae6e3850b46fad0a:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2020-09-11 18:03:00 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.10

First set of patches for v5.10. Most noteworthy here is ath11k getting
initial support for QCA6390 and IPQ6018 devices. But most of the
patches are cleanup: W=1 warning fixes, fallthrough keywords, DMA API
changes and tasklet API changes.

Major changes:

ath10k

* support SDIO firmware codedumps

* support station specific TID configurations

ath11k

* add support for IPQ6018

* add support for QCA6390 PCI devices

ath9k

* add support for NL80211_EXT_FEATURE_CAN_REPLACE_PTK0 to improve PTK0
  rekeying

wcn36xx

* add support for TX ack

----------------------------------------------------------------
Alex Dewar (1):
      ath11k: return error if firmware request fails

Alexander A. Klimov (2):
      ath9k: Replace HTTP links with HTTPS ones
      ath5k: Replace HTTP links with HTTPS ones

Alexander Wetzel (1):
      ath9k: add NL80211_EXT_FEATURE_CAN_REPLACE_PTK0 support

Allen Pais (17):
      ath5k: convert tasklets to use new tasklet_setup() API
      ath9k: convert tasklets to use new tasklet_setup() API
      carl9170: convert tasklets to use new tasklet_setup() API
      atmel: convert tasklets to use new tasklet_setup() API
      b43legacy: convert tasklets to use new tasklet_setup() API
      brcmsmac: convert tasklets to use new tasklet_setup() API
      ipw2x00: convert tasklets to use new tasklet_setup() API
      iwlegacy: convert tasklets to use new tasklet_setup() API
      intersil: convert tasklets to use new tasklet_setup() API
      mwl8k: convert tasklets to use new tasklet_setup() API
      qtnfmac: convert tasklets to use new tasklet_setup() API
      rt2x00: convert tasklets to use new tasklet_setup() API
      rtlwifi/rtw88: convert tasklets to use new tasklet_setup() API
      zd1211rw: convert tasklets to use new tasklet_setup() API
      ath11k: convert tasklets to use new tasklet_setup() API
      zd1211rw: fix build warning
      rtlwifi: fix build warning

Andy Shevchenko (1):
      brcmfmac: use %*ph to print small buffer

Anilkumar Kolli (11):
      ath11k: update firmware files read path
      ath11k: rename default board file
      ath11k: ahb: call ath11k_core_init() before irq configuration
      ath11k: convert ath11k_hw_params to an array
      ath11k: define max_radios in hw_params
      ath11k: add hw_ops for pdev id to hw_mac mapping
      ath11k: Add bdf-addr in hw_params
      dt: bindings: net: update compatible for ath11k
      ath11k: move target ce configs to hw_params
      ath11k: add ipq6018 support
      ath11k: remove calling ath11k_init_hw_params() second time

Bolarinwa Olayemi Saheed (1):
      ath9k: Check the return value of pcie_capability_read_*()

Brian Norris (2):
      rtw88: don't treat NULL pointer as an array
      rtw88: use read_poll_timeout_atomic() for poll loop

Bryan O'Donoghue (9):
      wcn36xx: Fix reported 802.11n rx_highest rate wcn3660/wcn3680
      wcn36xx: Add a chip identifier for WCN3680
      wcn36xx: Hook and identify RF_IRIS_WCN3680
      wcn36xx: Add 802.11ac MCS rates
      wcn36xx: Specify ieee80211_rx_status.nss
      wcn36xx: Add 802.11ac HAL param bitfields
      wcn36xx: Add Supported rates V1 structure
      wcn36xx: Use existing pointers in wcn36xx_smd_config_bss_v1
      wcn36xx: Set feature DOT11AC for wcn3680

Carl Huang (24):
      ath11k: do not depend on ARCH_QCOM for ath11k
      ath11k: add hw_params entry for QCA6390
      ath11k: allocate smaller chunks of memory for firmware
      ath11k: fix memory OOB access in qmi_decode
      ath11k: fix KASAN warning of ath11k_qmi_wlanfw_wlan_cfg_send
      ath11k: enable internal sleep clock
      ath11k: hal: create register values dynamically
      ath11k: ce: support different CE configurations
      ath11k: hal: assign msi_addr and msi_data to srng
      ath11k: ce: get msi_addr and msi_data before srng setup
      ath11k: disable CE interrupt before hif start
      ath11k: force single pdev only for QCA6390
      ath11k: initialize wmi config based on hw_params
      ath11k: wmi: put hardware to DBS mode
      ath11k: dp: redefine peer_map and peer_unmap
      ath11k: enable DP interrupt setup for QCA6390
      ath11k: don't initialize rxdma1 related ring
      ath11k: setup QCA6390 rings for both rxdmas
      ath11k: refine the phy_id check in ath11k_reg_chan_list_event
      ath11k: delay vdev_start for QCA6390
      ath11k: assign correct search flag and type for QCA6390
      ath11k: process both lmac rings for QCA6390
      ath11k: use TCL_DATA_RING_0 for QCA6390
      ath11k: reset MHI during power down and power up

Chris Chiu (1):
      rtl8xxxu: prevent potential memory leak

Christophe JAILLET (8):
      ath10k: Fix the size used in a 'dma_free_coherent()' call in an error handling path
      adm8211: switch from 'pci_' to 'dma_' API
      mwifiex: Do not use GFP_KERNEL in atomic context
      mwifiex: switch from 'pci_' to 'dma_' API
      mwifiex: Clean up some err and dbg messages
      rtw88: switch from 'pci_' to 'dma_' API
      rtl818x_pci: switch from 'pci_' to 'dma_' API
      rtlwifi: switch from 'pci_' to 'dma_' API

Colin Ian King (5):
      ath6kl: fix spelling mistake "initilisation" -> "initialization"
      wl1251, wlcore: fix spelling mistake "buld" -> "build"
      rtw88: fix spelling mistake: "unsupport" -> "unsupported"
      ath11k: fix spelling mistake "moniter" -> "monitor"
      ath11k: fix missing error check on call to ath11k_pci_get_user_msi_assignment

Dan Carpenter (5):
      ath6kl: prevent potential array overflow in ath6kl_add_new_sta()
      ath9k: Fix potential out of bounds in ath9k_htc_txcompletion_cb()
      ath11k: return -ENOMEM on allocation failure
      ath11k: fix uninitialized return in ath11k_spectral_process_data()
      rtlwifi: rtl8723ae: Delete a stray tab

Dinghao Liu (2):
      wilc1000: Fix memleak in wilc_sdio_probe
      wilc1000: Fix memleak in wilc_bus_probe

Dmitry Osipenko (3):
      brcmfmac: increase F2 watermark for BCM4329
      brcmfmac: drop chip id from debug messages
      brcmfmac: set F2 SDIO block size to 128 bytes for BCM4329

Douglas Anderson (3):
      ath10k: Wait until copy complete is actually done before completing
      ath10k: Keep track of which interrupts fired, don't poll them
      ath10k: Get rid of "per_ce_irq" hw param

Govind Singh (12):
      ath11k: add simple PCI client driver for QCA6390 chipset
      ath11k: pci: setup resources
      ath11k: pci: add MSI config initialisation
      ath11k: register MHI controller device for QCA6390
      ath11k: pci: add HAL, CE and core initialisation
      ath11k: use remoteproc only with AHB devices
      ath11k: add support for m3 firmware
      ath11k: add board file support for PCI devices
      ath11k: fill appropriate QMI service instance id for QCA6390
      ath11k: pci: add read32() and write32() hif operations
      ath11k: configure copy engine msi address in CE srng
      ath11k: setup ce tasklet for control path

Gustavo A. R. Silva (19):
      ath9k: Use fallthrough pseudo-keyword
      ath5k: Use fallthrough pseudo-keyword
      ath6kl: Use fallthrough pseudo-keyword
      ath10k: Use fallthrough pseudo-keyword
      ath11k: Use fallthrough pseudo-keyword
      mwifiex: Use fallthrough pseudo-keyword
      rtw88: Use fallthrough pseudo-keyword
      carl9170: Use fallthrough pseudo-keyword
      rt2x00: Use fallthrough pseudo-keyword
      prism54: Use fallthrough pseudo-keyword
      orinoco: Use fallthrough pseudo-keyword
      brcmfmac: Use fallthrough pseudo-keyword
      iwlegacy: Use fallthrough pseudo-keyword
      b43: Use fallthrough pseudo-keyword
      b43legacy: Use fallthrough pseudo-keyword
      atmel: Use fallthrough pseudo-keyword
      ath10k: wmi: Use struct_size() helper in ath10k_wmi_alloc_skb()
      rtlwifi: Use fallthrough pseudo-keyword
      mt7601u: Use fallthrough pseudo-keyword

Jia-Ju Bai (1):
      p54: avoid accessing the data mapped to streaming DMA

Julia Lawall (1):
      ath: drop unnecessary list_empty

Kalle Valo (17):
      ath11k: create a common function to request all firmware files
      ath11k: don't use defines for hw specific firmware directories
      ath11k: change ath11k_core_fetch_board_data_api_n() to use ath11k_core_create_firmware_path()
      ath11k: remove useless info messages
      ath11k: qmi: cleanup info messages
      ath11k: don't use defines in hw_params
      ath11k: remove define ATH11K_QMI_DEFAULT_CAL_FILE_NAME
      ath11k: move ring mask definitions to hw_params
      ath11k: implement ath11k_core_pre_init()
      ath11k: hal: create hw_srng_config dynamically
      ath10k: move enable_pll_clk call to ath10k_core_start()
      ath11k: hal: cleanup dynamic register macros
      ath11k: ce: remove host_ce_config_wlan macro
      ath11k: ce: remove CE_COUNT() macro
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      ath11k: fix link error when CONFIG_REMOTEPROC is disabled
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Keita Suzuki (1):
      brcmsmac: fix memory leak in wlc_phy_attach_lcnphy

Krzysztof Kozlowski (2):
      ath9k_htc: Do not select MAC80211_LEDS by default
      ath9k: Do not select MAC80211_LEDS by default

Larry Finger (15):
      rtlwifi: Start changing RT_TRACE into rtl_dbg
      rtlwifi: Replace RT_TRACE with rtl_dbg
      rtlwifi: btcoexist: Replace RT_TRACE with rtl_dbg
      rtlwifi: rtl8188ee: Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8192-common: Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8192ce: Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8192cu: Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8192de: Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8192ee: Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8192se Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8723ae Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8723be Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8723-common: Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8821ae: Rename RT_TRACE to rtl_dbg
      rtlwifi: Remove temporary definition of RT_TRACE

Lee Jones (89):
      ath5k: pcu: Add a description for 'band' remove one for 'mode'
      wil6210: Demote non-kerneldoc headers to standard comment blocks
      ath5k: Fix kerneldoc formatting issue
      ath6kl: wmi: Remove unused variable 'rate'
      ath9k: ar9002_initvals: Remove unused array 'ar9280PciePhy_clkreq_off_L1_9280'
      ath9k: ar9001_initvals: Remove unused array 'ar5416Bank6_9100'
      ath9k: ar5008_initvals: Remove unused table entirely
      ath9k: ar5008_initvals: Move ar5416Bank{0,1,2,3,7} to where they are used
      wil6210: debugfs: Fix a couple of formatting issues in 'wil6210_debugfs_init'
      atmel: Demote non-kerneldoc header to standard comment block
      b43: main: Add braces around empty statements
      airo: Place brackets around empty statement
      airo: Fix a myriad of coding style issues
      iwlegacy: common: Remove set but not used variable 'len'
      iwlegacy: common: Demote kerneldoc headers to standard comment blocks
      ipw2200: Remove set but unused variables 'rc' and 'w'
      b43legacy: main: Provide braces around empty 'if' body
      brcmfmac: fweh: Remove set but unused variable 'err'
      brcmfmac: fweh: Fix docrot related function documentation issues
      brcmsmac: mac80211_if: Demote a few non-conformant kerneldoc headers
      ipw2200: Demote lots of nonconformant kerneldoc comments
      b43: phy_common: Demote non-conformant kerneldoc header
      b43: phy_n: Add empty braces around empty statements
      wil6210: wmi: Fix formatting and demote non-conforming function headers
      wil6210: interrupt: Demote comment header which is clearly not kernel-doc
      wil6210: txrx: Demote obvious abuse of kernel-doc
      wil6210: txrx_edma: Demote comments which are clearly not kernel-doc
      wil6210: pmc: Demote a few nonconformant kernel-doc function headers
      wil6210: wil_platform: Demote kernel-doc header to standard comment block
      carl9170: Convert 'ar9170_qmap' to inline function
      hostap: Mark 'freq_list' as __maybe_unused
      rsi: Fix some kernel-doc issues
      rsi: File header should not be kernel-doc
      libertas_tf: Demote non-conformant kernel-doc headers
      wlcore: cmd: Fix some parameter description disparities
      libertas_tf: Fix a bunch of function doc formatting issues
      iwlegacy: debug: Demote seemingly unintentional kerneldoc header
      hostap: hostap_ap: Mark 'txt' as __always_unused
      cw1200: wsm: Remove 'dummy' variables
      libertas: Fix 'timer_list' stored private data related dot-rot
      mt7601u: phy: Fix misnaming when documented function parameter 'dac'
      rsi: Fix misnamed function parameter 'rx_pkt'
      rsi: Fix a few kerneldoc misdemeanours
      rsi: Fix a myriad of documentation issues
      rsi: File header comments should not be kernel-doc
      iwlegacy: 4965: Demote a bunch of nonconformant kernel-doc headers
      brcmfmac: p2p: Deal with set but unused variables
      libertas: Fix misnaming for function param 'device'
      libertas_tf: Fix function documentation formatting errors
      hostap: Remove set but unused variable 'hostscan'
      rsi: Add description for function param 'sta'
      brcmsmac: ampdu: Remove a bunch of unused variables
      brcmfmac: p2p: Fix a bunch of function docs
      rsi: Add descriptions for rsi_set_vap_capabilities()'s parameters
      brcmsmac: main: Remove a bunch of unused variables
      rsi: Source file headers do not make good kernel-doc candidates
      brcmfmac: firmware: Demote seemingly unintentional kernel-doc header
      rsi: File headers are not suitable for kernel-doc
      iwlegacy: 4965-mac: Convert function headers to standard comment blocks
      brcmfmac: btcoex: Update 'brcmf_btcoex_state' and demote others
      b43: phy_ht: Remove 9 year old TODO
      rsi: Source file headers are not suitable for kernel-doc
      iwlegacy: 4965-rs: Demote non kernel-doc headers to standard comment blocks
      iwlegacy: 4965-calib: Demote seemingly accidental kernel-doc header
      brcmfmac: fwsignal: Remove unused variable 'brcmf_fws_prio2fifo'
      rtlwifi: rtl8192c: phy_common: Remove unused variable 'bbvalue'
      mwifiex: pcie: Move tables to the only place they're used
      brcmsmac: ampdu: Remove a couple set but unused variables
      iwlegacy: 3945-mac: Remove all non-conformant kernel-doc headers
      iwlegacy: 3945-rs: Remove all non-conformant kernel-doc headers
      iwlegacy: 3945: Remove all non-conformant kernel-doc headers
      brcmfmac: p2p: Fix a couple of function headers
      orinoco_usb: Downgrade non-conforming kernel-doc headers
      brcmsmac: phy_cmn: Remove a unused variables 'vbat' and 'temp'
      zd1211rw: zd_chip: Fix formatting
      zd1211rw: zd_mac: Add missing or incorrect function documentation
      zd1211rw: zd_chip: Correct misspelled function argument
      brcmfmac: fwsignal: Finish documenting 'brcmf_fws_mac_descriptor'
      wlcore: debugfs: Remove unused variable 'res'
      rsi: rsi_91x_sdio: Fix a few kernel-doc related issues
      hostap: Remove unused variable 'fc'
      wl3501_cs: Fix a bunch of formatting issues related to function docs
      rtw88: debug: Remove unused variables 'val'
      rsi: rsi_91x_sdio_ops: File headers are not good kernel-doc candidates
      prism54: isl_ioctl: Remove unused variable 'j'
      brcmsmac: phy_lcn: Remove a bunch of unused variables
      brcmsmac: phy_n: Remove a bunch of unused variables
      brcmsmac: phytbl_lcn: Remove unused array 'dot11lcnphytbl_rx_gain_info_rev1'
      brcmsmac: phytbl_n: Remove a few unused arrays

Loic Poulain (10):
      wcn36xx: Add ieee80211 rx status rate information
      wcn36xx: Fix multiple AMPDU sessions support
      wcn36xx: Add TX ack support
      wcn36xx: Increase number of TX retries
      wcn36xx: Fix TX data path
      wcn36xx: Use sequence number allocated by mac80211
      wcn36xx: Fix software-driven scan
      wcn36xx: Setup starting bitrate to MCS-5
      wcn36xx: Disable bmps when encryption is disabled
      wcn36xx: Fix warning due to bad rate_idx

Masashi Honma (1):
      ath9k_htc: Use appropriate rs_datalen type

Nathan Chancellor (1):
      mwifiex: Remove unnecessary braces from HostCmd_SET_SEQ_NO_BSS_INFO

Pavel Machek (1):
      ath9k: Fix typo in function name

Rakesh Pillai (4):
      ath10k: Register shutdown handler
      ath10k: Add interrupt summary based CE processing
      dt: bindings: Add new regulator as optional property for WCN3990
      ath10k: Add support for chain1 regulator supply voting

Sathishkumar Muruganandam (1):
      ath10k: fix VHT NSS calculation when STBC is enabled

Tamizh Chelvam (5):
      ath10k: Add wmi command support for station specific TID config
      ath10k: Move rate mask validation function up in the file
      ath10k: Add new api to support TID specific configuration
      ath10k: Add new api to support reset TID config
      ath11k: Add peer max mpdu parameter in peer assoc command

Tetsuo Handa (1):
      mwifiex: don't call del_timer_sync() on uninitialized timer

Tom Rix (4):
      brcmfmac: check ndev pointer
      rndis_wlan: tighten check of rndis_query_oid return
      ath11k: fix a double free and a memory leak
      mwifiex: remove function pointer check

Tzu-En Huang (1):
      rtw88: fix compile warning: [-Wignored-qualifiers]

Venkateswara Naralasetty (3):
      ath10k: fix retry packets update in station dump
      ath10k: provide survey info as accumulated data
      ath11k: add raw mode and software crypto support

Wang Yufen (2):
      ath11k: Fix possible memleak in ath11k_qmi_init_service
      brcm80211: fix possible memleak in brcmf_proto_msgbuf_attach

Wen Gong (7):
      ath10k: start recovery process when payload length exceeds max htc length for sdio
      ath10k: add wmi service peer stat info for wmi tlv
      ath10k: remove return for NL80211_STA_INFO_TX_BITRATE
      ath10k: enable supports_peer_stats_info for QCA6174 PCI devices
      ath10k: correct the array index from mcs index for HT mode for QCA6174
      ath10k: add bus type for each layout of coredump
      ath10k: sdio: add firmware coredump support

YueHaibing (5):
      libertas_tf: Remove unused macro QOS_CONTROL_LEN
      mwifiex: wmm: Fix -Wunused-const-variable warnings
      mwifiex: sdio: Fix -Wunused-const-variable warnings
      ath11k: Remove unused inline function htt_htt_stats_debug_dump()
      ath10k: Remove unused macro ATH10K_ROC_TIMEOUT_HZ

Zekun Shen (2):
      ath10k: pci: fix memcpy size of bmi response
      ath10k: check idx validity in __ath10k_htt_rx_ring_fill_n()

Zong-Zhe Yang (1):
      rtw88: 8822c: update tx power limit tables to RF v20.1

 .../bindings/net/wireless/qcom,ath10k.txt          |   4 +-
 .../bindings/net/wireless/qcom,ath11k.yaml         |   4 +-
 drivers/net/wireless/admtek/adm8211.c              |  83 +-
 drivers/net/wireless/ath/ath10k/bmi.c              |  10 +-
 drivers/net/wireless/ath/ath10k/ce.c               |  81 +-
 drivers/net/wireless/ath/ath10k/ce.h               |  15 +-
 drivers/net/wireless/ath/ath10k/core.c             |  37 +-
 drivers/net/wireless/ath/ath10k/core.h             |  20 +
 drivers/net/wireless/ath/ath10k/coredump.c         | 349 +++++++-
 drivers/net/wireless/ath/ath10k/coredump.h         |   1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c           |  26 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |   6 +-
 drivers/net/wireless/ath/ath10k/hw.h               |   3 -
 drivers/net/wireless/ath/ath10k/mac.c              | 925 ++++++++++++++++---
 drivers/net/wireless/ath/ath10k/pci.c              |   2 +-
 drivers/net/wireless/ath/ath10k/sdio.c             | 331 ++++++-
 drivers/net/wireless/ath/ath10k/snoc.c             |  29 +-
 drivers/net/wireless/ath/ath10k/snoc.h             |   1 +
 drivers/net/wireless/ath/ath10k/targaddrs.h        |  11 +
 drivers/net/wireless/ath/ath10k/txrx.c             |  11 +-
 drivers/net/wireless/ath/ath10k/wmi-ops.h          |  19 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |   2 +
 drivers/net/wireless/ath/ath10k/wmi.c              |  71 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |  76 ++
 drivers/net/wireless/ath/ath10k/wow.c              |   2 +-
 drivers/net/wireless/ath/ath11k/Kconfig            |  18 +-
 drivers/net/wireless/ath/ath11k/Makefile           |  10 +-
 drivers/net/wireless/ath/ath11k/ahb.c              | 412 ++-------
 drivers/net/wireless/ath/ath11k/ce.c               | 144 ++-
 drivers/net/wireless/ath/ath11k/ce.h               |  12 +-
 drivers/net/wireless/ath/ath11k/core.c             | 268 ++++--
 drivers/net/wireless/ath/ath11k/core.h             |  75 +-
 drivers/net/wireless/ath/ath11k/dbring.c           |   2 +-
 drivers/net/wireless/ath/ath11k/debug.c            |  46 +-
 drivers/net/wireless/ath/ath11k/debug.h            |   3 +
 drivers/net/wireless/ath/ath11k/debug_htt_stats.c  |  44 -
 drivers/net/wireless/ath/ath11k/dp.c               | 216 ++++-
 drivers/net/wireless/ath/ath11k/dp.h               |  13 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            | 226 +++--
 drivers/net/wireless/ath/ath11k/dp_tx.c            | 104 ++-
 drivers/net/wireless/ath/ath11k/hal.c              | 169 ++--
 drivers/net/wireless/ath/ath11k/hal.h              | 179 ++--
 drivers/net/wireless/ath/ath11k/hal_rx.c           |  10 +-
 drivers/net/wireless/ath/ath11k/hal_tx.c           |   2 +-
 drivers/net/wireless/ath/ath11k/hif.h              |  30 +
 drivers/net/wireless/ath/ath11k/htc.c              |   4 +-
 drivers/net/wireless/ath/ath11k/hw.c               | 890 ++++++++++++++++++
 drivers/net/wireless/ath/ath11k/hw.h               | 146 ++-
 drivers/net/wireless/ath/ath11k/mac.c              | 187 +++-
 drivers/net/wireless/ath/ath11k/mhi.c              | 467 ++++++++++
 drivers/net/wireless/ath/ath11k/mhi.h              |  39 +
 drivers/net/wireless/ath/ath11k/pci.c              | 995 +++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/pci.h              |  65 ++
 drivers/net/wireless/ath/ath11k/peer.c             |   3 -
 drivers/net/wireless/ath/ath11k/qmi.c              | 334 +++++--
 drivers/net/wireless/ath/ath11k/qmi.h              |  27 +-
 drivers/net/wireless/ath/ath11k/reg.c              |   2 +-
 drivers/net/wireless/ath/ath11k/spectral.c         |  10 +-
 drivers/net/wireless/ath/ath11k/wmi.c              | 107 ++-
 drivers/net/wireless/ath/ath5k/ath5k.h             |   2 +-
 drivers/net/wireless/ath/ath5k/base.c              |  26 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |   4 +-
 drivers/net/wireless/ath/ath5k/pcu.c               |   6 +-
 drivers/net/wireless/ath/ath5k/phy.c               |   6 +-
 drivers/net/wireless/ath/ath5k/reset.c             |   2 +-
 drivers/net/wireless/ath/ath5k/rfbuffer.h          |   2 +-
 drivers/net/wireless/ath/ath5k/rfkill.c            |   7 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   6 +-
 drivers/net/wireless/ath/ath6kl/init.c             |   2 +-
 drivers/net/wireless/ath/ath6kl/main.c             |   5 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |  10 +-
 drivers/net/wireless/ath/ath9k/Kconfig             |  12 +-
 drivers/net/wireless/ath/ath9k/ani.c               |   2 +-
 drivers/net/wireless/ath/ath9k/ar5008_initvals.h   |  68 --
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |  35 +-
 drivers/net/wireless/ath/ath9k/ar9001_initvals.h   |  37 -
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h   |  14 -
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |   2 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |   2 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |   2 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |   4 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |   4 +-
 drivers/net/wireless/ath/ath9k/channel.c           |   4 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c        |   2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   2 +-
 drivers/net/wireless/ath/ath9k/htc.h               |   4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   8 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  10 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   2 +
 drivers/net/wireless/ath/ath9k/hw.c                |   6 +-
 drivers/net/wireless/ath/ath9k/init.c              |   6 +-
 drivers/net/wireless/ath/ath9k/main.c              |  18 +-
 drivers/net/wireless/ath/ath9k/pci.c               |   5 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |   9 +-
 drivers/net/wireless/ath/ath9k/wmi.h               |   4 +-
 drivers/net/wireless/ath/carl9170/carl9170.h       |   5 +-
 drivers/net/wireless/ath/carl9170/main.c           |   2 +-
 drivers/net/wireless/ath/carl9170/rx.c             |   2 +-
 drivers/net/wireless/ath/carl9170/tx.c             |  12 +-
 drivers/net/wireless/ath/carl9170/usb.c            |   7 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c    |  15 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |  57 +-
 drivers/net/wireless/ath/wcn36xx/hal.h             |  84 +-
 drivers/net/wireless/ath/wcn36xx/main.c            | 189 ++--
 drivers/net/wireless/ath/wcn36xx/pmc.c             |   5 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             | 172 ++--
 drivers/net/wireless/ath/wcn36xx/smd.h             |  12 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c            | 279 +++++-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |   9 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |   4 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |   8 +-
 drivers/net/wireless/ath/wil6210/interrupt.c       |   4 +-
 drivers/net/wireless/ath/wil6210/pmc.c             |  12 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |  30 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c       |  10 +-
 drivers/net/wireless/ath/wil6210/wil_platform.c    |   3 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |  36 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |  11 +-
 drivers/net/wireless/atmel/atmel.c                 |   4 +-
 drivers/net/wireless/broadcom/b43/dma.c            |   2 +-
 drivers/net/wireless/broadcom/b43/main.c           |  14 +-
 drivers/net/wireless/broadcom/b43/phy_common.c     |   2 +-
 drivers/net/wireless/broadcom/b43/phy_ht.c         |   3 -
 drivers/net/wireless/broadcom/b43/phy_n.c          |  21 +-
 drivers/net/wireless/broadcom/b43/pio.c            |   2 +-
 drivers/net/wireless/broadcom/b43/tables_nphy.c    |   2 +-
 drivers/net/wireless/broadcom/b43legacy/dma.c      |   2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |  15 +-
 drivers/net/wireless/broadcom/b43legacy/pio.c      |   7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |   6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/btcoex.c  |  12 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |  13 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |  20 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   2 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  31 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   7 +-
 .../wireless/broadcom/brcm80211/brcmsmac/ampdu.c   |  35 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |  17 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.h      |   2 +-
 .../wireless/broadcom/brcm80211/brcmsmac/main.c    |  38 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_cmn.c      |   6 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |  44 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |  47 +-
 .../broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c   |  13 -
 .../broadcom/brcm80211/brcmsmac/phy/phytbl_n.c     | 268 ------
 drivers/net/wireless/cisco/airo.c                  | 898 ++++++++++---------
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |   9 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |  52 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |  34 +-
 drivers/net/wireless/intel/iwlegacy/3945-rs.c      |   8 +-
 drivers/net/wireless/intel/iwlegacy/3945.c         |  46 +-
 drivers/net/wireless/intel/iwlegacy/4965-calib.c   |   2 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |  67 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |  10 +-
 drivers/net/wireless/intel/iwlegacy/4965.c         |  25 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |  76 +-
 drivers/net/wireless/intel/iwlegacy/debug.c        |   3 +-
 drivers/net/wireless/intersil/hostap/hostap.h      |   6 +-
 drivers/net/wireless/intersil/hostap/hostap_ap.c   |   2 +-
 drivers/net/wireless/intersil/hostap/hostap_hw.c   |  21 +-
 .../net/wireless/intersil/hostap/hostap_ioctl.c    |   3 +-
 drivers/net/wireless/intersil/orinoco/main.c       |  11 +-
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |  14 +-
 drivers/net/wireless/intersil/p54/p54pci.c         |  12 +-
 drivers/net/wireless/intersil/prism54/isl_38xx.c   |   2 +-
 drivers/net/wireless/intersil/prism54/isl_ioctl.c  |   5 +-
 drivers/net/wireless/intersil/prism54/islpci_dev.c |   2 +-
 drivers/net/wireless/marvell/libertas/firmware.c   |   4 +-
 drivers/net/wireless/marvell/libertas/main.c       |   6 +-
 drivers/net/wireless/marvell/libertas_tf/cmd.c     |  22 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |  37 +-
 drivers/net/wireless/marvell/libertas_tf/main.c    |   7 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   8 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |   4 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |   8 +-
 drivers/net/wireless/marvell/mwifiex/ie.c          |   2 +-
 drivers/net/wireless/marvell/mwifiex/init.c        |  14 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |   2 +
 drivers/net/wireless/marvell/mwifiex/pcie.c        | 323 +++++--
 drivers/net/wireless/marvell/mwifiex/pcie.h        | 149 ---
 drivers/net/wireless/marvell/mwifiex/scan.c        |   4 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        | 427 +++++++++
 drivers/net/wireless/marvell/mwifiex/sdio.h        | 427 ---------
 drivers/net/wireless/marvell/mwifiex/usb.c         |   3 +-
 drivers/net/wireless/marvell/mwifiex/wmm.c         |  15 +
 drivers/net/wireless/marvell/mwifiex/wmm.h         |  18 +-
 drivers/net/wireless/marvell/mwl8k.c               |  16 +-
 drivers/net/wireless/mediatek/mt7601u/dma.c        |   4 +-
 drivers/net/wireless/mediatek/mt7601u/mac.c        |   4 +-
 drivers/net/wireless/mediatek/mt7601u/phy.c        |   4 +-
 drivers/net/wireless/microchip/wilc1000/sdio.c     |   5 +-
 drivers/net/wireless/microchip/wilc1000/spi.c      |   5 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   |   7 +-
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   |   7 +-
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c     |  16 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c     |  16 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |  42 +-
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c    |  25 +-
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.h    |  10 +-
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c     |   1 -
 drivers/net/wireless/ralink/rt2x00/rt2x00.h        |  10 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |   5 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |  23 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.c       |   1 -
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |  70 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  10 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        | 146 +--
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 712 +++++++--------
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 354 ++++----
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 720 +++++++--------
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 668 +++++++-------
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 756 ++++++++--------
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |  28 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |   6 +-
 drivers/net/wireless/realtek/rtlwifi/cam.c         |  82 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        | 263 +++---
 drivers/net/wireless/realtek/rtlwifi/debug.c       |  10 +-
 drivers/net/wireless/realtek/rtlwifi/debug.h       |  14 +-
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |  72 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         | 419 +++++----
 drivers/net/wireless/realtek/rtlwifi/ps.c          |  98 +-
 drivers/net/wireless/realtek/rtlwifi/regd.c        |  18 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/dm.c    | 192 ++--
 .../net/wireless/realtek/rtlwifi/rtl8188ee/fw.c    |  90 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    | 203 +++--
 .../net/wireless/realtek/rtlwifi/rtl8188ee/led.c   |  20 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.c   | 385 ++++----
 .../net/wireless/realtek/rtlwifi/rtl8188ee/rf.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |  37 +-
 .../wireless/realtek/rtlwifi/rtl8192c/dm_common.c  | 224 ++---
 .../wireless/realtek/rtlwifi/rtl8192c/fw_common.c  |  88 +-
 .../wireless/realtek/rtlwifi/rtl8192c/phy_common.c | 261 +++---
 .../net/wireless/realtek/rtlwifi/rtl8192ce/dm.c    |  40 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    | 176 ++--
 .../net/wireless/realtek/rtlwifi/rtl8192ce/led.c   |  12 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/phy.c   | 121 ++-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/rf.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |  28 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/dm.c    |  38 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    | 152 ++--
 .../net/wireless/realtek/rtlwifi/rtl8192cu/led.c   |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/mac.c   |  64 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/phy.c   | 134 +--
 .../net/wireless/realtek/rtlwifi/rtl8192cu/rf.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   |  58 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/dm.c    | 312 +++----
 .../net/wireless/realtek/rtlwifi/rtl8192de/fw.c    | 116 +--
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    | 206 ++---
 .../net/wireless/realtek/rtlwifi/rtl8192de/led.c   |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   | 414 ++++-----
 .../net/wireless/realtek/rtlwifi/rtl8192de/rf.c    |  30 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |  32 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/dm.c    |  66 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    | 102 +--
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    | 208 ++---
 .../net/wireless/realtek/rtlwifi/rtl8192ee/led.c   |  18 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/phy.c   | 358 ++++----
 .../net/wireless/realtek/rtlwifi/rtl8192ee/rf.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |  45 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/dm.c    |  42 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/fw.c    |  40 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    | 157 ++--
 .../net/wireless/realtek/rtlwifi/rtl8192se/led.c   |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/phy.c   | 211 +++--
 .../net/wireless/realtek/rtlwifi/rtl8192se/rf.c    |  70 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/sw.c    |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/trx.c   |  22 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/dm.c    | 162 ++--
 .../net/wireless/realtek/rtlwifi/rtl8723ae/fw.c    |  64 +-
 .../realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c     | 150 ++--
 .../wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c   | 647 +++++++-------
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    | 232 ++---
 .../net/wireless/realtek/rtlwifi/rtl8723ae/led.c   |  12 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/phy.c   | 357 ++++----
 .../net/wireless/realtek/rtlwifi/rtl8723ae/rf.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |  28 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/dm.c    | 118 +--
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |  66 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    | 211 +++--
 .../net/wireless/realtek/rtlwifi/rtl8723be/led.c   |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/phy.c   | 310 +++----
 .../net/wireless/realtek/rtlwifi/rtl8723be/rf.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |  37 +-
 .../realtek/rtlwifi/rtl8723com/fw_common.c         |  22 +-
 .../realtek/rtlwifi/rtl8723com/phy_common.c        |  36 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    | 821 +++++++++--------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    | 134 +--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    | 465 +++++-----
 .../net/wireless/realtek/rtlwifi/rtl8821ae/led.c   |  32 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   | 529 +++++------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/rf.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   |  72 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |  28 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |   6 +-
 drivers/net/wireless/realtek/rtw88/mac.c           |  13 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   7 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |  33 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |  11 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |   4 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   4 +-
 .../net/wireless/realtek/rtw88/rtw8822c_table.c    |  32 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |   4 +-
 drivers/net/wireless/realtek/rtw88/tx.h            |   2 +-
 drivers/net/wireless/rndis_wlan.c                  |   4 +-
 drivers/net/wireless/rsi/rsi_91x_coex.c            |   2 +-
 drivers/net/wireless/rsi/rsi_91x_core.c            |   2 +-
 drivers/net/wireless/rsi/rsi_91x_debugfs.c         |   2 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   2 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   8 +-
 drivers/net/wireless/rsi/rsi_91x_main.c            |   5 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |  33 +-
 drivers/net/wireless/rsi/rsi_91x_ps.c              |   2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |   7 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c        |   2 +-
 drivers/net/wireless/st/cw1200/wsm.c               |   6 +-
 drivers/net/wireless/ti/wl1251/main.c              |   2 +-
 drivers/net/wireless/ti/wlcore/cmd.c               |   7 +-
 drivers/net/wireless/ti/wlcore/debugfs.h           |   6 +-
 drivers/net/wireless/wl3501_cs.c                   |  22 +-
 drivers/net/wireless/zydas/zd1211rw/zd_chip.c      |   4 +-
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c       |  15 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |   9 +-
 327 files changed, 15656 insertions(+), 10768 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath11k/hw.c
 create mode 100644 drivers/net/wireless/ath/ath11k/mhi.c
 create mode 100644 drivers/net/wireless/ath/ath11k/mhi.h
 create mode 100644 drivers/net/wireless/ath/ath11k/pci.c
 create mode 100644 drivers/net/wireless/ath/ath11k/pci.h
