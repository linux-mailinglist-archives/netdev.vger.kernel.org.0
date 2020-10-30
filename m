Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976712A01AF
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 10:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgJ3Jn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 05:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3Jn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 05:43:56 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CE8C0613CF;
        Fri, 30 Oct 2020 02:43:56 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kYQws-00FMfs-Mz; Fri, 30 Oct 2020 10:43:54 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-10-30
Date:   Fri, 30 Oct 2020 10:43:48 +0100
Message-Id: <20201030094349.20847-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Here's a first set of fixes, in particular the nl80211 eapol one
has people waiting for it.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 07e0887302450a62f51dba72df6afb5fabb23d1c:

  Merge tag 'fallthrough-fixes-clang-5.10-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux (2020-10-29 13:02:52 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2020-10-30

for you to fetch changes up to c2f46814521113f6699a74e0a0424cbc5b305479:

  mac80211: don't require VHT elements for HE on 2.4 GHz (2020-10-30 10:22:42 +0100)

----------------------------------------------------------------
A couple of fixes, for
 * HE on 2.4 GHz
 * a few issues syzbot found, but we have many more reports :-(
 * a regression in nl80211-transported EAPOL frames which had
   affected a number of users, from Mathy
 * kernel-doc markings in mac80211, from Mauro
 * a format argument in reg.c, from Ye Bin

----------------------------------------------------------------
Johannes Berg (4):
      mac80211: fix use of skb payload instead of header
      cfg80211: initialize wdev data earlier
      mac80211: always wind down STA state
      mac80211: don't require VHT elements for HE on 2.4 GHz

Mathy Vanhoef (1):
      mac80211: fix regression where EAPOL frames were sent in plaintext

Mauro Carvalho Chehab (1):
      mac80211: fix kernel-doc markups

Ye Bin (1):
      cfg80211: regulatory: Fix inconsistent format argument

 include/net/cfg80211.h  |  9 ++++----
 include/net/mac80211.h  |  7 +++---
 net/mac80211/mlme.c     |  3 ++-
 net/mac80211/sta_info.c | 18 ++++++++++++++++
 net/mac80211/sta_info.h |  9 +++++++-
 net/mac80211/tx.c       | 44 ++++++++++++++++++++++++--------------
 net/wireless/core.c     | 57 +++++++++++++++++++++++++++----------------------
 net/wireless/core.h     |  5 +++--
 net/wireless/nl80211.c  |  3 ++-
 net/wireless/reg.c      |  2 +-
 10 files changed, 102 insertions(+), 55 deletions(-)

