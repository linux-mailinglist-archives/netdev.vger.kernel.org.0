Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3414A2872A8
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 12:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgJHKmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 06:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgJHKmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 06:42:12 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2720CC061755;
        Thu,  8 Oct 2020 03:42:12 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQTNC-001Xl4-Cg; Thu, 08 Oct 2020 12:42:10 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2020-10-08
Date:   Thu,  8 Oct 2020 12:42:03 +0200
Message-Id: <20201008104204.44106-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

And also a few more patches for net-next, mostly fixes
for the work that recently landed there.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 9faebeb2d80065926dfbc09cb73b1bb7779a89cd:

  Merge branch 'ethtool-allow-dumping-policies-to-user-space' (2020-10-06 06:25:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2020-10-08

for you to fetch changes up to ba6ff70a3bb76c1ff440d3a0044b82e97abb648f:

  mac80211: copy configured beacon tx rate to driver (2020-10-08 12:26:35 +0200)

----------------------------------------------------------------
A handful of changes:
 * fixes for the recent S1G work
 * a docbook build time improvement
 * API to pass beacon rate to lower-level driver

----------------------------------------------------------------
Mauro Carvalho Chehab (1):
      docs: net: 80211: reduce docs build time

Rajkumar Manoharan (1):
      mac80211: copy configured beacon tx rate to driver

Thomas Pedersen (3):
      mac80211: handle lack of sband->bitrates in rates
      mac80211: initialize last_rate for S1G STAs
      cfg80211: only allow S1G channels on S1G band

 Documentation/driver-api/80211/cfg80211.rst        | 392 ++++++---------------
 .../driver-api/80211/mac80211-advanced.rst         | 151 +++-----
 Documentation/driver-api/80211/mac80211.rst        | 148 +++-----
 include/net/mac80211.h                             |   3 +
 net/mac80211/Makefile                              |   1 +
 net/mac80211/cfg.c                                 |   6 +-
 net/mac80211/ieee80211_i.h                         |   3 +
 net/mac80211/mlme.c                                |   4 +-
 net/mac80211/rate.c                                |   1 +
 net/mac80211/s1g.c                                 |  16 +
 net/mac80211/sta_info.c                            |   4 +
 net/mac80211/sta_info.h                            |   1 +
 net/wireless/chan.c                                |   5 +-
 13 files changed, 240 insertions(+), 495 deletions(-)
 create mode 100644 net/mac80211/s1g.c

