Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D143ACA23
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 13:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbhFRLo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 07:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbhFRLo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 07:44:26 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D975C061574;
        Fri, 18 Jun 2021 04:42:17 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1luCt4-008Tjj-PB; Fri, 18 Jun 2021 13:42:14 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2021-06-18
Date:   Fri, 18 Jun 2021 13:42:10 +0200
Message-Id: <20210618114211.49437-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We've got a few more stragglers for hopefully 5.13, see
the tag message below for more details.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 1c200f832e14420fa770193f9871f4ce2df00d07:

  net: qed: Fix memcpy() overflow of qed_dcbx_params() (2021-06-17 12:14:51 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2021-06-18

for you to fetch changes up to 652e8363bbc7d149fa194a5cbf30b1001c0274b0:

  mac80211: handle various extensible elements correctly (2021-06-18 13:25:49 +0200)

----------------------------------------------------------------
A couple of straggler fixes:
 * a minstrel HT sample check fix
 * peer measurement could double-free on races
 * certificate file generation at build time could
   sometimes hang
 * some parameters weren't reset between connections
   in mac80211
 * some extensible elements were treated as non-
   extensible, possibly causuing bad connections
   (or failures) if the AP adds data

----------------------------------------------------------------
Avraham Stern (1):
      cfg80211: avoid double free of PMSR request

Felix Fietkau (1):
      mac80211: minstrel_ht: fix sample time check

Johannes Berg (3):
      cfg80211: make certificate generation more robust
      mac80211: reset profile_periodicity/ema_ap
      mac80211: handle various extensible elements correctly

 net/mac80211/mlme.c                |  8 ++++++++
 net/mac80211/rc80211_minstrel_ht.c |  2 +-
 net/mac80211/util.c                | 22 +++++++++++-----------
 net/wireless/Makefile              |  2 +-
 net/wireless/pmsr.c                | 16 ++++++++++++++--
 5 files changed, 35 insertions(+), 15 deletions(-)

