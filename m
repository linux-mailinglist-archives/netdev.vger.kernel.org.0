Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C552027254F
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgIUNWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgIUNWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:22:50 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BFFC061755;
        Mon, 21 Sep 2020 06:22:50 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kKLmJ-008Ev0-Kx; Mon, 21 Sep 2020 15:22:47 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-09-21
Date:   Mon, 21 Sep 2020 15:22:40 +0200
Message-Id: <20200921132241.25883-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

We have a few more fixes for 5.9, see below.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 5f6857e808a8bd078296575b417c4b9d160b9779:

  nfp: use correct define to return NONE fec (2020-09-17 17:59:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2020-09-21

for you to fetch changes up to 75bcbd6913de649601f4e7d3fb6d2b5effc24e9e:

  mac80211: fix 80 MHz association to 160/80+80 AP on 6 GHz (2020-09-18 14:01:24 +0200)

----------------------------------------------------------------
Just a few fixes:
 * fix using HE on 2.4 GHz
 * AQL (airtime queue limit) estimation & VHT160 fix
 * do not oversize A-MPDUs if local capability is smaller than peer's
 * fix radiotap on 6 GHz to not put 2.4 GHz flag
 * fix Kconfig for lib80211
 * little fixlet for 6 GHz channel number / frequency conversion

----------------------------------------------------------------
Aloka Dixit (1):
      mac80211: Fix radiotap header channel flag for 6GHz band

Felix Fietkau (3):
      mac80211: extend AQL aggregation estimation to HE and fix unit mismatch
      mac80211: add AQL support for VHT160 tx rates
      mac80211: do not allow bigger VHT MPDUs than the hardware supports

Johannes Berg (1):
      cfg80211: fix 6 GHz channel conversion

John Crispin (1):
      mac80211: fix 80 MHz association to 160/80+80 AP on 6 GHz

Necip Fazil Yildiran (1):
      lib80211: fix unmet direct dependendices config warning when !CRYPTO

Wen Gong (1):
      mac80211: do not disable HE if HT is missing on 2.4 GHz

 net/mac80211/airtime.c | 20 ++++++++++++++------
 net/mac80211/mlme.c    |  3 ++-
 net/mac80211/rx.c      |  3 ++-
 net/mac80211/util.c    |  7 ++++---
 net/mac80211/vht.c     |  8 ++++----
 net/wireless/Kconfig   |  1 +
 net/wireless/util.c    |  2 +-
 7 files changed, 28 insertions(+), 16 deletions(-)

