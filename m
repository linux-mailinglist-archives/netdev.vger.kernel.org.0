Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A4954683F
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 16:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbiFJO2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 10:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiFJO2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 10:28:47 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3382C116;
        Fri, 10 Jun 2022 07:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=4RuO1+wQoFbN2SsMygy9LNDebYQnZnP1T7Jr2H7hzqE=; t=1654871325; x=1656080925; 
        b=OUn3nVzTB1lMCz6LZzTNBdIa6Kw+luggfFGSV0E+oUwquR/zkbH8t9s27z8WLImd/J9TAFcQs9v
        lMfjfX7Wn8SY+BTTVGReeeX7Hbi6jGWCQ2cCFwSjPnXucCsynaEhH9qv9aNDlqaOqOMXoXqBUp0O4
        rtNaUwQXtDGpoCMaEgd0aAsmUeNBtlRC4lwhQE9zCpe+tgbsRRFe83S+cPOih2fpmRGGzDjkTWALH
        8vvoqbg1AmE9fR1V8A2RIsW4nDr8oACwqc4Q+1nxttnQ4JF2y2MSPfLioHvHdQTDuhd6pl5CIPg4k
        6FAm7BxgjiXv+I5TPS0LiZaVGSfxAhRlEs8g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nzfcx-001X1m-KZ;
        Fri, 10 Jun 2022 16:28:43 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-next-2022-06-10
Date:   Fri, 10 Jun 2022 16:28:37 +0200
Message-Id: <20220610142838.330862-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

A first set of -next material. As I mention in the tag below
as well, this is mostly to align/flush, so we can start adding
MLD work that would otherwise have some conflicts.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 805cb5aadc2a88c453cfe620b28e12ff2fac27a6:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next (2022-05-19 21:53:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2022-06-10

for you to fetch changes up to 1449c24e71a343a033af8de0842d1edb8a37926a:

  wifi: mac80211_hwsim: Directly use ida_alloc()/free() (2022-06-10 16:13:01 +0200)

----------------------------------------------------------------
wireless-next patches for v5.20

Here's a first set of patches for v5.20. This is just a
queue flush, before we get things back from net-next that
are causing conflicts, and then can start merging a lot
of MLO (multi-link operation, part of 802.11be) code.

Lots of cleanups all over.

The only notable change is perhaps wilc1000 being the
first driver to disable WEP (while enabling WPA3).

----------------------------------------------------------------
Ajay Singh (4):
      wifi: wilc1000: use correct sequence of RESET for chip Power-UP/Down
      wifi: wilc1000: remove WEP security support
      wifi: wilc1000: add WPA3 SAE support
      wifi: wilc1000: add IGTK support

Andy Shevchenko (3):
      wifi: rtw88: use %*ph to print small buffer
      wifi: ray_cs: Utilize strnlen() in parse_addr()
      wifi: ray_cs: Drop useless status variable in parse_addr()

Bernard Zhao (1):
      wifi: cw1200: cleanup the code a bit

Dan Carpenter (1):
      wifi: rtlwifi: fix error codes in rtl_debugfs_set_write_h2c()

Eric Huang (1):
      rtw89: add new state to CFO state machine for UL-OFDMA

Johannes Berg (2):
      wifi: mac80211: remove cipher scheme support
      wifi: mac80211: refactor some key code

Julia Lawall (2):
      wifi: virt_wifi: fix typo in comment
      wifi: nl80211: fix typo in comment

Ke Liu (1):
      wifi: mac80211_hwsim: Directly use ida_alloc()/free()

Larry Finger (4):
      wifi: rtw88: Fix sparse warning for rtw8822b_hw_spec
      wifi: rtw88: Fix Sparse warning for rtw8822c_hw_spec
      wifi: rtw88: Fix Sparse warning for rtw8723d_hw_spec
      wifi: rtw88: Fix Sparse warning for rtw8821c_hw_spec

Minghao Chi (1):
      wifi: wfx: Remove redundant NULL check before release_firmware() call

Ping-Ke Shih (3):
      rtw89: pci: handle hardware watchdog timeout interrupt status
      rtw89: 8852c: rfk: re-calibrate RX DCK once thermal changes a lot
      wifi: rtw89: support MULTI_BSSID and correct BSSID mask of H2C

Po Hao Huang (4):
      rtw89: fix channel inconsistency during hw_scan
      rtw89: fix null vif pointer when hw_scan fails
      ieee80211: add trigger frame definition
      rtw89: 8852c: add trigger frame counter

Po-Hao Huang (1):
      rtw88: fix null vif pointer when hw_scan fails

Zong-Zhe Yang (1):
      rtw89: sar: adjust and support SAR on 6GHz band

 drivers/net/wireless/mac80211_hwsim.c              |   5 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c | 246 +++++++++++++--------
 drivers/net/wireless/microchip/wilc1000/fw.h       |  21 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      | 202 ++++++++---------
 drivers/net/wireless/microchip/wilc1000/hif.h      |  14 +-
 drivers/net/wireless/microchip/wilc1000/netdev.c   |  11 +-
 drivers/net/wireless/microchip/wilc1000/netdev.h   |  14 +-
 drivers/net/wireless/microchip/wilc1000/spi.c      |   6 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |   3 +-
 drivers/net/wireless/microchip/wilc1000/wlan.h     |   2 +
 drivers/net/wireless/microchip/wilc1000/wlan_if.h  |  20 +-
 drivers/net/wireless/ray_cs.c                      |  20 +-
 drivers/net/wireless/realtek/rtlwifi/debug.c       |   8 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |   6 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   5 +-
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8723d.h      |   2 +
 drivers/net/wireless/realtek/rtw88/rtw8723de.c     |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8723de.h     |  10 -
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.h      |   2 +
 drivers/net/wireless/realtek/rtw88/rtw8821ce.c     |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821ce.h     |  10 -
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.h      |   2 +
 drivers/net/wireless/realtek/rtw88/rtw8822be.c     |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822be.h     |  10 -
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |   2 +
 drivers/net/wireless/realtek/rtw88/rtw8822ce.c     |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822ce.h     |  10 -
 drivers/net/wireless/realtek/rtw89/cam.c           |   7 +
 drivers/net/wireless/realtek/rtw89/cam.h           |   8 +
 drivers/net/wireless/realtek/rtw89/core.c          |  56 ++++-
 drivers/net/wireless/realtek/rtw89/core.h          |  45 +++-
 drivers/net/wireless/realtek/rtw89/debug.c         |   3 +-
 drivers/net/wireless/realtek/rtw89/debug.h         |   1 +
 drivers/net/wireless/realtek/rtw89/fw.c            |  24 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |   5 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |  15 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |   1 +
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   2 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   9 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |   1 +
 drivers/net/wireless/realtek/rtw89/phy.c           |  24 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |   1 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |   1 +
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c  |  27 +++
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.h  |   1 +
 drivers/net/wireless/realtek/rtw89/sar.c           | 140 ++++++++++--
 drivers/net/wireless/silabs/wfx/fwio.c             |   3 +-
 drivers/net/wireless/st/cw1200/bh.c                |  10 +-
 drivers/net/wireless/virt_wifi.c                   |   2 +-
 include/linux/ieee80211.h                          |  31 +++
 include/net/mac80211.h                             |  35 ---
 include/uapi/linux/nl80211.h                       |   2 +-
 net/mac80211/cfg.c                                 |  98 ++++----
 net/mac80211/ieee80211_i.h                         |  11 +-
 net/mac80211/iface.c                               |   7 +-
 net/mac80211/key.c                                 |  22 +-
 net/mac80211/key.h                                 |   9 +-
 net/mac80211/main.c                                |  69 +-----
 net/mac80211/mesh_hwmp.c                           |   6 +-
 net/mac80211/mlme.c                                |   6 +-
 net/mac80211/rx.c                                  |  49 +---
 net/mac80211/sta_info.h                            |   4 +-
 net/mac80211/tx.c                                  |  21 +-
 net/mac80211/util.c                                |  70 +-----
 net/mac80211/wpa.c                                 | 133 +----------
 net/mac80211/wpa.h                                 |   5 +-
 70 files changed, 780 insertions(+), 831 deletions(-)
 delete mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723de.h
 delete mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821ce.h
 delete mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822be.h
 delete mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822ce.h

