Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632C05A24BA
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 11:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245203AbiHZJoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 05:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiHZJoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 05:44:38 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B39D4F4D;
        Fri, 26 Aug 2022 02:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=v2jTZUhYTOmemv/vPlUUXTiKKHa/RyOxkjzEnHhLu9M=; t=1661507076; x=1662716676; 
        b=OJD60mMD+AwEd0bhTb0DWGVbt7K/448ahTJl6liMRgddWHK5rB6KnOAvkZRtw+wWylu7IojrQpn
        R1XK0S0nmhXmZ9MvGELU5kKr9yVjC6bnvMSNV3Wsn+JRdnlvT8gi2EXZDDefICZkeBiCxDIcwky2h
        rKzT8kwkHV8vMM2iqoRmYAJDDwpPTDgn9YTmJS2cnzpu8VNrALkggbkRmYzcHLhcaiH2t63GWzK+p
        TEV4tle+9UbnTef8DDvrUp+jPqhgCh6kwDK2P9pibkQc1H91IkWSWyhs9R41Xn+//sr45F/xavg0j
        l7DAGDszfk1JyUAWdZjVWJWSe5QI19ktAf/g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oRVtB-000BfU-2F;
        Fri, 26 Aug 2022 11:44:33 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-next-2022-08-26
Date:   Fri, 26 Aug 2022 11:44:29 +0200
Message-Id: <20220826094430.19793-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

And here's a one for net-next. Nothing major this time
around either, MLO work continues of course, along with
various other updates. Drivers are lagging behind a bit,
but we'll have that sorted out too.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 63757225a93353bc2ce4499af5501eabdbbf23f9:

  Merge tag 'mlx5-updates-2022-07-28' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2022-07-29 21:39:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2022-08-26

for you to fetch changes up to be50baa40e90a18c3750b31a49be64929488d84b:

  wifi: mac80211: use full 'unsigned int' type (2022-08-26 09:58:54 +0200)

----------------------------------------------------------------
Various updates:
 * rtw88: operation, locking, warning, and code style fixes
 * rtw89: small updates
 * cfg80211/mac80211: more EHT/MLO (802.11be, WiFi 7) work
 * brcmfmac: a couple of fixes
 * misc cleanups etc.

----------------------------------------------------------------
Chia-Yuan Li (1):
      wifi: rtw89: 8852a: correct WDE IMR settings

Chih-Kang Chang (9):
      wifi: rtw88: fix stopping queues in wrong timing when HW scan
      wifi: rtw88: fix store OP channel info timing when HW scan
      wifi: rtw88: add mutex when set SAR
      wifi: rtw88: add mutex when set regulatory and get Tx power table
      wifi: rtw88: add the update channel flow to support setting by parameters
      wifi: rtw88: fix WARNING:rtw_get_tx_power_params() during HW scan
      wifi: rtw88: add flushing queue before HW scan
      wifi: rtw88: add flag check before enter or leave IPS
      wifi: rtw88: prohibit enter IPS during HW scan

Hari Chandrakanthan (1):
      wifi: mac80211: allow bw change during channel switch in mesh

Ilan Peer (1):
      wifi: cfg80211: Update RNR parsing to align with Draft P802.11be_D2.0

Johannes Berg (12):
      wifi: mac80211: accept STA changes without link changes
      wifi: mac80211: fix use-after-free
      wifi: mac80211: properly implement MLO key handling
      wifi: mac80211: use link ID for MLO in queued frames
      wifi: mac80211_hwsim: split iftype data into AP/non-AP
      wifi: cfg80211/mac80211: check EHT capability size correctly
      wifi: mac80211: maintain link_id in link_sta
      wifi: mac80211_hwsim: fix link change handling
      wifi: mac80211: set link ID in TX info for beacons
      wifi: mac80211: fix control port frame addressing
      wifi: mac80211: allow link address A2 in TXQ dequeue
      wifi: mac80211: correct SMPS mode in HE 6 GHz capability

Krzysztof Kozlowski (1):
      dt-bindings: wireless: use spi-peripheral-props.yaml

Lukas Bulwahn (1):
      wifi: mac80211: clean up a needless assignment in ieee80211_sta_activate_link()

Mordechay Goodstein (1):
      wifi: mac80211: mlme: don't add empty EML capabilities

Ping-Ke Shih (2):
      wifi: rtw88: access chip_info by const pointer
      wifi: rtlwifi: 8192de: correct checking of IQK reload

Po-Hao Huang (1):
      wifi: rtw88: 8822c: extend supported probe request size

Ruffalo Lavoisier (1):
      wifi: brcmsmac: remove duplicate words

Ryder Lee (1):
      wifi: mac80211: read ethtool's sta_stats from sinfo

Sebin Sebastian (1):
      wifi: qtnfmac: remove braces around single statement blocks

Shaul Triebitz (5):
      wifi: mac80211: properly set old_links when removing a link
      wifi: cfg80211: get correct AP link chandef
      wifi: mac80211: set link BSSID
      wifi: cfg80211: add link id to txq params
      wifi: mac80211: use link in TXQ parameter configuration

Vasanthakumar Thiagarajan (2):
      wifi: mac80211: add link information in ieee80211_rx_status
      wifi: mac80211: use the corresponding link for stats update

Veerendranath Jakkam (5):
      wifi: cfg80211: reject connect response with MLO params for WEP
      wifi: cfg80211: Prevent cfg80211_wext_siwencodeext() on MLD
      wifi: cfg80211: Add link_id parameter to various key operations for MLO
      wifi: nl80211: send MLO links channel info in GET_INTERFACE
      wifi: cfg80211: Add link_id to cfg80211_ch_switch_started_notify()

Wataru Gohda (2):
      wifi: brcmfmac: Fix to add brcmf_clear_assoc_ies when rmmod
      wifi: brcmfmac: Fix to add skb free for TIM update info when tx is completed

Wolfram Sang (1):
      wifi: mac80211: move from strlcpy with unused retval to strscpy

Wright Feng (3):
      wifi: brcmfmac: fix continuous 802.1x tx pending timeout error
      wifi: brcmfmac: fix scheduling while atomic issue when deleting flowring
      wifi: brcmfmac: fix invalid address access when enabling SCAN log level

Xin Gao (1):
      wifi: mac80211: use full 'unsigned int' type

Zong-Zhe Yang (2):
      wifi: rtw88: phy: fix warning of possible buffer overflow
      wifi: rtw89: refine leaving LPS function

 .../bindings/net/wireless/microchip,wilc1000.yaml  |   7 +-
 .../bindings/net/wireless/silabs,wfx.yaml          |  15 +-
 .../bindings/net/wireless/ti,wlcore.yaml           |  30 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   8 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |  10 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |   3 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  23 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   4 +-
 .../broadcom/brcm80211/brcmfmac/flowring.c         |   5 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |  16 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  25 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c |  12 +-
 .../wireless/broadcom/brcm80211/brcmsmac/types.h   |   2 +-
 drivers/net/wireless/mac80211_hwsim.c              | 394 ++++++++++++++++++++-
 drivers/net/wireless/marvell/libertas/cfg.c        |   9 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  10 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |  17 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  16 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |   9 +-
 drivers/net/wireless/realtek/rtw88/bf.c            |   2 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |  88 ++---
 drivers/net/wireless/realtek/rtw88/coex.h          |  14 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |  11 +-
 drivers/net/wireless/realtek/rtw88/efuse.c         |   4 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |  95 +++--
 drivers/net/wireless/realtek/rtw88/fw.h            |  21 +-
 drivers/net/wireless/realtek/rtw88/mac.c           |  18 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |  14 +-
 drivers/net/wireless/realtek/rtw88/main.c          | 213 ++++++-----
 drivers/net/wireless/realtek/rtw88/main.h          |  31 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |  20 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |  65 ++--
 drivers/net/wireless/realtek/rtw88/phy.h           |   2 +-
 drivers/net/wireless/realtek/rtw88/ps.c            |   7 +-
 drivers/net/wireless/realtek/rtw88/regd.c          |   2 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |   3 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |   3 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |   3 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   3 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |   8 +-
 drivers/net/wireless/realtek/rtw88/util.c          |   4 +-
 drivers/net/wireless/realtek/rtw89/ps.c            |   3 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |  21 +-
 drivers/net/wireless/rndis_wlan.c                  |  20 +-
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |  13 +-
 drivers/staging/wlan-ng/cfg80211.c                 |  12 +-
 include/linux/ieee80211.h                          |  14 +-
 include/net/cfg80211.h                             |  43 ++-
 include/net/mac80211.h                             |   9 +
 include/uapi/linux/nl80211.h                       |  14 +-
 net/mac80211/cfg.c                                 | 129 +++++--
 net/mac80211/eht.c                                 |   4 +-
 net/mac80211/ethtool.c                             |  10 +-
 net/mac80211/ibss.c                                |   8 +-
 net/mac80211/ieee80211_i.h                         |   8 +-
 net/mac80211/iface.c                               |  13 +-
 net/mac80211/key.c                                 | 190 +++++++---
 net/mac80211/key.h                                 |  13 +-
 net/mac80211/mesh.c                                |   2 +-
 net/mac80211/mlme.c                                |  73 +++-
 net/mac80211/rx.c                                  | 200 +++++++++--
 net/mac80211/sta_info.c                            |   9 +-
 net/mac80211/tx.c                                  |  65 +++-
 net/mac80211/util.c                                |  32 +-
 net/wireless/core.c                                |  16 +
 net/wireless/ibss.c                                |   2 +-
 net/wireless/nl80211.c                             | 186 +++++++---
 net/wireless/rdev-ops.h                            |  58 +--
 net/wireless/reg.c                                 |   4 +
 net/wireless/scan.c                                |   2 +-
 net/wireless/sme.c                                 |   5 +-
 net/wireless/trace.h                               |  97 +++--
 net/wireless/util.c                                |   4 +-
 net/wireless/wext-compat.c                         |  18 +-
 75 files changed, 1851 insertions(+), 695 deletions(-)

