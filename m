Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468D71C8BF8
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 15:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgEGNVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 09:21:22 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:54391 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725914AbgEGNVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 09:21:21 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588857679; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: Cc: To: From: Sender;
 bh=LpSlkdDXL508hpX6Q7hnpO7EDzjLUNWyvlSvbLMFmfQ=; b=EwKIx/fLoNh1nxsKMOuf2/P2hl9NmFcckWnpg9U4MNk5xkx2VSICSlN76LkGdV2g4+6GMjwQ
 xhpL8O/XF1HL3yJTRy8iZMzYI/MSGHRNMS+188P/zePiq4pFua/vH38Hcx3glDbQtGwQ+Ad9
 i8Jwe9tWdZaT7jLMV0CiMp2Lypg=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb40b49.7fb5e4743e30-smtp-out-n04;
 Thu, 07 May 2020 13:21:13 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E7090C433D2; Thu,  7 May 2020 13:21:12 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7155DC433F2;
        Thu,  7 May 2020 13:21:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7155DC433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-drivers-next-2020-05-07
Date:   Thu, 07 May 2020 16:21:06 +0300
Message-ID: <87sggb7uf1.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know=
 if
there are any problems.

Kalle

The following changes since commit 8f3d9f354286745c751374f5f1fcafee6b3f3136:

  Linux 5.7-rc1 (2020-04-12 12:35:55 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-2020-05-07

for you to fetch changes up to 7f65f6118a53eeb3cd9baa0ceb5519b478758cd9:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/a=
th.git (2020-05-06 12:12:27 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.8

First set of patches for v5.8. Changes all over, ath10k apparently
seeing most new features this time. rtw88 also had lots of changes due
to preparation for new hardware support.

In this pull request there's also a new macro to include/linux/iopoll:
read_poll_timeout_atomic(). This is needed by rtw88 for atomic
polling.

Major changes:

ath11k

* add debugfs file for testing ADDBA and DELBA

* add 802.11 encapsulation offload on hardware support

* add htt_peer_stats_reset debugfs file

ath10k

* enable VHT160 and VHT80+80 modes

* enable radar detection in secondary segment

* sdio: disable TX complete indication to improve throughput

* sdio: decrease power consumption

* sdio: add HTT TX bundle support to increase throughput

* sdio: add rx bitrate reporting

ath9k

* improvements to AR9002 calibration logic

carl9170

* remove buggy P2P_GO support

p54usb

* add support for AirVasT USB stick

rtw88

* add support for antenna configuration

ti wlcore

* add support for AES_CMAC cipher

iwlwifi

* support for a few new FW API versions

* new hw configs

----------------------------------------------------------------
Aloka Dixit (1):
      ath11k: Fix TWT radio count

Arnd Bergmann (1):
      mwifiex: avoid -Wstringop-overflow warning

Ashok Raj Nagarajan (1):
      ath11k: Add support to reset htt peer stats

Chi-Hsien Lin (1):
      brcmfmac: only generate random p2p address when needed

Christian Lamparter (1):
      carl9170: remove P2P_GO support

Christophe JAILLET (2):
      qtnfmac: Simplify code in _attach functions
      ipw2x00: Remove a memory allocation failure log message

Colin Ian King (4):
      ath11k: fix error message to correctly report the command that failed
      brcm80211: remove redundant pointer 'address'
      rtw88: fix spelling mistake "fimrware" -> "firmware"
      libertas_tf: avoid a null dereference in pointer priv

Dejin Zheng (1):
      rtw88: fix an issue about leak system resources

Emmanuel Grumbach (1):
      iwlwifi: remove fw_monitor module parameter

Gil Adam (2):
      iwlwifi: mvm: add framework for specific phy configuration
      iwlwifi: debug: set NPK buffer in context info

Giuseppe Marco Randazzo (1):
      p54usb: add AirVasT USB stick device-id

Govindaraj Saminathan (1):
      ath11k: cleanup reo command error code overwritten

Greg Kroah-Hartman (1):
      brcmfmac: no need to check return value of debugfs_create functions

Gustavo A. R. Silva (2):
      ath6kl: Replace zero-length array with flexible-array
      ath11k: Replace zero-length array with flexible-array

Ihab Zhaika (2):
      iwlwifi: add new cards for AX family
      iwlwifi: update few product names in AX family

Jaehoon Chung (1):
      brcmfmac: fix wrong location to get firmware feature

Jason Yan (26):
      brcmsmac: make brcms_c_set_mac() void
      ipw2x00: make ipw_qos_association_resp() void
      cw1200: make cw1200_spi_irq_unsubscribe() void
      libertas: make lbs_init_mesh() void
      libertas: make lbs_process_event() void
      orinoco: remove useless variable 'err' in spectrum_cs_suspend()
      brcmsmac: make brcms_c_stf_ss_update() void
      ipw2x00: make ipw_setup_deferred_work() void
      rtlwifi: rtl8188ee: use true,false for bool variables
      rtlwifi: rtl8723ae: use true,false for bool variables
      rtlwifi: rtl8192ee: use true,false for bool variables
      rtlwifi: rtl8723be: use true,false for bool variables
      rtlwifi: rtl8821ae: use true,false for bool variables
      rtlwifi: rtl8723ae: fix warning comparison to bool
      ath11k: remove conversion to bool in ath11k_dp_rxdesc_mpdu_valid()
      ath11k: remove conversion to bool in ath11k_debug_fw_stats_process()
      ath5k: remove conversion to bool in ath5k_ani_calibration()
      brcmfmac: remove comparison to bool in brcmf_fws_attach()
      ath11k: use true,false for bool variables
      rtlwifi: use true,false for bool variable in rtl_init_rfkill()
      ray_cs: use true,false for bool variable
      brcmsmac: remove Comparison to bool in brcms_b_txstatus()
      rtlwifi: remove comparison of 0/1 to bool variable
      b43: remove Comparison of 0/1 to bool variable in phy_n.c
      b43: remove Comparison of 0/1 to bool variable in pio.c
      rtlwifi: rtl8188ee: remove Comparison to bool in rf.c

Johannes Berg (6):
      iwlwifi: pcie: use seq_file for tx_queue debugfs file
      iwlwifi: pcie: add n_window/ampdu to tx_queue debugfs
      iwlwifi: pcie: gen2: minor code cleanups in byte table update
      iwlwifi: mvm: add DCM flag to rate pretty-print
      iwlwifi: pcie: move iwl_pcie_ctxt_info_alloc_dma() to user
      iwlwifi: mvm: tell firmware about required LTR delay

John Crispin (1):
      ath11k: add tx hw 802.11 encapsulation offloading support

John Oldman (2):
      ssb: sprom: fix block comments coding style issues
      ssb: scan: fix block comments coding style issues

Joseph Chuang (1):
      brcmfmac: Fix P2P Group Formation failure via Go-neg method

Jules Irenge (3):
      hostap: Add missing annotations for prism2_bss_list_proc_start() and =
prism2_bss_list_proc_stop
      brcmsmac: Add missing annotation for brcms_rfkill_set_hw_state()
      brcmsmac: Add missing annotation for brcms_down()

Justin Li (1):
      brcmfmac: Add P2P Action Frame retry delay to fix GAS Comeback Respon=
se failure issue

Kai-Heng Feng (3):
      rtw88: Add delay on polling h2c command status bit
      iopoll: Introduce read_poll_timeout_atomic macro
      rtw88: Use udelay instead of usleep in atomic context

Kalle Valo (6):
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      ath10k: rename ath10k_hif_swap_mailbox() to ath10k_hif_start_post()
      ath10k: sdio: remove _hif_ prefix from functions not part of hif inte=
rface
      ath10k: hif: make send_complete_check op optional
      Merge tag 'iwlwifi-next-for-kalle-2020-04-24-2' of git://git.kernel.o=
rg/.../iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Karthikeyan Periyasamy (3):
      ath11k: fix duplication peer create on same radio
      ath11k: Modify the interrupt timer threshold
      ath11k: fix reo flush send

Larry Finger (1):
      b43legacy: Fix case where channel status is corrupted

Lei Wang (2):
      ath10k: enable VHT160 and VHT80+80 modes
      ath10k: enable radar detection in secondary segment

Luca Coelho (4):
      iwlwifi: remove deprecated and unused iwl_mvm_keyinfo struct
      iwlwifi: pcie: add cfgs for SoCs with device ID 0x4FD0
      iwlwifi: pcie: add new structure for Qu devices with medium latency
      iwlwifi: pcie: add new structs for So devices with long latency

Madhan Mohan R (1):
      brcmfmac: p2p cert 6.1.9-support GOUT handling p2p presence request

Maharaja Kennadyrajan (7):
      ath11k: Add sta debugfs support to configure ADDBA and DELBA
      ath10k: Fix the race condition in firmware dump work queue
      ath11k: add pktlog checksum in trace events to support pktlog
      ath11k: Cleanup in pdev destroy and mac register during crash on reco=
very
      ath11k: Fix rx_filter flags setting for per peer rx_stats
      ath10k: Fix the invalid tx/rx chainmask configuration
      ath10k: Avoid override CE5 configuration for QCA99X0 chipsets

Mamatha Telu (1):
      ath10k: Fix typo in warning messages

Manikanta Pubbisetty (2):
      ath11k: set IRQ_DISABLE_UNLAZY flag for DP interrupts
      ath11k: rx path optimizations

Masashi Honma (1):
      ath9k_htc: Silence undersized packet warnings

Mordechay Goodstein (3):
      iwlwifi: move API version lookup to common code
      iwlwifi: support version 9 of WOWLAN_GET_STATUS notification
      iwlwifi: acpi: read TAS table from ACPI and send it to the FW

Nils ANDR=C3=89-CHANG (1):
      brcmfmac: remove leading space

Ping-Ke Shih (24):
      rtw88: 8723d: Add basic chip capabilities
      rtw88: 8723d: add beamform wrapper functions
      rtw88: 8723d: Add power sequence
      rtw88: 8723d: Add RF read/write ops
      rtw88: 8723d: Add mac/bb/rf/agc/power_limit tables
      rtw88: 8723d: Add cfg_ldo25 to control LDO25
      rtw88: 8723d: Add new chip op efuse_grant() to control efuse access
      rtw88: 8723d: Add read_efuse to recognize efuse info from map
      rtw88: add legacy firmware download for 8723D devices
      rtw88: no need to send additional information to legacy firmware
      rtw88: 8723d: Add mac power-on/-off function
      rtw88: decompose while(1) loop of power sequence polling command
      rtw88: 8723d: 11N chips don't support H2C queue
      rtw88: 8723d: implement set_tx_power_index ops
      rtw88: 8723d: Organize chip TX/RX FIFO
      rtw88: 8723d: initialize mac/bb/rf basic functions
      rtw88: 8723d: Add DIG parameter
      rtw88: 8723d: Add query_rx_desc
      rtw88: 8723d: Add set_channel
      rtw88: handle C2H_CCX_TX_RPT to know if packet TX'ed successfully
      rtw88: 8723d: some chips don't support LDPC
      rtw88: 8723d: Add chip_ops::false_alarm_statistics
      rtw88: 8723d: Set IG register for CCK rate
      rtw88: 8723d: add interface configurations table

Qiujun Huang (7):
      ath9k: Fix use-after-free Read in htc_connect_service
      ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
      ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
      ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
      ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
      rtlwifi: rtl8723ae: fix spelling mistake "chang" -> "change"
      rsi: fix a typo "throld" -> "threshold"

Rakesh Pillai (3):
      dt-bindings: ath10k: Add wifi-firmware subnode for wifi node
      ath10k: Setup the msa resources before qmi init
      ath10k: Add support for targets without trustzone

Raz Bouganim (1):
      wlcore: Adding suppoprt for IGTK key in wlcore driver

Ritesh Singh (1):
      ath11k: Fix fw assert by setting proper vht cap

Ryohei Kondo (1):
      brcmfmac: add vendor ie for association responses

Sathishkumar Muruganandam (2):
      ath11k: fix mgmt_tx_wmi cmd sent to FW for deleted vdev
      ath11k: add DBG_MAC prints to track vdev events

Sergey Ryazanov (6):
      ath9k: fix AR9002 ADC and NF calibrations
      ath9k: remove needless NFCAL_PENDING flag setting
      ath9k: do not miss longcal on AR9002
      ath9k: interleaved NF calibration on AR9002
      ath9k: invalidate all calibrations at once
      ath9k: add calibration timeout for AR9002

Shahar S Matityahu (2):
      iwlwifi: dbg: support multiple dumps in legacy dump flow
      iwlwifi: yoyo: support IWL_FW_INI_TIME_POINT_HOST_ALIVE_TIMEOUT time =
point

Sowmiya Sree Elavalagan (1):
      ath11k: fix resource unavailability for htt stats after peer stats di=
splay

Sriram R (3):
      ath11k: Increase the tx completion ring size
      ath11k: Avoid mgmt tx count underflow
      ath11k: Add dynamic tcl ring selection logic with retry mechanism

Tamizh Chelvam (1):
      ath11k: fix kernel panic by freeing the msdu received with invalid le=
ngth

Tova Mussai (2):
      iwlwifi: scan: remove support for fw scan api v13
      iwlwifi: nvm: use iwl_nl80211_band_from_channel_idx

Tzu-En Huang (1):
      rtw88: set power trim according to efuse PG values

Venkateswara Naralasetty (1):
      ath10k: fix kernel null pointer dereference

Wei Yongjun (3):
      ath11k: use GFP_ATOMIC under spin lock
      ath10k: fix possible memory leak in ath10k_bmi_lz_data_large()
      ath11k: fix error return code in ath11k_dp_alloc()

Wen Gong (14):
      ath10k: disable TX complete indication of htt for sdio
      ath10k: change ATH10K_SDIO_BUS_REQUEST_MAX_NUM from 64 to 1024
      ath10k: improve power save performance for sdio
      ath10k: add htt TX bundle for sdio
      ath10k: enable alt data of TX path for sdio
      ath10k: add flush tx packets for SDIO chip
      ath10k: drop the TX packet which size exceed credit size for sdio
      ath10k: enable rx duration report default for wmi tlv
      ath10k: add statistics of tx retries and tx failed when tx complete d=
isable
      ath10k: enable firmware peer stats info for wmi tlv
      ath10k: add rx bitrate report for SDIO
      ath10k: add bitrate parse for peer stats info
      ath10k: correct tx bitrate of iw for SDIO
      ath10k: remove the max_sched_scan_reqs value

Wright Feng (3):
      brcmfmac: keep apsta enabled when AP starts with MCHAN feature
      brcmfmac: remove arp_hostip_clear from brcmf_netdev_stop
      brcmfmac: support the second p2p connection

Yan-Hsuan Chuang (4):
      rtw88: make rtw_chip_ops::set_antenna return int
      rtw88: add support for set/get antennas
      rtw88: fix sparse warnings for download firmware routine
      rtw88: 8822c: update phy parameter tables to v50

YueHaibing (1):
      rtw88: Make two functions static

 .../bindings/net/wireless/qcom,ath10k.txt          |    14 +
 drivers/net/wireless/ath/ath10k/bmi.c              |     1 +
 drivers/net/wireless/ath/ath10k/ce.h               |     2 +-
 drivers/net/wireless/ath/ath10k/core.c             |    31 +-
 drivers/net/wireless/ath/ath10k/core.h             |    36 +-
 drivers/net/wireless/ath/ath10k/debug.c            |     4 +-
 drivers/net/wireless/ath/ath10k/debug.h            |     8 +
 drivers/net/wireless/ath/ath10k/hif.h              |    20 +-
 drivers/net/wireless/ath/ath10k/htc.c              |   399 +-
 drivers/net/wireless/ath/ath10k/htc.h              |    40 +-
 drivers/net/wireless/ath/ath10k/htt.c              |    13 +
 drivers/net/wireless/ath/ath10k/htt.h              |    24 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |    42 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |    51 +-
 drivers/net/wireless/ath/ath10k/hw.h               |     5 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   326 +-
 drivers/net/wireless/ath/ath10k/pci.c              |    71 +-
 drivers/net/wireless/ath/ath10k/pci.h              |     4 +
 drivers/net/wireless/ath/ath10k/qmi.c              |    61 +-
 drivers/net/wireless/ath/ath10k/qmi.h              |     3 -
 drivers/net/wireless/ath/ath10k/sdio.c             |   191 +-
 drivers/net/wireless/ath/ath10k/sdio.h             |    19 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   186 +-
 drivers/net/wireless/ath/ath10k/snoc.h             |     7 +
 drivers/net/wireless/ath/ath10k/txrx.c             |     2 +
 drivers/net/wireless/ath/ath10k/usb.c              |    12 -
 drivers/net/wireless/ath/ath10k/wmi-ops.h          |    30 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   127 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |   110 +
 drivers/net/wireless/ath/ath10k/wmi.c              |    52 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |    19 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |     2 +-
 drivers/net/wireless/ath/ath11k/core.h             |    15 +
 drivers/net/wireless/ath/ath11k/debug.c            |     9 +-
 drivers/net/wireless/ath/ath11k/debug.h            |    22 +-
 drivers/net/wireless/ath/ath11k/debug_htt_stats.h  |     8 +-
 drivers/net/wireless/ath/ath11k/debugfs_sta.c      |   297 +
 drivers/net/wireless/ath/ath11k/dp.c               |     6 +-
 drivers/net/wireless/ath/ath11k/dp.h               |    13 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |    49 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |    69 +-
 drivers/net/wireless/ath/ath11k/hal.h              |     2 +-
 drivers/net/wireless/ath/ath11k/hal_desc.h         |     4 +-
 drivers/net/wireless/ath/ath11k/hal_rx.h           |     2 +-
 drivers/net/wireless/ath/ath11k/hw.h               |     2 +-
 drivers/net/wireless/ath/ath11k/mac.c              |    95 +-
 drivers/net/wireless/ath/ath11k/peer.c             |    35 +-
 drivers/net/wireless/ath/ath11k/peer.h             |     1 +
 drivers/net/wireless/ath/ath11k/trace.h            |    12 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   170 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |    88 +-
 drivers/net/wireless/ath/ath5k/ani.c               |     2 +-
 drivers/net/wireless/ath/ath6kl/core.h             |     4 +-
 drivers/net/wireless/ath/ath6kl/debug.c            |     2 +-
 drivers/net/wireless/ath/ath6kl/hif.h              |     2 +-
 drivers/net/wireless/ath/ath9k/ar9002_calib.c      |    49 +-
 drivers/net/wireless/ath/ath9k/calib.c             |    16 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |    58 +-
 drivers/net/wireless/ath/ath9k/hif_usb.h           |     6 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    10 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |     6 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |     6 +-
 drivers/net/wireless/ath/ath9k/hw.h                |     2 +
 drivers/net/wireless/ath/ath9k/wmi.c               |     6 +-
 drivers/net/wireless/ath/ath9k/wmi.h               |     3 +-
 drivers/net/wireless/ath/carl9170/fw.c             |     4 +-
 drivers/net/wireless/ath/carl9170/main.c           |    21 +-
 drivers/net/wireless/broadcom/b43/phy_n.c          |     2 +-
 drivers/net/wireless/broadcom/b43/pio.c            |     2 +-
 drivers/net/wireless/broadcom/b43legacy/xmit.c     |     1 +
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |     2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    17 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |     4 +
 .../broadcom/brcm80211/brcmfmac/commonring.c       |     8 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |     3 -
 .../wireless/broadcom/brcm80211/brcmfmac/debug.c   |     9 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   |    12 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |     3 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |     2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   115 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |     9 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |     2 +
 .../wireless/broadcom/brcm80211/brcmsmac/main.c    |     7 +-
 .../net/wireless/broadcom/brcm80211/brcmsmac/stf.c |     7 +-
 .../net/wireless/broadcom/brcm80211/brcmsmac/stf.h |     2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |    27 +-
 drivers/net/wireless/intel/iwlwifi/Makefile        |     3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |    71 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |    76 +
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |    17 +
 drivers/net/wireless/intel/iwlwifi/fw/api/config.h |    39 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |    39 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |    15 +
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |    26 -
 drivers/net/wireless/intel/iwlwifi/fw/api/soc.h    |    12 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h    |    26 -
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   139 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |    11 -
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |     1 +
 drivers/net/wireless/intel/iwlwifi/fw/img.c        |    99 +
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |    19 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |    14 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |    23 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |    26 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |     4 -
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h |     2 -
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |     3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |     4 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |    29 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |     4 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |     4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   113 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |     1 -
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |     4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |    25 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |     3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |    44 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |    47 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |    15 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |    34 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |    16 -
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   137 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |     8 +-
 drivers/net/wireless/intersil/hostap/hostap_proc.c |     2 +
 .../net/wireless/intersil/orinoco/spectrum_cs.c    |     3 +-
 drivers/net/wireless/intersil/p54/p54usb.c         |     1 +
 drivers/net/wireless/marvell/libertas/cmd.h        |     2 +-
 drivers/net/wireless/marvell/libertas/cmdresp.c    |     5 +-
 drivers/net/wireless/marvell/libertas/mesh.c       |     6 +-
 drivers/net/wireless/marvell/libertas/mesh.h       |     2 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |     6 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |    39 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   |     2 +-
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   |     2 +-
 drivers/net/wireless/ray_cs.c                      |     3 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |     2 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |     2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/rf.c    |     4 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/sw.c    |     4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/sw.c    |     4 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c   |     2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |    10 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/sw.c    |     4 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.c    |     4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    |     4 +-
 drivers/net/wireless/realtek/rtw88/bf.c            |     7 +-
 drivers/net/wireless/realtek/rtw88/bf.h            |    22 +
 drivers/net/wireless/realtek/rtw88/efuse.c         |    26 +
 drivers/net/wireless/realtek/rtw88/efuse.h         |     3 +
 drivers/net/wireless/realtek/rtw88/fw.c            |    54 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |    32 +-
 drivers/net/wireless/realtek/rtw88/mac.c           |   407 +-
 drivers/net/wireless/realtek/rtw88/mac.h           |     1 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    40 +-
 drivers/net/wireless/realtek/rtw88/main.c          |    65 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    60 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |    39 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |    60 +-
 drivers/net/wireless/realtek/rtw88/phy.h           |     6 +
 drivers/net/wireless/realtek/rtw88/reg.h           |    97 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |  1137 ++
 drivers/net/wireless/realtek/rtw88/rtw8723d.h      |   144 +
 .../net/wireless/realtek/rtw88/rtw8723d_table.c    |  1196 ++
 .../net/wireless/realtek/rtw88/rtw8723d_table.h    |    15 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |    23 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   152 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |    28 +
 .../net/wireless/realtek/rtw88/rtw8822c_table.c    | 16870 +++++++++++++++=
++--
 .../net/wireless/realtek/rtw88/rtw8822c_table.h    |     1 +
 drivers/net/wireless/realtek/rtw88/tx.c            |    11 +-
 drivers/net/wireless/realtek/rtw88/tx.h            |     2 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |     2 +-
 drivers/net/wireless/st/cw1200/cw1200_spi.c        |     6 +-
 drivers/net/wireless/ti/wlcore/cmd.h               |     1 +
 drivers/net/wireless/ti/wlcore/main.c              |     4 +
 drivers/ssb/scan.c                                 |     6 +-
 drivers/ssb/sprom.c                                |    12 +-
 include/linux/iopoll.h                             |    62 +-
 178 files changed, 22694 insertions(+), 2405 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/img.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723d.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723d.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723d_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723d_table.h
