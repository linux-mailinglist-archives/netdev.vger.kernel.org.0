Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4504220E1AE
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389943AbgF2U6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731254AbgF2TND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:03 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CFFC02E2F3;
        Mon, 29 Jun 2020 07:27:30 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jpukp-00EEym-98; Mon, 29 Jun 2020 16:27:27 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-06-29
Date:   Mon, 29 Jun 2020 16:27:17 +0200
Message-Id: <20200629142718.31257-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

We've got a couple of fixes here, and I took the liberty to include a
small code cleanup of some really stupid code, and a patch that adds
new AKM suites so we can use them in the drivers more easily.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit eb2932b00fc75a154bb4607773dc0666924116ad:

  Merge branch 'net-bcmgenet-use-hardware-padding-of-runt-frames' (2020-06-24 21:51:03 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2020-06-29

for you to fetch changes up to 60a0121f8fa64b0f4297aa6fef8207500483a874:

  nl80211: fix memory leak when parsing NL80211_ATTR_HE_BSS_COLOR (2020-06-26 11:52:57 +0200)

----------------------------------------------------------------
Couple of fixes/small things:
 * TX control port status check fixed to not assume frame format
 * mesh control port fixes
 * error handling/leak fixes when starting AP, with HE attributes
 * fix broadcast packet handling with encapsulation offload
 * add new AKM suites
 * and a small code cleanup

----------------------------------------------------------------
Luca Coelho (2):
      nl80211: don't return err unconditionally in nl80211_start_ap()
      nl80211: fix memory leak when parsing NL80211_ATTR_HE_BSS_COLOR

Markus Theil (3):
      mac80211: fix control port tx status check
      mac80211: skip mpath lookup also for control port tx
      mac80211: allow rx of mesh eapol frames with default rx key

Pavel Machek (1):
      mac80211: simplify mesh code

Seevalamuthu Mariappan (1):
      mac80211: Fix dropping broadcast packets in 802.11 encap

Veerendranath Jakkam (1):
      ieee80211: Add missing and new AKM suite selector definitions

 include/linux/ieee80211.h |  4 ++++
 net/mac80211/mesh_hwmp.c  |  7 ++-----
 net/mac80211/rx.c         | 26 ++++++++++++++++++++++++++
 net/mac80211/status.c     | 22 +++++++++++++++-------
 net/mac80211/tx.c         |  8 ++++++--
 net/wireless/nl80211.c    |  5 +++--
 6 files changed, 56 insertions(+), 16 deletions(-)

