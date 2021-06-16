Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932103AA1CB
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 18:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhFPQvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 12:51:20 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:22442 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230146AbhFPQvT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 12:51:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623862153; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=pMiGwZTqk2LbtvGnnjhsY3xi28z/R4WHJXxCsaqtNpU=; b=mBpAt8wfnLQ4MXM1Y/D15nGITCkRF0PMFzquESwnkeb+RMa8gvKrRkg0NDD74uYVZ9idgUtR
 1ckOykd3M8j3SVKO5jw3perVLUcZQOTf+XlXagG9TFznZELvRdC2KH+2ah7W2MUd+sPVgo0F
 +5TTMIQ4kFBLWkiInI6gYbNLVr0=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 60ca2b75abfd22a3dc5fa319 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Jun 2021 16:48:53
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 33988C433F1; Wed, 16 Jun 2021 16:48:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C12BDC433D3;
        Wed, 16 Jun 2021 16:48:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C12BDC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2021-06-16
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210616164852.33988C433F1@smtp.codeaurora.org>
Date:   Wed, 16 Jun 2021 16:48:52 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 5ada57a9a6b0be0e6dfcbd4afa519b0347fd5649:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-05-27 09:55:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2021-06-16

for you to fetch changes up to f39c2d1a188de8884d93229bbf1378ea1947a9c8:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2021-06-15 18:47:30 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.14

First set of patches for v5.14. Major new features are here support
WCN6855 PCI in ath11k and WoWLAN support for wcn36xx. Also smaller
fixes and cleanups all over.

ath9k

* provide STBC info in the received frames

brcmfmac

* fix setting of station info chains bitmask

* correctly report average RSSI in station info

rsi

* support for changing beacon interval in AP mode

ath11k

* support for WCN6855 PCI hardware

wcn36xx

* WoWLAN support with magic packets and GTK rekeying

----------------------------------------------------------------
Alvin Šipraga (2):
      brcmfmac: fix setting of station info chains bitmask
      brcmfmac: correctly report average RSSI in station info

Baochen Qiang (7):
      ath11k: add hw reg support for WCN6855
      ath11k: add dp support for WCN6855
      ath11k: setup REO for WCN6855
      ath11k: setup WBM_IDLE_LINK ring once again
      ath11k: add support to get peer id for WCN6855
      ath11k: add support for WCN6855
      ath11k: don't call ath11k_pci_set_l1ss for WCN6855

Bryan O'Donoghue (13):
      wcn36xx: Return result of set_power_params in suspend
      wcn36xx: Run suspend for the first ieee80211_vif
      wcn36xx: Add ipv4 ARP offload support in suspend
      wcn36xx: Do not flush indication queue on suspend/resume
      wcn36xx: Add ipv6 address tracking
      wcn36xx: Add ipv6 namespace offload in suspend
      wcn36xx: Add set_rekey_data callback
      wcn36xx: Add GTK offload to WoWLAN path
      wcn36xx: Add GTK offload info to WoWLAN resume
      wcn36xx: Add Host suspend indication support
      wcn36xx: Add host resume request support
      wcn36xx: Enable WOWLAN flags
      wcn36xx: Move hal_buf allocation to devm_kmalloc in probe

Christophe JAILLET (2):
      brcmsmac: mac80211_if: Fix a resource leak in an error handling path
      ath11k: Fix an error handling path in ath11k_core_fetch_board_data_api_n()

Colin Ian King (3):
      ath10k/ath11k: fix spelling mistake "requed" -> "requeued"
      b43legacy: Fix spelling mistake "overflew" -> "overflowed"
      rtlwifi: rtl8723ae: remove redundant initialization of variable rtstatus

Ding Senjie (1):
      rtlwifi: Fix spelling of 'download'

Guenter Roeck (1):
      brcmsmac: Drop unnecessary NULL check after container_of

Hang Zhang (1):
      cw1200: Revert unnecessary patches that fix unreal use-after-free bugs

Hui Tang (3):
      libertas: remove leading spaces before tabs
      rt2x00: remove leading spaces before tabs
      wlcore: remove leading spaces before tabs

Jiapeng Chong (2):
      wcn36xx: Fix inconsistent indenting
      ath6kl: Fix inconsistent indenting

Johannes Berg (1):
      wil6210: remove erroneous wiphy locking

Kalle Valo (2):
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Lee Gibson (1):
      wl1251: Fix possible buffer overflow in wl1251_cmd_scan

Marek Vasut (2):
      rsi: Assign beacon rate settings to the correct rate_info descriptor field
      rsi: Add support for changing beacon interval

Martin Fuzzey (1):
      rsi: fix AP mode with WPA failure due to encrypted EAPOL

Matthias Brugger (2):
      brcmfmac: Delete second brcm folder hierarchy
      brcmfmac: Add clm_blob firmware files to modinfo

Michael Buesch (1):
      ssb: sdio: Don't overwrite const buffer if block_write fails

Pali Rohár (1):
      ath9k: Fix kernel NULL pointer dereference during ath_reset_internal()

Philipp Borgers (1):
      ath9k: ar9003_mac: read STBC indicator from rx descriptor

Ping-Ke Shih (1):
      rtlwifi: 8821a: btcoexist: add comments to explain why if-else branches are identical

Randy Dunlap (1):
      wireless: carl9170: fix LEDS build errors & warnings

Russell King (4):
      wlcore: tidy up use of fw_log.actual_buff_size
      wlcore: make some of the fwlog calculations more obvious
      wlcore: fix bug reading fwlog
      wlcore: fix read pointer update

Saurav Girepunje (1):
      zd1211rw: Prefer pr_err over printk error msg

Seevalamuthu Mariappan (1):
      ath11k: send beacon template after vdev_start/restart during csa

Shaokun Zhang (2):
      brcmsmac: Remove the repeated declaration
      ath10k: remove the repeated declaration

Shawn Guo (1):
      brcmfmac: use ISO3166 country code and 0 rev as fallback

Shubhankar Kuranagatti (3):
      ssb: gpio: Fix alignment of comment
      ssb: pcicore: Fix indentation of comment
      ssb: Fix indentation of comment

Souptick Joarder (1):
      ipw2x00: Minor documentation update

Stanislaw Gruszka (1):
      rt2x00: do not set timestamp for injected frames

Tian Tao (1):
      ssb: remove unreachable code

Tong Tiangen (1):
      brcmfmac: Fix a double-free in brcmf_sdio_bus_reset

Tony Lindgren (1):
      wlcore/wl12xx: Fix wl12xx get_mac error if device is in ELP

Tudor Ambarus (1):
      wilc1000: Fix clock name binding

Yang Li (3):
      ssb: Remove redundant assignment to err
      rtlwifi: Remove redundant assignments to ul_enc_algo
      ath10k: Fix an error code in ath10k_add_interface()

Yang Shen (9):
      brcmfmac: Demote non-compliant kernel-doc headers
      libertas_tf: Fix wrong function name in comments
      rtlwifi: Fix wrong function name in comments
      rsi: Fix missing function name in comments
      wlcore: Fix missing function name in comments
      wl1251: Fix missing function name in comments
      ath5k: Fix wrong function name in comments
      ath: Fix wrong function name in comments
      wil6210: Fix wrong function name in comments

Yang Yingliang (4):
      ath10k: go to path err_unsupported when chip id is not supported
      ath10k: add missing error return code in ath10k_pci_probe()
      ath10k: remove unused more_frags variable
      ath10k: Use devm_platform_get_and_ioremap_resource()

YueHaibing (3):
      b43legacy: Remove unused inline function txring_to_priority()
      wlcore: use DEVICE_ATTR_<RW|RO> macro
      libertas: use DEVICE_ATTR_RW macro

Zhen Lei (4):
      b43: phy_n: Delete some useless TODO code
      ssb: Fix error return code in ssb_bus_scan()
      ssb: use DEVICE_ATTR_ADMIN_RW() helper macro
      rtlwifi: btcoex: 21a 2ant: Delete several duplicate condition branch codes

Zou Wei (1):
      cw1200: add missing MODULE_DEVICE_TABLE

zuoqilin (1):
      rndis_wlan: simplify is_associated()

Íñigo Huguet (1):
      brcmsmac: improve readability on addresses copy

 drivers/net/wireless/ath/ath10k/ahb.c              |   9 +-
 drivers/net/wireless/ath/ath10k/core.h             |   2 +-
 drivers/net/wireless/ath/ath10k/debug.c            |   4 +-
 drivers/net/wireless/ath/ath10k/htt.h              |   4 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   2 -
 drivers/net/wireless/ath/ath10k/mac.c              |   1 +
 drivers/net/wireless/ath/ath10k/pci.c              |  14 +-
 drivers/net/wireless/ath/ath10k/pci.h              |   1 -
 drivers/net/wireless/ath/ath10k/wmi.c              |   6 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |   9 +-
 drivers/net/wireless/ath/ath11k/core.c             |  47 ++-
 drivers/net/wireless/ath/ath11k/core.h             |   5 +-
 .../net/wireless/ath/ath11k/debugfs_htt_stats.c    |   2 +-
 .../net/wireless/ath/ath11k/debugfs_htt_stats.h    |   2 +-
 drivers/net/wireless/ath/ath11k/dp.c               |  16 +-
 drivers/net/wireless/ath/ath11k/hal.c              |  10 +
 drivers/net/wireless/ath/ath11k/hal.h              |   3 +-
 drivers/net/wireless/ath/ath11k/hal_rx.c           |  42 +--
 drivers/net/wireless/ath/ath11k/hal_rx.h           |   8 +
 drivers/net/wireless/ath/ath11k/hw.c               | 391 +++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/hw.h               |   5 +
 drivers/net/wireless/ath/ath11k/mac.c              |  10 +-
 drivers/net/wireless/ath/ath11k/mhi.c              |   1 +
 drivers/net/wireless/ath/ath11k/pci.c              |  47 ++-
 drivers/net/wireless/ath/ath11k/rx_desc.h          |  87 +++++
 drivers/net/wireless/ath/ath11k/wmi.c              |   4 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |   4 +-
 drivers/net/wireless/ath/ath5k/pcu.c               |   2 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   4 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |   2 +
 drivers/net/wireless/ath/ath9k/main.c              |   5 +
 drivers/net/wireless/ath/carl9170/Kconfig          |   8 +-
 drivers/net/wireless/ath/hw.c                      |   2 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |   2 +-
 drivers/net/wireless/ath/wcn36xx/hal.h             |  20 +-
 drivers/net/wireless/ath/wcn36xx/main.c            | 131 ++++++-
 drivers/net/wireless/ath/wcn36xx/smd.c             | 267 ++++++++++++++
 drivers/net/wireless/ath/wcn36xx/smd.h             |  17 +
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |  14 +
 drivers/net/wireless/ath/wil6210/cfg80211.c        |   2 -
 drivers/net/wireless/ath/wil6210/interrupt.c       |   2 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |   6 +-
 drivers/net/wireless/broadcom/b43/phy_n.c          |  47 ---
 drivers/net/wireless/broadcom/b43legacy/dma.c      |  13 -
 drivers/net/wireless/broadcom/b43legacy/main.c     |   2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  54 +--
 .../broadcom/brcm80211/brcmfmac/firmware.h         |   7 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  19 +-
 .../wireless/broadcom/brcm80211/brcmsmac/aiutils.c |   3 -
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   8 +-
 .../wireless/broadcom/brcm80211/brcmsmac/main.c    |   3 +-
 .../net/wireless/broadcom/brcm80211/brcmsmac/stf.h |   1 -
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |   2 +-
 drivers/net/wireless/marvell/libertas/main.c       |   2 +-
 drivers/net/wireless/marvell/libertas/mesh.c       | 149 ++++----
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |   2 +-
 drivers/net/wireless/microchip/wilc1000/spi.c      |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c   |   5 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    |  20 +-
 drivers/net/wireless/realtek/rtlwifi/cam.c         |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/mac.c   |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/trx.c   |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |   2 +-
 drivers/net/wireless/rndis_wlan.c                  |   5 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   6 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |  20 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   7 +-
 drivers/net/wireless/rsi/rsi_main.h                |   1 -
 drivers/net/wireless/st/cw1200/cw1200_sdio.c       |   1 +
 drivers/net/wireless/st/cw1200/scan.c              |  17 +-
 drivers/net/wireless/ti/wl1251/cmd.c               |  17 +-
 drivers/net/wireless/ti/wl12xx/main.c              |   7 +
 drivers/net/wireless/ti/wlcore/cmd.c               |   6 +-
 drivers/net/wireless/ti/wlcore/event.c             |  67 ++--
 drivers/net/wireless/ti/wlcore/main.c              |   4 +-
 drivers/net/wireless/ti/wlcore/sysfs.c             |  24 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |   4 +-
 drivers/ssb/driver_gpio.c                          |   6 +-
 drivers/ssb/driver_pcicore.c                       |  18 +-
 drivers/ssb/main.c                                 |  36 +-
 drivers/ssb/pci.c                                  |  16 +-
 drivers/ssb/pcmcia.c                               |  16 +-
 drivers/ssb/scan.c                                 |   1 +
 drivers/ssb/sdio.c                                 |   1 -
 87 files changed, 1380 insertions(+), 477 deletions(-)
