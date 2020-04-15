Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814B91A9730
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 10:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894923AbgDOIop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 04:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2894908AbgDOIoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 04:44:37 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999E1C061A0C;
        Wed, 15 Apr 2020 01:44:36 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jOder-001exI-J4; Wed, 15 Apr 2020 10:44:33 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-04-15
Date:   Wed, 15 Apr 2020 10:44:26 +0200
Message-Id: <20200415084427.31107-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

So far we only have a few fixes for wireless, nothing really
that important.

However, over Easter I found an Easter egg in the form of some
netlink validation and the policy export patches that I made
a little more than a year ago (and then evidently forgot about).
I'll send those once you reopen net-next, but wanted to already
say that they will depend on pulling the FTM responder policy
fix into that. Obviously this isn't at all urgent, but for that
I'd appreciate if you could pull net (with this pull request
included) into net-next at some point.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit e154659ba39a1c2be576aaa0a5bda8088d707950:

  mptcp: fix double-unlock in mptcp_poll (2020-04-12 21:04:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2020-04-15

for you to fetch changes up to 93e2d04a1888668183f3fb48666e90b9b31d29e6:

  mac80211: fix channel switch trigger from unknown mesh peer (2020-04-15 09:54:26 +0200)

----------------------------------------------------------------
A couple of fixes:
 * FTM responder policy netlink validation fix
   (but the only user validates again later)
 * kernel-doc fixes
 * a fix for a race in mac80211 radio registration vs. userspace
 * a mesh channel switch fix
 * a fix for a syzbot reported kasprintf() issue

----------------------------------------------------------------
Johannes Berg (1):
      nl80211: fix NL80211_ATTR_FTM_RESPONDER policy

Lothar Rubusch (1):
      cfg80211: fix kernel-doc notation

Sumit Garg (1):
      mac80211: fix race in ieee80211_register_hw()

Tamizh chelvam (1):
      mac80211: fix channel switch trigger from unknown mesh peer

Tuomas Tynkkynen (1):
      mac80211_hwsim: Use kstrndup() in place of kasprintf()

 drivers/net/wireless/mac80211_hwsim.c | 12 ++++++------
 include/net/cfg80211.h                | 10 ++++++++++
 net/mac80211/main.c                   | 24 +++++++++++++-----------
 net/mac80211/mesh.c                   | 11 +++++++----
 net/wireless/nl80211.c                |  6 ++----
 5 files changed, 38 insertions(+), 25 deletions(-)

