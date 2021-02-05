Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1A53114B1
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhBEWMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:12:23 -0500
Received: from so15.mailgun.net ([198.61.254.15]:31565 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229566AbhBEOlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 09:41:14 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612541979; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=KCP31NAFObJPL56qHeibLtj+NJn3cmYwD3Gxo6rFaWs=; b=kOVPKXQ2wy9IwcY4GKipdmqICX2l8ELXLMYMzER4HMXDvebuImEbDRi00vxKsvqBdhDI4P0c
 HKr2p/+aNrwHi2trk+sDScw9SMjOqPQwR0/E1yLQVjRLzEPALrAzVHi8gG+3yiXTGAa9eJte
 wUy/AEx4tESteAbOYQPiF3qC2tE=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 601d6ff671c26722934de149 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 05 Feb 2021 16:19:02
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C7F83C433ED; Fri,  5 Feb 2021 16:19:01 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 80CE4C433C6;
        Fri,  5 Feb 2021 16:19:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 80CE4C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2021-02-05
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210205161901.C7F83C433ED@smtp.codeaurora.org>
Date:   Fri,  5 Feb 2021 16:19:01 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 73b7a6047971aa6ce4a70fc4901964d14f077171:

  net: dsa: bcm_sf2: support BCM4908's integrated switch (2021-01-09 19:18:10 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2021-02-05

for you to fetch changes up to 4832bb371c4175ffb506a96accbb08ef2b2466e7:

  iwl4965: do not process non-QOS frames on txq->sched_retry path (2021-01-25 16:43:27 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for v5.12

First set of patches for v5.12. A smaller pull request this time,
biggest feature being a better key handling for ath9k. And of course
the usual fixes and cleanups all over.

Major changes:

ath9k

* more robust encryption key cache management

brcmfmac

* support BCM4365E with 43666 ChipCommon chip ID

----------------------------------------------------------------
Aditya Srivastava (5):
      rtlwifi: rtl_pci: fix bool comparison in expressions
      rtlwifi: rtl8192c-common: fix bool comparison in expressions
      rtlwifi: rtl8188ee: fix bool comparison in expressions
      rtlwifi: rtl8192se: fix bool comparison in expressions
      rtlwifi: rtl8821ae: fix bool comparison in expressions

Amey Narkhede (1):
      qtnfmac_pcie: Use module_pci_driver

Chin-Yen Lee (2):
      rtw88: reduce the log level for failure of tx report
      rtw88: 8723de: adjust the LTR setting

Ching-Te Ku (1):
      rtw88: coex: set 4 slot TDMA for BT link and WL busy

Colin Ian King (1):
      wilc1000: fix spelling mistake in Kconfig "devision" -> "division"

Dan Carpenter (1):
      ath11k: dp: clean up a variable name

Geert Uytterhoeven (1):
      mwifiex: pcie: Drop bogus __refdata annotation

Jouni Malinen (5):
      ath: Use safer key clearing with key cache entries
      ath9k: Clear key cache explicitly on disabling hardware
      ath: Export ath_hw_keysetmac()
      ath: Modify ath_key_delete() to not need full key entry
      ath9k: Postpone key cache entry deletion for TXQ frames reference it

Kalle Valo (2):
      ath11k: pci: remove unnecessary mask in ath11k_pci_enable_ltssm()
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Lorenzo Bianconi (2):
      mt7601u: use ieee80211_rx_list to pass frames to the network stack as a batch
      mt7601u: process tx URBs with status EPROTO properly

Luca Pesce (1):
      brcmfmac: clear EAP/association status bits on linkdown events

Rafał Miłecki (1):
      brcmfmac: support BCM4365E with 43666 ChipCommon chip ID

Rakesh Pillai (2):
      ath10k: Fix error handling in case of CE pipe init failure
      ath10k: Remove voltage regulator votes during wifi disable

Stanislaw Gruszka (1):
      iwl4965: do not process non-QOS frames on txq->sched_retry path

Tian Tao (1):
      wilc1000: use flexible-array member instead of zero-length array

Tony Lindgren (2):
      wlcore: Downgrade exceeded max RX BA sessions to debug
      wlcore: Fix command execute failure 19 for wl12xx

Vincent Fann (1):
      rtw88: 8821c: apply CCK PD level which calculates from dynamic mechanism

Wen Gong (1):
      ath10k: prevent deinitializing NAPI twice

YANG LI (1):
      rtw88: Simplify bool comparison

Zheng Yongjun (2):
      rtw88: Delete useless kfree code
      brcmfmac: Delete useless kfree code

Zhi Han (2):
      mt7601u: process URBs in status EPROTO properly
      mt7601u: check the status of device in calibration

 drivers/net/wireless/ath/ath.h                     |   3 +-
 drivers/net/wireless/ath/ath10k/ahb.c              |   5 +-
 drivers/net/wireless/ath/ath10k/core.c             |  25 +++++
 drivers/net/wireless/ath/ath10k/core.h             |   5 +
 drivers/net/wireless/ath/ath10k/pci.c              |   7 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |   5 +-
 drivers/net/wireless/ath/ath10k/snoc.c             | 103 +++++++++++----------
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   2 +-
 drivers/net/wireless/ath/ath11k/pci.c              |   2 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   2 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   1 +
 drivers/net/wireless/ath/ath9k/main.c              |  95 ++++++++++++++++++-
 drivers/net/wireless/ath/key.c                     |  41 ++++----
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |   1 +
 .../broadcom/brcm80211/brcmfmac/firmware.c         |  10 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   1 +
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |   1 +
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |  11 ++-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   2 +-
 drivers/net/wireless/mediatek/mt7601u/dma.c        |  21 ++++-
 drivers/net/wireless/mediatek/mt7601u/phy.c        |   3 +
 drivers/net/wireless/microchip/wilc1000/Kconfig    |   2 +-
 drivers/net/wireless/microchip/wilc1000/fw.h       |   8 +-
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |  13 +--
 drivers/net/wireless/realtek/rtlwifi/ps.c          |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/dm.c    |   8 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |   4 +-
 .../wireless/realtek/rtlwifi/rtl8192c/dm_common.c  |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |   8 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |   4 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |   2 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   1 -
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |   4 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |   7 --
 drivers/net/wireless/realtek/rtw88/tx.c            |   2 +-
 drivers/net/wireless/ti/wl12xx/main.c              |   3 -
 drivers/net/wireless/ti/wlcore/main.c              |  17 +---
 drivers/net/wireless/ti/wlcore/wlcore.h            |   3 -
 41 files changed, 283 insertions(+), 170 deletions(-)
