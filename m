Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D97644DDC04
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 15:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbiCROsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 10:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237812AbiCROsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 10:48:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC4C10505F;
        Fri, 18 Mar 2022 07:47:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32326B82249;
        Fri, 18 Mar 2022 14:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9E1C340E8;
        Fri, 18 Mar 2022 14:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647614817;
        bh=hi54bPtdOQ8b6OU4NHuqn6YWgB8ryezgVoAl0X8a4Bg=;
        h=From:Subject:To:Cc:Date:From;
        b=t7fA2zNSUgxpTyrLUF/jm6UGcUDIzOCh7FiQYjfp1+JD5yoT101bspLRp7vYNqOPv
         VtyCdCPQk7Jszf7/Si6Mn7EHqRfHKmzO52bxSSiSMzbaTsUTITglxhGgYtIGJCwSgd
         pvqQpkKHyw9/aYtJ/AEWbIGuV6eKMFt/yPjqac7hKeJE8Y5t/9SMtgiBEz6v51t6E3
         dI2pcW5iyHtSLw11lmvZpjS2KXPcNYkAlIuSGZwKwoxKO81vP1WqJ1tYad0Iz5bgMr
         +17pZ6/qCwbR8rJQw4VlBVSW6GGErb8r85amAbPVo8AoTgcnz9gx73XcSVSZwW6EUh
         qclXsI20NqErQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-next-2022-03-18
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20220318144657.4C9E1C340E8@smtp.kernel.org>
Date:   Fri, 18 Mar 2022 14:46:57 +0000 (UTC)
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit de29aff976d3216e7f3ab41fcd7af46fa8f7eab7:

  Merge tag 'linux-can-next-for-5.18-20220313' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next (2022-03-13 10:25:12 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2022-03-18

for you to fetch changes up to 54f586a9153201c6cff55e1f561990c78bd99aa7:

  rfkill: make new event layout opt-in (2022-03-18 13:09:17 +0200)

----------------------------------------------------------------
wireless-next patches for v5.18

Third set of patches for v5.18. Smaller set this time, support for
mt7921u and some work on MBSSID support. Also a workaround for rfkill
userspace event.

Major changes:

mac80211

* MBSSID beacon handling in AP mode

rfkill

* make new event layout opt-in to workaround buggy user space

rtlwifi

* support On Networks N150 device id

mt76

* mt7915: MBSSID and 6 GHz band support

* new driver mt7921u

----------------------------------------------------------------
Arnd Bergmann (1):
      iwlwifi: mei: fix building iwlmei

Chia-Yuan Li (3):
      rtw89: modify MAC enable functions
      rtw89: disable FW and H2C function if CPU disabled
      rtw89: 8852c: add mac_ctrl_path and mac_cfg_gnt APIs

Chung-Hsuan Hung (1):
      rtw89: 8852c: add read/write rf register function

Colin Ian King (4):
      mwifiex: make read-only array wmm_oui static const
      mt76: connac: make read-only array ba_range static const
      brcmfmac: p2p: Fix spelling mistake "Comback" -> "Comeback"
      rtw89: Fix spelling mistake "Mis-Match" -> "Mismatch"

Dan Carpenter (1):
      mt76: mt7915: check for devm_pinctrl_get() failure

Deren Wu (4):
      mt76: fix monitor mode crash with sdio driver
      mt76: fix invalid rssi report
      mt76: fix wrong HE data rate in sniffer tool
      mt76: fix monitor rx FCS error in DFS channel

Evelyn Tsai (1):
      mt76: mt7915: fix DFS no radar detection event

Johannes Berg (2):
      mac80211: always have ieee80211_sta_restart()
      rfkill: make new event layout opt-in

John Crispin (1):
      mac80211: MBSSID channel switch

Jonathan Teh (1):
      rtlwifi: rtl8192cu: Add On Networks N150

Julia Lawall (4):
      zd1201: use kzalloc
      rtlwifi: rtl8821ae: fix typos in comments
      airo: fix typos in comments
      mt76: mt7915: fix typos in comments

Kalle Valo (1):
      Merge tag 'mt76-for-kvalo-2022-03-16' of https://github.com/nbd168/wireless

Lorenzo Bianconi (19):
      mac80211: MBSSID beacon handling in AP mode
      mac80211: update bssid_indicator in ieee80211_assign_beacon
      mt76: mt7615: honor ret from mt7615_mcu_restart in mt7663u_mcu_init
      mt76: mt7663u: introduce mt7663u_mcu_power_on routine
      mt76: mt7921: make mt7921_init_tx_queues static
      mt76: mt7921: fix xmit-queue dump for usb and sdio
      mt76: mt7921: fix mt7921_queues_acq implementation
      mt76: mt7921: get rid of mt7921_wait_for_mcu_init declaration
      mt76: usb: add req_type to ___mt76u_rr signature
      mt76: usb: add req_type to ___mt76u_wr signature
      mt76: usb: introduce __mt76u_init utility routine
      mt76: mt7921: disable runtime pm for usb
      mt76: mt7921: update mt7921_skb_add_usb_sdio_hdr to support usb
      mt76: mt7921: move mt7921_usb_sdio_tx_prepare_skb in common mac code
      mt76: mt7921: move mt7921_usb_sdio_tx_complete_skb in common mac code.
      mt76: mt7921: move mt7921_usb_sdio_tx_status_data in mac common code.
      mt76: mt7921: add mt7921u driver
      mt76: mt7921: move mt7921_init_hw in a dedicated work
      mt76: mt7915: introduce 802.11ax multi-bss support

Lukas Bulwahn (1):
      MAINTAINERS: fix ath11k DT bindings location

MeiChia Chiu (3):
      mt76: split single ldpc cap bit into bits
      mt76: connac: add 6 GHz support for wtbl and starec configuration
      mt76: mt7915: add 6 GHz support

Peter Chiu (1):
      mt76: mt7915: fix phy cap in mt7915_set_stream_he_txbf_caps()

Ping-Ke Shih (6):
      rtw89: fix uninitialized variable of rtw89_append_probe_req_ie()
      rtw89: add config_rf_reg_v1 to configure RF parameter tables
      rtw89: initialize preload window of D-MAC
      rtw89: change value assignment style of rtw89_mac_cfg_gnt()
      rtw89: extend mac tx_en bits from 16 to 32
      rtw89: implement stop and resume channels transmission v1

Ryder Lee (2):
      mt76: mt7915: allow beaconing on all chains
      mt76: use le32/16_get_bits() whenever possible

Sean Wang (3):
      mt76: mt7921: fix up the monitor mode
      mt76: mt7921: use mt76_hw instead of open coding it
      mt76: mt7921: don't enable beacon filter when IEEE80211_CONF_CHANGE_MONITOR is set

Shayne Chen (4):
      mt76: mt7915: fix eeprom fields of txpower init values
      mt76: mt7915: add txpower init for 6GHz
      mt76: mt7915: set band1 TGID field in tx descriptor
      mt76: mt7915: fix beamforming mib stats

Yuan-Han Zhang (3):
      rtw89: modify dcfo_comp to share with chips
      rtw89: 8852c: add write/read crystal function in CFO tracking
      rtw89: 8852c: add setting of TB UL TX power offset

 MAINTAINERS                                        |   2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   8 +-
 drivers/net/wireless/cisco/airo.c                  |   2 +-
 drivers/net/wireless/intel/iwlwifi/Kconfig         |   1 +
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c     |   2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   5 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |  14 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  20 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   1 +
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |  90 ++++--
 .../net/wireless/mediatek/mt76/mt7615/usb_mcu.c    |  36 ++-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  54 +++-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |  82 ++++--
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |  32 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  59 +++-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    | 147 ++++++----
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    | 105 ++++++-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |  28 +-
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c    |   2 +
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |   4 +
 drivers/net/wireless/mediatek/mt76/mt7921/Kconfig  |  11 +
 drivers/net/wireless/mediatek/mt76/mt7921/Makefile |   2 +
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |  28 +-
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |  74 +++--
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    | 128 +++++++--
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    |   1 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  38 ++-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  33 ++-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |  42 ++-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |   1 +
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |  61 +++-
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   |   7 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mac.c   |  83 ------
 .../net/wireless/mediatek/mt76/mt7921/sdio_mcu.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    | 306 +++++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7921/usb_mac.c    | 252 +++++++++++++++++
 drivers/net/wireless/mediatek/mt76/sdio_txrx.c     |   2 +-
 drivers/net/wireless/mediatek/mt76/usb.c           | 125 +++------
 .../net/wireless/realtek/rtlwifi/rtl8192cu/sw.c    |   1 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    |   6 +-
 drivers/net/wireless/realtek/rtw89/coex.c          |  30 +-
 drivers/net/wireless/realtek/rtw89/core.h          |  47 +++-
 drivers/net/wireless/realtek/rtw89/fw.c            |   2 +-
 drivers/net/wireless/realtek/rtw89/mac.c           | 283 ++++++++++++++++---
 drivers/net/wireless/realtek/rtw89/mac.h           |  12 +-
 drivers/net/wireless/realtek/rtw89/phy.c           | 164 ++++++++++-
 drivers/net/wireless/realtek/rtw89/phy.h           |   9 +
 drivers/net/wireless/realtek/rtw89/reg.h           |  77 ++++++
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |  22 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c  |  24 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |  50 ++++
 drivers/net/wireless/zydas/zd1201.c                |   3 +-
 include/net/mac80211.h                             |   2 +
 include/uapi/linux/rfkill.h                        |  14 +-
 net/mac80211/cfg.c                                 | 128 ++++++++-
 net/mac80211/ieee80211_i.h                         |  15 +
 net/mac80211/mlme.c                                |   2 +-
 net/mac80211/tx.c                                  |  24 +-
 net/rfkill/core.c                                  |  48 +++-
 69 files changed, 2307 insertions(+), 592 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/usb.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/usb_mac.c
