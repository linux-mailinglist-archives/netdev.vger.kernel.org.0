Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DACF15D675
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 12:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbgBNLTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 06:19:55 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:43012 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728864AbgBNLTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 06:19:55 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j2Z0i-00BUEg-PQ; Fri, 14 Feb 2020 12:19:52 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next next-2020-02-14
Date:   Fri, 14 Feb 2020 12:19:46 +0100
Message-Id: <20200214111947.55727-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

And also for net-next, some updates. I have more in the
queue, but want to get these in first, then forward my
tree, and then get the others to avoid conflicts etc.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit fe23d63422c83cd7c8154dc7faef6af97be4b948:

  Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue (2019-12-31 21:43:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2020-02-14

for you to fetch changes up to 1f6e0baa703d31002c312c3e423c108b04325df0:

  mac80211: allow setting queue_len for drivers not using wake_tx_queue (2020-02-14 09:59:35 +0100)

----------------------------------------------------------------
A few big new things:
 * 802.11 frame encapsulation offload support
 * more HE (802.11ax) support, including some for 6 GHz band
 * powersave in hwsim, for better testing

Of course as usual there are various cleanups and small fixes.

----------------------------------------------------------------
Aditya Pakki (1):
      mac80211: Remove redundant assertion

Andrei Otcheretianski (1):
      mac80211: Accept broadcast probe responses on 6GHz band

Ben Greear (1):
      mac80211: Fix setting txpower to zero

Daniel Gabay (1):
      mac80211: update condition for HE disablement

Haim Dreyfuss (2):
      cfg80211: add no HE indication to the channel flag
      mac80211: check whether HE connection is allowed by the reg domain

Ilan Peer (3):
      mac80211: Handle SMPS mode changes only in AP mode
      mac80211: Remove support for changing AP SMPS mode
      cfg80211/mac80211: Allow user space to register for station Rx authentication

Johannes Berg (7):
      Merge remote-tracking branch 'net-next/master' into mac80211-next
      mac80211_hwsim: remove maximum TX power
      mac80211: simplify and improve HT/VHT/HE disable code
      mac80211: refactor extended element parsing
      mac80211: allow changing TX-related netdev features
      mac80211: remove supported channels element in 6 GHz if ECSA support
      mac80211: set station bandwidth from HE capability

John Crispin (6):
      trivial: mac80211: fix indentation
      mac80211: add 802.11 encapsulation offloading support
      nl80211: add handling for BSS color
      mac80211: add handling for BSS color
      mac80211: fix 11w when using encapsulation offloading
      mac80211: allow setting queue_len for drivers not using wake_tx_queue

Lorenzo Bianconi (1):
      mac80211: debugfs: improve airtime_flags handler readability

Luca Coelho (1):
      mac80211: make ieee80211_wep_init() return void

Markus Theil (3):
      mac80211: fix tx status for no ack cases
      nl80211: add src and dst addr attributes for control port tx/rx
      mac80211: support NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211_MAC_ADDRS

Pi-Hsun Shih (1):
      wireless: Use offsetof instead of custom macro.

Sergey Matyukevich (1):
      ieee80211: add WPA3 OWE AKM suite selector

Shaul Triebitz (1):
      mac80211: parse also the RSNXE IE

Thomas Pedersen (2):
      mac80211_hwsim: add power save support
      mac80211: add ieee80211_is_any_nullfunc()

Toke Høiland-Jørgensen (1):
      mac80211: Always show airtime debugfs file when TXQs are enabled

Tova Mussai (1):
      mac80211: HE: set RX NSS

Veerendranath Jakkam (1):
      cfg80211: Enhance the AKM advertizement to support per interface.

Zvika Yehudai (1):
      ieee80211: fix 'the' doubling in comments

 drivers/net/wireless/ath/ath10k/mac.c             |   3 +-
 drivers/net/wireless/ath/ath9k/main.c             |   3 +
 drivers/net/wireless/ath/ath9k/xmit.c             |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |   2 +-
 drivers/net/wireless/mac80211_hwsim.c             |  11 +-
 include/linux/ieee80211.h                         |  26 +++-
 include/net/cfg80211.h                            |  63 +++++++-
 include/net/mac80211.h                            |  40 ++++-
 include/uapi/linux/nl80211.h                      |  80 +++++++++-
 include/uapi/linux/wireless.h                     |   5 +-
 net/mac80211/cfg.c                                | 106 +------------
 net/mac80211/debugfs.c                            |  56 ++++++-
 net/mac80211/debugfs_netdev.c                     |  13 +-
 net/mac80211/debugfs_sta.c                        |   6 +-
 net/mac80211/he.c                                 |   4 +
 net/mac80211/ht.c                                 |  64 +++-----
 net/mac80211/ieee80211_i.h                        |  28 +++-
 net/mac80211/iface.c                              |  82 +++++++++-
 net/mac80211/key.c                                |  19 ++-
 net/mac80211/main.c                               |  33 ++--
 net/mac80211/mlme.c                               | 139 +++++++++++------
 net/mac80211/rx.c                                 |  14 +-
 net/mac80211/sta_info.c                           |  16 +-
 net/mac80211/status.c                             |  91 ++++++++++-
 net/mac80211/tx.c                                 | 177 +++++++++++++++++++++-
 net/mac80211/util.c                               |  83 ++++++----
 net/mac80211/vht.c                                |  58 ++++++-
 net/mac80211/wep.c                                |   4 +-
 net/mac80211/wep.h                                |   2 +-
 net/wireless/core.h                               |   2 +-
 net/wireless/mlme.c                               |  33 +++-
 net/wireless/nl80211.c                            | 109 ++++++++++++-
 net/wireless/rdev-ops.h                           |   8 +-
 net/wireless/reg.c                                |   2 +
 net/wireless/trace.h                              |  27 ++--
 35 files changed, 1078 insertions(+), 338 deletions(-)

