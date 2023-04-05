Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280C06D7AC7
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 13:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237765AbjDELKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 07:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237568AbjDELKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 07:10:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701DA59DF;
        Wed,  5 Apr 2023 04:10:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B93E63CBC;
        Wed,  5 Apr 2023 11:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4792BC43443;
        Wed,  5 Apr 2023 11:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680693037;
        bh=QDdiAsizQD2pJksHsO5vKjf20QqkDQ1vJFkPygFVjsE=;
        h=From:Subject:To:Cc:Date:From;
        b=nzHxuXoAF7pG5r1UgNumZrpd56IG3aM+hVxs+rIPf1j685pR/chk2M1SooBi5dI+q
         UkVy1dZS5BczzBJaONLF2Em8ZXYN7w2oKsqrCX2nDQKB8OaTzGcAbW5Dii/Oz/8iCh
         TVc54HVyGOiGqO8JAwvGAizi2AQl5zb6R/IA1u+55KWPsDKD9ulI2tyjHxSQABAJ/a
         e12C2SlZUFjiYaFh06OaxusfD/1yVPTEEPvJJ40yx3NOsZuvoINsVDtowJMQA175IS
         evaqkifhhZgn4wlwL/AlNryJYPG44Oiv2Bh1cVdms5GodOpgCqBi+7T7GkPbMczRD7
         6uPg//Arcso2g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-next-2023-04-05
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20230405111037.4792BC43443@smtp.kernel.org>
Date:   Wed,  5 Apr 2023 11:10:37 +0000 (UTC)
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit aa2aa818cd1198cfa2498116d57cd9f13fea80e4:

  wifi: clean up erroneously introduced file (2023-03-30 22:50:12 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2023-04-05

for you to fetch changes up to cbef9a83c51dfcb07f77cfa6ac26f53a1ea86f49:

  wifi: rt2x00: Fix memory leak when handling surveys (2023-04-03 16:44:27 +0300)

----------------------------------------------------------------
wireless-next patches for v6.3

Smaller pull request this time, sending this early to fix the conflict
in mac80211. Nothing really special this time, only smaller changes.

Note: We pulled wireless into wireless-next to fix a complicated
conflict in mac80211.

Major changes:

mac80211/cfg80211

* enable Wi-Fi 7 (EHT) mesh support

----------------------------------------------------------------
Armin Wolf (1):
      wifi: rt2x00: Fix memory leak when handling surveys

Cai Huoqing (2):
      wifi: rtw88: Remove redundant pci_clear_master
      wifi: rtw89: Remove redundant pci_clear_master

Chih-Kang Chang (3):
      wifi: rtw89: set data lowest rate according to AP supported rate
      wifi: rtw89: fix incorrect channel info during scan due to ppdu_sts filtering
      wifi: rtw89: config EDCCA threshold during scan to prevent TX failed

Chin-Yen Lee (1):
      wifi: rtw89: remove superfluous H2C of join_info

Ching-Te Ku (5):
      wifi: rtw89: coex: Add LPS protocol radio state for RTL8852B
      wifi: rtw89: coex: Not to enable firmware report when WiFi is power saving
      wifi: rtw89: coex: Update RTL8852B LNA2 hardware parameter
      wifi: rtw89: coex: Add report control v5 variation
      wifi: rtw89: coex: Update Wi-Fi Bluetooth coexistence version to 7.0.1

Christophe JAILLET (1):
      wifi: rsi: Slightly simplify rsi_set_channel()

Dan Carpenter (1):
      wifi: rndis_wlan: clean up a type issue

Felix Fietkau (6):
      wifi: mac80211: drop bogus static keywords in A-MSDU rx
      wifi: mac80211: fix potential null pointer dereference
      wifi: mac80211: fix receiving mesh packets in forwarding=0 networks
      wifi: mac80211: fix mesh forwarding
      wifi: mac80211: fix flow dissection for forwarded packets
      wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta

Gustavo A. R. Silva (2):
      wifi: rndis_wlan: Replace fake flex-array with flexible-array member
      wifi: rtlwifi: Replace fake flex-array with flex-array member

Jiapeng Chong (1):
      wifi: b43legacy: Remove the unused function prev_slot()

Johannes Berg (1):
      Merge wireless/main into wireless-next/main

Ping-Ke Shih (2):
      wifi: rtw89: add counters of register-based H2C/C2H
      wifi: rtw89: fix potential race condition between napi_init and napi_enable

Rob Herring (1):
      bcma: Use of_address_to_resource()

Ryder Lee (2):
      wifi: mac80211: fix the size calculation of ieee80211_ie_len_eht_cap()
      wifi: mac80211: enable EHT mesh support

Tom Rix (7):
      wifi: ipw2x00: remove unused _ipw_read16 function
      wifi: rtw88: remove unused rtw_pci_get_tx_desc function
      wifi: b43legacy: remove unused freq_r3A_value function
      wifi: brcmsmac: remove unused has_5g variable
      wifi: brcmsmac: ampdu: remove unused suc_mpdu variable
      wifi: mwifiex: remove unused evt_buf variable
      bcma: remove unused mips_read32 function

Wei Chen (2):
      wifi: rtlwifi: fix incorrect error codes in rtl_debugfs_set_write_rfreg()
      wifi: rtlwifi: fix incorrect error codes in rtl_debugfs_set_write_reg()

 drivers/bcma/driver_mips.c                         |   6 -
 drivers/bcma/main.c                                |  10 +-
 drivers/net/wireless/broadcom/b43legacy/dma.c      |   8 -
 drivers/net/wireless/broadcom/b43legacy/radio.c    |  17 --
 .../wireless/broadcom/brcm80211/brcmsmac/ampdu.c   |   3 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   2 -
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |  13 --
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  50 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  29 +++-
 drivers/net/wireless/legacy/rndis_wlan.c           |   8 +-
 drivers/net/wireless/marvell/mwifiex/11h.c         |   4 -
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   8 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |   1 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   3 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  40 +++--
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |   1 +
 drivers/net/wireless/realtek/rtlwifi/debug.c       |  12 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   2 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |   8 -
 drivers/net/wireless/realtek/rtw89/coex.c          | 171 ++++++++++++++++++++-
 drivers/net/wireless/realtek/rtw89/coex.h          |   1 +
 drivers/net/wireless/realtek/rtw89/core.c          |  57 +++++--
 drivers/net/wireless/realtek/rtw89/core.h          |  33 +++-
 drivers/net/wireless/realtek/rtw89/fw.c            |  11 ++
 drivers/net/wireless/realtek/rtw89/mac.c           |   2 +
 drivers/net/wireless/realtek/rtw89/pci.c           |  20 +--
 drivers/net/wireless/realtek/rtw89/phy.c           |  19 +++
 drivers/net/wireless/realtek/rtw89/phy.h           |   1 +
 drivers/net/wireless/realtek/rtw89/reg.h           |  10 ++
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |  14 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |  54 ++++++-
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |  14 +-
 drivers/net/wireless/realtek/rtw89/wow.c           |   9 --
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   7 +-
 net/mac80211/cfg.c                                 |  21 +--
 net/mac80211/ieee80211_i.h                         |   5 +
 net/mac80211/main.c                                |   2 +
 net/mac80211/mesh.c                                |  73 ++++++++-
 net/mac80211/mesh.h                                |   4 +
 net/mac80211/mesh_plink.c                          |  16 +-
 net/mac80211/rx.c                                  |  51 +++---
 net/mac80211/sta_info.c                            |   3 +-
 net/mac80211/util.c                                |  76 ++++++++-
 net/mac80211/wme.c                                 |   6 +-
 net/wireless/nl80211.c                             |  26 ++--
 49 files changed, 718 insertions(+), 229 deletions(-)
