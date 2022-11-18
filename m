Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C05A62F328
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 12:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241456AbiKRLCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 06:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241460AbiKRLCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 06:02:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD929824C;
        Fri, 18 Nov 2022 03:02:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 067E86243D;
        Fri, 18 Nov 2022 11:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFC9C433D6;
        Fri, 18 Nov 2022 11:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668769362;
        bh=yOJs5dlIGwYhjK4Jzweo8n7eiXuCGsOYXbXlLEdrjvI=;
        h=From:Subject:To:Cc:Date:From;
        b=GQcv+yBm/TtAqyS1GCVfdBXi37UIJBUHUdCY7PjuBK1xuIb4mTl6U3yBTSwG23Qxt
         bMkcWAy1he6B+a2DK1shgC/1MmFjIzVEMJcfFVhqSsafyLGKCNENrq+xybrbIaedf+
         +f6626maFh6r5mbsO4iIPWTuobHMrV4SOpSYj0hOG4O39DWa+CChbPcMHYcAyvUeAa
         PZ9/Tm1EA4FipQz/+wQml1neBu+EEq1b+l36MU1AZ/OWhEl4ONUYrVXkzCarKD0A0O
         rJxXH+R46dJHtBDYHXw/XdBOV0it3+VblkP6IMVOBCUf2vCB+DIgpDUC7yj1gJ2gzi
         RcVrpYdQjL50A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-next-2022-11-18
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20221118110241.ADFC9C433D6@smtp.kernel.org>
Date:   Fri, 18 Nov 2022 11:02:41 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 637639cbfebb747406b9a57befc0b347057a3a24:

  ice: Add additional CSR registers to ETHTOOL_GREGS (2022-10-28 21:57:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2022-11-18

for you to fetch changes up to e7e40cc6555ca0b395a09fc6b9a036e4a8ac6f41:

  Merge tag 'iwlwifi-next-for-kalle-2022-11-06-v2' of http://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2022-11-17 14:53:45 +0200)

----------------------------------------------------------------
wireless-next patches for v6.2

Second set of patches for v6.2. Only driver patches this time, nothing
really special. Unused platform data support was removed from wl1251
and rtw89 got WoWLAN support.

Major changes:

ath11k

* support configuring channel dwell time during scan

rtw89

* new dynamic header firmware format support

* Wake-over-WLAN support

rtl8xxxu

* enable IEEE80211_HW_SUPPORT_FAST_XMIT

----------------------------------------------------------------
Aditya Kumar Singh (2):
      wifi: ath11k: stop tx queues immediately upon firmware exit
      wifi: ath11k: fix firmware assert during bandwidth change for peer sta

Avraham Stern (7):
      wifi: iwlwifi: mvm: send TKIP connection status to csme
      wifi: iwlwifi: mei: make sure ownership confirmed message is sent
      wifi: iwlwifi: mei: avoid blocking sap messages handling due to rtnl lock
      wifi: iwlwifi: mei: implement PLDR flow
      wifi: iwlwifi: mei: use wait_event_timeout() return value
      wifi: iwlwifi: iwlmei: report disconnection as temporary
      wifi: iwlwifi: mei: wait for the mac to stop on suspend

Baochen Qiang (2):
      wifi: ath11k: Don't exit on wakeup failure
      wifi: ath11k: Send PME message during wakeup from D3cold

Bitterblue Smith (11):
      wifi: rtl8xxxu: Add central frequency offset tracking
      wifi: rtl8xxxu: Fix the CCK RSSI calculation
      wifi: rtl8xxxu: Recognise all possible chip cuts
      wifi: rtl8xxxu: Set IEEE80211_HW_SUPPORT_FAST_XMIT
      wifi: rtl8xxxu: Use dev_* instead of pr_info
      wifi: rtl8xxxu: Move burst init to a function
      wifi: rtl8xxxu: Split up rtl8xxxu_identify_chip
      wifi: rtl8xxxu: Rename rtl8xxxu_8188f_channel_to_group
      wifi: rtl8xxxu: Name some bits used in burst init
      wifi: rtl8xxxu: Use strscpy instead of sprintf
      wifi: rtl8xxxu: Use u32_get_bits in *_identify_chip

Brian Henriquez (1):
      wifi: brcmfmac: correctly remove all p2p vif

Chia-Yuan Li (2):
      wifi: rtw89: dump dispatch status via debug port
      wifi: rtw89: update D-MAC and C-MAC dump to diagnose SER

Chih-Kang Chang (4):
      wifi: rtw89: collect and send RF parameters to firmware for WoWLAN
      wifi: rtw89: move enable_cpu/disable_cpu into fw_download
      wifi: rtw89: add function to adjust and restore PLE quota
      wifi: rtw89: add drop tx packet function

Chin-Yen Lee (3):
      wifi: rtw89: add related H2C for WoWLAN mode
      wifi: rtw89: add WoWLAN function support
      wifi: rtw89: add WoWLAN pattern match support

Christophe JAILLET (3):
      wifi: Use kstrtobool() instead of strtobool()
      wifi: rtw89: Fix some error handling path in rtw89_wow_enable()
      wifi: rtw89: Fix some error handling path in rtw89_core_sta_assoc()

Colin Ian King (5):
      wifi: ath11k: Fix spelling mistake "chnange" -> "change"
      wifi: ath9k: Make arrays prof_prio and channelmap static const
      wifi: rtw89: 8852b: Fix spelling mistake KIP_RESOTRE -> KIP_RESTORE
      wifi: rtlwifi: rtl8192ee: remove static variable stop_report_cnt
      wifi: iwlegacy: remove redundant variable len

Dmitry Torokhov (3):
      ARM: OMAP2+: pdata-quirks: stop including wl12xx.h
      wifi: wl1251: drop support for platform data
      wifi: wl1251: switch to using gpiod API

Emmanuel Grumbach (2):
      wifi: iwlwifi: mei: don't send SAP commands if AMT is disabled
      wifi: iwlwifi: mei: fix tx DHCP packet for devices with new Tx API

Eric Huang (1):
      wifi: rtw89: add BW info for both TX and RX in phy_info

Fedor Pchelkin (3):
      wifi: ath9k: hif_usb: fix memory leak of urbs in ath9k_hif_usb_dealloc_tx_urbs()
      wifi: ath9k: hif_usb: Fix use-after-free in ath9k_hif_usb_reg_in_cb()
      wifi: ath9k: verify the expected usb_endpoints are present

Gustavo A. R. Silva (7):
      wifi: ath10k: Replace zero-length arrays with DECLARE_FLEX_ARRAY() helper
      carl9170: Replace zero-length array with DECLARE_FLEX_ARRAY() helper
      wifi: orinoco: Avoid clashing function prototypes
      wifi: cfg80211: Avoid clashing function prototypes
      wifi: hostap: Avoid clashing function prototypes
      wifi: zd1201: Avoid clashing function prototypes
      wifi: airo: Avoid clashing function prototypes

Ilan Peer (1):
      wifi: iwlwifi: mvm: Fix getting the lowest rate

Jiapeng Chong (1):
      wifi: ipw2200: Remove the unused function ipw_alive()

Jisoo Jang (1):
      wifi: brcmfmac: Fix potential NULL pointer dereference in 'brcmf_c_preinit_dcmds()'

Johannes Berg (3):
      wifi: iwlwifi: mei: fix potential NULL-ptr deref after clone
      wifi: iwlwifi: mvm: use old checksum for Bz A-step
      wifi: iwlwifi: mvm: support new key API

Jonathan Neuschäfer (1):
      wifi: brcmfmac: Fix a typo "unknow"

Kalle Valo (2):
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2022-11-06-v2' of http://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next

Karthikeyan Periyasamy (1):
      wifi: ath11k: suppress add interface error

Kees Cook (3):
      wifi: ath9k: Remove -Warray-bounds exception
      wifi: carl9170: Remove -Warray-bounds exception
      wifi: atmel: Fix atmel_private_handler array size

Linus Walleij (2):
      bcma: Use the proper gpio include
      bcma: Fail probe if GPIO subdriver fails

Liu Shixin (1):
      wifi: wil6210: debugfs: use DEFINE_SHOW_ATTRIBUTE to simplify fw_capabilities/fw_version

Luca Coelho (2):
      wifi: iwlwifi: cfg: disable STBC for BL step A devices
      wifi: iwlwifi: mvm: print an error instead of a warning on invalid rate

Manikanta Pubbisetty (1):
      wifi: ath11k: add support to configure channel dwell time

Marek Vasut (1):
      wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port

Michael Walle (1):
      wifi: wilc1000: sdio: fix module autoloading

Minsuk Kang (1):
      wifi: brcmfmac: Fix potential shift-out-of-bounds in brcmf_fw_alloc_request()

Nagarajan Maran (1):
      wifi: ath11k: fix monitor vdev creation with firmware recovery

Peter Kosyh (1):
      wifi: ath10k: Check return value of ath10k_get_arvif() in ath10k_wmi_event_tdls_peer()

Ping-Ke Shih (4):
      wifi: rtw89: fw: adapt to new firmware format of dynamic header
      wifi: rtw89: 8852c: make table of RU mask constant
      wifi: rtw89: use u32_encode_bits() to fill MAC quota value
      wifi: rtw89: 8852b: change debug mask of message of no TX resource

Prasanna Kerekoppa (1):
      wifi: brcmfmac: Avoiding Connection delay

Rotem Saado (2):
      wifi: iwlwifi: dbg: add support for DBGC4 on BZ family and above
      wifi: iwlwifi: dbg: use bit of DRAM alloc ID to store failed allocs

Shigeru Yoshida (1):
      wifi: ar5523: Fix use-after-free on ar5523_cmd() timed out

Sowmiya Sree Elavalagan (1):
      wifi: ath11k: Fix firmware crash on vdev delete race condition

Wataru Gohda (1):
      wifi: brcmfmac: Fix for when connect request is not success

Wen Gong (2):
      wifi: ath11k: fix warning in dma_free_coherent() of memory chunks while recovery
      wifi: ath11k: avoid deadlock during regulatory update in ath11k_regd_update()

Youghandhar Chintala (1):
      wifi: ath10k: Delay the unmapping of the buffer

Zong-Zhe Yang (2):
      wifi: rtw89: declare support bands with const
      wifi: rtw89: check if sta's mac_id is valid under AP/TDLS

 MAINTAINERS                                        |    1 -
 arch/arm/mach-omap2/pdata-quirks.c                 |    1 -
 drivers/bcma/main.c                                |    4 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |    6 +
 drivers/net/wireless/ath/ath10k/core.c             |   16 +
 drivers/net/wireless/ath/ath10k/debug.c            |    5 +-
 drivers/net/wireless/ath/ath10k/htc.c              |    9 +
 drivers/net/wireless/ath/ath10k/htt.h              |    6 +-
 drivers/net/wireless/ath/ath10k/hw.h               |    2 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |    7 +
 drivers/net/wireless/ath/ath11k/core.c             |    9 +-
 drivers/net/wireless/ath/ath11k/core.h             |    3 +
 drivers/net/wireless/ath/ath11k/mac.c              |  224 +++--
 drivers/net/wireless/ath/ath11k/pcic.c             |   13 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   12 +-
 drivers/net/wireless/ath/ath11k/reg.c              |    6 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |    2 +-
 drivers/net/wireless/ath/ath9k/Makefile            |    5 -
 drivers/net/wireless/ath/ath9k/ath9k.h             |    1 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   46 +-
 drivers/net/wireless/ath/ath9k/mci.c               |    8 +-
 drivers/net/wireless/ath/ath9k/tx99.c              |    2 +-
 drivers/net/wireless/ath/carl9170/Makefile         |    5 -
 drivers/net/wireless/ath/carl9170/wlan.h           |    2 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |   36 +-
 drivers/net/wireless/atmel/atmel.c                 |    2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   24 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |    8 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |    5 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |    8 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |    2 +-
 .../net/wireless/broadcom/brcm80211/brcmsmac/led.c |    3 -
 drivers/net/wireless/cisco/airo.c                  |  204 ++--
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |   16 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |    6 -
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   36 +-
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |   79 ++
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |    7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |    4 +
 drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h   |   30 +-
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |  302 ++++--
 drivers/net/wireless/intel/iwlwifi/mei/net.c       |   10 +-
 drivers/net/wireless/intel/iwlwifi/mei/sap.h       |   55 +-
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile    |    1 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |    9 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   60 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   23 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c   |  226 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   19 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |    3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |    8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    3 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   15 +-
 .../net/wireless/intersil/hostap/hostap_ioctl.c    |  244 ++---
 drivers/net/wireless/intersil/orinoco/wext.c       |  131 +--
 drivers/net/wireless/marvell/mwifiex/debugfs.c     |    2 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |    1 +
 drivers/net/wireless/microchip/wilc1000/sdio.c     |    1 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   31 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c |  107 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c |   62 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |   75 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c |  111 ++-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |   82 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  504 +++++-----
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |   11 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |    8 -
 drivers/net/wireless/realtek/rtw89/Makefile        |    2 +
 drivers/net/wireless/realtek/rtw89/core.c          |   20 +-
 drivers/net/wireless/realtek/rtw89/core.h          |  129 ++-
 drivers/net/wireless/realtek/rtw89/debug.c         | 1019 ++++++++++++++++++--
 drivers/net/wireless/realtek/rtw89/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw89/fw.c            |  317 +++++-
 drivers/net/wireless/realtek/rtw89/fw.h            |  261 ++++-
 drivers/net/wireless/realtek/rtw89/mac.c           |  515 +++++++---
 drivers/net/wireless/realtek/rtw89/mac.h           |   77 ++
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   55 ++
 drivers/net/wireless/realtek/rtw89/pci.c           |   39 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |   12 +
 drivers/net/wireless/realtek/rtw89/phy.c           |   31 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |    2 +-
 drivers/net/wireless/realtek/rtw89/ps.c            |    2 +-
 drivers/net/wireless/realtek/rtw89/ps.h            |    1 +
 drivers/net/wireless/realtek/rtw89/reg.h           |  255 ++++-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   18 +
 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c  |    2 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |   18 +-
 drivers/net/wireless/realtek/rtw89/util.h          |   11 +
 drivers/net/wireless/realtek/rtw89/wow.c           |  859 +++++++++++++++++
 drivers/net/wireless/realtek/rtw89/wow.h           |   21 +
 drivers/net/wireless/rsi/rsi_91x_core.c            |    4 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |    6 +-
 drivers/net/wireless/ti/Kconfig                    |    8 -
 drivers/net/wireless/ti/wilink_platform_data.c     |   35 -
 drivers/net/wireless/ti/wl1251/sdio.c              |    8 +-
 drivers/net/wireless/ti/wl1251/spi.c               |   76 +-
 drivers/net/wireless/ti/wl1251/wl1251.h            |    1 -
 drivers/net/wireless/ti/wlcore/spi.c               |    1 -
 drivers/net/wireless/zydas/zd1201.c                |  174 ++--
 include/linux/bcma/bcma_driver_chipcommon.h        |    2 +-
 include/linux/wl12xx.h                             |   44 -
 include/net/cfg80211-wext.h                        |   20 +-
 net/wireless/scan.c                                |    3 +-
 net/wireless/wext-compat.c                         |  180 ++--
 net/wireless/wext-compat.h                         |    8 +-
 net/wireless/wext-sme.c                            |    5 +-
 107 files changed, 5791 insertions(+), 1424 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/wow.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/wow.h
 delete mode 100644 drivers/net/wireless/ti/wilink_platform_data.c
 delete mode 100644 include/linux/wl12xx.h
