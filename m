Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD9D2FAB7F
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389009AbhARKlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 05:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388458AbhARJNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 04:13:34 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADABC0613D3;
        Mon, 18 Jan 2021 01:12:45 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l1QaZ-008B73-Nk; Mon, 18 Jan 2021 10:12:43 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2021-01-18
Date:   Mon, 18 Jan 2021 10:12:34 +0100
Message-Id: <20210118091235.68511-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Here are some fixes for wireless - probably the thing people
have most been waiting for is the kernel-doc fixes :-)

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 220efcf9caf755bdf92892afd37484cb6859e0d2:

  Merge tag 'mlx5-fixes-2021-01-07' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2021-01-07 19:13:30 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2021-01-18

for you to fetch changes up to 8b194febe111c5cc47595749a766d24ca33dd95a:

  mac80211: 160MHz with extended NSS BW in CSA (2021-01-18 09:43:41 +0100)

----------------------------------------------------------------
Various fixes:
 * kernel-doc parsing fixes
 * incorrect debugfs string checks
 * fix for 160 MHz/extended NSS in CSA
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

Shay Bar (1):
      mac80211: 160MHz with extended NSS BW in CSA

Shayne Chen (1):
      mac80211: fix incorrect strlen of .write in debugfs

 include/net/cfg80211.h   |  5 ++++-
 include/net/mac80211.h   |  1 +
 net/mac80211/debugfs.c   | 44 ++++++++++++++++++++------------------------
 net/mac80211/rx.c        |  2 ++
 net/mac80211/spectmgmt.c |  9 ++++++---
 net/mac80211/tx.c        | 31 +++++++++++++++++--------------
 net/wireless/reg.c       | 11 ++++++++++-
 7 files changed, 60 insertions(+), 43 deletions(-)

