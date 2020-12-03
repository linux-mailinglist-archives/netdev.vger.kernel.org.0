Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAD52CDE21
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387404AbgLCS6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:58:30 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:50773 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgLCS6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:58:30 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607021886; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=5VNIGp4CClShO9lC+F9B+66dHz6yLAs+cobqMaTeM4s=; b=l6iUTYvCFGetjjaWqDPTbnnkr277qfEC4VoFFLxvMAXHhkUqEovhAU0CfBk2tNEgMz1IeBkJ
 wrJSoCP0/q+54xly/9Yo5FEynJLyYpilNVAGkc6Sn4eFwI1lYCsfjT6pODOjYLms9EXbPOXv
 5GQ0XxSne2cKsstfZWmrldT6oVo=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5fc9351d96285165cd85d3ba (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 03 Dec 2020 18:57:33
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9CFA5C433ED; Thu,  3 Dec 2020 18:57:32 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8A9D1C433C6;
        Thu,  3 Dec 2020 18:57:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8A9D1C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2020-12-03
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20201203185732.9CFA5C433ED@smtp.codeaurora.org>
Date:   Thu,  3 Dec 2020 18:57:32 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 3650b228f83adda7e5ee532e2b90429c03f7b9ec:

  Linux 5.10-rc1 (2020-10-25 15:14:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2020-12-03

for you to fetch changes up to 9eb597c74483ad5c230a884449069adfb68285ea:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2020-12-02 21:46:55 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for v5.11

First set of patches for v5.11. rtw88 getting improvements to work
better with Bluetooth and other driver also getting some new features.
mhi-ath11k-immutable branch was pulled from mhi tree to avoid
conflicts with mhi tree.

Major changes:

rtw88

* major bluetooth co-existance improvements

wilc1000

* Wi-Fi Multimedia (WMM) support

ath11k

* Fast Initial Link Setup (FILS) discovery and unsolicited broadcast
  probe response support

* qcom,ath11k-calibration-variant Device Tree setting

* cold boot calibration support

* new DFS region: JP

wnc36xx

* enable connection monitoring and keepalive in firmware

ath10k

* firmware IRAM recovery feature

mhi

* merge mhi-ath11k-immutable branch to make MHI API change go smoothly

----------------------------------------------------------------
Ajay Singh (5):
      wilc1000: added 'ndo_set_mac_address' callback support
      wilc1000: free resource in wilc_wlan_txq_add_net_pkt() for failure path
      wilc1000: free resource in wilc_wlan_txq_add_mgmt_pkt() for failure path
      wilc1000: call complete() for failure in wilc_wlan_txq_add_cfg_pkt()
      wilc1000: added queue support for WMM

Alex Dewar (2):
      ath10k: sdio: remove redundant check in for loop
      ath11k: Handle errors if peer creation fails

Allen Pais (2):
      ath11k: convert tasklets to use new tasklet_setup() API
      wireless: mt7601u: convert tasklets to use new tasklet_setup() API

Aloka Dixit (1):
      ath11k: FILS discovery and unsolicited broadcast probe response support

Arnd Bergmann (5):
      ath6kl: fix enum-conversion warning
      net: hostap: fix function cast warning
      rtlwifi: fix -Wpointer-sign warning
      rtw88: remove extraneous 'const' qualifier
      ath9k: work around false-positive gcc warning

Ben Greear (1):
      ath10k: Don't iterate over not-sdata-in-driver interfaces.

Bhaumik Bhatt (1):
      net: qrtr: Unprepare MHI channels during remove

Brian Norris (1):
      rtw88: wow: print key type when failing

Bryan O'Donoghue (4):
      wcn36xx: Set LINK_FAIL_TX_CNT to 1000 on all wcn36xx
      wcn36xx: Enable firmware link monitoring
      wcn36xx: Enable firmware offloaded keepalive
      wcn36xx: Send NULL data packet when exiting BMPS

Carl Huang (1):
      ath11k: fix ZERO address in probe request

Chin-Yen Lee (4):
      rtw88: sync the power state between driver and firmware
      rtw88: store firmware feature in firmware header
      rtw88: add C2H response for checking firmware leave lps
      rtw88: decide lps deep mode from firmware feature.

Ching-Te Ku (33):
      rtw88: coex: separate BLE HID profile from BLE profile
      rtw88: coex: fixed some wrong register definition and setting
      rtw88: coex: update coex parameter to improve A2DP quality
      rtw88: coex: reduce magic number
      rtw88: coex: coding style adjustment
      rtw88: coex: Modify the timing of set_ant_path/set_rf_para
      rtw88: coex: add separate flag for manual control
      rtw88: coex: modified for BT info notify
      rtw88: coex: change the parameter for A2DP when WLAN connecting
      rtw88: coex: update WLAN 5G AFH parameter for 8822b
      rtw88: coex: add debug message
      rtw88: coex: simplify the setting and condition about WLAN TX limitation
      rtw88: coex: update TDMA settings for different beacon interval
      rtw88: coex: remove unnecessary feature/function
      rtw88: coex: add write scoreboard action when WLAN in critical procedure
      rtw88: coex: Add force flag for coexistence table function
      rtw88: coex: add the mechanism for RF4CE
      rtw88: coex: update the TDMA parameter when leave LPS
      rtw88: coex: Change antenna setting to enhance free-run performance
      rtw88: coex: fix BT performance drop during initial/power-on step
      rtw88: coex: remove write scan bit to scoreboard in scan and connect notify
      rtw88: coex: remove unnecessary WLAN slot extend
      rtw88: coex: change the decode method from firmware
      rtw88: coex: run coexistence when WLAN entering/leaving LPS
      rtw88: coex: add debug message
      rtw88: coex: update the mechanism for A2DP + PAN
      rtw88: coex: update AFH information while in free-run mode
      rtw88: coex: change the coexistence mechanism for HID
      rtw88: coex: change the coexistence mechanism for WLAN connected
      rtw88: coex: add function to avoid cck lock
      rtw88: coex: add action for coexistence in hardware initial
      rtw88: coex: upgrade coexistence A2DP mechanism
      rtw88: coex: add feature to enhance HID coexistence performance

Christophe JAILLET (3):
      ath11k: Fix an error handling path
      ath10k: Fix an error handling path
      ath10k: Release some resources in an error handling path

Dmitry Safonov (1):
      brcmsmac: ampdu: Check BA window size before checking block ack

Govind Singh (1):
      ath11k: Remove unused param from wmi_mgmt_params

Govindaraj Saminathan (1):
      ath11k: cold boot calibration support

Gustavo A. R. Silva (3):
      ray_cs: Use fallthrough pseudo-keyword
      wlcore: Use fallthrough pseudo-keyword
      mwifiex: Fix fall-through warnings for Clang

Jia-Ju Bai (4):
      rtlwifi: rtl8188ee: avoid accessing the data mapped to streaming DMA
      rtlwifi: rtl8192ce: avoid accessing the data mapped to streaming DMA
      rtlwifi: rtl8192de: avoid accessing the data mapped to streaming DMA
      rtlwifi: rtl8723ae: avoid accessing the data mapped to streaming DMA

Jisheng Zhang (1):
      mwifiex: Remove duplicated REG_PORT definition

Kaixu Xia (1):
      rtlwifi: rtl8192de: remove the useless value assignment

Kalle Valo (6):
      ath10k: remove repeated words in comments
      ath10k: ath10k_pci_init_irq(): workaround for checkpatch fallthrough warning
      ath11k: remove repeated words in comments and warnings
      Merge mhi-ath11k-immutable into ath-next
      ath11k: dp_rx: fix monitor status dma unmap direction
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Karthikeyan Periyasamy (3):
      ath11k: Fix single phy hw mode
      ath11k: Fix the hal descriptor mask
      ath11k: fix wmi init configuration

Lavanya Suresh (1):
      ath11k: Add new dfs region name for JP

Lee Jones (32):
      ath: regd: Provide description for ath_reg_apply_ir_flags's 'reg' param
      ath: dfs_pattern_detector: Fix some function kernel-doc headers
      ath: dfs_pri_detector: Demote zero/half completed kernel-doc headers
      ath9k: ar9330_1p1_initvals: Remove unused const variable 'ar9331_common_tx_gain_offset1_1'
      ath9k: ar9340_initvals: Remove unused const variable 'ar9340Modes_ub124_tx_gain_table_1p0'
      ath9k: ar9485_initvals: Remove unused const variable 'ar9485_fast_clock_1_1_baseband_postamble'
      ath9k: ar9003_2p2_initvals: Remove unused const variables
      ath9k: ar5008_phy: Demote half completed function headers
      ath9k: dynack: Demote non-compliant function header
      wil6210: wmi: Correct misnamed function parameter 'ptr_'
      rsi: rsi_91x_usb: Fix some basic kernel-doc issues
      rsi: rsi_91x_usb_ops: Source file headers are not good candidates for kernel-doc
      brcmfmac: bcmsdh: Fix description for function parameter 'pktlist'
      brcmfmac: pcie: Provide description for missing function parameter 'devinfo'
      brcmfmac: fweh: Add missing description for 'gfp'
      wl1251: cmd: Rename 'len' to 'buf_len' in the documentation
      prism54: isl_ioctl: Fix one function header and demote another
      wl3501_cs: Fix misspelling and provide missing documentation
      mwifiex: pcie: Remove a couple of unchecked 'ret's
      wlcore: spi: Demote a non-compliant function header, fix another
      rtw88: rtw8822c: Remove unused variable 'corr_val'
      rtlwifi: rtl8192cu: mac: Fix some missing/ill-documented function parameters
      rtlwifi: rtl8192cu: trx: Demote clear abuse of kernel-doc format
      rtlwifi: halbtc8723b2ant: Remove a bunch of set but unused variables
      rtlwifi: phy: Remove set but unused variable 'bbvalue'
      rtlwifi: halbtc8821a1ant: Remove set but unused variable 'wifi_rssi_state'
      rtlwifi: rtl8723be: Remove set but unused variable 'lc_cal'
      rtlwifi: rtl8188ee: Remove set but unused variable 'reg_ea4'
      rtlwifi: halbtc8821a2ant: Remove a bunch of unused variables
      rtlwifi: rtl8723be: Remove set but unused variable 'cck_highpwr'
      rtlwifi: rtl8821ae: phy: Remove a couple of unused variables
      rtlwifi: rtl8821ae: Place braces around empty if() body

Loic Poulain (2):
      bus: mhi: Remove auto-start option
      net: qrtr: Start MHI channels during init

Maharaja Kennadyrajan (1):
      ath11k: Fix the rx_filter flag setting for peer rssi stats

Marek Vasut (3):
      rsi: Fix TX EAPOL packet handling against iwlwifi AP
      rsi: Move card interrupt handling to RX thread
      rsi: Clean up loop in the interrupt handler

Markov Mikhail (1):
      rt2x00: save survey for every channel visited

Matthias Brugger (1):
      brcmfmac: expose firmware config files through modinfo

P Praneesh (1):
      ath11k: add processor_id based ring_selector logic

Ping-Ke Shih (2):
      rtw88: 8723d: add cck pd seetings
      rtw88: add CCK_PD debug log

Qinglang Miao (1):
      cw1200: fix missing destroy_workqueue() on error in cw1200_init_common

Rakesh Pillai (1):
      ath10k: Fix the parsing error in service available event

Ramya Gnanasekar (1):
      ath11k: Fix beamformee STS in HE cap

Remi Depommier (2):
      brcmfmac: fix SDIO access for big-endian host
      brcmfmac: Fix incorrect type in assignment

Rikard Falkeborn (1):
      ath10k: Constify static qmi structs

Ritesh Singh (3):
      ath11k: vdev delete synchronization with firmware
      ath11k: peer delete synchronization with firmware
      ath11k: remove "ath11k_mac_get_ar_vdev_stop_status" references

Sebastian Andrzej Siewior (18):
      orinoco: Remove BUG_ON(in_interrupt/irq())
      airo: Invoke airo_read_wireless_stats() directly
      airo: Always use JOB_STATS and JOB_EVENT
      airo: Replace in_atomic() usage.
      hostap: Remove in_atomic() check.
      zd1211rw: Remove in_atomic() usage.
      rtlwifi: Remove in_interrupt() usage in is_any_client_connect_to_ap().
      rtlwifi: Remove in_interrupt() usage in halbtc_send_bt_mp_operation()
      orinoco: Move context allocation after processing the skb
      orinoco: Prepare stubs for in_interrupt() removal
      orinoco: Annotate ezusb_xmit()
      orinoco: Annotate ezusb_init()
      orinoco: Annotate firmware loading
      orinoco: Annotate ezusb_read_pda()
      orinoco: Annotate ezusb_write_ltv()
      orinoco: Remove ezusb_doicmd_wait()
      orinoco: Annotate ezusb_docmd_wait()
      orinoco: Annotate ezusb_read_ltv()

Seung-Woo Kim (1):
      brcmfmac: Fix memory leak for unpaired brcmf_{alloc/free}

Sven Eckelmann (7):
      dt: bindings: add new dt entry for ath11k calibration variant
      ath11k: search DT for qcom,ath11k-calibration-variant
      ath11k: Initialize complete alpha2 for regulatory change
      ath11k: Fix number of rules in filtered ETSI regdomain
      ath11k: Don't cast ath11k_skb_cb to ieee80211_tx_info.control
      ath11k: Reset ath11k_skb_cb before setting new flags
      ath11k: Build check size of ath11k_skb_cb

Tamizh Chelvam (1):
      ath10k: fix compilation warning

Tian Tao (1):
      wlcore: Switch to using the new API kobj_to_dev()

Tokunori Ikegami (2):
      rtl8xxxu: Add Buffalo WI-U3-866D to list of supported devices
      Revert "rtl8xxxu: Add Buffalo WI-U3-866D to list of supported devices"

Tom Rix (3):
      wireless: remove unneeded break
      airo: remove trailing semicolon in macro definition
      wl1251: remove trailing semicolon in macro definition

Tsuchiya Yuto (3):
      mwifiex: fix mwifiex_shutdown_sw() causing sw reset failure
      mwifiex: update comment for shutdown_sw()/reinit_sw() to reflect current state
      mwifiex: pcie: skip cancel_work_sync() on reset failure path

Vasanthakumar Thiagarajan (1):
      ath11k: Remove unnecessary data sync to cpu on monitor buffer

Venkateswara Naralasetty (1):
      ath10k: add target IRAM recovery feature support

Wang Hai (1):
      qtnfmac: fix error return code in qtnf_pcie_probe()

Wang Qing (1):
      rtlwifi: fix spelling typo of workaround

WeitaoWangoc (1):
      rtlwifi: Fix non-canonical address access issues

Wen Gong (1):
      ath10k: cancel rx worker in hif_stop for SDIO

Yejune Deng (1):
      cw1200: replace a set of atomic_add()

Zhang Changzhong (2):
      brcmfmac: fix error return code in brcmf_cfg80211_connect()
      rsi: fix error return code in rsi_reset_card()

 .../bindings/net/wireless/qcom,ath11k.yaml         |    6 +
 drivers/bus/mhi/core/init.c                        |    9 -
 drivers/bus/mhi/core/internal.h                    |    1 -
 drivers/net/wireless/ath/ath10k/core.c             |   85 +-
 drivers/net/wireless/ath/ath10k/core.h             |    8 +
 drivers/net/wireless/ath/ath10k/debug.c            |    2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |    1 -
 drivers/net/wireless/ath/ath10k/mac.c              |   21 +-
 drivers/net/wireless/ath/ath10k/p2p.c              |    2 +-
 drivers/net/wireless/ath/ath10k/pci.c              |    2 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |    4 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h          |    2 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |   20 +-
 drivers/net/wireless/ath/ath10k/usb.c              |    7 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |    4 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   11 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |    7 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |   27 +
 drivers/net/wireless/ath/ath11k/core.c             |   41 +-
 drivers/net/wireless/ath/ath11k/core.h             |   22 +-
 drivers/net/wireless/ath/ath11k/dp.c               |    2 +-
 drivers/net/wireless/ath/ath11k/dp.h               |    2 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   18 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |   13 +-
 drivers/net/wireless/ath/ath11k/hal_desc.h         |    8 +-
 drivers/net/wireless/ath/ath11k/hw.c               |    4 +-
 drivers/net/wireless/ath/ath11k/hw.h               |    1 +
 drivers/net/wireless/ath/ath11k/mac.c              |  198 ++-
 drivers/net/wireless/ath/ath11k/mac.h              |    2 -
 drivers/net/wireless/ath/ath11k/mhi.c              |    4 -
 drivers/net/wireless/ath/ath11k/pci.c              |    7 +-
 drivers/net/wireless/ath/ath11k/peer.c             |   44 +-
 drivers/net/wireless/ath/ath11k/peer.h             |    2 +
 drivers/net/wireless/ath/ath11k/qmi.c              |   78 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |    5 +
 drivers/net/wireless/ath/ath11k/reg.c              |    7 +-
 drivers/net/wireless/ath/ath11k/reg.h              |    1 +
 drivers/net/wireless/ath/ath11k/rx_desc.h          |    2 +-
 drivers/net/wireless/ath/ath11k/testmode.c         |    4 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  294 +++-
 drivers/net/wireless/ath/ath11k/wmi.h              |   52 +-
 drivers/net/wireless/ath/ath6kl/testmode.c         |    1 -
 drivers/net/wireless/ath/ath6kl/wmi.c              |    4 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |   15 +-
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |   14 -
 .../net/wireless/ath/ath9k/ar9330_1p1_initvals.h   |    7 -
 drivers/net/wireless/ath/ath9k/ar9340_initvals.h   |  101 --
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h   |    7 -
 drivers/net/wireless/ath/ath9k/dynack.c            |   11 +-
 drivers/net/wireless/ath/ath9k/hw.c                |    1 -
 drivers/net/wireless/ath/dfs_pattern_detector.c    |   14 +-
 drivers/net/wireless/ath/dfs_pri_detector.c        |    9 +-
 drivers/net/wireless/ath/regd.c                    |    1 +
 drivers/net/wireless/ath/wcn36xx/main.c            |    2 +
 drivers/net/wireless/ath/wcn36xx/smd.c             |    4 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |    2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |    1 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   26 +-
 .../wireless/broadcom/brcm80211/brcmsmac/ampdu.c   |   11 +-
 drivers/net/wireless/cisco/airo.c                  |  126 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |    2 -
 drivers/net/wireless/intersil/hostap/hostap_hw.c   |   17 +-
 .../net/wireless/intersil/hostap/hostap_ioctl.c    |   15 +-
 drivers/net/wireless/intersil/orinoco/hermes.c     |    1 +
 drivers/net/wireless/intersil/orinoco/hermes.h     |   15 +
 drivers/net/wireless/intersil/orinoco/hw.c         |   32 +-
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |  168 ++-
 drivers/net/wireless/intersil/prism54/isl_ioctl.c  |    5 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |    6 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   24 +-
 drivers/net/wireless/marvell/mwifiex/pcie.h        |    2 +
 drivers/net/wireless/marvell/mwifiex/sdio.h        |    2 -
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |    2 +
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |    1 +
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c     |    1 +
 drivers/net/wireless/marvell/mwifiex/wmm.c         |    1 +
 drivers/net/wireless/mediatek/mt7601u/dma.c        |   12 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |    7 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   17 +
 drivers/net/wireless/microchip/wilc1000/hif.h      |    1 +
 drivers/net/wireless/microchip/wilc1000/netdev.c   |   38 +
 drivers/net/wireless/microchip/wilc1000/netdev.h   |   11 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |  335 ++++-
 drivers/net/wireless/microchip/wilc1000/wlan.h     |   30 +
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |    6 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |   62 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h        |   10 +
 drivers/net/wireless/ray_cs.c                      |    6 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |   48 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    |    4 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    |   27 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |    1 -
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.c   |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/mac.c   |    7 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |    1 -
 .../net/wireless/realtek/rtlwifi/rtl8723ae/phy.c   |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/phy.c   |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |   96 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.c |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.h |    4 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |    1 -
 drivers/net/wireless/realtek/rtw88/coex.c          | 1538 +++++++++++++++-----
 drivers/net/wireless/realtek/rtw88/coex.h          |   47 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |   27 +-
 drivers/net/wireless/realtek/rtw88/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw88/fw.c            |    6 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |   11 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    9 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   59 +-
 drivers/net/wireless/realtek/rtw88/main.h          |   41 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |    6 +
 drivers/net/wireless/realtek/rtw88/ps.c            |  135 +-
 drivers/net/wireless/realtek/rtw88/ps.h            |    3 +-
 drivers/net/wireless/realtek/rtw88/reg.h           |   17 +-
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |   96 +-
 drivers/net/wireless/realtek/rtw88/rtw8723d.h      |    3 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |   16 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.h      |    2 -
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |   55 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  119 +-
 drivers/net/wireless/realtek/rtw88/wow.c           |    8 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |    3 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |    6 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c        |  173 +--
 drivers/net/wireless/rsi/rsi_91x_usb.c             |   36 +-
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c         |    2 +-
 drivers/net/wireless/rsi/rsi_sdio.h                |    8 +-
 drivers/net/wireless/st/cw1200/bh.c                |   10 +-
 drivers/net/wireless/st/cw1200/main.c              |    2 +
 drivers/net/wireless/st/cw1200/wsm.c               |    8 +-
 drivers/net/wireless/ti/wl1251/cmd.c               |    2 +-
 drivers/net/wireless/ti/wl1251/debugfs.c           |    2 +-
 drivers/net/wireless/ti/wlcore/main.c              |    4 +-
 drivers/net/wireless/ti/wlcore/spi.c               |    3 +-
 drivers/net/wireless/ti/wlcore/sysfs.c             |    2 +-
 drivers/net/wireless/wl3501_cs.c                   |    8 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |   15 -
 include/linux/mhi.h                                |    2 -
 net/qrtr/mhi.c                                     |    6 +
 150 files changed, 3496 insertions(+), 1488 deletions(-)
