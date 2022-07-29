Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065AB585593
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 21:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238344AbiG2T2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 15:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiG2T2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 15:28:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FF65E32E;
        Fri, 29 Jul 2022 12:28:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93175B827B6;
        Fri, 29 Jul 2022 19:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5011C433D6;
        Fri, 29 Jul 2022 19:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659122913;
        bh=IGaQJ8n0Kx7UDMx4Xe/sD9x5Ki9q6wgjQt7ALfttjYs=;
        h=From:Subject:To:Cc:Date:From;
        b=pygbFv+ff9T0L8a6IRja9Vy4KmXTC6jDgzHYAal1fXQoMdoWmMA74A4lqPgkzRuOE
         keFobBtAg2V8ECefv3d6BMaWIeeKupowLdxh2HvH5yJQwNoYwBxWRyEGtQO08ySnlu
         bncARAYLMLc60my3TGzLp0k7H+KFuIQiVjYwQjubRLeaREBIhVI8jtqG/f5fr3lrHX
         MM6PEPiZhkc5MjKXyONsfObHBxJCJMAzod2U8CRb6rKd3SEf4ZljCw0cnHTt4jLDLm
         5IZGwc4FEt3spsA4+7bHyopw0L8Nh6Hk3xbBIz73zOchDpyqJVhG7upTGowcxmHPgj
         bsaTHAWUMXVMQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-next-2022-07-29
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20220729192832.A5011C433D6@smtp.kernel.org>
Date:   Fri, 29 Jul 2022 19:28:32 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

The following changes since commit 8e4372e617854a16d4ec549ba821aad78fd748a6:

  Merge branch 'add-mtu-change-with-stmmac-interface-running' (2022-07-25 19:39:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2022-07-29

for you to fetch changes up to 35610745d71df567297bb40c5e4263cda38dddd5:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2022-07-29 16:38:03 +0300)

----------------------------------------------------------------
wireless-next patches for v5.20

Fourth set of patches for v5.20, last few patches before the merge
window. Only driver changes this time, mostly just fixes and cleanup.

Major changes:

brcmfmac

* support brcm,ccode-map-trivial DT property

wcn36xx

* add debugfs file to show firmware feature strings

----------------------------------------------------------------
Ajay Singh (7):
      wifi: wilc1000: add WID_TX_POWER WID in g_cfg_byte array
      wifi: wilc1000: set correct value of 'close' variable in failure case
      wifi: wilc1000: set station_info flag only when signal value is valid
      wifi: wilc1000: get correct length of string WID from received config packet
      wifi: wilc1000: cancel the connect operation during interface down
      wifi: wilc1000: add 'isinit' flag for SDIO bus similar to SPI
      wifi: wilc1000: use existing iftype variable to store the interface type

Alvin Šipraga (2):
      dt-bindings: bcm4329-fmac: add optional brcm,ccode-map-trivial
      wifi: brcmfmac: support brcm,ccode-map-trivial DT property

Ammar Faizi (1):
      wifi: wil6210: debugfs: fix uninitialized variable use in `wil_write_file_wmi()`

Bryan O'Donoghue (4):
      wifi: wcn36xx: Rename clunky firmware feature bit enum
      wifi: wcn36xx: Move firmware feature bit storage to dedicated firmware.c file
      wifi: wcn36xx: Move capability bitmap to string translation function to firmware.c
      wifi: wcn36xx: Add debugfs entry to read firmware feature strings

Dan Carpenter (1):
      wifi: brcmfmac: use strreplace() in brcmf_of_probe()

Danny van Heumen (1):
      wifi: brcmfmac: prevent double-free on hardware-reset

Hangyu Hua (1):
      wifi: libertas: Fix possible refcount leak in if_usb_probe()

Hans de Goede (2):
      wifi: brcmfmac: Add brcmf_c_set_cur_etheraddr() helper
      wifi: brcmfmac: Replace default (not configured) MAC with a random MAC

Jason Wang (1):
      wifi: mwifiex: Fix comment typo

Jose Ignacio Tornos Martinez (1):
      wifi: iwlwifi: mvm: fix double list_add at iwl_mvm_mac_wake_tx_queue

Justin Stitt (1):
      wifi: iwlwifi: mvm: fix clang -Wformat warnings

Kalle Valo (2):
      Revert "ath11k: add support for hardware rfkill for QCA6390"
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Li Qiong (1):
      wifi: mwl8k: use time_after to replace "jiffies > a"

Manikanta Pubbisetty (1):
      wifi: ath11k: Fix register write failure on QCN9074

Paul Cercueil (1):
      wifi: brcmfmac: Remove #ifdef guards for PM related functions

Ping-Ke Shih (1):
      wifi: rtw89: 8852a: update RF radio A/B R56

Uwe Kleine-König (1):
      wifi: wl12xx: Drop if with an always false condition

William Dean (1):
      wifi: rtw88: check the return value of alloc_workqueue()

Xin Gao (1):
      wifi: b43: do not initialise static variable to 0

Xu Qiang (1):
      wifi: plfxlc: Use eth_zero_addr() to assign zero address

Yang Li (2):
      wifi: mwifiex: clean up one inconsistent indenting
      wifi: b43legacy: clean up one inconsistent indenting

Zhang Jiaming (1):
      wifi: rtlwifi: Remove duplicate word and Fix typo

Zheyu Ma (1):
      wifi: rtl8xxxu: Fix the error handling of the probe function

Zong-Zhe Yang (1):
      wifi: rtw89: 8852a: adjust IMR for SER L1

 .../bindings/net/wireless/brcm,bcm4329-fmac.yaml   |  10 +
 drivers/net/wireless/ath/ath11k/ahb.c              |  52 +-
 drivers/net/wireless/ath/ath11k/core.c             |  87 --
 drivers/net/wireless/ath/ath11k/core.h             |   4 -
 drivers/net/wireless/ath/ath11k/hw.h               |   5 -
 drivers/net/wireless/ath/ath11k/mac.c              |  58 --
 drivers/net/wireless/ath/ath11k/mac.h              |   2 -
 drivers/net/wireless/ath/ath11k/pci.c              |  70 +-
 drivers/net/wireless/ath/ath11k/pcic.c             |  57 +-
 drivers/net/wireless/ath/ath11k/pcic.h             |   2 +
 drivers/net/wireless/ath/ath11k/wmi.c              |  41 -
 drivers/net/wireless/ath/ath11k/wmi.h              |  25 -
 drivers/net/wireless/ath/wcn36xx/Makefile          |   3 +-
 drivers/net/wireless/ath/wcn36xx/debug.c           |  39 +
 drivers/net/wireless/ath/wcn36xx/debug.h           |   1 +
 drivers/net/wireless/ath/wcn36xx/firmware.c        | 125 +++
 drivers/net/wireless/ath/wcn36xx/firmware.h        |  84 ++
 drivers/net/wireless/ath/wcn36xx/hal.h             |  68 --
 drivers/net/wireless/ath/wcn36xx/main.c            |  86 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |  57 +-
 drivers/net/wireless/ath/wcn36xx/smd.h             |   3 -
 drivers/net/wireless/ath/wil6210/debugfs.c         |   4 +-
 drivers/net/wireless/broadcom/b43/main.c           |   2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  49 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   3 +
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  41 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |   3 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   8 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |  12 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  15 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  16 -
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   1 +
 drivers/net/wireless/marvell/libertas/if_usb.c     |   1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   2 +-
 drivers/net/wireless/marvell/mwl8k.c               |   2 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |   3 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   6 +-
 drivers/net/wireless/microchip/wilc1000/hif.h      |   1 +
 drivers/net/wireless/microchip/wilc1000/netdev.c   |   9 +-
 drivers/net/wireless/microchip/wilc1000/netdev.h   |   1 -
 drivers/net/wireless/microchip/wilc1000/sdio.c     |  13 +
 drivers/net/wireless/microchip/wilc1000/spi.c      |   8 +
 drivers/net/wireless/microchip/wilc1000/wlan.c     |   9 +-
 drivers/net/wireless/microchip/wilc1000/wlan.h     |   1 +
 drivers/net/wireless/microchip/wilc1000/wlan_cfg.c |   6 +-
 drivers/net/wireless/purelifi/plfxlc/usb.c         |   2 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  21 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |   2 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   4 +
 drivers/net/wireless/realtek/rtw89/pci.c           |   2 +-
 .../net/wireless/realtek/rtw89/rtw8852a_table.c    | 896 ++++++++++-----------
 drivers/net/wireless/ti/wl12xx/main.c              |   3 -
 55 files changed, 992 insertions(+), 1041 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wcn36xx/firmware.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/firmware.h
