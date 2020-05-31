Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CCA1E96B2
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 11:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgEaJxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 05:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgEaJxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 05:53:44 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C54C061A0E;
        Sun, 31 May 2020 02:53:44 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jfKey-006fbI-Rf; Sun, 31 May 2020 11:53:41 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2020-05-31
Date:   Sun, 31 May 2020 11:53:20 +0200
Message-Id: <20200531095321.18991-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

My apologies that this comes so late, it took me much longer than
I had anticipated to pull together the 6 GHz changes between the
overlaps that Qualcomm and we at Intel had, since we both had much
of this implemented, though with a bit different focus (AP/mesh
vs. client). But I think it's now fine, although I left out the
scanning for now since we're still discussing the userspace API.

Other than that, nothing really big, you can see the tag message
below.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit dc0f3ed1973f101508957b59e529e03da1349e09:

  net: phy: at803x: add cable diagnostics support for ATH9331 and ATH8032 (2020-05-26 23:26:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2020-05-31

for you to fetch changes up to 093a48d2aa4b74db3134b61d7b7a061dbe79177b:

  cfg80211: support bigger kek/kck key length (2020-05-31 11:27:24 +0200)

----------------------------------------------------------------
Another set of changes, including
 * many 6 GHz changes, though it's not _quite_ complete
   (I left out scanning for now, we're still discussing)
 * allow userspace SA-query processing for operating channel
   validation
 * TX status for control port TX, for AP-side operation
 * more per-STA/TID control options
 * move to kHz for channels, for future S1G operation
 * various other small changes

----------------------------------------------------------------
Arend Van Spriel (1):
      cfg80211: adapt to new channelization of the 6GHz band

Gustavo A. R. Silva (2):
      cfg80211: Replace zero-length array with flexible-array
      mac80211: Replace zero-length array with flexible-array

Hauke Mehrtens (1):
      wireless: Use linux/stddef.h instead of stddef.h

Ilan Peer (2):
      mac80211: Add HE 6GHz capabilities element to probe request
      mac80211: Consider 6 GHz band when handling power constraint

Johannes Berg (15):
      mac80211: allow SA-QUERY processing in userspace
      mac80211: fix HT-Control field reception for management frames
      cfg80211: fix 6 GHz frequencies to kHz
      nl80211: really allow client-only BIGTK support
      cfg80211: add a helper to identify 6 GHz PSCs
      ieee80211: add code to obtain and parse 6 GHz operation field
      ieee80211: add HE ext EIDs and 6 GHz capability defines
      cfg80211: add and expose HE 6 GHz band capabilities
      mac80211: avoid using ext NSS high BW if not supported
      mac80211: determine chandef from HE 6 GHz operation
      mac80211: use HE 6 GHz band capability and pass it to the driver
      cfg80211: treat 6 GHz channels as valid regardless of capability
      cfg80211: reject HT/VHT capabilities on 6 GHz band
      cfg80211: require HE capabilities for 6 GHz band
      mac80211: accept aggregation sessions on 6 GHz

Markus Theil (2):
      nl80211: add ability to report TX status for control port TX
      mac80211: support control port TX status reporting

Nathan Errera (1):
      cfg80211: support bigger kek/kck key length

Patrick Steinhardt (1):
      cfg80211: fix CFG82011_CRDA_SUPPORT still mentioning internal regdb

Rajkumar Manoharan (5):
      cfg80211: handle 6 GHz capability of new station
      mac80211: add HE 6 GHz Band Capabilities into parse extension
      mac80211: add HE 6 GHz Band Capability element
      mac80211: build HE operation with 6 GHz oper information
      mac80211: do not allow HT/VHT IEs in 6 GHz mesh mode

Ramon Fontes (1):
      mac80211_hwsim: report the WIPHY_FLAG_SUPPORTS_5_10_MHZ capability

Sergey Matyukevich (4):
      cfg80211: fix mask type in cfg80211_tid_cfg structure
      mac80211: fix variable names in TID config methods
      cfg80211: add support for TID specific AMSDU configuration
      nl80211: simplify peer specific TID configuration

Shaul Triebitz (1):
      mac80211: check the correct bit for EMA AP

Tamizh Chelvam (2):
      mac80211: Add new AMPDU factor macro for HE peer caps
      nl80211: Add support to configure TID specific Tx rate configuration

Thomas Pedersen (4):
      cfg80211: add KHz variants of frame RX API
      nl80211: add KHz frequency offset for most wifi commands
      nl80211: support scan frequencies in KHz
      ieee80211: S1G defines

Tova Mussai (2):
      ieee80211: definitions for reduced neighbor reports
      mac80211: set short_slot for 6 GHz band

 drivers/net/wireless/mac80211_hwsim.c |   1 +
 include/linux/ieee80211.h             | 344 +++++++++++++++++++++++++++++++++-
 include/net/cfg80211.h                | 169 ++++++++++++++---
 include/net/mac80211.h                |  14 +-
 include/uapi/linux/nl80211.h          | 126 ++++++++++---
 include/uapi/linux/wireless.h         |   6 +-
 net/mac80211/agg-rx.c                 |   5 +-
 net/mac80211/agg-tx.c                 |   3 +-
 net/mac80211/cfg.c                    |  13 +-
 net/mac80211/driver-ops.h             |   4 +-
 net/mac80211/he.c                     |  48 +++++
 net/mac80211/ibss.c                   |  11 +-
 net/mac80211/ieee80211_i.h            |  25 ++-
 net/mac80211/main.c                   |   4 +
 net/mac80211/mesh.c                   |  54 +++++-
 net/mac80211/mesh.h                   |   2 +
 net/mac80211/mesh_plink.c             |   9 +-
 net/mac80211/mlme.c                   | 120 ++++++++----
 net/mac80211/rx.c                     | 105 ++++++++---
 net/mac80211/scan.c                   |  23 ++-
 net/mac80211/spectmgmt.c              |   4 +-
 net/mac80211/status.c                 |   9 +-
 net/mac80211/tdls.c                   |   2 +-
 net/mac80211/tx.c                     |  65 +++++--
 net/mac80211/util.c                   | 298 +++++++++++++++++++++++++++--
 net/wireless/Kconfig                  |   4 +-
 net/wireless/chan.c                   |  22 ++-
 net/wireless/core.c                   |  17 +-
 net/wireless/core.h                   |   2 +-
 net/wireless/mlme.c                   |   6 +-
 net/wireless/nl80211.c                | 297 ++++++++++++++++++++++-------
 net/wireless/rdev-ops.h               |   9 +-
 net/wireless/sme.c                    |   7 +-
 net/wireless/trace.h                  |  25 ++-
 net/wireless/util.c                   |  10 +-
 35 files changed, 1575 insertions(+), 288 deletions(-)

