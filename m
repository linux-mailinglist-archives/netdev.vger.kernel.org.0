Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7F33F3EBF
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 10:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbhHVIzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 04:55:23 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:10505 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbhHVIzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 04:55:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629622481; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=YLbl0xRcr1U5W8rQS7Nr5kE5XUjSm6COojhpg7Ltu54=; b=AVNp6GsZxSeiH1cKA4oyihoowCZlN5GdXVX1c1C+p2smkDJ7fIzFjtgzONX63JTM+wvlwERf
 GgpkttoVPoH7c4q51jP6B6u8n0OIfS43DiFMoT4j0DtSHH1fE3KmySnKs2HQVC53IL4C5isf
 Yg0XHSLn180qigPUzrDBdR3CPvM=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 612210cef588e42af1f91ab5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 22 Aug 2021 08:54:38
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 360ACC4338F; Sun, 22 Aug 2021 08:54:38 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DDE8FC4338F;
        Sun, 22 Aug 2021 08:54:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org DDE8FC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2021-08-22
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210822085438.360ACC4338F@smtp.codeaurora.org>
Date:   Sun, 22 Aug 2021 08:54:38 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit af996031e1545c47423dfdd024840702ceb5a26c:

  net: ixp4xx_hss: use dma_pool_zalloc (2021-07-26 14:17:55 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2021-08-22

for you to fetch changes up to 0dc62413c882d765db7a3ff4d507e8c0a804ba68:

  brcmsmac: make array addr static const, makes object smaller (2021-08-21 22:20:17 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.15

First set of patches for v5.15. This got delayed as I have been mostly
offline for the last few weeks. The biggest change is removal of
prism54 driver, otherwise just smaller changes.

Major changes:

ath5k, ath9k, ath10k, ath11k:

* switch from 'pci_' to 'dma_' API

brcmfmac

* allow per-board firmware binaries

* add support 43752 SDIO device

prism54

* remove the obsoleted driver, everyone should be using p54 driver instead

----------------------------------------------------------------
Andy Shevchenko (1):
      ray_cs: use %*ph to print small buffer

Angus Ainslie (1):
      brcmfmac: add 43752 SDIO ids and initialization

Arend van Spriel (4):
      brcmfmac: use different error value for invalid ram base address
      brcmfmac: increase core revision column aligning core list
      brcmfmac: add xtlv support to firmware interface layer
      brcmfmac: support chipsets with different core enumeration space

Chin-Yen Lee (6):
      rtw88: adjust the log level for failure of tx report
      rtw88: 8822ce: set CLKREQ# signal to low during suspend
      rtw88: use read_poll_timeout instead of fixed sleep
      rtw88: refine the setting of rsvd pages for different firmware
      rtw88: wow: report wow reason through mac80211 api
      rtw88: wow: fix size access error of probe request

Chris Chiu (2):
      rtl8xxxu: disable interrupt_in transfer for 8188cu and 8192cu
      rtl8xxxu: Fix the handling of TX A-MPDU aggregation

Christophe JAILLET (2):
      ath: switch from 'pci_' to 'dma_' API
      ath11k: Remove some duplicate code

Claudiu Beznea (3):
      wilc1000: use goto labels on error path
      wilc1000: dispose irq on failure path
      wilc1000: use devm_clk_get_optional()

Colin Ian King (4):
      rtlwifi: rtl8192de: Remove redundant variable initializations
      rtlwifi: rtl8192de: make arrays static const, makes object smaller
      mwifiex: make arrays static const, makes object smaller
      brcmsmac: make array addr static const, makes object smaller

Dan Carpenter (2):
      rsi: fix error code in rsi_load_9116_firmware()
      rsi: fix an error code in rsi_probe()

Gustavo A. R. Silva (1):
      mwifiex: usb: Replace one-element array with flexible-array member

Kalle Valo (1):
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Kees Cook (2):
      ipw2x00: Avoid field-overflowing memcpy()
      ray_cs: Split memcpy() to avoid bounds check warning

Len Baker (2):
      ipw2x00: Use struct_size helper instead of open-coded arithmetic
      rtw88: Remove unnecessary check code

Linus Walleij (2):
      brcmfmac: firmware: Allow per-board firmware binaries
      brcmfmac: firmware: Fix firmware loading

Lukas Bulwahn (1):
      intersil: remove obsolete prism54 wireless driver

Mikhail Rudenko (1):
      brcmfmac: use separate firmware for 43430 revision 2

Ping-Ke Shih (1):
      rtw88: wow: build wow function only if CONFIG_PM is on

Po-Hao Huang (2):
      rtw88: 8822c: add tx stbc support under HT mode
      rtw88: change beacon filter default mode

Sean Anderson (1):
      brcmfmac: Set SDIO workqueue as WQ_HIGHPRI

Tuo Li (1):
      mwifiex: drop redundant null-pointer check in mwifiex_dnld_cmd_to_fw()

dingsenjie (1):
      libertas: Remove unnecessary label of lbs_ethtool_get_eeprom

wengjianfeng (1):
      wilc1000: remove redundant code

 MAINTAINERS                                        |    7 -
 drivers/net/wireless/ath/ath10k/pci.c              |    9 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |    5 -
 drivers/net/wireless/ath/ath11k/pci.c              |   10 +-
 drivers/net/wireless/ath/ath5k/pci.c               |    2 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    8 +-
 .../wireless/broadcom/brcm80211/brcmfmac/Makefile  |    3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |    4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |   29 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.h    |    5 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |   69 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.c    |  126 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.h    |    8 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   30 +-
 .../wireless/broadcom/brcm80211/brcmfmac/xtlv.c    |   82 +
 .../wireless/broadcom/brcm80211/brcmfmac/xtlv.h    |   31 +
 .../wireless/broadcom/brcm80211/brcmsmac/main.c    |    2 +-
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |    1 +
 .../net/wireless/broadcom/brcm80211/include/soc.h  |    2 +-
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |   56 +-
 drivers/net/wireless/intel/ipw2x00/libipw_tx.c     |    4 +-
 drivers/net/wireless/intersil/Kconfig              |   20 -
 drivers/net/wireless/intersil/Makefile             |    1 -
 drivers/net/wireless/intersil/prism54/Makefile     |    9 -
 drivers/net/wireless/intersil/prism54/isl_38xx.c   |  245 --
 drivers/net/wireless/intersil/prism54/isl_38xx.h   |  158 --
 drivers/net/wireless/intersil/prism54/isl_ioctl.c  | 2909 --------------------
 drivers/net/wireless/intersil/prism54/isl_ioctl.h  |   35 -
 drivers/net/wireless/intersil/prism54/isl_oid.h    |  492 ----
 drivers/net/wireless/intersil/prism54/islpci_dev.c |  951 -------
 drivers/net/wireless/intersil/prism54/islpci_dev.h |  204 --
 drivers/net/wireless/intersil/prism54/islpci_eth.c |  489 ----
 drivers/net/wireless/intersil/prism54/islpci_eth.h |   59 -
 .../net/wireless/intersil/prism54/islpci_hotplug.c |  316 ---
 drivers/net/wireless/intersil/prism54/islpci_mgt.c |  491 ----
 drivers/net/wireless/intersil/prism54/islpci_mgt.h |  126 -
 drivers/net/wireless/intersil/prism54/oid_mgt.c    |  889 ------
 drivers/net/wireless/intersil/prism54/oid_mgt.h    |   46 -
 .../net/wireless/intersil/prism54/prismcompat.h    |   30 -
 drivers/net/wireless/marvell/libertas/ethtool.c    |    9 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |    2 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |    4 +-
 drivers/net/wireless/marvell/mwifiex/usb.h         |    2 +-
 drivers/net/wireless/microchip/wilc1000/sdio.c     |   29 +-
 drivers/net/wireless/microchip/wilc1000/spi.c      |   29 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |   38 +-
 drivers/net/wireless/ray_cs.c                      |    8 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |    2 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   37 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |   52 +-
 drivers/net/wireless/realtek/rtw88/Makefile        |    2 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |    8 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |    3 +-
 drivers/net/wireless/realtek/rtw88/main.c          |    2 +
 drivers/net/wireless/realtek/rtw88/main.h          |    6 +
 drivers/net/wireless/realtek/rtw88/pci.c           |   38 +-
 drivers/net/wireless/realtek/rtw88/pci.h           |    1 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |    1 +
 drivers/net/wireless/realtek/rtw88/tx.c            |    2 +-
 drivers/net/wireless/realtek/rtw88/wow.c           |  107 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |    4 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |    1 +
 include/linux/mmc/sdio_ids.h                       |    1 +
 64 files changed, 615 insertions(+), 7739 deletions(-)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.h
 delete mode 100644 drivers/net/wireless/intersil/prism54/Makefile
 delete mode 100644 drivers/net/wireless/intersil/prism54/isl_38xx.c
 delete mode 100644 drivers/net/wireless/intersil/prism54/isl_38xx.h
 delete mode 100644 drivers/net/wireless/intersil/prism54/isl_ioctl.c
 delete mode 100644 drivers/net/wireless/intersil/prism54/isl_ioctl.h
 delete mode 100644 drivers/net/wireless/intersil/prism54/isl_oid.h
 delete mode 100644 drivers/net/wireless/intersil/prism54/islpci_dev.c
 delete mode 100644 drivers/net/wireless/intersil/prism54/islpci_dev.h
 delete mode 100644 drivers/net/wireless/intersil/prism54/islpci_eth.c
 delete mode 100644 drivers/net/wireless/intersil/prism54/islpci_eth.h
 delete mode 100644 drivers/net/wireless/intersil/prism54/islpci_hotplug.c
 delete mode 100644 drivers/net/wireless/intersil/prism54/islpci_mgt.c
 delete mode 100644 drivers/net/wireless/intersil/prism54/islpci_mgt.h
 delete mode 100644 drivers/net/wireless/intersil/prism54/oid_mgt.c
 delete mode 100644 drivers/net/wireless/intersil/prism54/oid_mgt.h
 delete mode 100644 drivers/net/wireless/intersil/prism54/prismcompat.h
