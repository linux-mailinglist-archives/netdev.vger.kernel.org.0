Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0E4649B2A
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 10:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbiLLJay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 04:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbiLLJab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 04:30:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8917A6435;
        Mon, 12 Dec 2022 01:30:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42BE7B80BE8;
        Mon, 12 Dec 2022 09:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5AEC433D2;
        Mon, 12 Dec 2022 09:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670837426;
        bh=yOb3x1WaiL7gvgdAJPPGuqahy5lGVVX2BBG2Zalqifs=;
        h=From:Subject:To:Cc:Date:From;
        b=qq3SrtfymrFJcI+z7Ud8MTkALa5Ivso5364pfJrxoHsVz/GEbYTh6OJFi6LAhQ3v5
         HgkaBKLfrU0+vEFGiMv5lKf4auOMxhpQ3AmN2U2dMfT4dEiB4vZUWbMKvzcv0gFBcp
         ZdplXaLehH6Xrdo6AvgoY9EEbk8twGWeiTr0VjSgnFeAGWnI17W6vYzwPzX5r8vPGO
         SpOWM/R8lAfp/ea5BiKYBaMnZORb26aMobhrxxIk2Wlfh/w4g5QLJCKvTInYKsRQDv
         QCTmK8dG6ouiUcncB5DVzu09DwL3eUhKYDZMadG8ScrrkLI7xiSjKfBIE5a7Cl4Duy
         WpSr8MHa2ZaXQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-next-2022-12-12
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20221212093026.5C5AEC433D2@smtp.kernel.org>
Date:   Mon, 12 Dec 2022 09:30:26 +0000 (UTC)
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

The following changes since commit 65e6af6cebefbf7d8d8ac52b71cd251c2071ad00:

  net: ethernet: mtk_wed: fix sleep while atomic in mtk_wed_wo_queue_refill (2022-12-02 21:23:02 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2022-12-12

for you to fetch changes up to 832c3f66f53f1eb20f424b916a311ad82074ef0d:

  Merge tag 'iwlwifi-next-for-kalle-2022-12-07' of http://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2022-12-08 16:54:33 +0200)

----------------------------------------------------------------
wireless-next patches for v6.2

Fourth set of patches for v6.2. Few final patches, a big change is
that rtw88 now has USB support.

Major changes:

rtw88

* support USB devices rtw8821cu, rtw8822bu, rtw8822cu and rtw8723du

----------------------------------------------------------------
Arend van Spriel (7):
      wifi: brcmfmac: add function to unbind device to bus layer api
      wifi: brcmfmac: add firmware vendor info in driver info
      wifi: brcmfmac: add support for vendor-specific firmware api
      wifi: brcmfmac: add support for Cypress firmware api
      wifi: brcmfmac: add support Broadcom BCA firmware api
      wifi: brcmfmac: add vendor name in revinfo debugfs file
      wifi: brcmfmac: introduce BRCMFMAC exported symbols namespace

Bitterblue Smith (3):
      wifi: rtl8xxxu: Add __packed to struct rtl8723bu_c2h
      wifi: rtl8xxxu: Fix the channel width reporting
      wifi: rtl8xxxu: Introduce rtl8xxxu_update_ra_report

Jakob Koschel (1):
      wifi: iwlwifi: mvm: replace usage of found with dedicated list iterator variable

Jiapeng Chong (1):
      wifi: ipw2x00: Remove some unused functions

Johannes Berg (3):
      wifi: iwlwifi: nvm-parse: enable WiFi7 for Fm radio for now
      wifi: iwlwifi: modify new queue allocation command
      wifi: iwlwifi: fw: use correct IML/ROM status register

Jun ASAKA (1):
      wifi: rtl8xxxu: fixing IQK failures for rtl8192eu

Kalle Valo (1):
      Merge tag 'iwlwifi-next-for-kalle-2022-12-07' of http://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next

Miri Korenblit (1):
      wifi: iwlwifi: mvm: Don't use deprecated register

Mordechay Goodstein (1):
      wifi: iwlwifi: mvm: don't access packet before checking len

Mukesh Sisodiya (3):
      wifi: iwlwifi: dump: Update check for valid FW address
      wifi: iwlwifi: pcie: Add reading and storing of crf and cdb id.
      wifi: iwlwifi: dump: Update check for UMAC valid FW address

Naftali Goldstein (1):
      wifi: iwlwifi: mvm: d3: add TKIP to the GTK iterator

Peter Kosyh (2):
      wifi: rtlwifi: rtl8192se: remove redundant rtl_get_bbreg() call
      wifi: rtlwifi: btcoexist: fix conditions branches that are never executed

Po-Hao Huang (4):
      wifi: rtw89: add mac TSF sync function
      wifi: rtw89: stop mac port function when stop_ap()
      wifi: rtw89: fix unsuccessful interface_add flow
      wifi: rtw89: add join info upon create interface

Sascha Hauer (11):
      wifi: rtw88: print firmware type in info message
      wifi: rtw88: Call rtw_fw_beacon_filter_config() with rtwdev->mutex held
      wifi: rtw88: Drop rf_lock
      wifi: rtw88: Drop h2c.lock
      wifi: rtw88: Drop coex mutex
      wifi: rtw88: iterate over vif/sta list non-atomically
      wifi: rtw88: Add common USB chip support
      wifi: rtw88: Add rtw8821cu chipset support
      wifi: rtw88: Add rtw8822bu chipset support
      wifi: rtw88: Add rtw8822cu chipset support
      wifi: rtw88: Add rtw8723du chipset support

Tom Rix (1):
      wifi: iwlwifi: mei: clean up comments

Wang Yufen (1):
      wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()

Zong-Zhe Yang (2):
      wifi: rtw89: don't request partial firmware if SECURITY_LOADPIN_ENFORCE
      wifi: rtw89: request full firmware only once if it's early requested

 .../wireless/broadcom/brcm80211/brcmfmac/Makefile  |  11 +
 .../broadcom/brcm80211/brcmfmac/bca/Makefile       |  12 +
 .../broadcom/brcm80211/brcmfmac/bca/core.c         |  27 +
 .../broadcom/brcm80211/brcmfmac/bca/module.c       |  27 +
 .../broadcom/brcm80211/brcmfmac/bca/vops.h         |  11 +
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  52 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  30 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  12 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   8 +
 .../broadcom/brcm80211/brcmfmac/cyw/Makefile       |  12 +
 .../broadcom/brcm80211/brcmfmac/cyw/core.c         |  27 +
 .../broadcom/brcm80211/brcmfmac/cyw/module.c       |  27 +
 .../broadcom/brcm80211/brcmfmac/cyw/vops.h         |  11 +
 .../wireless/broadcom/brcm80211/brcmfmac/fwvid.c   | 199 +++++
 .../wireless/broadcom/brcm80211/brcmfmac/fwvid.h   |  47 ++
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  72 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  13 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  27 +-
 .../broadcom/brcm80211/brcmfmac/wcc/Makefile       |  12 +
 .../broadcom/brcm80211/brcmfmac/wcc/core.c         |  27 +
 .../broadcom/brcm80211/brcmfmac/wcc/module.c       |  27 +
 .../broadcom/brcm80211/brcmfmac/wcc/vops.h         |  11 +
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |  11 -
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |  16 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c       |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   4 +
 drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h   |   6 +-
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mei/sap.h       |  10 +-
 .../net/wireless/intel/iwlwifi/mei/trace-data.h    |   2 +-
 drivers/net/wireless/intel/iwlwifi/mei/trace.h     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   9 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  38 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  26 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  33 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   2 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |  73 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 101 +--
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |   5 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/phy.c   |   3 -
 drivers/net/wireless/realtek/rtw88/Kconfig         |  47 ++
 drivers/net/wireless/realtek/rtw88/Makefile        |  15 +
 drivers/net/wireless/realtek/rtw88/coex.c          |   3 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |  15 +
 drivers/net/wireless/realtek/rtw88/fw.c            |  13 +-
 drivers/net/wireless/realtek/rtw88/hci.h           |   9 +-
 drivers/net/wireless/realtek/rtw88/mac.c           |   3 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   2 +-
 drivers/net/wireless/realtek/rtw88/main.c          |  12 +-
 drivers/net/wireless/realtek/rtw88/main.h          |  12 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |   6 +-
 drivers/net/wireless/realtek/rtw88/ps.c            |   2 +-
 drivers/net/wireless/realtek/rtw88/reg.h           |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |  28 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.h      |  13 +-
 drivers/net/wireless/realtek/rtw88/rtw8723du.c     |  36 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |  18 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.h      |  21 +
 drivers/net/wireless/realtek/rtw88/rtw8821cu.c     |  50 ++
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |  19 +
 drivers/net/wireless/realtek/rtw88/rtw8822bu.c     |  90 ++
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  24 +
 drivers/net/wireless/realtek/rtw88/rtw8822cu.c     |  44 +
 drivers/net/wireless/realtek/rtw88/tx.h            |  31 +
 drivers/net/wireless/realtek/rtw88/usb.c           | 911 +++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/usb.h           | 107 +++
 drivers/net/wireless/realtek/rtw88/util.c          | 103 +++
 drivers/net/wireless/realtek/rtw88/util.h          |  12 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   6 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |  60 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |  22 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |  64 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |   3 +
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   3 +
 drivers/net/wireless/realtek/rtw89/reg.h           |  17 +
 80 files changed, 2613 insertions(+), 297 deletions(-)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/Makefile
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/module.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/vops.h
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/Makefile
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/module.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/vops.h
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.h
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/Makefile
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/module.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/vops.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723du.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cu.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bu.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cu.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/usb.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/usb.h
