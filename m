Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A581A33EE23
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 11:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhCQKNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 06:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhCQKMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 06:12:44 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C059C06174A;
        Wed, 17 Mar 2021 03:12:43 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lMTAN-00HIqt-Or; Wed, 17 Mar 2021 11:12:39 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2021-03-17
Date:   Wed, 17 Mar 2021 11:12:34 +0100
Message-Id: <20210317101235.11186-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

So here's a first set of fixes for the current rc cycle,
really nothing major, though the network namespace locking
fix is something a few people have been running into.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 13832ae2755395b2585500c85b64f5109a44227e:

  mptcp: fix ADD_ADDR HMAC in case port is specified (2021-03-15 16:43:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2021-03-17

for you to fetch changes up to 239729a21e528466d02f5558936306ffa9314ad1:

  wireless/nl80211: fix wdev_id may be used uninitialized (2021-03-16 21:20:47 +0100)

----------------------------------------------------------------
First round of fixes for 5.12-rc:
 * HE (802.11ax) elements can be extended, handle that
 * fix locking in network namespace changes that was
   broken due to the RTNL-redux work
 * various other small fixes

----------------------------------------------------------------
Brian Norris (1):
      mac80211: Allow HE operation to be longer than expected.

Daniel Phan (1):
      mac80211: Check crypto_aead_encrypt for errors

Jarod Wilson (1):
      wireless/nl80211: fix wdev_id may be used uninitialized

Johannes Berg (3):
      mac80211: fix rate mask reset
      mac80211: minstrel_ht: remove unused variable 'mg'
      nl80211: fix locking for wireless device netns change

Karthikeyan Kathirvel (1):
      mac80211: choose first enabled channel for monitor

Markus Theil (1):
      mac80211: fix double free in ibss_leave

 net/mac80211/aead_api.c            |  5 +++--
 net/mac80211/aes_gmac.c            |  5 +++--
 net/mac80211/cfg.c                 |  4 ++--
 net/mac80211/ibss.c                |  2 ++
 net/mac80211/main.c                | 13 ++++++++++++-
 net/mac80211/mlme.c                |  2 +-
 net/mac80211/rc80211_minstrel_ht.c |  2 --
 net/mac80211/util.c                |  2 +-
 net/wireless/nl80211.c             | 12 ++++++++----
 9 files changed, 32 insertions(+), 15 deletions(-)

