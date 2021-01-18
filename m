Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFCD2FABDA
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394467AbhARUt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 15:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394384AbhARUsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 15:48:41 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08772C061573;
        Mon, 18 Jan 2021 12:48:01 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l1bRP-008Ocq-BO; Mon, 18 Jan 2021 21:47:59 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2021-01-18.2
Date:   Mon, 18 Jan 2021 21:47:49 +0100
Message-Id: <20210118204750.7243-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

New try, dropped the 160 MHz CSA patch for now that has the sparse
issue since people are waiting for the kernel-doc fixes.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 220efcf9caf755bdf92892afd37484cb6859e0d2:

  Merge tag 'mlx5-fixes-2021-01-07' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2021-01-07 19:13:30 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2021-01-18.2

for you to fetch changes up to c13cf5c159660451c8fbdc37efb998b198e1d305:

  mac80211: check if atf has been disabled in __ieee80211_schedule_txq (2021-01-14 22:27:38 +0100)

----------------------------------------------------------------
Various fixes:
 * kernel-doc parsing fixes
 * incorrect debugfs string checks
 * locking fix in regulatory
 * some encryption-related fixes

----------------------------------------------------------------
Felix Fietkau (3):
      mac80211: fix fast-rx encryption check
      mac80211: fix encryption key selection for 802.3 xmit
      mac80211: do not drop tx nulldata packets on encrypted links

Ilan Peer (1):
      cfg80211: Save the regulatory domain with a lock

Johannes Berg (1):
      cfg80211/mac80211: fix kernel-doc for SAR APIs

Lorenzo Bianconi (1):
      mac80211: check if atf has been disabled in __ieee80211_schedule_txq

Mauro Carvalho Chehab (1):
      cfg80211: fix a kerneldoc markup

Shayne Chen (1):
      mac80211: fix incorrect strlen of .write in debugfs

 include/net/cfg80211.h |  5 ++++-
 include/net/mac80211.h |  1 +
 net/mac80211/debugfs.c | 44 ++++++++++++++++++++------------------------
 net/mac80211/rx.c      |  2 ++
 net/mac80211/tx.c      | 31 +++++++++++++++++--------------
 net/wireless/reg.c     | 11 ++++++++++-
 6 files changed, 54 insertions(+), 40 deletions(-)

