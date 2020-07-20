Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E4C2262D8
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 17:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgGTPEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 11:04:38 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:57190 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728351AbgGTPEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 11:04:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595257476; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: Cc: To: From: Sender;
 bh=Ygn+dWFwmyFfS7pkXED2qSAcf4YXUED3zh0fc/0E+2E=; b=E6l+Y9EWEOHBDQi5kWhBUOlrCqjnDzR8JBhk8EO6W/WVhD9Q0/hc/FdeT9N1eg+BpsZmaeg+
 EXD1e6Jlj8qO6UvHu18Bm1+GYS2XwCdJTyaAZ7wB3wEQQXKBShYuPeTambKdSxvxofri6IgH
 3EavLM4BGDwhSPWdgjqGNkyGACk=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n14.prod.us-west-2.postgun.com with SMTP id
 5f15b2425912b3a4054d0a32 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 20 Jul 2020 15:03:30
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 83072C433CA; Mon, 20 Jul 2020 15:03:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 52CD0C433C9;
        Mon, 20 Jul 2020 15:03:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 52CD0C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-drivers-next-2020-07-20
Date:   Mon, 20 Jul 2020 18:03:26 +0300
Message-ID: <875zai6xfl.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(This is a resend as I don't see the original mail I sent 6h ago in the
netdev patchwork, but the tag has not changed from the original email.)

Hi,

here's a pull request to net-next tree, more info below. Please let me know=
 if
there are any problems.

Kalle

The following changes since commit b3a9e3b9622ae10064826dccb4f7a52bd88c7407:

  Linux 5.8-rc1 (2020-06-14 12:45:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-2020-07-20

for you to fetch changes up to 0e20c3e10333326fc63646fa40b159eb88b7e8c8:

  wireless: Fix trivial spelling (2020-07-15 19:48:14 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.9

First set of patches for v5.9. This comes later than usual as I was
offline for two weeks. The biggest change here is moving Microchip
wilc1000 driver from staging. There was an immutable topic branch with
one commit moving the whole driver and the topic branch was pulled
both to staging-next and wireless-drivers-next. At the moment the only
reported conflict is in MAINTAINERS file, so I'm hoping the move
should go smoothly.

Other notable changes are ath11k getting 6 GHz band support and rtw88
supporting RTL8821CE. And there's also the usual fixes, API changes
and cleanups all over.

Major changes:

wilc1000

* move from drivers/staging to drivers/net/wireless/microchip

ath11k

* add 6G band support

* add spectral scan support

iwlwifi

* make FW reconfiguration quieter by not using warn level

rtw88

* add support for RTL8821CE

----------------------------------------------------------------
Aaron Ma (1):
      rtw88: 8822ce: add support for device ID 0xc82f

Able Liao (1):
      brcmfmac: do not disconnect for disassoc frame from unconnected AP

Ajay Singh (5):
      wilc1000: move wilc driver out of staging
      wilc1000: use strlcpy to avoid 'stringop-truncation' warning
      wilc1000: fix compiler warning for 'wowlan_support' unused variable
      wilc1000: use unified single wilc1000 FW binary
      wilc1000: use API version number info along with firmware filename

Alexander A. Klimov (1):
      ssb: Replace HTTP links with HTTPS ones

Alexander Wetzel (1):
      iwlwifi: Extended Key ID support for mvm and dvm

Amar Shankar (1):
      brcmfmac: reserve 2 credits for host tx control path

Arnd Bergmann (1):
      iwlwifi: mvm: fix gcc-10 zero-length-bounds warning

Ben Greear (1):
      iwlwifi: mvm: Fix avg-power report

Bolarinwa Olayemi Saheed (1):
      iwlegacy: Check the return value of pcie_capability_read_*()

Chi-Hsien Lin (1):
      brcmfmac: reset SDIO bus on a firmware crash

Chris Down (1):
      iwlwifi: Don't IWL_WARN on FW reconfiguration

Chung-Hsien Hsu (1):
      brcmfmac: update tx status flags to sync with firmware

Colin Ian King (2):
      iwlwifi: mvm: remove redundant assignment to variable ret
      iwlegacy: remove redundant initialization of variable tid

Dan Carpenter (1):
      mwifiex: Prevent memory corruption handling keys

Double Lo (1):
      brcmfmac: fix throughput zero stalls on PM 1 mode due to credit map

Evan Green (1):
      ath10k: Acquire tx_lock in tx error paths

Flavio Suligoi (6):
      ath: fix wiki website url
      net: wireless: intel: fix wiki website url
      wireless: fix wiki website url in main Kconfig
      atmel: fix wiki website url
      broadcom: fix wiki website url
      orinoco_usb: fix spelling mistake

Gustavo A. R. Silva (1):
      iwlwifi: Replace zero-length array with flexible-array

Jia-Shyr Chuang (1):
      brcmfmac: increase message buffer size for control packets

Joe Perches (1):
      rtlwifi: Use const in 8188ee/8723be/8821ae swing_table declarations

Joseph Chuang (1):
      brcmfmac: initialize the requested dwell time

Kalle Valo (3):
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2020-06-11' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next
      Merge branch 'wilc1000-move-out-of-staging'

Karthikeyan Periyasamy (2):
      ath11k: Add direct buffer ring support
      ath11k: add support for spectral scan

Kees Cook (2):
      b43: Remove uninitialized_var() usage
      rtlwifi: rtl8192cu: Remove uninitialized_var() usage

Kieran Bingham (1):
      wireless: Fix trivial spelling

Larry Finger (2):
      rtlwifi: Fix endian issue in ps.c
      rtlwifi: rtl8188ee: Fix endian issue

Linus Walleij (1):
      brcm80211: brcmsmac: Move LEDs to GPIO descriptors

Luc Van Oostenryck (1):
      wilc1000: let wilc_mac_xmit() return NETDEV_TX_OK

Luca Ceresoli (1):
      iwlwifi: fix config variable name in comment

Matthias Brugger (1):
      brcmfmac: Transform compatible string for FW loading

Nicolas Ferre (1):
      MAINTAINERS: net: wilc1000: Update entry

Pali Roh=C3=A1r (2):
      mwifiex: Use macro MWIFIEX_MAX_BSS_NUM for specifying limit of interf=
aces
      mwifiex: Fix reporting 'operation not supported' error code

Ping-Ke Shih (1):
      rtlwifi: 8821ae: remove unused path B parameters from swing table

Pradeep Kumar Chitrapu (8):
      ath11k: add 6G frequency list supported by driver
      ath11k: add support for 6GHz radio in driver
      ath11k: Use freq instead of channel number in rx path
      ath11k: extend peer_assoc_cmd for 6GHz band
      ath11k: set psc channel flag when sending channel list to firmware.
      ath11k: Add 6G scan dwell time parameter in scan request command
      ath11k: Send multiple scan_chan_list messages if required
      ath11k: Add support for 6g scan hint

Prasanna Kerekoppa (1):
      brcmfmac: To fix Bss Info flag definition Bug

Rajkumar Manoharan (1):
      ath11k: build HE 6 GHz capability

Raveendran Somu (2):
      brcmfmac: To fix kernel crash on out of boundary access
      brcmfmac: allow credit borrowing for all access categories

Reto Schneider (3):
      rtlwifi: rtl8192cu: Fix deadlock
      rtlwifi: rtl8192cu: Prevent leaking urb
      rtlwifi: rtl8192cu: Free ieee80211_hw if probing fails

Soontak Lee (2):
      brcmfmac: Fix for unable to return to visible SSID
      brcmfmac: Fix for wrong disconnection event source information

Sowmiya Sree Elavalagan (1):
      ath11k: removing redundant reo unlock followed by immediate lock

Sriram R (2):
      ath11k: Add dp tx err stats
      ath11k: Add support for ring backpressure stats

Tony Lindgren (4):
      wlcore: Simplify runtime resume ELP path
      wlcore: Use spin_trylock in wlcore_irq_locked() for running the queue
      wlcore: Use spin_trylock in wlcore_irq() to see if we need to queue tx
      wlcore: Remove pointless spinlock

Tzu-En Huang (12):
      rtw88: 8821c: add basic functions
      rtw88: 8821c: add set tx power index
      rtw88: 8821c: add dig related settings
      rtw88: 8821c: add set channel support
      rtw88: 8821c: add query rx desc support
      rtw88: 8821c: add false alarm statistics
      rtw88: 8821c: add phy calibration
      rtw88: 8821c: add cck pd settings
      rtw88: 8821c: add power tracking
      rtw88: 8821c: add beamformee support
      rtw88: single rf path chips don't support TX STBC
      rtw88: 8821c: Add 8821CE to Kconfig and Makefile

Vaibhav Gupta (5):
      rtl818x_pci: use generic power management
      orinoco: use generic power management
      adm8211: use generic power management
      ipw2100: use generic power management
      ipw2200: use generic power management

Venkateswara Naralasetty (1):
      ath11k: fix wmi peer flags in peer assoc command

Wright Feng (5):
      brcmfmac: fix invalid permanent MAC address in wiphy
      brcmfmac: keep SDIO watchdog running when console_interval is non-zero
      brcmfmac: reduce maximum station interface from 2 to 1 in RSDB mode
      brcmfmac: set state of hanger slot to FREE when flushing PSQ
      brcmfmac: set pacing shift before transmitting skb to bus

Xu Wang (2):
      airo: use set_current_state macro
      zd1211rw: remove needless check before usb_free_coherent()

Yan-Hsuan Chuang (2):
      rtw88: pci: disable aspm for platform inter-op with module parameter
      rtw88: 8822c: add new RFE type 6

YueHaibing (1):
      iwlwifi: mvm: Remove unused inline function iwl_mvm_tid_to_ac_queue

Zong-Zhe Yang (1):
      rtw88: coex: Fix ACL Tx pause during BT inquiry/page.

 .../bindings/net/wireless}/microchip,wilc1000.yaml |    0
 MAINTAINERS                                        |   14 +-
 drivers/net/wireless/Kconfig                       |    3 +-
 drivers/net/wireless/Makefile                      |    1 +
 drivers/net/wireless/admtek/adm8211.c              |   25 +-
 drivers/net/wireless/ath/Kconfig                   |    4 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |    4 +
 drivers/net/wireless/ath/ath10k/usb.c              |    2 +-
 drivers/net/wireless/ath/ath11k/Kconfig            |    9 +
 drivers/net/wireless/ath/ath11k/Makefile           |    4 +-
 drivers/net/wireless/ath/ath11k/core.c             |   10 +
 drivers/net/wireless/ath/ath11k/core.h             |   52 +-
 drivers/net/wireless/ath/ath11k/dbring.c           |  356 ++
 drivers/net/wireless/ath/ath11k/dbring.h           |   79 +
 drivers/net/wireless/ath/ath11k/debug.c            |  128 +-
 drivers/net/wireless/ath/ath11k/dp.c               |    3 +-
 drivers/net/wireless/ath/ath11k/dp.h               |   42 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   36 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |    7 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  220 +-
 drivers/net/wireless/ath/ath11k/reg.c              |    4 +
 drivers/net/wireless/ath/ath11k/spectral.c         | 1023 +++
 drivers/net/wireless/ath/ath11k/spectral.h         |   82 +
 drivers/net/wireless/ath/ath11k/wmi.c              |  690 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |  184 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |    2 +-
 drivers/net/wireless/ath/ath9k/Kconfig             |    5 +-
 drivers/net/wireless/ath/ath9k/hw.c                |    2 +-
 drivers/net/wireless/ath/carl9170/Kconfig          |    2 +-
 drivers/net/wireless/ath/carl9170/usb.c            |    2 +-
 drivers/net/wireless/ath/spectral_common.h         |   17 +
 drivers/net/wireless/ath/wil6210/Kconfig           |    2 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |    2 +-
 drivers/net/wireless/broadcom/b43/main.c           |    2 +-
 drivers/net/wireless/broadcom/b43/phy_n.c          |    2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |    4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |    4 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   48 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |    3 +
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |    2 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |   75 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |    3 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |   19 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |    5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   59 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |    3 +
 .../net/wireless/broadcom/brcm80211/brcmsmac/led.c |   62 +-
 .../net/wireless/broadcom/brcm80211/brcmsmac/led.h |    6 +-
 drivers/net/wireless/cisco/airo.c                  |    4 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |   31 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |   30 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |    2 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |    2 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/Kconfig         |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/commands.h  |   12 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |    1 +
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |   14 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |    2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |    2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h   |    2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    8 -
 .../net/wireless/intersil/orinoco/orinoco_nortel.c |    3 +-
 .../net/wireless/intersil/orinoco/orinoco_pci.c    |    3 +-
 .../net/wireless/intersil/orinoco/orinoco_pci.h    |   32 +-
 .../net/wireless/intersil/orinoco/orinoco_plx.c    |    3 +-
 .../net/wireless/intersil/orinoco/orinoco_tmd.c    |    3 +-
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |    6 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   21 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |    2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |    4 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |   22 +-
 drivers/net/wireless/microchip/Kconfig             |   15 +
 drivers/net/wireless/microchip/Makefile            |    2 +
 .../wireless/microchip}/wilc1000/Kconfig           |    0
 .../wireless/microchip}/wilc1000/Makefile          |    3 -
 .../wireless/microchip}/wilc1000/cfg80211.c        |    2 +
 .../wireless/microchip}/wilc1000/cfg80211.h        |    0
 .../wireless/microchip}/wilc1000/fw.h              |    0
 .../wireless/microchip}/wilc1000/hif.c             |    0
 .../wireless/microchip}/wilc1000/hif.h             |    0
 .../wireless/microchip}/wilc1000/mon.c             |    3 +-
 .../wireless/microchip}/wilc1000/netdev.c          |   35 +-
 .../wireless/microchip}/wilc1000/netdev.h          |    0
 .../wireless/microchip}/wilc1000/sdio.c            |    0
 .../wireless/microchip}/wilc1000/spi.c             |    0
 .../wireless/microchip}/wilc1000/wlan.c            |    0
 .../wireless/microchip}/wilc1000/wlan.h            |    0
 .../wireless/microchip}/wilc1000/wlan_cfg.c        |    0
 .../wireless/microchip}/wilc1000/wlan_cfg.h        |    0
 .../wireless/microchip}/wilc1000/wlan_if.h         |    0
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |   23 +-
 drivers/net/wireless/realtek/rtlwifi/ps.c          |   12 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/dm.c    |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/dm.c    |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    |  138 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   12 +-
 drivers/net/wireless/realtek/rtw88/Kconfig         |   14 +
 drivers/net/wireless/realtek/rtw88/Makefile        |    6 +
 drivers/net/wireless/realtek/rtw88/bf.c            |    5 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |   98 +-
 drivers/net/wireless/realtek/rtw88/coex.h          |    3 +
 drivers/net/wireless/realtek/rtw88/main.c          |   12 +-
 drivers/net/wireless/realtek/rtw88/main.h          |   11 +
 drivers/net/wireless/realtek/rtw88/pci.c           |    9 +
 drivers/net/wireless/realtek/rtw88/reg.h           |    4 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |   13 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      | 1450 +++++
 drivers/net/wireless/realtek/rtw88/rtw8821c.h      |  233 +
 .../net/wireless/realtek/rtw88/rtw8821c_table.c    | 6611 ++++++++++++++++=
++++
 .../net/wireless/realtek/rtw88/rtw8821c_table.h    |   15 +
 drivers/net/wireless/realtek/rtw88/rtw8821ce.c     |   30 +
 drivers/net/wireless/realtek/rtw88/rtw8821ce.h     |   14 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |    7 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   10 +-
 drivers/net/wireless/realtek/rtw88/rtw8822ce.c     |    4 +
 drivers/net/wireless/ti/wlcore/main.c              |   84 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |    4 +-
 drivers/ssb/driver_chipcommon.c                    |    4 +-
 drivers/ssb/driver_chipcommon_pmu.c                |    2 +-
 drivers/ssb/sprom.c                                |    2 +-
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 131 files changed, 11831 insertions(+), 626 deletions(-)
 rename {drivers/staging/wilc1000 =3D> Documentation/devicetree/bindings/ne=
t/wireless}/microchip,wilc1000.yaml (100%)
 create mode 100644 drivers/net/wireless/ath/ath11k/dbring.c
 create mode 100644 drivers/net/wireless/ath/ath11k/dbring.h
 create mode 100644 drivers/net/wireless/ath/ath11k/spectral.c
 create mode 100644 drivers/net/wireless/ath/ath11k/spectral.h
 create mode 100644 drivers/net/wireless/microchip/Kconfig
 create mode 100644 drivers/net/wireless/microchip/Makefile
 rename drivers/{staging =3D> net/wireless/microchip}/wilc1000/Kconfig (100=
%)
 rename drivers/{staging =3D> net/wireless/microchip}/wilc1000/Makefile (72=
%)
 rename drivers/{staging =3D> net/wireless/microchip}/wilc1000/cfg80211.c (=
99%)
 rename drivers/{staging =3D> net/wireless/microchip}/wilc1000/cfg80211.h (=
100%)
 rename drivers/{staging =3D> net/wireless/microchip}/wilc1000/fw.h (100%)
 rename drivers/{staging =3D> net/wireless/microchip}/wilc1000/hif.c (100%)
 rename drivers/{staging =3D> net/wireless/microchip}/wilc1000/hif.h (100%)
 rename drivers/{staging =3D> net/wireless/microchip}/wilc1000/mon.c (98%)
 rename drivers/{staging =3D> net/wireless/microchip}/wilc1000/netdev.c (96=
%)
 rename drivers/{staging =3D> net/wireless/microchip}/wilc1000/netdev.h (10=
0%)
 rename drivers/{staging =3D> net/wireless/microchip}/wilc1000/sdio.c (100%)
 rename drivers/{staging =3D> net/wireless/microchip}/wilc1000/spi.c (100%)
 rename drivers/{staging =3D> net/wireless/microchip}/wilc1000/wlan.c (100%)
 rename drivers/{staging =3D> net/wireless/microchip}/wilc1000/wlan.h (100%)
 rename drivers/{staging =3D> net/wireless/microchip}/wilc1000/wlan_cfg.c (=
100%)
 rename drivers/{staging =3D> net/wireless/microchip}/wilc1000/wlan_cfg.h (=
100%)
 rename drivers/{staging =3D> net/wireless/microchip}/wilc1000/wlan_if.h (1=
00%)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821c.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821c.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821c_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821c_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821ce.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821ce.h
